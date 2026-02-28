import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/routes/router_refresh_notifire.dart';
import 'package:snooker_management/views/authentication/brand_panel_screen.dart';
import 'package:snooker_management/views/authentication/glass_login_card.dart';

class LoginScreen extends StatefulWidget {
  final bool showAccessDenied;
  const LoginScreen({super.key, this.onLogin, this.showAccessDenied = false});

  /// Hook your own login function here.
  final Future<void> Function(String email, String password)? onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers & state
  bool _snackbarShown = false;
  late final AuthStateNotifier authNotifier;
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showAccessDenied && !_snackbarShown) {
      _snackbarShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("You must login first to access this page."),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            backgroundColor: ColorConstant.secondaryColor,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    authenticationController = Get.find<AuthenticationController>();
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 980;

    return Scaffold(
      body: GetBuilder<AuthenticationController>(
        builder: (authenticationControllerr) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight, // at least full viewport height
                  ),
                  child: Stack(
                    children: [
                      // Cinematic Background
                      Positioned.fill(
                        child: Image.asset(
                          ImageConstant.loginImage,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),

                      // Dark vignette + brand gradient
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.75),
                                Colors.black.withOpacity(0.85),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      // Soft green glow behind content (depth)
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              radius: 1.1,
                              colors: [
                                ColorConstant.primaryColor.withOpacity(0.18),
                                Colors.transparent,
                              ],
                              center: const Alignment(0.1, -0.2),
                            ),
                          ),
                        ),
                      ),

                      // Content
                      SafeArea(
                        child: Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 1250),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: isWide
                                  ? Container(
                                      height: constraints
                                          .maxHeight, //  use LayoutBuilder constraints
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: BrandPanelView(
                                              gold: ColorConstant.goldColor,
                                              green: ColorConstant.primaryColor,
                                            ),
                                          ),
                                          const SizedBox(width: 32),
                                          Expanded(
                                            flex: 5,
                                            child: GlassLoginCard(
                                              formKey: _formKey,
                                              email: authenticationController
                                                  .emailController,
                                              password: authenticationController
                                                  .passwordController,
                                              obscure: authenticationController
                                                  .obsecurePassword,
                                              setObsecure: () {
                                                authenticationController
                                                    .operatorObscure(
                                                        authenticationController
                                                            .obsecurePassword);
                                              },
                                              loading: authenticationController
                                                  .loadingLogin,
                                              onLogin: () {
                                                authenticationController
                                                    .emailController
                                                    .text = "demo@gmail.com";
                                                authenticationController
                                                    .passwordController
                                                    .text = "12345678";
                                                authenticationController
                                                    .loginFunction(context);
                                              },
                                              gold: ColorConstant.goldColor,
                                              green: ColorConstant.primaryColor,
                                              felt: ColorConstant.drkerFelt,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        BrandPanelView(
                                          gold: ColorConstant.goldColor,
                                          green: ColorConstant.primaryColor,
                                        ),
                                        const SizedBox(height: 22),
                                        GlassLoginCard(
                                          formKey: _formKey,
                                          email: authenticationController
                                              .emailController,
                                          password: authenticationController
                                              .passwordController,
                                          obscure: authenticationController
                                              .obsecurePassword,
                                          setObsecure: () {
                                            authenticationController
                                                .operatorObscure(
                                                    authenticationController
                                                        .obsecurePassword);
                                          },
                                          loading: authenticationController
                                              .loadingLogin,
                                          onLogin: () {
                                            authenticationController
                                                .emailController
                                                .text = "demo@gmail.com";
                                            authenticationController
                                                .passwordController
                                                .text = "12345678";
                                            authenticationController
                                                .loginFunction(context);
                                          },
                                          gold: ColorConstant.goldColor,
                                          green: ColorConstant.primaryColor,
                                          felt: ColorConstant.drkerFelt,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
