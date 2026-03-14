import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snooker_management/constants/enum_constant.dart';

import 'package:snooker_management/models/user_profile.dart';
import 'package:snooker_management/routes/router_refresh_notifire.dart';
import 'package:snooker_management/services/authentication_services.dart';
import 'package:snooker_management/utils/flush_messages_util.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/internet_checker_helper.dart';
import 'package:snooker_management/views/screens/allocation_management/allocation_screen.dart';
import 'package:snooker_management/views/screens/attendance_management/attendance_screen.dart';
import 'package:snooker_management/views/screens/employee_management/employee_screen.dart';
import 'package:snooker_management/views/screens/expense_management/expense_screen.dart';

import 'package:snooker_management/views/screens/membership_management/membership_screen.dart';
import 'package:snooker_management/views/screens/package_management/package_screen.dart';
import 'package:snooker_management/views/screens/reports_management/sales_profit&loss_reports.dart';
import 'package:snooker_management/views/screens/salary_management/salary_screen.dart';
import 'package:snooker_management/views/screens/sale_management/sale_screen.dart';
import 'package:snooker_management/views/screens/table_management/tables_screen.dart';
import 'dart:typed_data' as typed_data;

class AuthenticationController extends GetxController {
  final TextEditingController snookerNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController =
      TextEditingController();

  GlobalKey<FormState> operatorLoginFieldsKey = GlobalKey<FormState>();
  GlobalKey<FormState> fieldKey = GlobalKey<FormState>();
  bool signuploading = false;
  final _auth = FirebaseAuth.instance;
  UsersModel? userPermissions;
  UsersModel? specificUserPermissions;

  String? userUid; // Default role

  void setUid() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userUid = sp.getString('uId') ?? "";
    update();
  }

  final AuthStateNotifier authNotifier;

  AuthenticationController(this.authNotifier);

  User? user;

  bool get isLoggedIn => user != null;

  void assignSnookerName() {
    snookerNameController.text = userPermissions!.snookerName.toString();
  }

  @override
  void onInit() {
    super.onInit();

    // Listen to Firebase auth changes
    _auth.authStateChanges().listen((firebaseUser) {
      user = firebaseUser;
      authNotifier.refresh(); // triggers GoRouter redirect
    });

    // Restore user data from SharedPreferences (for web refresh)
    _restoreUserFromPrefs();
  }

  Timer? demoTimer;
  int remainingSeconds = 0;

  static const String demoExpiryKey = "demo_expiry_time";

  Future<void> startDemoTimer(context) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if expiry already stored
    int? storedExpiry = prefs.getInt(demoExpiryKey);

    if (storedExpiry == null) {
      // First time login → create expiry time
      int expiryTime = DateTime.now().millisecondsSinceEpoch + (7 * 60 * 1000);

      await prefs.setInt(demoExpiryKey, expiryTime);
      remainingSeconds = 7 * 60;
    } else {
      // App refreshed → calculate remaining time
      int now = DateTime.now().millisecondsSinceEpoch;
      remainingSeconds = ((storedExpiry - now) / 1000).floor();

      if (remainingSeconds <= 0) {
        await prefs.remove(demoExpiryKey);
        logOut(context);
        return;
      }
    }

    update();
    _startTicker(context);
  }

  void _startTicker(context) {
    demoTimer?.cancel();

    demoTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        update();
      } else {
        timer.cancel();

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(demoExpiryKey);

        logOut(context);
      }
    });
  }

  Future<void> clearDemoTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(demoExpiryKey);
    demoTimer?.cancel();
  }

  // Timer? demoTimer;
  // int remainingSeconds = 7 * 60; // 7 minutes

  // void startDemoTimer(BuildContext context) {
  //   demoTimer?.cancel();
  //   remainingSeconds = 7 * 60;
  //   update();

  //   demoTimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (remainingSeconds > 0) {
  //       remainingSeconds--;
  //       update(); // triggers UI update in GetBuilder
  //     } else {
  //       timer.cancel();
  //       logOut(context);
  //       update();
  //     }
  //   });
  // }

  @override
  void onClose() {
    demoTimer?.cancel();
    super.onClose();
  }

  Future<void> _restoreUserFromPrefs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    // Restore uid
    userUid = sp.getString('uId');

    // Restore role
    userRole = sp.getString('role');

    // Restore snooker data
    userPermissions = UsersModel(
      uId: userUid ?? "",
      role: userRole ?? "",
      snookerLogo: sp.getString('clubLogo') ?? "",
      snookerName: sp.getString('clubName') ?? "",
      permissionsList: List<String>.from(jsonDecode(
          sp.getString('permissions') ??
              '[]')), // optionally you can store it too
    );

    // Assign snooker name to controller if needed
    if (userPermissions != null) {
      snookerNameController.text = userPermissions!.snookerName ?? "";
    }

    update(); // trigger UI rebuild
  }

  String operatorId = "";
  void setOperatorIdForPermission(String id) {
    operatorId = id;
    update();
  }

  /*----------------------------------------------------------------------*/
  /*                      sidebar navigation logic                        */
  /*----------------------------------------------------------------------*/
  enumPageIndex selectedPage = enumPageIndex.AllocationManagement;
  bool leftViewISVisible = true;
  String selectedTileText = "Allocation Management";

  void selectTile(String value) {
    selectedTileText = value;
    update();
  }

  void leftView(bool value) {
    leftViewISVisible = value;
    update();
  }

  changeScreenIndex(enumPageIndex page) {
    selectedPage = page;
    update();
  }

  Widget get screen {
    switch (selectedPage) {
      case enumPageIndex.AllocationManagement:
        return const AllocationScreenPage();
      case enumPageIndex.AttendanceManagement:
        return const AttendanceScreen();
      case enumPageIndex.EmployeeManagement:
        return const EmployeeScreen();
      case enumPageIndex.ExpenseManagement:
        return const ExpenseScreen();
      case enumPageIndex.MembershipManagement:
        return const MembershipScreen();
      case enumPageIndex.PackageManagement:
        return const PackageScreen();
      case enumPageIndex.SalaeManagement:
        return const SaleScreen();
      case enumPageIndex.SalaryManagement:
        return const SalaryScreen();
      case enumPageIndex.TableManagement:
        return const TablesScreen();
      case enumPageIndex.SalesProfit$Loss:
        return const SalesProfitAndLossReports();

      default:
        return const AllocationScreenPage();
    }
  }

  void setInitialIndex() {
    selectedTileText = "Allocation Management";
    selectedPage = enumPageIndex.AllocationManagement;
    update();
  }

  /*----------------------------------------------------------------------*/
  /*                              logOut                                  */
  /*----------------------------------------------------------------------*/
  Future<void> logOut(
    BuildContext context,
  ) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      // sp.remove("role");
      // sp.remove("uId");
      await sp.clear();
      // Dispose GlobalKeys by resetting them
      operatorLoginFieldsKey = GlobalKey<FormState>();
      fieldKey = GlobalKey<FormState>();
      FlushMessagesUtil.easyLoading();
      await FirebaseAuth.instance.signOut();
      Get.deleteAll(force: true);
      Get.put(authNotifier, permanent: true);
      Get.put(AuthenticationController(authNotifier), permanent: true);
      EasyLoading.dismiss();
      if (!context.mounted) return;
      clearDemoTimer();
      context.go('/login');
    } catch (e) {
      FlushMessagesUtil.snackBarMessage(("Error"), e.toString(), context);
    }
  }

  /*----------------------------------------------------------------------*/
  /*                             permission checker                       */
  /*----------------------------------------------------------------------*/
  List<String> honourPermissionsList = [];
  List<String> operatorPermissions = [];

  void permissionCheck(String index) {
    if ((operatorPermissions ?? []).contains(index)) {
      operatorPermissions.remove(index);
      update();
    } else {
      operatorPermissions.add(index);
      update();
    }
  }

  bool forgotPasswordLoading = false;
  final int _selectedIndex = 0;
  get selectedIndex => _selectedIndex;
  bool favourite = false;

  bool obsecurePassword = true;
  operatorObscure(bool value) {
    obsecurePassword = !value;
    update();
  }

  bool obsecurePasswordManager = true;
  managerObscure(bool a) {
    obsecurePasswordManager = !a;
    update();
  }

  bool passwordObscure = true;
  obscure(bool a) {
    passwordObscure = !a;
    update();
  }

  bool loadingLogin = false;
  loadingFunctionLogin(bool load) {
    loadingLogin = load;
    update();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    signupEmailController.clear();
    passwordController.clear();
    signupPasswordController.clear();
    nameController.clear();
  }

  /*----------------------------------------------------------------------*/
  /*                         check and validations                        */
  /*----------------------------------------------------------------------*/

  String? nameValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter name";
    }

    return null;
  }

  String? emailValidate(value) {
    bool emailReg = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value);
    if (emailReg == false) {
      return "Please enter valid email";
    }
    return null;
  }

  String? passwordValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter password";
    }
    return null;
  }

  String? signUppasswordValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your password.";
    }

    // Regex: At least 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

    if (!regex.hasMatch(value)) {
      return "Password must be at least 8 characters long, include an uppercase letter, "
          "a lowercase letter, a number, and a special character.";
    }

    return null;
  }

  String? snookerNameValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please must fill field";
    }
    return null;
  }

  /*----------------------------------------------------------------------*/
  /*                   login and authentication logic                     */
  /*----------------------------------------------------------------------*/

  Future<void> loginFunction(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      loadingFunctionLogin(true);

      await _auth.signInWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString());

      if ((await FirebaseAuthenticationServices.userExists())) {
        setInitialIndex();
        await getUserDetails(true);
        getUserRoleAndId();
        if (!context.mounted) return;

        context.go('/HomeScreen');

        emailController.clear();
        passwordController.clear();

        //DialogHelper.showSuccessDialog("Login successfully!", false);
        getUserRoleAndId();
      } else {
        if (!context.mounted) return;
        DialogHelper.showAttentionDialog(context,
            "You are not user of this application please contact with Admin");
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException code: ${e.code}'); // Debugging
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        if (!context.mounted) return;
        DialogHelper.showExceptionErrorDialog(
          context,
          "Incorrect email or password. Please try again.",
        );
      } else if (e.code == 'user-not-found') {
        if (!context.mounted) return;
        DialogHelper.showExceptionErrorDialog(
          context,
          "No account found with this email.",
        );
      } else if (e.code == 'invalid-email') {
        if (!context.mounted) return;
        DialogHelper.showExceptionErrorDialog(
          context,
          "The email address is badly formatted.",
        );
      } else {
        if (!context.mounted) return;
        DialogHelper.showExceptionErrorDialog(
          context,
          "Authentication failed. Please check your credentials.",
        );
      }
    } on FirebaseException {
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(
        context,
        "A server error occurred. Please try again later.",
      );
    } on PlatformException {
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(
        context,
        "Something went wrong on your device. Please try again.",
      );
    } catch (e) {
      throw e.toString();
    } finally {
      loadingFunctionLogin(false);
    }
  }

  /*----------------------------------------------------------------------*/
  /*                        set operator permissions                      */
  /*----------------------------------------------------------------------*/
  void setPermissions(BuildContext context, String? operatorId) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      FlushMessagesUtil.easyLoading();
      if (!context.mounted) return;
      await FirebaseAuthenticationServices.updateUserPermissions(
          context, operatorPermissions, operatorId ?? "");
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
          context, "Operator permissions updated successfully!", false);
      await getUserDetails(false);
      await getSpecificUserPermissions(operatorId ?? "");
    } catch (e) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(
        context,
        e.toString(),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getUserDetails(bool isFreshlogin) async {
    try {
      userPermissions =
          await FirebaseAuthenticationServices.getUserData(isFreshlogin);
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('role', userPermissions?.role ?? "");
      sp.setString('uId', userPermissions?.uId ?? "");
      sp.setString('clubLogo', userPermissions?.snookerLogo ?? "");
      sp.setString('clubName', userPermissions?.snookerName ?? "");
      sp.setString(
          'permissions', jsonEncode(userPermissions?.permissionsList ?? []));

      if (userPermissions != null) {
        honourPermissionsList.clear();
        update();
        honourPermissionsList.addAll(userPermissions!.permissionsList!);
      }
      update();
    } catch (e) {
      EasyLoading.dismiss();
      userPermissions = null;
      update();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getSpecificUserPermissions(String operatorId) async {
    try {
      specificUserPermissions =
          await FirebaseAuthenticationServices.getspecificOperatorData(
              operatorId);

      if (specificUserPermissions != null) {
        operatorPermissions.clear();
        operatorPermissions.addAll(specificUserPermissions!.permissionsList!);
      }
      update();
    } catch (e) {
      EasyLoading.dismiss();
      specificUserPermissions = null;
      update();
    } finally {
      EasyLoading.dismiss();
    }
  }

  String? userRole;
  void getUserRoleAndId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userRole = sp.getString('role');
    userUid = sp.getString('uId') ?? "";
    update();
  }

/*----------------------------------------------------------------------*/
/*                      update snooker logo or name                     */
/*----------------------------------------------------------------------*/
  Future<void> updateLogoOrName(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }

      FlushMessagesUtil.easyLoading();
      await FirebaseAuthenticationServices.updateLogoOrImage(
          context, userPermissions!, newImage, snookerNameController.text);
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(
          context, "You have successfully updated your Snooker profile", false);

      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('clubName', snookerNameController.text);

      update();
      getUserDetails(false);
    } catch (e) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      DialogHelper.showExceptionErrorDialog(
        context,
        e.toString(),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  /*--------------------------------------------------------------------------*/
  /*                                pick local Image                           */
  /*--------------------------------------------------------------------------*/

  typed_data.Uint8List? newImage;

  Future<void> imagePicker() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, //  only gallery
      );

      if (image != null) {
        newImage = await image.readAsBytes();
        update();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

/*----------------------------------------------------------------------*/
/*                               operator signup                        */
/*----------------------------------------------------------------------*/
  void operatorSignUp(BuildContext context) async {
    try {
      //Check Internet Connection Before Proceeding
      bool isConnected = await InternetCheckerHelper.isConnectedToInternet();
      if (!context.mounted) return;
      if (!isConnected) {
        DialogHelper.showInternetConnectionDialog(
            context, "Ensure you're connected to the internet and retry");
        return;
      }
      FlushMessagesUtil.easyLoading();
      update();

      await FirebaseAuthenticationServices.signUpAndCreateUserWithEmail(
          signupEmailController.text.toString(),
          signupPasswordController.text.toString(),
          nameController.text);
      if (!context.mounted) return;
      DialogHelper.showSuccessDialog(context,
          "Your operator account has been created successfully!", false);

      clearFields();
    } catch (e) {
      DialogHelper.showExceptionErrorDialog(
        context,
        "$e",
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

/*----------------------------------------------------------------------*/
/*                              delete operator                         */
/*----------------------------------------------------------------------*/

  Future<void> deleteOperator(BuildContext context, String? email,
      String? password, String? userId) async {
    try {
      FlushMessagesUtil.easyLoading();
      await FirebaseAuthenticationServices.deleteOperator(
          email ?? "", password ?? "", userId ?? "");
      if (!context.mounted) return;
      Navigator.of(context).pop();
      DialogHelper.showSuccessDialog(
          context, "Operator with ID $userId deleted successfully", false);
    } catch (e) {
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }
}
