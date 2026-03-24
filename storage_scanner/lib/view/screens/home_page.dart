import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage_scanner/constants/assets_constants.dart';
import 'package:storage_scanner/constants/color_constant.dart';

import 'package:storage_scanner/controller/scan_controller.dart';
import 'package:storage_scanner/core/extension.dart';
import 'package:storage_scanner/utils/permission_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(ScanController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() {
          return Text(
            controller.isScanning.value ? "Scanning..." : "Storage Cleaner",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: ColorConstant
                  .whiteColor, // replace with ColorConstant.whiteColor if defined
            ),
          );
        }),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, // start of gradient
              end: Alignment.bottomRight, // end of gradient
              colors: ColorConstant.appBarLinearGradientColor,
              stops: [0.70, 1.0], // <-- last color only at the very end
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // needed to show gradient
        elevation: 0, // optional: remove shadow
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, // start of gradient
                end: Alignment.bottomRight, // end of gradient
                colors: ColorConstant.backgroundGradientColor,
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  AssetsConstants.storageImage,
                  height: 300.h,
                  width: 300.w,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 40.h),
                Obx(() {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: controller.isScanning.value
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,

                        children: [
                          Visibility(
                            visible: !controller.isScanning.value,
                            child: Container(
                              padding: EdgeInsets.all(5.r),
                              decoration: BoxDecoration(
                                color: ColorConstant.whiteColor,
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: controller.isScanning.value ? 0 : 20.w,
                          ),
                          Text(
                            controller.isScanning.value
                                ? "Scanning Storage..."
                                : "Find Hidden & Large Files",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant
                                  .whiteColor, // replace with ColorConstant.whiteColor if defined
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: controller.isScanning.value
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: !controller.isScanning.value,
                            child: Container(
                              padding: EdgeInsets.all(5.r),
                              decoration: BoxDecoration(
                                color: ColorConstant.whiteColor,
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: controller.isScanning.value ? 0 : 20.w,
                          ),
                          Text(
                            controller.isScanning.value
                                ? "Files Scanned: ${controller.progress.value}%"
                                : "Free Up Your Space",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.whiteColor,
                              // replace with ColorConstant.whiteColor if defined
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  );
                }),

                SizedBox(height: controller.isScanning.value ? 50.h : 100.h),
                //Here should a progress
                Obx(() {
                  if (!controller.isScanning.value) return SizedBox();

                  return Stack(
                    children: [
                      // Background
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF9A8CFF), // lighter start
                              Color(0xFF7A6CF0), // mid
                              Color(0xFFE174FE), // end
                            ],
                          ),
                        ),
                      ),

                      // 🔹 Actual Progress Fill
                      FractionallySizedBox(
                        widthFactor: controller.progress.value / 100,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFFFF59D), //  light yellow progress
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: controller.isScanning.value ? 50.h : 0.h),
                Obx(() {
                  return controller.isScanning.value
                      ? Text(
                          "Please wait...",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.whiteColor,
                            // replace with ColorConstant.whiteColor if defined
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),

                            //  Shadow (bottom-right, deeper purple)
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF5A44E6).withOpacity(0.8),
                                offset: Offset(4, 6),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),

                              //  Gradient Border (lighter first color)
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(
                                    0xFF7A6CF0,
                                  ), //  lighter version of 5A44E6
                                  Color(0xFFE174FE), // end color
                                ],
                              ),
                            ),
                            padding: EdgeInsets.all(2),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),

                                //  Inner Gradient (pink toward top-right)
                                gradient: LinearGradient(
                                  begin: Alignment
                                      .bottomLeft, //  start from opposite
                                  end: Alignment
                                      .topRight, //  push pink to top-right
                                  colors: [
                                    Color(0xFF5A44E6),
                                    Color(0xFFE174FE),
                                  ],
                                  stops: [
                                    0.6,
                                    1.0,
                                  ], //  makes pink more visible at end (top-right)
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () async {
                                    await requestPermission();
                                    controller.startScan();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                      horizontal: 60.w,
                                    ),
                                    child: Text(
                                      "Scan Now",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
