import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/package_model.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';

class FirebasePackageServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;

  /*--------------------------------------------------------------------------*/
  /*                                add Package                               */
  /*--------------------------------------------------------------------------*/
  static Future<void> addPackage(BuildContext context, String name,
      String price, String description, String duration) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final packageModel = PackageModel(
          userId: uId,
          id: time,
          packageName: name,
          packagePrice: price,
          packageDescription: description,
          packageDuration: duration);

      await fireStore
          .collection('PackageManagement')
          .doc(uId)
          .collection("PackageDetails")
          .doc(time)
          .set(packageModel.toJson())
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
  /*                                  get Package                             */
  /*--------------------------------------------------------------------------*/
  static Query<Map<String, dynamic>> getPackages(String uId) {
    return fireStore
        .collection('PackageManagement')
        .doc(uId)
        .collection("PackageDetails")
        .orderBy("id", descending: true);
  }

  /*--------------------------------------------------------------------------*/
  /*                                 Update Package                           */
  /*--------------------------------------------------------------------------*/
  static Future<void> updatePackage(BuildContext context, String id,
      String name, String price, String description, String duration) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      await fireStore
          .collection('PackageManagement')
          .doc(uId)
          .collection("PackageDetails")
          .doc(id)
          .update({
        'packageName': name,
        'packagePrice': price,
        'packageDescription': description,
        'packageDuration': duration,
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
  /*                               delete Package                             */
  /*--------------------------------------------------------------------------*/
  static Future<void> deletePackage(String id) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!isConnected) {
        throw "No internet connection. Please check your network.";
      }
      await fireStore
          .collection('PackageManagement')
          .doc(uId)
          .collection("PackageDetails")
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
/*                               get packages Name                          */
/*--------------------------------------------------------------------------*/

  static Future<List<PackageModel>> getPackagesForMember(
      BuildContext context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('PackageManagement')
          .doc(uId)
          .collection("PackageDetails")
          .get();

      // Converting snapshot documents to a list of maps
      List<PackageModel> packagesList = snapshot.docs
          .map((doc) => PackageModel.fromJson(doc.data()))
          .toList();

      return packagesList;
    } catch (e) {
      return [];
    }
  }
}
