import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:file_picker/file_picker.dart';
import 'dart:io';

class Backup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Backup and Restore Database')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                backupDatabase();
              },
              child: Text('عمل نسخة احتياطية'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // restoreDatabase();
              },
              child: Text('استعادة النسخة الاحتياطية'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getDatabasePath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, "my_database.db");
  }

  Future<String?> pickBackupLocation() async {
    // String? path = await FilePicker.platform.getDirectoryPath();
    // return path;
  }

  Future<void> backupDatabase() async {
    String dbPath = await getDatabasePath();
    File dbFile = File(dbPath);

    String? backupDir = await pickBackupLocation();
    if (backupDir != null) {
      String backupPath = join(backupDir, "backup_my_database.db");
      await dbFile.copy(backupPath);
      print('Backup successful: $backupPath');
    } else {
      print('Backup cancelled');
    }
  }

  // Future<void> restoreDatabase() async {
  //   String? backupFilePath = await pickBackupFile();
  //   if (backupFilePath != null) {
  //     String dbPath = await getDatabasePath();
  //     File dbFile = File(dbPath);
  //     await dbFile.delete(); // حذف قاعدة البيانات الحالية
  //     await File(backupFilePath).copy(dbPath); // نسخ النسخة الاحتياطية
  //     print('Restore successful');
  //   } else {
  //     print('Restore cancelled');
  //   }
  // }

  // Future<String?> pickBackupFile() async {
  //   String? filePath = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['db'], // يمكنك تعديل امتداد الملف حسب الحاجة
  //   ).then((result) {
  //     return result?.files.single.path;
  //   });
  //   return filePath;
  // }
}
