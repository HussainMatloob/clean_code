import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data' as typed_data;
import 'package:snooker_management/models/employee_detail_model.dart';
import 'package:snooker_management/services/employee_services.dart';
import 'package:snooker_management/services/pdf_services/employee_pdf_service.dart';
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

  void pickImage(typed_data.Uint8List? image) {
    newImage = image;
    update();
  }

  typed_data.Uint8List? newImage;

  Future<void> imagePicker() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, //  only gallery
      );

      if (image != null) {
        newImage = await image.readAsBytes();
        update();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

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
      FlushMessagesUtil.easyLoading();
      List<EmployeeModel> employeeReport =
          await FirebaseEmployeeServices.generateEmployeeReport();

      List<EmployeeModel> employeeModel = employeeReport;
      if (!context.mounted) return;
      if (employeeModel.isNotEmpty) {
        employeeReportGenerator(context, employeeModel);
      } else {
        if (!context.mounted) return;
        EasyLoading.dismiss();
        DialogHelper.showNoticeDialog(
            context, "There are currently no employee records available");
      }
    } catch (e) {
      EasyLoading.dismiss();
      DialogHelper.showExceptionErrorDialog(
        context,
        e.toString(),
      );
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

  String? snookerName;
  Uint8List? image;

  Uint8List? pdfBytes;
  Future<void> employeeReportGenerator(
      BuildContext context, List<EmployeeModel> employees) async {
    /// LOAD LOGO
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    /// LOAD CLUB NAME
    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";
    update();

    /// ⭐ GENERATE PDF
    pdfBytes = await EmployeePdfService.generatePdf(
      employees: employees,
      snookerName: snookerName ?? "",
      image: image,
    );

    EasyLoading.dismiss();

    update();
    if (!context.mounted) return;
    context.go('/app/employeePdf');
  }
}
