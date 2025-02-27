// ignore_for_file: non_constant_identifier_names

import 'package:bazara_optician_app/core/function/pdf_function.dart';
import 'package:bazara_optician_app/core/shered_widget/action_button_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:bazara_optician_app/core/shered_widget/info_text_field_widget.dart';
import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:bazara_optician_app/features/invoice_details_features/widgets/invoice_optometry_view_widget.dart';
import 'package:bazara_optician_app/features/invoice_details_features/widgets/invoice_purchases_view_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/section_title_widget.dart';
import 'package:bazara_optician_app/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({super.key});

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  SqlDb sqlDb = SqlDb();
  List list = [];
  bool? isDefaultValue;
  int? id;
  late TextEditingController total_price = TextEditingController(
    text: list[0]['total_price'],
  );
  late TextEditingController paid_price = TextEditingController(
    text: list[0]['paid_price'],
  );
  late TextEditingController remaining_price = TextEditingController(
    text: list[0]['remaining_price'],
  );

  void onChanged() {
    double total = double.tryParse(total_price.text) ?? 0;
    double paid = double.tryParse(paid_price.text) ?? 0;

    if (paid > total) {
      paid = total;
      paid_price.text = total.toStringAsFixed(0); // إعادة ضبط المدفوع
    }

    double remaining = total - paid;
    setState(() {
      remaining_price.text = remaining.toStringAsFixed(0);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null) {
        setState(() {
          id = args['id'];
          isDefaultValue = args['isDefaultValue'];
        });
        readData();
      }
    });
  }

  Future<void> readData() async {
    if (isDefaultValue == true) {
      list.clear();
      List<Map> response = await sqlDb.readData(
        "SELECT * FROM ClientOptometry WHERE id = $id",
      );
      list.addAll(response);
    } else {
      list.clear();
      List<Map> response = await sqlDb.readData(
        "SELECT * FROM ClientPurchases WHERE id = $id",
      );
      list.addAll(response);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(tital: 'تقرير فاتورة'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Screenshot(
                          controller: screenshotController,
                          child: Container(
                            width: double.maxFinite,
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: SectionTitleWidget(
                                          style: KTextStyle.textStyle20
                                              .copyWith(
                                                color: AppColors.blackLight,
                                              ),
                                          title:
                                              isDefaultValue == true
                                                  ? 'كليشة فحص نظر'
                                                  : 'كليشة شراء نظارة',
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      InfoTextFieldWidget(
                                        title: 'اسم العميل',
                                        controller: TextEditingController(
                                          text: list[0]['name'],
                                        ),
                                        keyboardType: TextInputType.text,
                                        isEnable: false,
                                        unRequired: true,
                                      ),
                                      SizedBox(height: 10.h),
                                      InfoTextFieldWidget(
                                        title: 'رقم العميل',
                                        controller: TextEditingController(
                                          text: list[0]['phone'],
                                        ),
                                        keyboardType: TextInputType.phone,
                                        isEnable: false,
                                        unRequired: true,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isDefaultValue == true
                                          ? InvoiceOptometryWidget(
                                            dist_R_SPH: TextEditingController(
                                              text: list[0]['dist_R_SPH'],
                                            ),
                                            dist_R_CYL: TextEditingController(
                                              text: list[0]['dist_R_CYL'],
                                            ),
                                            dist_R_AXIS: TextEditingController(
                                              text: list[0]['dist_R_AXIS'],
                                            ),
                                            dist_R_V_A: TextEditingController(
                                              text: list[0]['dist_R_V_A'],
                                            ),
                                            dist_L_SPH: TextEditingController(
                                              text: list[0]['dist_L_SPH'],
                                            ),
                                            dist_L_CYL: TextEditingController(
                                              text: list[0]['dist_L_CYL'],
                                            ),
                                            dist_L_AXIS: TextEditingController(
                                              text: list[0]['dist_L_AXIS'],
                                            ),
                                            dist_L_V_A: TextEditingController(
                                              text: list[0]['dist_L_V_A'],
                                            ),
                                            near_R_SPH: TextEditingController(
                                              text: list[0]['near_R_SPH'],
                                            ),
                                            near_R_CYL: TextEditingController(
                                              text: list[0]['near_R_CYL'],
                                            ),
                                            near_R_AXIS: TextEditingController(
                                              text: list[0]['near_R_AXIS'],
                                            ),
                                            near_R_V_A: TextEditingController(
                                              text: list[0]['near_R_V_A'],
                                            ),
                                            near_L_SPH: TextEditingController(
                                              text: list[0]['near_L_SPH'],
                                            ),
                                            near_L_CYL: TextEditingController(
                                              text: list[0]['near_L_CYL'],
                                            ),
                                            near_L_AXIS: TextEditingController(
                                              text: list[0]['near_L_AXIS'],
                                            ),
                                            near_L_V_A: TextEditingController(
                                              text: list[0]['near_L_V_A'],
                                            ),
                                            L_P_D: TextEditingController(
                                              text: list[0]['L_P_D'],
                                            ),
                                            DR: TextEditingController(
                                              text: list[0]['DR'],
                                            ),
                                            invoice_date: TextEditingController(
                                              text: list[0]['invoice_date'],
                                            ),
                                            review_date: TextEditingController(
                                              text: list[0]['review_date'],
                                            ),
                                          )
                                          : InvoicePurchasesWidget(
                                            onChanged: onChanged,
                                            invoice_date: TextEditingController(
                                              text: list[0]['invoice_date'],
                                            ),
                                            frame_type: TextEditingController(
                                              text: list[0]['frame_type'],
                                            ),
                                            frame_model: TextEditingController(
                                              text: list[0]['frame_model'],
                                            ),
                                            R_SPH: TextEditingController(
                                              text: list[0]['R_SPH'],
                                            ),
                                            R_CYL: TextEditingController(
                                              text: list[0]['R_CYL'],
                                            ),
                                            R_AXIS: TextEditingController(
                                              text: list[0]['R_AXIS'],
                                            ),
                                            R_ADD: TextEditingController(
                                              text: list[0]['R_ADD'],
                                            ),
                                            R_CLR: TextEditingController(
                                              text: list[0]['R_CLR'],
                                            ),
                                            L_SPH: TextEditingController(
                                              text: list[0]['L_SPH'],
                                            ),
                                            L_CYL: TextEditingController(
                                              text: list[0]['L_CYL'],
                                            ),
                                            L_AXIS: TextEditingController(
                                              text: list[0]['L_AXIS'],
                                            ),
                                            L_ADD: TextEditingController(
                                              text: list[0]['L_ADD'],
                                            ),
                                            L_CLR: TextEditingController(
                                              text: list[0]['L_CLR'],
                                            ),
                                            total_price: total_price,
                                            paid_price: paid_price,
                                            remaining_price: remaining_price,
                                            delvery_date: TextEditingController(
                                              text: list[0]['delvery_date'],
                                            ),
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ActionButtonWidget(
                              iconPath: Icons.print,
                              title: 'حفظ وطباعة PDF',
                              width: 150.w,
                              onTap: () async {
                                await PdfFunction.generatePdf(
                                  screenshotController,
                                );
                              },
                            ),
                            ActionButtonWidget(
                              isSolid: false,
                              iconPath: Icons.share,
                              title: 'مشاركة',
                              width: 150.w,
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
