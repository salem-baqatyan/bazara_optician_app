import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/core/styles/text_style.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomBottomNavigationBarItem> items;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.greyBorder),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                items.asMap().entries.map((entry) {
                  int index = entry.key;
                  CustomBottomNavigationBarItem item = entry.value;
                  bool isSelected = currentIndex == index;

                  return InkWell(
                    onTap: () => onTap(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 70.w,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                item.icon,
                                size: 25.sp,
                                color:
                                    isSelected
                                        ? AppColors.white
                                        : AppColors.primary,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                item.label,
                                textAlign: TextAlign.center,
                                style:
                                    isSelected
                                        ? KTextStyle.textStyle12.copyWith(
                                          color: AppColors.white,
                                        )
                                        : KTextStyle.textStyle12.copyWith(
                                          color: AppColors.greyDark,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBarItem {
  final IconData icon;
  final String label;

  CustomBottomNavigationBarItem({required this.icon, required this.label});
}
