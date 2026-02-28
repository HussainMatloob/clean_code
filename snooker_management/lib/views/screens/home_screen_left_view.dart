import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/constants/data_constant.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';

import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_list_tile.dart';
import 'package:snooker_management/views/widgets/shimer_effect_widget.dart';
import '../../main.dart';
import '../widgets/custom_image_widget.dart';
import '../widgets/custom_text.dart';

class HomeScreenLeftView extends StatefulWidget {
  const HomeScreenLeftView({super.key});
  @override
  State<HomeScreenLeftView> createState() => _HomeScreenLeftViewState();
}

class _HomeScreenLeftViewState extends State<HomeScreenLeftView> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GetBuilder<AuthenticationController>(
      builder: (authenticationController) {
        if (authenticationController.leftViewISVisible == true ||
            ResponsiveHelper.isTablet(context) ||
            ResponsiveHelper.isMobile(context)) {
          return Container(
            height: mq.height,
            width: mq.width * 0.18,
            decoration: BoxDecoration(
              // border: Border.all(width: mq.width * 0.0001),
              color: ColorConstant.leftViewColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // subtle shadow
                  offset: const Offset(0, 2), // bottom shadow only
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: authenticationController.userPermissions != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 120.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Image with padding
                            ResponsiveHelper.isTablet(context) ||
                                    ResponsiveHelper.isMobile(context)
                                ? authenticationController.userRole == "Honour"
                                    ? InkWell(
                                        onTap: () {
                                          context.go('/app/adminPage');
                                        },
                                        child: Padding(
                                          padding: EdgeInsetsGeometry.only(
                                              left: 10.w,
                                              bottom: 10.h,
                                              top: 10.h),
                                          child: Container(
                                            height: 60.h,
                                            width: 50.w,
                                            decoration: BoxDecoration(
                                                color: ColorConstant
                                                    .secondaryColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 1,
                                                    color: ColorConstant
                                                        .primaryColor)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      50), // makes it circular
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    authenticationController
                                                            .userPermissions
                                                            ?.snookerLogo ??
                                                        "",
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const Center(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(
                                                  Icons.person,
                                                  size: 15.sp,
                                                  color:
                                                      ColorConstant.greyColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(8.0.w),
                                        child: CustomImageWidget(
                                          radius: 5.r,

                                          width: 50
                                              .w, // slightly smaller for sidebar
                                          height: 70.h,
                                          image: authenticationController
                                                  .userPermissions
                                                  ?.snookerLogo ??
                                              "",
                                        ),
                                      )
                                : Padding(
                                    padding: EdgeInsets.all(8.0.w),
                                    child: CustomImageWidget(
                                      radius: 5.r,

                                      width:
                                          50.w, // slightly smaller for sidebar
                                      height: 70.h,
                                      image: authenticationController
                                              .userPermissions?.snookerLogo ??
                                          "",
                                    ),
                                  ),

                            SizedBox(
                                width: 10.w), // space between image and text

                            // Name text
                            Expanded(
                              child: Text(
                                authenticationController
                                        .userPermissions?.snookerName ??
                                    "",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: ColorConstant.primaryColor,
                                ),
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis, // prevents overflow
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...DataConstant.menuItems.map((item) {
                                      // check permission
                                      if (authenticationController
                                          .userPermissions!.permissionsList!
                                          .contains(item.permission)) {
                                        return Column(
                                          children: [
                                            CustomListTile(
                                              onTap: () {
                                                authenticationController
                                                    .selectTile(item.title);
                                                authenticationController
                                                    .changeScreenIndex(
                                                        item.pageIndex);
                                                if (ResponsiveHelper.isTablet(
                                                        context) ||
                                                    ResponsiveHelper.isMobile(
                                                        context)) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              text: item.title,
                                              textSize: 11.sp,
                                              textFw: FontWeight.w700,
                                              textColor:
                                                  authenticationController
                                                              .selectedPage ==
                                                          item.pageIndex
                                                      ? ColorConstant
                                                          .primaryColor
                                                      : ColorConstant
                                                          .blackColor,
                                              icon: Icon(
                                                item.icon,
                                                size: 20.sp,
                                                color: authenticationController
                                                            .selectedPage ==
                                                        item.pageIndex
                                                    ? ColorConstant.primaryColor
                                                    : ColorConstant.blackColor,
                                              ),
                                              height: 50.h,
                                              width: 40.w,
                                              padding: 20.r,
                                              isAsset: true,
                                            ),
                                            const Divider(height: 1),
                                          ],
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }).toList(),

                                    // Logout button
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 30.h),
                                      child: ListTile(
                                        onTap: () {
                                          CustomAlertDialog.CustomDialog(
                                            containerHeight: 350.h,
                                            containerWidth: 100.w,
                                            height: 30.h,
                                            context,
                                            text:
                                                "Are you sure you want to log out? You will need to log in again with your credentials to access your account.",
                                            textFw: FontWeight.bold,
                                            yesAction: () {
                                              authenticationController
                                                  .logOut(context);
                                            },
                                            noAction: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                        leading: const Icon(
                                          Icons.logout,
                                          color: Color(0xFF136A3B),
                                          size: 30,
                                        ),
                                        title: CustomText(
                                          "LogOut",
                                          color: ColorConstant.blackColor,
                                          fw: FontWeight.w700,
                                          size: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !ResponsiveHelper.isTablet(context) &&
                                  !ResponsiveHelper.isMobile(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        authenticationController
                                            .leftView(false);
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        color: ColorConstant.greyColor,
                                      )),
                                  SizedBox(
                                    width: 15.w,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : const ShimmerEffectWidget(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
