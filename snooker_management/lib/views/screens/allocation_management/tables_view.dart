import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/controller/allocation_controller.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/utils/date_time_utils.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/views/screens/allocation_management/custom_allocation_dialog.dart';
import 'package:snooker_management/views/screens/allocation_management/custom_done_allocation_dialog.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_image_widget.dart';
import 'package:snooker_management/views/widgets/custom_popup_widget.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class TablesView extends StatefulWidget {
  TableDetailModel? tableModel;
  int index;
  TablesView({super.key, this.tableModel, this.index = 0});

  @override
  State<TablesView> createState() => _TablesViewState();
}

class _TablesViewState extends State<TablesView> {
  final AllocationController allocationController =
      Get.put(AllocationController());
  bool isAllocate = false;

  @override
  Widget build(BuildContext context) {
    if (allocationController.allocationsStatus.isNotEmpty) {
      if (widget.tableModel!.tableNumber ==
              allocationController
                  .allocationsStatus[widget.index].tableNumber! &&
          allocationController.allocationsStatus[widget.index].isAllocated!) {
        isAllocate = true;
        allocationController.updateTableTime(
            widget.index.toString(),
            DateTimeUtils.calculateTimeDifference(allocationController
                .allocationsStatus[widget.index].startTime!));
      } else {
        isAllocate = false;
      }
    }
    return AspectRatio(
      aspectRatio: 0.8, // same as childAspectRatio
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () {
              if (isAllocate == false) {
                if (widget.tableModel!.tableNumber ==
                    allocationController
                        .allocationsStatus[widget.index].tableNumber!) {
                  CustomAllocationDialog.showCustomDialog(
                    context,
                    tableModel: widget.tableModel,
                    index: widget.index.toString(),
                    isAddAble: true,
                    allocationController: allocationController,
                  );
                  allocationController.clearAllSelections();
                }
              }
            },
            child: CustomImageWidget(
              isAsset: true,
              width: double.infinity, // fills available grid cell width
              height: double.infinity, // fills available grid cell height
              image: ImageConstant.snookerTable,
              isAllocated: isAllocate,
              tableImage: "tableImage",
              radius: 10.r,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isAllocate
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButtonWidget(
                            tabAction: () {
                              allocationController.clearSelectedDropDownValue();
                              allocationController
                                  .updateSelectedStatus("Pay now");
                              allocationController.setPayedAmount(
                                  allocationController
                                      .allocationsStatus[widget.index]);
                              CustomDoneAllocationDialog.showCustomDialog(
                                context,
                                tableModel: widget.tableModel,
                                cancelAndUpdateAllocationModel:
                                    allocationController
                                        .allocationsStatus[widget.index],
                              );
                            },
                            textColor: ColorConstant.whiteColor,
                            paddingHorizontal: 15.r,
                            height: 30.h,
                            buttonColor: ColorConstant.blueColor,
                            text: "Done",
                            textSize: 10.sp,
                            textFw: FontWeight.w100,
                          ),
                          CustomPopupWidget(
                              playersName: allocationController
                                  .allocationsStatus[widget.index].playersName),
                        ],
                      )
                    : const SizedBox(),
                isAllocate
                    ? Obx(() {
                        String currentTime = allocationController
                                .gameTimes[widget.index.toString()]?.value ??
                            "00:00:00";
                        return CustomText(
                          allocationController.updateTimer(
                              int.parse(widget.tableModel!.tableNumber),
                              currentTime),
                          size: 20.sp,
                          fw: FontWeight.w200,
                          color: ColorConstant.blackColor,
                        );
                      })
                    : const SizedBox(),
                CustomText(
                  widget.tableModel!.tableNumber,
                  size: 20.sp,
                  fw: FontWeight.w700,
                  color: ColorConstant.offWhite,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isAllocate
                        ? CustomButtonWidget(
                            tabAction: () {
                              if (isAllocate == true) {
                                allocationController.clearAllSelections();
                                allocationController
                                    .setValuesForUpdate(widget.index);
                                CustomAllocationDialog.showCustomDialog(context,
                                    tableModel: widget.tableModel,
                                    index: widget.index.toString(),
                                    isAddAble: false,
                                    allocationController: allocationController);
                              }
                            },
                            textColor: ColorConstant.whiteColor,
                            buttonColor: ColorConstant.blackColor,
                            paddingHorizontal: 10.r,
                            height: 30.h,
                            text: "Update",
                            textSize: 10.sp,
                            textFw: FontWeight.w100,
                          )
                        : const SizedBox(),
                    SizedBox(
                      width: 5.w,
                    ),
                    isAllocate
                        ? CustomButtonWidget(
                            tabAction: () {
                              CustomAlertDialog.CustomDialog(
                                  containerHeight: 300.h,
                                  containerWidth: 100.w,
                                  height: 30.h,
                                  context,
                                  text:
                                      "You sure want to cancel this allocation!",
                                  textFw: FontWeight.bold, yesAction: () {
                                if (widget.tableModel!.tableNumber ==
                                    allocationController
                                        .allocationsStatus[widget.index]
                                        .tableNumber!) {
                                  FlushMessagesUtil.easyLoading();
                                  allocationController.cancelAllocation(
                                      widget.tableModel!,
                                      context,
                                      false,
                                      false);
                                }
                              }, noAction: () {
                                Navigator.of(context).pop();
                              });
                            },
                            textColor: ColorConstant.whiteColor,
                            paddingHorizontal: 10.r,
                            height: 30.h,
                            buttonColor: ColorConstant.redColor,
                            text: "Cancel",
                            textSize: 10.sp,
                            textFw: FontWeight.w100,
                          )
                        : const SizedBox(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
