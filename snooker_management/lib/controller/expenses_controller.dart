import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/models/expense_model.dart';
import 'package:snooker_management/models/expenses_name_model.dart';
import 'package:snooker_management/models/other_expenses_model.dart';
import 'package:snooker_management/services/expense_services.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class ExpensesController extends GetxController {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController searchDateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> fieldsKey = GlobalKey<FormState>();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  String? selectedCustomName;
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  bool isExpenseSearching = false;
  List<ExpensesNameModel> expensesList = [];
  List<String> expensesNameList = [];
  late List<String> items;
  String? selectedDropDownValue;
  String? selectedExpenseReportOption;
  String? selectedOtherExpenseReportOption;

  @override
  void onClose() {
    descriptionController.dispose();
    expenseAmountController.dispose();
    dateController.dispose();
    searchController.dispose();
    expenseNameController.dispose();
    searchDateController.dispose();
    nameController.dispose();
    super.onClose();
  }

  String? userUid;
  void getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userUid = sp.getString('uId') ?? "";
    update();
  }

  String formatDate(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to 'yyyy-MM-dd'
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  void selectDropDownListValue(String value, bool isShowingExpense) {
    selectedCustomName = value;
    update();
  }

  void selectExpenseReportOption(String value) {
    selectedExpenseReportOption = value;
    update();
  }

  void selectOtherExpenseReportOption(String value) {
    selectedOtherExpenseReportOption = value;
    update();
  }

  void setNullSelectedReportOption() {
    selectedExpenseReportOption = null;
    selectedOtherExpenseReportOption = null;
    update();
  }

  List<ExpensesModel> searchedExpenses = [];

  /*--------------------------------------------------------------------------*/
  /*                               search Expense                             */
  /*--------------------------------------------------------------------------*/
  Future<void> searchExpense(BuildContext context) async {
    // Perform the search
    try {
      searchedExpenses = await FirebaseExpenseServices.searchExpense(
          context, searchDateController.text, selectedCustomName!);
      // Stop the progress indicator after the search is complete
      expenseSearchingProgress(false);
      update();
    } catch (e) {
      expenseSearchingProgress(false);
      setSearchedExpenseEmpty();
      update();
    }
  }

  void setSearchedExpenseEmpty() {
    searchedExpenses = [];
    update();
  }

  void expenseSearchingProgress(value) {
    isExpenseSearching = value;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                clear all selections                      */
  /*--------------------------------------------------------------------------*/
  void clearAllSelections() {
    setNullSelectedReportOption();
    searchDateController.clear();
    expenseNameController.clear();
    selectedCustomName = null;
    descriptionController.clear();
    expenseAmountController.clear();
    dateController.clear();
    nameController.clear();
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                check and validation                      */
  /*--------------------------------------------------------------------------*/
  String? customFieldsValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select an Expense Name";
    }
    return null;
  }

  String? nameValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Expense Name";
    }
    return null;
  }

  String? expenseDescriptionValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Expense Description";
    }
    return null;
  }

  String? expenseAmountValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Expense Amount";
    }
    return null;
  }

  String? expenseDateValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please must select Expense Date";
    }
    return null;
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
  /*                             add Expense Logic                            */
  /*--------------------------------------------------------------------------*/
  void addExpenseFunction(BuildContext context) async {
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
      if (!context.mounted) return;
      await FirebaseExpenseServices.addExpense(
        context,
        expenseNameController.text,
        descriptionController.text,
        expenseAmountController.text,
        dateController.text,
      );
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
        context,
        "Expense Added Successfully!",
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
  /*                          update Expense Logic                            */
  /*--------------------------------------------------------------------------*/
  void updateExpenseFunction(BuildContext context, String id) async {
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
      if (!context.mounted) return;
      await FirebaseExpenseServices.updateExpense(
          context,
          id,
          expenseNameController.text,
          descriptionController.text,
          expenseAmountController.text,
          dateController.text);
      setSearchedExpenseEmpty();
      if (!context.mounted) return;
      EasyLoading.dismiss();
      Navigator.of(context).pop();
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
        context,
        "Expense updated successfully!",
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
  /*                              delete expense                              */
  /*--------------------------------------------------------------------------*/
  void expenseDeleteAction(
      ExpensesModel expenseModel, BuildContext context) async {
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
      await FirebaseExpenseServices.deleteExpenseRow(expenseModel.id!);
      if (!context.mounted) return;
      setSearchedExpenseEmpty();
      EasyLoading.dismiss();
      Navigator.of(context).pop();
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
        context,
        "Expense deleted successfully!",
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
  /*                          add Other Expense Logic                         */
  /*--------------------------------------------------------------------------*/
  void addOtherExpenseFunction(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      if (!context.mounted) return;
      FlushMessagesUtil.easyLoading();
      await FirebaseExpenseServices.addOtherExpense(
        context,
        nameController.text,
        expenseNameController.text,
        expenseAmountController.text,
        dateController.text,
      );
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
        context,
        "Expense Added Successfully!",
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
  /*                        update Other Expense Logic                        */
  /*--------------------------------------------------------------------------*/
  void updateOtherExpenseFunction(
    BuildContext context,
    String id,
  ) async {
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
      if (!context.mounted) return;
      await FirebaseExpenseServices.updateOtherExpense(
        context,
        id,
        nameController.text,
        expenseNameController.text,
        expenseAmountController.text,
        dateController.text,
      );
      EasyLoading.dismiss();
      setSearchedExpenseEmpty();
      if (!context.mounted) return;
      Navigator.of(context).pop();

      DialogHelper.showSuccessDialog(
        context,
        "Expense updated successfully!",
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
  /*                            delete Other Expense                            */
  /*--------------------------------------------------------------------------*/
  void otherExpenseDeleteAction(
      OtherExpensesModel otherExpensesModel, BuildContext context) async {
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
      await FirebaseExpenseServices.deleteOtherExpenseRow(
          otherExpensesModel.id!);
      setSearchedExpenseEmpty();
      EasyLoading.dismiss();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
        context,
        "Expense deleted successfully!",
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
  /*                           get expenses Name logic                        */
  /*--------------------------------------------------------------------------*/

  Future<void> getExpensesName(BuildContext context) async {
    expensesList = await FirebaseExpenseServices.getExpensesName(context);
    for (int i = 0; i < expensesList.length; i++) {
      expensesNameList.add(expensesList[i].expenseName!);
    }
    update();
  }

  void clearExpensesNameList() {
    expensesNameList.clear();
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                       add custom expense in dropDownList                 */
  /*--------------------------------------------------------------------------*/
  Future<void> addCustomExpense(BuildContext context) async {
    if (!expensesNameList.contains(expenseNameController.text) &&
        expenseNameController.toString().trim().isNotEmpty) {
      try {
        //Check Internet Connection Before Proceeding
        bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
        if (!context.mounted) return;
        if (!isConnected) {
          DialogHelper.showInternetConnectionDialog(
              context, "Ensure you're connected to the internet and retry");
          return;
        }
        if (!context.mounted) return;
        FlushMessagesUtil.easyLoading();
        FirebaseExpenseServices.addExpenseName(
                context, expenseNameController.text)
            .then((value) {
          EasyLoading.dismiss();
          clearExpensesNameList();
          if (!context.mounted) return;
          getExpensesName(context);
          expenseNameController.clear();
          update();
        });
      } catch (e) {
        EasyLoading.dismiss();
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                   Select value from editable drop down                   */
  /*--------------------------------------------------------------------------*/
  void selectValueFromEditableDropDown(String value) {
    expenseNameController.text = value;
    update();
  }

  void updateFunction() {
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                     generate Expense report logic                        */
  /*--------------------------------------------------------------------------*/

  Future<void> generateExpensesReport(BuildContext context) async {
    try {
      if (selectedExpenseReportOption == "Monthly" &&
          selectedCustomName != null) {
      } else {
        if (selectedExpenseReportOption != null && selectedCustomName != null) {
          FlushMessagesUtil.easyLoading();
          List<ExpensesModel> expenseReport =
              await FirebaseExpenseServices.generateExpensesReportByNameInRange(
                  context, selectedExpenseReportOption!, selectedCustomName!);
          EasyLoading.dismiss();
          List<ExpensesModel> expensesModel = expenseReport;
          if (expensesModel.isNotEmpty) {
            expenseReportGenerator(context, expensesModel, false);
          } else {
            if (!context.mounted) return;
            DialogHelper.showNoticeDialog(
                context, "There are currently no expense records available");
          }
        } else if (selectedExpenseReportOption != null &&
            selectedCustomName == null) {
          FlushMessagesUtil.easyLoading();
          List<ExpensesModel> expenseReport =
              await FirebaseExpenseServices.generateExpensesInDateRange(
                  context, selectedExpenseReportOption!);
          EasyLoading.dismiss();
          List<ExpensesModel> expensesModel = expenseReport;
          if (expensesModel.isNotEmpty) {
            expenseReportGenerator(context, expensesModel, false);
          } else {
            if (!context.mounted) return;
            DialogHelper.showNoticeDialog(
                context, "There are currently no expense records available");
          }
        } else {
          DialogHelper.showAttentionDialog(
              context, "Please select a report option to continue");
        }
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
/*                 generate other Expense report logic                      */
/*--------------------------------------------------------------------------*/
  Future<void> generateOtherExpensesReport(BuildContext context) async {
    try {
      if (selectedOtherExpenseReportOption != null) {
        FlushMessagesUtil.easyLoading();
        List<OtherExpensesModel> otherExpenseData =
            await FirebaseExpenseServices.generateOtherExpensesReportInRange(
                context, selectedOtherExpenseReportOption!);
        EasyLoading.dismiss();
        List<OtherExpensesModel> otherExpensesModel = otherExpenseData;
        if (!context.mounted) return;
        if (otherExpensesModel.isNotEmpty) {
          expenseReportGenerator(context, otherExpensesModel, true);
        } else {
          DialogHelper.showNoticeDialog(
              context, "There are currently no expense records available");
        }
      } else {
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
  List<List<dynamic>> allPages = [];

  void resetPdfCurrentPage() {
    currentPage = 1;
    update();
  }

  // Generate PDF dynamically, checking space per page
  Future<Map<String, dynamic>> generatePdf(
      BuildContext context, List<dynamic> expensesList) async {
    final pdf = pw.Document();
    const pageFormat = PdfPageFormat.a4; // A4 page format
    final pageHeight = pageFormat.height; // A4 page height
    const margin = 20.0; // Margin space for top, bottom, left, and right
    const headerHeight = 30.0; // Space for header (adjust as needed)
    const contentHeight = 20.0; // Height of each row (adjust based on content)
    double currentHeight = headerHeight; // Start with header height
    List<List<dynamic>> allPages = [];
    List<dynamic> currentPageExpenses = [];

    for (var expenses in expensesList) {
      // Check if adding this row will exceed available space (accounting for margins and header)
      if (currentHeight + contentHeight > (pageHeight - margin * 2)) {
        // If it exceeds, add the current page to allPages and start a new page
        allPages.add(currentPageExpenses);
        currentPageExpenses = [expenses]; // Start with current row on next page
        currentHeight = headerHeight +
            contentHeight; // Reset height for new page (including header)
      } else {
        // If there's space, add the row to the current page
        currentPageExpenses.add(expenses);
        currentHeight += contentHeight; // Add row height to the current height
      }
    }

    // Add remaining rows to the last page if any
    if (currentPageExpenses.isNotEmpty) {
      allPages.add(currentPageExpenses);
    }

    totalPages = allPages.length;

    // Return the generated PDF document, total pages, and paginated data
    return {'pdf': pdf, 'totalPages': totalPages, 'allPages': allPages};
  }

  void expenseReportGenerator(BuildContext context,
      List<dynamic> expensesOrOtherExpenses, bool isOtherExpense) async {
    final result = await generatePdf(context, expensesOrOtherExpenses);
    final pdf = result['pdf'] as pw.Document;
    totalPages = result['totalPages'] as int;
    allPages = result['allPages'] as List<List<dynamic>>;
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";

    if (isOtherExpense) {
      if (!context.mounted) return;
      context.go('/app/otherExpensePdf');
    } else {
      if (!context.mounted) return;
      context.go('/app/expensePdf');
    }
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
