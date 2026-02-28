import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/models/attendance_model.dart';
import 'package:snooker_management/models/employee_detail_model.dart';
import 'package:snooker_management/services/attendance_services.dart';
import 'package:snooker_management/services/employee_services.dart';
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

  String formatDate(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to 'yyyy-MM-dd'
    return DateFormat('dd-MM-yyyy').format(dateTime);
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
      if (attendance == null) {
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

  /*--------------------------------------------------------------------------*/
  /*                        generate Attendance reports                       */
  /*--------------------------------------------------------------------------*/

  Future<void> generateAttendanceReports(BuildContext context) async {
    try {
      if (selectedAttendanceReportOption == "Daily" &&
          selectedCustomName != null) {
      } else {
        resetPdfCurrentPage();
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

          EasyLoading.dismiss();
          if (!context.mounted) return;
          List<AttendanceModel> attendanceModel = attendanceReportList;
          if (attendanceModel.isNotEmpty) {
            attendanceReportGenerator(context, attendanceModel);
          } else {
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

          EasyLoading.dismiss();
          if (!context.mounted) return;
          List<AttendanceModel> attendanceModel = attendanceReportList;
          if (attendanceModel.isNotEmpty) {
            attendanceReportGenerator(context, attendanceModel);
          } else {
            DialogHelper.showNoticeDialog(
                context, "No Attendance exist for the selected criteria");
          }
        } else {
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
    } finally {
      EasyLoading.dismiss();
    }
  }

  int totalPages = 1;
  int currentPage = 1;
  String? snookerName;
  Uint8List? image;

  List<List<AttendanceModel>> allPages = [];
  // Reset page for fresh start
  void resetPdfCurrentPage() {
    currentPage = 1;
    update();
  }

  // Generate PDF dynamically, checking space per page
  Future<Map<String, dynamic>> generatePdf(
      BuildContext context, List<AttendanceModel> attendanceList) async {
    final pdf = pw.Document();
    const pageFormat = PdfPageFormat.a4; // A4 page format
    final pageHeight = pageFormat.height; // A4 page height
    const margin = 20.0; // Margin space for top, bottom, left, and right
    const headerHeight = 30.0; // Space for header (adjust as needed)
    const contentHeight = 20.0; // Height of each row (adjust based on content)
    double currentHeight = headerHeight; // Start with header height
    List<List<AttendanceModel>> allPages = [];
    List<AttendanceModel> currentPageAttendance = [];

    for (var attendance in attendanceList) {
      // Check if adding this row will exceed available space (accounting for margins and header)
      if (currentHeight + contentHeight > (pageHeight - margin * 2)) {
        // If it exceeds, add the current page to allPages and start a new page
        allPages.add(currentPageAttendance);
        currentPageAttendance = [
          attendance
        ]; // Start with current row on next page
        currentHeight = headerHeight +
            contentHeight; // Reset height for new page (including header)
      } else {
        // If there's space, add the row to the current page
        currentPageAttendance.add(attendance);
        currentHeight += contentHeight; // Add row height to the current height
      }
    }

    // Add remaining rows to the last page if any
    if (currentPageAttendance.isNotEmpty) {
      allPages.add(currentPageAttendance);
    }

    totalPages = allPages.length;

    // Return the generated PDF document, total pages, and paginated data
    return {'pdf': pdf, 'totalPages': totalPages, 'allPages': allPages};
  }

  // Handle table and page generation
  void attendanceReportGenerator(
      BuildContext context, List<AttendanceModel> attendanceModel) async {
    final result = await generatePdf(context, attendanceModel);
    final pdf = result['pdf'] as pw.Document;
    totalPages = result['totalPages'] as int;
    allPages = result['allPages'] as List<List<AttendanceModel>>;
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";

    //  Navigate using GoRouter
    if (!context.mounted) return;
    context.go('/app/attendancePdf');
  }

  // Page navigation methods
  void goToFirstPage() {
    if (currentPage != 1) {
      currentPage = 1;
      update();
    }
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      currentPage--;
      update();
    }
  }

  void goToNextPage() {
    if (currentPage < totalPages) {
      currentPage++;
      update();
    }
  }

  void goToLastPage() {
    if (currentPage != totalPages) {
      currentPage = totalPages;
      update();
    }
  }

  void goToPage(int pageNumber) {
    if (pageNumber >= 1 && pageNumber <= totalPages) {
      currentPage = pageNumber;
      update();
    }
  }
}
