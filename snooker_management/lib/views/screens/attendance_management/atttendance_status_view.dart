import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/attendance_model.dart';
import 'package:snooker_management/services/attendance_services.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';

class AttendanceStatusView extends StatefulWidget {
  final AttendanceModel? attendanceModel;
  const AttendanceStatusView({
    super.key,
    this.attendanceModel,
  });
  @override
  State<AttendanceStatusView> createState() => _AttendanceStatusViewState();
}

class _AttendanceStatusViewState extends State<AttendanceStatusView> {
  String selectedStatus = "";
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Row(
      mainAxisAlignment: ResponsiveHelper.isTablet(context) ||
              ResponsiveHelper.isMobile(context)
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: [
        Row(
          children: [
            CustomButtonWidget(
              isBorder: true,
              buttonColor: selectedStatus == ""
                  ? widget.attendanceModel!.status == "Present"
                      ? ColorConstant.dullBlueColor
                      : Colors.transparent
                  : selectedStatus == "Present"
                      ? ColorConstant.dullBlueColor
                      : Colors.transparent,
              radius: 5.r,
              height: mq.height * 0.03,
              paddingHorizontal: 5.w,
              text: "Present",
              textColor: selectedStatus == ""
                  ? widget.attendanceModel!.status == "Present"
                      ? ColorConstant.whiteColor
                      : ColorConstant.blackColor
                  : selectedStatus == "Present"
                      ? ColorConstant.whiteColor
                      : ColorConstant.blackColor,
              textSize: 10.sp,
              tabAction: () {
                setState(() {
                  selectedStatus = "Present";
                });
              },
            ),
            SizedBox(
              width: 5.w,
            ),
            CustomButtonWidget(
              isBorder: true,
              buttonColor: selectedStatus == ""
                  ? widget.attendanceModel!.status == "Absent"
                      ? ColorConstant.dullRedColor
                      : Colors.transparent
                  : selectedStatus == "Absent"
                      ? ColorConstant.dullRedColor
                      : Colors.transparent,
              radius: 5.r,
              height: mq.height * 0.03,
              paddingHorizontal: 5.w,
              textColor: selectedStatus == ""
                  ? widget.attendanceModel!.status == "Absent"
                      ? ColorConstant.whiteColor
                      : ColorConstant.blackColor
                  : selectedStatus == "Absent"
                      ? ColorConstant.whiteColor
                      : ColorConstant.blackColor,
              text: "Absent",
              textSize: 10.sp,
              tabAction: () {
                setState(() {
                  selectedStatus = "Absent";
                });
              },
            ),
            SizedBox(
              width: 5.w,
            ),
            CustomButtonWidget(
              isBorder: true,
              buttonColor: selectedStatus == ""
                  ? widget.attendanceModel!.status == "Leave"
                      ? ColorConstant.primaryColor
                      : Colors.transparent
                  : selectedStatus == "Leave"
                      ? ColorConstant.primaryColor
                      : Colors.transparent,
              radius: 5.r,
              height: mq.height * 0.03,
              paddingHorizontal: 5.w,
              textColor: selectedStatus == ""
                  ? widget.attendanceModel!.status == "Leave"
                      ? ColorConstant.whiteColor
                      : ColorConstant.blackColor
                  : selectedStatus == "Leave"
                      ? ColorConstant.whiteColor
                      : ColorConstant.blackColor,
              text: "Leave",
              textSize: 10.sp,
              tabAction: () {
                setState(() {
                  selectedStatus = "Leave";
                });
              },
            ),
          ],
        ),
        SizedBox(
          width: 15.w,
        ),
        CustomButtonWidget(
          buttonColor: ColorConstant.blueColor,
          radius: 30.r,
          height: mq.height * 0.04,
          paddingHorizontal: 7.w,
          text: "Update",
          textSize: 10.sp,
          tabAction: () async {
            try {
              FlushMessagesUtil.easyLoading();
              await FirebaseAttendanceServices.updateAttendance(
                  context, widget.attendanceModel!, selectedStatus);
              EasyLoading.dismiss();
              if (!context.mounted) return;
              DialogHelper.showSuccessDialog(
                context,
                "Employee Attendance updated successfully!",
                false,
              );
            } catch (e) {
              EasyLoading.dismiss();

              DialogHelper.showExceptionErrorDialog(context, "$e");
            }
          },
        ),
      ],
    );
  }
}
