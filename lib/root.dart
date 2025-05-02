import 'package:flutter/material.dart';
import 'package:optician_app/drawer.dart';
import 'package:optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:optician_app/custom_bottom_navigation_bar.dart';
import 'package:optician_app/features/calendar_dates_features/calender_dates_screen.dart';
import 'package:optician_app/features/main_menu_features/statistics_screen.dart';
import 'package:optician_app/features/new_invoice_features/screens/new_invoice_screen.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String titleAppBar = "الصفحة الرئيسية";

  /// The current index of the selected item or page.
  /// Initialized to 0 by default.
  int myIndex = 1;

  Widget _getCurrentScreen() {
    switch (myIndex) {
      case 0:
        return CalenderDatesScreen(); // هنا يتم إنشاء شاشة جديدة كل مرة
      case 1:
        return StatisticsScreen();
      case 2:
        return NewInvoiceScreen();
      default:
        return StatisticsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: MyDrawer(),
        body: Column(
          children: [
            CustomAppBar(
              tital: titleAppBar,
              isBack: false,
              isOptionalButton: true,
              optionalButtonIcon: Icons.menu,
              onOptionalButtonTab: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  _getCurrentScreen(),
                  if (!isKeyboardOpen)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomBottomNavigationBar(
                        currentIndex: myIndex,
                        onTap: (index) {
                          setState(() {
                            myIndex = index;
                            titleAppBar =
                                index == 0
                                    ? "التحقق من المواعيد"
                                    : index == 1
                                    ? "الصفحة الرئيسية"
                                    : "أضافة فاتورة جديدة";
                          });
                        },
                        items: [
                          CustomBottomNavigationBarItem(
                            icon: Icons.calendar_month,
                            label: 'التقويم',
                          ),
                          CustomBottomNavigationBarItem(
                            icon: Icons.home,
                            label: 'الرئيسية',
                          ),
                          CustomBottomNavigationBarItem(
                            icon: Icons.add_card,
                            label: 'فاتورة',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
