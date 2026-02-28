import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/employee_detail_model.dart';
import 'package:snooker_management/models/salary_model.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class FirebaseSalaryServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

  /*--------------------------------------------------------------------------*/
  /*                            get Expenses name                             */
  /*--------------------------------------------------------------------------*/
  static Future<List<EmployeeModel>> getEmployeesName(
      BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('EmployeeManagement')
          .doc(uId)
          .collection("EmployeesDetail")
          .get();
// Converting snapshot documents to a list of maps
      List<EmployeeModel> employeesList = snapshot.docs
          .map((doc) => EmployeeModel.fromJson(doc.data()))
          .toList();

      return employeesList;
    } catch (e) {
      return [];
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                   add salary                             */
  /*--------------------------------------------------------------------------*/
  static Future<void> addSalary(BuildContext context, String employeeName,
      String salary, String shift, String date) async {
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
      DateTime formatBillDate = dateFormat.parse(date);
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final salaryModel = SalaryModel(
        userId: uId,
        id: time,
        employeeName: employeeName,
        employeeSalary: double.parse(salary),
        shift: shift,
        date: Timestamp.fromDate(formatBillDate),
      );
      return await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .doc(time)
          .set(salaryModel.toJson())
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
  /*                               update Salary                              */
  /*--------------------------------------------------------------------------*/
  static Future<void> updateSalary(BuildContext context, String id,
      String employeeName, String salary, String shift, String date) async {
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
      DateTime formatBillDate = dateFormat.parse(date);
      await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .doc(id)
          .update({
        'employeeName': employeeName,
        'employeeSalary': double.parse(salary),
        'shift': shift,
        'date': Timestamp.fromDate(formatBillDate),
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
  /*                               delete Salary                              */
  /*--------------------------------------------------------------------------*/
  static Future<void> deleteSalary(
      BuildContext context, SalaryModel salaryModel) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .doc(salaryModel.id)
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
  /*                               get Expenses                                */
  /*--------------------------------------------------------------------------*/
  static Query<Map<String, dynamic>> getSalaries(String uId) {
    return fireStore
        .collection('SalaryManagement')
        .doc(uId)
        .collection("SalaryDetails")
        .orderBy("id", descending: true);
  }

  /*--------------------------------------------------------------------------*/
  /*                              search Salary                               */
  /*--------------------------------------------------------------------------*/
  static Future<SalaryModel?> searchSalary(
      BuildContext context, String date, String expenseName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      // Parse the string into a DateTime object
      DateTime formatedDate = dateFormat.parse(date);
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("date", isEqualTo: Timestamp.fromDate(formatedDate))
          .where("employeeName", isEqualTo: expenseName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return SalaryModel.fromJson(snapshot.docs.first.data());
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
  /*                  generate Salary report monthly,yearly                 */
  /*--------------------------------------------------------------------------*/
  static Future<List<SalaryModel>> generateSalaryInDateRange(
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
      if (dateRange == "Monthly") {
        startDate = DateTime(now.year, now.month - 1, now.day); // 1 month back
      } else if (dateRange == "Yearly") {
        startDate = DateTime(now.year - 1, now.month, now.day); // 1 year back
      } else {
        // If the condition doesn't match, return an empty list
        return [];
      }
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true)
          .get();
      // Converting snapshot documents to a list of maps
      List<SalaryModel> salaryList =
          snapshot.docs.map((doc) => SalaryModel.fromJson(doc.data())).toList();
      return salaryList;
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
  /*                        generate salary report by name                    */
  /*--------------------------------------------------------------------------*/
  static Future<List<SalaryModel>> generateSalaryReportByNameInRange(
      BuildContext context, String dateRange, String employeeName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Get the current date
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate =
          DateTime(now.year, now.month, now.day, 23, 59, 59); // End of today

      if (dateRange == "Yearly") {
        startDate = DateTime(now.year - 1, now.month, now.day); // 1 year back
      } else {
        // If the condition doesn't match, return an empty list
        return [];
      }
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .where("employeeName", isEqualTo: employeeName)
          .orderBy("id", descending: true)
          .get();
      // Converting snapshot documents to a list of maps
      List<SalaryModel> salaryList =
          snapshot.docs.map((doc) => SalaryModel.fromJson(doc.data())).toList();
      return salaryList;
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
/*                generate yearly expenses reports by month                 */
/*--------------------------------------------------------------------------*/

  static Future<List<SalaryModel>> generateReportForSpecificMonth(
      BuildContext context, String monthName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Map month names to their respective numbers
      Map<String, int> monthMap = {
        "January": 1,
        "February": 2,
        "March": 3,
        "April": 4,
        "May": 5,
        "June": 6,
        "July": 7,
        "August": 8,
        "September": 9,
        "October": 10,
        "November": 11,
        "December": 12,
      };

      // Validate the input month name
      if (!monthMap.containsKey(monthName)) {
        throw Exception("Invalid month name: $monthName");
      }

      // Get the current date
      DateTime now = DateTime.now();
      int targetMonth = monthMap[monthName]!;

      // Calculate the start and end dates for the specified month
      DateTime startDate;
      DateTime endDate;

      if (targetMonth <= now.month) {
        // The specified month is in the current year
        startDate = DateTime(now.year, targetMonth, 1);
        endDate =
            DateTime(now.year, targetMonth + 1, 0, 23, 59, 59); // End of month
      } else {
        // The specified month is in the previous year
        startDate = DateTime(now.year - 1, targetMonth, 1);
        endDate = DateTime(
            now.year - 1, targetMonth + 1, 0, 23, 59, 59); // End of month
      }

      // Fetch data for the specified month range
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true) // Ensure proper indexing
          .get();

      // Convert snapshot to a list of SalaryModel
      List<SalaryModel> salaryList =
          snapshot.docs.map((doc) => SalaryModel.fromJson(doc.data())).toList();

      return salaryList;
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
