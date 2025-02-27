// ignore_for_file: non_constant_identifier_names

import 'package:bazara_optician_app/core/shered_widget/cell_table_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/cell_text_field_widget.dart';
import 'package:bazara_optician_app/features/new_invoice_features/widgets/info_date_field_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/info_hint_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoicePurchasesWidget extends StatelessWidget {
  final dynamic Function()? onChanged;
  final TextEditingController frame_type;
  final TextEditingController frame_model;

  final TextEditingController R_SPH;
  final TextEditingController R_CYL;
  final TextEditingController R_AXIS;
  final TextEditingController R_ADD;
  final TextEditingController R_CLR;
  final TextEditingController L_SPH;
  final TextEditingController L_CYL;
  final TextEditingController L_AXIS;
  final TextEditingController L_ADD;
  final TextEditingController L_CLR;

  final TextEditingController total_price;
  final TextEditingController paid_price;
  final TextEditingController remaining_price;

  final TextEditingController invoice_date;
  final TextEditingController delvery_date;

  const InvoicePurchasesWidget({
    super.key,
    this.onChanged,
    required this.frame_type,
    required this.frame_model,
    required this.R_SPH,
    required this.R_CYL,
    required this.R_AXIS,
    required this.R_ADD,
    required this.R_CLR,
    required this.L_SPH,
    required this.L_CYL,
    required this.L_AXIS,
    required this.L_ADD,
    required this.L_CLR,
    required this.total_price,
    required this.paid_price,
    required this.remaining_price,
    required this.invoice_date,
    required this.delvery_date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoHintFieldWidget(
                label: 'نوع الفريم',
                controller: frame_type,
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoHintFieldWidget(
                label: 'موديل الفريم',
                controller: frame_model,
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Table(
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                CellTableWidget(text: "CLR", bottom: false),
                CellTableWidget(text: "ADD", right: false, bottom: false),
                CellTableWidget(text: "AXIS", right: false, bottom: false),
                CellTableWidget(text: "CYL", right: false, bottom: false),
                CellTableWidget(text: "SPH", right: false, bottom: false),
                CellTableWidget(text: "", all: false),
              ],
            ),
            TableRow(
              children: [
                CellTextFieldWidget(controller: R_CLR, bottom: false),
                CellTextFieldWidget(
                  controller: R_ADD,
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: R_AXIS,
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: R_CYL,
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: R_SPH,
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(text: "R", right: false, bottom: false),
              ],
            ),
            TableRow(
              children: [
                CellTextFieldWidget(controller: L_SPH),
                CellTextFieldWidget(controller: L_CYL, right: false),
                CellTextFieldWidget(controller: L_AXIS, right: false),
                CellTextFieldWidget(controller: L_ADD, right: false),
                CellTextFieldWidget(controller: L_CLR, right: false),
                CellTableWidget(text: "L", right: false),
              ],
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Expanded(
              child: InfoHintFieldWidget(
                label: 'اجمالي القيمة',
                controller: total_price,
                keyboardType: TextInputType.number,
                onChanged: (value) => onChanged!(),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoHintFieldWidget(
                label: 'المدفوع',
                controller: paid_price,
                keyboardType: TextInputType.number,
                onChanged: (value) => onChanged!(),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoHintFieldWidget(
                label: 'المتبقي',
                controller: remaining_price,
                keyboardType: TextInputType.number,
                isEnable: false, // لا يمكن تعديله يدويًا
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: InfoDateFieldWidget(
                label: 'التاريخ',
                controller: invoice_date,
                isEnable: false,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoDateFieldWidget(
                label: 'موعد التسليم',
                controller: delvery_date,
                isEnable: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
