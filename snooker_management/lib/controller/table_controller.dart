import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/services/pdf_services/table_pdf_service.dart';
import 'package:snooker_management/services/table_services.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

import '../models/table_details_model.dart';

class TableController extends GetxController {
  TextEditingController searchController = TextEditingController();
  TextEditingController tableNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> fieldsKey = GlobalKey<FormState>();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();

  bool isTableSearching = false;
  TableDetailModel? searchedTable;
  bool tableExist = false;

  @override
  void onClose() {
    searchController.dispose();
    tableNumberController.dispose();
    nameController.dispose();
    typeController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }

  String? userUid;
  void getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userUid = sp.getString('uId') ?? "";
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                 search Table                             */
  /*--------------------------------------------------------------------------*/
  Future<void> searchTable(BuildContext context) async {
    try {
      // Perform the search
      searchedTable = await FirebaseTableServices.searchTable(
          searchController.text.trim(), context);
      update();
      if (searchedTable == null) {
        if (!context.mounted) return;
        DialogHelper.showNoticeDialog(
            context, "No table exists with this number");
      }
    } catch (e) {
      tableSearchingProgress(false);
      searchedTable = null;
      update();
    } finally {
      tableSearchingProgress(false);
    }
  }

  void setTableNull() {
    searchedTable = null;
    update();
  }

  void tableSearchingProgress(value) {
    isTableSearching = value;
    update();
  }

  Future<void> tableExistOrNot(BuildContext context) async {
    try {
      tableExist = await FirebaseTableServices.tableExist(
          context, tableNumberController.text);
      update();
    } catch (e) {}
  }

  /*--------------------------------------------------------------------------*/
  /*                                check and validation                      */
  /*--------------------------------------------------------------------------*/

  String? tableNumberValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Table Number";
    }
    return null;
  }

  String? tableNameValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Table Name";
    }
    return null;
  }

  String? tableTypeValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Table Type";
    }
    return null;
  }

  String? tableDescriptionValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Table Description";
    }
    return null;
  }

  String? tablePriceValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Table Price";
    }
    return null;
  }

  /*--------------------------------------------------------------------------*/
  /*                               add Table Logic                            */
  /*--------------------------------------------------------------------------*/
  Future<void> addTableFunction(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      await tableExistOrNot(context);
      if (tableExist) {
        FlushMessagesUtil.easyLoading();
        await FirebaseTableServices.addTable(
          context,
          tableNumberController.text,
          nameController.text,
          typeController.text,
          descriptionController.text,
          priceController.text,
        );
        EasyLoading.dismiss();
        setTableNull();
        if (!context.mounted) return;
        DialogHelper.showSuccessDialog(
          context,
          "Table Added Successfully!",
          false,
        );
        //  Navigator.of(context).pop(),
      } else {
        if (!context.mounted) return;
        DialogHelper.showNoticeDialog(context,
            "This table number is already in use. Please choose a different table number");
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                            update Table Logic                            */
  /*--------------------------------------------------------------------------*/
  Future<void> updateTableFunction(
      BuildContext context, String id, String tableNumber) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      if (tableNumberController.text != tableNumber) {
        await tableExistOrNot(context);
      } else {
        tableExist = true;
        update();
      }
      if (tableExist) {
        FlushMessagesUtil.easyLoading();
        await FirebaseTableServices.updateTable(
          context,
          id,
          tableNumberController.text,
          nameController.text,
          typeController.text,
          descriptionController.text,
          priceController.text,
        );

        setTableNull();
        if (!context.mounted) return;
        Navigator.of(context).pop();
        DialogHelper.showSuccessDialog(
          context,
          "Table updated successfully!",
          false,
        );
      } else {
        if (!context.mounted) return;
        DialogHelper.showNoticeDialog(context,
            "This table number is already in use. Please choose a different table number");
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                  delete Table                            */
  /*--------------------------------------------------------------------------*/
  void tableDeleteAction(
      TableDetailModel tableDetailModel, BuildContext context) async {
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
      await FirebaseTableServices.deleteTableRow(tableDetailModel.id);

      setTableNull();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      DialogHelper.showSuccessDialog(
        context,
        "Table deleted successfully!",
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
/*                             generate tables report                       */
/*--------------------------------------------------------------------------*/
  void generateTablesReport(BuildContext context) async {
    try {
      FlushMessagesUtil.easyLoading();
      List<TableDetailModel> tableModel =
          await FirebaseTableServices.generateTableReport();

      if (tableModel.isNotEmpty) {
        if (!context.mounted) return;
        tableReportGenerator(context, tableModel);
      } else {
        if (!context.mounted) return;
        EasyLoading.dismiss();
        DialogHelper.showNoticeDialog(
            context, "There are currently no table records available");
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    }
  }

/*--------------------------------------------------------------------------*/
/*                              table report generator                      */
/*--------------------------------------------------------------------------*/

  String? snookerName;
  Uint8List? image;

  Uint8List? pdfBytes;
  Future<void> tableReportGenerator(
      BuildContext context, List<TableDetailModel> tables) async {
    /// LOAD LOGO
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    /// LOAD CLUB NAME
    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";
    update();

    /// ⭐ GENERATE PDF
    try {
      pdfBytes = await TablePdfService.generatePdf(
        tables: tables,
        snookerName: snookerName ?? "",
        image: image,
      );
    } catch (e) {
      debugPrint("$e");
    }

    EasyLoading.dismiss();

    update();
    if (!context.mounted) return;
    context.go('/app/tablePdf');
  }
}
