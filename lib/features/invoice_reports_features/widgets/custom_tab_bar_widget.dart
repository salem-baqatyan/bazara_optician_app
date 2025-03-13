import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBarWidget extends StatelessWidget {
  final List<Widget> tabs;
  final List<Widget> tabViews;
  final int length;
  final Color indicatorColor;
  final double indicatorWeight;
  final Color labelColor;
  final Color unselectedLabelColor;
  final double height;
  final double heightTab;

  // Constants for repeated values
  static const double _borderRadius = 25.0;
  static const double _indicatorPadding = 5.0;
  static const double _sizedBoxHeight = 5.0;

  /// Creates a custom tab bar widget.
  ///
  /// The [tabs] and [tabViews] lists must have the same length.
  /// The [length] parameter must match the number of tabs and tab views.

  const CustomTabBarWidget({
    super.key,
    required this.tabs,
    required this.tabViews,
    required this.length,
    this.indicatorColor = Colors.transparent,
    this.indicatorWeight = 2.0,
    this.labelColor = AppColors.black,
    this.unselectedLabelColor = AppColors.black,
    this.height = 700.0,
    this.heightTab = 65,
  }) : assert(
         tabs.length == tabViews.length,
         'Tabs and TabViews must have the same length',
       ),
       assert(
         length == tabs.length,
         'Length must match the number of tabs and tab views',
       );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.colorButton,
                borderRadius: BorderRadius.circular(25),
              ),
              child: SizedBox(
                height: 55.h,
                child: TabBar(
                  labelStyle: KTextStyle.textStyle16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  dividerColor: Colors.transparent,
                  indicatorColor: indicatorColor,
                  indicatorWeight: indicatorWeight.w,
                  labelColor: labelColor,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                  ), // تقليل المسافة بين العناوين
                  unselectedLabelColor: unselectedLabelColor,
                  tabs: tabs,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_borderRadius.r),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.symmetric(
                    horizontal: _indicatorPadding.h,
                    vertical: _indicatorPadding.w,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: _sizedBoxHeight.h),
          Flexible(
            fit: FlexFit.loose,
            child: SizedBox(
              height: double.infinity,
              child: TabBarView(children: tabViews),
            ),
          ),
        ],
      ),
    );
  }
}
