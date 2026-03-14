import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseReportServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

/*-------------------------------------------------------------------------*/
/*                         get today tables sale                           */
/*-------------------------------------------------------------------------*/
  static Future<double> getTodayTablesSale() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateTime now = DateTime.now().toUtc();
      DateTime startDate = DateTime.utc(now.year, now.month, now.day);
      DateTime endOfDay =
          DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection("SaleManagement")
          .doc(uId)
          .collection("SaleDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();
      // Calculate the sum of payedAmount
      double totalTodayTableSales =
          snapshot.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["payedAmount"])?.toDouble() ?? 0.0;
      });
      return totalTodayTableSales;
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

/*-------------------------------------------------------------------------*/
/*                           get  today expenses                           */
/*-------------------------------------------------------------------------*/
  static Future<double> getTodayExpenses() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateTime now = DateTime.now().toUtc();
      DateTime startOfDay = DateTime.utc(now.year, now.month, now.day);
      DateTime endOfDay =
          DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('ExpenseManagement')
          .doc(uId)
          .collection("ExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      // Calculate the sum of expenseAmount
      double totalExpenseAmount = snapshot.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["expenseAmount"])?.toDouble() ?? 0.0;
      });

      QuerySnapshot<Map<String, dynamic>> snapshot1 = await fireStore
          .collection('OtherExpenses')
          .doc(uId)
          .collection("OtherExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      // Calculate the sum of otherExpenseAmount
      double totalOtherExpenseAmount =
          snapshot1.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["otherExpenseAmount"])?.toDouble() ??
            0.0;
      });

      QuerySnapshot<Map<String, dynamic>> snapshot2 = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      // Calculate the sum of employeeSalary
      double totalEmployeeSalary =
          snapshot2.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["employeeSalary"])?.toDouble() ??
            0.0;
      });

      final double totalExpenses =
          totalExpenseAmount + totalOtherExpenseAmount + totalEmployeeSalary;

      return totalExpenses;
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

/*-------------------------------------------------------------------------*/
/*                     get table sales in date range                       */
/*-------------------------------------------------------------------------*/
  static Future<double> getTableSalesInDateRange(BuildContext context,
      String dateRange, String selectedDate, bool isSelectedDate) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateTime startDate;
      DateTime endDate;
      DateTime now;
      if (isSelectedDate) {
        now = DateTime.now().toUtc();
        DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(selectedDate);
        startDate =
            DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
        endDate = DateTime(
            parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59);
      } else {
        now = DateTime.now().toUtc();
        startDate = DateTime.utc(now.year, now.month, now.day);
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      }

      if (dateRange == "Daily") {
        QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
            .collection("SaleManagement")
            .doc(uId)
            .collection("SaleDetails")
            .where("date",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .get();

        // Calculate the sum of payedAmount
        double totalTableSales = snapshot.docs.fold(0.0, (previousValue, doc) {
          return previousValue + (doc.data()["payedAmount"])?.toDouble() ?? 0.0;
        });

        return totalTableSales;
      } else if (dateRange == "Weekly") {
        startDate =
            now.subtract(const Duration(days: 6)); // 7 days back from today
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Monthly") {
        startDate =
            DateTime.utc(now.year, now.month - 1, now.day); // 1 month back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Yearly") {
        startDate =
            DateTime.utc(now.year - 1, now.month, now.day); // 1 year back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else {
        // If the condition doesn't match, return an empty list
        return 0.0;
      }
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection("SaleManagement")
          .doc(uId)
          .collection("SaleDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Calculate the sum of payedAmount
      double totalTableSales = snapshot.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["payedAmount"])?.toDouble() ?? 0.0;
      });

      return totalTableSales;
    } catch (e) {
      return 0.0;
    }
  }

  /*-------------------------------------------------------------------------*/
  /*                      get all Expenses in date range                     */
  /*-------------------------------------------------------------------------*/
  static Future<double> getAllExpensesInDateRange(BuildContext context,
      String dateRange, String selectedDate, bool isSelectedDate) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateTime startDate;
      DateTime endDate;
      DateTime now;
      if (isSelectedDate) {
        now = DateTime.now().toUtc();
        DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(selectedDate);
        startDate =
            DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
        endDate = DateTime.utc(
            parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59);
      } else {
        now = DateTime.now().toUtc();
        startDate = DateTime.utc(now.year, now.month, now.day);
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      }

      if (dateRange == "Daily") {
        QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
            .collection('ExpenseManagement')
            .doc(uId)
            .collection("ExpensesDetails")
            .where("expenseDate",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("expenseDate",
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .get();

        // Calculate the sum of expenseAmount
        double totalExpenseAmount =
            snapshot.docs.fold(0.0, (previousValue, doc) {
          return previousValue + (doc.data()["expenseAmount"])?.toDouble() ??
              0.0;
        });

        QuerySnapshot<Map<String, dynamic>> snapshot1 = await fireStore
            .collection('OtherExpenses')
            .doc(uId)
            .collection("OtherExpensesDetails")
            .where("expenseDate",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("expenseDate",
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .get();

        // Calculate the sum of otherExpenseAmount
        double totalOtherExpenseAmount =
            snapshot1.docs.fold(0.0, (previousValue, doc) {
          return previousValue +
                  (doc.data()["otherExpenseAmount"])?.toDouble() ??
              0.0;
        });

        QuerySnapshot<Map<String, dynamic>> snapshot2 = await fireStore
            .collection('SalaryManagement')
            .doc(uId)
            .collection("SalaryDetails")
            .where("date",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .get();

        // Calculate the sum of employeeSalary
        double totalEmployeeSalary =
            snapshot2.docs.fold(0.0, (previousValue, doc) {
          return previousValue + (doc.data()["employeeSalary"])?.toDouble() ??
              0.0;
        });

        final double totalExpenses =
            totalExpenseAmount + totalOtherExpenseAmount + totalEmployeeSalary;

        return totalExpenses;
      } else if (dateRange == "Weekly") {
        startDate =
            now.subtract(const Duration(days: 6)); // 7 days back from today
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Monthly") {
        startDate =
            DateTime.utc(now.year, now.month - 1, now.day); // 1 month back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Yearly") {
        startDate =
            DateTime.utc(now.year - 1, now.month, now.day); // 1 year back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else {
        // If the condition doesn't match, return an empty list
        return 0.0;
      }
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('ExpenseManagement')
          .doc(uId)
          .collection("ExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Calculate the sum of expenseAmount
      double totalExpenseAmount = snapshot.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["expenseAmount"])?.toDouble() ?? 0.0;
      });

      QuerySnapshot<Map<String, dynamic>> snapshot1 = await fireStore
          .collection('OtherExpenses')
          .doc(uId)
          .collection("OtherExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Calculate the sum of otherExpenseAmount
      double totalOtherExpenseAmount =
          snapshot1.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["otherExpenseAmount"])?.toDouble() ??
            0.0;
      });

      QuerySnapshot<Map<String, dynamic>> snapshot2 = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Calculate the sum of employeeSalary
      double totalEmployeeSalary =
          snapshot2.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["employeeSalary"])?.toDouble() ??
            0.0;
      });

      final double totalExpenses =
          totalExpenseAmount + totalOtherExpenseAmount + totalEmployeeSalary;

      return totalExpenses;
    } catch (e) {
      return 0.0;
    }
  }

  /*-------------------------------------------------------------------------*/
  /*                      get other Expenses in date range                   */
  /*-------------------------------------------------------------------------*/
  static Future<double> getOtherExpensesInDateRange(BuildContext context,
      String dateRange, String selectedDate, bool isSelectedDate) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateTime startDate;
      DateTime endDate;
      DateTime now;
      if (isSelectedDate) {
        now = DateTime.now().toUtc();
        DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(selectedDate);
        startDate = DateTime.utc(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
        );
        endDate = DateTime.utc(
            parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59);
      } else {
        now = DateTime.now().toUtc();
        startDate = DateTime.utc(now.year, now.month, now.day);
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      }

      if (dateRange == "Daily") {
        QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
            .collection('OtherExpenses')
            .doc(uId)
            .collection("OtherExpensesDetails")
            .where("expenseDate",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("expenseDate",
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .get();
        // Calculate the sum of otherExpenseAmount
        double totalOtherExpenseAmount =
            snapshot.docs.fold(0.0, (previousValue, doc) {
          return previousValue +
                  (doc.data()["otherExpenseAmount"])?.toDouble() ??
              0.0;
        });
        return totalOtherExpenseAmount;
      } else if (dateRange == "Weekly") {
        startDate =
            now.subtract(const Duration(days: 6)); // 7 days back from today
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Monthly") {
        startDate =
            DateTime.utc(now.year, now.month - 1, now.day); // 1 month back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Yearly") {
        startDate =
            DateTime.utc(now.year - 1, now.month, now.day); // 1 year back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else {
        // If the condition doesn't match, return an empty list
        return 0.0;
      }
      // Fetching the snapshot of the Firestore query

      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('OtherExpenses')
          .doc(uId)
          .collection("OtherExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Calculate the sum of otherExpenseAmount
      double totalOtherExpenseAmount =
          snapshot.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["otherExpenseAmount"])?.toDouble() ??
            0.0;
      });

      return totalOtherExpenseAmount;
    } catch (e) {
      return 0.0;
    }
  }

  /*-------------------------------------------------------------------------*/
  /*                     get profit and loss in date range                   */
  /*-------------------------------------------------------------------------*/
  static Future<List<double>> getProfitAndLossInDateRange(BuildContext context,
      String dateRange, String selectedDate, bool isSelectedDate) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      DateTime startDate;
      DateTime endDate;
      DateTime now;
      if (isSelectedDate) {
        now = DateTime.now().toUtc();
        DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(selectedDate);
        startDate =
            DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
        endDate = DateTime.utc(
            parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59);
      } else {
        now = DateTime.now().toUtc();
        startDate = DateTime.utc(now.year, now.month, now.day);
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      }

      if (dateRange == "Daily") {
        QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
            .collection("SaleManagement")
            .doc(uId)
            .collection("SaleDetails")
            .where("date",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .get();

        // Calculate the sum of payedAmount
        double totalTableSales = snapshot.docs.fold(0.0, (previousValue, doc) {
          return previousValue + (doc.data()["payedAmount"])?.toDouble() ?? 0.0;
        });

        final double totalDailySales = totalTableSales;

        QuerySnapshot<Map<String, dynamic>> snapshot2 = await fireStore
            .collection('ExpenseManagement')
            .doc(uId)
            .collection("ExpensesDetails")
            .where("expenseDate",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("expenseDate",
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .get();

        // Calculate the sum of expenseAmount
        double totalExpenseAmount =
            snapshot2.docs.fold(0.0, (previousValue, doc) {
          return previousValue + (doc.data()["expenseAmount"])?.toDouble() ??
              0.0;
        });

        QuerySnapshot<Map<String, dynamic>> snapshot3 = await fireStore
            .collection('OtherExpenses')
            .doc(uId)
            .collection("OtherExpensesDetails")
            .where("expenseDate",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("expenseDate",
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .get();

        // Calculate the sum of otherExpenseAmount
        double totalOtherExpenseAmount =
            snapshot3.docs.fold(0.0, (previousValue, doc) {
          return previousValue +
                  (doc.data()["otherExpenseAmount"])?.toDouble() ??
              0.0;
        });

        QuerySnapshot<Map<String, dynamic>> snapshot4 = await fireStore
            .collection('SalaryManagement')
            .doc(uId)
            .collection("SalaryDetails")
            .where("date",
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .get();

        // Calculate the sum of employeeSalary
        double totalEmployeeSalary =
            snapshot4.docs.fold(0.0, (previousValue, doc) {
          return previousValue + (doc.data()["employeeSalary"])?.toDouble() ??
              0.0;
        });

        final double totalDailyExpenses =
            totalExpenseAmount + totalOtherExpenseAmount + totalEmployeeSalary;

        final totalProfitAndLoss = totalDailySales - totalDailyExpenses;
        return [totalProfitAndLoss, totalDailySales, totalDailyExpenses];
      } else if (dateRange == "Weekly") {
        startDate =
            now.subtract(const Duration(days: 6)); // 7 days back from today
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Monthly") {
        startDate =
            DateTime.utc(now.year, now.month - 1, now.day); // 1 month back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else if (dateRange == "Yearly") {
        startDate =
            DateTime.utc(now.year - 1, now.month, now.day); // 1 year back
        endDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
      } else {
        // If the condition doesn't match, return an empty list
        return [0.0, 0.0, 0.0];
      }
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection("SaleManagement")
          .doc(uId)
          .collection("SaleDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Calculate the sum of payedAmount
      double totalTableSales = snapshot.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["payedAmount"])?.toDouble() ?? 0.0;
      });

      final double totalSalesInDateRange = totalTableSales;

      QuerySnapshot<Map<String, dynamic>> snapshot2 = await fireStore
          .collection('ExpenseManagement')
          .doc(uId)
          .collection("ExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Calculate the sum of expenseAmount
      double totalExpenseAmount =
          snapshot2.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["expenseAmount"])?.toDouble() ?? 0.0;
      });

      QuerySnapshot<Map<String, dynamic>> snapshot3 = await fireStore
          .collection('OtherExpenses')
          .doc(uId)
          .collection("OtherExpensesDetails")
          .where("expenseDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("expenseDate",
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Calculate the sum of otherExpenseAmount
      double totalOtherExpenseAmount =
          snapshot3.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["otherExpenseAmount"])?.toDouble() ??
            0.0;
      });

      QuerySnapshot<Map<String, dynamic>> snapshot4 = await fireStore
          .collection('SalaryManagement')
          .doc(uId)
          .collection("SalaryDetails")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Calculate the sum of employeeSalary
      double totalEmployeeSalary =
          snapshot4.docs.fold(0.0, (previousValue, doc) {
        return previousValue + (doc.data()["employeeSalary"])?.toDouble() ??
            0.0;
      });

      final double totalExpensesInDateRange =
          totalExpenseAmount + totalOtherExpenseAmount + totalEmployeeSalary;

      final totalProfitAndLoss =
          totalSalesInDateRange - totalExpensesInDateRange;
      return [
        totalProfitAndLoss,
        totalSalesInDateRange,
        totalExpensesInDateRange
      ];
    } catch (e) {
      return [0.0, 0.0, 0.0];
    }
  }
}
//s