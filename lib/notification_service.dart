import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  // إرسال التذكيرات بناءً على نوع الحدث (Optometry أو Purchases)
  Future<void> scheduleNotification(
    int invoiceId,
    String eventName,
    DateTime eventDate,
    String eventType,
  ) async {
    final now = DateTime.now();
    DateTime scheduledDate = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      0,
      0,
      // now.hour,
      // now.minute + 2,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 1),
      ); // لضمان أن التذكير في المستقبل
    }

    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default Notifications',
          channelDescription: 'Channel for default notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    if (eventType == 'Purchases') {
      androidNotificationDetails = AndroidNotificationDetails(
        'purchases_channel',
        'Purchases Notifications',
        channelDescription: 'Channel for purchases notifications',
        importance: Importance.max,
        priority: Priority.high,
      );

      // تذكير في نفس اليوم للشراء
      await flutterLocalNotificationsPlugin.zonedSchedule(
        invoiceId, // مع تغيير ID لتجنب التكرار
        '⏰ تذكير تجهيز نظارة',
        '🔔 $eventName',
        tzScheduledDate,
        NotificationDetails(android: androidNotificationDetails),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } else if (eventType == 'Optometry') {
      // تذكير قبل أيام متعددة (5، 4، 3، 2، 1)
      for (int i = 5; i >= 0; i--) {
        final optometryScheduledDate = tzScheduledDate.subtract(
          Duration(days: i),
        );
        await flutterLocalNotificationsPlugin.zonedSchedule(
          invoiceId + i, // تغيير الـ ID لتجنب التكرار
          '⏰ تذكير مراجعة فحص نظر',
          '🔔 تبقى $i يوم من $eventName',
          optometryScheduledDate,
          NotificationDetails(android: androidNotificationDetails),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }
}
