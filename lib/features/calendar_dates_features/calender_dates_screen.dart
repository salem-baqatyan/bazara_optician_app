import 'package:optician_app/core/provider/event_provider.dart';
import 'package:optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/core/styles/text_style.dart';
import 'package:optician_app/core/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderDatesScreen extends StatefulWidget {
  final DateTime? focusedDay;
  const CalenderDatesScreen({super.key, this.focusedDay});

  @override
  State<CalenderDatesScreen> createState() => _CalenderDatesScreenState();
}

class _CalenderDatesScreenState extends State<CalenderDatesScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _selectedEvents = [];
  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay ?? DateTime.now(); // <-- أولاً
    _selectedDay = DateUtils.dateOnly(_focusedDay); // <-- ثانياً
    // تحميل الأحداث بعد بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedEvents(_selectedDay!, _focusedDay);
    });
  }

  // دالة تحديث قائمة الأحداث المختارة
  void _updateSelectedEvents(DateTime selectedDay, DateTime focusedDay) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventProvider.loadEvents().then((_) {
      setState(() {
        _selectedDay = DateUtils.dateOnly(selectedDay);
        _focusedDay = focusedDay;
        _selectedEvents = eventProvider.events[_selectedDay] ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TableCalendar(
              weekendDays: [DateTime.saturday, DateTime.friday],
              startingDayOfWeek: StartingDayOfWeek.saturday,
              daysOfWeekHeight: 50.h,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: KTextStyle.textStyle13.copyWith(
                  color: AppColors.primary,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: KTextStyle.textStyle20.copyWith(
                  color: AppColors.blackDark,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  size: 30.sp,
                  color: AppColors.primary,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  size: 30.sp,
                  color: AppColors.primary,
                ),
              ),
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: KTextStyle.textStyle14.copyWith(
                  color: AppColors.blackDark,
                ),
                selectedTextStyle: KTextStyle.textStyle16.copyWith(
                  color: AppColors.primary,
                ),

                selectedDecoration: BoxDecoration(
                  color: const Color.fromARGB(60, 255, 117, 107),
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(10.r),
                ),
                todayTextStyle: KTextStyle.textStyle16.copyWith(
                  color: AppColors.blackDark,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
              ),
              focusedDay: _focusedDay,
              firstDay: DateTime(1900),
              lastDay: DateTime(2100),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) {
                DateTime normalizedDay = DateUtils.dateOnly(day);
                return events[normalizedDay] ?? [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                _updateSelectedEvents(selectedDay, focusedDay);
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child:
                  _selectedEvents.isEmpty
                      ? Center(
                        child: Text(
                          "لا توجد أحداث لهذا اليوم",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _selectedEvents.length,
                        itemBuilder: (context, index) {
                          final event = _selectedEvents[index];
                          final String rawDate = event['date'].replaceAll(
                            '/',
                            '-',
                          ); // تصحيح الصيغة
                          final DateTime eventDate = DateTime.parse(rawDate);

                          // جعل اليوم يبدأ من منتصف الليل
                          final DateTime today = DateTime.now();
                          final DateTime nowAtMidnight = DateTime(
                            today.year,
                            today.month,
                            today.day,
                          );

                          // الفرق بالأيام
                          final Duration difference = eventDate.difference(
                            nowAtMidnight,
                          );
                          final int daysLeft = difference.inDays;

                          String remainingText;

                          if (daysLeft < 0) {
                            remainingText = "انتهى الحدث";
                          } else if (daysLeft == 0) {
                            remainingText = "اليوم هو موعد الحدث";
                          } else if (daysLeft == 1) {
                            remainingText = "باقي يوم";
                          } else if (daysLeft == 2) {
                            remainingText = "باقي يومان";
                          } else if (daysLeft <= 30) {
                            remainingText = "باقي $daysLeft أيام";
                          } else {
                            int monthsLeft =
                                (daysLeft / 30)
                                    .floor(); // كل 30 يوم تقريباً شهر

                            if (monthsLeft == 1) {
                              remainingText = "باقي شهر";
                            } else if (monthsLeft == 2) {
                              remainingText = "باقي شهران";
                            } else {
                              remainingText = "باقي $monthsLeft أشهر";
                            }
                          }
                          return InkWell(
                            onTap: () {
                              debugPrint(
                                "Navigating with id: ${event['id']} and isDefaultValue: ${event['type'] == "Optometry"}",
                              );
                              context.push(
                                AppRouter.nameRouters.kCustomerReminderScreen,
                                extra: [
                                  event['id'],
                                  event['type'] == "Optometry"
                                      ? 'Optometry'
                                      : 'Purchases',
                                ],
                              );
                              print(
                                '${event['id']} ${event['type'] == "Optometry" ? 'Optometry' : 'Purchases'}',
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient:
                                      event['type'] == "Optometry"
                                          ? LinearGradient(
                                            colors: [
                                              Colors.purple.shade300,
                                              Colors.purple.shade700,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                          : LinearGradient(
                                            colors: [
                                              Colors.green.shade300,
                                              Colors.green.shade700,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ), // لجعل الزوايا مستديرة
                                ),
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        event['type'] == "Optometry"
                                            ? "فحص نظر 🔬"
                                            : "شراء نظارة 👓",
                                        style: KTextStyle.textStyle14.copyWith(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    event['name'],
                                    style: KTextStyle.textStyle14.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    remainingText,
                                    style: KTextStyle.textStyle14.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }
}
