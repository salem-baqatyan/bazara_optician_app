import 'package:bazara_optician_app/core/provider/event_provider.dart';
import 'package:bazara_optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/features/calendar_dates_features/calender_dates_screen.dart';
import 'package:bazara_optician_app/features/customer_reminder_features/customer_reminder_screen.dart';
import 'package:bazara_optician_app/features/invoice_reports_features/invoice_reports_screen.dart';
import 'package:bazara_optician_app/features/main_menu_features/backup.dart';
import 'package:bazara_optician_app/features/main_menu_features/test.dart';
import 'package:bazara_optician_app/features/customers_market_features/customers_market_screen.dart';
import 'package:bazara_optician_app/features/new_invoice_features/screens/new_invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<EventProvider>(context, listen: false).removeOldEvents();

    final List<Map<String, dynamic>> options = [
      {
        "title": 'أضافة فاتورة جديدة',
        "icon": Icons.add_card,
        "page": NewInvoiceScreen(),
      },
      {
        "title": 'التحقق من مواعيد في التقويم',
        "icon": Icons.calendar_month,
        "page": CalenderDatesScreen(),
      },
      {
        "title": 'تسويق الى العملاء',
        "icon": Icons.shopping_cart,
        "page": MarketScreen(),
      },
      {
        "title": 'تذكير العملاء',
        "icon": Icons.mail,
        "page": CustomerReminderScreen(id: 0, isDefaultType: 'Other'),
      },
      {
        "title": 'تقارير الفواتير',
        "icon": Icons.receipt_long,
        "page": InvoiceReportsScreen(),
      },
      {
        "title": 'نسخة الاحتياطية',
        "icon": Icons.backup,
        "page": BackupScreen(),
      },
    ];
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBar(tital: 'القائمة الرئيسية', isBack: false),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundColor: const Color(0xFFF3F4F6),
                                child: Icon(
                                  option["icon"],
                                  size: 24,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            option["title"],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 16.sp,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => option['page'],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
