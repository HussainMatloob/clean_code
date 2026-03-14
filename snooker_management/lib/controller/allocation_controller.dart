import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/models/allocation_model.dart';
import 'package:snooker_management/models/cancel_update_allocation_model.dart';
import 'package:snooker_management/models/member_model.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/services/allocation_services.dart';
import 'package:snooker_management/services/pdf_services/allocation_pdf_service.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class AllocationController extends GetxController {
  TextEditingController player1 = TextEditingController();
  TextEditingController player2 = TextEditingController();
  TextEditingController player3 = TextEditingController();
  TextEditingController player4 = TextEditingController();
  TextEditingController saleAmountController = TextEditingController();
  bool isExpanded = false;
  List<String> membersNameList = [];
  List<MemberModel> membersList = [];
  String? selectedCustomName;
  final Map<int, RxString> tableTimeMap =
      {}; // Holds reactive times for each table
  final Map<int, Timer?> tableTimers =
      {}; // Holds individual timers for each table
  List<CancelAndUpdateAllocationModel> allocationsStatus = [];
  String selectedStatus = "Single";
  String? selectedAllocationReportOption;
  String? selectedMonthOrTable;
  List<String> tablesNumberList = [];
  double totalAmount = 0.0;
  String? useruid;

  void showOrHideReportOption() {
    isExpanded = !isExpanded;
    selectedAllocationReportOption = null;
    selectedMonthOrTable = null;
    update();
  }

  void clearTablesList() {
    tablesNumberList.clear();
    isExpanded = false;
    update();
  }

  void getUid() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    useruid = sp.getString('uId') ?? "";

    update();
  }

  Future<void> initialmethodsOfAllocation() async {
    clearTablesList();
    await getStatusOfAllocations(true);
    clearMembersNameList();
    await getMembersName();
    getUid();
  }
  /*--------------------------------------------------------------------------*/
  /*                             get member discount                          */
  /*--------------------------------------------------------------------------*/

  MemberModel? memberModel;

  void getMemberDiscount(String memberName) async {
    if (memberName.contains("(Member)")) {
      String name = memberName.replaceAll("(Member)", "").trim();
      FlushMessagesUtil.easyLoading();
      memberModel =
          await FirebaseAllocationServices.getSpecificMemberDiscount(name);
      EasyLoading.dismiss();
      double discount = (memberModel?.discount ?? 0.0).toDouble();
      double finalAmount = totalAmount - discount;
      saleAmountController.text = finalAmount.toString();
      update();
    } else {
      memberModel = null;
      saleAmountController.text = totalAmount.toString();
      update();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                            select  report option                         */
  /*--------------------------------------------------------------------------*/
  void selectAllocationReportOption(String value) {
    selectedAllocationReportOption = value;
    update();
  }

  void clearSelections() {
    selectedAllocationReportOption = null;
    selectedMonthOrTable = null;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                        save start time of each table                     */
  /*--------------------------------------------------------------------------*/
  final Map<String, RxString> gameTimes = {};
  void updateTableTime(String tableNumber, String newTime) {
    gameTimes[tableNumber] = newTime.obs;
  }

  void setPayedAmount(CancelAndUpdateAllocationModel currentTablePrice) {
    memberModel = null;
    saleAmountController.clear();
    totalAmount = currentTablePrice.tablePrice ?? 0.0;
    update();
  }

  void updateSelectedStatus(String value) {
    selectedStatus = value;
    update();
  }

  void selectStatus(String value) {
    selectedStatus = value;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                               tables timer logic                         */
  /*--------------------------------------------------------------------------*/
  // Update time for a specific table
  String updateTimer(int tableId, String gameTime) {
    // Parse provided time
    DateTime startDateTime = DateFormat('HH:mm:ss').parse(gameTime);

    // Convert gameTime to Duration
    Duration initialOffset = Duration(
      hours: startDateTime.hour,
      minutes: startDateTime.minute,
      seconds: startDateTime.second,
    );

    // Initialize the reactive time if not already done
    tableTimeMap.putIfAbsent(tableId, () => "".obs);

    // Start a new timer for the table if not already active
    if (tableTimers[tableId] == null ||
        !(tableTimers[tableId]?.isActive ?? false)) {
      tableTimers[tableId] = Timer.periodic(const Duration(seconds: 1), (_) {
        // Increment the initial offset by 1 second
        initialOffset += const Duration(seconds: 1);

        // Update the reactive time for the specific table
        tableTimeMap[tableId]?.value = _formatDuration(initialOffset);
      });
    }
    return tableTimeMap[tableId]?.value ?? "00:00:00";
  }

  // Helper function to format Duration into HH:mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  // Cleanup timers when no longer needed
  @override
  void onClose() {
    tableTimers.forEach((_, timer) => timer?.cancel());
    player1.dispose();
    player2.dispose();
    player3.dispose();
    player4.dispose();
    saleAmountController.dispose();
    super.onClose();
  }

  /*--------------------------------------------------------------------------*/
  /*                                check and validation                      */
  /*--------------------------------------------------------------------------*/

  String? customFieldsValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please must enter Player Name";
    }
    return null;
  }

  String? saleAmountValidateValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please must enter amount";
    }
    return null;
  }

  /*--------------------------------------------------------------------------*/
  /*                            get table allocations                         */
  /*--------------------------------------------------------------------------*/
  Future<void> getStatusOfAllocations(bool isGetTables) async {
    allocationsStatus =
        await FirebaseAllocationServices.getCancelAndUpdateAllocationsDetail();
    update();
    if (isGetTables) {
      for (int i = 0; i < allocationsStatus.length; i++) {
        tablesNumberList.add(allocationsStatus[i].tableNumber!);
      }
      update();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                          update table allocation                         */
  /*--------------------------------------------------------------------------*/
  Future<void> updateAllocation(
      TableDetailModel tableModel,
      BuildContext context,
      bool isAllocate,
      String index,
      bool isAddAble) async {
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
      Timestamp oldTime = allocationsStatus[int.parse(index)].startTime!;
      await FirebaseAllocationServices.updateTableAllocation(
          tableModel,
          context,
          isAllocate,
          player1.text.trim(),
          player2.text.trim(),
          player3.text.trim(),
          player4.text.trim(),
          selectedStatus,
          isAddAble,
          oldTime);
      await getStatusOfAllocations(false);

      if (isAddAble) {
        updateTableTime(index.toString(), "00:00:00");
        int tableId = int.parse(tableModel.tableNumber);
        resetTableTime(tableId); // Call the reset function
      }

      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
        context,
        isAddAble
            ? "Allocation added successfully"
            : "Allocation updated successfully",
        true,
      );
    } catch (e) {
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                               reset table time                           */
  /*--------------------------------------------------------------------------*/
  void resetTableTime(int tableId) {
    // Stop and remove the old timer for the specific table
    if (tableTimers[tableId]?.isActive ?? false) {
      tableTimers[tableId]?.cancel(); // Cancel the running timer
    }
    tableTimers.remove(tableId); // Remove the timer from the map

    // Reset the time in the reactive map to "00:00:00"
    tableTimeMap[tableId]?.value = "00:00:00"; // Update the time
  }

  /*--------------------------------------------------------------------------*/
  /*                          cancel table allocation                         */
  /*--------------------------------------------------------------------------*/
  Future<void> cancelAllocation(TableDetailModel tableModel,
      BuildContext context, bool isAllocate, bool isDone) async {
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
      await FirebaseAllocationServices.cancelTableAllocation(
          tableModel, context, isAllocate);
      await getStatusOfAllocations(false);
      if (!isDone) {
        EasyLoading.dismiss();
        Navigator.of(context).pop();
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
  /*                           get Members Name logic                         */
  /*--------------------------------------------------------------------------*/

  Future<void> getMembersName() async {
    membersList = await FirebaseAllocationServices.getActivatedMembersName();
    for (int i = 0; i < membersList.length; i++) {
      membersNameList.add(membersList[i].memberName!);
    }
    update();
  }

  void clearMembersNameList() {
    membersNameList.clear();
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                   Select value from editable drop down                   */
  /*--------------------------------------------------------------------------*/
  void selectValueFromEditableDropDown(
      String value, TextEditingController fieldController) {
    fieldController.text = "$value(Member)";
    update();
  }

/*--------------------------------------------------------------------------*/
/*                        clearAll fields and selections                    */
/*--------------------------------------------------------------------------*/
  void clearAllSelections() {
    player1.clear();
    player2.clear();
    player3.clear();
    player4.clear();
    selectedStatus = "Single";
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                            set values for update                         */
  /*--------------------------------------------------------------------------*/
  void setValuesForUpdate(int index) {
    if (allocationsStatus[index].gameType == "Single") {
      player1.text = allocationsStatus[index].playersName![0];
      player3.text = allocationsStatus[index].playersName![1];
      selectedStatus = "Single";
      update();
    } else {
      player1.text = allocationsStatus[index].playersName![0];
      player2.text = allocationsStatus[index].playersName![1];
      player3.text = allocationsStatus[index].playersName![2];
      player4.text = allocationsStatus[index].playersName![3];
      selectedStatus = "Double";
      update();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                         select dropDown value logic                      */
  /*--------------------------------------------------------------------------*/

  Future<void> selectTable(String value, BuildContext context) async {
    selectedMonthOrTable = value;
    update();
  }

  void selectDropDownListValue(String value, bool isShowingNames) {
    selectedCustomName = value;
    update();
    getMemberDiscount(value);
  }

  void clearSelectedDropDownValue() {
    selectedCustomName = null;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                             done allocation logic                         */
  /*--------------------------------------------------------------------------*/
  Future<void> doneAllocation(
    BuildContext context,
    CancelAndUpdateAllocationModel cancelAndUpdateAllocationModel,
    TableDetailModel tableModel,
    String startTime,
    String endTime,
    String totalTime,
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
      if (selectedCustomName == null) {
        DialogHelper.showAttentionDialog(
            context, "Please select a looser name");
        return;
      }
      FlushMessagesUtil.easyLoading();

      final isPaid = selectedStatus == "Pay now";
      if (!context.mounted) return;
      await FirebaseAllocationServices.doneTableAllocation(
        context,
        cancelAndUpdateAllocationModel,
        startTime,
        endTime,
        totalTime,
        selectedCustomName.toString(),
        saleAmountController.text.trim(),
        !isPaid,
      );

      cancelAllocation(tableModel, context, false, true);
      EasyLoading.dismiss();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
        context,
        isPaid
            ? "Sale added successfully!"
            : "Allocation moved to sale successfully!",
        false,
      );
    } catch (e) {
      EasyLoading.dismiss();
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  String? snookerName;
  Uint8List? image;

  Uint8List? pdfBytes;

  /*--------------------------------------------------------------------------*/
  /*                       generate allocations report                        */
  /*--------------------------------------------------------------------------*/
  Future<void> generateAllocationReports(BuildContext context) async {
    try {
      if (selectedAllocationReportOption != null &&
          selectedMonthOrTable != null) {
        FlushMessagesUtil.easyLoading();
        List<AllocationModel> allocationsList =
            await FirebaseAllocationServices.generateAllocationsReportByTable(
                context,
                selectedAllocationReportOption!,
                selectedMonthOrTable!);

        if (!context.mounted) return;
        List<AllocationModel> allocationDetails = allocationsList;
        if (allocationDetails.isNotEmpty) {
          generateAllocationPdf(allocationDetails, context);
        } else {
          EasyLoading.dismiss();
          DialogHelper.showNoticeDialog(
              context, "No allocations exist for the selected criteria");
        }
      } else if (selectedAllocationReportOption != null) {
        FlushMessagesUtil.easyLoading();
        List<AllocationModel> allocationsList =
            await FirebaseAllocationServices.generateAllocationReportInRange(
                context, selectedAllocationReportOption!);

        List<AllocationModel> allocationDetail = allocationsList;
        if (!context.mounted) return;
        if (allocationDetail.isNotEmpty) {
          generateAllocationPdf(allocationDetail, context);
        } else {
          EasyLoading.dismiss();
          DialogHelper.showNoticeDialog(
              context, "No allocations exist for the selected criteria");
        }
      } else {
        EasyLoading.dismiss();
        DialogHelper.showAttentionDialog(
            context, "Please select a report option to continue");
      }
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
      EasyLoading.dismiss();
      update();
    }
  }

  Future<void> generateAllocationPdf(
      List<AllocationModel> allocations, BuildContext context) async {
    /// LOAD LOGO
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    /// LOAD CLUB NAME
    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";
    update();

    /// ⭐ GENERATE PDF
    pdfBytes = await AllocationPdfService.generatePdf(
      allocations: allocations,
      snookerName: snookerName ?? "",
      image: image,
    );

    EasyLoading.dismiss();

    update();
    if (!context.mounted) return;
    context.go('/app/allocationPdf');
  }
}
