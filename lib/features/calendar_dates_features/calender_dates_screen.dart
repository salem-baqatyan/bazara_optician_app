import 'package:bazara_optician_app/core/provider/event_provider.dart';
import 'package:bazara_optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:bazara_optician_app/core/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderDatesScreen extends StatefulWidget {
  const CalenderDatesScreen({super.key});

  @override
  State<CalenderDatesScreen> createState() => _CalenderDatesScreenState();
}

class _CalenderDatesScreenState extends State<CalenderDatesScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _selectedEvents = [];
  @override
  void initState() {
    super.initState();
    _selectedDay = DateUtils.dateOnly(_focusedDay); // إزالة الوقت
    _loadEvents(); // تحميل الأحداث مباشرة
  }

  void _loadEvents() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventProvider.loadEvents();
    setState(() {}); // تحديث الواجهة بعد تحميل الأحداث
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(tital: 'التحقق من المواعيد'),
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
                defaultTextStyle: KTextStyle.textStyle14.copyWith(
                  color: AppColors.blackDark,
                ),
                selectedTextStyle: KTextStyle.textStyle16.copyWith(
                  color: AppColors.blackDark,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
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
                setState(() {
                  _selectedDay = DateUtils.dateOnly(selectedDay);
                  _focusedDay = focusedDay;
                  _selectedEvents = events[_selectedDay] ?? [];
                });
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

                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteName.kInvoiceDetailsScreen,
                                arguments: {
                                  'id': event['id'],
                                  'isDefaultValue':
                                      event['type'] == "Optometry",
                                },
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
                                        "ID: ${event['id']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors
                                                  .white, // ✅ لون النص أبيض ليتناسب مع الخلفية
                                        ),
                                      ),
                                      Text(
                                        event['type'] == "Optometry"
                                            ? "🔬 فحص"
                                            : "👓 شراء",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ), // ✅ لون النص أبيض
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    event['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                    ), // ✅ لون النص أبيض
                                  ),
                                  subtitle: Text(
                                    "التاريخ: ${event['date']}",
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ), // ✅ لون النص أبيض خفيف
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
