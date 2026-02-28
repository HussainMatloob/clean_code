import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/allocation_controller.dart';

import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';

import '../../widgets/custom_drop_down_button.dart';

class ReportGeneratorView extends StatefulWidget {
  final String? snookerLogo;
  const ReportGeneratorView({super.key, this.snookerLogo});

  @override
  State<ReportGeneratorView> createState() => _ReportGeneratorViewState();
}

class _ReportGeneratorViewState extends State<ReportGeneratorView> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    bool isMobileOrTablet = ResponsiveHelper.isTablet(context) ||
        ResponsiveHelper.isMobile(context);

    // Wrap children in a list to reuse for both Column and Row
    final children = [
      GetBuilder<AllocationController>(
          init: AllocationController(),
          builder: (allocationController) {
            return CustomDropDownButton(
              dropDownButtonList: allocationController.tablesNumberList,
              text: 'Select Table Number',
              height: mq.height * 0.04,
              textColor: ColorConstant.hintTextColor,
              textSize: isMobileOrTablet ? 11.sp : 12.sp,
              textFw: FontWeight.w400,
              dropDownListTextSize: isMobileOrTablet ? 11.sp : 12.sp,
              controller: allocationController,
              isMonthsOrTables: true,
              isTableNumber: true,
            );
          }),
      SizedBox(width: 20.w, height: 20.h),
      GetBuilder<AllocationController>(
          init: AllocationController(),
          builder: (allocationController) {
            return Container(
              decoration: BoxDecoration(
                color: ColorConstant.primaryColor,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButtonWidget(
                    tabAction: () {
                      allocationController
                          .selectAllocationReportOption("Daily");
                    },
                    buttonColor:
                        allocationController.selectedAllocationReportOption ==
                                "Daily"
                            ? ColorConstant.blueColor
                            : Colors.transparent,
                    height: mq.height * 0.04,
                    paddingHorizontal: 15,
                    radius: 50.r,
                    textSize: 12.sp,
                    textFw: FontWeight.w400,
                    text: "Daily",
                  ),
                  CustomButtonWidget(
                    tabAction: () {
                      allocationController
                          .selectAllocationReportOption("Weekly");
                    },
                    buttonColor:
                        allocationController.selectedAllocationReportOption ==
                                "Weekly"
                            ? ColorConstant.blueColor
                            : Colors.transparent,
                    height: mq.height * 0.04,
                    radius: 50.r,
                    textSize: 12.sp,
                    textFw: FontWeight.w400,
                    text: "Weekly",
                    paddingHorizontal: 15,
                  ),
                  CustomButtonWidget(
                    tabAction: () {
                      allocationController
                          .selectAllocationReportOption("Monthly");
                    },
                    buttonColor:
                        allocationController.selectedAllocationReportOption ==
                                "Monthly"
                            ? ColorConstant.blueColor
                            : Colors.transparent,
                    height: mq.height * 0.04,
                    radius: 50.r,
                    textSize: 12.sp,
                    textFw: FontWeight.w400,
                    text: "Monthly",
                    paddingHorizontal: 15,
                  )
                ],
              ),
            );
          }),
      SizedBox(width: 20.w, height: 20.h),
      GetBuilder<AllocationController>(
          init: AllocationController(),
          builder: (allocationController) {
            return Row(
              children: [
                CustomButtonWidget(
                  sizedBoxWidth: 10.w,
                  tabAction: () async {
                    allocationController.generateAllocationReports(context);
                  },
                  buttonColor: ColorConstant.blueColor,
                  height: mq.height * 0.04,
                  paddingHorizontal: 13.w,
                  textSize: 12.sp,
                  textFw: FontWeight.w400,
                  textColor: ColorConstant.whiteColor,
                  text: "Export to pdf",
                  radius: 5.r,
                  icon: Icon(
                    size: 12.sp,
                    Icons.picture_as_pdf,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.w, height: 10.h),
                CustomButtonWidget(
                  radius: 5.r,
                  height: mq.height * 0.04,
                  paddingHorizontal: 10.w,
                  buttonColor: ColorConstant.blueColor,
                  sizedBoxWidth: 4.w,
                  text: "Clear",
                  textSize: 12.sp,
                  tabAction: () {
                    allocationController.clearSelections();
                  },
                ),
              ],
            );
          }),
    ];

    return isMobileOrTablet
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          );
  }
}
