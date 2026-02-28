import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class DialogHelper {
  static void showLoading(BuildContext context,
      {String message = "Processing..."}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0.r)),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  CustomText(
                    message,
                    size: 16.sp,
                  )
                ],
              ),
            ),
          );
        });
  }

  // static void showLoading({String message = "Processing..."}) {
  //   Get.dialog(
  //     Dialog(
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0.r)),
  //       child: Padding(
  //         padding: EdgeInsets.all(16.r),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             CircularProgressIndicator(),
  //             SizedBox(height: 16.h),
  //             CustomText(
  //               message,
  //               size: 16.sp,
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  static void hideDialog(BuildContext context) {
    if (Get.isDialogOpen!) {
      Navigator.of(context).pop();
    }
  }

  static void showSuccessDialog(
      BuildContext context, String message, bool isHide) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle,
                    color: ColorConstant.primaryColor, size: 40.sp),
                SizedBox(height: 10.h),
                CustomText(
                  "Success",
                  fw: FontWeight.bold,
                  size: 18.sp,
                ),
                SizedBox(height: 5.h),
                CustomText(message, textAlign: TextAlign.center),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (isHide) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: const CustomText("OK", color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showAttentionDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false, // optional but recommended for errors
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning,
                      color: ColorConstant.redColor, size: 40.sp),
                  SizedBox(height: 16.h),
                  CustomText(
                    "Attention",
                    fw: FontWeight.w600,
                    size: 20.sp,
                  ),
                  SizedBox(height: 12.h),
                  CustomText(
                    message,
                    textAlign: TextAlign.center,
                    size: 14.sp,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: const CustomText("OK", color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void showNoticeDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false, // optional but recommended for errors
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline,
                      color: ColorConstant.redColor, size: 40.sp),
                  SizedBox(height: 16.h),
                  CustomText(
                    "Notice",
                    fw: FontWeight.w600,
                    size: 20.sp,
                  ),
                  SizedBox(height: 12.h),
                  CustomText(
                    message,
                    textAlign: TextAlign.center,
                    size: 14.sp,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: const CustomText("OK", color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // static void showNoticeDialog(String message) {
  //   Get.dialog(
  //     Dialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.r),
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.all(16.r),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(Icons.info_outline,
  //                 color: ColorConstant.redColor, size: 40.sp),
  //             SizedBox(height: 16.h),
  //             CustomText(
  //               "Notice",
  //               fw: FontWeight.w600,
  //               size: 20.sp,
  //             ),
  //             SizedBox(height: 12.h),
  //             CustomText(
  //               message,
  //               textAlign: TextAlign.center,
  //               size: 14.sp,
  //             ),
  //             SizedBox(height: 20.h),
  //             SizedBox(
  //               child: ElevatedButton(
  //                 onPressed: () => Get.back(),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: ColorConstant.primaryColor,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8.r),
  //                   ),
  //                 ),
  //                 child: const CustomText("OK", color: Colors.white),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static void showInternetConnectionDialog(
      BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false, // optional but recommended for errors
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off,
                      color: ColorConstant.redColor, size: 40.sp),
                  SizedBox(height: 16.h),
                  CustomText(
                    "No network connection detected",
                    fw: FontWeight.w600,
                    size: 16.sp,
                  ),
                  SizedBox(height: 12.h),
                  CustomText(
                    message,
                    textAlign: TextAlign.center,
                    size: 12.sp,
                    fw: FontWeight.w400,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: const CustomText("OK", color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void showExceptionErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // optional but recommended for errors
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  color: ColorConstant.redColor,
                  size: 48.sp,
                ),
                SizedBox(height: 16.h),
                CustomText(
                  "Error",
                  fw: FontWeight.w600,
                  size: 20.sp,
                ),
                SizedBox(height: 12.h),
                CustomText(
                  message,
                  textAlign: TextAlign.center,
                  size: 14.sp,
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const CustomText(
                      "OK",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showInfoDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false, // optional but recommended for errors
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 50.sp),
                  SizedBox(height: 10.h),
                  CustomText(
                    "Info",
                    fw: FontWeight.bold,
                    size: 18.sp,
                  ),
                  SizedBox(height: 5.h),
                  CustomText(message, textAlign: TextAlign.center),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const CustomText("OK"),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
