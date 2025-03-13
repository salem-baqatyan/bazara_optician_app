import 'package:optician_app/core/shered_widget/required_text.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoTextFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool? isEnable;
  final bool? unRequired;

  const InfoTextFieldWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.keyboardType,
    this.isEnable = true,
    this.unRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RequiredText(title: title, unRequired: unRequired),
        SizedBox(width: 10.w),
        Expanded(
          child: AbsorbPointer(
            absorbing: isEnable == true ? false : true,
            child: SizedBox(
              height: 40.h,
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: 10.w, bottom: 15.h),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.greyBorder,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
