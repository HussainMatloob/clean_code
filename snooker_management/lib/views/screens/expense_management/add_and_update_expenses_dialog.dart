import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/expenses_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/edit_able_custom_drop_down.dart';
import '../../../main.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/custom_text_form_field.dart';

class AddAndUpdateExpensesDialog {
  static void showCustomDialog(BuildContext context,
      {bool? isDataAddAble, String? id, double? height, double? width}) {
    mq = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<ExpensesController>(
            init: ExpensesController(),
            builder: (expensesController) {
              return Form(
                key: expensesController.fieldsKey,
                child: Container(
                  decoration: BoxDecoration(color: ColorConstant.whiteColor),
                  padding: EdgeInsets.all(20.r),
                  height: height ?? 800.h,
                  width: width ?? 600.w,
                  child: Column(
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
                                            ? "Add New Expense"
                                            : "Update Expense",
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
                                EditAbleCustomDropDownButton(
                                  dropDownButtonList:
                                      expensesController.expensesNameList,
                                  text: 'Enter or select Expense',
                                  textColor: ColorConstant.hintTextColor,
                                  textSize: 15.sp,
                                  textFw: FontWeight.w400,
                                  dropDownListTextSize: 12.sp,
                                  controller: expensesController,
                                  customFieldController:
                                      expensesController.expenseNameController,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller:
                                      expensesController.descriptionController,
                                  horizontalPadding: 10.w,
                                  labelText: "Description",
                                  validateFunction: expensesController
                                      .expenseDescriptionValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        expensesController.focusNode2);
                                  },
                                  focusNode: expensesController.focusNode1,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller: expensesController
                                      .expenseAmountController,
                                  horizontalPadding: 10.w,
                                  labelText: "Amount",
                                  validateFunction:
                                      expensesController.expenseAmountValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    expensesController.focusNode2.unfocus();
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                  focusNode: expensesController.focusNode2,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  width: 250.w,
                                  controller: expensesController.dateController,
                                  horizontalPadding: 10.w,
                                  labelText: "dd-MM-yyyy",
                                  validateFunction:
                                      expensesController.expenseDateValidate,
                                  icon: Icon(
                                    Icons.event,
                                    color: ColorConstant.hintTextColor,
                                  ),
                                  suffixTapAction: () {
                                    expensesController.selectDate(context,
                                        expensesController.dateController);
                                  },
                                  onTap: () {
                                    expensesController.selectDate(context,
                                        expensesController.dateController);
                                  },
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
                                if (expensesController.fieldsKey.currentState!
                                    .validate()) {
                                  expensesController
                                      .addExpenseFunction(context);
                                }
                              } else {
                                if (expensesController.fieldsKey.currentState!
                                    .validate()) {
                                  expensesController.updateExpenseFunction(
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
                              expensesController.clearAllSelections();
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
