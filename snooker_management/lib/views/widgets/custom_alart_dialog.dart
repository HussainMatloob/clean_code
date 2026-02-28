import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:snooker_management/views/widgets/custom_button_widget.dart';

import 'package:snooker_management/views/widgets/custom_text.dart';

import '../../constants/color_constants.dart';

class CustomAlertDialog {
  static void CustomDialog(
    BuildContext context, {
    double? height,
    double? width,
    double? containerHeight,
    double? containerWidth,
    VoidCallback? yesAction,
    VoidCallback? noAction,
    String? text,
    FontWeight? textFw,
    Color? textColor,
    String? id,
    String? buttonText,
    bool isLogoUpdate = false,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
            child: Container(
              padding: EdgeInsets.all(20.r),
              height: containerHeight ?? 150.h,
              width: containerWidth ?? 100.w,
              decoration: BoxDecoration(
                //color: ColorConstant.whiteColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.warning,
                      color: ColorConstant.redColor, size: 30.sp),
                  SizedBox(height: 20.h),
                  CustomText(
                    "Attention",
                    fw: FontWeight.bold,
                    size: 18.sp,
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomText(
                              text,
                              fw: textFw,
                              size: 12.sp,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(height: 35.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtonWidget(
                          text: "Yes",
                          height: height ?? 50.h,
                          width: width ?? 60.w,
                          buttonColor: ColorConstant.redColor,
                          tabAction: yesAction),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustomButtonWidget(
                          text: "No",
                          height: height ?? 50.h,
                          width: width ?? 60.w,
                          buttonColor: ColorConstant.blueColor,
                          tabAction: noAction),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
