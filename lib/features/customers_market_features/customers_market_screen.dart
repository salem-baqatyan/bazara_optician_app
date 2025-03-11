import 'dart:io';
import 'package:bazara_optician_app/core/shered_widget/action_button_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/custom_app_bar.dart';
import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:bazara_optician_app/features/customers_market_features/custom_add_image_widget.dart';
import 'package:bazara_optician_app/core/shered_widget/info_rich_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late TextEditingController detailsAds = TextEditingController();
  File? mainImage; // استخدام صورة واحدة فقط

  Future pickImageFromGallery({bool isMainImage = false}) async {
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (returnImage == null) return;
    setState(() {
      mainImage = File(returnImage.path); // تحديد الصورة مباشرة
    });
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
                CustomAppBar(tital: 'تسويق الى العملاء'),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.maxFinite,
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          CustomAddImageWidget(
                            selectedImage:
                                mainImage, // استخدم الصورة الواحدة فقط
                            hasTileButton: true,
                            containerWidth: 400,
                            mainContainerHeight: 300,
                            upContainerHeight: 250,
                            downContainerHeight: 35,
                            onPressed: () {
                              pickImageFromGallery(isMainImage: true);
                            },
                            onDelete: () {
                              setState(() {
                                mainImage = null; // مسح الصورة
                              });
                            },
                          ),
                          SizedBox(height: 20.h),
                          CustomTextFormWidget(
                            textController: detailsAds,
                            text: 'وصف الاعلان',
                            width: 350.w,
                            height: 150.h,
                            maxLines: 5,
                          ),
                          SizedBox(height: 20.h),
                          ActionButtonWidget(
                            isSolid: false,
                            iconPath: Icons.share,
                            title: 'مشاركة',
                            width: 150.w,
                            onTap: () async {
                              // التحقق إذا كانت الصورة أو النص موجودين
                              if (mainImage != null ||
                                  detailsAds.text.isNotEmpty) {
                                try {
                                  // إذا كانت الصورة موجودة، سيتم مشاركة الصورة مع النص
                                  if (mainImage != null &&
                                      detailsAds.text.isNotEmpty) {
                                    await Share.shareXFiles([
                                      XFile(mainImage!.path),
                                    ], text: detailsAds.text);
                                  }
                                  // إذا كانت الصورة فقط موجودة
                                  else if (mainImage != null) {
                                    await Share.shareXFiles([
                                      XFile(mainImage!.path),
                                    ]);
                                  }
                                  // إذا كان النص فقط موجودًا
                                  else if (detailsAds.text.isNotEmpty) {
                                    await Share.share(detailsAds.text);
                                  }
                                } catch (e) {
                                  // إذا فشل أي شيء في المشاركة
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("حدث خطأ أثناء المشاركة."),
                                    ),
                                  );
                                }
                              } else {
                                // إذا لم يكن هناك صورة أو نص
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "يرجى اختيار صورة أو كتابة نص للإعلان أولاً.",
                                    ),
                                  ),
                                );
                              }
                            },
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
}
