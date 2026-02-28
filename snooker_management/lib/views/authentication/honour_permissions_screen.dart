import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';

import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class PermissionsScreen extends StatefulWidget {
  PermissionsScreen({
    super.key,
  });

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authenticationController.getUserDetails(false);
    authenticationController
        .getSpecificUserPermissions(authenticationController.operatorId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
      builder: (authenticationController) {
        return Scaffold(
          appBar: AppBar(),
          backgroundColor: ColorConstant.secondaryColor,
          body: authenticationController.userPermissions == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: ColorConstant.primaryColor,
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          "Set Permissions for Operator",
                          size: 20.sp,
                          fw: FontWeight.w700,
                          color: ColorConstant.blackColor,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Visibility(
                            visible: !ResponsiveHelper.isMobile(context) &&
                                !ResponsiveHelper.isTablet(context),
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 150.w),
                                  child: CustomText(
                                    "Allocated Modules",
                                    size: 20.sp,
                                    fw: FontWeight.w700,
                                    color: ColorConstant.blackColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                authenticationController.specificUserPermissions
                                            ?.permissionsList !=
                                        null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  authenticationController
                                                      .specificUserPermissions!
                                                      .permissionsList!
                                                      .length;
                                              i++)
                                            CustomText(
                                                "$i: ${authenticationController.specificUserPermissions!.permissionsList![i]}"),
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !ResponsiveHelper.isMobile(context) &&
                                !ResponsiveHelper.isTablet(context),
                            child: VerticalDivider(
                              color: ColorConstant.hintTextColor,
                              thickness: 1,
                              width: 1.w,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveHelper.isMobile(
                                                    context) ||
                                                ResponsiveHelper.isTablet(
                                                    context)
                                            ? 10.w
                                            : 150.w),
                                    child: authenticationController
                                                .userPermissions !=
                                            null
                                        ? authenticationController
                                                    .honourPermissionsList ==
                                                []
                                            ? const SizedBox()
                                            : ListView.builder(
                                                itemCount:
                                                    authenticationController
                                                        .honourPermissionsList
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    leading: CustomText(
                                                        authenticationController
                                                                .honourPermissionsList[
                                                            index]),
                                                    trailing: CheckboxTheme(
                                                      data: CheckboxThemeData(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(4
                                                                  .r), // Optional, to make the border rounded
                                                          side: BorderSide(
                                                            color: const Color(
                                                                0x261B0D38), // #1B0D38 with 15% opacity
                                                            width: 1.5
                                                                .w, // Border width
                                                          ),
                                                        ),
                                                        fillColor:
                                                            WidgetStateProperty
                                                                .resolveWith(
                                                                    (states) {
                                                          if (states.contains(
                                                              WidgetState
                                                                  .selected)) {
                                                            return ColorConstant
                                                                .primaryColor; // Tick color when selected
                                                          }
                                                          return Colors
                                                              .transparent; // Background color when unchecked
                                                        }),
                                                        checkColor:
                                                            WidgetStateProperty
                                                                .all(ColorConstant
                                                                    .blackColor), // Tick color
                                                      ),
                                                      child: Checkbox(
                                                        value: (authenticationController
                                                                        .operatorPermissions ??
                                                                    [])
                                                                .contains(
                                                                    authenticationController
                                                                            .honourPermissionsList[
                                                                        index])
                                                            ? true
                                                            : false,
                                                        onChanged: (value) {
                                                          authenticationController
                                                              .permissionCheck(
                                                                  authenticationController
                                                                          .honourPermissionsList[
                                                                      index]);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                })
                                        : const SizedBox(),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomButtonWidget(
                                      height: 50.h,
                                      width: 70.w,
                                      text: "Update",
                                      textColor: ColorConstant.whiteColor,
                                      buttonColor: ColorConstant.primaryColor,
                                      textSize: 12.sp,
                                      textFw: FontWeight.w400,
                                      tabAction: () {
                                        authenticationController.setPermissions(
                                            context,
                                            authenticationController
                                                .operatorId);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.w,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
