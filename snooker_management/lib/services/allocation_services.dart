import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/TemporaryLoosersModel.dart';
import 'package:snooker_management/models/allocation_model.dart';
import 'package:snooker_management/models/cancel_update_allocation_model.dart';
import 'package:snooker_management/models/member_model.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/models/table_sales_model.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class FirebaseAllocationServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

  /*--------------------------------------------------------------------------*/
  /*                          get tables for allocations                      */
  /*--------------------------------------------------------------------------*/
  static Stream<QuerySnapshot<Map<String, dynamic>>> getTablesForAllocation(
      String? uId) {
    return fireStore
        .collection("TableManagement")
        .doc(uId)
        .collection("TableDetails")
        .snapshots();
  }

/*--------------------------------------------------------------------------*/
/*               get allocations and check exist or not                     */
/*--------------------------------------------------------------------------*/

  static Future<List<CancelAndUpdateAllocationModel>>
      getCancelAndUpdateAllocationsDetail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String uId = sp.getString('uId') ?? "";
    QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
        .collection("CancelAndUpdateAllocations")
        .doc(uId)
        .collection("CancelAndUpdateAllocationsDetail")
        .get();
    List<CancelAndUpdateAllocationModel> allocationsStatus = snapshot.docs
        .map((doc) => CancelAndUpdateAllocationModel.fromJson(doc.data()))
        .toList();
    if (allocationsStatus.isEmpty) {
      return [];
    }
    return allocationsStatus;
  }

/*--------------------------------------------------------------------------*/
/*                            get member discount value                     */
/*--------------------------------------------------------------------------*/

  static Future<MemberModel?> getSpecificMemberDiscount(
      String memberName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String uId = sp.getString('uId') ?? "";
    try {
      QuerySnapshot<Map<String, dynamic>> document = await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .where("memberName", isEqualTo: memberName)
          .limit(1)
          .get();
      MemberModel? memberDiscount =
          MemberModel.fromJson(document.docs.first.data());
      return memberDiscount;
    } catch (e) {
      EasyLoading.dismiss();
      return null;
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                          update allocation status                      */
  /*--------------------------------------------------------------------------*/
  static Future<void> updateTableAllocation(
      TableDetailModel tableModel,
      BuildContext context,
      bool isAllocate,
      String player1,
      String player2,
      String player3,
      String player4,
      String gameType,
      bool isAddAble,
      Timestamp oldTime) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }

      final List players = [];
      if (gameType == "Single") {
        players.add(player1);
        players.add(player3);
      } else {
        players.add(player1);
        players.add(player2);
        players.add(player3);
        players.add(player4);
      }

      // DateTime now = DateTime.now().toUtc();
      // Timestamp timestamp = Timestamp.fromDate(now);

      await fireStore
          .collection("CancelAndUpdateAllocations")
          .doc(uId)
          .collection("CancelAndUpdateAllocationsDetail")
          .doc(tableModel.id)
          .update({
        "startTime": isAddAble ? FieldValue.serverTimestamp() : oldTime,
        "playersName": players,
        "isAllocated": isAllocate,
        "gameType": gameType,
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        throw "Update timed out. Please check your network and try again.";
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
  /*                             cancel allocation                            */
  /*--------------------------------------------------------------------------*/
  static Future<void> cancelTableAllocation(TableDetailModel tableModel,
      BuildContext context, bool isAllocate) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // DateTime now = DateTime.now();
      // Timestamp timestamp = Timestamp.fromDate(now);
      final List players = [];
      await fireStore
          .collection("CancelAndUpdateAllocations")
          .doc(uId)
          .collection("CancelAndUpdateAllocationsDetail")
          .doc(tableModel.id)
          .update({
        "startTime": FieldValue.serverTimestamp(),
        "playersName": players,
        "isAllocated": isAllocate,
        "gameType": "Single",
      }).timeout(const Duration(seconds: 25), onTimeout: () {
        throw "Timed out. Please check your network and try again.";
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
  /*                         get Activated Members Name                       */
  /*--------------------------------------------------------------------------*/
  static Future<List<MemberModel>> getActivatedMembersName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String uId = sp.getString('uId') ?? "";
    final DateTime currentDate = DateTime.now().toUtc(); // Convert to UTC
    DateTime startOfDay =
        DateTime.utc(currentDate.year, currentDate.month, currentDate.day);
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('MembershipManagement')
          .doc(uId)
          .collection("MembershipDetail")
          .where("endDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
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
/*                             done table allocation                        */
/*--------------------------------------------------------------------------*/

  static Future<void> doneTableAllocation(
    BuildContext context,
    CancelAndUpdateAllocationModel cancelAndUpdateAllocationModel,
    String startTime,
    String endTime,
    String totalTime,
    String looserName,
    String payedAmount,
    bool isMoveToTemporaryLoser,
  ) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      await fireStore.runTransaction((transaction) async {
        final time = DateTime.now().millisecondsSinceEpoch.toString();
        DateTime now = DateTime.now();
        // DateTime currentDay =
        //     DateTime(now.year, now.month, now.day, 23, 59, 59);

        AllocationModel allocationModel = AllocationModel(
          id: time,
          userId: uId,
          playersName: cancelAndUpdateAllocationModel.playersName,
          gameType: cancelAndUpdateAllocationModel.gameType,
          tableNumber: cancelAndUpdateAllocationModel.tableNumber,
          totalAmount: payedAmount,
          startTime: startTime,
          endTime: endTime,
          totalTime: totalTime,
        );

        DocumentReference allocationRef = fireStore
            .collection("AllocationManagement")
            .doc(uId)
            .collection("AllocationDetails")
            .doc(time);

        transaction.set(allocationRef, allocationModel.toJson());

        if (isMoveToTemporaryLoser) {
          QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
              .collection('TemporaryLosers')
              .doc(uId)
              .collection("TemporaryLosersDetail")
              .where("looserName", isEqualTo: looserName)
              .where("tableNumber",
                  isEqualTo: cancelAndUpdateAllocationModel.tableNumber)
              .limit(1)
              .get();

          if (snapshot.docs.isNotEmpty) {
            List<TemporaryLosersModel> temporaryLoser = snapshot.docs
                .map((doc) => TemporaryLosersModel.fromJson(doc.data()))
                .toList();

            double newPayAmount = 0;
            double youPay = double.parse(payedAmount);
            int loseGames = temporaryLoser[0].loosGames! + 1;
            newPayAmount = temporaryLoser[0].payAmount! + youPay;
            String sTime = "${temporaryLoser[0].startTime!},$startTime";
            String eTime = "${temporaryLoser[0].endTime!},$endTime";
            String tTime = "${temporaryLoser[0].totalTime!},$totalTime";
            String gType =
                "${temporaryLoser[0].gameType!},${cancelAndUpdateAllocationModel.gameType}";

            DocumentReference loserDocRef = fireStore
                .collection('TemporaryLosers')
                .doc(uId)
                .collection("TemporaryLosersDetail")
                .doc(temporaryLoser[0].id);

            transaction.update(loserDocRef, {
              "loosGames": loseGames,
              "payAmount": newPayAmount,
              "startTime": sTime,
              "endTime": eTime,
              "totalTime": tTime,
              "gameType": gType,
            });
          } else {
            TemporaryLosersModel temporaryLosersModel = TemporaryLosersModel(
              id: time,
              userId: uId,
              looserName: looserName,
              gameType: cancelAndUpdateAllocationModel.gameType,
              tableNumber: cancelAndUpdateAllocationModel.tableNumber,
              tablePrice: cancelAndUpdateAllocationModel.tablePrice.toString(),
              payAmount: double.parse(payedAmount),
              loosGames: 1,
              startTime: startTime,
              endTime: endTime,
              totalTime: totalTime,
            );

            DocumentReference loserDocRef = fireStore
                .collection('TemporaryLosers')
                .doc(uId)
                .collection("TemporaryLosersDetail")
                .doc(time);

            transaction.set(loserDocRef, temporaryLosersModel.toJson());
          }
        } else {
          TableSalesModel tableSalesModel = TableSalesModel(
            id: time,
            userId: uId,
            looserName: looserName,
            loosGames: 1,
            totalAmount: cancelAndUpdateAllocationModel.tablePrice.toString(),
            payedAmount: int.parse(payedAmount),
            paymentMethod: "Cash",
            status: "Payed",
            tableNumber: cancelAndUpdateAllocationModel.tableNumber,
          );

          DocumentReference saleRef = fireStore
              .collection("SaleManagement")
              .doc(user!.uid)
              .collection("SaleDetails")
              .doc(time);

          transaction.set(saleRef, tableSalesModel.toJson());
        }
      });
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  /*--------------------------------------------------------------------------*/
  /*         generate allocations reports daily weekly,monthly,yearly         */
  /*--------------------------------------------------------------------------*/
  static Future<List<AllocationModel>> generateAllocationReportInRange(
      BuildContext context, String dateRange) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      DateTime now = DateTime.now().toUtc();

      DateTime startDate;
      DateTime endDate;

      // ================= DAILY =================
      if (dateRange == "Daily") {
        startDate = DateTime.utc(now.year, now.month, now.day);
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      }

      // ================= WEEKLY =================
      else if (dateRange == "Weekly") {
        startDate = now.subtract(const Duration(days: 6));
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      }

      // ================= MONTHLY =================
      else if (dateRange == "Monthly") {
        startDate = DateTime(now.year, now.month - 1, now.day);
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection("AllocationManagement")
          .doc(uId)
          .collection("AllocationDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AllocationModel.fromJson(doc.data()))
          .toList();
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  /*--------------------------------------------------------------------------*/
  /*   generate allocations reports daily weekly,monthly,yearly By Table      */
  /*--------------------------------------------------------------------------*/
  static Future<List<AllocationModel>> generateAllocationsReportByTable(
      BuildContext context, String dateRange, String tableNumber) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      DateTime now = DateTime.now().toUtc();
      DateTime startDate;
      DateTime endDate;

      if (dateRange == "Daily") {
        startDate = DateTime.utc(now.year, now.month, now.day);
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Weekly") {
        startDate = now.subtract(const Duration(days: 6)); // 7 days back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Monthly") {
        startDate = DateTime(now.year, now.month - 1, now.day); // 1 month back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection("AllocationManagement")
          .doc(uId)
          .collection("AllocationDetails")
          .where("tableNumber", isEqualTo: tableNumber)
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true)
          .get();

      List<AllocationModel> allocationsList = snapshot.docs
          .map((doc) => AllocationModel.fromJson(doc.data()))
          .toList();

      return allocationsList;
    } on FirebaseAuthException {
      throw "Authentication failed. Please check your credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }
}
//m
