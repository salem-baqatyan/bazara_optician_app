// ignore_for_file: non_constant_identifier_names

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/core/styles/text_style.dart';

class CustomDropdownButtonWidget extends StatefulWidget {
  final String? lense_type;
  final List<String> lensItems;
  final void Function(String?) onChangedDropdown;

  const CustomDropdownButtonWidget({
    super.key,
    required this.lense_type,
    required this.lensItems,
    required this.onChangedDropdown,
  });

  @override
  State<CustomDropdownButtonWidget> createState() =>
      _CustomDropdownButtonWidgetState();
}

class _CustomDropdownButtonWidgetState
    extends State<CustomDropdownButtonWidget> {
  late String? currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.lense_type;
  }

  @override
  Widget build(BuildContext context) {
    final validItems = widget.lensItems.toSet().toList(); // إزالة التكرارات
    if (currentValue != null && !validItems.contains(currentValue)) {
      currentValue = null;
    }
    return DropdownButton2<String>(
      underline: SizedBox.shrink(),
      isExpanded: true,
      hint: Text(
        'نوع العدسة',
        style: KTextStyle.textStyle12.copyWith(color: AppColors.greyLight),
      ),
      value: currentValue,
      items:
          validItems.map((lens) {
            return DropdownMenuItem(value: lens, child: Text(lens));
          }).toList(),
      onChanged: (value) {
        setState(() {
          currentValue = value;
        });
        widget.onChangedDropdown(value);
      },
      buttonStyleData: ButtonStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyBorder, width: 1.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      dropdownStyleData: const DropdownStyleData(maxHeight: 170),
      menuItemStyleData: const MenuItemStyleData(height: 40),
    );
  }
}
