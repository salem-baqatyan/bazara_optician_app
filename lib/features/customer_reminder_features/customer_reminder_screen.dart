import 'package:optician_app/core/const/my_flutter_app_icons.dart';
import 'package:optician_app/core/shered_widget/add_from_contacts_widget.dart';
import 'package:optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:optician_app/core/shered_widget/info_text_field_widget.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/core/shered_widget/info_rich_field_widget.dart';
import 'package:optician_app/sqldb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerReminderScreen extends StatefulWidget {
  final int id;
  final String isDefaultType;

  const CustomerReminderScreen({
    super.key,
    required this.id,
    required this.isDefaultType,
  });

  @override
  State<CustomerReminderScreen> createState() => _CustomerReminderScreenState();
}

class _CustomerReminderScreenState extends State<CustomerReminderScreen> {
  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController message = TextEditingController();

  SqlDb sqlDb = SqlDb();
  List list = [];
  bool isLoading = true; // ⬅️ متغير لتحديد ما إذا كانت البيانات تُحمّل

  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<void> readData() async {
    int id = widget.id;
    String isDefaultType = widget.isDefaultType;
    String messageType = "";
    print(isDefaultType);
    if (isDefaultType == "Optometry") {
      List<Map> response = await sqlDb.readData(
        "SELECT * FROM ClientOptometry WHERE id = $id",
      );
      list = response;

      // جلب الرسالة المناسبة من جدول Messages حسب نوع العميل
      List<Map> messageResponse = await sqlDb.readData(
        "SELECT * FROM Messages WHERE type_message = '$isDefaultType'",
      );

      if (messageResponse.isNotEmpty) {
        messageType = messageResponse[0]['messages'] ?? '';
      }
    } else if (isDefaultType == "Purchases") {
      List<Map> response = await sqlDb.readData(
        "SELECT * FROM ClientPurchases WHERE id = $id",
      );
      list = response;
      // جلب الرسالة المناسبة من جدول Messages حسب نوع العميل
      List<Map> messageResponse = await sqlDb.readData(
        "SELECT * FROM Messages WHERE type_message = '$isDefaultType'",
      );

      if (messageResponse.isNotEmpty) {
        messageType = messageResponse[0]['messages'] ?? '';
      }
    } else {
      list = [
        {'name': '', 'phone': ''},
      ];
      messageType = '';
    }
    if (mounted && list.isNotEmpty) {
      name.text = list[0]['name'] ?? '';
      phone.text = list[0]['phone'] ?? '';
      message.text = messageType;
    }

    setState(() {
      isLoading = false;
    });
  }

  String validatePhone(String value) {
    if (value.isEmpty) return 'مطلوب إدخال رقم الجوال';
    if (!RegExp(r'^(7\d{8}|0\d{7})$').hasMatch(value)) {
      return 'رقم الجوال يجب أن يبدأ بـ7 أو 0 ويتبعه 7 أرقام';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.transparent,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(tital: 'تذكير العملاء'),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.maxFinite,
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          AddFromContactsWidget(
                            onTap: () async {
                              Contact? contact =
                                  await _contactPicker.selectContact();
                              if (contact != null) {
                                String rawPhone =
                                    contact.phoneNumbers?.first ?? 'No phone';
                                String cleanedPhone = rawPhone.replaceAll(
                                  RegExp(r'\D'),
                                  '',
                                );

                                if (cleanedPhone.startsWith('967')) {
                                  cleanedPhone = cleanedPhone.substring(3);
                                } else if (cleanedPhone.startsWith('00967')) {
                                  cleanedPhone = cleanedPhone.substring(5);
                                }

                                setState(() {
                                  name.text = contact.fullName ?? 'No name';
                                  phone.text = cleanedPhone;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 20.h),
                          InfoTextFieldWidget(
                            title: 'اسم العميل',
                            controller: name,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 10.h),
                          InfoTextFieldWidget(
                            title: 'رقم العميل',
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            validator: validatePhone,
                          ),
                          SizedBox(height: 20.h),
                          InfoRichFieldWidget(
                            textController: message,
                            text: 'رسالة العميل',
                            width: 350.w,
                            height: 150.h,
                            maxLines: 5,
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: socialButtons(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialButtons() {
    return ButtonBar(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            if (name.text.isEmpty ||
                phone.text.isEmpty ||
                message.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('يرجى ملء جميع الحقول اولا!')),
              );
            } else {
              final Uri launchUri = Uri(
                scheme: 'https',
                host: 'api.whatsapp.com',
                path: 'send',
                queryParameters: {'phone': phone.text, 'text': message.text},
              );
              launchUrl(launchUri);
            }
          },
          icon: const Icon(
            SocialIcon.whatsapp,
            color: AppColors.primary,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {
            if (name.text.isEmpty ||
                phone.text.isEmpty ||
                message.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('يرجى ملء جميع الحقول اولا!')),
              );
            } else {
              final Uri launchUri = Uri(
                scheme: 'sms',
                path: phone.text,
                queryParameters: {'body': message.text},
              );
              launchUrl(launchUri);
            }
          },
          icon: const Icon(Icons.mail, color: AppColors.primary, size: 30),
        ),
        IconButton(
          onPressed: () {
            if (name.text.isEmpty ||
                phone.text.isEmpty ||
                message.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('يرجى ملء جميع الحقول اولا!')),
              );
            } else {
              final Uri launchUri = Uri(scheme: 'tel', path: phone.text);
              launchUrl(launchUri);
            }
          },
          icon: const Icon(Icons.phone, color: AppColors.primary, size: 30),
        ),
      ],
    );
  }
}
