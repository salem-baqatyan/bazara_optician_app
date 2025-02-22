import 'package:bazara_optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:bazara_optician_app/features/second_features/widgets/add_from_contacts_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/invoice_body_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/info_text_field_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/section_title_widget.dart';
import 'package:bazara_optician_app/features/second_features/widgets/type_radio_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewInvoiceScreen extends StatefulWidget {
  const NewInvoiceScreen({super.key});

  @override
  State<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();

  TextEditingController nameConroller = TextEditingController();
  TextEditingController phoneConroller = TextEditingController();
  int invoiceType = 1;
  final ValueNotifier<int> discountRateNotifier = ValueNotifier<int>(10);
  final ValueNotifier<int> numberToBuyNotifier = ValueNotifier<int>(2);
  final ValueNotifier<int> numberToGetNotifier = ValueNotifier<int>(1);

  String selectedOption = 'Optometry';
  bool isDiscountDefaultValue = true;

  // Default values for bonus configuration
  int discountRate = 10; // Default "Percent Rate" value
  int numberToBuy = 2; // Default "Buy X" value
  int numberToGet = 1; // Default "Get Y" value

  List<Map<String, dynamic>> listProduct = [];

  @override
  void initState() {
    super.initState();
    isDiscountDefaultValue = selectedOption == 'Optometry';
    discountRateNotifier.value = discountRate;
    numberToBuyNotifier.value = numberToBuy;
    numberToGetNotifier.value = numberToGet;
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
                                        nameConroller = TextEditingController(
                                          text: contact!.fullName ?? 'No name',
                                        );
                                        phoneConroller = TextEditingController(
                                          text:
                                              contact.phoneNumbers?.first ??
                                              'No phone',
                                        );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                    InfoTextFieldWidget(
                                      title: 'اسم العميل',
                                      controller: nameConroller,
                                      keyboardType: TextInputType.text,
                                    ),
                                    SizedBox(height: 20.h),
                                    InfoTextFieldWidget(
                                      title: 'رقم العميل',
                                      controller: phoneConroller,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40.h),
                                TypeRadioWidget(
                                  selectedOption: selectedOption,
                                  onChangedDiscount: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                      isDiscountDefaultValue = true;
                                      invoiceType = 1;
                                    });
                                  },
                                  onChangedBouns: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                      isDiscountDefaultValue = false;
                                      invoiceType = 2;
                                    });
                                  },
                                ),
                                SizedBox(height: 40.h),
                                InvoiceBodyWidget(
                                  isDefaultValue: isDiscountDefaultValue,
                                  discountRate: discountRate,
                                  numberToBuy: numberToBuy,
                                  numberToGet: numberToGet,
                                  onDiscountRateChanged: (newRate) {
                                    setState(() {
                                      discountRateNotifier.value = newRate;
                                    });
                                  },
                                  onNumberToBuyChanged: (newBuysCount) {
                                    setState(() {
                                      numberToBuyNotifier.value = newBuysCount;
                                    });
                                  },
                                  onNumberToGetChanged: (newNumberToGet) {
                                    setState(() {
                                      numberToGetNotifier.value =
                                          newNumberToGet;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
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
