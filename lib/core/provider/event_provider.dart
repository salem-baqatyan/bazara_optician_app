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

      // ✅ إدراج الحدث في جدول Events
      await mydb.rawInsert(
        "INSERT INTO Events (id_invoice, event_name, date_invoice, type_invoice) VALUES (?, ?, ?, ?)",
        [invoiceId, eventName, dateString, type],
      );

      // ✅ تحويل التاريخ وإضافته إلى قائمة الأحداث
      DateTime date = DateFormat("yyyy/MM/dd").parse(dateString);
      Map<String, dynamic> event = {
        "id": invoiceId,
        "name": eventName,
        "type": type,
        "date": dateString,
      };

      if (!events.containsKey(date)) {
        events[date] = [];
      }

      events[date]!.add(event);

      notifyListeners();
    } catch (e) {
      print("❌ خطأ في إضافة الحدث: $e");
    }
  }
}
