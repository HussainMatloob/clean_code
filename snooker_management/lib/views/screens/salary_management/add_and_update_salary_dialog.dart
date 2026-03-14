import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/salary_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import '../../../main.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/custom_text_form_field.dart';

class AddAndUpdateSalaryDialog {
  static void showCustomDialog(BuildContext context,
      {bool? isDataAddAble, String? id, double? height, double? width}) {
    mq = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<SalaryController>(
            init: SalaryController(),
            builder: (salaryController) {
              return Form(
                key: salaryController.fieldsKey,
                child: Container(
                  decoration: BoxDecoration(color: ColorConstant.whiteColor),
                  padding: EdgeInsets.all(20.r),
                  height: height ?? 600.h,
                  width: width ?? 600.w,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: CustomText(
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                        isDataAddAble == true
                                            ? "Add New Salary"
                                            : "Update Salary",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomDropDownButton(
                                  dropDownButtonList:
                                      salaryController.employeesNameList,
                                  text: 'Select Employee Name',
                                  textColor: ColorConstant.hintTextColor,
                                  isShowingCustomNames: true,
                                  controller: salaryController,
                                  height: ResponsiveHelper.isMobile(context)
                                      ? 40.h
                                      : 57.h,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller: salaryController.employeeSalary,
                                  horizontalPadding: 10.w,
                                  labelText: "Salary",
                                  validateFunction:
                                      salaryController.employeeSalaryValidate,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  fieldEnable: false,
                                  controller: salaryController.shiftController,
                                  horizontalPadding: 10.w,
                                  labelText: "Shift",
                                  textInputAction: TextInputAction.next,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  width: 250.w,
                                  controller: salaryController.dateController,
                                  horizontalPadding: 10.w,
                                  labelText: "dd-MM-yyyy",
                                  validateFunction:
                                      salaryController.salaryDateValidate,
                                  icon: Icon(
                                    Icons.event,
                                    color: ColorConstant.hintTextColor,
                                  ),
                                  suffixTapAction: () {
                                    salaryController.selectDate(context,
                                        salaryController.dateController);
                                  },
                                  onTap: () {
                                    salaryController.selectDate(context,
                                        salaryController.dateController);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButtonWidget(
                            tabAction: () {
                              if (isDataAddAble == true) {
                                if (salaryController.fieldsKey.currentState!
                                    .validate()) {
                                  salaryController.addSalaryFunction(context);
                                }
                              } else {
                                if (salaryController.fieldsKey.currentState!
                                    .validate()) {
                                  salaryController.updateSalaryFunction(
                                      context, id!);
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
                            width: 20.w,
                          ),
                          CustomButtonWidget(
                            tabAction: () {
                              salaryController.clearAllSelections();
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
