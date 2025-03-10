import 'package:bazara_optician_app/features/customer_reminder_features/customer_reminder_screen.dart';
import 'package:bazara_optician_app/features/home_screen.dart';
import 'package:bazara_optician_app/features/invoice_details_features/screens/invoice_details_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

class NameRouters {
  String khomeScreen = '/';
  String kInvoiceDetailsScreen = '/invoice_details_screen';
  String kCustomerReminderScreen = '/customer_reminder_screen';
}

abstract class AppRouter {
  static const khomeScreen = '/';
  static NameRouters storeRouters = NameRouters();
  static final router = GoRouter(
    routes: [
      // Name Routes
      GoRoute(
        path: AppRouter.storeRouters.khomeScreen,
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: AppRouter.storeRouters.kInvoiceDetailsScreen,
        builder: (context, state) {
          final List<dynamic> args = state.extra as List<dynamic>;
          final int id = args[0];
          final String isDefaultType = args[1];
          return InvoiceDetailsScreen(id: id, isDefaultType: isDefaultType);
        },
      ),

      GoRoute(
        path: AppRouter.storeRouters.kCustomerReminderScreen,
        builder: (context, state) {
          final List<dynamic> args = state.extra as List<dynamic>;
          final int id = args[0];
          final String isDefaultType = args[1];

          return CustomerReminderScreen(id: id, isDefaultType: isDefaultType);
        },
      ),
    ],
  );
}
