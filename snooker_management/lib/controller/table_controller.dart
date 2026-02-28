import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/services/table_services.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';
import 'package:snooker_management/views/screens/table_management/table_pdf_preview.dart';
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
      resetPdfCurrentPage();
      FlushMessagesUtil.easyLoading();
      List<TableDetailModel> tableModel =
          await FirebaseTableServices.generateTableReport();

      if (tableModel.isNotEmpty) {
        tableReportGenerator(context, tableModel);
      } else {
        if (!context.mounted) return;
        DialogHelper.showNoticeDialog(
            context, "There are currently no table records available");
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
/*                              table report generator                      */
/*--------------------------------------------------------------------------*/

  int totalPages = 1;
  int currentPage = 1;
  String? snookerName;
  Uint8List? image;
  List<List<TableDetailModel>> allPages = [];
  void resetPdfCurrentPage() {
    currentPage = 1;
    update();
  }

  Future<Map<String, dynamic>> generatePdf(
      BuildContext context, List<TableDetailModel> tablesList) async {
    final pdf = pw.Document();
    const pageFormat = PdfPageFormat.a4; // A4 page format
    final pageHeight = pageFormat.height; // A4 page height
    const margin = 20.0; // Margin space for top, bottom, left, and right
    const headerHeight = 30.0; // Space for header (adjust as needed)
    const contentHeight = 20.0; // Height of each row (adjust based on content)
    double currentHeight = headerHeight; // Start with header height
    List<List<TableDetailModel>> allPages = [];
    List<TableDetailModel> currentPageTables = [];

    for (var tables in tablesList) {
      // Check if adding this row will exceed available space (accounting for margins and header)
      if (currentHeight + contentHeight > (pageHeight - margin * 2)) {
        // If it exceeds, add the current page to allPages and start a new page
        allPages.add(currentPageTables);
        currentPageTables = [tables]; // Start with current row on next page
        currentHeight = headerHeight +
            contentHeight; // Reset height for new page (including header)
      } else {
        // If there's space, add the row to the current page
        currentPageTables.add(tables);
        currentHeight += contentHeight; // Add row height to the current height
      }
    }

    // Add remaining rows to the last page if any
    if (currentPageTables.isNotEmpty) {
      allPages.add(currentPageTables);
    }

    totalPages = allPages.length;

    // Return the generated PDF document, total pages, and paginated data
    return {'pdf': pdf, 'totalPages': totalPages, 'allPages': allPages};
  }

  void tableReportGenerator(
      BuildContext context, List<TableDetailModel> tableDetailModel) async {
    final result = await generatePdf(context, tableDetailModel);
    final pdf = result['pdf'] as pw.Document;
    totalPages = result['totalPages'] as int;
    allPages = result['allPages'] as List<List<TableDetailModel>>;
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";

    context.go('/app/tablePdf');
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
