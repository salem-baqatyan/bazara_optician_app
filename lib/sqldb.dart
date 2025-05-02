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
      CREATE TABLE "ClientOptometry" (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
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
        "review_date" TEXT
        )
''');
    batch.execute('''
      CREATE TABLE "ClientPurchases" (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
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
        "delvery_date" TEXT
        )
''');
    batch.execute('''
    CREATE TABLE "Events" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "id_invoice" INTEGER,
      "event_name" TEXT,
      "date_invoice" TEXT,
      "type_invoice" TEXT
    )
  ''');
    batch.execute('''
    CREATE TABLE "Clients" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "client_name" TEXT,
      "client_phone" TEXT,
      "id_invoice" INTEGER,
      "type_invoice" TEXT,
      "date_invoice" TEXT,
      "date_reminder" TEXT
    )
  ''');
    batch.execute('''
    CREATE TABLE "Messages" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "messages" TEXT,
      "type_message" TEXT
    )
  ''');
    batch.execute('''
    CREATE TABLE "Lenses" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "name" TEXT
    )
  ''');
    await batch.commit();
    debugPrint('✅ Create Database and Tables Done');

    // 🔵 إضافة البيانات الافتراضية مباشرة بعد إنشاء الجداول
    await db.rawInsert('''
    INSERT INTO Messages (messages, type_message)
    VALUES 
    ("موعد مراجعة فحص نظرك قد اقترب حفاظا على صحة عينيك يرجى زيارتنا...", "Optometry"),
    ("نظارتك تم تجهيزها يرجى الحضور لاستلامها...", "Purchases")
  ''');
    debugPrint('✅ Insert default messages into Messages table');
    await db.rawInsert('''
    INSERT INTO Lenses (name)
    VALUES 
    ("WT"),
    ("WT MC"),
    ("PG X")
  ''');
    debugPrint('✅ Insert default lenses into Lenses table');
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

  Future<void> backupDatabase() async {
    String databasePath = await getDatabasesPath();
    String dbFilePath = join(databasePath, 'database.db');
    File dbFile = File(dbFilePath);

    if (!await dbFile.exists()) {
      debugPrint('❌ قاعدة البيانات غير موجودة!');
      return;
    }

    String? backupDir = await FilePicker.platform.getDirectoryPath();
    if (backupDir != null) {
      final now = DateTime.now();
      final randomFileName =
          '${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}-${now.millisecond}.pdf';

      String backupPath = join(backupDir, "backup_$randomFileName.db");
      await dbFile.copy(backupPath);
      debugPrint('✅ النسخ الاحتياطي ناجح: $backupPath');
    } else {
      debugPrint('❌ تم إلغاء النسخ الاحتياطي');
    }
  }

  Future<void> restoreDatabase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // 🔹 السماح بأي نوع ملف
      );

      if (result != null && result.files.single.path != null) {
        String backupFilePath = result.files.single.path!;
        String dbPath =
            await getDatabasePath(); // 🔹 استدعاء `getDatabasePath` هنا
        File dbFile = File(dbPath);

        // حذف قاعدة البيانات الحالية إذا كانت موجودة
        if (await dbFile.exists()) {
          await dbFile.delete();
        }

        // استعادة النسخة الاحتياطية
        await File(backupFilePath).copy(dbPath);
        print('✅ استعادة النسخة الاحتياطية تمت بنجاح');
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
