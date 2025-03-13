import 'package:optician_app/core/shered_widget/action_button_widget.dart';
import 'package:optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  Future<void> requestPermissions() async {
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    final sqlDb = Provider.of<SqlDb>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomAppBar(tital: 'إدارة النسخ الاحتياطي'),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionButtonWidget(
                      isSolid: true,
                      iconPath: Icons.backup,
                      title: 'عمل نسخة احتياطية',
                      width: 200.w,
                      onTap: () async {
                        await requestPermissions();
                        await sqlDb.backupDatabase();
                      },
                    ),
                    SizedBox(height: 20),
                    ActionButtonWidget(
                      isSolid: false,
                      iconPath: Icons.restore,
                      title: 'استعادة النسخة الاحتياطية',
                      width: 200.w,
                      onTap: () async {
                        await requestPermissions();
                        await sqlDb.restoreDatabase();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
