import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/attendance_model.dart';
import 'package:snooker_management/models/employee_detail_model.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class FirebaseAttendanceServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

/*--------------------------------------------------------------------------*/
/*                               add attendance                             */
/*--------------------------------------------------------------------------*/
  static Future<void> addAttendance(BuildContext context,
      List<EmployeeModel> employees, String shift, String status) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateTime now = DateTime.now();
      DateTime currentDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      for (int i = 0; i < employees.length; i++) {
        if (employees[i].shift == shift) {
          var time = DateTime.now().millisecondsSinceEpoch.toString();
          var attendanceModel = AttendanceModel(
            userId: uId,
            id: time,
            employeeName: employees[i].employeeName,
            date: Timestamp.fromDate(currentDay),
            shift: shift,
            status: status,
          );
          await fireStore
              .collection('AttendanceManagement')
              .doc(uId)
              .collection("AttendanceDetails")
              .doc(time)
              .set(attendanceModel.toJson())
              .timeout(const Duration(seconds: 60), onTimeout: () {
            throw "Timed out. Please check your network and try again.";
          });
        }
      }
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
  /*                        check today attendance exist                      */
  /*--------------------------------------------------------------------------*/
  static Future<bool> todayAttendanceExist(String shift) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateTime now = DateTime.now();
      DateTime currentDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('AttendanceManagement')
          .doc(uId)
          .collection("AttendanceDetails")
          .where("shift", isEqualTo: shift)
          .where("date", isEqualTo: Timestamp.fromDate(currentDay))
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                get attendance                            */
  /*--------------------------------------------------------------------------*/
  static Future<List<AttendanceModel>?> getAttendance(
      BuildContext context, String shift) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String uId = sp.getString('uId') ?? "";
    try {
      DateTime now = DateTime.now();
      DateTime currentDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('AttendanceManagement')
          .doc(uId)
          .collection("AttendanceDetails")
          .where("shift", isEqualTo: shift)
          .where("date", isEqualTo: Timestamp.fromDate(currentDay))
          .get();
      List<AttendanceModel> attendanceList = snapshot.docs
          .map((doc) => AttendanceModel.fromJson(doc.data()))
          .toList();
      if (attendanceList.isEmpty) {
        return null;
      } else {
        return attendanceList;
      }
    } catch (e) {
      EasyLoading.dismiss();
      return [];
    }
  }

/*--------------------------------------------------------------------------*/
/*                             update attendance                            */
/*--------------------------------------------------------------------------*/

  static Future<void> updateAttendance(BuildContext context,
      AttendanceModel attendanceModel, String newStatus) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Co
      //nnection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      if (newStatus == "") {
        await fireStore
            .collection('AttendanceManagement')
            .doc(uId)
            .collection("AttendanceDetails")
            .doc(attendanceModel.id)
            .update({
          'status': attendanceModel.status,
        }).timeout(const Duration(seconds: 60), onTimeout: () {
          throw "Update timed out. Please check your network and try again.";
        });
      } else {
        await fireStore
            .collection('AttendanceManagement')
            .doc(uId)
            .collection("AttendanceDetails")
            .doc(attendanceModel.id)
            .update({
          'status': newStatus,
        }).timeout(const Duration(seconds: 60), onTimeout: () {
          throw "Update timed out. Please check your network and try again.";
        });
      }
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
  /*                              search Attendance                           */
  /*--------------------------------------------------------------------------*/
  static Future<AttendanceModel?> searchAttendance(BuildContext context,
      String attendanceDate, String employeeName, String shift) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      // Parse the string into a DateTime object
      DateTime formatDate = dateFormat.parse(attendanceDate);

      DateTime date = DateTime(
          formatDate.year, formatDate.month, formatDate.day, 23, 59, 59);

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('AttendanceManagement')
          .doc(uId)
          .collection("AttendanceDetails")
          .where("employeeName", isEqualTo: employeeName)
          .where("date", isEqualTo: Timestamp.fromDate(date))
          .where("shift", isEqualTo: shift)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return AttendanceModel.fromJson(snapshot.docs.first.data());
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
  /*         generate attendance reports daily weekly,monthly,yearly          */
  /*--------------------------------------------------------------------------*/
  static Future<List<AttendanceModel>> generateAttendanceReportInRange(
      BuildContext context, String shift, String dateRange) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Get the current date
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate =
          DateTime(now.year, now.month, now.day, 23, 59, 59); // End of today

      if (dateRange == "Daily") {
        QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
            .collection('AttendanceManagement')
            .doc(uId)
            .collection("AttendanceDetails")
            .where("date", isEqualTo: Timestamp.fromDate(endDate))
            .where("shift", isEqualTo: shift)
            .orderBy("id", descending: true)
            .get();
        List<AttendanceModel> attendanceList = snapshot.docs
            .map((doc) => AttendanceModel.fromJson(doc.data()))
            .toList();
        return attendanceList;
      } else if (dateRange == "Weekly") {
        startDate =
            now.subtract(const Duration(days: 6)); // 7 days back from today
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
          .collection('AttendanceManagement')
          .doc(uId)
          .collection("AttendanceDetails")
          .where("shift", isEqualTo: shift)
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true)
          .get();
      // Converting snapshot documents to a list of maps
      List<AttendanceModel> attendanceList = snapshot.docs
          .map((doc) => AttendanceModel.fromJson(doc.data()))
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

  /*--------------------------------------------------------------------------*/
  /*    generate attendance reports by Name daily weekly,monthly,yearly        */
  /*--------------------------------------------------------------------------*/
  static Future<List<AttendanceModel>> generateAttendanceReportByNameInRange(
      BuildContext context,
      String shift,
      String dateRange,
      String employeeName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Get the current date
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate =
          DateTime(now.year, now.month, now.day, 23, 59, 59); // End of today

      if (dateRange == "Weekly") {
        startDate =
            now.subtract(const Duration(days: 6)); // 7 days back from today
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
          .collection('AttendanceManagement')
          .doc(uId)
          .collection("AttendanceDetails")
          .where("shift", isEqualTo: shift)
          .where("employeeName", isEqualTo: employeeName)
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy("id", descending: true)
          .get();
      // Converting snapshot documents to a list of maps
      List<AttendanceModel> attendanceList = snapshot.docs
          .map((doc) => AttendanceModel.fromJson(doc.data()))
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
