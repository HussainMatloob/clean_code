import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/allocation_controller.dart';
import 'package:snooker_management/models/cancel_update_allocation_model.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/utils/date_time_utils.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_radio_button.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class CustomDoneAllocationDialog {
  static void showCustomDialog(
    BuildContext context, {
    TableDetailModel? tableModel,
    CancelAndUpdateAllocationModel? cancelAndUpdateAllocationModel,
  }) {
    final GlobalKey<FormState> fieldsKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<AllocationController>(
            init: AllocationController(),
            builder: (allocationController) {
              return Form(
                key: fieldsKey,
                child: Container(
                  decoration: BoxDecoration(color: ColorConstant.whiteColor),
                  padding: EdgeInsets.all(20.r),
                  height: 650.h,
                  width: 400.w,
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
                                      "Table ${tableModel!.tableNumber}",
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
                                size: 15.sp,
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
                                Row(
                                  children: [
                                    CustomRadioButton(
                                      status: "Pay now",
                                      controller: allocationController,
                                      isAllocation: true,
                                    ),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    CustomRadioButton(
                                      status: "Move to sale",
                                      controller: allocationController,
                                      isAllocation: true,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomDropDownButton(
                                  dropDownButtonList:
                                      cancelAndUpdateAllocationModel!
                                          .playersName,
                                  text: 'Select Looser Name',
                                  textColor: ColorConstant.hintTextColor,
                                  textSize: 14.sp,
                                  textFw: FontWeight.w400,
                                  dropDownListTextSize: 14.sp,
                                  controller: allocationController,
                                  isShowingCustomNames: true,
                                ),
                                allocationController.selectedStatus == "Pay now"
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          CustomText(
                                            "Table Number: ${cancelAndUpdateAllocationModel.tableNumber}",
                                            size: 14.sp,
                                            fw: FontWeight.w400,
                                            color: ColorConstant.blackColor,
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          CustomText(
                                            "Game Type: ${cancelAndUpdateAllocationModel.gameType}",
                                            size: 14.sp,
                                            fw: FontWeight.w400,
                                            color: ColorConstant.blackColor,
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          CustomText(
                                            "Start Time: ${DateTimeUtils.extractTimeFromTimestamp(cancelAndUpdateAllocationModel.startTime!)}",
                                            size: 14.sp,
                                            fw: FontWeight.w400,
                                            color: ColorConstant.blackColor,
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          CustomText(
                                            "End Time: ${DateTimeUtils.getCurrentTime()}",
                                            size: 14.sp,
                                            fw: FontWeight.w400,
                                            color: ColorConstant.blackColor,
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          CustomText(
                                            "Total Time: ${DateTimeUtils.calculateTimeDifference(cancelAndUpdateAllocationModel.startTime!)}",
                                            size: 14.sp,
                                            fw: FontWeight.w400,
                                            color: ColorConstant.blackColor,
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomText(
                                  "Total Amount: ${cancelAndUpdateAllocationModel.tablePrice}",
                                  size: 14.sp,
                                  fw: FontWeight.w400,
                                  color: ColorConstant.blackColor,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomText(
                                  "Discount: ${allocationController.memberModel?.discount ?? "0.0"}",
                                  size: 14.sp,
                                  fw: FontWeight.w400,
                                  color: ColorConstant.blackColor,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextFormField(
                                  controller:
                                      allocationController.saleAmountController,
                                  horizontalPadding: 10.w,
                                  labelText: "Final Amount",
                                  validateFunction: allocationController
                                      .saleAmountValidateValidate,
                                  textInputAction: TextInputAction.next,
                                  hintTextSize: 14.sp,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
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
                              String startTime =
                                  DateTimeUtils.extractTimeFromTimestamp(
                                      cancelAndUpdateAllocationModel
                                          .startTime!);
                              String endTime = DateTimeUtils.getCurrentTime();
                              String totalTime =
                                  DateTimeUtils.calculateTimeDifference(
                                      cancelAndUpdateAllocationModel
                                          .startTime!);
                              if (fieldsKey.currentState!.validate()) {
                                allocationController.doneAllocation(
                                    context,
                                    cancelAndUpdateAllocationModel,
                                    tableModel,
                                    startTime,
                                    endTime,
                                    totalTime);
                              }
                            },
                            buttonColor: ColorConstant.primaryColor,
                            height: 40.h,
                            width: 80.w,
                            textSize: 12.sp,
                            textFw: FontWeight.w400,
                            textColor: ColorConstant.whiteColor,
                            text: "Done",
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
