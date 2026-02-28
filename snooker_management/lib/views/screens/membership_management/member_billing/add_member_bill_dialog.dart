import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/member_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/member_model.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class AddMemberBillDialog {
  static void showCustomDialog(
    BuildContext context, {
    MemberModel? memberModel,
  }) {
    mq = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<MemberController>(
            init: MemberController(),
            builder: (memberController) {
              return Form(
                key: memberController.fieldsKey,
                child: Container(
                  decoration:
                      BoxDecoration(color: ColorConstant.secondaryColor),
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
                                Container(
                                    margin: EdgeInsets.only(left: 50.w),
                                    child: CustomText(
                                      "Add Member Bill",
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                      size: 16.sp,
                                    )),
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
                                  fieldEnable: false,
                                  horizontalPadding: 10.w,
                                  labelText: "Member Name",
                                  controller:
                                      memberController.memberNameController,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  fieldEnable: false,
                                  horizontalPadding: 10.w,
                                  labelText: "Package Name",
                                  controller: memberController.packageName,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  fieldEnable: false,
                                  horizontalPadding: 10.w,
                                  labelText: "Package Price",
                                  controller: memberController.packagePrice,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  fieldEnable: false,
                                  horizontalPadding: 10.w,
                                  labelText: "Payment Method",
                                  controller:
                                      memberController.paymentMethodController,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  fieldEnable: false,
                                  horizontalPadding: 10.w,
                                  labelText: "Package Duration",
                                  controller: memberController.packageDuration,
                                ),
                                SizedBox(
                                  height: mq.height * 0.02,
                                ),
                                CustomTextFormField(
                                  width: 250.w,
                                  controller:
                                      memberController.billDateController,
                                  horizontalPadding: 10.w,
                                  labelText: "Date",
                                  validateFunction:
                                      memberController.memberBillDateValidate,
                                  icon: Icon(
                                    Icons.event,
                                    color: ColorConstant.hintTextColor,
                                  ),
                                  suffixTapAction: () {
                                    memberController.selectDate(context,
                                        memberController.billDateController);
                                  },
                                  onTap: () {
                                    memberController.selectDate(context,
                                        memberController.billDateController);
                                  },
                                ),
                                SizedBox(
                                  height: mq.height * 0.02,
                                ),
                                CustomText(
                                  "Update Member Plan",
                                  fw: FontWeight.w700,
                                  color: ColorConstant.blackColor,
                                ),
                                SizedBox(
                                  height: mq.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    CustomTextFormField(
                                      width: 250.w,
                                      controller:
                                          memberController.startDateController,
                                      horizontalPadding: 10.w,
                                      labelText: "Start Date",
                                      validateFunction: memberController
                                          .memberStartDateValidate,
                                      icon: Icon(
                                        Icons.event,
                                        color: ColorConstant.hintTextColor,
                                      ),
                                      suffixTapAction: () {
                                        memberController.selectDate(
                                            context,
                                            memberController
                                                .startDateController);
                                      },
                                      onTap: () {
                                        memberController.selectDate(
                                            context,
                                            memberController
                                                .startDateController);
                                      },
                                    ),
                                    SizedBox(
                                      width: mq.height * 0.04,
                                    ),
                                    CustomTextFormField(
                                      width: 250.w,
                                      controller:
                                          memberController.endDateController,
                                      horizontalPadding: 10.w,
                                      labelText: "End Date",
                                      validateFunction: memberController
                                          .memberEndDateValidate,
                                      icon: Icon(
                                        Icons.event,
                                        color: ColorConstant.hintTextColor,
                                      ),
                                      suffixTapAction: () {
                                        memberController.selectDate(context,
                                            memberController.endDateController);
                                      },
                                      onTap: () {
                                        memberController.selectDate(context,
                                            memberController.endDateController);
                                      },
                                    ),
                                  ],
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButtonWidget(
                            tabAction: () {
                              if (memberController.fieldsKey.currentState!
                                  .validate()) {
                                memberController.addMemberBillFunction(
                                    context, memberModel!);
                              }
                            },
                            buttonColor: ColorConstant.primaryColor,
                            height: mq.height * 0.05,
                            width: mq.height * 0.14,
                            textSize: 14.sp,
                            textFw: FontWeight.w400,
                            textColor: ColorConstant.whiteColor,
                            text: "Add",
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
