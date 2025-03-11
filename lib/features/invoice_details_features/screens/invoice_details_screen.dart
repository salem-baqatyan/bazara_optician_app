// ignore_for_file: non_constant_identifier_names

import 'package:bazara_optician_app/core/function/shared_function.dart';
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
  final int id;
  final String isDefaultType;
  const InvoiceDetailsScreen({
    super.key,
    required this.id,
    required this.isDefaultType,
  });

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool isEnable = false;
  SqlDb sqlDb = SqlDb();
  List list = [];
  String? isDefaultType;
  int? id;
  late TextEditingController name = TextEditingController(
    text: list[0]['name'],
  );
  late TextEditingController phone = TextEditingController(
    text: list[0]['phone'],
  );
  late TextEditingController invoice_date = TextEditingController(
    text: list[0]['invoice_date'],
  );
  late TextEditingController L_P_D = TextEditingController(
    text: list[0]['L_P_D'],
  );
  late TextEditingController DR = TextEditingController(text: list[0]['DR']);
  late TextEditingController review_date = TextEditingController(
    text: list[0]['review_date'],
  );
  ///////////////////////////////////////////////////
  late TextEditingController frame_type = TextEditingController(
    text: list[0]['frame_type'],
  );
  late TextEditingController frame_model = TextEditingController(
    text: list[0]['frame_model'],
  );
  late TextEditingController total_price = TextEditingController(
    text: list[0]['total_price'],
  );
  late TextEditingController paid_price = TextEditingController(
    text: list[0]['paid_price'],
  );
  late TextEditingController remaining_price = TextEditingController(
    text: list[0]['remaining_price'],
  );
  late TextEditingController delvery_date = TextEditingController(
    text: list[0]['delvery_date'],
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
    id = widget.id;
    isDefaultType = widget.isDefaultType;
    readData();
  }

  Future<void> readData() async {
    if (isDefaultType == "Optometry") {
      list.clear();
      List<Map> response = await sqlDb.readData(
        "SELECT * FROM ClientOptometry WHERE id = $id",
      );
      list.addAll(response);
    } else if (isDefaultType == "Purchases") {
      list.clear();
      List<Map> response = await sqlDb.readData(
        "SELECT * FROM ClientPurchases WHERE id = $id",
      );
      list.addAll(response);
    }
    if (mounted) setState(() {});
  }

  Future updateData() async {
    if (isDefaultType == "Optometry") {
      int response = await sqlDb.updateData('''
      UPDATE ClientOptometry SET
      name ="${name.text}",
      phone ="${phone.text}",
      L_P_D ="${L_P_D.text}",
      DR ="${DR.text}",
      invoice_date ="${invoice_date.text}",
      review_date ="${review_date.text}"

      WHERE id = $id
      ''');

      if (response > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت تعديل فاتورة فحص النظر بنجاح...')),
        );
      }
    } else {
      int response = await sqlDb.updateData('''
      UPDATE ClientPurchases SET
      name ="${name.text}",
      phone ="${phone.text}",
      frame_type ="${frame_type.text}",
      frame_model ="${frame_model.text}",
      total_price ="${total_price.text}",
      paid_price ="${paid_price.text}",
      remaining_price ="${remaining_price.text}",
      invoice_date ="${invoice_date.text}",
      delvery_date ="${delvery_date.text}"

      WHERE id = $id
      ''');

      if (response > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت تعديل فاتورة شراء النظارة بنجاح...'),
          ),
        );
      }
    }
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
              CustomAppBar(
                tital: 'تقرير فاتورة',
                isOptionalButton: true,
                optionalButtonIcon: isEnable ? Icons.edit_off : Icons.edit,
                optionalButtonColor: isEnable ? AppColors.colorButton : null,
                onOptionalButtonTab: () {
                  setState(() {
                    FocusScope.of(context).unfocus();
                    isEnable = !isEnable;
                  });
                },
              ),
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
                                  Image.asset(
                                    'assets/image/icon_store_bill.png',
                                  ),
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
                                              isDefaultType == "Optometry"
                                                  ? 'فاتورة فحص نظر'
                                                  : 'فاتورة شراء نظارة',
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      InfoTextFieldWidget(
                                        title: 'اسم العميل',
                                        controller: name,
                                        keyboardType: TextInputType.text,
                                        isEnable: isEnable,
                                        unRequired: true,
                                      ),
                                      SizedBox(height: 10.h),
                                      InfoTextFieldWidget(
                                        title: 'رقم العميل',
                                        controller: phone,
                                        keyboardType: TextInputType.phone,
                                        isEnable: isEnable,
                                        unRequired: true,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isDefaultType == "Optometry"
                                          ? InvoiceOptometryWidget(
                                            isEnable: isEnable,
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
                                            L_P_D: L_P_D,
                                            DR: DR,
                                            invoice_date: invoice_date,
                                            review_date: review_date,
                                          )
                                          : InvoicePurchasesWidget(
                                            isEnable: isEnable,
                                            onChanged: onChanged,
                                            invoice_date: invoice_date,
                                            frame_type: frame_type,
                                            frame_model: frame_model,
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
                                            delvery_date: delvery_date,
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        isEnable == false
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ActionButtonWidget(
                                  iconPath: Icons.print,
                                  title: 'طباعة PDF',
                                  width: 150.w,
                                  onTap: () async {
                                    await SharedFunction.generatePdf(
                                      screenshotController,
                                    );
                                  },
                                ),

                                ActionButtonWidget(
                                  isSolid: false,
                                  iconPath: Icons.share,
                                  title: 'مشاركة',
                                  width: 150.w,
                                  onTap: () async {
                                    await SharedFunction.generateScreenshot(
                                      screenshotController,
                                    );
                                  },
                                ),
                              ],
                            )
                            : ActionButtonWidget(
                              iconPath: Icons.save,
                              title: 'حفظ التعديل',
                              width: 150.w,
                              onTap: () async {
                                setState(() {
                                  updateData();
                                  isEnable = !isEnable;
                                });
                              },
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
