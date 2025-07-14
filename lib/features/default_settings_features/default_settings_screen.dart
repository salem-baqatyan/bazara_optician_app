import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optician_app/core/shered_widget/action_button_widget.dart';
import 'package:optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:optician_app/core/shered_widget/info_rich_field_widget.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/sqldb.dart';

class DefaultSettingsScreen extends StatefulWidget {
  const DefaultSettingsScreen({super.key});

  @override
  State<DefaultSettingsScreen> createState() => _DefaultSettingsScreenState();
}

class _DefaultSettingsScreenState extends State<DefaultSettingsScreen> {
  SqlDb sqlDb = SqlDb();

  List<Map<String, dynamic>> lenses = [];
  List<Map<String, dynamic>> tasks = [];
  String? selectedLens;

  bool isEnable = false;

  TextEditingController optometryMessageController = TextEditingController();
  TextEditingController purchasesMessageController = TextEditingController();
  TextEditingController lensesController = TextEditingController();
  TextEditingController tasksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadLenses();
    loadTasks();
    loadDefaultMessages();
  }

  Future<void> loadDefaultMessages() async {
    List<Map> optometryMessage = await sqlDb.readData(
      "SELECT messages FROM Messages WHERE type_message = 'Optometry'",
    );
    List<Map> purchasesMessage = await sqlDb.readData(
      "SELECT messages FROM Messages WHERE type_message = 'Purchases'",
    );

    if (optometryMessage.isNotEmpty) {
      optometryMessageController.text = optometryMessage[0]['messages'];
    }

    if (purchasesMessage.isNotEmpty) {
      purchasesMessageController.text = purchasesMessage[0]['messages'];
    }

    setState(() {});
  }

  Future<void> loadLenses() async {
    final response = await sqlDb.readData("SELECT name FROM Lenses");
    lenses = List<Map<String, dynamic>>.from(response);
    lensesController.text = lenses.map((e) => e['name']).join('\n');
    setState(() {});
  }

  Future<void> loadTasks() async {
    final response = await sqlDb.readData("SELECT name, points FROM Tasks");
    tasks = List<Map<String, dynamic>>.from(response);
    tasksController.text = tasks
        .map((e) => "${e['name']} - ${e['points']}")
        .join('\n');
    setState(() {});
  }

  Future<void> updateData() async {
    await sqlDb.updateData('''
      UPDATE Messages
      SET messages = CASE type_message
                       WHEN 'Optometry' THEN '${optometryMessageController.text}'
                       WHEN 'Purchases' THEN '${purchasesMessageController.text}'
                       ELSE messages
                     END
      WHERE type_message IN ('Optometry', 'Purchases')
    ''');
  }

  Future<void> updateLenses() async {
    await sqlDb.deleteData("DELETE FROM Lenses");

    List<String> updatedNames =
        lensesController.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    for (String name in updatedNames) {
      await sqlDb.insertData("INSERT INTO Lenses(name) VALUES ('$name')");
    }
  }

  Future<void> updateTasks() async {
    await sqlDb.deleteData("DELETE FROM Tasks");

    List<String> lines = tasksController.text.split('\n');
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      var parts = line.split('-');
      if (parts.length == 2) {
        String name = parts[0].trim();
        int? points = int.tryParse(parts[1].trim());
        if (points != null) {
          await sqlDb.insertData(
            "INSERT INTO Tasks (name, points) VALUES ('$name', $points)",
          );
        }
      }
    }
  }

  Future<void> resetToDefault() async {
    await sqlDb.deleteData("DELETE FROM Messages");
    await sqlDb.deleteData("DELETE FROM Lenses");
    await sqlDb.deleteData("DELETE FROM Tasks");

    await sqlDb.insertData('''
      INSERT INTO Messages (messages, type_message)
      VALUES 
      ("موعد مراجعة فحص نظرك قد اقترب حفاظا على صحة عينيك يرجى زيارتنا...", "Optometry"),
      ("نظارتك تم تجهيزها يرجى الحضور لاستلامها...", "Purchases")
    ''');

    await sqlDb.insertData('''
      INSERT INTO Lenses (name)
      VALUES 
      ("WT"),
      ("WT MC"),
      ("PG X")
    ''');

    await sqlDb.insertData('''
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

    await loadDefaultMessages();
    await loadLenses();
    await loadTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ تمت إعادة التعيين إلى البيانات الافتراضية'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                tital: 'الاعداد الافتراضي',
                isOptionalButton: true,
                optionalButtonIcon: isEnable ? Icons.edit_off : Icons.edit,
                optionalButtonColor: isEnable ? AppColors.colorButton : null,
                onOptionalButtonTab: () {
                  setState(() {
                    isEnable = !isEnable;
                    loadLenses();
                    loadDefaultMessages();
                    loadTasks();
                    FocusScope.of(context).unfocus();
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.maxFinite,
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            InfoRichFieldWidget(
                              textController: optometryMessageController,
                              text: 'رسالة فحص النظر',
                              width: 350.w,
                              height: 150.h,
                              maxLines: 5,
                              isEnable: isEnable,
                            ),
                            SizedBox(height: 20.h),
                            InfoRichFieldWidget(
                              textController: purchasesMessageController,
                              text: 'رسالة شراء النظارة',
                              width: 350.w,
                              height: 150.h,
                              maxLines: 5,
                              isEnable: isEnable,
                            ),
                            SizedBox(height: 20.h),
                            InfoRichFieldWidget(
                              textController: lensesController,
                              text: 'قائمة العدسات (عدِّل أو أضف أو احذف هنا)',
                              width: 350.w,
                              height: 200.h,
                              isEnable: isEnable,
                              textDirection: TextDirection.ltr,
                            ),
                            SizedBox(height: 20.h),
                            InfoRichFieldWidget(
                              textController: tasksController,
                              text: 'قائمة المهام (عدِّل أو أضف أو احذف هنا)',
                              width: 350.w,
                              height: 250.h,
                              isEnable: isEnable,
                              textDirection: TextDirection.rtl,
                            ),
                            SizedBox(height: 10.h),
                            isEnable == false
                                ? ActionButtonWidget(
                                  iconPath: Icons.repeat,
                                  title: 'اعادة تعيين',
                                  width: 150.w,
                                  onTap: () async {
                                    await resetToDefault();
                                    setState(() {});
                                  },
                                )
                                : ActionButtonWidget(
                                  iconPath: Icons.save,
                                  title: 'حفظ التعديل',
                                  width: 150.w,
                                  onTap: () async {
                                    await updateData();
                                    await updateLenses();
                                    await updateTasks();
                                    setState(() {
                                      isEnable = false;
                                      FocusScope.of(context).unfocus();
                                    });
                                  },
                                ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
