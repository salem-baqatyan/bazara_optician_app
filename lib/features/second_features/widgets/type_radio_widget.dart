import 'package:bazara_optician_app/features/second_features/widgets/custom_radio_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypeRadioWidget extends StatelessWidget {
  final String? selectedOption;
  final void Function(String?)? onChangedDiscount;
  final void Function(String?)? onChangedBouns;
  const TypeRadioWidget({
    super.key,
    required this.selectedOption,
    this.onChangedDiscount,
    this.onChangedBouns,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(title: 'طلب العميل'),
        SizedBox(height: 10.h),
        CustomRadioWidget(
          title: 'فحص نظر',
          value: 'Optometry',
          selectedOption: selectedOption,
          onChanged: onChangedDiscount,
        ),
        CustomRadioWidget(
          title: 'نظارة جديدة',
          value: 'Purchases',
          selectedOption: selectedOption,
          onChanged: onChangedBouns,
        ),
      ],
    );
  }
}
