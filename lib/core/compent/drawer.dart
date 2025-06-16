import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optician_app/core/shered_widget/drawer_tile_widget.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/features/clients_features/clients_screen.dart';
import 'package:optician_app/features/customer_reminder_features/customer_reminder_screen.dart';
import 'package:optician_app/features/customers_market_features/customers_market_screen.dart';
import 'package:optician_app/features/default_settings_features/default_settings_screen.dart';
import 'package:optician_app/features/invoice_reports_features/screens/invoice_reports_screen.dart';
import 'package:optician_app/features/main_menu_features/backup.dart';
import 'package:optician_app/features/main_menu_features/testo.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.w,
      child: Container(
        color: AppColors.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            DrawerHeader(
              padding: EdgeInsets.all(7.5),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: AppColors.greyBorder),
                    ),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        'assets/image/icon_store_bill.png',
                      ),
                    ),
                  ),
                  Container(
                    height: 25.h,
                    width: 150.w,
                    alignment: Alignment.center,
                    child: Text(
                      'بازرعة للنظارات',
                      style: TextStyle(
                        fontSize: 17.5.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackLight,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            DrawerTile(
              title: 'تقارير الفواتير',
              leading: const Icon(Icons.receipt_long, color: AppColors.primary),
              ontap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InvoiceReportsScreen(),
                  ),
                );
              },
            ),
            DrawerTile(
              title: 'العملاء',
              leading: const Icon(Icons.settings, color: AppColors.primary),
              ontap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientsScreen()),
                );
              },
            ),
            DrawerTile(
              title: 'التذكيرات',
              leading: const Icon(Icons.mail, color: AppColors.primary),
              ontap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CustomerReminderScreen(
                          id: 0,
                          isDefaultType: 'Other',
                        ),
                  ),
                );
              },
            ),
            DrawerTile(
              title: 'تسويق الى العملاء',
              leading: const Icon(
                Icons.shopping_cart,
                color: AppColors.primary,
              ),
              ontap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MarketScreen()),
                );
              },
            ),
            DrawerTile(
              title: 'نسخة الاحتياطية',
              leading: const Icon(Icons.backup, color: AppColors.primary),
              ontap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BackupScreen()),
                );
              },
            ),
            DrawerTile(
              title: 'الاعداد الافتراضي',
              leading: const Icon(Icons.settings, color: AppColors.primary),
              ontap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DefaultSettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
