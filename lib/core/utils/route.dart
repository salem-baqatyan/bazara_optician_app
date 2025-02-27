import 'package:bazara_optician_app/features/home_screen.dart';
import 'package:bazara_optician_app/features/invoice_details_features/screens/invoice_details_screen.dart';
// import 'package:bazara_optician_app/features/new_invoice_features/widgets/test.dart';
import 'package:flutter/material.dart';

class RouteName {
  static String khomeScreen = '/';
  static String kInvoiceDetailsScreen = '/invoice_details_screen';
  // static String ktest = '/test';
}

class AppRoute {
  static Route<dynamic> routeApp(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (ctx) => const HomeScreen());

      case '/invoice_details_screen':
        return MaterialPageRoute(
          builder: (ctx) => const InvoiceDetailsScreen(),
          settings: RouteSettings(arguments: routeSettings.arguments),
        );
      // case '/test':
      // return MaterialPageRoute(
      //   builder: (ctx) => const Test(),
      // settings: RouteSettings(arguments: routeSettings.arguments),
      // );

      default:
        return MaterialPageRoute(builder: (ctx) => const HomeScreen());
    }
  }
}
