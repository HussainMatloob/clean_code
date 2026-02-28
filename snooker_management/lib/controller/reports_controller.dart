import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snooker_management/services/report_services.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';

class ReportsController extends GetxController {
  TextEditingController dateController = TextEditingController();
  String? selectedCustomName;
  String? selectedReportMethod;
  double toDayTablesSale = 0.0;
  double toDayExpenses = 0.0;
  double totalOfSalesAndExpenses = 0.0;
  List<double> profitAndLoss = [0.0, 50.0, 50.0];
  List<String> tableNumbers = [];

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
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

  void selectReportMethod(String value) {
    selectedReportMethod = value;
    update();
  }

  void resetAllSelections(bool isTableNumberClear) {
    dateController.clear();
    selectedReportMethod = null;
    selectedCustomName = null;
    totalOfSalesAndExpenses = 0.0;
    profitAndLoss = [0.0, 50.0, 50.0];
    if (isTableNumberClear) {
      tableNumbers.clear();
    }
    update();
  }

/*--------------------------------------------------------------------------*/
/*                           select dropDown value                          */
/*--------------------------------------------------------------------------*/
  void selectDropDownListValue(String value, bool isReportsMethod) {
    selectedCustomName = value;
    update();
  }

/*--------------------------------------------------------------------------*/
/*                            get toDay tables Sale                          */
/*--------------------------------------------------------------------------*/
  Future<void> getToDayTablesSale() async {
    try {
      toDayTablesSale = await FirebaseReportServices.getTodayTablesSale();
      update();
    } catch (e) {
      toDayTablesSale = 0.0;
      update();
    }
  }

/*--------------------------------------------------------------------------*/
/*                              get toDay expenses                          */
/*--------------------------------------------------------------------------*/
  Future<void> getTodayExpenses() async {
    try {
      toDayExpenses = await FirebaseReportServices.getTodayExpenses();
      update();
    } catch (e) {
      toDayExpenses = 0.0;
      update();
    }
  }

/*--------------------------------------------------------------------------*/
/*             get total sales and expenses in date range                   */
/*--------------------------------------------------------------------------*/
  Future<void> getTotalOfSalesAndExpenses(BuildContext context) async {
    try {
      if (dateController.text.trim().isEmpty) {
        if (selectedReportMethod != null) {
          if (selectedCustomName == "Table Sales") {
            FlushMessagesUtil.easyLoading();
            totalOfSalesAndExpenses =
                await FirebaseReportServices.getTableSalesInDateRange(
                    context, selectedReportMethod!, dateController.text, false);

            update();
          } else if (selectedCustomName == "All Expenses") {
            FlushMessagesUtil.easyLoading();
            totalOfSalesAndExpenses =
                await FirebaseReportServices.getAllExpensesInDateRange(
                    context, selectedReportMethod!, dateController.text, false);

            update();
          } else if (selectedCustomName == "Other Expenses") {
            FlushMessagesUtil.easyLoading();
            totalOfSalesAndExpenses =
                await FirebaseReportServices.getOtherExpensesInDateRange(
                    context, selectedReportMethod!, dateController.text, false);

            update();
          } else if (selectedCustomName == "Profit&Loss") {
            FlushMessagesUtil.easyLoading();
            profitAndLoss =
                await FirebaseReportServices.getProfitAndLossInDateRange(
                    context, selectedReportMethod!, dateController.text, false);
            totalOfSalesAndExpenses = profitAndLoss[0];

            update();
          } else {
            DialogHelper.showAttentionDialog(
                context, "Kindly select an option from the dropdown");
          }
        } else {
          DialogHelper.showAttentionDialog(
              context, "Please select a report option to continue");
        }
      } else {
        if (selectedCustomName == "Table Sales") {
          FlushMessagesUtil.easyLoading();
          totalOfSalesAndExpenses =
              await FirebaseReportServices.getTableSalesInDateRange(
                  context, "Daily", dateController.text, true);

          update();
        } else if (selectedCustomName == "All Expenses") {
          FlushMessagesUtil.easyLoading();
          totalOfSalesAndExpenses =
              await FirebaseReportServices.getAllExpensesInDateRange(
                  context, "Daily", dateController.text, true);

          update();
        } else if (selectedCustomName == "Other Expenses") {
          FlushMessagesUtil.easyLoading();
          totalOfSalesAndExpenses =
              await FirebaseReportServices.getOtherExpensesInDateRange(
                  context, "Daily", dateController.text, true);

          update();
        } else if (selectedCustomName == "Profit&Loss") {
          FlushMessagesUtil.easyLoading();
          profitAndLoss =
              await FirebaseReportServices.getProfitAndLossInDateRange(
                  context, "Daily", dateController.text, true);
          totalOfSalesAndExpenses = profitAndLoss[0];

          update();
        } else {
          DialogHelper.showAttentionDialog(
              context, "Kindly select an option from the dropdown");
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
  }
}
