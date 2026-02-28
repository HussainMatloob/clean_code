import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/package_model.dart';
import 'package:snooker_management/services/package_services.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class PackageController extends GetxController {
  TextEditingController packageNameController = TextEditingController();
  TextEditingController packagePriceController = TextEditingController();
  TextEditingController packageDescriptionController = TextEditingController();
  TextEditingController packageDurationController = TextEditingController();
  GlobalKey<FormState> fieldsKey = GlobalKey<FormState>();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();

  @override
  void onClose() {
    packageNameController.dispose();
    packagePriceController.dispose();
    packageDescriptionController.dispose();
    packageDurationController.dispose();
    super.onClose();
  }

  String? userUid;
  void getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userUid = sp.getString('uId') ?? "";
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                check and validation                      */
  /*--------------------------------------------------------------------------*/

  String? packageNameValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Package Name";
    }
    return null;
  }

  String? packagePriceValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Package price";
    }
    return null;
  }

  String? packageDescriptionValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Package Description";
    }
    return null;
  }

  String? packageDurationValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Package Duration";
    }
    return null;
  }

  /*--------------------------------------------------------------------------*/
  /*                               add Package logic                          */
  /*--------------------------------------------------------------------------*/
  void addPackageFunction(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      FlushMessagesUtil.easyLoading();
      await FirebasePackageServices.addPackage(
        context,
        packageNameController.text,
        packagePriceController.text,
        packageDescriptionController.text,
        packageDurationController.text,
      );
      EasyLoading.dismiss();
      if (!context.mounted) return;
      Navigator.of(context).pop();

      DialogHelper.showSuccessDialog(
        context,
        "Package Added Successfully!",
        false,
      );
    } catch (e) {
      EasyLoading.dismiss();
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                             update Package logic                         */
  /*--------------------------------------------------------------------------*/
  void updatePackageFunction(BuildContext context, String id) async {
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
      await FirebasePackageServices.updatePackage(
        context,
        id,
        packageNameController.text,
        packagePriceController.text,
        packageDescriptionController.text,
        packageDurationController.text,
      );
      EasyLoading.dismiss();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
        context,
        "Package updated successfully!",
        false,
      );
    } catch (e) {
      EasyLoading.dismiss();
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                delete Package                            */
  /*--------------------------------------------------------------------------*/
  void packageDeleteAction(
      PackageModel packageModel, BuildContext context) async {
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
      await FirebasePackageServices.deletePackage(packageModel.id!);
      EasyLoading.dismiss();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      DialogHelper.showSuccessDialog(
        context,
        "Package deleted successfully!",
        false,
      );
    } catch (e) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
