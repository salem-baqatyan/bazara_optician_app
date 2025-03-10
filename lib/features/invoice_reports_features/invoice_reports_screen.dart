import 'package:bazara_optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:bazara_optician_app/features/invoice_reports_features/custom_tab_bar_widget.dart';
import 'package:bazara_optician_app/features/invoice_reports_features/reports_optometry_widget.dart';
import 'package:bazara_optician_app/features/invoice_reports_features/reports_purchases_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceReportsScreen extends StatefulWidget {
  const InvoiceReportsScreen({super.key});

  @override
  State<InvoiceReportsScreen> createState() => _InvoiceReportsScreenState();
}

class _InvoiceReportsScreenState extends State<InvoiceReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              CustomAppBar(tital: 'تقارير الفواتير'),
              const SizedBox(height: 5),
              Expanded(
                child: CustomTabBarWidget(
                  length: 2,
                  tabs: [
                    Tab(child: Text('فحص نظر', style: KTextStyle.textStyle16)),
                    Tab(
                      child: Text('نظارة جديدة', style: KTextStyle.textStyle16),
                    ),
                  ],
                  tabViews: const [
                    ReportsOptometryWidget(),
                    ReportsPurchasesWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
