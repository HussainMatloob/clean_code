import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/models/attendance_model.dart';
import 'package:snooker_management/models/employee_detail_model.dart';
import 'package:snooker_management/services/attendance_services.dart';
import 'package:snooker_management/services/employee_services.dart';
import 'package:snooker_management/services/pdf_services/attendance_pdf_service.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';

class AttendanceController extends GetxController {
  String? selectedEmployeeShift;
  bool isAttendanceSearching = false;
  List<String> employeesNameList = [];
  List<EmployeeModel> employeesList = [];
  String? selectedCustomName;
  bool? attendanceExist;
  AttendanceModel? searchedAttendance;
  TextEditingController dateController = TextEditingController();
  List<AttendanceModel>? attendance;
  List<AttendanceModel> attendanceReportList = [];

  void selectEmployeeShiftInDropDownList(
      BuildContext context, String value) async {
    attendanceExist = null;
    clearAllSelections();
    setAttendanceNull();
    clearEmployeesNameList();
    selectedEmployeeShift = value;
    update();
    await getAttendance(context);
    await getEmployeesName(context, selectedEmployeeShift!);
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }

  void setEmployeeShift(String shift) {
    selectedEmployeeShift = shift;
    update();
  }

  String? selectedAttendanceReportOption;
  void selectAttendanceReportOption(String value) {
    selectedAttendanceReportOption = value;
    update();
  }

  Future<void> getAttendance(BuildContext context) async {
    try {
      attendance = await FirebaseAttendanceServices.getAttendance(
          context, selectedEmployeeShift.toString());

      if (attendance == null || attendance == []) {
        attendanceExist = false;
      } else {
        attendanceExist = true;
      }
      update();
    } catch (e) {}
  }

  /*--------------------------------------------------------------------------*/
  /*                            search Attendance                             */
  /*--------------------------------------------------------------------------*/
  Future<void> searchAttendance(BuildContext context) async {
    // Perform the search
    try {
      searchedAttendance = await FirebaseAttendanceServices.searchAttendance(
          context,
          dateController.text,
          selectedCustomName!,
          selectedEmployeeShift!);
      // Stop the progress indicator after the search is complete
      attendanceSearchingProgress(false);
      update();
    } catch (e) {
      attendanceSearchingProgress(false);
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  void setAttendanceNull() {
    searchedAttendance = null;
    update();
  }

  void attendanceSearchingProgress(value) {
    isAttendanceSearching = value;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                 date selector                            */
  /*--------------------------------------------------------------------------*/
  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(
      BuildContext context, TextEditingController dateController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Use the date property to keep only the date part without the time component
      selectedDate = DateTime(picked.year, picked.month, picked.day);
      // Format the date using DateFormat
      dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      update();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                            get Employees Name                            */
  /*--------------------------------------------------------------------------*/

  Future<void> getEmployeesName(BuildContext context, String shift) async {
    try {
      employeesList =
          await FirebaseEmployeeServices.getEmployeesName(context, shift);
      for (int i = 0; i < employeesList.length; i++) {
        employeesNameList.add(employeesList[i].employeeName);
      }
      update();
    } catch (e) {
      employeesList = [];
      update();
    }
  }

  void clearEmployeesNameList() {
    employeesNameList.clear();
    update();
  }

  void selectDropDownListValue(String value, bool isShowingExpenseName) {
    selectedCustomName = value;
    update();
  }

  void clearAllSelections() {
    selectedAttendanceReportOption = null;
    dateController.clear();
    selectedCustomName = null;
    update();
  }

  String? snookerName;
  Uint8List? image;

  Uint8List? pdfBytes;

  /*--------------------------------------------------------------------------*/
  /*                        generate Attendance reports                       */
  /*--------------------------------------------------------------------------*/

  Future<void> generateAttendanceReports(BuildContext context) async {
    try {
      if (selectedAttendanceReportOption == "Daily" &&
          selectedCustomName != null) {
      } else {
        if (selectedAttendanceReportOption != null &&
            selectedCustomName != null) {
          FlushMessagesUtil.easyLoading();
          attendanceReportList = [];
          update();
          attendanceReportList = await FirebaseAttendanceServices
              .generateAttendanceReportByNameInRange(
                  context,
                  selectedEmployeeShift!,
                  selectedAttendanceReportOption!,
                  selectedCustomName!);

          if (!context.mounted) return;
          List<AttendanceModel> attendanceModel = attendanceReportList;
          if (attendanceModel.isNotEmpty) {
            attendanceReportGenerator(context, attendanceModel);
          } else {
            EasyLoading.dismiss();
            DialogHelper.showNoticeDialog(
                context, "No Attendance exist for the selected criteria");
          }
        } else if (selectedAttendanceReportOption != null &&
            selectedCustomName == null) {
          FlushMessagesUtil.easyLoading();
          attendanceReportList = [];
          update();
          attendanceReportList =
              await FirebaseAttendanceServices.generateAttendanceReportInRange(
                  context,
                  selectedEmployeeShift ?? "Morning",
                  selectedAttendanceReportOption!);

          if (!context.mounted) return;
          List<AttendanceModel> attendanceModel = attendanceReportList;
          if (attendanceModel.isNotEmpty) {
            attendanceReportGenerator(context, attendanceModel);
          } else {
            EasyLoading.dismiss();
            DialogHelper.showNoticeDialog(
                context, "No Attendance exist for the selected criteria");
          }
        } else {
          EasyLoading.dismiss();
          DialogHelper.showAttentionDialog(
              context, "Please select a report option to continue");
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      attendanceReportList = [];
      update();
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    }
  }

  Future<void> attendanceReportGenerator(
      BuildContext context, List<AttendanceModel> attendance) async {
    /// LOAD LOGO
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    /// LOAD CLUB NAME
    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";
    update();

    /// ⭐ GENERATE PDF
    pdfBytes = await AttendancePdfService.generatePdf(
      attendance: attendance,
      snookerName: snookerName ?? "",
      image: image,
    );

    EasyLoading.dismiss();

    update();
    if (!context.mounted) return;
    context.go('/app/attendancePdf');
  }
}
