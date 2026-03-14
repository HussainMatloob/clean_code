import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/TemporaryLoosersModel.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/models/table_sales_model.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class FirebaseSaleServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

  /*--------------------------------------------------------------------------*/
  /*                                  get Tables                                */
  /*--------------------------------------------------------------------------*/

  static Future<List<TableDetailModel>> getTables() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('TableManagement')
          .doc(uId)
          .collection("TableDetails")
          .get();
      List<TableDetailModel> tables = snapshot.docs
          .map((doc) => TableDetailModel.fromJson(doc.data()))
          .toList();
      if (tables.isEmpty) {
        return [];
      }
      return tables;
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
  /*                           search temporary Losers                         */
  /*--------------------------------------------------------------------------*/
  static Future<List<TemporaryLosersModel>> searchTemporaryLoserByName(
      BuildContext context, String loserName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('TemporaryLosers')
          .doc(uId)
          .collection("TemporaryLosersDetail")
          .where("looserName", isEqualTo: loserName)
          .get();

      // Converting snapshot documents to a list of maps

      List<TemporaryLosersModel> temporaryLosers = snapshot.docs
          .map((doc) => TemporaryLosersModel.fromJson(doc.data()))
          .toList();

      return temporaryLosers;
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
  /*                            get temporary All Losers                         */
  /*--------------------------------------------------------------------------*/
  static Future<List<TemporaryLosersModel>> getAllLosers(
      BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('TemporaryLosers')
          .doc(uId)
          .collection("TemporaryLosersDetail")
          .get();

      // Converting snapshot documents to a list of maps

      List<TemporaryLosersModel> temporaryLosers = snapshot.docs
          .map((doc) => TemporaryLosersModel.fromJson(doc.data()))
          .toList();

      return temporaryLosers;
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
  /*                  get temporary Losers by table Number                    */
  /*--------------------------------------------------------------------------*/

  static Future<List<TemporaryLosersModel>> getTemporaryLosers(
      BuildContext context, String tableNumber) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('TemporaryLosers')
          .doc(uId)
          .collection("TemporaryLosersDetail")
          .where("tableNumber", isEqualTo: tableNumber)
          .get();

      // Converting snapshot documents to a list of maps

      List<TemporaryLosersModel> temporaryLosers = snapshot.docs
          .map((doc) => TemporaryLosersModel.fromJson(doc.data()))
          .toList();

      return temporaryLosers;
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
  /*                                add table sale                            */
  /*--------------------------------------------------------------------------*/
  static Future<void> addTableSale(
      BuildContext context,
      TemporaryLosersModel loserData,
      bool isAddAll,
      List<TemporaryLosersModel> listLosers,
      String totalAmount,
      String finalAmount,
      int totalLoseGames) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }

      final String time = DateTime.now().millisecondsSinceEpoch.toString();
      // DateTime now = DateTime.now();
      // DateTime currentDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      WriteBatch batch = fireStore.batch();

      if (isAddAll) {
        // Prepare model
        TableSalesModel tableSalesModel = TableSalesModel(
            id: time,
            userId: uId,
            looserName: listLosers[0].looserName,
            loosGames: totalLoseGames,
            totalAmount: totalAmount,
            payedAmount: int.parse(finalAmount),
            paymentMethod: "Cash",
            status: "Payed",
            tableNumber: loserData.tableNumber);

        // Add sale to batch
        DocumentReference saleRef = fireStore
            .collection("SaleManagement")
            .doc(uId)
            .collection("SaleDetails")
            .doc(time);
        batch.set(saleRef, tableSalesModel.toJson());

        // Add deletes to batch
        for (var loser in listLosers) {
          DocumentReference loserRef = fireStore
              .collection("TemporaryLosers")
              .doc(uId)
              .collection("TemporaryLosersDetail")
              .doc(loser.id);
          batch.delete(loserRef);
        }
      } else {
        TableSalesModel tableSalesModel = TableSalesModel(
            id: time,
            userId: uId,
            looserName: loserData.looserName,
            loosGames: loserData.loosGames,
            totalAmount: loserData.payAmount.toString(),
            payedAmount: int.parse(finalAmount),
            paymentMethod: "Cash",
            status: "Payed",
            tableNumber: loserData.tableNumber);

        // Add single sale
        DocumentReference saleRef = fireStore
            .collection("SaleManagement")
            .doc(uId)
            .collection("SaleDetails")
            .doc(time);
        batch.set(saleRef, tableSalesModel.toJson());

        // Delete loser
        DocumentReference loserRef = fireStore
            .collection("TemporaryLosers")
            .doc(uId)
            .collection("TemporaryLosersDetail")
            .doc(loserData.id);
        batch.delete(loserRef);
      }

      // Commit all operations atomically
      await batch.commit().timeout(const Duration(seconds: 180), onTimeout: () {
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
  /*             generate sales reports daily weekly,monthly,yearly           */
  /*--------------------------------------------------------------------------*/
  static Future<List<TableSalesModel>> generateSalesReportInRange(
      BuildContext context, String dateRange) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      // Always use UTC
      DateTime now = DateTime.now().toUtc();

      DateTime startDate;
      DateTime endDate;

      if (dateRange == "Daily") {
        startDate = DateTime.utc(now.year, now.month, now.day);
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Weekly") {
        startDate = now.subtract(const Duration(days: 6));
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Monthly") {
        startDate = DateTime.utc(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 30)); // 1 month back (your logic)
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Yearly") {
        startDate = DateTime.utc(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 365)); // 1 year back (your logic)
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection("SaleManagement")
          .doc(uId)
          .collection("SaleDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("date", descending: true) // better than id
          .get();

      return snapshot.docs
          .map((doc) => TableSalesModel.fromJson(doc.data()))
          .toList();
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
  /*        generate sales reports daily weekly,monthly,yearly By Table       */
  /*--------------------------------------------------------------------------*/
  static Future<List<TableSalesModel>> generateSalesReportByTable(
      BuildContext context, String dateRange, String tableNumber) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      // Always use UTC
      DateTime now = DateTime.now().toUtc();

      DateTime startDate;
      DateTime endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);

      if (dateRange == "Daily") {
        startDate = DateTime.utc(now.year, now.month, now.day);
      } else if (dateRange == "Weekly") {
        startDate = now.subtract(const Duration(days: 6));
      } else if (dateRange == "Monthly") {
        startDate = now.subtract(const Duration(days: 30)); // your logic
      } else if (dateRange == "Yearly") {
        startDate = now.subtract(const Duration(days: 365)); // your logic
      } else {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection("SaleManagement")
          .doc(uId)
          .collection("SaleDetails")
          .where("tableNumber", isEqualTo: tableNumber)
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("date", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TableSalesModel.fromJson(doc.data()))
          .toList();
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
}
