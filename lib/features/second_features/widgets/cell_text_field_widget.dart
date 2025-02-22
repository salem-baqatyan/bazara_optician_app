import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CellTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool? top;
  final bool? bottom;
  final bool? right;
  final bool? left;
  final bool? all;
  const CellTextFieldWidget({
    super.key,
    required this.controller,
    this.top = true,
    this.bottom = true,
    this.right = true,
    this.left = true,
    this.all = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
            all == true
                ? Border(
                  top:
                      top == true
                          ? BorderSide()
                          : BorderSide(color: Colors.grey.shade100),
                  bottom:
                      bottom == true
                          ? BorderSide()
                          : BorderSide(color: Colors.grey.shade100),
                  right:
                      right == true
                          ? BorderSide()
                          : BorderSide(color: Colors.grey.shade100),
                  left:
                      left == true
                          ? BorderSide()
                          : BorderSide(color: Colors.grey.shade100),
                )
                : null,
      ),
      padding: EdgeInsets.all(4),
      child: TextFormField(
        controller: controller,
        style: KTextStyle.textStyle13.copyWith(color: AppColors.greyLight),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 15.h),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.greyBorder, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
