// ignore_for_file: non_constant_identifier_names

import 'package:bazara_optician_app/features/invoice_details_features/widgets/info_disable_field_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/cell_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceOptometryWidget extends StatelessWidget {
  final bool? isEnable;
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
    this.isEnable,
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
                CellTableWidget(
                  text: dist_R_V_A.text, //dist_L_V_A
                  bottom: false,
                ),
                CellTableWidget(
                  text: dist_R_AXIS.text, //dist_R_AXIS
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(
                  text: dist_R_CYL.text, //dist_R_CYL
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(
                  text: dist_R_SPH.text, //dist_R_SPH
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
                CellTableWidget(
                  text: dist_L_V_A.text, //dist_L_V_A
                  bottom: false,
                ),
                CellTableWidget(
                  text: dist_L_AXIS.text, //dist_L_AXIS
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(
                  text: dist_L_CYL.text, //dist_L_CYL
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(
                  text: dist_L_SPH.text, //dist_L_SPH
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
                CellTableWidget(
                  text: near_R_V_A.text, //near_R_V_A
                  bottom: false,
                ),
                CellTableWidget(
                  text: near_R_AXIS.text, //near_R_AXIS
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(
                  text: near_R_CYL.text, //near_R_CYL
                  right: false,
                  bottom: false,
                ),
                CellTableWidget(
                  text: near_R_SPH.text, //near_R_SPH
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
                CellTableWidget(text: near_L_V_A.text), //near_L_V_A
                CellTableWidget(
                  text: near_L_AXIS.text, //near_L_AXIS
                  right: false,
                ),
                CellTableWidget(
                  text: near_L_CYL.text, //near_L_CYL
                  right: false,
                ),
                CellTableWidget(
                  text: near_L_SPH.text, //near_L_SPH
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
              child: InfoDisableFieldWidget(
                label: 'L.P.D',
                controller: L_P_D, //L_P_D
                isEnable: isEnable,
                isDate: false,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoDisableFieldWidget(
                label: 'DR',
                controller: DR, //DR
                isEnable: isEnable,
                isDate: false,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: InfoDisableFieldWidget(
                label: 'التاريخ',
                controller: invoice_date,
                isEnable: isEnable,
                isDate: isEnable,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InfoDisableFieldWidget(
                label: 'موعد المراجعة',
                controller: review_date,
                isEnable: isEnable,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
