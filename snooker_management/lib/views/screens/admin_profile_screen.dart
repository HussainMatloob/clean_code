import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/user_profile.dart';
import 'package:snooker_management/services/authentication_services.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';

import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_image_selector.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> formKey1 = GlobalKey();
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authenticationController.assignSnookerName();
    authenticationController.setUid();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      body: GetBuilder<AuthenticationController>(
        builder: (authenticationController) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: ColorConstant.linearGradian),
            ),
            width: double.infinity,
            height: mq.height,
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorConstant.primaryColor,
                          ColorConstant.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstant.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "🎱 Owner Dashboard",
                              size: 26.sp,
                              fw: FontWeight.bold,
                              color: Colors.white,
                            ),
                            SizedBox(height: 6.h),
                            CustomText(
                              "Manage your snooker club & operators",
                              size: 14.sp,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  /// TOP GRID LAYOUT (2 columns)
                  ResponsiveHelper.isMobile(context)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              /// PROFILE SECTION
                              _buildGlassCard(
                                title: "Club Profile",
                                icon: Icons.business,
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFormField(
                                        controller: authenticationController
                                            .snookerNameController,
                                        horizontalPadding: 10.w,
                                        labelText: "Snooker Club Name",
                                        validateFunction:
                                            authenticationController
                                                .snookerNameValidate,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      SizedBox(height: 20.h),
                                      CustomText(
                                        "Upload Club Logo",
                                        size: 14.sp,
                                        fw: FontWeight.w500,
                                      ),
                                      SizedBox(height: 10.h),
                                      Container(
                                        width: 150.w,
                                        height: 150.h,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ColorConstant.greyLightColor,
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Center(
                                          child: CustomImageSelector(
                                            image: authenticationController
                                                .userPermissions?.snookerLogo,
                                            height: 150.h,
                                            width: 120.w,
                                            icon: Icon(Icons.image,
                                                size: 40.sp,
                                                color: ColorConstant.greyColor),
                                            color: ColorConstant.greyLightColor,
                                            controller:
                                                authenticationController,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 25.h),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CustomButtonWidget(
                                          width: 160.w,
                                          text: "💾 Save Changes",
                                          height: 45.h,
                                          radius: 12.r,
                                          textSize: 14.sp,
                                          buttonColor:
                                              ColorConstant.primaryColor,
                                          tabAction: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              authenticationController
                                                  .updateLogoOrName(context);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 24.h),

                              /// OPERATOR REGISTRATION SECTION
                              _buildGlassCard(
                                title: "Register Operator",
                                icon: Icons.group_add,
                                child: Form(
                                  key: formKey1,
                                  child: Column(
                                    children: [
                                      CustomTextFormField(
                                        controller: authenticationController
                                            .nameController,
                                        horizontalPadding: 10.w,
                                        labelText: "Full Name",
                                        validateFunction:
                                            authenticationController
                                                .nameValidate,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextFormField(
                                        controller: authenticationController
                                            .signupEmailController,
                                        horizontalPadding: 10.w,
                                        labelText: "Email Address",
                                        validateFunction:
                                            authenticationController
                                                .emailValidate,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextFormField(
                                        controller: authenticationController
                                            .signupPasswordController,
                                        horizontalPadding: 10.w,
                                        labelText: "Password",
                                        validateFunction:
                                            authenticationController
                                                .signUppasswordValidate,
                                        textInputAction: TextInputAction.done,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: CustomText(
                                            "Change Password?",
                                            size: 12.sp,
                                            fw: FontWeight.w500,
                                            color: ColorConstant.primaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CustomButtonWidget(
                                          width: 160.w,
                                          text: "➕ Add Operator",
                                          height: 45.h,
                                          radius: 12.r,
                                          textSize: 14.sp,
                                          buttonColor:
                                              ColorConstant.primaryColor,
                                          tabAction: () {
                                            if (formKey1.currentState!
                                                .validate()) {
                                              authenticationController
                                                  .operatorSignUp(context);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ])
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              /// PROFILE SECTION
                              Expanded(
                                child: _buildGlassCard(
                                  title: "Club Profile",
                                  icon: Icons.business,
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextFormField(
                                          controller: authenticationController
                                              .snookerNameController,
                                          horizontalPadding: 10.w,
                                          labelText: "Snooker Club Name",
                                          validateFunction:
                                              authenticationController
                                                  .snookerNameValidate,
                                          textInputAction: TextInputAction.next,
                                        ),
                                        SizedBox(height: 20.h),
                                        CustomText(
                                          "Upload Club Logo",
                                          size: 14.sp,
                                          fw: FontWeight.w500,
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          width: 150.w,
                                          height: 150.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  ColorConstant.greyLightColor,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: Center(
                                            child: CustomImageSelector(
                                              image: authenticationController
                                                  .userPermissions?.snookerLogo,
                                              height: 150.h,
                                              width: 120.w,
                                              icon: Icon(Icons.image,
                                                  size: 40.sp,
                                                  color:
                                                      ColorConstant.greyColor),
                                              color:
                                                  ColorConstant.greyLightColor,
                                              controller:
                                                  authenticationController,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 25.h),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: CustomButtonWidget(
                                            width: 160.w,
                                            text: "💾 Save Changes",
                                            height: 45.h,
                                            radius: 12.r,
                                            textSize: 14.sp,
                                            buttonColor:
                                                ColorConstant.primaryColor,
                                            tabAction: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                authenticationController
                                                    .updateLogoOrName(context);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 24.w),

                              /// OPERATOR REGISTRATION SECTION
                              Expanded(
                                child: _buildGlassCard(
                                  title: "Register Operator",
                                  icon: Icons.group_add,
                                  child: Form(
                                    key: formKey1,
                                    child: Column(
                                      children: [
                                        CustomTextFormField(
                                          controller: authenticationController
                                              .nameController,
                                          horizontalPadding: 10.w,
                                          labelText: "Full Name",
                                          validateFunction:
                                              authenticationController
                                                  .nameValidate,
                                          textInputAction: TextInputAction.next,
                                        ),
                                        SizedBox(height: 20.h),
                                        CustomTextFormField(
                                          controller: authenticationController
                                              .signupEmailController,
                                          horizontalPadding: 10.w,
                                          labelText: "Email Address",
                                          validateFunction:
                                              authenticationController
                                                  .emailValidate,
                                          textInputAction: TextInputAction.next,
                                        ),
                                        SizedBox(height: 20.h),
                                        CustomTextFormField(
                                          controller: authenticationController
                                              .signupPasswordController,
                                          horizontalPadding: 10.w,
                                          labelText: "Password",
                                          validateFunction:
                                              authenticationController
                                                  .signUppasswordValidate,
                                          textInputAction: TextInputAction.done,
                                        ),
                                        SizedBox(height: 2.h),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {},
                                            child: CustomText(
                                              "Change Password?",
                                              size: 12.sp,
                                              fw: FontWeight.w500,
                                              color: ColorConstant.primaryColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: CustomButtonWidget(
                                            width: 160.w,
                                            text: "➕ Add Operator",
                                            height: 45.h,
                                            radius: 12.r,
                                            textSize: 14.sp,
                                            buttonColor:
                                                ColorConstant.primaryColor,
                                            tabAction: () {
                                              if (formKey1.currentState!
                                                  .validate()) {
                                                authenticationController
                                                    .operatorSignUp(context);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),

                  SizedBox(height: 40.h),

                  /// OPERATOR LIST SECTION
                  CustomText(
                    "Your Operators",
                    size: 16.sp,
                    fw: FontWeight.w600,
                    color: ColorConstant.blackColor,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                      width: 500.w,
                      child: StreamBuilder(
                          stream:
                              FirebaseAuthenticationServices.getYourOperators(
                                  authenticationController.userUid ?? ""),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isEmpty) {
                                return SizedBox();
                              } else {
                                var data = snapshot.data?.docs;
                                List<UsersModel> operators = data
                                        ?.map((e) =>
                                            UsersModel.fromJson(e.data()))
                                        .toList() ??
                                    [];
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: operators.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.all(10.r),
                                      child: InkWell(
                                        onTap: () {
                                          authenticationController
                                              .setOperatorIdForPermission(
                                                  operators[index].id ?? "");
                                          context.go('/app/permissionsScreen');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(16.r),
                                          decoration: BoxDecoration(
                                            color: ColorConstant.offWhite,
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.15),
                                                offset: const Offset(
                                                    4, 4), // bottom-right
                                                blurRadius: 12,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    "Operator ${index + 1}",
                                                    size: 14.sp,
                                                    fw: FontWeight.w600,
                                                  ),
                                                  CustomButtonWidget(
                                                    text: "Remove",
                                                    textSize: 12.sp,
                                                    textFw: FontWeight.w400,
                                                    radius: 5.r,
                                                    height: 40.h,
                                                    textColor: ColorConstant
                                                        .whiteColor,
                                                    buttonColor:
                                                        ColorConstant.redColor,
                                                    paddingHorizontal: 10.w,
                                                    tabAction: () {
                                                      CustomAlertDialog
                                                          .CustomDialog(
                                                              containerHeight:
                                                                  350.h,
                                                              containerWidth:
                                                                  100.w,
                                                              height: 30.h,
                                                              context,
                                                              text:
                                                                  "Are you sure you want to delete this operator record? If you proceed, you will lose all information related to this operator.!",
                                                              textFw: FontWeight
                                                                  .bold,
                                                              yesAction: () {
                                                        authenticationController.deleteOperator(
                                                            context,
                                                            operators[index]
                                                                    .email ??
                                                                "",
                                                            operators[index]
                                                                    .password ??
                                                                "",
                                                            operators[index]
                                                                    .id ??
                                                                "");
                                                      }, noAction: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .person_outline,
                                                            size: 20.sp,
                                                            color: ColorConstant
                                                                .primaryColor),
                                                        SizedBox(height: 5.h),
                                                        CustomText(
                                                          operators[index]
                                                                  .userName ??
                                                              "",
                                                          maxLines: 1,
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          size: 12.sp,
                                                          fw: FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .email_outlined,
                                                            size: 20.sp,
                                                            color: ColorConstant
                                                                .primaryColor),
                                                        SizedBox(height: 5.h),
                                                        CustomText(
                                                          operators[index]
                                                                  .email ??
                                                              "",
                                                          maxLines: 1,
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          size: 12.sp,
                                                          fw: FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .password_outlined,
                                                            size: 20.sp,
                                                            color: ColorConstant
                                                                .primaryColor),
                                                        SizedBox(height: 5.h),
                                                        CustomText(
                                                          operators[index]
                                                                  .password ??
                                                              "",
                                                          maxLines: 1,
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          size: 12.sp,
                                                          fw: FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                            Icons.military_tech,
                                                            size: 20.sp,
                                                            color: ColorConstant
                                                                .primaryColor),
                                                        SizedBox(height: 5.h),
                                                        CustomText(
                                                          operators[index]
                                                                  .role ??
                                                              "",
                                                          maxLines: 1,
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          size: 12.sp,
                                                          fw: FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              /// Delete Button
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            } else {
                              return SizedBox(
                                  height: 50.h,
                                  width: 50.w,
                                  child: const Center(
                                      child: CircularProgressIndicator()));
                            }
                          })),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassCard(
      {required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child:
                    Icon(icon, color: ColorConstant.primaryColor, size: 20.sp),
              ),
              SizedBox(width: 10.w),
              CustomText(title, size: 18.sp, fw: FontWeight.w600),
            ],
          ),
          Divider(height: 30.h, thickness: 1),
          child,
        ],
      ),
    );
  }
}
