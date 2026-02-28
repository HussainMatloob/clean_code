import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/home_screen_left_view.dart';

import 'package:snooker_management/views/widgets/custom_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final AuthenticationController authenticationController;

  @override
  void initState() {
    super.initState();
    authenticationController = Get.find<AuthenticationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Production-safe controller initialization
      authenticationController.startDemoTimer(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GetBuilder<AuthenticationController>(
      builder: (_) {
        final minutes = _.remainingSeconds ~/ 60;
        final seconds = _.remainingSeconds % 60;
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorConstant.whiteColor,
          appBar: ResponsiveHelper.isTablet(context) ||
                  ResponsiveHelper.isMobile(context)
              ? AppBar(
                  title: CustomText(
                    "Snooker Management",
                    fw: FontWeight.w900,
                    size: 14.sp,
                    color: ColorConstant.offWhite,
                  ),
                  backgroundColor: ColorConstant.primaryColor,
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: ColorConstant.offWhite,
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState
                            ?.openDrawer(); // opens the drawer
                      },
                    ),
                  ),
                  actions: [
                    CustomText(
                      "${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
                      textStyle: TextStyle(
                          color: ColorConstant.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_outlined,
                      ),
                      color: ColorConstant.whiteColor,
                    ),
                    SizedBox(
                      width: 10.w,
                    )
                  ],
                )
              : null,
          drawer: SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.8, // your sidebar width
            child: Material(
              // Material gives proper ripple effects
              color: ColorConstant.leftViewColor, // same as your sidebar
              child: const HomeScreenLeftView(),
            ),
          ),
          body: Container(
            height: mq.height,
            width: mq.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: ColorConstant.linearGradian),
            ),
            child: authenticationController.userUid != null &&
                    auth.currentUser?.uid != null
                ? Row(
                    children: [
                      Visibility(
                          visible: !ResponsiveHelper.isTablet(context) &&
                              !ResponsiveHelper.isMobile(context),
                          child: const HomeScreenLeftView()),
                      Expanded(
                        child: Column(
                          children: [
                            Visibility(
                              visible: !ResponsiveHelper.isTablet(context) &&
                                  !ResponsiveHelper.isMobile(context),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 25.w, bottom: 10.h, right: 15.w),
                                decoration: BoxDecoration(
                                  color: ColorConstant.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.1), // subtle shadow
                                      offset: const Offset(
                                          2, 0), // right shadow only
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: authenticationController
                                                  .leftViewISVisible ==
                                              false,
                                          child: IconButton(
                                              onPressed: () {
                                                authenticationController
                                                    .leftView(true);
                                              },
                                              icon: Icon(
                                                Icons.menu,
                                                color: ColorConstant.offWhite,
                                              )),
                                        ),
                                        SizedBox(
                                          height: authenticationController
                                                  .leftViewISVisible
                                              ? 7.h
                                              : 0.h,
                                        ),
                                        CustomText(
                                          "Snooker Management",
                                          fw: FontWeight.w900,
                                          size: 14.sp,
                                          color: ColorConstant.offWhite,
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20.w),
                                          child: CustomText(
                                            authenticationController
                                                .selectedTileText,
                                            size: 12.sp,
                                            color: ColorConstant.offWhite,
                                            fw: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            "${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
                                            textStyle: TextStyle(
                                                color: ColorConstant.whiteColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.notifications_outlined,
                                            ),
                                            color: ColorConstant.whiteColor,
                                          ),
                                          SizedBox(
                                            width: authenticationController
                                                        .userRole ==
                                                    "Honour"
                                                ? 10.w
                                                : 0.w,
                                          ),
                                          authenticationController.userRole ==
                                                  "Honour"
                                              ? InkWell(
                                                  onTap: () {
                                                    context
                                                        .go('/app/adminPage');
                                                  },
                                                  child: Container(
                                                    height: 60.h,
                                                    width: 50.w,
                                                    decoration: BoxDecoration(
                                                      color: ColorConstant
                                                          .secondaryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50), // makes it circular
                                                      child: CachedNetworkImage(
                                                        imageUrl: authenticationController
                                                                .userPermissions
                                                                ?.snookerLogo ??
                                                            "",
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.person,
                                                          size: 15.sp,
                                                          color: ColorConstant
                                                              .greyColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(child: authenticationController.screen)
                          ],
                        ),
                      )
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                    color: ColorConstant.primaryColor,
                  )),
          ),
        );
      },
    );
  }
}
