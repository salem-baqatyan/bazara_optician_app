// ignore_for_file: non_constant_identifier_names

import 'package:optician_app/core/provider/event_provider.dart';
import 'package:optician_app/core/shered_widget/action_button_widget.dart';
import 'package:optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:optician_app/core/shered_widget/section_title_widget.dart';
import 'package:optician_app/core/shered_widget/type_radio_widget.dart';
import 'package:optician_app/core/styles/Colors.dart';
import 'package:optician_app/core/shered_widget/add_from_contacts_widget.dart';
import 'package:optician_app/core/shered_widget/info_text_field_widget.dart';
import 'package:optician_app/features/new_invoice_features/widgets/invoice_optometry_widget.dart';
import 'package:optician_app/features/new_invoice_features/widgets/invoice_purchases_widget.dart';
import 'package:optician_app/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewInvoiceScreen extends StatefulWidget {
  const NewInvoiceScreen({super.key});

  @override
  State<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  SqlDb sqlDb = SqlDb();
  String selectedOption = 'Optometry';
  bool isDefaultValue = true;

  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();

  late TextEditingController name = TextEditingController();
  late TextEditingController phone = TextEditingController();
  late TextEditingController invoice_date = TextEditingController();
  ///////////////////////////////////////////////////////
  late TextEditingController dist_R_SPH = TextEditingController();
  late TextEditingController dist_R_CYL = TextEditingController();
  late TextEditingController dist_R_AXIS = TextEditingController();
  late TextEditingController dist_R_V_A = TextEditingController();
  late TextEditingController dist_L_SPH = TextEditingController();
  late TextEditingController dist_L_CYL = TextEditingController();
  late TextEditingController dist_L_AXIS = TextEditingController();
  late TextEditingController dist_L_V_A = TextEditingController();

  late TextEditingController near_R_SPH = TextEditingController();
  late TextEditingController near_R_CYL = TextEditingController();
  late TextEditingController near_R_AXIS = TextEditingController();
  late TextEditingController near_R_V_A = TextEditingController();
  late TextEditingController near_L_SPH = TextEditingController();
  late TextEditingController near_L_CYL = TextEditingController();
  late TextEditingController near_L_AXIS = TextEditingController();
  late TextEditingController near_L_V_A = TextEditingController();

  late TextEditingController L_P_D = TextEditingController();
  late TextEditingController DR = TextEditingController();

  late TextEditingController review_date = TextEditingController();
  ///////////////////////////////////////////////////
  late TextEditingController frame_type = TextEditingController();
  late TextEditingController frame_model = TextEditingController();

  late TextEditingController R_SPH = TextEditingController();
  late TextEditingController R_CYL = TextEditingController();
  late TextEditingController R_AXIS = TextEditingController();
  late TextEditingController R_ADD = TextEditingController();
  late TextEditingController R_CLR = TextEditingController();
  late TextEditingController L_SPH = TextEditingController();
  late TextEditingController L_CYL = TextEditingController();
  late TextEditingController L_AXIS = TextEditingController();
  late TextEditingController L_ADD = TextEditingController();
  late TextEditingController L_CLR = TextEditingController();

  late TextEditingController total_price = TextEditingController();
  late TextEditingController paid_price = TextEditingController();
  late TextEditingController remaining_price = TextEditingController();

  late TextEditingController delvery_date = TextEditingController();
  ////////////////////////////////////////////////////////
  void clearOptometry() {
    dist_R_SPH.clear();
    dist_R_CYL.clear();
    dist_R_AXIS.clear();
    dist_R_V_A.clear();
    dist_L_SPH.clear();
    dist_L_CYL.clear();
    dist_L_AXIS.clear();
    dist_L_V_A.clear();

    near_R_SPH.clear();
    near_R_CYL.clear();
    near_R_AXIS.clear();
    near_R_V_A.clear();
    near_L_SPH.clear();
    near_L_CYL.clear();
    near_L_AXIS.clear();
    near_L_V_A.clear();

    L_P_D.clear();
    DR.clear();
    review_date.clear();
  }

  void clearPurchases() {
    frame_type.clear();
    frame_model.clear();

    R_SPH.clear();
    R_CYL.clear();
    R_AXIS.clear();
    R_ADD.clear();
    R_CLR.clear();
    L_SPH.clear();
    L_CYL.clear();
    L_AXIS.clear();
    L_ADD.clear();
    L_CLR.clear();

    total_price.clear();
    paid_price.clear();
    remaining_price.clear();

    delvery_date.clear();
  }

  void reloadDate() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = 6 + now.month;
    int day = now.day;
    DateTime result = DateTime(year, month, day);
    invoice_date = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(now),
    );
    review_date = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(result),
    );
  }

  Future addData() async {
    // ✅ دالة لتحويل "0.00" إلى "PR" والحقول الفارغة إلى "-"
    String formatValue(String value) {
      if (value.trim().isEmpty) return "-"; // إذا كان الحقل فارغًا ضع "-"
      if (value.trim() == "0.00") return "PR"; // إذا كان الحقل "0.00" ضع "PR"
      return value;
    }

    if (isDefaultValue == true) {
      if (name.text.isEmpty || phone.text.isEmpty || DR.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يرجى ملء جميع الحقول المطلوبة!')),
        );
      } else {
        dist_R_SPH.text = formatValue(dist_R_SPH.text);
        dist_R_CYL.text = formatValue(dist_R_CYL.text);
        dist_R_AXIS.text = formatValue(dist_R_AXIS.text);
        dist_R_V_A.text = formatValue(dist_R_V_A.text);
        dist_L_SPH.text = formatValue(dist_L_SPH.text);
        dist_L_CYL.text = formatValue(dist_L_CYL.text);
        dist_L_AXIS.text = formatValue(dist_L_AXIS.text);
        dist_L_V_A.text = formatValue(dist_L_V_A.text);
        near_R_SPH.text = formatValue(near_R_SPH.text);
        near_R_CYL.text = formatValue(near_R_CYL.text);
        near_R_AXIS.text = formatValue(near_R_AXIS.text);
        near_R_V_A.text = formatValue(near_R_V_A.text);
        near_L_SPH.text = formatValue(near_L_SPH.text);
        near_L_CYL.text = formatValue(near_L_CYL.text);
        near_L_AXIS.text = formatValue(near_L_AXIS.text);
        near_L_V_A.text = formatValue(near_L_V_A.text);

        int response = await sqlDb.insertData('''
      INSERT INTO ClientOptometry 
      (name, phone, dist_R_SPH, dist_R_CYL, dist_R_AXIS, dist_R_V_A, 
      dist_L_SPH, dist_L_CYL, dist_L_AXIS, dist_L_V_A, near_R_SPH, 
      near_R_CYL, near_R_AXIS, near_R_V_A, near_L_SPH, near_L_CYL, 
      near_L_AXIS, near_L_V_A, L_P_D, DR, invoice_date, review_date)
      VALUES 
      ("${name.text}", "${phone.text}", "${dist_R_SPH.text}", "${dist_R_CYL.text}", "${dist_R_AXIS.text}", "${dist_R_V_A.text}", 
      "${dist_L_SPH.text}", "${dist_L_CYL.text}", "${dist_L_AXIS.text}", "${dist_L_V_A.text}", "${near_R_SPH.text}", 
      "${near_R_CYL.text}", "${near_R_AXIS.text}", "${near_R_V_A.text}", "${near_L_SPH.text}", "${near_L_CYL.text}", 
      "${near_L_AXIS.text}", "${near_L_V_A.text}", "${L_P_D.text}", "${DR.text}", "${invoice_date.text}", "${review_date.text}")
      ''');

        if (response > 0) {
          // 🔹 جلب ID آخر فاتورة
          List<Map> lastInvoice = await sqlDb.readData(
            "SELECT id FROM ClientOptometry ORDER BY id DESC LIMIT 1",
          );
          int invoiceId = lastInvoice[0]['id'];

          // ✅ إضافة الحدث إلى التقويم
          Provider.of<EventProvider>(context, listen: false).addEvent(
            invoiceId,
            'مراجعة فحص النظر لـ ${name.text}', // اسم الحدث
            review_date.text,
            "Optometry", // ✅ النوع الصحيح
          );
          name.clear();
          phone.clear();
          clearOptometry();
          reloadDate();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تمت إضافة فاتورة فحص النظر بنجاح...'),
            ),
          );
        }
      }
    } else {
      if (name.text.isEmpty ||
          phone.text.isEmpty ||
          total_price.text.isEmpty ||
          paid_price.text.isEmpty ||
          delvery_date.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يرجى ملء جميع الحقول المطلوبة!')),
        );
      } else {
        R_SPH.text = formatValue(R_SPH.text);
        R_CYL.text = formatValue(R_CYL.text);
        R_AXIS.text = formatValue(R_AXIS.text);
        R_ADD.text = formatValue(R_ADD.text);
        R_CLR.text = formatValue(R_CLR.text);
        L_SPH.text = formatValue(L_SPH.text);
        L_CYL.text = formatValue(L_CYL.text);
        L_AXIS.text = formatValue(L_AXIS.text);
        L_ADD.text = formatValue(L_ADD.text);
        L_CLR.text = formatValue(L_CLR.text);

        int response = await sqlDb.insertData('''
      INSERT INTO ClientPurchases 
      (name, phone, frame_type, frame_model, R_SPH, R_CYL, R_AXIS, R_ADD, R_CLR, 
      L_SPH, L_CYL, L_AXIS, L_ADD, L_CLR, total_price, paid_price, remaining_price, 
      invoice_date, delvery_date)
      VALUES 
      ("${name.text}", "${phone.text}", "${frame_type.text}", "${frame_model.text}", "${R_SPH.text}", "${R_CYL.text}", "${R_AXIS.text}", 
      "${R_ADD.text}", "${R_CLR.text}", "${L_SPH.text}", "${L_CYL.text}", "${L_AXIS.text}", "${L_ADD.text}", "${L_CLR.text}", 
      "${total_price.text}", "${paid_price.text}", "${remaining_price.text}", "${invoice_date.text}", "${delvery_date.text}")
      ''');

        if (response > 0) {
          // 🔹 جلب ID آخر فاتورة
          List<Map> lastInvoice = await sqlDb.readData(
            "SELECT id FROM ClientPurchases ORDER BY id DESC LIMIT 1",
          );
          int invoiceId = lastInvoice[0]['id'];

          // ✅ إضافة الحدث إلى التقويم
          Provider.of<EventProvider>(context, listen: false).addEvent(
            invoiceId,
            'تسليم النظارة لـ ${name.text}', // اسم الحدث
            delvery_date.text,
            "Purchases", // ✅ النوع الصحيح
          );
          name.clear();
          phone.clear();
          clearPurchases();
          reloadDate();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تمت إضافة فاتورة شراء النظارة بنجاح...'),
            ),
          );
        }
      }
    }
  }

  deleteAll() async {
    await sqlDb.deleteData("DELETE FROM ClientPurchases ");
    setState(() {});
  }

  void onChanged() {
    double total = double.tryParse(total_price.text) ?? 0;
    double paid = double.tryParse(paid_price.text) ?? 0;

    if (paid > total) {
      paid = total;
      paid_price.text = total.toStringAsFixed(0); // إعادة ضبط المدفوع
    }

    double remaining = total - paid;
    setState(() {
      remaining_price.text = remaining.toStringAsFixed(0);
    });
  }

  @override
  void initState() {
    super.initState();
    isDefaultValue = selectedOption == 'Optometry';
    reloadDate();
  }

  @override
  void dispose() {
    super.dispose();
    clearPurchases();
    clearOptometry();
    name.clear();
    phone.clear();
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
              CustomAppBar(tital: 'اضافة فاتورة جديدة'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          color: AppColors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SectionTitleWidget(
                                      title: 'المعلومات الشخصية',
                                    ),
                                    SizedBox(height: 20.h),
                                    AddFromContactsWidget(
                                      onTap: () async {
                                        Contact? contact =
                                            await _contactPicker
                                                .selectContact();
                                        setState(() {
                                          contact == null ? null : [contact];
                                        });
                                        name = TextEditingController(
                                          text: contact!.fullName ?? 'No name',
                                        );
                                        phone = TextEditingController(
                                          text:
                                              contact.phoneNumbers?.first ??
                                              'No phone',
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
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                TypeRadioWidget(
                                  selectedOption: selectedOption,
                                  onChangedOptometry: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                      isDefaultValue = true;
                                      clearPurchases();
                                      reloadDate();
                                    });
                                  },
                                  onChangedPurchases: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                      isDefaultValue = false;
                                      clearOptometry();
                                      reloadDate();
                                    });
                                  },
                                ),
                                SizedBox(height: 20.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SectionTitleWidget(
                                      title:
                                          isDefaultValue
                                              ? 'كليشة فحص نظر'
                                              : 'كليشة شراء نظارة',
                                    ),
                                    SizedBox(height: 10.h),
                                    isDefaultValue
                                        ? InvoiceOptometryWidget(
                                          dist_R_SPH: dist_R_SPH,
                                          dist_R_CYL: dist_R_CYL,
                                          dist_R_AXIS: dist_R_AXIS,
                                          dist_R_V_A: dist_R_V_A,
                                          dist_L_SPH: dist_L_SPH,
                                          dist_L_CYL: dist_L_CYL,
                                          dist_L_AXIS: dist_L_AXIS,
                                          dist_L_V_A: dist_L_V_A,
                                          near_R_SPH: near_R_SPH,
                                          near_R_CYL: near_R_CYL,
                                          near_R_AXIS: near_R_AXIS,
                                          near_R_V_A: near_R_V_A,
                                          near_L_SPH: near_L_SPH,
                                          near_L_CYL: near_L_CYL,
                                          near_L_AXIS: near_L_AXIS,
                                          near_L_V_A: near_L_V_A,
                                          L_P_D: L_P_D,
                                          DR: DR,
                                          invoice_date: invoice_date,
                                          review_date: review_date,
                                        )
                                        : InvoicePurchasesWidget(
                                          onChanged: () => onChanged(),
                                          invoice_date: invoice_date,
                                          frame_type: frame_type,
                                          frame_model: frame_model,
                                          R_SPH: R_SPH,
                                          R_CYL: R_CYL,
                                          R_AXIS: R_AXIS,
                                          R_ADD: R_ADD,
                                          R_CLR: R_CLR,
                                          L_SPH: L_SPH,
                                          L_CYL: L_CYL,
                                          L_AXIS: L_AXIS,
                                          L_ADD: L_ADD,
                                          L_CLR: L_CLR,
                                          total_price: total_price,
                                          paid_price: paid_price,
                                          remaining_price: remaining_price,
                                          delvery_date: delvery_date,
                                        ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ActionButtonWidget(
                          iconPath: Icons.add_circle_outline,
                          title: 'حفظ وتأكيد',
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            addData();
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
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
