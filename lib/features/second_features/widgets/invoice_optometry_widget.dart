import 'package:bazara_optician_app/features/second_features/widgets/cell_table_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/cell_text_field_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/info_date_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class InvoiceOptometryWidget extends StatelessWidget {
  const InvoiceOptometryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    DateTime now = DateTime.now();
    int year = now.year;
    int month = 6 + now.month;
    int day = now.day;
    DateTime review_date = DateTime(year, month, day);
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
                CellTableWidget(text: "R", right: false, bottom: false),
                CellTableWidget(text: "Dist.", right: false, bottom: false),
              ],
            ),
            // الصف الثالث: Dist L
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
                CellTableWidget(text: "R", right: false, bottom: false),
                CellTableWidget(text: "Near", right: false, bottom: false),
              ],
            ),
            // الصف الخامس: Near L
            TableRow(
              children: [
                CellTextFieldWidget(controller: controller),
                CellTextFieldWidget(controller: controller, right: false),
                CellTextFieldWidget(controller: controller, right: false),
                CellTextFieldWidget(controller: controller, right: false),
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
                label: 'موعد المراجعة',
                controller: TextEditingController(
                  text: DateFormat('yyyy/MM/dd').format(review_date),
                ),
                isEnable: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
