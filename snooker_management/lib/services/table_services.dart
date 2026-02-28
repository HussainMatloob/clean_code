import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/cancel_update_allocation_model.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class FirebaseTableServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

  /*--------------------------------------------------------------------------*/
  /*                                  add Table                                */
  /*--------------------------------------------------------------------------*/
  static Future<void> addTable(
      BuildContext context,
      String tableNumber,
      String tableName,
      String tableType,
      String tableDescription,
      String tablePrice) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      DateTime now = DateTime.now();
      DateTime currentDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final batch = fireStore.batch();

// Reference for TableManagement
      final tableRef = fireStore
          .collection('TableManagement')
          .doc(uId)
          .collection("TableDetails")
          .doc(time);

// Reference for CancelAndUpdateAllocations
      final allocationRef = fireStore
          .collection("CancelAndUpdateAllocations")
          .doc(uId)
          .collection("CancelAndUpdateAllocationsDetail")
          .doc(time);

// Create models
      final tableModel = TableDetailModel(
        userId: uId,
        id: time,
        tableNumber: tableNumber,
        tableName: tableName,
        tableType: tableType,
        tableDescription: tableDescription,
        tablePrice: tablePrice,
        tableStatus: "free",
      );

      final cancelAndUpdateAllocationModel = CancelAndUpdateAllocationModel(
        id: time,
        userId: uId,
        isAllocated: false,
        playersName: [],
        startTime: Timestamp.fromDate(currentDay),
        tableNumber: tableNumber,
        tablePrice: double.parse(tablePrice),
        gameType: "Single",
      );

// Add to batch
      batch.set(tableRef, tableModel.toJson());
      batch.set(allocationRef, cancelAndUpdateAllocationModel.toJson());

// Commit batch
      await batch.commit().timeout(
        const Duration(seconds: 180),
        onTimeout: () {
          throw "Connection timed out. Please check your internet and try again.";
        },
      );
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
  /*                                  get Table                                */
  /*--------------------------------------------------------------------------*/
  static Query<Map<String, dynamic>> getTable(String uId) {
    try {
      return fireStore
          .collection('TableManagement')
          .doc(uId)
          .collection("TableDetails");
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
  /*                              update Table                                */
  /*--------------------------------------------------------------------------*/
  static Future<void> updateTable(
      BuildContext context,
      String id,
      String tableNumber,
      String tableName,
      String tableType,
      String tableDescription,
      String tablePrice) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      final batch = fireStore.batch();

// Reference for TableManagement update
      final tableRef = fireStore
          .collection('TableManagement')
          .doc(uId)
          .collection("TableDetails")
          .doc(id);

// Reference for CancelAndUpdateAllocations update
      final allocationRef = fireStore
          .collection("CancelAndUpdateAllocations")
          .doc(uId)
          .collection("CancelAndUpdateAllocationsDetail")
          .doc(id);

// Add updates to batch
      batch.update(tableRef, {
        'tableNumber': tableNumber,
        'tableName': tableName,
        'tableType': tableType,
        'tableDescription': tableDescription,
        'tablePrice': tablePrice,
      });

      batch.update(allocationRef, {
        "tableNumber": tableNumber,
        "tablePrice": double.parse(tablePrice),
      });

// Commit the batch
      await batch.commit().timeout(
        const Duration(seconds: 180),
        onTimeout: () {
          throw "Connection timed out. Please check your internet and try again.";
        },
      );
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
  /*                                 delete Table                             */
  /*--------------------------------------------------------------------------*/
  static Future<void> deleteTableRow(String id) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      final batch = fireStore.batch();

// Reference for TableManagement delete
      final tableRef = fireStore
          .collection('TableManagement')
          .doc(uId)
          .collection("TableDetails")
          .doc(id);

// Reference for CancelAndUpdateAllocations delete
      final allocationRef = fireStore
          .collection("CancelAndUpdateAllocations")
          .doc(uId)
          .collection("CancelAndUpdateAllocationsDetail")
          .doc(id);

// Add deletes to batch
      batch.delete(tableRef);
      batch.delete(allocationRef);

// Commit the batch
      await batch.commit().timeout(
        const Duration(seconds: 180),
        onTimeout: () {
          throw "Connection timed out. Please check your internet and try again.";
        },
      );
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
  /*                              search Table                                */
  /*--------------------------------------------------------------------------*/
  static Future<TableDetailModel?> searchTable(
      String tableNumber, BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> contactQuery = await fireStore
          .collection('TableManagement')
          .doc(uId)
          .collection("TableDetails")
          .where("tableNumber", isEqualTo: tableNumber)
          .limit(1)
          .get();

      if (contactQuery.docs.isNotEmpty) {
        return TableDetailModel.fromJson(contactQuery.docs.first.data());
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
  /*                            generate Table Report                         */
  /*--------------------------------------------------------------------------*/
  static Future<List<TableDetailModel>> generateTableReport() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('TableManagement')
          .doc(uId)
          .collection("TableDetails")
          .orderBy("id", descending: true)
          .get();

      // Converting snapshot documents to a list of maps
      List<TableDetailModel> tableList = snapshot.docs
          .map((doc) => TableDetailModel.fromJson(doc.data()))
          .toList();

      return tableList;
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
/*                     check table already exist or not                     */
/*--------------------------------------------------------------------------*/
  static Future<bool> tableExist(
      BuildContext context, String tableNumber) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection("TableManagement")
          .doc(uId)
          .collection("TableDetails")
          .where("tableNumber", isEqualTo: tableNumber)
          .limit(1)
          .get();
      return snapshot.docs.isEmpty;
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
