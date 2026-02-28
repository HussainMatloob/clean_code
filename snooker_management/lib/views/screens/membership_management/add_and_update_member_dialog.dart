import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/member_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_radio_button.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import '../../../main.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/custom_image_selector.dart';
import '../../widgets/custom_text_form_field.dart';

class AddAndUpdateMemberDialog {
  static void showCustomDialog(
    BuildContext context, {
    bool? isDataAddAble,
    String? id,
    String? memberImage,
    String? memberName,
  }) {
    mq = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<MemberController>(
            init: MemberController(),
            builder: (memberController) {
              final children = [
                CustomTextFormField(
                  width: 200.w,
                  fieldEnable: false,
                  controller: memberController.packagePrice,
                  horizontalPadding: 10.w,
                  labelText: "Package Price",
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  ],
                ),
                ResponsiveHelper.isDesktop(context)
                    ? SizedBox(
                        width: mq.width * 0.02,
                      )
                    : SizedBox(
                        height: mq.height * 0.04,
                      ),
                CustomTextFormField(
                  width: 200.w,
                  fieldEnable: false,
                  controller: memberController.packageDuration,
                  horizontalPadding: 10.w,
                  labelText: "Package Duration",
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  ],
                ),
              ];
              return Form(
                key: memberController.fieldsKey,
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: CustomText(
                                        textOverflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        isDataAddAble == true
                                            ? "Add New Member"
                                            : "Update Member",
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
                                      memberController.memberNameController,
                                  horizontalPadding: 10.w,
                                  labelText: "Member Name",
                                  validateFunction:
                                      memberController.memberNameValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        memberController.focusNode2);
                                  },
                                  focusNode: memberController.focusNode1,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller:
                                      memberController.memberContactController,
                                  horizontalPadding: 10.w,
                                  labelText: "Contact",
                                  validateFunction:
                                      memberController.memberContactValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        memberController.focusNode3);
                                  },
                                  focusNode: memberController.focusNode2,
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
                                  controller:
                                      memberController.memberAddressController,
                                  horizontalPadding: 10.w,
                                  labelText: "Address",
                                  validateFunction:
                                      memberController.memberAddressValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        memberController.focusNode4);
                                  },
                                  focusNode: memberController.focusNode3,
                                ),

                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller:
                                      memberController.memberNICController,
                                  horizontalPadding: 10.w,
                                  labelText: "NIC",
                                  validateFunction:
                                      memberController.memberNicValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        memberController.focusNode5);
                                  },
                                  focusNode: memberController.focusNode4,
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
                                      memberController.discountController,
                                  horizontalPadding: 10.w,
                                  labelText: "Discount",
                                  validateFunction:
                                      memberController.discountValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    memberController.focusNode5.unfocus();
                                  },
                                  focusNode: memberController.focusNode5,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                ),
                                SizedBox(
                                  height: mq.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    CustomRadioButton(
                                      status: "Unblock",
                                      controller: memberController,
                                    ),
                                    SizedBox(
                                      width: mq.width * 0.01,
                                    ),
                                    CustomRadioButton(
                                      status: "Block",
                                      controller: memberController,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomDropDownButton(
                                  dropDownButtonList:
                                      memberController.packagesNameList,
                                  text: 'Select Package',
                                  textColor: ColorConstant.hintTextColor,
                                  textSize: 15.sp,
                                  textFw: FontWeight.w400,
                                  dropDownListTextSize: 16.sp,
                                  controller: memberController,
                                  height: ResponsiveHelper.isMobile(context)
                                      ? 48.h
                                      : 57.h,
                                ),

                                // ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  width: 250.w,
                                  controller:
                                      memberController.startDateController,
                                  horizontalPadding: 10.w,
                                  labelText: "Start Date",
                                  validateFunction:
                                      memberController.memberStartDateValidate,
                                  icon: Icon(
                                    Icons.event,
                                    color: ColorConstant.hintTextColor,
                                  ),
                                  suffixTapAction: () {
                                    memberController.selectDate(context,
                                        memberController.startDateController);
                                  },
                                  onTap: () {
                                    memberController.selectDate(context,
                                        memberController.startDateController);
                                  },
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  width: 250.w,
                                  controller:
                                      memberController.endDateController,
                                  horizontalPadding: 10.w,
                                  labelText: "End Date",
                                  validateFunction:
                                      memberController.memberEndDateValidate,
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
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                Visibility(
                                  visible:
                                      !ResponsiveHelper.isMobile(context) &&
                                          !ResponsiveHelper.isTablet(context),
                                  child: Row(
                                    children: children,
                                  ),
                                ),
                                Visibility(
                                  visible: ResponsiveHelper.isMobile(context),
                                  child: Column(
                                    children: children,
                                  ),
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                Row(
                                  children: [
                                    CustomImageSelector(
                                      image: memberImage,
                                      height: 150.h,
                                      width: 130.w,
                                      icon: Icon(
                                        Icons.image,
                                        size: 50.sp,
                                        color: ColorConstant.greyColor,
                                      ),
                                      color: ColorConstant.greyLightColor,
                                      controller: memberController,
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
                                if (memberController.fieldsKey.currentState!
                                    .validate()) {
                                  memberController.addMember(context);
                                }
                              } else {
                                if (memberController.fieldsKey.currentState!
                                    .validate()) {
                                  memberController.updateMember(
                                      context, id!, memberImage!, memberName!);
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
                              memberController.memberNameController.clear();
                              memberController.memberContactController.clear();
                              memberController.memberAddressController.clear();
                              memberController.memberNICController.clear();
                              memberController.startDateController.clear();
                              memberController.endDateController.clear();
                              memberController.pickImage(null);
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
