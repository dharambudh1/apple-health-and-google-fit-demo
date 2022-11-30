import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:health_demo/screen/health_data_insert.dart';
import 'package:health_demo/config/health_data_types.dart';
import 'package:health_demo/screen/list_adapter.dart';
import 'package:health_demo/singleton/singleton.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthApp extends StatefulWidget {
  const HealthApp({Key? key}) : super(key: key);

  @override
  HealthAppState createState() => HealthAppState();
}

class HealthAppState extends State<HealthApp>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final HealthFactory _health = HealthFactory();
  late final TabController _tabController;

  List<HealthDataPoint> _healthDataList = [];

  List<HealthDataType> currentList = Platform.isIOS
      ? HealthList.dataTypeKeysIOS
      : HealthList.dataTypeKeysAndroid;

  ScaffoldMessengerState state = ScaffoldMessenger.of(
    Singleton().navigatorKey.currentContext!,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: currentList.length, vsync: this);
    showDialog();
  }

  Future<void> showDialog() async {
    bool hasPermissionToShowData = await askPermission();
    hasPermissionToShowData
        ? init()
        : log('hasPermissionToShowData $hasPermissionToShowData');
    return Future.value();
  }

  Future<void> init() async {
    await fetchAllData();
    return Future.value();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add_circle_outline,
            size: 24,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HealthDataInsertScreen(
                    callback: (value) async {
                      await valueInsert(value);
                    },
                  );
                },
              ),
            );
          },
        ),
        appBar: AppBar(
          title: const Text('Health Example'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: tabBar(),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: tabView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  Future<bool> askPermission() async {
    Map<Permission, PermissionStatus> permStatus;

    if (Platform.isAndroid) {
      permStatus = await [
        Permission.activityRecognition,
        Permission.location,
        Permission.sensors,
      ].request();
    } else {
      permStatus = await [
        Permission.sensors,
      ].request();
    }

    return Future.value(permStatus.containsValue(PermissionStatus.granted));
  }

  Future<void> fetchAllData() async {
    bool requested = await _health.requestAuthorization(currentList);
    if (requested) {
      try {
        List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
          DateTime.now().subtract(const Duration(days: 5)),
          DateTime.now(),
          currentList,
        );
        _healthDataList.addAll(
          (healthData.length < 100) ? healthData : healthData.sublist(0, 100),
        );
        _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
        if (mounted) setState(() {});
      } catch (error) {
        log('Exception in getHealthDataFromTypes: $error');
      }
    } else {
      log('requestAuthorization has been failed');
    }
    return Future.value();
  }

  Future<void> insertDataFunction({
    required double value,
    required HealthDataType type,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    bool permission = false;
    if (type == HealthDataType.HIGH_HEART_RATE_EVENT ||
        type == HealthDataType.LOW_HEART_RATE_EVENT ||
        type == HealthDataType.IRREGULAR_HEART_RATE_EVENT) {
      state.showSnackBar(
        SnackBar(
          content: Text(
            "$type - iOS doesn't support writing this data type in HealthKit",
          ),
        ),
      );
      return Future.value();
    }
    permission = await HealthFactory.hasPermissions(
          [type],
          permissions: [HealthDataAccess.WRITE],
        ) ??
        false;
    permission = await _health.requestAuthorization(
      [type],
      permissions: [HealthDataAccess.READ_WRITE],
    );
    if (permission) {
      try {
        await _health.writeHealthData(value, type, startTime, endTime);
        state.showSnackBar(
          const SnackBar(
            content: Text('Data added successfully.'),
          ),
        );
        init();
      } catch (error) {
        state.showSnackBar(
          SnackBar(
            content: Text('Exception in getHealthDataFromTypes: $error'),
          ),
        );
      }
    } else {
      state.showSnackBar(
        const SnackBar(
          content: Text('Permission request has been denied.'),
        ),
      );
    }
    return Future.value();
  }

  Future<void> valueInsert(dynamic result) async {
    if (result is List) {
      List temp = result;
      await insertDataFunction(
        value: double.tryParse(temp[0]) ?? 0,
        type: temp[1],
        startTime: temp[2],
        endTime: temp[3],
      );
    }
    return Future.value();
  }

  List<Tab> tabBar() {
    List<Tab> tabs = [];
    for (var i = 0; i < currentList.length; i++) {
      tabs.add(
        Tab(
          text: Platform.isIOS
              ? HealthList.dataTypeKeysIOS[i].name.capitalize()
              : HealthList.dataTypeKeysAndroid[i].name.capitalize(),
        ),
      );
    }
    return tabs;
  }

  List<Widget> tabView() {
    List<Widget> tabs = [];
    for (var i = 0; i < currentList.length; i++) {
      tabs.add(
        RefreshIndicator(
          onRefresh: init,
          child: ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: _healthDataList.length,
            itemBuilder: (_, index) {
              HealthDataPoint healthDataPoint = _healthDataList[index];
              return ListAdapter(
                list: currentList,
                indexOfLoop: i,
                healthDataPoint: healthDataPoint,
              );
            },
          ),
        ),
      );
    }
    return tabs;
  }
}

extension StringExtension on String {
  String capitalize() {
    String temp = "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    return temp.replaceAll("_", " ");
  }
}
