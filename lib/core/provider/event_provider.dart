import 'package:bazara_optician_app/notification_service.dart';
import 'package:bazara_optician_app/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class EventProvider extends ChangeNotifier {
  Map<DateTime, List<Map<String, dynamic>>> events = {};
  final SqlDb _sqlDb = SqlDb(); // كائن قاعدة البيانات

  // 🔹 استرجاع الأحداث من قاعدة البيانات
  Future<void> loadEvents() async {
    try {
      Map<DateTime, List<Map<String, dynamic>>> newEvents = {};

      // ✅ جلب جميع الأحداث من جدول Events
      List<Map> eventData = await _sqlDb.readData('SELECT * FROM Events');

      for (var row in eventData) {
        try {
          // ✅ معالجة أي خطأ في تحويل التاريخ
          DateTime date = DateFormat("yyyy/MM/dd").parse(row['date_invoice']);
          Map<String, dynamic> event = {
            "id": row['id_invoice'],
            "name": row['event_name'], // ✅ إضافة اسم الحدث
            "type": row['type_invoice'],
            "date": row['date_invoice'],
          };

          if (!newEvents.containsKey(date)) {
            newEvents[date] = [];
          }
          newEvents[date]!.add(event);
        } catch (e) {
          print("❌ خطأ في تحويل التاريخ: ${row['date_invoice']} - $e");
        }
      }

      // تحديث قائمة الأحداث وإشعار الواجهة
      events = newEvents;
      notifyListeners();
    } catch (e) {
      print("❌ خطأ في تحميل الأحداث: $e");
    }
  }

  // 🔹 إضافة حدث جديد
  Future<void> addEvent(
    int invoiceId,
    String eventName,
    String dateString,
    String type,
  ) async {
    try {
      Database? mydb = await _sqlDb.db;

      if (mydb == null) {
        print("❌ قاعدة البيانات غير مهيأة.");
        return;
      }

      // ✅ إدراج الحدث في قاعدة البيانات
      await mydb.rawInsert(
        "INSERT INTO Events (id_invoice, event_name, date_invoice, type_invoice) VALUES (?, ?, ?, ?)",
        [invoiceId, eventName, dateString, type],
      );

      // ✅ تحويل التاريخ وجدولة الإشعارات باستخدام NotificationService
      DateTime eventDate = DateFormat("yyyy/MM/dd").parse(dateString);
      await NotificationService().scheduleNotification(
        invoiceId,
        eventName,
        eventDate,
        type, // نوع الحدث: "Optometry" أو "Purchases"
      );

      // ✅ تحديث قائمة الأحداث
      if (!events.containsKey(eventDate)) {
        events[eventDate] = [];
      }

      events[eventDate]!.add({
        "id": invoiceId,
        "name": eventName,
        "type": type,
        "date": dateString,
      });

      notifyListeners();
    } catch (e) {
      print("❌ خطأ في إضافة الحدث: $e");
    }
  }

  // 🔹 حذف الأحداث القديمة
  Future<void> removeOldEvents() async {
    try {
      Database? mydb = await _sqlDb.db;
      if (mydb == null) {
        print("❌ قاعدة البيانات غير مهيأة.");
        return;
      }
      final now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day, 0, 0);

      // ✅ حذف الأحداث القديمة من قاعدة البيانات
      await mydb.rawDelete("DELETE FROM Events WHERE date_invoice < ?", [
        DateFormat("yyyy/MM/dd").format(today),
      ]);

      // ✅ حذف الأحداث من الخريطة
      events.removeWhere((date, _) {
        final difference = today.difference(date).inDays;
        return difference >
            0; // إذا كانت الفرق بين التاريخين أكبر من 0 فهذا يعني أن الحدث في الماضي
      });

      // 🔄 تحديث الشاشة
      notifyListeners();

      print(
        "✅ تم حذف الأحداث القديمة التي كانت بتاريخ: ${DateFormat('yyyy/MM/dd').format(today)}",
      );
    } catch (e) {
      print("❌ خطأ في حذف الأحداث القديمة: $e");
    }
  }
}
