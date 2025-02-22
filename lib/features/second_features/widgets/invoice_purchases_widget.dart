import 'package:bazara_optician_app/features/second_features/widgets/cell_table_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/cell_text_field_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/info_date_field_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/info_hint_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class InvoicePurchasesWidget extends StatelessWidget {
  const InvoicePurchasesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    DateTime now = DateTime.now();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoHintFieldWidget(
                label: 'نوع الفريم',
                controller: controller,
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoHintFieldWidget(
                label: 'موديل الفريم',
                controller: controller,
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
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
                CellTextFieldWidget(controller: controller, bottom: false),
                CellTextFieldWidget(
                  controller: controller,
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: controller,
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: controller,
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: controller,
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(text: "R", right: false, bottom: false),
              ],
            ),
            TableRow(
              children: [
                CellTextFieldWidget(controller: controller),
                CellTextFieldWidget(controller: controller, right: false),
                CellTextFieldWidget(controller: controller, right: false),
                CellTextFieldWidget(controller: controller, right: false),
                CellTextFieldWidget(controller: controller, right: false),
                CellTableWidget(text: "L", right: false),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: InfoHintFieldWidget(
                label: 'اجمالي القيمة',
                controller: controller,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoHintFieldWidget(
                label: 'المدفوع',
                controller: controller,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoHintFieldWidget(
                label: 'المتبقي',
                controller: controller,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: InfoDateFieldWidget(
                label: 'التاريخ',
                controller: TextEditingController(
                  text: DateFormat('yyyy/MM/dd').format(now),
                ),
                isEnable: false,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoDateFieldWidget(
                label: 'موعد التسليم',
                controller: controller,
                isEnable: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
