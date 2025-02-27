import 'package:bazara_optician_app/core/shered_widget/custom_radio_widget.dart';
import 'package:flutter/material.dart';

class TypeViewRadioWidget extends StatelessWidget {
  final String? selectedOption;
  final void Function(String?)? onChangedOptometry;
  final void Function(String?)? onChangedPurchases;
  const TypeViewRadioWidget({
    super.key,
    required this.selectedOption,
    this.onChangedOptometry,
    this.onChangedPurchases,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 2,
          child: CustomRadioWidget(
            title: 'فحص نظر',
            value: 'Optometry',
            selectedOption: selectedOption,
            onChanged: onChangedOptometry,
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 2,
          child: CustomRadioWidget(
            title: 'نظارة جديدة',
            value: 'Purchases',
            selectedOption: selectedOption,
            onChanged: onChangedPurchases,
          ),
        ),
      ],
    );
  }
}
