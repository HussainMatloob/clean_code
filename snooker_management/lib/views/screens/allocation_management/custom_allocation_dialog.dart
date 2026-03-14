import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/allocation_controller.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_radio_button.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/edit_able_custom_drop_down.dart';

class CustomAllocationDialog {
  static void showCustomDialog(
    BuildContext context, {
    TableDetailModel? tableModel,
    String? index,
    bool? isAddAble,
    required AllocationController
        allocationController, // pass existing controller
  }) {
    final GlobalKey<FormState> fieldsKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<AllocationController>(
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
                              children: [
                                MediaQuery.of(context).size.width < 350
                                    ? Column(
                                        children: [
                                          CustomRadioButton(
                                            status: "Single",
                                            controller: allocationController,
                                            isAllocation: true,
                                          ),
                                          SizedBox(
                                            width: 10.h,
                                          ),
                                          CustomRadioButton(
                                            status: "Double",
                                            controller: allocationController,
                                            isAllocation: true,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          CustomRadioButton(
                                            status: "Single",
                                            controller: allocationController,
                                            isAllocation: true,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          CustomRadioButton(
                                            status: "Double",
                                            controller: allocationController,
                                            isAllocation: true,
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                EditAbleCustomDropDownButton(
                                  dropDownButtonList:
                                      allocationController.membersNameList,
                                  text: "Player Name",
                                  textColor: ColorConstant.hintTextColor,
                                  textSize: 15.sp,
                                  textFw: FontWeight.w400,
                                  dropDownListTextSize: 12.sp,
                                  controller: allocationController,
                                  customFieldController:
                                      allocationController.player1,
                                  isAllocation: true,
                                  hintTextSize: 12.sp,
                                ),
                                SizedBox(
                                  height: allocationController.selectedStatus ==
                                          "Single"
                                      ? 0.h
                                      : 20.h,
                                ),
                                allocationController.selectedStatus == "Single"
                                    ? const SizedBox()
                                    : EditAbleCustomDropDownButton(
                                        dropDownButtonList: allocationController
                                            .membersNameList,
                                        text: "Player Name",
                                        textColor: ColorConstant.hintTextColor,
                                        textSize: 15.sp,
                                        textFw: FontWeight.w400,
                                        dropDownListTextSize: 12.sp,
                                        controller: allocationController,
                                        customFieldController:
                                            allocationController.player2,
                                        isAllocation: true,
                                        hintTextSize: 12.sp,
                                      ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomText(
                                  "Vs",
                                  fw: FontWeight.w700,
                                  color: ColorConstant.blackColor,
                                  size: 14.sp,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                EditAbleCustomDropDownButton(
                                  dropDownButtonList:
                                      allocationController.membersNameList,
                                  text: "Player Name",
                                  textColor: ColorConstant.hintTextColor,
                                  textSize: 15.sp,
                                  textFw: FontWeight.w400,
                                  dropDownListTextSize: 12.sp,
                                  controller: allocationController,
                                  customFieldController:
                                      allocationController.player3,
                                  isAllocation: true,
                                  hintTextSize: 12.sp,
                                ),
                                SizedBox(
                                  height: allocationController.selectedStatus ==
                                          "Single"
                                      ? 0.h
                                      : 20.h,
                                ),
                                allocationController.selectedStatus == "Single"
                                    ? const SizedBox()
                                    : EditAbleCustomDropDownButton(
                                        dropDownButtonList: allocationController
                                            .membersNameList,
                                        text: "Player Name",
                                        textColor: ColorConstant.hintTextColor,
                                        textSize: 15.sp,
                                        textFw: FontWeight.w400,
                                        dropDownListTextSize: 12.sp,
                                        controller: allocationController,
                                        customFieldController:
                                            allocationController.player4,
                                        isAllocation: true,
                                        hintTextSize: 12.sp,
                                      ),
                                SizedBox(
                                  height: 10.h,
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
                              if (fieldsKey.currentState!.validate()) {
                                FlushMessagesUtil.easyLoading();
                                allocationController.updateAllocation(
                                    tableModel,
                                    context,
                                    true,
                                    index!,
                                    isAddAble!);
                              }
                            },
                            buttonColor: ColorConstant.primaryColor,
                            height: 40.h,
                            paddingHorizontal: 10.w,
                            textSize: 12.sp,
                            textFw: FontWeight.w400,
                            textColor: ColorConstant.whiteColor,
                            text: isAddAble == true ? "Allocate" : "Update",
                            radius: 5.r,
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          CustomButtonWidget(
                            tabAction: () {
                              allocationController.clearAllSelections();
                            },
                            buttonColor: ColorConstant.blueColor,
                            height: 40.h,
                            paddingHorizontal: 10.w,
                            textSize: 12.sp,
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
