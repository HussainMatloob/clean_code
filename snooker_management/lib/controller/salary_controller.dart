import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/employee_detail_model.dart';
import 'package:snooker_management/models/salary_model.dart';
import 'package:snooker_management/services/salary_servces.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

import '../constants/images_constant.dart';

class SalaryController extends GetxController {
  TextEditingController employeeSalary = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController searchDateController = TextEditingController();
  GlobalKey<FormState> fieldsKey = GlobalKey<FormState>();

  String? selectedSalaryReportOption;
  bool isSalarySearching = false;
  List<String> employeesNameList = [];
  String? selectedCustomName;
  List<EmployeeModel> employeesList = [];
  SalaryModel? searchedSalary;
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  String? selectedSearchedName;
  String? selectedMonthOrTable;

  @override
  void onClose() {
    employeeSalary.dispose();
    shiftController.dispose();
    dateController.dispose();
    searchDateController.dispose();
    super.onClose();
  }

  String? userUid;
  void getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userUid = sp.getString('uId') ?? "";
    update();
  }

  void selectSalaryReportOption(String value) {
    selectedSalaryReportOption = value;
    update();
  }

  String formatDate(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to 'yyyy-MM-dd'
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  /*--------------------------------------------------------------------------*/
  /*                                check and validation                      */
  /*--------------------------------------------------------------------------*/
  String? employeeSalaryValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter employee salary";
    }
    return null;
  }

  String? salaryDateValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select salary date";
    }
    return null;
  }

  void clearAllSelections() {
    selectedSalaryReportOption = null;
    selectedCustomName = null;
    employeeSalary.clear();
    shiftController.clear();
    dateController.clear();
    searchDateController.clear();
    selectedSearchedName = null;
    selectedMonthOrTable = null;
    update();
  }

  void setEmployeeName(String employeeName) {
    selectedCustomName = employeeName;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                search Salary                             */
  /*--------------------------------------------------------------------------*/
  Future<void> searchSalary(BuildContext context) async {
    try {
      // Perform the search
      searchedSalary = await FirebaseSalaryServices.searchSalary(
          context, searchDateController.text, selectedSearchedName!);

      // Stop the progress indicator after the search is complete
      salarySearchingProgress(false);
      if (searchedSalary == null) {
        if (!context.mounted) return;
        DialogHelper.showNoticeDialog(
            context, "No salary records found for any employee");
      }
      update();
    } catch (e) {
      salarySearchingProgress(false);
      searchedSalary = null;
      update();
    } finally {
      salarySearchingProgress(false);
    }
  }

  void setSearchedSalaryNull() {
    searchedSalary = null;
    update();
  }

  void salarySearchingProgress(value) {
    isSalarySearching = value;
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
  /*                          get employees Name logic                        */
  /*--------------------------------------------------------------------------*/

  Future<void> getExpensesName(BuildContext context) async {
    employeesList = await FirebaseSalaryServices.getEmployeesName(context);
    for (int i = 0; i < employeesList.length; i++) {
      employeesNameList.add(employeesList[i].employeeName);
    }
    update();
  }

  void clearEmployeesNameList() {
    employeesNameList.clear();
    update();
  }

  void selectDropDownListValue(String value, bool isShowingEmployee) {
    selectedCustomName = value;
    update();
    for (int i = 0; i <= employeesList.length; i++) {
      if (selectedCustomName == employeesList[i].employeeName) {
        shiftController.text = employeesList[i].shift;
      }
    }
  }

  void selectValueForSearch(String value) {
    selectedSearchedName = value;
    update();
  }

  void selectMonth(String month) {
    selectedMonthOrTable = month;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                              add salary Logic                            */
  /*--------------------------------------------------------------------------*/
  void addSalaryFunction(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      if (selectedCustomName != null) {
        FlushMessagesUtil.easyLoading();
        await FirebaseSalaryServices.addSalary(
          context,
          selectedCustomName!,
          employeeSalary.text,
          shiftController.text,
          dateController.text,
        );
        if (!context.mounted) return;
        DialogHelper.showSuccessDialog(
          context,
          "Salary Added Successfully!",
          false,
        );
      } else {
        DialogHelper.showAttentionDialog(
            context, "Kindly select a employee name to continue");
      }
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                           update salary Logic                            */
  /*--------------------------------------------------------------------------*/
  void updateSalaryFunction(BuildContext context, String id) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      if (selectedCustomName != null) {
        FlushMessagesUtil.easyLoading();
        await FirebaseSalaryServices.updateSalary(
          context,
          id,
          selectedCustomName!,
          employeeSalary.text,
          shiftController.text,
          dateController.text,
        );
        if (!context.mounted) return;
        setSearchedSalaryNull();
        Navigator.of(context).pop();

        DialogHelper.showSuccessDialog(
          context,
          "Salary Updated Successfully!",
          false,
        );
      } else {
        DialogHelper.showAttentionDialog(
            context, "Kindly select a employee name to continue");
      }
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                            delete salary Logic                           */
  /*--------------------------------------------------------------------------*/
  void salaryDeleteAction(SalaryModel salaryModel, BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      FlushMessagesUtil.easyLoading();
      await FirebaseSalaryServices.deleteSalary(context, salaryModel);
      setSearchedSalaryNull();
      EasyLoading.dismiss();
      if (!context.mounted) return;
      Navigator.of(context).pop();

      DialogHelper.showSuccessDialog(
        context,
        "Salary deleted successfully!",
        false,
      );
    } catch (e) {
      EasyLoading.dismiss();
      Navigator.of(context).pop();
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                            generate Salary report                        */
  /*--------------------------------------------------------------------------*/
  Future<void> generateSalaryReport(BuildContext context) async {
    try {
      if (selectedSalaryReportOption != null) {
        if (selectedSalaryReportOption == "Yearly" &&
            selectedMonthOrTable != null) {
          FlushMessagesUtil.easyLoading();
          List<SalaryModel> specificMonthSalary =
              await FirebaseSalaryServices.generateReportForSpecificMonth(
                  context, selectedMonthOrTable!);
          EasyLoading.dismiss();
          if (!context.mounted) return;
          List<SalaryModel> salaryModel = specificMonthSalary;
          if (salaryModel.isNotEmpty) {
            salaryReportGenerator(context, salaryModel);
          } else {
            DialogHelper.showNoticeDialog(
                context, "No employee salaries were recorded for this month");
          }
        } else if (selectedSalaryReportOption == "Monthly" &&
            selectedMonthOrTable != null) {
          //print("We have not any reports in this Scenario");
        } else {
          if (selectedSalaryReportOption != null &&
              selectedSearchedName != null &&
              selectedSalaryReportOption != "Monthly") {
            FlushMessagesUtil.easyLoading();
            List<SalaryModel> salaryReportByName =
                await FirebaseSalaryServices.generateSalaryReportByNameInRange(
                    context,
                    selectedSalaryReportOption!,
                    selectedSearchedName!);
            EasyLoading.dismiss();
            if (!context.mounted) return;
            List<SalaryModel> salaryModel = salaryReportByName;
            if (salaryModel.isNotEmpty) {
              salaryReportGenerator(context, salaryModel);
            } else {
              DialogHelper.showNoticeDialog(
                  context, "No salary records found for the selected name");
            }
          } else if (selectedSalaryReportOption != null &&
              selectedSearchedName == null) {
            FlushMessagesUtil.easyLoading();
            List<SalaryModel> salaryReportInDateRange =
                await FirebaseSalaryServices.generateSalaryInDateRange(
                    context, selectedSalaryReportOption!);
            EasyLoading.dismiss();
            List<SalaryModel> salaryModel = salaryReportInDateRange;
            if (salaryModel.isNotEmpty) {
              salaryReportGenerator(context, salaryModel);
            } else {
              if (!context.mounted) return;
              DialogHelper.showNoticeDialog(context, "No salary records found");
            }
          }
        }
      } else {
        if (!context.mounted) return;
        DialogHelper.showAttentionDialog(
            context, "Please select a report option to continue");
      }
    } catch (e) {
      EasyLoading.dismiss();
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
  List<List<SalaryModel>> allPages = [];
  void resetPdfCurrentPage() {
    currentPage = 1;
    update();
  }

  Future<Map<String, dynamic>> generatePdf(
      BuildContext context, List<SalaryModel> salariesList) async {
    final pdf = pw.Document();
    const pageFormat = PdfPageFormat.a4; // A4 page format
    final pageHeight = pageFormat.height; // A4 page height
    const margin = 20.0; // Margin space for top, bottom, left, and right
    const headerHeight = 30.0; // Space for header (adjust as needed)
    const contentHeight = 20.0; // Height of each row (adjust based on content)
    double currentHeight = headerHeight; // Start with header height
    List<List<SalaryModel>> allPages = [];
    List<SalaryModel> currentPageSalaries = [];

    for (var salaries in salariesList) {
      // Check if adding this row will exceed available space (accounting for margins and header)
      if (currentHeight + contentHeight > (pageHeight - margin * 2)) {
        // If it exceeds, add the current page to allPages and start a new page
        allPages.add(currentPageSalaries);
        currentPageSalaries = [salaries]; // Start with current row on next page
        currentHeight = headerHeight +
            contentHeight; // Reset height for new page (including header)
      } else {
        // If there's space, add the row to the current page
        currentPageSalaries.add(salaries);
        currentHeight += contentHeight; // Add row height to the current height
      }
    }

    // Add remaining rows to the last page if any
    if (currentPageSalaries.isNotEmpty) {
      allPages.add(currentPageSalaries);
    }

    totalPages = allPages.length;

    // Return the generated PDF document, total pages, and paginated data
    return {'pdf': pdf, 'totalPages': totalPages, 'allPages': allPages};
  }

  void salaryReportGenerator(
      BuildContext context, List<SalaryModel> salaryModel) async {
    final result = await generatePdf(context, salaryModel);
    final pdf = result['pdf'] as pw.Document;
    totalPages = result['totalPages'] as int;
    allPages = result['allPages'] as List<List<SalaryModel>>;
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";
    context.go('/app/salaryPdf');
  }

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

  void goToNextPage(int totalPages) {
    if (currentPage < totalPages) {
      currentPage++;
      update();
    }
  }

  void goToLastPage(int totalPages) {
    if (currentPage != totalPages) {
      currentPage = totalPages;
      update();
    }
  }

  void goToPage(int pageNumber, int totalPages) {
    if (pageNumber >= 1 && pageNumber <= totalPages) {
      currentPage = pageNumber;
      update();
    }
  }
}
