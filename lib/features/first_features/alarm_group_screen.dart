import 'package:bazara_optician_app/core/shered_widget/action_button_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class AlarmGroupScreen extends StatefulWidget {
  const AlarmGroupScreen({super.key});

  @override
  State<AlarmGroupScreen> createState() => _AlarmGroupScreenState();
}

class _AlarmGroupScreenState extends State<AlarmGroupScreen> {
  Time _time = Time(hour: 11, minute: 30, second: 20);
  bool iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomAppBar(tital: 'مجموعات التذكير'),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ActionButtonWidget(
                  title: 'إضافة مجموعة',
                  iconPath: 'assets/add.svg',
                  onTap: () {
                    Navigator.of(context).push(
                      showPicker(
                        // showSecondSelector: true,
                        displayHeader: true,
                        context: context,
                        value: _time,
                        onChange: onTimeChanged,
                        minuteInterval: TimePickerInterval.FIVE,
                        // Optional onChange to receive value as DateTime
                        onChangeDateTime: (DateTime dateTime) {
                          // print(dateTime);
                          debugPrint("[debug datetime]:  $dateTime");
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: AppColors.background,
                width: double.infinity,
                child: Text(
                  "${_time.hour}:${_time.minute}:${_time.second} ${_time.period.name}"
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              ActionButtonWidget(
                width: 150,
                title: 'إضافة مجموعة',
                iconPath: 'assets/add.svg',
                onTap: () {
                  Navigator.pushNamed(context, RouteName.ktest);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
