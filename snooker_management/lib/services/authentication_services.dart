import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/models/user_profile.dart';

import 'dart:typed_data' as typed_data;

class FirebaseAuthenticationServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  //static User get user => auth.currentUser!;
  static User? get user => auth.currentUser;
  /*--------------------------------------------------------------------------*/
  /*                      check user already exist or not                     */
  /*--------------------------------------------------------------------------*/
  static Future<bool> userExists() async {
    return (await fireStore.collection('SnookerUsers').doc(user!.uid).get())
        .exists;
  }

  /*--------------------------------------------------------------------------*/
  /*                          create new operator                             */
  /*--------------------------------------------------------------------------*/

  static Future<void> signUpAndCreateUserWithEmail(
      String email, String password, String name) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      // Step 1: Create Firebase Auth user
      final secondaryAuth = FirebaseAuth.instanceFor(app: Firebase.app());
      await secondaryAuth.setPersistence(Persistence.NONE);
      final userCredential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final credentialUser = userCredential.user;
      if (credentialUser == null) throw "User creation failed.";

      try {
        // Step 2: Prepare Firestore batch
        final batch = fireStore.batch();

        final time = DateTime.now().millisecondsSinceEpoch.toString();

        final userProfile = UsersModel(
          id: credentialUser.uid,
          uId: uId,
          role: "Operator",
          userName: name,
          email: email,
          password: password,
          snookerLogo: "",
          snookerName: "Snooker Club",
          createdAt: time,
          userDeviceToken: "",
          permissionsList: [],
        );

        final userDocRef =
            fireStore.collection('SnookerUsers').doc(credentialUser.uid);
        batch.set(userDocRef, userProfile.toJson());

        // Step 3: Commit batch
        await batch.commit();
      } catch (firestoreError) {
        // Rollback Auth user if Firestore profile creation fails
        try {
          await credentialUser.delete();
        } catch (deleteError) {
          print("Rollback failed: $deleteError");
        }
        throw "Failed to create user profile. Signup rolled back.";
      }
      //  finally {
      //   await secondaryAuth.signOut();
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw "An account with this email already exists. Please try logging in instead.";
      } else if (e.code == 'weak-password') {
        throw "Your password is too weak. Please choose a stronger one.";
      } else if (e.code == 'invalid-email') {
        throw "Please enter a valid email address.";
      } else {
        throw "Authentication failed: ${e.message ?? 'Unknown error occurred.'}";
      }
    } catch (e) {
      throw "Unexpected signup error: $e";
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                   get user                               */
  /*--------------------------------------------------------------------------*/
  static Future<UsersModel?> getUserData(bool isFreshlogin) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString("uId") ?? "";
      String userUid = isFreshlogin ? user!.uid : uId;
      // Fetching the snapshot of the Firestore query
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await fireStore.collection('SnookerUsers').doc(userUid).get();

      // Converting snapshot documents to a list of maps
      if (snapshot.data() != null) {
        UsersModel userData = UsersModel.fromJson(snapshot.data()!);
        return userData;
      } else {
        return null;
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
  /*                      get selected operator data                          */
  /*--------------------------------------------------------------------------*/
  static Future<UsersModel?> getspecificOperatorData(String operatorId) async {
    try {
      String userUid = operatorId;
      // Fetching the snapshot of the Firestore query
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await fireStore.collection('SnookerUsers').doc(userUid).get();

      // Converting snapshot documents to a list of maps
      if (snapshot.data() != null) {
        UsersModel userData = UsersModel.fromJson(snapshot.data()!);
        return userData;
      } else {
        return null;
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
  /*                              get your operators                          */
  /*--------------------------------------------------------------------------*/

  static Stream<QuerySnapshot<Map<String, dynamic>>> getYourOperators(
      String uId) {
    return fireStore
        .collection("SnookerUsers")
        .where("uId", isEqualTo: uId)
        .where("role", isEqualTo: "Operator")
        .snapshots();
  }

  /*--------------------------------------------------------------------------*/
  /*                           update user permission                         */
  /*--------------------------------------------------------------------------*/
  static Future<void> updateUserPermissions(BuildContext context,
      List<String> permissionsList, String operatorId) async {
    try {
      return await fireStore.collection('SnookerUsers').doc(operatorId).update({
        "permissionsList": permissionsList ?? [],
      }).timeout(const Duration(seconds: 60), onTimeout: () {
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
  /*                           update logo or image                           */
  /*--------------------------------------------------------------------------*/
  static Future<void> updateLogoOrImage(
      BuildContext context,
      UsersModel userData,
      typed_data.Uint8List? newLogo,
      String snookerName) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String uId = sp.getString('uId') ?? "";
      if (newLogo != null) {
        final time = DateTime.now().millisecondsSinceEpoch.toString();
        const ext = 'jpg';
        final ref = storage.ref().child('EmployeeImages/$time.$ext');
        await ref.putData(newLogo).then((TaskSnapshot snapshot) async {
          String logoUrl = await snapshot.ref.getDownloadURL();

          final querySnapshot = await fireStore
              .collection('SnookerUsers')
              .where("uId", isEqualTo: uId)
              .get();

          // Start a batch
          final batch = fireStore.batch();

          for (var doc in querySnapshot.docs) {
            batch.update(doc.reference,
                {"snookerLogo": logoUrl, "snookerName": snookerName});
          }

          // Commit the batch (atomic operation)
          await batch.commit();
        });
      } else {
        final querySnapshot = await fireStore
            .collection('SnookerUsers')
            .where("uId", isEqualTo: uId)
            .get();

        // Start a batch
        final batch = fireStore.batch();

        for (var doc in querySnapshot.docs) {
          batch.update(doc.reference, {
            "snookerLogo": userData.snookerLogo,
            "snookerName": snookerName
          });
        }

        // Commit the batch (atomic operation)
        await batch.commit();
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
  /*                                delete operator                           */
  /*--------------------------------------------------------------------------*/
  static Future<void> deleteOperator(
      String email, String password, String id) async {
    FirebaseApp? secondaryApp;

    try {
      // Step 1: Create a secondary Firebase app (keeps admin session intact)
      secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      FirebaseAuth secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      // Step 2: Login as target user in secondary app
      UserCredential userCredential = await secondaryAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Step 3: Backup Firestore data
      final userDoc = await fireStore.collection('SnookerUsers').doc(id).get();
      final backupData = userDoc.data();

      // Step 4: Delete Firestore document first
      await fireStore.collection('SnookerUsers').doc(id).delete();

      // Step 5: Delete from Auth
      try {
        await userCredential.user!.delete();
      } catch (authErr) {
        // Rollback Firestore if Auth delete failed
        if (backupData != null) {
          try {
            await fireStore.collection('SnookerUsers').doc(id).set(backupData);
          } catch (rollbackErr) {
            // Optional: log rollback failure
            debugPrint("Rollback failed: $rollbackErr");
          }
        }
        throw "Something went wrong while deleting the user.";
      }
    } on FirebaseAuthException {
      throw "Authentication failed. Please check the user's credentials.";
    } on FirebaseException {
      throw "A server error occurred. Please try again later.";
    } on PlatformException {
      throw "Something went wrong on your device. Please try again.";
    } catch (e) {
      throw e.toString();
    } finally {
      // Step 6: Sign out secondary user and delete app
      try {
        if (secondaryApp != null) {
          await FirebaseAuth.instanceFor(app: secondaryApp).signOut();
          await secondaryApp.delete();
        }
      } catch (cleanupErr) {
        debugPrint("Secondary app cleanup failed: $cleanupErr");
      }
    }
  }
}
