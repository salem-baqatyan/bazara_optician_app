//device_calendar
/*

- عدد الفواتير: ${mostActiveClient['invoice_count']}'
*/
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:device_calendar/device_calendar.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CalendarScreen extends StatefulWidget {
//   @override
//   _CalendarScreenState createState() => _CalendarScreenState();
// }

// class _CalendarScreenState extends State<CalendarScreen> {
//   final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<Event>> _events = {};

//   @override
//   void initState() {
//     super.initState();
//     _requestCalendarPermission();
//   }

//   /// طلب الإذن للوصول إلى التقويم
//   Future<void> _requestCalendarPermission() async {
//     var status = await Permission.calendar.request();
//     if (status.isGranted) {
//       _loadCalendarEvents();
//     } else {
//       print("تم رفض إذن الوصول إلى التقويم");
//     }
//   }

//   /// تحميل أحداث التقويم
//   Future<void> _loadCalendarEvents() async {
//     var calendars = await _deviceCalendarPlugin.retrieveCalendars();
//     if (calendars.isSuccess &&
//         calendars.data != null &&
//         calendars.data!.isNotEmpty) {
//       var firstCalendar = calendars.data!.first;
//       var eventsResult = await _deviceCalendarPlugin.retrieveEvents(
//         firstCalendar.id!,
//         RetrieveEventsParams(
//           startDate: DateTime.now().subtract(Duration(days: 30)), // آخر 30 يوم
//           endDate: DateTime.now().add(Duration(days: 30)), // 30 يوم قادمة
//         ),
//       );

//       if (eventsResult.isSuccess && eventsResult.data != null) {
//         Map<DateTime, List<Event>> eventsMap = {};
//         for (var event in eventsResult.data!) {
//           DateTime eventDate = DateTime(
//             event.start!.year,
//             event.start!.month,
//             event.start!.day,
//           );
//           if (!eventsMap.containsKey(eventDate)) {
//             eventsMap[eventDate] = [];
//           }
//           eventsMap[eventDate]!.add(event);
//         }

//         setState(() {
//           _events = eventsMap;
//         });
//       }
//     }
//   }

//   /// إرجاع قائمة الأحداث في اليوم المحدد
//   List<Event> _getEventsForDay(DateTime day) {
//     return _events[DateTime(day.year, day.month, day.day)] ?? [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("التقويم الخاص بك")),
//       body: Column(
//         children: [
//           TableCalendar(
//             focusedDay: _focusedDay,
//             firstDay: DateTime.utc(2000, 1, 1),
//             lastDay: DateTime.utc(2100, 12, 31),
//             calendarFormat: _calendarFormat,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             eventLoader: _getEventsForDay,
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//             },
//             onFormatChanged: (format) {
//               setState(() {
//                 _calendarFormat = format;
//               });
//             },
//           ),
//           Expanded(
//             child:
//                 _selectedDay == null || _getEventsForDay(_selectedDay!).isEmpty
//                     ? Center(child: Text("لا توجد أحداث في هذا اليوم"))
//                     : ListView.builder(
//                       itemCount: _getEventsForDay(_selectedDay!).length,
//                       itemBuilder: (context, index) {
//                         Event event = _getEventsForDay(_selectedDay!)[index];
//                         return ListTile(
//                           title: Text(event.title ?? "بدون عنوان"),
//                           subtitle: Text("من ${event.start} إلى ${event.end}"),
//                           leading: Icon(Icons.event, color: Colors.blue),
//                         );
//                       },
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }
