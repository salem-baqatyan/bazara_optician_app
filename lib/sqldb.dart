import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:provider/provider.dart';

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

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'database.db');
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 2,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  _onCreate(Database db, int version) async {
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
        "R_SPH" TEXT, 
        "R_CYL" TEXT,
        "R_AXIS" TEXT,
        "R_ADD" TEXT,
        "R_CLR" TEXT,
        "L_SPH" TEXT, 
        "L_CYL" TEXT,
        "L_AXIS" TEXT,
        "L_ADD" TEXT,
        "L_CLR" TEXT,
        "total_price" TEXT,
        "paid_price" TEXT,
        "remaining_price" TEXT,
        "invoice_date" TEXT,
        "delvery_date" TEXT)
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
    await batch.commit();
    print('Create Database and Table ====================');
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {}

  deleteMyDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'database.db');
    await deleteDatabase(path);
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    notifyListeners();
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}
