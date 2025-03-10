import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFromContactsWidget extends StatelessWidget {
  final void Function() onTap;
  const AddFromContactsWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 125.h,
        width: 125.w,
        child: DottedBorder(
          color: AppColors.primary,
          strokeWidth: 1.w,
          dashPattern: [16, 3],
          child: InkWell(
            onTap: onTap,
            child: Container(
              color: AppColors.backgroundColor,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 75.sp, color: AppColors.greenDark),
                    Text(
                      'أضافة من جهات الاتصال',
                      style: KTextStyle.textStyle9.copyWith(
                        color: AppColors.blackDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
