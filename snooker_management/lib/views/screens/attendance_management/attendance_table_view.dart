import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/attendance_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/services/attendance_services.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/attendance_management/attendance_table_row.dart';
import 'package:snooker_management/views/screens/attendance_management/atttendance_status_view.dart';

import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

import '../../widgets/custom_empty_screen_message.dart';

class AttendanceTableView extends StatelessWidget {
  AttendanceTableView({super.key});
  AttendanceController attendanceController = Get.find<AttendanceController>();

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<AttendanceController>(
      builder: (attendanceController) {
        return Container(
          margin: ResponsiveHelper.isMobile(context)
              ? EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h)
              : EdgeInsets.all(10.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Visibility(
                visible: attendanceController.attendanceExist != null,
                child: attendanceController.attendanceExist == true
                    ? ResponsiveHelper.isTablet(context) ||
                            ResponsiveHelper.isMobile(context)
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: attendanceController.attendance!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: mq.width,
                                  margin: EdgeInsets.only(
                                    bottom: 15.h,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                      color: ColorConstant.greenLightColor,
                                      borderRadius: BorderRadius.circular(5.r)),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            attendanceController
                                                .attendance![index]
                                                .employeeName,
                                            fw: FontWeight.w700,
                                            size: 14.sp,
                                            color: ColorConstant.blackColor,
                                          ),
                                          CustomText(
                                            attendanceController.formatDate(
                                                attendanceController
                                                    .attendance![index].date!),
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
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomText(
                                            attendanceController
                                                    .attendance?[index].shift ??
                                                "",
                                            fw: FontWeight.w400,
                                            size: 11.sp,
                                            color: ColorConstant.blackColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      AttendanceStatusView(
                                        attendanceModel: attendanceController
                                            .attendance![index],
                                      )
                                    ],
                                  ));
                            })
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Column(
                                  children: [
                                    AttendanceTableRow(
                                      cells: [
                                        CustomTableCell(
                                          text: "Name",
                                          textColor: ColorConstant.primaryColor,
                                          textFw: FontWeight.bold,
                                        ),
                                        CustomTableCell(
                                          text: "Date",
                                          textColor: ColorConstant.primaryColor,
                                          textFw: FontWeight.bold,
                                        ),
                                        CustomTableCell(
                                          text: "Shift",
                                          textColor: ColorConstant.primaryColor,
                                          textFw: FontWeight.bold,
                                        ),
                                        CustomTableCell(
                                          text: "Status",
                                          textColor: ColorConstant.primaryColor,
                                          textFw: FontWeight.bold,
                                        ),
                                      ],
                                      isHeader: true,
                                    ),
                                    for (int i = 0;
                                        i <
                                            attendanceController
                                                .attendance!.length;
                                        i++)
                                      AttendanceTableRow(
                                        rowsColor:
                                            ColorConstant.greenLightColor,
                                        cells: [
                                          CustomTableCell(
                                            text: attendanceController
                                                    .attendance?[i]
                                                    .employeeName ??
                                                "",
                                            padding: 8.r,
                                          ),
                                          CustomTableCell(
                                            text: attendanceController
                                                .formatDate(attendanceController
                                                    .attendance![i].date!),
                                            padding: 8.r,
                                          ),
                                          CustomTableCell(
                                            text: attendanceController
                                                    .attendance?[i].shift ??
                                                "",
                                            padding: 8.r,
                                          ),
                                          AttendanceStatusView(
                                            attendanceModel:
                                                attendanceController
                                                    .attendance![i],
                                          )
                                        ],
                                      ),
                                  ],
                                )),
                          )
                    : Column(
                        children: [
                          CustomEmptyScreenMessage(
                            icon: Icon(
                              Icons
                                  .assignment_turned_in_outlined, // Good for attendance/check-ins
                              size: 60.sp,
                              color: ColorConstant.greyColor,
                            ),
                            headText: "No Attendance Found",
                            subtext:
                                "You haven’t marked any attendance yet.\nPlease add attendance to keep records up to date.",
                          ),
                          TextButton(
                              onPressed: () async {
                                //Check Internet Connection Before Proceeding
                                bool isConnected = await InternetCheckerHelper
                                    .isConnectedToInternet();
                                if (!isConnected) {
                                  if (!context.mounted) return;
                                  DialogHelper.showExceptionErrorDialog(context,
                                      "No internet connection. Please check your network.");
                                } else if (attendanceController.employeesList ==
                                        [] ||
                                    attendanceController
                                        .employeesList.isEmpty) {
                                  if (!context.mounted) return;
                                  DialogHelper.showNoticeDialog(context,
                                      "Kindly add employees before proceeding");
                                } else {
                                  try {
                                    FlushMessagesUtil.easyLoading();
                                    await FirebaseAttendanceServices
                                        .addAttendance(
                                            context,
                                            attendanceController.employeesList,
                                            attendanceController
                                                .selectedEmployeeShift!,
                                            "Present");

                                    EasyLoading.dismiss();
                                    if (!context.mounted) return;
                                    DialogHelper.showSuccessDialog(
                                      context,
                                      "Attendance added successfully!",
                                      false,
                                    );
                                    attendanceController.getAttendance(context);
                                    // attendanceController.toDayAttendanceExist(attendanceController.selectedEmployeeShift!);
                                  } catch (e) {
                                    EasyLoading.dismiss();
                                    if (!context.mounted) return;
                                    DialogHelper.showExceptionErrorDialog(
                                        context, "$e");
                                  }
                                }
                              },
                              child: CustomText(
                                "Click here to add Attendance",
                                color: ColorConstant.primaryColor,
                                size: 12.w,
                              ))
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
