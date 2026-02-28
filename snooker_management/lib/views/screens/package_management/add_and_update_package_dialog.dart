import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/package_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import '../../../main.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/custom_text_form_field.dart';

class AddAndUpdatePackageDialog {
  static void showCustomDialog(BuildContext context,
      {bool? isDataAddAble, String? id, double? height, double? width}) {
    mq = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<PackageController>(
            init: PackageController(),
            builder: (packageController) {
              return Form(
                key: packageController.fieldsKey,
                child: Container(
                  decoration: BoxDecoration(color: ColorConstant.whiteColor),
                  padding: EdgeInsets.all(20.r),
                  height: height ?? 800.h,
                  width: width ?? 600.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: CustomText(
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                        isDataAddAble == true
                                            ? "Add New Package"
                                            : "Update Package",
                                        fw: FontWeight.w700,
                                        color: ColorConstant.blackColor,
                                        size: 16.sp,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close,
                                size: 20.sp,
                                color: ColorConstant.blackColor,
                              ))
                        ],
                      ),
                      const Divider(
                        height: 1,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: EdgeInsets.all(30.r),
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  controller:
                                      packageController.packageNameController,
                                  horizontalPadding: 10.w,
                                  labelText: "Package Name",
                                  validateFunction:
                                      packageController.packageNameValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        packageController.focusNode2);
                                  },
                                  focusNode: packageController.focusNode1,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller:
                                      packageController.packagePriceController,
                                  horizontalPadding: 10.w,
                                  labelText: "Package Price",
                                  validateFunction:
                                      packageController.packagePriceValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        packageController.focusNode3);
                                  },
                                  focusNode: packageController.focusNode2,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller: packageController
                                      .packageDescriptionController,
                                  horizontalPadding: 10.w,
                                  labelText: "Description",
                                  validateFunction: packageController
                                      .packageDescriptionValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        packageController.focusNode4);
                                  },
                                  focusNode: packageController.focusNode3,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller: packageController
                                      .packageDurationController,
                                  horizontalPadding: 10.w,
                                  labelText: "Duration",
                                  validateFunction:
                                      packageController.packageDurationValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        packageController.focusNode4);
                                  },
                                  focusNode: packageController.focusNode4,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: ResponsiveHelper.isMobile(context)
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.end,
                        children: [
                          CustomButtonWidget(
                            tabAction: () {
                              if (isDataAddAble == true) {
                                if (packageController.fieldsKey.currentState!
                                    .validate()) {
                                  packageController.addPackageFunction(context);
                                }
                              } else {
                                if (packageController.fieldsKey.currentState!
                                    .validate()) {
                                  packageController.updatePackageFunction(
                                      context, id!);
                                }
                              }
                            },
                            buttonColor: ColorConstant.primaryColor,
                            height: mq.height * 0.05,
                            paddingHorizontal: 15.w,
                            textSize: 14.sp,
                            textFw: FontWeight.w400,
                            textColor: ColorConstant.whiteColor,
                            text: isDataAddAble == true ? "Add" : "Update",
                            radius: 5.r,
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          CustomButtonWidget(
                            tabAction: () {
                              packageController.packageNameController.clear();
                              packageController.packagePriceController.clear();
                              packageController.packageDescriptionController
                                  .clear();
                              packageController.packageDurationController
                                  .clear();
                            },
                            buttonColor: ColorConstant.blueColor,
                            height: mq.height * 0.05,
                            paddingHorizontal: 15.w,
                            textSize: 14.sp,
                            textFw: FontWeight.w400,
                            textColor: ColorConstant.whiteColor,
                            text: "Clear",
                            radius: 5.r,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
