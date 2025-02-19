import 'package:bazara_optician_app/features/home_screen.dart';
import 'package:bazara_optician_app/features/second_features/test.dart';
import 'package:flutter/material.dart';

class RouteName {
  static String khomeScreen = '/';
  static String ktest = '/test';
}

class AppRoute {
  static Route<dynamic> routeApp(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (ctx) => const HomeScreen());
      case '/test':
        return MaterialPageRoute(
          builder: (ctx) => const Test(),
          // settings: RouteSettings(arguments: routeSettings.arguments),
        );
      default:
        return MaterialPageRoute(builder: (ctx) => const HomeScreen());
    }
  }
}
