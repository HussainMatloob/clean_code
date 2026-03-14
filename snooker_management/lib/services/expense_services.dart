import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/expense_model.dart';
import 'package:snooker_management/models/expenses_name_model.dart';
import 'package:snooker_management/models/other_expenses_model.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class FirebaseExpenseServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

  /*--------------------------------------------------------------------------*/
  /*                                  add expense                             */
  /*--------------------------------------------------------------------------*/
  static Future<void> addExpense(BuildContext context, String expenseName,
      String description, String amount, String date) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');

      // Parse selected date
      DateTime parsedDate = dateFormat.parse(date);

      // Normalize to UTC start of day
      DateTime formatBillDate =
          DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
      final time = DateTime.now().millisecondsSinceEpoch.toString();

      final expenseModel = ExpensesModel(
        userId: uId,
        id: time,
        expenseName: expenseName,
        expenseDescription: description,
        expenseAmount: double.parse(amount),
        expenseDate: Timestamp.fromDate(formatBillDate),
      );

      await fireStore
          .collection('ExpenseManagement')
          .doc(uId)
          .collection("ExpensesDetails")
          .doc(time)
          .set(expenseModel.toJson())
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
  /*                               get Expenses                                */
  /*--------------------------------------------------------------------------*/
  static Query<Map<String, dynamic>> getExpenses(String uId) {
    return fireStore
        .collection('ExpenseManagement')
        .doc(uId)
        .collection("ExpensesDetails")
        .orderBy("id", descending: true);
  }

  /*--------------------------------------------------------------------------*/
  /*                              update Expense                              */
  /*--------------------------------------------------------------------------*/
  static Future<void> updateExpense(
    BuildContext context,
    String id,
    String expenseName,
    String description,
    String amount,
    String date,
  ) async {
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
      DateTime parsedDate = dateFormat.parse(date);
      // Normalize to UTC start of day
      DateTime formatBillDate =
          DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
      await fireStore
          .collection('ExpenseManagement')
          .doc(uId)
          .collection("ExpensesDetails")
          .doc(id)
          .update({
        'expenseName': expenseName,
        'expenseDescription': description,
        'expenseAmount': double.parse(amount),
        'expenseDate': Timestamp.fromDate(formatBillDate),
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
  /*                              delete Expense                              */
  /*--------------------------------------------------------------------------*/
  static Future<void> deleteExpenseRow(String id) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      await fireStore
          .collection('ExpenseManagement')
          .doc(uId)
          .collection("ExpensesDetails")
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
  /*                                  add expense Name                             */
  /*--------------------------------------------------------------------------*/
  static Future<void> addExpenseName(
    BuildContext context,
    String expenseName,
  ) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String uId = sp.getString('uId') ?? "";
    try {
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final expenseNameModel = ExpensesNameModel(
        userId: uId,
        id: time,
        expenseName: expenseName,
      );

      return await fireStore
          .collection('ExpensesName')
          .doc(uId)
          .collection("ExpensesNameDetails")
          .doc(time)
          .set(expenseNameModel.toJson());
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                            get Expenses name                             */
  /*--------------------------------------------------------------------------*/
  static Future<List<ExpensesNameModel>> getExpensesName(
      BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('ExpensesName')
          .doc(uId)
          .collection("ExpensesNameDetails")
          .get();
      // Converting snapshot documents to a list of maps
      List<ExpensesNameModel> packagesList = snapshot.docs
          .map((doc) => ExpensesNameModel.fromJson(doc.data()))
          .toList();

      return packagesList;
    } catch (e) {
      return [];
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                              search Expense                              */
  /*--------------------------------------------------------------------------*/
  static Future<List<ExpensesModel>> searchExpense(
      BuildContext context, String date, String expenseName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      DateFormat dateFormat = DateFormat('dd-MM-yyyy');

      // Parse selected date
      DateTime parsedDate = dateFormat.parse(date);

      // Start and end of selected day (UTC)
      DateTime startDate =
          DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);

      DateTime endDate = DateTime.utc(
          parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59);

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('ExpenseManagement')
          .doc(uId)
          .collection("ExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .where("expenseName", isEqualTo: expenseName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return ExpensesModel.fromJson(doc.data());
        }).toList();
      }

      return [];
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
  /*                  generate Expenses report monthly,yearly                 */
  /*--------------------------------------------------------------------------*/
  static Future<List<ExpensesModel>> generateExpensesInDateRange(
      BuildContext context, String dateRange) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      // Get the current date
      DateTime now = DateTime.now().toUtc();
      DateTime startDate;
      DateTime endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);

      // Calculate the start date based on the condition
      if (dateRange == "Monthly") {
        startDate = now.subtract(const Duration(days: 30)); // 1 month back
      } else if (dateRange == "Yearly") {
        startDate =
            DateTime.utc(now.year - 1, now.month, now.day); // 1 year back
      } else {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('ExpenseManagement')
          .doc(uId)
          .collection("ExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true)
          .get();

      List<ExpensesModel> expensesList = snapshot.docs
          .map((doc) => ExpensesModel.fromJson(doc.data()))
          .toList();
      return expensesList;
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
  /*                  generate yearly expense reports by name                 */
  /*--------------------------------------------------------------------------*/
  static Future<List<ExpensesModel>> generateExpensesReportByNameInRange(
      BuildContext context, String dateRange, String expenseName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      // Get the current date
      DateTime now = DateTime.now().toUtc();
      DateTime startDate;
      DateTime endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);

      if (dateRange == "Yearly") {
        startDate =
            DateTime.utc(now.year - 1, now.month, now.day); // 1 year back
      } else {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('ExpenseManagement')
          .doc(uId)
          .collection("ExpensesDetails")
          .where("expenseName", isEqualTo: expenseName)
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true)
          .get();

      List<ExpensesModel> expensesList = snapshot.docs
          .map((doc) => ExpensesModel.fromJson(doc.data()))
          .toList();

      return expensesList;
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
  /*                            add other expense                             */
  /*--------------------------------------------------------------------------*/
  static Future<void> addOtherExpense(BuildContext context, String name,
      String expenseName, String amount, String date) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      // Parse selected date
      DateTime parsedDate = dateFormat.parse(date);

      // Normalize to UTC start of day
      DateTime formatBillDate =
          DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final otherExpensesModel = OtherExpensesModel(
        userId: uId,
        id: time,
        name: name,
        expenseName: expenseName,
        otherExpenseAmount: double.parse(amount),
        expenseDate: Timestamp.fromDate(formatBillDate),
      );
      return await fireStore
          .collection('OtherExpenses')
          .doc(uId)
          .collection("OtherExpensesDetails")
          .doc(time)
          .set(otherExpensesModel.toJson())
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
  /*                               get Expenses                                */
  /*--------------------------------------------------------------------------*/
  static Query<Map<String, dynamic>> getOtherExpenses(String uId) {
    return fireStore
        .collection('OtherExpenses')
        .doc(uId)
        .collection("OtherExpensesDetails")
        .orderBy("id", descending: true);
  }

  /*--------------------------------------------------------------------------*/
  /*                              update other Expense                        */
  /*--------------------------------------------------------------------------*/
  static Future<void> updateOtherExpense(
    BuildContext context,
    String id,
    String name,
    String expenseName,
    String amount,
    String date,
  ) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');

      // Parse selected date
      DateTime parsedDate = dateFormat.parse(date);

      // Normalize to UTC start of day
      DateTime formatBillDate =
          DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
      await fireStore
          .collection('OtherExpenses')
          .doc(uId)
          .collection("OtherExpensesDetails")
          .doc(id)
          .update({
        'name': name,
        'expenseName': expenseName,
        'otherExpenseAmount': double.parse(amount),
        'expenseDate': Timestamp.fromDate(formatBillDate),
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
  /*                          delete other Expense                            */
  /*--------------------------------------------------------------------------*/
  static Future<void> deleteOtherExpenseRow(String id) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      await fireStore
          .collection('OtherExpenses')
          .doc(uId)
          .collection("OtherExpensesDetails")
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
  /*          generate daily,weekly and monthly other Expense reports         */
  /*--------------------------------------------------------------------------*/
  static Future<List<OtherExpensesModel>> generateOtherExpensesReportInRange(
      BuildContext context, String dateRange) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      DateTime now = DateTime.now().toUtc();
      DateTime startDate;
      DateTime endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);

      if (dateRange == "Daily") {
        startDate = DateTime.utc(now.year, now.month, now.day);
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);

        QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
            .collection('OtherExpenses')
            .doc(uId)
            .collection("OtherExpensesDetails")
            .where("expenseDate",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("expenseDate",
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .orderBy("id", descending: true)
            .get();

        List<OtherExpensesModel> otherExpensesList = snapshot.docs
            .map((doc) => OtherExpensesModel.fromJson(doc.data()))
            .toList();

        return otherExpensesList;
      } else if (dateRange == "Weekly") {
        startDate = now.subtract(const Duration(days: 7));
      } else if (dateRange == "Monthly") {
        startDate = now.subtract(const Duration(days: 30));
      } else {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('OtherExpenses')
          .doc(uId)
          .collection("OtherExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true)
          .get();

      List<OtherExpensesModel> attendanceList = snapshot.docs
          .map((doc) => OtherExpensesModel.fromJson(doc.data()))
          .toList();

      return attendanceList;
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
