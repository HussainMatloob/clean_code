import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import '../../../controller/employee_controller.dart';
import '../../../main.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/custom_image_selector.dart';
import '../../widgets/custom_text_form_field.dart';

class AddAndUpdateEmployeeDialog {
  static void showCustomDialog(
    BuildContext context, {
    bool? isDataAddAble,
    String? id,
    String? employeeImage,
    String? employeeName,
  }) {
    mq = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<EmployeeController>(
            init: EmployeeController(),
            builder: (employeeController) {
              return Form(
                key: employeeController.fieldsKey,
                child: Container(
                  decoration: BoxDecoration(color: ColorConstant.whiteColor),
                  padding: EdgeInsets.all(20.r),
                  height: 800.h,
                  width: 600.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: CustomText(
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                        isDataAddAble == true
                                            ? "Add New Employee"
                                            : "Update Employee",
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFormField(
                                  controller:
                                      employeeController.employeeNameController,
                                  horizontalPadding: 10.w,
                                  labelText: "Name",
                                  validateFunction:
                                      employeeController.employeeNameValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        employeeController.focusNode2);
                                  },
                                  focusNode: employeeController.focusNode1,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller:
                                      employeeController.employeeNicController,
                                  horizontalPadding: 10.w,
                                  labelText: "NIC",
                                  validateFunction:
                                      employeeController.employeeNicValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        employeeController.focusNode3);
                                  },
                                  focusNode: employeeController.focusNode2,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                    LengthLimitingTextInputFormatter(13),
                                  ],
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller:
                                      employeeController.employeeTypeController,
                                  horizontalPadding: 10.w,
                                  labelText: "Type",
                                  validateFunction:
                                      employeeController.employeeTypeValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        employeeController.focusNode4);
                                  },
                                  focusNode: employeeController.focusNode3,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller: employeeController
                                      .employeeContactController,
                                  horizontalPadding: 10.w,
                                  labelText: "Contact",
                                  validateFunction: employeeController
                                      .employeeContactValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        employeeController.focusNode5);
                                  },
                                  focusNode: employeeController.focusNode4,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller: employeeController
                                      .employeeAddressController,
                                  horizontalPadding: 10.w,
                                  labelText: "Address",
                                  validateFunction: employeeController
                                      .employeeAddressValidate,
                                  onFieldSubmitted: (_) {
                                    employeeController.focusNode5.unfocus();
                                  },
                                  focusNode: employeeController.focusNode5,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomDropDownButton(
                                  height: ResponsiveHelper.isMobile(context)
                                      ? 40.h
                                      : 57.h,
                                  dropDownButtonList: const [
                                    "Morning",
                                    "Evening"
                                  ],
                                  text: 'Select Shift',
                                  textColor: ColorConstant.hintTextColor,
                                  textSize: 15.sp,
                                  textFw: FontWeight.w400,
                                  dropDownListTextSize: 16.sp,
                                  controller: employeeController,
                                  isEmployee: true,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                Row(
                                  children: [
                                    CustomImageSelector(
                                      image: employeeImage,
                                      height: 150.h,
                                      width: 130.w,
                                      icon: Icon(
                                        Icons.image,
                                        size: 50.sp,
                                        color: ColorConstant.greyColor,
                                      ),
                                      color: ColorConstant.greyLightColor,
                                      controller: employeeController,
                                    )
                                  ],
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
                                if (employeeController.fieldsKey.currentState!
                                    .validate()) {
                                  employeeController.addEmployee(context);
                                }
                              } else {
                                if (employeeController.fieldsKey.currentState!
                                    .validate()) {
                                  employeeController.updateEmployee(context,
                                      id!, employeeImage!, employeeName!);
                                }
                              }
                            },
                            buttonColor: ColorConstant.primaryColor,
                            height: mq.height * 0.05,
                            paddingHorizontal: 10.w,
                            textSize: 14.sp,
                            textFw: FontWeight.w400,
                            textColor: ColorConstant.whiteColor,
                            text: isDataAddAble == true ? "Add" : "Update",
                            radius: 5.r,
                          ),
                          SizedBox(
                            width: 20.sp,
                          ),
                          CustomButtonWidget(
                            tabAction: () {
                              employeeController.employeeNameController.text =
                                  "";
                              employeeController.employeeNicController.text =
                                  "";
                              employeeController.employeeTypeController.text =
                                  "";
                              employeeController
                                  .employeeContactController.text = "";
                              employeeController
                                  .employeeAddressController.text = "";
                              employeeController.pickImage(null);
                            },
                            buttonColor: ColorConstant.blueColor,
                            height: mq.height * 0.05,
                            paddingHorizontal: 10.w,
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
