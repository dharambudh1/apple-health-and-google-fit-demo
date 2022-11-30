import 'package:flutter/material.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

}