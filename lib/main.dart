import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_demo/config/firebase_options.dart';
import 'package:health_demo/screen/health_screen.dart';
import 'package:health_demo/singleton/singleton.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff6750a4),
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff6750a4),
      ),
      navigatorKey: Singleton().navigatorKey,
      home: const HealthApp(),
    );
  }
}
