import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/routes/app_router.dart';
import 'package:snooker_management/routes/router_refresh_notifire.dart';

import 'firebase_options.dart';

late Size mq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authNotifier = AuthStateNotifier();

  // Register with GetX
  Get.put(authNotifier,
      permanent: true); //  so you can Get.find<AuthStateNotifier>()

  Get.put(AuthenticationController(authNotifier), permanent: true);

  runApp(MyApp(authNotifier: authNotifier));
}

class MyApp extends StatelessWidget {
  final AuthStateNotifier authNotifier;
  late final GoRouter _router = AppRouter.router(authNotifier);

  MyApp({super.key, required this.authNotifier});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine designSize based on the screen width at runtime
        final designSize = constraints.maxWidth >= 1024
            ? const Size(1440, 1024) // Desktop
            : constraints.maxWidth >= 600
                ? const Size(768, 1024) // Tablet
                : const Size(375, 812); // Mobile
        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Snooker Partner',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
                useMaterial3: true,
              ),
              builder: EasyLoading.init(),
              //  home: const LoginScreen(),

              routerDelegate: _router.routerDelegate,
              routeInformationParser: _router.routeInformationParser,
              routeInformationProvider: _router.routeInformationProvider,
            );
          },
        );
      },
    );
  }
}
