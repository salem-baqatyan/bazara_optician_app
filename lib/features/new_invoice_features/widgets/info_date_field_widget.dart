import 'package:bazara_optician_app/core/styles/Colors.dart' show AppColors;
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class InfoDateFieldWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isEnable;

  const InfoDateFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.isEnable,
  });

  @override
  State<InfoDateFieldWidget> createState() => _InfoDateFieldWidgetState();
}

class _InfoDateFieldWidgetState extends State<InfoDateFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          widget.isEnable
              ? () async {
                DateTime? pickeddate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.primary, // Header background color
                          onPrimary: AppColors.white, // Header text color
                          onSurface:
                              AppColors.blackDark, // Text color on the calendar
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                AppColors.blackLight, // Button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickeddate != null) {
                  setState(() {
                    widget.controller.text = DateFormat(
                      'yyyy/MM/dd',
                    ).format(pickeddate);
                  });
                }
              }
              : null,
      child: AbsorbPointer(
        absorbing: true,
        child: SizedBox(
          height: 40.h,
          child: TextFormField(
            readOnly: true,
            keyboardType: TextInputType.datetime,
            controller: widget.controller,
            decoration: InputDecoration(
              label: Text(
                widget.label,
                style: KTextStyle.textStyle13.copyWith(
                  color: AppColors.greyLight,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.calendar_month),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 4.h, // Reduced vertical padding
                horizontal: 4.w, // Reduced horizontal padding
              ),
              prefixIconConstraints: BoxConstraints.tight(Size(40, 40)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.greyBorder, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
