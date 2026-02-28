import 'dart:typed_data' as typed_data;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/controller/member_controller.dart';
import 'package:snooker_management/models/member_billing_model.dart';
import 'package:snooker_management/models/member_model.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';
import '../utils/flush_messages_util.dart';

class FirebaseMembershipServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

  /*--------------------------------------------------------------------------*/
  /*                                 member exist                             */
  /*--------------------------------------------------------------------------*/
  static Future<bool> memberExist(String memberName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String uId = sp.getString('uId') ?? "";
    QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
        .collection('MembershipManagement')
        .doc(uId)
        .collection("MembershipDetail")
        .where("memberName", isEqualTo: memberName)
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }

  /*--------------------------------------------------------------------------*/
  /*                                   add member                             */
  /*--------------------------------------------------------------------------*/
  static Future<void> addNewMember(
      BuildContext context,
      String memberName,
      String memberContact,
      String memberAddress,
      String packageName,
      String memberNic,
      String discount,
      String blockStatus,
      String startDate,
      String endDate,
      String packageDuration,
      String packagePrice,
      typed_data.Uint8List employeeImage) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      // Parse the string into a DateTime object
      DateTime formatStartDate = dateFormat.parse(startDate);
      DateTime formatEndDate = dateFormat.parse(endDate);
      const ext = 'jpg'; // You can change this based on your image format
      final ref = storage.ref().child('MemberImages/$time.$ext');

      TaskSnapshot snapshot = await ref.putData(employeeImage);
      String imageUrl = await snapshot.ref.getDownloadURL();

      MemberModel memberModel = MemberModel(
          userId: uId,
          id: time,
          memberName: memberName,
          memberContact: memberContact,
          memberAddress: memberAddress,
          packageName: packageName,
          memberNic: memberNic,
          discount: double.parse(discount),
          blockStatus: blockStatus,
          startDate: Timestamp.fromDate(formatStartDate),
          endDate: Timestamp.fromDate(formatEndDate),
          packageDuration: packageDuration,
          packagePrice: packagePrice,
          image: imageUrl);

      await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .doc(time)
          .set(memberModel.toJson())
          .timeout(const Duration(seconds: 180), onTimeout: () {
        throw "Connection timed out. Please check your internet and try again.";
      });
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                 Update member                            */
  /*--------------------------------------------------------------------------*/
  static Future<void> updateMemberWithSameImage(
      BuildContext context,
      String id,
      String memberName,
      String memberContact,
      String memberAddress,
      String packageName,
      String memberNic,
      String discount,
      String blockStatus,
      String startDate,
      String endDate,
      String packageDuration,
      String packagePrice,
      String memImage) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      // Parse the string into a DateTime object
      DateTime formatStartDate = dateFormat.parse(startDate);
      DateTime formatEndDate = dateFormat.parse(endDate);

      await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .doc(id)
          .update({
        'memberName': memberName,
        'memberContact': memberContact,
        'memberAddress': memberAddress,
        'packageName': packageName,
        'memberNic': memberNic,
        'discount': double.parse(discount),
        'blockStatus': blockStatus,
        'startDate': Timestamp.fromDate(formatStartDate),
        'endDate': Timestamp.fromDate(formatEndDate),
        "packageDuration": packageDuration,
        "packagePrice": packagePrice,
        'image': memImage,
      }).timeout(const Duration(seconds: 180), onTimeout: () {
        throw "Connection timed out. Please check your internet and try again.";
      });
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> updateMemberWithNewImage(
      BuildContext context,
      String id,
      String memberName,
      String memberContact,
      String memberAddress,
      String packageName,
      String memberNic,
      String discount,
      String blockStatus,
      String startDate,
      String endDate,
      String packageDuration,
      String packagePrice,
      typed_data.Uint8List memImage) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      // Parse the string into a DateTime object
      DateTime formatStartDate = dateFormat.parse(startDate);
      DateTime formatEndDate = dateFormat.parse(endDate);
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      const ext = 'jpg';
      final ref = storage.ref().child('MemberImages/$time.$ext');
      TaskSnapshot snapshot = await ref.putData(memImage);
      String imageUrl = await snapshot.ref.getDownloadURL();

      await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .doc(id)
          .update({
        'memberName': memberName,
        'memberContact': memberContact,
        'memberAddress': memberAddress,
        'packageName': packageName,
        'memberNic': memberNic,
        'discount': double.parse(discount),
        'blockStatus': blockStatus,
        'startDate': Timestamp.fromDate(formatStartDate),
        'endDate': Timestamp.fromDate(formatEndDate),
        "packageDuration": packageDuration,
        "packagePrice": packagePrice,
        'image': imageUrl
      }).timeout(const Duration(seconds: 180), onTimeout: () {
        throw "Connection timed out. Please check your internet and try again.";
      });
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                 delete member                            */
  /*--------------------------------------------------------------------------*/
  static Future<void> deleteMemberRow(String id) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .doc(id)
          .delete()
          .timeout(const Duration(seconds: 180), onTimeout: () {
        throw "Connection timed out. Please check your internet and try again.";
      });
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                               search member                              */
  /*--------------------------------------------------------------------------*/
  static Future<MemberModel?> searchMember(
      String numberOrNic, BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> nicQuery = await fireStore
          .collection('MembershipManagement')
          .doc(user!.uid)
          .collection("MembershipDetail")
          .where("memberNic", isEqualTo: numberOrNic)
          .limit(1)
          .get();

      if (nicQuery.docs.isNotEmpty) {
        // Return the first matching document as a model
        return MemberModel.fromJson(nicQuery.docs.first.data());
      }

      // Check for employeeContact
      QuerySnapshot<Map<String, dynamic>> contactQuery = await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .where("memberContact", isEqualTo: numberOrNic)
          .limit(1)
          .get();

      if (contactQuery.docs.isNotEmpty) {
        return MemberModel.fromJson(contactQuery.docs.first.data());
      }
      // If no match is found, return null
      return null;
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                            generate member report                        */
  /*--------------------------------------------------------------------------*/
  static Future<List<MemberModel>> generateMemberReport(
      BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .orderBy("id", descending: true)
          .get();

      // Converting snapshot documents to a list of maps
      List<MemberModel> employeeList =
          snapshot.docs.map((doc) => MemberModel.fromJson(doc.data())).toList();

      return employeeList;
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                 get Members                              */
  /*--------------------------------------------------------------------------*/
  static Query<Map<String, dynamic>> getMembers(String uId) {
    return fireStore
        .collection('MembershipManagement')
        .doc(uId)
        .collection("MembershipDetail")
        .orderBy("id", descending: true);
  }

  /*--------------------------------------------------------------------------*/
  /*                            add Member Bill                               */
  /*--------------------------------------------------------------------------*/
  static Future<void> addMemberBill(
      BuildContext context,
      MemberModel memberModel,
      String billDate,
      String startDate,
      String endDate,
      String paymentMethod) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      // Parse the string into a DateTime object
      DateTime formatBillDate = dateFormat.parse(billDate);
      DateTime formatStartDate = dateFormat.parse(startDate);
      DateTime formatEndDate = dateFormat.parse(endDate);

      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final memberBillingModel = MemberBillingModel(
          userId: uId,
          id: time,
          memberId: memberModel.id,
          memberName: memberModel.memberName,
          packageName: memberModel.packageName,
          packagePrice: double.parse(memberModel.packagePrice!),
          packageDuration: memberModel.packageDuration,
          billDate: Timestamp.fromDate(
              formatBillDate), // Convert the DateTime object to a Firestore Timestamp
          startDate: Timestamp.fromDate(
              formatStartDate), // Convert the DateTime object to a Firestore Timestamp
          endDate: Timestamp.fromDate(
              formatEndDate), // Convert the DateTime object to a Firestore Timestamp
          paymentMethod: paymentMethod);
      await fireStore
          .collection('MemberBilling')
          .doc(uId)
          .collection("BillingDetails")
          .doc(time)
          .set(memberBillingModel.toJson());

      await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .doc(memberModel.id)
          .update({
        'startDate': Timestamp.fromDate(formatStartDate),
        'endDate': Timestamp.fromDate(formatEndDate),
      });
    } catch (e) {
      EasyLoading.dismiss();
      FlushMessagesUtil.snackBarMessage("error", e.toString(), context);
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                               get Member Bills                           */
  /*--------------------------------------------------------------------------*/
  static Query<Map<String, dynamic>> getMembersBill(String uId) {
    return fireStore
        .collection('MemberBilling')
        .doc(uId)
        .collection("BillingDetails")
        .orderBy("id", descending: true);
  }

  /*--------------------------------------------------------------------------*/
  /*                              get  Members Name                           */
  /*--------------------------------------------------------------------------*/

  static Future<List<MemberModel>> getMembersName(BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .get();

      // Converting snapshot documents to a list of maps
      List<MemberModel> membersList =
          snapshot.docs.map((doc) => MemberModel.fromJson(doc.data())).toList();

      return membersList;
    } catch (e) {
      return [];
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                              search  member bill                          */
  /*--------------------------------------------------------------------------*/
  static Future<MemberBillingModel?> searchMemberBill(
      String billDate, String memberName, BuildContext context) async {
    // Check for employeeNIC
    MemberController memberController = Get.find<MemberController>();
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      // Parse the string into a DateTime object
      DateTime formatBillDate = dateFormat.parse(billDate);
      QuerySnapshot<Map<String, dynamic>> billingQuery = await fireStore
          .collection('MemberBilling')
          .doc(uId)
          .collection("BillingDetails")
          .where(
            "billDate",
            isEqualTo: Timestamp.fromDate(formatBillDate),
          )
          .where("memberName", isEqualTo: memberName)
          .limit(1)
          .get();

      if (billingQuery.docs.isNotEmpty) {
        // Return the first matching document as a model
        return MemberBillingModel.fromJson(billingQuery.docs.first.data());
      }
      // If no match is found, return null
      return null;
    } catch (e) {
      FlushMessagesUtil.snackBarMessage(
          "error", "Failed to fetch billing details: ${e.toString()}", context);
      memberController.memberBillSearchingProgress(false);
      return null;
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                             delete member Bill                           */
  /*--------------------------------------------------------------------------*/
  static Future<void> deleteMemberBill(String id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String uId = sp.getString('uId') ?? "";
    await fireStore
        .collection('MemberBilling')
        .doc(uId)
        .collection("BillingDetails")
        .doc(id)
        .delete();
  }

  /*--------------------------------------------------------------------------*/
  /*             Calculate Activated Deactivated and Total Members            */
  /*--------------------------------------------------------------------------*/
  static Future<int> calculateTotalMembers() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> query = await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .get();
      return query.docs.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> calculateActivatedMembers() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      final DateTime currentDate = DateTime.now().toUtc(); // Convert to UTC
      DateTime startOfDay =
          DateTime.utc(currentDate.year, currentDate.month, currentDate.day);
      QuerySnapshot<Map<String, dynamic>> query = await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .where("endDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .get();
      return query.docs.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> calculateExpireMembers() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      final DateTime currentDate = DateTime.now().toUtc(); // Convert to UTC
      DateTime startOfDay = DateTime.utc(
          currentDate.year, currentDate.month, currentDate.day); // Ensure UTC

      QuerySnapshot<Map<String, dynamic>> query = await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .where("endDate", isLessThan: Timestamp.fromDate(startOfDay))
          .get();
      return query.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                      generate active members report                      */
  /*--------------------------------------------------------------------------*/
  static Future<List<MemberModel>> generateActivatedMembersReport(
      BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      final DateTime currentDate = DateTime.now().toUtc(); // Convert to UTC
      DateTime startOfDay =
          DateTime.utc(currentDate.year, currentDate.month, currentDate.day);
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .where("endDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .orderBy("id", descending: true)
          .get();

      // Converting snapshot documents to a list of maps
      List<MemberModel> membersList =
          snapshot.docs.map((doc) => MemberModel.fromJson(doc.data())).toList();

      return membersList;
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                      generate expire members report                      */
  /*--------------------------------------------------------------------------*/
  static Future<List<MemberModel>> generateExpireMembersReport(
      BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      final DateTime currentDate = DateTime.now().toUtc(); // Convert to UTC
      DateTime startOfDay =
          DateTime.utc(currentDate.year, currentDate.month, currentDate.day);
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .where("endDate", isLessThan: Timestamp.fromDate(startOfDay))
          .orderBy("id", descending: true)
          .get();

      // Converting snapshot documents to a list of maps
      List<MemberModel> membersList =
          snapshot.docs.map((doc) => MemberModel.fromJson(doc.data())).toList();

      return membersList;
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw e.toString();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                        generate member Billing report                    */
  /*--------------------------------------------------------------------------*/
  static Future<List<MemberBillingModel>> generateMembersBillReport(
      BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('MemberBilling')
          .doc(uId)
          .collection("BillingDetails")
          .orderBy("id", descending: true)
          .get();

      // Converting snapshot documents to a list of maps
      List<MemberBillingModel> memberBillingList = snapshot.docs
          .map((doc) => MemberBillingModel.fromJson(doc.data()))
          .toList();
      return memberBillingList;
    } catch (e) {
      EasyLoading.dismiss();
      FlushMessagesUtil.snackBarMessage("error", e.toString(), context);
      return [];
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                       generate member bill by name                       */
  /*--------------------------------------------------------------------------*/
  static Future<List<MemberBillingModel>> generateMembersBillReportByName(
      BuildContext context, String memberName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('MemberBilling')
          .doc(uId)
          .collection("BillingDetails")
          .where("memberName", isEqualTo: memberName)
          .orderBy("id", descending: true)
          .get();

      // Converting snapshot documents to a list of maps
      List<MemberBillingModel> memberBillingList = snapshot.docs
          .map((doc) => MemberBillingModel.fromJson(doc.data()))
          .toList();
      return memberBillingList;
    } catch (e) {
      EasyLoading.dismiss();
      FlushMessagesUtil.snackBarMessage("error", e.toString(), context);
      return [];
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                 generate member bill weekly,monthly,yearly               */
  /*--------------------------------------------------------------------------*/
  static Future<List<MemberBillingModel>> generateMembersBillInDateRange(
      BuildContext context, String dateRange) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Get the current date
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate =
          DateTime(now.year, now.month, now.day, 23, 59, 59); // End of today

      // Calculate the start date based on the condition
      if (dateRange == "Weekly") {
        startDate =
            now.subtract(const Duration(days: 7)); // 7 days back from today
      } else if (dateRange == "Monthly") {
        startDate = DateTime(now.year, now.month - 1, now.day); // 1 month back
      } else if (dateRange == "Yearly") {
        startDate = DateTime(now.year - 1, now.month, now.day); // 1 year back
      } else {
        // If the condition doesn't match, return an empty list
        return [];
      }
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('MemberBilling')
          .doc(uId)
          .collection("BillingDetails")
          .where("billDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("billDate", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true)
          .get();
      // Converting snapshot documents to a list of maps
      List<MemberBillingModel> memberBillingList = snapshot.docs
          .map((doc) => MemberBillingModel.fromJson(doc.data()))
          .toList();
      return memberBillingList;
    } catch (e) {
      EasyLoading.dismiss();
      FlushMessagesUtil.snackBarMessage("error", e.toString(), context);
      return [];
    }
  }
}
