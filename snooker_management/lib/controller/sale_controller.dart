import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/TemporaryLoosersModel.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/models/table_sales_model.dart';
import 'package:snooker_management/services/sale_services.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';
import '../constants/images_constant.dart';
import '../views/screens/sale_management/sales_pdf_preview.dart';

class SaleController extends GetxController {
  GlobalKey<FormState> fieldsKey = GlobalKey<FormState>();
  GlobalKey<FormState> fieldsKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> fieldsKey2 = GlobalKey<FormState>();
  TextEditingController saleAmountController = TextEditingController();
  TextEditingController saleAmountController1 = TextEditingController();
  TextEditingController searchLoserController = TextEditingController();
  TextEditingController totalSaleAmountController = TextEditingController();

  List<TableDetailModel> tablesDetail = [];
  List<String> tablesNumberList = [];
  String? selectedCustomName;
  String? selectedMonthOrTable;
  List<String> losersNameList = [];
  List<TemporaryLosersModel> temporaryLosers = [];
  TemporaryLosersModel? selectedLoserData;
  List<String> allTemporaryLosersNameList = [];
  List<TemporaryLosersModel> allTemporaryLosers = [];
  List<TemporaryLosersModel> searchedLosers = [];
  double totalAmount = 0.0;
  int totalLoseGames = 0;

  @override
  void onClose() {
    saleAmountController.dispose();
    saleAmountController1.dispose();
    searchLoserController.dispose();
    super.onClose();
  }

  String formatDate(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to 'yyyy-MM-dd'
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  String? selectedSaleReportOption;
  void selectSaleReportOption(String value) {
    selectedSaleReportOption = value;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                           search loser by name                           */
  /*--------------------------------------------------------------------------*/
  Future<void> searchLoser(BuildContext context) async {
    try {
      FlushMessagesUtil.easyLoading();
      searchedLosers = await FirebaseSaleServices.searchTemporaryLoserByName(
          context, searchLoserController.text);
      totalAmount = 0.0;
      totalLoseGames = 0;
      for (int i = 0; i < searchedLosers.length; i++) {
        double newValue = double.parse(searchedLosers[i].payAmount.toString());
        int loseGames = int.parse(searchedLosers[i].loosGames.toString());
        totalAmount += newValue;
        totalLoseGames += loseGames;
      }
      totalSaleAmountController.text = totalAmount.toString();
      update();
    } catch (e) {
      totalSaleAmountController.text = "0.0";
      searchedLosers = [];
      update();
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                get losers name                           */
  /*--------------------------------------------------------------------------*/
  Future<void> getLosersName(BuildContext context) async {
    try {
      allTemporaryLosers = await FirebaseSaleServices.getAllLosers(context);
      for (int i = 0; i < allTemporaryLosers.length; i++) {
        if (!allTemporaryLosersNameList
            .contains(allTemporaryLosers[i].looserName!)) {
          allTemporaryLosersNameList.add(allTemporaryLosers[i].looserName!);
        }
      }
      update();
    } catch (e) {
      allTemporaryLosersNameList = [];
      update();
    }
  }

  void clearAllSearchedLoserSelections(bool isInitial) {
    if (isInitial) {
      allTemporaryLosersNameList.clear();
    }
    searchLoserController.clear();
    searchedLosers.clear();
    totalAmount = 0.0;
    totalSaleAmountController.clear();
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                   Select value from editable drop down                   */
  /*--------------------------------------------------------------------------*/
  void selectValueFromEditableDropDown(
      String value, TextEditingController fieldController) {
    fieldController.text = value;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                             Get Tables Number                            */
  /*--------------------------------------------------------------------------*/
  Future<void> getTablesNumber() async {
    try {
      tablesDetail = await FirebaseSaleServices.getTables();
      update();
      for (int i = 0; i < tablesDetail.length; i++) {
        tablesNumberList.add(tablesDetail[i].tableNumber);
      }
      update();
    } catch (e) {
      tablesNumberList = [];
      update();
    }
  }

  void clearTablesNumberList() {
    tablesNumberList.clear();
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                         select dropDown value logic                      */
  /*--------------------------------------------------------------------------*/
  Future<void> selectTable(String value, BuildContext context) async {
    try {
      FlushMessagesUtil.easyLoading();
      selectedCustomName = null;
      losersNameList.clear();
      selectedMonthOrTable = value;
      selectedLoserData = null;
      saleAmountController.clear();
      update();
      temporaryLosers = await FirebaseSaleServices.getTemporaryLosers(
          context, value.toString());
      for (int i = 0; i < temporaryLosers.length; i++) {
        losersNameList.add(temporaryLosers[i].looserName!);
      }

      update();
    } catch (e) {
      losersNameList = [];
      update();
    } finally {
      EasyLoading.dismiss();
    }
  }

  void selectDropDownListValue(String value, bool isShowingNames) {
    selectedCustomName = value;
    update();
    for (int i = 0; i < temporaryLosers.length; i++) {
      if (selectedCustomName == temporaryLosers[i].looserName) {
        selectedLoserData = temporaryLosers[i];
        update();
      }
    }
    saleAmountController.text = selectedLoserData != null
        ? selectedLoserData!.payAmount.toString()
        : "";
    update();
  }

  void clearSelectedDropDownValue() {
    selectedCustomName = null;
    selectedMonthOrTable = null;
    losersNameList.clear();
    selectedLoserData = null;
    saleAmountController.clear();
    selectedSaleReportOption = null;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                               check and validations                      */
  /*--------------------------------------------------------------------------*/
  String? saleAmountValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter an amount";
    }
    return null;
  }

  String? customFieldsValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select or enter the loser's name";
    }
    return null;
  }

/*--------------------------------------------------------------------------*/
/*                                add loser sale logic                      */
/*--------------------------------------------------------------------------*/
  Future<void> addLoserSale(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      if (selectedLoserData != null) {
        FlushMessagesUtil.easyLoading();
        await FirebaseSaleServices.addTableSale(context, selectedLoserData!,
            false, [], "0", saleAmountController.text, 0);

        if (!context.mounted) return;
        DialogHelper.showSuccessDialog(
          context,
          "Sale added Successfully!",
          false,
        );
        clearSelectedDropDownValue();
      } else {
        DialogHelper.showAttentionDialog(
            context, "Please select the participant who lost");
      }
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                          add searched loser sale                         */
  /*--------------------------------------------------------------------------*/
  Future<void> addSearchedLoserSale(
    BuildContext context,
    TemporaryLosersModel loserSale,
    List<TemporaryLosersModel> losersList,
    bool isAddAll,
    total,
    payedAmount,
  ) async {
    //Check Internet Connection Before Proceeding
    bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
    if (!context.mounted) return;
    if (!isConnected) {
      DialogHelper.showInternetConnectionDialog(
          context, "Ensure you're connected to the internet and retry");
      return;
    }
    try {
      FlushMessagesUtil.easyLoading();
      await FirebaseSaleServices.addTableSale(context, loserSale, isAddAll,
          losersList, total, payedAmount, totalLoseGames);
      if (!context.mounted) return;
      if (isAddAll == false) {
        Navigator.of(context).pop();
      }
      DialogHelper.showSuccessDialog(
        context,
        "Sale added Successfully!",
        false,
      );

      searchedLosers = await FirebaseSaleServices.searchTemporaryLoserByName(
          context, searchLoserController.text);
      totalAmount = 0.0;
      totalLoseGames = 0;
      for (int i = 0; i < searchedLosers.length; i++) {
        double newValue = double.parse(searchedLosers[i].payAmount.toString());
        int loseGames = int.parse(searchedLosers[i].loosGames.toString());
        totalAmount += newValue;
        totalLoseGames += loseGames;
      }
      totalSaleAmountController.text = totalAmount.toString();
      update();
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                             generate sales report                        */
  /*--------------------------------------------------------------------------*/
  Future<void> generateSalesReports(BuildContext context) async {
    try {
      if (selectedSaleReportOption != null && selectedMonthOrTable != null) {
        FlushMessagesUtil.easyLoading();
        List<TableSalesModel> salesDetail =
            await FirebaseSaleServices.generateSalesReportByTable(
                context, selectedSaleReportOption!, selectedMonthOrTable!);
        if (!context.mounted) return;
        if (salesDetail.isNotEmpty) {
          salesReportGenerator(context, salesDetail);
        } else {
          DialogHelper.showNoticeDialog(
              context, "There are currently no sale records available");
        }
      } else if (selectedSaleReportOption != null) {
        FlushMessagesUtil.easyLoading();
        List<TableSalesModel> salesDetail =
            await FirebaseSaleServices.generateSalesReportInRange(
                context, selectedSaleReportOption!);

        if (salesDetail.isNotEmpty) {
          salesReportGenerator(context, salesDetail);
        } else {
          if (!context.mounted) return;
          DialogHelper.showNoticeDialog(
              context, "There are currently no sale records available");
        }
      } else {
        if (!context.mounted) return;
        DialogHelper.showAttentionDialog(
            context, "Please select a report option to continue");
      }
    } catch (e) {
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
  List<List<TableSalesModel>> allPages = [];
  void resetPdfCurrentPage() {
    currentPage = 1;
    update();
  }

  Future<Map<String, dynamic>> generatePdf(
      BuildContext context, List<TableSalesModel> salesList) async {
    final pdf = pw.Document();
    const pageFormat = PdfPageFormat.a4; // A4 page format
    final pageHeight = pageFormat.height; // A4 page height
    const margin = 20.0; // Margin space for top, bottom, left, and right
    const headerHeight = 30.0; // Space for header (adjust as needed)
    const contentHeight = 20.0; // Height of each row (adjust based on content)
    double currentHeight = headerHeight; // Start with header height
    List<List<TableSalesModel>> allPages = [];
    List<TableSalesModel> currentPageTableSales = [];

    for (var sales in salesList) {
      // Check if adding this row will exceed available space (accounting for margins and header)
      if (currentHeight + contentHeight > (pageHeight - margin * 2)) {
        // If it exceeds, add the current page to allPages and start a new page
        allPages.add(currentPageTableSales);
        currentPageTableSales = [sales]; // Start with current row on next page
        currentHeight = headerHeight +
            contentHeight; // Reset height for new page (including header)
      } else {
        // If there's space, add the row to the current page
        currentPageTableSales.add(sales);
        currentHeight += contentHeight; // Add row height to the current height
      }
    }

    // Add remaining rows to the last page if any
    if (currentPageTableSales.isNotEmpty) {
      allPages.add(currentPageTableSales);
    }

    totalPages = allPages.length;

    // Return the generated PDF document, total pages, and paginated data
    return {'pdf': pdf, 'totalPages': totalPages, 'allPages': allPages};
  }

  void salesReportGenerator(
      BuildContext context, List<TableSalesModel> tableSalesModel) async {
    final result = await generatePdf(context, tableSalesModel);
    final pdf = result['pdf'] as pw.Document;
    totalPages = result['totalPages'] as int;
    allPages = result['allPages'] as List<List<TableSalesModel>>;
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";

    if (!context.mounted) return;
    context.go('/app/salesPdfPreviewPages');
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
