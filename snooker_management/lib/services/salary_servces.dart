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
      DateTime parsedStart = dateFormat.parse(date);

      DateTime formatSalaryDate =
          DateTime.utc(parsedStart.year, parsedStart.month, parsedStart.day);

      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final salaryModel = SalaryModel(
        userId: uId,
        id: time,
        employeeName: employeeName,
        employeeSalary: double.parse(salary),
        shift: shift,
        date: Timestamp.fromDate(formatSalaryDate),
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
      DateTime parsedStart = dateFormat.parse(date);

      DateTime formatSalaryDate =
          DateTime.utc(parsedStart.year, parsedStart.month, parsedStart.day);
      await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .doc(id)
          .update({
        'employeeName': employeeName,
        'employeeSalary': double.parse(salary),
        'shift': shift,
        'date': Timestamp.fromDate(formatSalaryDate),
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
      BuildContext context, String date, String employeeName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      DateFormat dateFormat = DateFormat('dd-MM-yyyy');

      // Parse date
      DateTime parsedDate = dateFormat.parse(date);

      // Create day range in UTC
      DateTime startDate =
          DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);

      DateTime endDate = DateTime.utc(
          parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59);

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("employeeName", isEqualTo: employeeName)
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return SalaryModel.fromJson(snapshot.docs.first.data());
      }

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
  /*                  generate Salary report monthly,yearly                    */
  /*--------------------------------------------------------------------------*/
  static Future<List<SalaryModel>> generateSalaryInDateRange(
      BuildContext context, String dateRange) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";

      DateTime now = DateTime.now().toUtc();
      DateTime startDate;
      DateTime endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);

      if (dateRange == "Monthly") {
        startDate = DateTime(now.year, now.month - 1, now.day);
      } else if (dateRange == "Yearly") {
        startDate = DateTime(now.year - 1, now.month, now.day);
      } else {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("date", descending: true)
          .get();

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

      DateTime now = DateTime.now().toUtc();
      DateTime startDate;
      DateTime endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);

      if (dateRange == "Yearly") {
        startDate = DateTime.utc(now.year - 1, now.month, now.day);
      } else {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("employeeName", isEqualTo: employeeName)
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("date", descending: true)
          .get();

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

      if (!monthMap.containsKey(monthName)) {
        throw Exception("Invalid month name: $monthName");
      }

      DateTime now = DateTime.now().toUtc();
      int targetMonth = monthMap[monthName]!;

      DateTime startDate;
      DateTime endDate;

      if (targetMonth <= now.month) {
        startDate = DateTime.utc(now.year, targetMonth, 1);
        endDate = DateTime.utc(now.year, targetMonth + 1, 1)
            .subtract(const Duration(seconds: 1));
      } else {
        startDate = DateTime.utc(now.year - 1, targetMonth, 1);
        endDate = DateTime.utc(now.year - 1, targetMonth + 1, 1)
            .subtract(const Duration(seconds: 1));
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("date", descending: true)
          .get();

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
