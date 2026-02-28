import 'dart:typed_data' as typed_data;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/employee_detail_model.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class FirebaseEmployeeServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

  /*--------------------------------------------------------------------------*/
  /*                                 add employee                             */
  /*--------------------------------------------------------------------------*/

  static Future<void> addNewEmployee(
      String employeeName,
      String employeeNic,
      String employeeType,
      String employeeContact,
      String employeeAddress,
      typed_data.Uint8List employeeImage,
      String shift) async {
    //Check Internet Connection Before Proceeding
    bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
    if (!isConnected) {
      throw "No internet connection. Please check your network.";
    }
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      const ext = 'jpg';
      final ref = storage.ref().child('EmployeeImages/$time.$ext');

      TaskSnapshot snapshot = await ref.putData(employeeImage);
      String imageUrl = await snapshot.ref.getDownloadURL();

      EmployeeModel employeeDetailModel = EmployeeModel(
          userId: uId,
          id: time,
          employeeName: employeeName,
          employeeNic: employeeNic,
          employeeType: employeeType,
          employeeContact: employeeContact,
          employeeAddress: employeeAddress,
          shift: shift,
          image: imageUrl);

      await fireStore
          .collection('EmployeeManagement')
          .doc(uId)
          .collection("EmployeesDetail")
          .doc(time)
          .set(employeeDetailModel.toJson())
          .timeout(const Duration(seconds: 180), onTimeout: () {
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
  /*                               employee exist                             */
  /*--------------------------------------------------------------------------*/
  static Future<bool> employeeExist(String employeeName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('EmployeeManagement')
          .doc(uId)
          .collection("EmployeesDetail")
          .where("employeeName", isEqualTo: employeeName)
          .limit(1)
          .get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                 get employees                             */
  /*--------------------------------------------------------------------------*/
  static Query<Map<String, dynamic>> getEmployees(String userId) {
    return fireStore
        .collection('EmployeeManagement')
        .doc(userId)
        .collection("EmployeesDetail")
        .orderBy("id", descending: true);
  }

  /*--------------------------------------------------------------------------*/
  /*                                 Update employee                           */
  /*--------------------------------------------------------------------------*/
  static Future<void> updateEmployeeWithSameImage(
      BuildContext context,
      String id,
      String empName,
      String empNic,
      String empType,
      String empContact,
      String empAddress,
      String shift,
      String empImage) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      await fireStore
          .collection('EmployeeManagement')
          .doc(uId)
          .collection("EmployeesDetail")
          .doc(id)
          .update({
        'employeeName': empName,
        'employeeNIC': empNic,
        'employeeType': empType,
        'employeeContact': empContact,
        'employeeAddress': empAddress,
        'shift': shift,
        'image': empImage
      }).timeout(const Duration(seconds: 180), onTimeout: () {
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

  static Future<void> updateEmployeeWithNewImage(
      BuildContext context,
      String id,
      String empName,
      String empNic,
      String empType,
      String empContact,
      String empAddress,
      String shift,
      typed_data.Uint8List empImage) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      const ext = 'jpg';
      final ref = storage.ref().child('EmployeeImages/$time.$ext');
      await ref.putData(empImage).then((TaskSnapshot snapshot) async {
        String imageUrl = await snapshot.ref.getDownloadURL();

        await fireStore
            .collection('EmployeeManagement')
            .doc(uId)
            .collection("EmployeesDetail")
            .doc(id)
            .update({
          'employeeName': empName,
          'employeeNic': empNic,
          'employeeType': empType,
          'employeeContact': empContact,
          'employeeAddress': empAddress,
          'shift': shift,
          'image': imageUrl
        }).timeout(const Duration(seconds: 180), onTimeout: () {
          throw "Update timed out. Please check your network and try again.";
        });
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
  /*                                 delete employee                          */
  /*--------------------------------------------------------------------------*/
  static Future<void> deleteEmployeeRow(String id) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      await fireStore
          .collection('EmployeeManagement')
          .doc(uId)
          .collection("EmployeesDetail")
          .doc(id)
          .delete()
          .timeout(const Duration(seconds: 180), onTimeout: () {
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
/*                          generate employee report                        */
/*--------------------------------------------------------------------------*/

  static Future<List<EmployeeModel>> generateEmployeeReport() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Fetching the snapshot of the Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('EmployeeManagement')
          .doc(uId)
          .collection("EmployeesDetail")
          .orderBy("id", descending: true)
          .get();

      // Converting snapshot documents to a list of maps
      List<EmployeeModel> employeeList = snapshot.docs
          .map((doc) => EmployeeModel.fromJson(doc.data()))
          .toList();

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
/*                              search employee                             */
/*--------------------------------------------------------------------------*/
  static Future<EmployeeModel?> searchEmployee(
      String numberOrNic, BuildContext context) async {
    // Check for employeeNIC
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> nicQuery = await fireStore
          .collection('EmployeeManagement')
          .doc(uId)
          .collection("EmployeesDetail")
          .where("employeeNIC", isEqualTo: numberOrNic)
          .limit(1)
          .get();

      if (nicQuery.docs.isNotEmpty) {
        // Return the first matching document as a model
        return EmployeeModel.fromJson(nicQuery.docs.first.data());
      }

      // Check for employeeContact
      QuerySnapshot<Map<String, dynamic>> contactQuery = await fireStore
          .collection('EmployeeManagement')
          .doc(uId)
          .collection("EmployeesDetail")
          .where("employeeContact", isEqualTo: numberOrNic)
          .limit(1)
          .get();

      if (contactQuery.docs.isNotEmpty) {
        return EmployeeModel.fromJson(contactQuery.docs.first.data());
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
  /*                             get Employees Name                           */
  /*--------------------------------------------------------------------------*/
  static Future<List<EmployeeModel>> getEmployeesName(
      BuildContext context, shift) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('EmployeeManagement')
          .doc(uId)
          .collection("EmployeesDetail")
          .where("shift", isEqualTo: shift)
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
}
