import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/models/member_billing_model.dart';
import 'dart:typed_data' as typed_data;
import 'package:snooker_management/models/member_model.dart';
import 'package:snooker_management/models/package_model.dart';
import 'package:snooker_management/services/membership_services.dart';
import 'package:snooker_management/services/package_services.dart';
import 'package:snooker_management/services/pdf_services/member_pdf_service.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class MemberController extends GetxController {
  TextEditingController searchController = TextEditingController();
  TextEditingController memberNameController = TextEditingController();
  TextEditingController memberContactController = TextEditingController();
  TextEditingController memberAddressController = TextEditingController();
  TextEditingController memberNICController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController packagePrice = TextEditingController();
  TextEditingController packageDuration = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController packageName = TextEditingController();
  TextEditingController billDateController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  GlobalKey<FormState> fieldsKey = GlobalKey<FormState>();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  List<String> packagesNameList = [];
  List<String> membersNameList = [];
  String selectedStatus = "Unblock";
  bool isMemberSearching = false;
  bool isMemberBillSearching = false;
  MemberModel? searchedMember;
  MemberBillingModel? searchedMemberBill;
  List<PackageModel> packagesList = [];
  List<MemberModel> membersList = [];
  String? selectedPackageName;
  String? selectedCustomName;

  String? selectedBillingReportOption;
  String? selectedMemberReportOption;
  final DateTime currentDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  late String date;
  bool? isMemberExist;
  // Constructor for ChildFormPage

  @override
  void onClose() {
    searchController.dispose();
    memberNameController.dispose();
    memberContactController.dispose();
    memberAddressController.dispose();
    memberNICController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    packagePrice.dispose();
    packageDuration.dispose();
    paymentMethodController.dispose();
    packageName.dispose();
    billDateController.dispose();
    discountController.dispose();
    super.onClose();
  }

  void setBillingData(MemberModel memberModel) {
    date = dateFormat.format(currentDate);
    billDateController.text = date;
    memberNameController.text = memberModel.memberName!;
    packageName.text = memberModel.packageName!;
    packagePrice.text = memberModel.packagePrice!;
    packageDuration.text = memberModel.packageDuration!;
    startDateController.clear();
    endDateController.clear();
    update();
  }

  String? userUid;
  void getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userUid = sp.getString('uId') ?? "";
    update();
  }

  void selectBillingReportOption(String value) {
    selectedBillingReportOption = value;
    update();
  }

  void selectMemberReportOption(String value) {
    selectedMemberReportOption = value;
    update();
  }

  void setNullSelectedReportOption() {
    selectedBillingReportOption = null;
    selectedMemberReportOption = null;
    update();
  }

  int calculatedTotalMembers = 0;
  Future<void> calculateTotalMembers() async {
    calculatedTotalMembers =
        await FirebaseMembershipServices.calculateTotalMembers();
    update();
  }

  int calculatedActivatedMembers = 0;
  Future<void> calculateActivatedMembers() async {
    calculatedActivatedMembers =
        await FirebaseMembershipServices.calculateActivatedMembers();
    update();
  }

  int calculatedDActivatedMembers = 0;
  Future<void> calculateDactivatedMembers() async {
    calculatedDActivatedMembers =
        await FirebaseMembershipServices.calculateExpireMembers();
    update();
  }

  String formatDate(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to 'yyyy-MM-dd'
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  /*--------------------------------------------------------------------------*/
  /*                               set block Status                           */
  /*--------------------------------------------------------------------------*/
  void updateBlockStatus(String value) {
    selectedStatus = value;
    update();
  }

  void selectStatus(String value) {
    selectedStatus = value;
    update();
  }

  void setBlockStatus(String status) {
    selectedStatus = status;
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
  /*                           get Packages Name logic                        */
  /*--------------------------------------------------------------------------*/

  Future<void> getPackagesName(BuildContext context) async {
    packagesList = await FirebasePackageServices.getPackagesForMember(context);
    for (int i = 0; i < packagesList.length; i++) {
      packagesNameList.add(packagesList[i].packageName!);
    }
    update();
  }

  void clearPackagesNameList() {
    packagesNameList.clear();
    update();
  }

  void clearMembersNameList() {
    membersNameList.clear();
    update();
  }

  void clearFieldsAndSelections() {
    pickImage(null);
    memberNameController.clear();
    memberContactController.clear();
    memberAddressController.clear();
    memberNICController.clear();
    startDateController.clear();
    endDateController.clear();
    packageDuration.clear();
    packagePrice.clear();
    discountController.clear();
    clearSelectedDropDownValue();
    updateBlockStatus("Unblock");
  }

  /*--------------------------------------------------------------------------*/
  /*                           get Members Name logic                         */
  /*--------------------------------------------------------------------------*/

  Future<void> getMembersName(BuildContext context) async {
    membersList = await FirebaseMembershipServices.getMembersName(context);
    for (int i = 0; i < membersList.length; i++) {
      membersNameList.add(membersList[i].memberName!);
    }
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                         select dropDown value logic                      */
  /*--------------------------------------------------------------------------*/

  void selectDropDownListValue(String value, bool isShowingMembers) {
    if (isShowingMembers) {
      selectedCustomName = value;
      update();
    } else {
      selectedPackageName = value;
      update();
      for (int i = 0; i <= packagesList.length; i++) {
        if (selectedPackageName == packagesList[i].packageName) {
          packagePrice.text = packagesList[i].packagePrice!;
          packageDuration.text = packagesList[i].packageDuration!;
        }
      }
      update();
    }
  }

  void clearSelectedDropDownValue() {
    selectedPackageName = null;
    selectedCustomName = null;
    update();
  }

  void setSelectedPackage(String package) {
    selectedPackageName = package;
    update();
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
  /*                                search member                             */
  /*--------------------------------------------------------------------------*/
  Future<void> searchMember(BuildContext context) async {
    try {
      // Perform the search
      searchedMember = await FirebaseMembershipServices.searchMember(
          searchController.text.trim(), context);

      // Stop the progress indicator after the search is complete
      memberSearchingProgress(false);
      update();
    } catch (e) {
      memberSearchingProgress(false);
      searchedMember = null;
      update();
    } finally {
      memberSearchingProgress(false);
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                               search member bill                          */
  /*--------------------------------------------------------------------------*/
  Future<void> searchMemberBill(BuildContext context) async {
    // Perform the search
    searchedMemberBill = await FirebaseMembershipServices.searchMemberBill(
        billDateController.text.trim(), selectedCustomName!, context);
    // Stop the progress indicator after the search is complete
    memberBillSearchingProgress(false);
    update();
  }

  void setMemberAndBillingNull() {
    searchedMember = null;
    searchedMemberBill = null;
    update();
  }

  void memberSearchingProgress(value) {
    isMemberSearching = value;
    update();
  }

  void memberBillSearchingProgress(value) {
    isMemberBillSearching = value;
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                check and validation                      */
  /*--------------------------------------------------------------------------*/

  String? memberNameValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Member Name";
    }
    return null;
  }

  RegExp contactRegex = RegExp(r'^[0-9]{11}$');
  String? memberContactValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter eleven digit phone number";
    } else if (!contactRegex.hasMatch(value)) {
      return "Please enter valid number";
    }
    return null;
  }

  String? memberAddressValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter Member Address";
    }
    return null;
  }

  RegExp nicRegex = RegExp(r'^[0-9]{13}$');
  String? memberNicValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter NIC without dashes";
    } else if (!nicRegex.hasMatch(value)) {
      return "Please enter valid NIC";
    }
    return null;
  }

  String? memberStartDateValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select Start Date";
    }
    return null;
  }

  String? memberEndDateValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select End Date";
    }
    return null;
  }

  String? memberBillDateValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select Billing Date";
    }
    return null;
  }

  String? discountValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please must set discount";
    }
    return null;
  }

/*--------------------------------------------------------------------------*/
/*                               check member exist                         */
/*--------------------------------------------------------------------------*/
  Future<void> checkMemberExist() async {
    isMemberExist = await FirebaseMembershipServices.memberExist(
        memberNameController.text.trim());
    update();
  }

  /*--------------------------------------------------------------------------*/
  /*                                 add member logic                         */
  /*--------------------------------------------------------------------------*/
  Future<void> addMember(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      DateTime startDate = dateFormat.parse(startDateController.text);
      DateTime endDate = dateFormat.parse(endDateController.text);
      await checkMemberExist();
      if (!context.mounted) return;
      if (isMemberExist!) {
        if (selectedPackageName != null) {
          if (newImage != null) {
            if (startDate.isAfter(endDate)) {
              DialogHelper.showNoticeDialog(context,
                  "Start date cannot be after the end date. Please correct it");
            } else {
              FlushMessagesUtil.easyLoading();
              await FirebaseMembershipServices.addNewMember(
                  context,
                  memberNameController.text.trim(),
                  memberContactController.text,
                  memberAddressController.text,
                  selectedPackageName!,
                  memberNICController.text,
                  discountController.text,
                  selectedStatus,
                  startDateController.text,
                  endDateController.text,
                  packageDuration.text,
                  packagePrice.text,
                  newImage!);
              EasyLoading.dismiss();
              calculateTotalMembers();
              calculateActivatedMembers();
              calculateDactivatedMembers();
              setMemberAndBillingNull();
              if (!context.mounted) return;
              Navigator.of(context).pop();
              if (!context.mounted) return;
              DialogHelper.showSuccessDialog(
                context,
                "Member Added Successfully!",
                false,
              );
            }
          } else {
            if (!context.mounted) return;
            DialogHelper.showAttentionDialog(
                context, "Kindly select an image to proceed");
          }
        } else {
          if (!context.mounted) return;
          DialogHelper.showAttentionDialog(
              context, "Kindly select a package to continue");
        }
      } else {
        if (!context.mounted) return;
        DialogHelper.showNoticeDialog(context,
            "This name is already in use. Please choose a different name");
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
  /*                               update member logic                        */
  /*--------------------------------------------------------------------------*/
  Future<void> updateMember(BuildContext context, String id, String memberImage,
      String memberName) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      DateTime startDate = dateFormat.parse(startDateController.text);
      DateTime endDate = dateFormat.parse(endDateController.text);

      if (memberName != memberNameController.text.trim()) {
        await checkMemberExist();
      } else {
        isMemberExist = true;
        update();
      }
      if (!context.mounted) return;
      if (isMemberExist!) {
        if (newImage == null) {
          if (startDate.isAfter(endDate)) {
            DialogHelper.showNoticeDialog(context,
                "Start date cannot be after the end date. Please correct it");
          } else {
            FlushMessagesUtil.easyLoading();
            await FirebaseMembershipServices.updateMemberWithSameImage(
              context,
              id,
              memberNameController.text.trim(),
              memberContactController.text,
              memberAddressController.text,
              selectedPackageName!,
              memberNICController.text,
              discountController.text,
              selectedStatus,
              startDateController.text,
              endDateController.text,
              packageDuration.text,
              packagePrice.text,
              memberImage,
            );
            EasyLoading.dismiss();
            calculateTotalMembers();
            calculateActivatedMembers();
            calculateDactivatedMembers();
            setMemberAndBillingNull();

            Navigator.of(context).pop();
            if (!context.mounted) return;
            DialogHelper.showSuccessDialog(
              context,
              "Member updated successfully!",
              false,
            );
          }
        } else {
          if (startDate.isAfter(endDate)) {
            DialogHelper.showNoticeDialog(context,
                "Start date cannot be after the end date. Please correct it");
          } else {
            FlushMessagesUtil.easyLoading();
            await FirebaseMembershipServices.updateMemberWithNewImage(
              context,
              id,
              memberNameController.text.trim(),
              memberContactController.text,
              memberAddressController.text,
              selectedPackageName!,
              memberNICController.text,
              discountController.text,
              selectedStatus,
              startDateController.text,
              endDateController.text,
              packageDuration.text,
              packagePrice.text,
              newImage!,
            );
            EasyLoading.dismiss();
            calculateTotalMembers();
            calculateActivatedMembers();
            calculateDactivatedMembers();
            setMemberAndBillingNull();

            Navigator.of(context).pop();
            if (!context.mounted) return;
            DialogHelper.showSuccessDialog(
              context,
              "Member updated successfully!",
              false,
            );

            pickImage(null);
          }
        }
      } else {
        DialogHelper.showNoticeDialog(context,
            "This name is already in use. Please choose a different name");
      }
    } catch (e) {
      EasyLoading.dismiss();
      DialogHelper.showExceptionErrorDialog(context, "$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                             delete member logic                          */
  /*--------------------------------------------------------------------------*/

  void memberDeleteAction(MemberModel memberModel, BuildContext context) async {
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
      await FirebaseMembershipServices.deleteMemberRow(memberModel.id!);
      EasyLoading.dismiss();
      calculateTotalMembers();
      calculateActivatedMembers();
      calculateDactivatedMembers();
      setMemberAndBillingNull();
      if (!context.mounted) return;
      pickImage(null);
      Navigator.of(context).pop();
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
        context,
        "Member deleted successfully!",
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
  /*                         delete member bill logic                         */
  /*--------------------------------------------------------------------------*/

  void memberBillDeleteAction(
      MemberBillingModel memberBillingModel, BuildContext context) {
    FlushMessagesUtil.easyLoading();
    try {
      FirebaseMembershipServices.deleteMemberBill(memberBillingModel.id!)
          .then((value) => {
                EasyLoading.dismiss(),
                setMemberAndBillingNull(),
                FlushMessagesUtil.snackBarMessage(
                    "Success", "Member Bill deleted successfully", context),
                Navigator.of(context).pop(),
              });
    } catch (e) {
      EasyLoading.dismiss();
      FlushMessagesUtil.snackBarMessage("Error", e.toString(), context);
      Navigator.of(context).pop();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                             add member bill logic                        */
  /*--------------------------------------------------------------------------*/
  void addMemberBillFunction(BuildContext context, MemberModel memberModel) {
    try {
      DateTime now = DateTime.now();
      DateTime currentDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      DateTime startDate = dateFormat.parse(startDateController.text);
      DateTime endDate = dateFormat.parse(endDateController.text);
      DateTime billDate = dateFormat.parse(billDateController.text);

      if (billDate.isAfter(currentDate)) {
        FlushMessagesUtil.snackBarMessage(
            "Error", "Please enter valid Bill date", context);
      } else if (startDate.isAfter(endDate)) {
        FlushMessagesUtil.snackBarMessage(
            "Error", "Please enter valid Start date and End date", context);
      } else {
        FlushMessagesUtil.easyLoading();
        FirebaseMembershipServices.addMemberBill(
                context,
                memberModel,
                billDateController.text,
                startDateController.text,
                endDateController.text,
                paymentMethodController.text)
            .then((onValue) {
          setMemberAndBillingNull();
          EasyLoading.dismiss();
          calculateTotalMembers();
          calculateActivatedMembers();
          calculateDactivatedMembers();
          FlushMessagesUtil.snackBarMessage(
              "Success", "Bill added successfully", context);
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      FlushMessagesUtil.snackBarMessage(
          "Error", "${e.toString()},${'dd-MM-yyyy'}", context);
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                      generate member report logic                        */
  /*--------------------------------------------------------------------------*/

  String? snookerName;
  Uint8List? image;

  Uint8List? membersPdfBytes;
  Uint8List? billingMembersPdfBytes;
  Future<void> memberReportGenerator(BuildContext context,
      List<dynamic> membersOrBillingList, bool isMemberBill) async {
    /// LOAD LOGO
    image =
        (await rootBundle.load(ImageConstant.tableLogo)).buffer.asUint8List();

    /// LOAD CLUB NAME
    SharedPreferences sp = await SharedPreferences.getInstance();
    snookerName = sp.getString('clubName') ?? "";
    update();

    /// ⭐ GENERATE PDF
    if (isMemberBill) {
      // otherExpensepdfBytes = await  MemberBillingPdfService.generatePdf(
      //    memberBills:  memberBills,
      //   snookerName: snookerName ?? "",
      //   image: image,
      // );
    } else {
      try {
        membersPdfBytes = await MemberPdfServices.generatePdf(
          members: membersOrBillingList,
          snookerName: snookerName ?? "",
          image: image,
        );
      } catch (e) {
        print("Data=======__----------------- $e");
      }
    }

    EasyLoading.dismiss();
    update();

    if (isMemberBill) {
      // if (!context.mounted) return;
      // context.go('/app/memberBillsExpensePdf');
    } else {
      if (!context.mounted) return;
      context.go("/app/membershipPdf");
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                          generate  Members Pdf                           */
  /*--------------------------------------------------------------------------*/
  Future<void> generateMembersPdf(BuildContext context) async {
    try {
      if (selectedMemberReportOption == "Activated Members") {
        FlushMessagesUtil.easyLoading();
        List<MemberModel> activatedMembersList =
            await FirebaseMembershipServices.generateActivatedMembersReport(
                context);

        List<MemberModel> memberModel = activatedMembersList;
        if (memberModel.isNotEmpty) {
          memberReportGenerator(context, memberModel, false);
        } else {
          if (!context.mounted) return;
          EasyLoading.dismiss();
          DialogHelper.showNoticeDialog(context,
              "There are currently no activated member records available");
        }
      } else if (selectedMemberReportOption == "Expire Members") {
        FlushMessagesUtil.easyLoading();
        List<MemberModel> expireMembers =
            await FirebaseMembershipServices.generateExpireMembersReport(
                context);

        List<MemberModel> memberModel = expireMembers;
        if (memberModel.isNotEmpty) {
          if (!context.mounted) return;
          memberReportGenerator(context, memberModel, false);
        } else {
          if (!context.mounted) return;
          EasyLoading.dismiss();
          DialogHelper.showNoticeDialog(context,
              "There are currently no expire member records available");
        }
      } else {
        FlushMessagesUtil.easyLoading();
        List<MemberModel> totalMembers =
            await FirebaseMembershipServices.generateMemberReport(context);

        List<MemberModel> memberModel = totalMembers;
        if (memberModel.isNotEmpty) {
          if (!context.mounted) return;
          memberReportGenerator(context, memberModel, false);
        } else {
          if (!context.mounted) return;
          EasyLoading.dismiss();
          DialogHelper.showNoticeDialog(
              context, "There are currently no member records available");
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(context, "$e");
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                       generate  Members Billing Pdf                      */
  /*--------------------------------------------------------------------------*/
  Future<void> generateMembersBillPdf(BuildContext context) async {
    if (selectedCustomName != null && selectedBillingReportOption == null) {
      FlushMessagesUtil.easyLoading();
      await FirebaseMembershipServices.generateMembersBillReportByName(
              context, selectedCustomName!)
          .then((value) {
        List<MemberBillingModel> memberBillingModel = value;
        if (memberBillingModel.isNotEmpty) {
          memberReportGenerator(context, memberBillingModel, true);
        } else {
          EasyLoading.dismiss();
          FlushMessagesUtil.snackBarMessage(
              "error", "There is no any Member Bill record exist", context);
        }
      });
    } else if (selectedBillingReportOption != null) {
      FlushMessagesUtil.easyLoading();
      await FirebaseMembershipServices.generateMembersBillInDateRange(
              context, selectedBillingReportOption!)
          .then((value) {
        List<MemberBillingModel> memberBillingModel = value;
        if (memberBillingModel.isNotEmpty) {
          memberReportGenerator(context, memberBillingModel, true);
        } else {
          EasyLoading.dismiss();
          FlushMessagesUtil.snackBarMessage(
              "error", "There is no any Member Bill record exist", context);
        }
      });
    } else {
      FlushMessagesUtil.easyLoading();
      await FirebaseMembershipServices.generateMembersBillReport(context)
          .then((value) {
        List<MemberBillingModel> memberBillingModel = value;
        if (memberBillingModel.isNotEmpty) {
          memberReportGenerator(context, memberBillingModel, true);
        } else {
          EasyLoading.dismiss();
          FlushMessagesUtil.snackBarMessage(
              "error", "There is no any Member Bill record exist", context);
        }
      });
    }
  }
}
