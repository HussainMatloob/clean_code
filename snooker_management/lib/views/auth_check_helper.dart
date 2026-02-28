import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:snooker_management/controller/auth_controller.dart';

bool isLoggedIn() {
  return Get.isRegistered<AuthenticationController>() &&
      Get.find<AuthenticationController>().userUid != null &&
      FirebaseAuth.instance.currentUser != null;
}
