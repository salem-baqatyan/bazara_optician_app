import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class SqlDb extends ChangeNotifier {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> intialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'database.db');
    Database mydb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
-- جدول العملاء
CREATE TABLE "Clients" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT,
  "phone" TEXT,
  "points" INTEGER DEFAULT 0
)
''');

    batch.execute('''
-- جدول نقاط العميل
CREATE TABLE "Points" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "client_id" INTEGER,
  "task_name" TEXT,
  "quantity" INTEGER,
  "points_per_item" INTEGER,
  "total_points" INTEGER,
  "date" TEXT,
  FOREIGN KEY ("client_id") REFERENCES Clients("id")
)
''');

    batch.execute('''
-- فواتير فحص النظر
CREATE TABLE "ClientOptometry" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT, 
  "client_id" INTEGER,
  "name" TEXT, 
  "phone" TEXT,

  "dist_R_SPH" TEXT, 
  "dist_R_CYL" TEXT,
  "dist_R_AXIS" TEXT,
  "dist_R_V_A" TEXT,
  "dist_L_SPH" TEXT, 
  "dist_L_CYL" TEXT,
  "dist_L_AXIS" TEXT,
  "dist_L_V_A" TEXT,

  "near_R_SPH" TEXT, 
  "near_R_CYL" TEXT,
  "near_R_AXIS" TEXT,
  "near_R_V_A" TEXT,
  "near_L_SPH" TEXT, 
  "near_L_CYL" TEXT,
  "near_L_AXIS" TEXT,
  "near_L_V_A" TEXT,
  
  "L_P_D" TEXT,
  "DR" TEXT,

  "invoice_date" TEXT,
  "review_date" TEXT,

  FOREIGN KEY ("client_id") REFERENCES Clients("id")
)
''');
    batch.execute('''
-- فواتير شراء النظارات
CREATE TABLE "ClientPurchases" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT, 
  "client_id" INTEGER,
  "name" TEXT, 
  "phone" TEXT,
  "frame_type" TEXT,
  "frame_model" TEXT,
  "lense_type" TEXT,

  "R_SPH" TEXT, 
  "R_CYL" TEXT,
  "R_AXIS" TEXT,
  "R_ADD" TEXT,
  "L_SPH" TEXT, 
  "L_CYL" TEXT,
  "L_AXIS" TEXT,
  "L_ADD" TEXT,

  "total_price" TEXT,
  "paid_price" TEXT,
  "remaining_price" TEXT,
  "invoice_date" TEXT,
  "delvery_date" TEXT,

  FOREIGN KEY ("client_id") REFERENCES Clients("id")
)
  ''');
    batch.execute('''
-- جدول الأحداث (للتذكير بموعد الفحص أو استلام النظارة)
CREATE TABLE "Events" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "id_invoice" INTEGER,
  "event_name" TEXT,
  "date_invoice" TEXT,
  "type_invoice" TEXT
)
  ''');
    batch.execute('''
-- جدول العمليات
CREATE TABLE "Process" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "client_name" TEXT,
  "client_phone" TEXT,
  "id_invoice" INTEGER,
  "type_invoice" TEXT,
  "date_invoice" TEXT,
  "date_reminder" TEXT
)
  ''');
    batch.execute('''
-- جدول الرسائل الجاهزة
CREATE TABLE "Messages" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "messages" TEXT,
  "type_message" TEXT
)
  ''');
    batch.execute('''
-- جدول أنواع العدسات
CREATE TABLE "Lenses" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT
)
  ''');
    batch.execute('''
-- جدول أنواع المهمات
CREATE TABLE "Tasks" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT,
  "points" INTEGER
)
''');

    await batch.commit();
    debugPrint('✅ Create Database and Tables Done');

    // 🔵 إضافة البيانات الافتراضية مباشرة بعد إنشاء الجداول
    await db.rawInsert('''
-- رسائل افتراضية
INSERT INTO Messages (messages, type_message)
VALUES 
("موعد مراجعة فحص نظرك قد اقترب حفاظا على صحة عينيك يرجى زيارتنا...", "Optometry"),
("نظارتك تم تجهيزها يرجى الحضور لاستلامها...", "Purchases")
  ''');
    debugPrint('✅ Insert default messages into Messages table');
    await db.rawInsert('''
-- أنواع العدسات الافتراضية
INSERT INTO Lenses (name)
VALUES 
("WT"),
("WT MC"),
("PG X")
  ''');
    await db.rawInsert('''
-- أنواع المهمات الافتراضية
INSERT INTO Tasks (name, points) VALUES 
("نظارة كاملة", 25),
("عدسات طبية فقط", 10),
("فريم فقط", 10),
("نظارة قراءة", 5),
("نظارة شمسية", 15),
("عدسات الاصقة طبية", 15),
("عدسات لاصقة زينة", 10),
("محلول عدسات + بخاخ", 5)
''');
    debugPrint('✅ Insert default Tasks into tasks table');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<String> getDatabasePath() async {
    String databasePath = await getDatabasesPath();
    return join(databasePath, 'database.db');
  }

  Future<void> deleteMyDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'database.db');
    await deleteDatabase(path);
  }

  /// ✅ نسخ احتياطي إلى اي مجلد
  Future<void> backupDatabase() async {
    String dbPath = await getDatabasePath();
    File dbFile = File(dbPath);

    if (!await dbFile.exists()) {
      debugPrint('❌ قاعدة البيانات غير موجودة!');
      return;
    }

    String? backupDir = await FilePicker.platform.getDirectoryPath();
    if (backupDir != null) {
      final now = DateTime.now();
      final fileName =
          'backup_${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}.db';
      final backupPath = join(backupDir, fileName);

      // ✅ نسخ المحتوى يدويًا لتفادي مشاكل read-only
      final newFile = await File(backupPath).create();
      await newFile.writeAsBytes(await dbFile.readAsBytes());

      debugPrint('✅ تم النسخ الاحتياطي بنجاح إلى: $backupPath');
    } else {
      debugPrint('❌ تم إلغاء النسخ الاحتياطي');
    }
  }

  /// ✅ استعادة نسخة من ملف .db يحدده المستخدم
  Future<void> restoreDatabase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        String backupFilePath = result.files.single.path!;
        String dbPath = await getDatabasePath();
        File dbFile = File(dbPath);

        // حذف القاعدة القديمة
        if (await dbFile.exists()) {
          await dbFile.delete();
        }

        // ✅ نسخ المحتوى يدويًا لتفادي read-only
        final newDbFile = await File(dbPath).create();
        await newDbFile.writeAsBytes(await File(backupFilePath).readAsBytes());

        // ✅ إعادة فتح الاتصال بالقاعدة
        if (_db != null) {
          await _db!.close();
          _db = null;
        }
        _db = await openDatabase(dbPath);
        notifyListeners();

        print('✅ تم استعادة النسخة الاحتياطية بنجاح');
      } else {
        print('⚠️ لم يتم اختيار أي ملف');
      }
    } catch (e) {
      print('❌ خطأ أثناء استعادة النسخة الاحتياطية: $e');
    }
  }

  Future<dynamic> readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    notifyListeners();
    return response;
  }

  Future<dynamic> insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  Future<dynamic> updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  Future<dynamic> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}
