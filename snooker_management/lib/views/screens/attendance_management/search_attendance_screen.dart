import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/attendance_controller.dart';
import 'package:snooker_management/main.dart';

import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';

import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class SearchAttendanceScreen extends StatefulWidget {
  const SearchAttendanceScreen({super.key});

  @override
  State<SearchAttendanceScreen> createState() => _SearchAttendanceScreenState();
}

class _SearchAttendanceScreenState extends State<SearchAttendanceScreen> {
  AttendanceController? attendanceController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      attendanceController = Get.isRegistered<AttendanceController>()
          ? null
          : Get.put(AttendanceController());
      attendanceController!.getEmployeesName(context, "Morning");
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Container(
      width: mq.width,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ColorConstant.linearGradian),
      ),
      child: GetBuilder<AttendanceController>(
        init: Get.isRegistered<AttendanceController>()
            ? null
            : AttendanceController(),
        builder: (attendanceController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: ColorConstant.primaryColor,
                        borderRadius: BorderRadius.circular(50.r)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomButtonWidget(
                          tabAction: () {
                            attendanceController
                                .selectAttendanceReportOption("Daily");
                          },
                          buttonColor: attendanceController
                                      .selectedAttendanceReportOption ==
                                  "Daily"
                              ? ColorConstant.blueColor
                              : Colors.transparent,
                          height: mq.height * 0.04,
                          radius: 50.r,
                          paddingHorizontal: 15,
                          textSize: 12.sp,
                          textFw: FontWeight.w400,
                          text: "Daily",
                        ),
                        CustomButtonWidget(
                          tabAction: () {
                            attendanceController
                                .selectAttendanceReportOption("Weekly");
                          },
                          buttonColor: attendanceController
                                      .selectedAttendanceReportOption ==
                                  "Weekly"
                              ? ColorConstant.blueColor
                              : Colors.transparent,
                          height: mq.height * 0.04,
                          radius: 50.r,
                          paddingHorizontal: 15,
                          textSize: 12.sp,
                          textFw: FontWeight.w400,
                          text: "Weekly",
                        ),
                        CustomButtonWidget(
                          tabAction: () {
                            attendanceController
                                .selectAttendanceReportOption("Monthly");
                          },
                          buttonColor: attendanceController
                                      .selectedAttendanceReportOption ==
                                  "Monthly"
                              ? ColorConstant.blueColor
                              : Colors.transparent,
                          height: mq.height * 0.04,
                          radius: 50.r,
                          paddingHorizontal: 15,
                          textSize: 12.sp,
                          textFw: FontWeight.w400,
                          text: "Monthly",
                        ),
                        CustomButtonWidget(
                          tabAction: () {
                            attendanceController
                                .selectAttendanceReportOption("Yearly");
                          },
                          buttonColor: attendanceController
                                      .selectedAttendanceReportOption ==
                                  "Yearly"
                              ? ColorConstant.blueColor
                              : Colors.transparent,
                          height: mq.height * 0.04,
                          radius: 50.r,
                          paddingHorizontal: 15,
                          textSize: 12.sp,
                          textFw: FontWeight.w400,
                          text: "Yearly",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButtonWidget(
                        sizedBoxWidth: 10.w,
                        tabAction: () async {
                          attendanceController
                              .generateAttendanceReports(context);
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
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: mq.width,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                      color: ColorConstant.primaryColor, width: 10.w),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      width: 200.w,
                      height: mq.height * 0.04,
                      controller: attendanceController.dateController,
                      horizontalPadding: 10.w,
                      labelText: "Date",
                      icon: Icon(
                        Icons.event,
                        color: ColorConstant.hintTextColor,
                      ),
                      suffixTapAction: () {
                        attendanceController.selectDate(
                            context, attendanceController.dateController);
                      },
                      onTap: () {
                        attendanceController.selectDate(
                            context, attendanceController.dateController);
                      },
                      hintTextSize: 12.sp,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomDropDownButton(
                      textSize: 12.sp,
                      textFw: FontWeight.w400,
                      dropDownListTextSize: 12.sp,
                      height: mq.height * 0.04,
                      width: 200.w,
                      text: "Search & generate report",
                      dropDownButtonList:
                          attendanceController.employeesNameList,
                      controller: attendanceController,
                      isShowingCustomNames: true,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    attendanceController.isAttendanceSearching
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: ColorConstant.blueColor),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomButtonWidget(
                                radius: 5.r,
                                height: mq.height * 0.04,
                                paddingHorizontal: 8.w,
                                buttonColor: ColorConstant.blueColor,
                                text: "Search",
                                textSize: 10.sp,
                                tabAction: () async {
                                  if (attendanceController
                                          .dateController.text.isNotEmpty &&
                                      attendanceController.selectedCustomName !=
                                          null) {
                                    attendanceController
                                        .attendanceSearchingProgress(true);
                                    attendanceController
                                        .searchAttendance(context);
                                  }
                                },
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Visibility(
                      visible: attendanceController.searchedAttendance != null,
                      child: Container(
                          width: mq.width,
                          margin: EdgeInsets.only(bottom: 15.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.3), // light gray shadow
                                  offset: const Offset(
                                      3, 3), // right (x), bottom (y)
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                              color: ColorConstant.greenLightColor,
                              borderRadius: BorderRadius.circular(5.r)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      attendanceController.clearAllSelections();
                                      attendanceController.setAttendanceNull();
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Icon(
                                          size: 12.sp,
                                          Icons.cancel,
                                          color: ColorConstant.greyColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    attendanceController
                                            .searchedAttendance?.employeeName ??
                                        "",
                                    fw: FontWeight.w700,
                                    size: 14.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                  CustomText(
                                    attendanceController
                                                .searchedAttendance?.date ==
                                            null
                                        ? ""
                                        : attendanceController.formatDate(
                                            attendanceController
                                                .searchedAttendance!.date!),
                                    fw: FontWeight.w400,
                                    size: 11.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    attendanceController
                                            .searchedAttendance?.shift ??
                                        "",
                                    fw: FontWeight.w400,
                                    size: 11.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                        color: attendanceController
                                                    .searchedAttendance
                                                    ?.status ==
                                                "Present"
                                            ? ColorConstant.dullBlueColor
                                            : attendanceController
                                                        .searchedAttendance
                                                        ?.status ==
                                                    "Absent"
                                                ? ColorConstant.dullRedColor
                                                : ColorConstant.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: CustomText(
                                      attendanceController
                                              .searchedAttendance?.status ??
                                          "",
                                      fw: FontWeight.w400,
                                      size: 11.sp,
                                      color: ColorConstant.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
