import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data' as typed_data;
import 'package:snooker_management/models/employee_detail_model.dart';
import 'package:snooker_management/services/employee_services.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';
import '../constants/images_constant.dart';
import '../utils/flush_messages_util.dart';
import 'package:pdf/widgets.dart' as pw;

class EmployeeController extends GetxController {
  TextEditingController searchController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController employeeNicController = TextEditingController();
  TextEditingController employeeTypeController = TextEditingController();
  TextEditingController employeeContactController = TextEditingController();
  TextEditingController employeeAddressController = TextEditingController();
  GlobalKey<FormState> fieldsKey = GlobalKey<FormState>();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();

  bool isEmployeeSearching = false;
  EmployeeModel? searchedEmployee;
  String? selectedEmployeeShift;
  bool? isEmployeeExist;

  @override
  void onClose() {
    searchController.dispose();
    employeeNameController.dispose();
    employeeNicController.dispose();
    employeeTypeController.dispose();
    employeeContactController.dispose();
    employeeAddressController.dispose();
    super.onClose();
  }

  void selectEmployeeShiftInDropDownList(BuildContext context, String value) {
    selectedEmployeeShift = value;
    update();
  }

  void setSelectedShiftNull() {
    selectedEmployeeShift = null;
    update();
  }

  String? userUid;
  void getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userUid = sp.getString('uId') ?? "";
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                 search employee                          */
  /*--------------------------------------------------------------------------*/
  Future<void> searchEmployee(BuildContext context) async {
    try {
      // Perform the search
      searchedEmployee = await FirebaseEmployeeServices.searchEmployee(
          searchController.text.trim(), context);

      // Stop the progress indicator after the search is complete
      employeeSearchingProgress(false);
      update();
    } catch (e) {
      employeeSearchingProgress(false);
      searchedEmployee = null;
      update();
    } finally {
      employeeSearchingProgress(false);
    }
  }

  void setEmployeeNull() {
    searchedEmployee = null;
    update();
  }

  void employeeSearchingProgress(value) {
    isEmployeeSearching = value;
    update();
  }

  void setEmployeeShift(String value) {
    selectedEmployeeShift = value;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                check and validation                      */
  /*--------------------------------------------------------------------------*/

  String? employeeNameValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter employee Name";
    }
    return null;
  }

  String? employeeTypeValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter employee Type";
    }
    return null;
  }

  String? employeeAddressValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter employee Address";
    }
    return null;
  }

  RegExp contactRegex = RegExp(r'^[0-9]{11}$');
  String? employeeContactValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter eleven digit phone number";
    } else if (!contactRegex.hasMatch(value)) {
      return "Please enter valid number";
    }
    return null;
  }

  RegExp nicRegex = RegExp(r'^[0-9]{13}$');
  String? employeeNicValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter NIC without dashes";
    } else if (!nicRegex.hasMatch(value)) {
      return "Please enter valid NIC";
    }
    return null;
  }

  /*--------------------------------------------------------------------------*/
  /*                                pick local Image                           */
  /*--------------------------------------------------------------------------*/
  typed_data.Uint8List? newImage;

  void pickImage(typed_data.Uint8List? image) {
    newImage = image;
    update();
  }

  Future<void> imagePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // important
      );

      if (result != null) {
        if (kIsWeb) {
          // Web
          newImage = result.files.single.bytes;
        } else {
          // Android / iOS
          File file = File(result.files.single.path!);
          newImage = await file.readAsBytes();
        }
        update();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
  // Future<void> imagePicker() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.image,
  //       allowMultiple: false,
  //     );
  //     if (result != null && result.files.single.bytes != null) {
  //       typed_data.Uint8List imageBytes = result.files.single.bytes!;
  //       pickImage(imageBytes);
  //     }
  //   } catch (e) {
  //     print("Error picking image: $e");
  //   }
  // }

/*--------------------------------------------------------------------------*/
/*                             check employee exist                         */
/*--------------------------------------------------------------------------*/
  Future<void> checkEmployeeExist() async {
    isEmployeeExist = await FirebaseEmployeeServices.employeeExist(
        employeeNameController.text);
    update();
  }

/*--------------------------------------------------------------------------*/
/*                             add employee logic                           */
/*--------------------------------------------------------------------------*/
  Future<void> addEmployee(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      await checkEmployeeExist();
      if (isEmployeeExist!) {
        if (selectedEmployeeShift != null) {
          if (newImage != null) {
            FlushMessagesUtil.easyLoading();
            await FirebaseEmployeeServices.addNewEmployee(
                employeeNameController.text,
                employeeNicController.text,
                employeeTypeController.text,
                employeeContactController.text,
                employeeAddressController.text,
                newImage!,
                selectedEmployeeShift!);
            EasyLoading.dismiss();
            setEmployeeNull();
            if (!context.mounted) return;
            DialogHelper.showSuccessDialog(
                context, "Employee Added Successfully!", false);
          } else {
            if (!context.mounted) return;
            DialogHelper.showAttentionDialog(
                context, "Please select an image to proceed");
          }
        } else {
          if (!context.mounted) return;
          DialogHelper.showAttentionDialog(
              context, "Please select an employee shift to continue");
        }
      } else {
        if (!context.mounted) return;
        DialogHelper.showAttentionDialog(context,
            "This name is already in use. Please choose a different name");
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(
        context,
        e.toString(),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

/*--------------------------------------------------------------------------*/
/*                          generate employee repoart                       */
/*--------------------------------------------------------------------------*/
  void generateEmployeereport(BuildContext context) async {
    try {
      resetPdfCurrentPage();
      FlushMessagesUtil.easyLoading();
      List<EmployeeModel> employeeReport =
          await FirebaseEmployeeServices.generateEmployeeReport();
      EasyLoading.dismiss();
      List<EmployeeModel> employeeModel = employeeReport;
      if (!context.mounted) return;
      if (employeeModel.isNotEmpty) {
        employeeReportGenerator(context, employeeModel);
      } else {
        if (!context.mounted) return;
        DialogHelper.showNoticeDialog(
            context, "There are currently no employee records available");
      }
    } catch (e) {
      EasyLoading.dismiss();
      DialogHelper.showExceptionErrorDialog(
        context,
        e.toString(),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

/*--------------------------------------------------------------------------*/
/*                             update employee logic                        */
/*--------------------------------------------------------------------------*/
  Future<void> updateEmployee(BuildContext context, String id,
      String employeeImage, String employeeName) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      if (employeeName != employeeNameController.text) {
        await checkEmployeeExist();
      } else {
        isEmployeeExist = true;
        update();
      }
      if (isEmployeeExist!) {
        if (newImage == null) {
          FlushMessagesUtil.easyLoading();
          if (!context.mounted) return;
          await FirebaseEmployeeServices.updateEmployeeWithSameImage(
            context,
            id,
            employeeNameController.text,
            employeeNicController.text,
            employeeTypeController.text,
            employeeContactController.text,
            employeeAddressController.text,
            selectedEmployeeShift!,
            employeeImage.toString(),
          );
          EasyLoading.dismiss();
          setEmployeeNull();
          if (!context.mounted) return;
          Navigator.of(context).pop();
          if (!context.mounted) return;
          DialogHelper.showSuccessDialog(
              context, "Employee updated successfully!", false);
        } else {
          FlushMessagesUtil.easyLoading();
          await FirebaseEmployeeServices.updateEmployeeWithNewImage(
            context,
            id,
            employeeNameController.text,
            employeeNicController.text,
            employeeTypeController.text,
            employeeContactController.text,
            employeeAddressController.text,
            selectedEmployeeShift!,
            newImage!,
          );
          EasyLoading.dismiss();
          setEmployeeNull();
          Navigator.of(context).pop();
          pickImage(null);
          if (!context.mounted) return;
          DialogHelper.showSuccessDialog(
              context, "Employee updated successfully!", false);
        }
      } else {
        if (!context.mounted) return;
        DialogHelper.showAttentionDialog(context,
            "This name is already in use. Please choose a different name");
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(
        context,
        e.toString(),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

/*--------------------------------------------------------------------------*/
/*                                 delete employee                          */
/*--------------------------------------------------------------------------*/

  void userDeleteAction(
      EmployeeModel employeeDetailModel, BuildContext context) async {
    FlushMessagesUtil.easyLoading();
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      await FirebaseEmployeeServices.deleteEmployeeRow(employeeDetailModel.id);
      if (!context.mounted) return;
      EasyLoading.dismiss();
      setEmployeeNull();
      Navigator.of(context).pop();
      pickImage(null);
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
          context, "Employee deleted successfully!", false);
    } catch (e) {
      EasyLoading.dismiss();
      Navigator.of(context).pop();
      DialogHelper.showExceptionErrorDialog(
        context,
        e.toString(),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

/*--------------------------------------------------------------------------*/
/*                           generate employee report                       */
/*--------------------------------------------------------------------------*/
  int totalPages = 1;
  int currentPage = 1;
  String? snookerName;
  Uint8List? image;
  List<List<EmployeeModel>> allPages = [];
  void resetPdfCurrentPage() {
    currentPage = 1;
    update();
  }

  // Generate PDF dynamically, checking space per page
  Future<Map<String, dynamic>> generatePdf(
      BuildContext context, List<EmployeeModel> employeesList) async {
    final pdf = pw.Document();
    const pageFormat = PdfPageFormat.a4; // A4 page format
    final pageHeight = pageFormat.height; // A4 page height
    const margin = 20.0; // Margin space for top, bottom, left, and right
    const headerHeight = 30.0; // Space for header (adjust as needed)
    const contentHeight = 20.0; // Height of each row (adjust based on content)
    double currentHeight = headerHeight; // Start with header height
    List<List<EmployeeModel>> allPages = [];
    List<EmployeeModel> currentPageEmployees = [];

    for (var employees in employeesList) {
      // Check if adding this row will exceed available space (accounting for margins and header)
      if (currentHeight + contentHeight > (pageHeight - margin * 2)) {
        // If it exceeds, add the current page to allPages and start a new page
        allPages.add(currentPageEmployees);
        currentPageEmployees = [
          employees
        ]; // Start with current row on next page
        currentHeight = headerHeight +
            contentHeight; // Reset height for new page (including header)
      } else {
        // If there's space, add the row to the current page
        currentPageEmployees.add(employees);
        currentHeight += contentHeight; // Add row height to the current height
      }
    }

    // Add remaining rows to the last page if any
    if (currentPageEmployees.isNotEmpty) {
      allPages.add(currentPageEmployees);
    }

    totalPages = allPages.length;

    // Return the generated PDF document, total pages, and paginated data
    return {'pdf': pdf, 'totalPages': totalPages, 'allPages': allPages};
  }

  void employeeReportGenerator(
      BuildContext context, List<EmployeeModel> employeeDetailModel) async {
    final result = await generatePdf(context, employeeDetailModel);
    final pdf = result['pdf'] as pw.Document;
    totalPages = result['totalPages'] as int;
    allPages = result['allPages'] as List<List<EmployeeModel>>;
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";

    context.go('/app/employeePdf');
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
