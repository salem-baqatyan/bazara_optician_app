import 'dart:io';
import 'package:bazara_optician_app/core/const/my_flutter_app_icons.dart';
import 'package:bazara_optician_app/core/shered_widget/action_button_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/add_from_contacts_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:bazara_optician_app/core/shered_widget/info_text_field_widget.dart';
import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:bazara_optician_app/features/customers_market_features/custom_add_image_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/info_rich_field_widget.dart';
import 'package:bazara_optician_app/sqldb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
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

  late TextEditingController name = TextEditingController(
    text: list[0]['name'],
  );
  late TextEditingController phone = TextEditingController(
    text: list[0]['phone'],
  );
  late TextEditingController message = TextEditingController(text: messageType);

  SqlDb sqlDb = SqlDb();
  List list = [];
  String? isDefaultType;
  int? id;
  String messageType = "";
  @override
  void initState() {
    super.initState();
    id = widget.id;
    isDefaultType = widget.isDefaultType;
    readData();
  }

  Future<void> readData() async {
    if (isDefaultType == "Optometry") {
      list.clear();
      List<Map> response = await sqlDb.readData(
        "SELECT * FROM ClientOptometry WHERE id = $id",
      );
      list.addAll(response);
      messageType =
          'موعد مراجعة فحص نظرك قد اقترب حفاظا على صحة عينيك يرجى زيارتنا...';
    } else if (isDefaultType == "Purchases") {
      list.clear();
      List<Map> response = await sqlDb.readData(
        "SELECT * FROM ClientPurchases WHERE id = $id",
      );
      list.addAll(response);
      messageType = 'نظارتك تم تجهيزها يرجى الحضور لستلامها...';
    } else if (isDefaultType == "Other") {
      list.clear();
      List<Map> response = [
        {'name': '', 'phone': ''},
      ];
      list.addAll(response);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                              setState(() {
                                contact == null ? null : [contact];
                              });
                              name = TextEditingController(
                                text: contact!.fullName ?? 'No name',
                              );
                              phone = TextEditingController(
                                text: contact.phoneNumbers?.first ?? 'No phone',
                              );
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
                          ),
                          SizedBox(height: 20.h),
                          CustomTextFormWidget(
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
