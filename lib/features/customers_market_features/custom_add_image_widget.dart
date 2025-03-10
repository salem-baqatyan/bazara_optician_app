import 'dart:io';

import 'package:bazara_optician_app/core/styles/Colors.dart';
import 'package:bazara_optician_app/core/styles/text_style.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAddImageWidget extends StatefulWidget {
  final double containerWidth;
  final double mainContainerHeight;
  final double upContainerHeight;
  final double downContainerHeight;
  final String actionButtonText;
  final String titleText;
  final Function onPressed;
  final bool hasTileButton;
  final String? initialImageUrl; // Add initial image URL
  final File? selectedImage; // <-- Add this parameter
  final VoidCallback onDelete; // Add onDelete callback

  const CustomAddImageWidget({
    super.key,
    this.containerWidth = 100,
    this.mainContainerHeight = 117,
    this.upContainerHeight = 82,
    this.downContainerHeight = 35,
    this.actionButtonText = "إضافة صورة",
    this.titleText = "صورة المنتج",
    required this.onPressed,
    this.hasTileButton = false,
    this.initialImageUrl, // Add initial image URL
    this.selectedImage, // <-- Add this parameter
    required this.onDelete, // Require onDelete callback
  });

  @override
  State<CustomAddImageWidget> createState() => _CustomAddImageWidgetState();
}

class _CustomAddImageWidgetState extends State<CustomAddImageWidget> {
  File? selectedImage;
  String? imageUrl; // Add image URL state

  @override
  void initState() {
    super.initState();
    selectedImage = widget.selectedImage; // Store passed-in image
  }

  @override
  Widget build(BuildContext context) {
    selectedImage = widget.selectedImage;
    return SizedBox(
      width: widget.containerWidth.w,
      height: widget.mainContainerHeight.h,
      child: Column(
        children: [
          ////
          InkWell(
            onTap: () {
              widget.onPressed();
            },
            child: SizedBox(
              width: widget.containerWidth.w,
              height: widget.upContainerHeight.h,
              child: DottedBorder(
                color: AppColors.primary,
                strokeWidth: 1.w,
                dashPattern: const [16, 3],
                child: Container(
                  width: widget.containerWidth.w,
                  height: widget.upContainerHeight.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOpacity,
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                  child: Center(
                    child:
                        selectedImage == null
                            ? imageUrl == null
                                ? widget.hasTileButton
                                    ? SizedBox(
                                      width: 135.w,
                                      height: 40.h,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'إضافة صورة',
                                              textAlign: TextAlign.center,
                                              style: KTextStyle.textStyle14
                                                  .copyWith(
                                                    color: AppColors.white,
                                                  ),
                                            ),
                                            SizedBox(width: 8.0.w),
                                            const Icon(
                                              Icons.add_photo_alternate,
                                              color: AppColors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : Icon(Icons.upload)
                                : Image.network(
                                  imageUrl!,
                                  width: widget.containerWidth.w,
                                  height: widget.upContainerHeight.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return !widget.hasTileButton
                                        ? Icon(Icons.upload)
                                        :
                                        ///////////// need refactoring ////////
                                        SizedBox(
                                          width: 135.w,
                                          height: 40.h,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'إضافة صورة',
                                                  textAlign: TextAlign.center,
                                                  style: KTextStyle.textStyle14
                                                      .copyWith(
                                                        color: AppColors.white,
                                                      ),
                                                ),
                                                SizedBox(width: 8.0.w),
                                                const Icon(
                                                  Icons.add_photo_alternate,
                                                  color: AppColors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                    ///////////// need refactoring ////////
                                  },
                                )
                            : Stack(
                              children: [
                                Image.file(
                                  selectedImage!,
                                  width: widget.containerWidth.w,
                                  height: widget.upContainerHeight.h,
                                  fit: BoxFit.fill,
                                ),
                                if (widget.upContainerHeight <= 82)
                                  Positioned(
                                    top: 2.0,
                                    left: 0.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 4.0,
                                      ),
                                      child: const Icon(
                                        Icons.edit_square,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                    ),
                                  )
                                else
                                  Positioned(
                                    top: 8.0,
                                    left: 8.0,
                                    child: Container(
                                      color: Colors.black54,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 4.0,
                                      ),
                                      child: Text(
                                        'اضغط لتغيير الصورة',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              widget.containerWidth == 100.46
                                                  ? 8.0.sp
                                                  : 12.0.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  top:
                                      widget.upContainerHeight > 82 ? 8.0 : 2.0,
                                  right:
                                      widget.upContainerHeight > 82 ? 8.0 : 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImage = null;
                                        imageUrl = null; // Clear image URL
                                      });
                                      // widget.onDelete(); // Call onDelete callback
                                      widget
                                          .onDelete(); // Notify parent about deletion
                                    },
                                    child: Container(
                                      color:
                                          widget.upContainerHeight > 82
                                              ? Colors.black54
                                              : null,
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size:
                                            widget.upContainerHeight <= 82
                                                ? 15.0
                                                : 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: widget.containerWidth.w,
            height: widget.downContainerHeight.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.redOpacity,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0.r),
                  bottomRight: Radius.circular(10.0.r),
                ),
              ),
              child: Center(
                child: Text(
                  widget.titleText,
                  style: KTextStyle.textStyle14.copyWith(
                    color: AppColors.greyDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
