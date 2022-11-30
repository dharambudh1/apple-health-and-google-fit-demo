import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:health_demo/config/health_data_types.dart';
import 'package:health_demo/screen/health_screen.dart';

class HealthDataInsertScreen extends StatefulWidget {
  final Function(dynamic) callback;
  const HealthDataInsertScreen({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<HealthDataInsertScreen> createState() => _HealthDataInsertScreenState();
}

class _HealthDataInsertScreenState extends State<HealthDataInsertScreen> {
  final TextEditingController controller = TextEditingController();
  HealthDataType iosDefaultValue = HealthList.dataTypeKeysIOS.first;
  HealthDataType androidDefaultValue = HealthList.dataTypeKeysAndroid.first;
  final DateTime endDate = DateTime.now();
  final DateTime startDate =
      DateTime.now().subtract(const Duration(minutes: 20));
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add new data"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Select data type"),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    commonDropDown(),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some value';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter value',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      controller: controller,
                      maxLines: 1,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Stat date:"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(startDate.toString()),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("End date:"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(endDate.toString()),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          NavigatorState navState = Navigator.of(context);

                          await widget.callback(
                            [
                              controller.value.text,
                              Platform.isIOS
                                  ? iosDefaultValue
                                  : androidDefaultValue,
                              startDate,
                              endDate,
                            ],
                          );

                          navState.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) {
                                return const HealthApp();
                              },
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text("Add data"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<HealthDataType> myList() {
    return Platform.isIOS
        ? HealthList.dataTypeKeysIOS
        : HealthList.dataTypeKeysAndroid;
  }

  Widget commonDropDown() {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<HealthDataType>(
          isDense: false,
          isExpanded: true,
          value: Platform.isIOS ? iosDefaultValue : androidDefaultValue,
          onChanged: (v) {
            Platform.isIOS
                ? iosDefaultValue = v ?? HealthList.dataTypeKeysIOS.first
                : androidDefaultValue =
                    v ?? HealthList.dataTypeKeysAndroid.first;
            setState(() {});
          },
          items: myList().map(
            (HealthDataType classType) {
              return DropdownMenuItem<HealthDataType>(
                value: classType,
                child: Text(
                  classType.name.capitalize(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
