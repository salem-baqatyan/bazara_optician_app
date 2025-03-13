// ignore_for_file: non_constant_identifier_names

import 'package:optician_app/core/shered_widget/cell_table_widget.dart';
import 'package:optician_app/core/shered_widget/cell_text_field_widget.dart';
import 'package:optician_app/features/new_invoice_features/widgets/info_date_field_widget.dart';
import 'package:optician_app/core/shered_widget/info_hint_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceOptometryWidget extends StatelessWidget {
  final TextEditingController invoice_date;
  final TextEditingController review_date;

  final TextEditingController dist_R_SPH;
  final TextEditingController dist_R_CYL;
  final TextEditingController dist_R_AXIS;
  final TextEditingController dist_R_V_A;
  final TextEditingController dist_L_SPH;
  final TextEditingController dist_L_CYL;
  final TextEditingController dist_L_AXIS;
  final TextEditingController dist_L_V_A;

  final TextEditingController near_R_SPH;
  final TextEditingController near_R_CYL;
  final TextEditingController near_R_AXIS;
  final TextEditingController near_R_V_A;
  final TextEditingController near_L_SPH;
  final TextEditingController near_L_CYL;
  final TextEditingController near_L_AXIS;
  final TextEditingController near_L_V_A;

  final TextEditingController L_P_D;
  final TextEditingController DR;
  const InvoiceOptometryWidget({
    super.key,
    required this.invoice_date,
    required this.review_date,
    required this.dist_R_SPH,
    required this.dist_R_CYL,
    required this.dist_R_AXIS,
    required this.dist_R_V_A,
    required this.dist_L_SPH,
    required this.dist_L_CYL,
    required this.dist_L_AXIS,
    required this.dist_L_V_A,
    required this.near_R_SPH,
    required this.near_R_CYL,
    required this.near_R_AXIS,
    required this.near_R_V_A,
    required this.near_L_SPH,
    required this.near_L_CYL,
    required this.near_L_AXIS,
    required this.near_L_V_A,
    required this.L_P_D,
    required this.DR,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            // الصف الأول: العناوين
            TableRow(
              decoration: BoxDecoration(color: Colors.white),
              children: [
                CellTableWidget(text: "V.A", bottom: false),
                CellTableWidget(text: "Axis", right: false, bottom: false),
                CellTableWidget(text: "Cyl.", right: false, bottom: false),
                CellTableWidget(text: "Sph.", right: false, bottom: false),
                CellTableWidget(text: "", all: false),
                CellTableWidget(text: "", all: false),
              ],
            ),
            // الصف الثاني: Dist R
            TableRow(
              children: [
                CellTextFieldWidget(
                  controller: dist_R_V_A, //dist_L_V_A
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: dist_R_AXIS, //dist_R_AXIS
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: dist_R_CYL, //dist_R_CYL
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: dist_R_SPH, //dist_R_SPH
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(text: "R", right: false, bottom: false),
                CellTableWidget(text: "Dist.", right: false, bottom: false),
              ],
            ),
            // الصف الثالث: Dist L
            TableRow(
              children: [
                CellTextFieldWidget(
                  controller: dist_L_V_A, //dist_L_V_A
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: dist_L_AXIS, //dist_L_AXIS
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: dist_L_CYL, //dist_L_CYL
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: dist_L_SPH, //dist_L_SPH
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(text: "L", right: false, bottom: false),
                CellTableWidget(
                  text: "",
                  right: false,
                  bottom: false,
                  top: false,
                ),
              ],
            ),
            // الصف الرابع: Near R
            TableRow(
              children: [
                CellTextFieldWidget(
                  controller: near_R_V_A, //near_R_V_A
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: near_R_AXIS, //near_R_AXIS
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: near_R_CYL, //near_R_CYL
                  right: false,
                  bottom: false,
                ),
                CellTextFieldWidget(
                  controller: near_R_SPH, //near_R_SPH
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(text: "R", right: false, bottom: false),
                CellTableWidget(text: "Near", right: false, bottom: false),
              ],
            ),
            // الصف الخامس: Near L
            TableRow(
              children: [
                CellTextFieldWidget(controller: near_L_V_A), //near_L_V_A
                CellTextFieldWidget(
                  controller: near_L_AXIS, //near_L_AXIS
                  right: false,
                ),
                CellTextFieldWidget(
                  controller: near_L_CYL, //near_L_CYL
                  right: false,
                ),
                CellTextFieldWidget(
                  controller: near_L_SPH, //near_L_SPH
                  right: false,
                ),
                CellTableWidget(text: "L", right: false),
                CellTableWidget(text: "", right: false, top: false),
              ],
            ),
          ],
        ),

        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: InfoHintFieldWidget(
                label: 'L.P.D',
                controller: L_P_D, //L_P_D
                keyboardType: TextInputType.phone,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoHintFieldWidget(
                label: 'DR',
                controller: DR, //DR
                keyboardType: TextInputType.text,
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
                controller: invoice_date,
                isEnable: false,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoDateFieldWidget(
                label: 'موعد المراجعة',
                controller: review_date,
                isEnable: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
