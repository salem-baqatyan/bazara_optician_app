import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:bazara_optician_app/features/second_features/widgets/info_date_field_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/info_hint_field_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/info_text_field_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/invoice_optometry_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/invoice_purchases_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class InvoiceBodyWidget extends StatelessWidget {
  final bool isDefaultValue;
  final int discountRate;
  final int numberToBuy;
  final int numberToGet;
  final void Function(int) onDiscountRateChanged;
  final void Function(int) onNumberToBuyChanged;
  final void Function(int) onNumberToGetChanged;
  const InvoiceBodyWidget({
    super.key,
    required this.isDefaultValue,
    required this.discountRate,
    required this.numberToBuy,
    required this.numberToGet,
    required this.onDiscountRateChanged,
    required this.onNumberToBuyChanged,
    required this.onNumberToGetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(
          title: isDefaultValue ? 'كليشة فحص نظر' : 'كليشة شراء نظارة',
        ),
        SizedBox(height: 20.h),
        isDefaultValue ? InvoiceOptometryWidget() : InvoicePurchasesWidget(),
      ],
    );
  }
}
