import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/attendance_controller.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';

import 'package:snooker_management/views/screens/attendance_management/attendance_table_row.dart';
import 'package:snooker_management/views/screens/attendance_management/attendance_table_view.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class AttendanceScreen extends StatefulWidget {
  final String? snookerLogo;
  const AttendanceScreen({super.key, this.snookerLogo});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  AttendanceController attendanceController = Get.put(AttendanceController());
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      attendanceController.clearEmployeesNameList();
      attendanceController.clearAllSelections();
      attendanceController.getEmployeesName(context, "Morning");
      attendanceController.setEmployeeShift("Morning");
      attendanceController.getAttendance(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<AttendanceController>(
      builder: (attendanceController) {
        return Container(
          decoration: BoxDecoration(
            color: ColorConstant.secondaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // subtle shadow
                offset: const Offset(2, 2), // 2 right, 2 bottom
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        left: 30.w, right: 30.w, top: 30.h, bottom: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: !ResponsiveHelper.isTablet(context) &&
                              !ResponsiveHelper.isMobile(context),
                          child: Row(
                            children: [
                              CustomDropDownButton(
                                  height: mq.height * 0.05,
                                  width: 200.w,
                                  isEmployee: true,
                                  dropDownButtonList: const [
                                    "Morning",
                                    "Evening"
                                  ],
                                  controller: attendanceController),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.isTablet(context) ||
                                  ResponsiveHelper.isMobile(context)
                              ? 8.h
                              : 20.h,
                        ),
                        ResponsiveHelper.isMobile(context)
                            ? GestureDetector(
                                onTap: () {
                                  context.go('/app/searchAttendance');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  width: mq.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: ColorConstant.greenLightColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        size: 20.sp,
                                        Icons.search,
                                        color: ColorConstant.greyColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: ColorConstant.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(50.r)),
                                        child: Row(
                                          children: [
                                            CustomButtonWidget(
                                              tabAction: () {
                                                attendanceController
                                                    .selectAttendanceReportOption(
                                                        "Daily");
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
                                                    .selectAttendanceReportOption(
                                                        "Weekly");
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
                                                    .selectAttendanceReportOption(
                                                        "Monthly");
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
                                                    .selectAttendanceReportOption(
                                                        "Yearly");
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
                                        width: 20.w,
                                      ),
                                      CustomButtonWidget(
                                        sizedBoxWidth: 10.w,
                                        tabAction: () async {
                                          attendanceController
                                              .generateAttendanceReports(
                                                  context);
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
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(20.r),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        border: Border.all(
                                            color: ColorConstant.primaryColor,
                                            width: 10.w)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            CustomTextFormField(
                                              width: 200.w,
                                              height: mq.height * 0.04,
                                              controller: attendanceController
                                                  .dateController,
                                              horizontalPadding: 10.w,
                                              labelText: "Date",
                                              icon: Icon(
                                                Icons.event,
                                                color:
                                                    ColorConstant.hintTextColor,
                                              ),
                                              suffixTapAction: () {
                                                attendanceController.selectDate(
                                                    context,
                                                    attendanceController
                                                        .dateController);
                                              },
                                              onTap: () {
                                                attendanceController.selectDate(
                                                    context,
                                                    attendanceController
                                                        .dateController);
                                              },
                                              hintTextSize: 12.sp,
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            CustomDropDownButton(
                                              textSize: 12.sp,
                                              textFw: FontWeight.w400,
                                              dropDownListTextSize: 12.sp,
                                              height: mq.height * 0.04,
                                              width: 200.w,
                                              text: "Search & generate report",
                                              dropDownButtonList:
                                                  attendanceController
                                                      .employeesNameList,
                                              controller: attendanceController,
                                              isShowingCustomNames: true,
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            attendanceController
                                                    .isAttendanceSearching
                                                ? SizedBox(
                                                    height: 30.h,
                                                    width: 30.w,
                                                    child:
                                                        CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: ColorConstant
                                                                .blueColor),
                                                  )
                                                : CustomButtonWidget(
                                                    radius: 5.r,
                                                    height: mq.height * 0.04,
                                                    paddingHorizontal: 8.w,
                                                    buttonColor:
                                                        ColorConstant.blueColor,
                                                    text: "Search",
                                                    textSize: 10.sp,
                                                    tabAction: () async {
                                                      if (attendanceController
                                                              .dateController
                                                              .text
                                                              .isNotEmpty &&
                                                          attendanceController
                                                                  .selectedCustomName !=
                                                              null) {
                                                        attendanceController
                                                            .attendanceSearchingProgress(
                                                                true);
                                                        attendanceController
                                                            .searchAttendance(
                                                                context);
                                                      }
                                                    },
                                                  ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            CustomButtonWidget(
                                              radius: 5.r,
                                              height: mq.height * 0.04,
                                              paddingHorizontal: 10.w,
                                              buttonColor:
                                                  ColorConstant.blueColor,
                                              sizedBoxWidth: 4.w,
                                              text: "Clear",
                                              textSize: 10.sp,
                                              tabAction: () {
                                                attendanceController
                                                    .clearAllSelections();
                                                attendanceController
                                                    .setAttendanceNull();
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        AttendanceTableRow(
                                          padding: 0,
                                          cells: [
                                            CustomTableCell(
                                              text: "Name",
                                              textColor:
                                                  ColorConstant.primaryColor,
                                              textFw: FontWeight.bold,
                                            ),
                                            CustomTableCell(
                                              text: "Date",
                                              textColor:
                                                  ColorConstant.primaryColor,
                                              textFw: FontWeight.bold,
                                            ),
                                            CustomTableCell(
                                              text: "Shift",
                                              textColor:
                                                  ColorConstant.primaryColor,
                                              textFw: FontWeight.bold,
                                            ),
                                            CustomTableCell(
                                              text: "Status",
                                              textColor:
                                                  ColorConstant.primaryColor,
                                              textFw: FontWeight.bold,
                                            ),
                                          ],
                                          isHeader: true,
                                        ),
                                        attendanceController
                                                    .searchedAttendance ==
                                                null
                                            ? Container()
                                            : AttendanceTableRow(
                                                cells: [
                                                  CustomTableCell(
                                                    text: attendanceController
                                                        .searchedAttendance!
                                                        .employeeName,
                                                    padding: 8.r,
                                                  ),
                                                  CustomTableCell(
                                                    text: attendanceController
                                                        .formatDate(
                                                            attendanceController
                                                                .searchedAttendance!
                                                                .date!),
                                                    padding: 8.r,
                                                  ),
                                                  CustomTableCell(
                                                    text: attendanceController
                                                        .searchedAttendance!
                                                        .shift,
                                                    padding: 8.r,
                                                  ),
                                                  CustomTableCell(
                                                    text: attendanceController
                                                        .searchedAttendance!
                                                        .status,
                                                    padding: 8.r,
                                                  ),
                                                  // _buildTableCellImage(employeeDetailModel.image.toString()),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ResponsiveHelper.isTablet(context) ||
                                    ResponsiveHelper.isMobile(context)
                                ? Row(
                                    children: [
                                      CustomButtonWidget(
                                          tabAction: () {
                                            attendanceController
                                                .selectEmployeeShiftInDropDownList(
                                                    context, "Morning");
                                          },
                                          buttonColor: attendanceController
                                                      .selectedEmployeeShift ==
                                                  "Morning"
                                              ? ColorConstant.primaryColor
                                              : ColorConstant.greenLightColor,
                                          textColor: attendanceController
                                                      .selectedEmployeeShift ==
                                                  "Morning"
                                              ? ColorConstant.whiteColor
                                              : ColorConstant.blackColor,
                                          height: mq.height * 0.04,
                                          paddingHorizontal: 15,
                                          textSize: 12.sp,
                                          textFw: FontWeight.w700,
                                          text: "Morning"),
                                      CustomButtonWidget(
                                          tabAction: () {
                                            attendanceController
                                                .selectEmployeeShiftInDropDownList(
                                                    context, "Evening");
                                          },
                                          buttonColor: attendanceController
                                                      .selectedEmployeeShift ==
                                                  "Evening"
                                              ? ColorConstant.primaryColor
                                              : ColorConstant.greenLightColor,
                                          height: mq.height * 0.04,
                                          paddingHorizontal: 15,
                                          textColor: attendanceController
                                                      .selectedEmployeeShift ==
                                                  "Evening"
                                              ? ColorConstant.whiteColor
                                              : ColorConstant.blackColor,
                                          textSize: 12.sp,
                                          textFw: FontWeight.w700,
                                          text: "Evening")
                                    ],
                                  )
                                : CustomText(
                                    "Shift ${attendanceController.selectedEmployeeShift}",
                                    color: ColorConstant.blackColor,
                                    fw: FontWeight.w700,
                                    size: 18.sp,
                                  ),
                          ],
                        ),
                      ],
                    )),
                const Divider(
                  height: 1,
                ),
                AttendanceTableView(),
              ],
            ),
          ),
        );
      },
    );
  }
}
