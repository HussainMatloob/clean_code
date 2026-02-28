import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/controller/package_controller.dart';
import 'package:snooker_management/models/package_model.dart';
import 'package:snooker_management/services/package_services.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/package_management/add_and_update_package_dialog.dart';
import 'package:snooker_management/views/screens/package_management/packageTableRow.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_empty_screen_message.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

import '../../../main.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  PackageController packageController = Get.put(PackageController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packageController.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<PackageController>(
      init: PackageController(),
      builder: (packageController) {
        return Container(
          decoration: BoxDecoration(
            color: ColorConstant.secondaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // subtle shadow
                offset: const Offset(2, 2), // 2 right, 2 bottom
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: ResponsiveHelper.isMobile(context)
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            CustomButtonWidget(
                              sizedBoxWidth: 10.w,
                              tabAction: () {
                                packageController.packagePriceController
                                    .clear();
                                packageController.packageNameController.clear();
                                packageController.packageDescriptionController
                                    .clear();
                                packageController.packageDurationController
                                    .clear();
                                AddAndUpdatePackageDialog.showCustomDialog(
                                    isDataAddAble: true,
                                    context,
                                    height: 600.h,
                                    width: 600.w);
                              },
                              buttonColor: ColorConstant.primaryColor,
                              height: mq.height * 0.04,
                              paddingHorizontal: 15.w,
                              textSize: 12.sp,
                              textFw: FontWeight.w400,
                              textColor: ColorConstant.whiteColor,
                              text: "Add new",
                              radius: 5.r,
                              icon: Icon(
                                size: 12.sp,
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: PackageTableRow(
                            cells: [
                              CustomTableCell(
                                text: "Package Name",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Package Price",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Description",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Duration",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Actions",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                            ],
                            isHeader: true,
                          ),
                        ),
                        packageController.userUid == null
                            ? SizedBox()
                            : PaginateFirestore(
                                shrinkWrap: true,
                                itemBuilder:
                                    (context, documentSnapshot, index) {
                                  PackageModel packageModel =
                                      PackageModel.fromJson(
                                          documentSnapshot[index].data()
                                              as Map<String, dynamic>);

                                  return ResponsiveHelper.isMobile(context)
                                      ? GestureDetector(
                                          onTap: () {
                                            packageController
                                                    .packageNameController
                                                    .text =
                                                packageModel.packageName!;
                                            packageController
                                                    .packagePriceController
                                                    .text =
                                                packageModel.packagePrice!;
                                            packageController
                                                    .packageDescriptionController
                                                    .text =
                                                packageModel
                                                    .packageDescription!;
                                            packageController
                                                    .packageDurationController
                                                    .text =
                                                packageModel.packageDuration!;
                                            AddAndUpdatePackageDialog
                                                .showCustomDialog(
                                                    isDataAddAble: false,
                                                    context,
                                                    id: packageModel.id,
                                                    height: 600.h,
                                                    width: 600.w);
                                          },
                                          child: Container(
                                            width: mq.width,
                                            margin:
                                                EdgeInsets.only(bottom: 15.h),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                                color: ColorConstant
                                                    .greenLightColor,
                                                borderRadius:
                                                    BorderRadius.circular(5.r)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomText(
                                                      packageModel.packageName,
                                                      fw: FontWeight.w700,
                                                      size: 14.sp,
                                                      color: ColorConstant
                                                          .blackColor,
                                                    ),
                                                    CustomText(
                                                      packageModel
                                                              .packagePrice ??
                                                          "",
                                                      fw: FontWeight.w400,
                                                      size: 11.sp,
                                                      color: ColorConstant
                                                          .blackColor,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: CustomText(
                                                        packageModel
                                                                .packageDescription ??
                                                            "",
                                                        fw: FontWeight.w400,
                                                        size: 11.sp,
                                                        color: ColorConstant
                                                            .blackColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    CustomText(
                                                      packageModel
                                                              .packageDuration ??
                                                          "",
                                                      fw: FontWeight.w400,
                                                      size: 11.sp,
                                                      color: ColorConstant
                                                          .blackColor,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    CustomButtonWidget(
                                                      radius: 5.r,
                                                      height: mq.height * 0.03,
                                                      paddingHorizontal: 8.w,
                                                      buttonColor: ColorConstant
                                                          .redColor,
                                                      textColor: ColorConstant
                                                          .whiteColor,
                                                      text: "Delete",
                                                      textSize: 10.sp,
                                                      tabAction: () async {
                                                        CustomAlertDialog
                                                            .CustomDialog(
                                                                containerHeight:
                                                                    300.h,
                                                                containerWidth:
                                                                    100.w,
                                                                height: 30.h,
                                                                context,
                                                                text:
                                                                    "You sure want to delete this package record!",
                                                                textFw:
                                                                    FontWeight
                                                                        .bold,
                                                                yesAction: () {
                                                          packageController
                                                              .packageDeleteAction(
                                                                  packageModel,
                                                                  context);
                                                        }, noAction: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ))
                                      : PackageTableRow(
                                          cells: [
                                            CustomTableCell(
                                              text: packageModel.packageName,
                                              padding: 8.r,
                                            ),
                                            CustomTableCell(
                                              text: packageModel.packagePrice,
                                              padding: 8.r,
                                            ),
                                            CustomTableCell(
                                              text: packageModel
                                                  .packageDescription,
                                              padding: 8.r,
                                            ),
                                            CustomTableCell(
                                              text:
                                                  packageModel.packageDuration,
                                              padding: 8.r,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                  child: CustomButtonWidget(
                                                    tabAction: () {
                                                      packageController
                                                              .packageNameController
                                                              .text =
                                                          packageModel
                                                              .packageName!;
                                                      packageController
                                                              .packagePriceController
                                                              .text =
                                                          packageModel
                                                              .packagePrice!;
                                                      packageController
                                                              .packageDescriptionController
                                                              .text =
                                                          packageModel
                                                              .packageDescription!;
                                                      packageController
                                                              .packageDurationController
                                                              .text =
                                                          packageModel
                                                              .packageDuration!;
                                                      AddAndUpdatePackageDialog
                                                          .showCustomDialog(
                                                              isDataAddAble:
                                                                  false,
                                                              context,
                                                              id: packageModel
                                                                  .id,
                                                              height: 600.h,
                                                              width: 600.w);
                                                    },
                                                    icon: Icon(
                                                      Icons.update,
                                                      size: 18.sp,
                                                      color: ColorConstant
                                                          .whiteColor,
                                                    ),
                                                    height: 50.h,
                                                    width: 40.w,
                                                    buttonColor:
                                                        ColorConstant.blueColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                FittedBox(
                                                  child: CustomButtonWidget(
                                                    tabAction: () {
                                                      CustomAlertDialog
                                                          .CustomDialog(
                                                              containerHeight:
                                                                  300.h,
                                                              containerWidth:
                                                                  100.w,
                                                              height: 30.h,
                                                              context,
                                                              text:
                                                                  "You sure want to delete this package record!",
                                                              textFw: FontWeight
                                                                  .bold,
                                                              yesAction: () {
                                                        packageController
                                                            .packageDeleteAction(
                                                                packageModel,
                                                                context);
                                                      }, noAction: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 18.sp,
                                                      color: ColorConstant
                                                          .whiteColor,
                                                    ),
                                                    height: 50.h,
                                                    width: 40.w,
                                                    buttonColor:
                                                        ColorConstant.redColor,
                                                  ),
                                                )
                                              ],
                                            )
                                            // _buildTableCellImage(employeeDetailModel.image.toString()),
                                          ],
                                        );
                                },
                                query: FirebasePackageServices.getPackages(
                                    packageController.userUid ?? ""),
                                itemBuilderType: PaginateBuilderType.listView,
                                isLive: true,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                onEmpty: Center(
                                  child: CustomEmptyScreenMessage(
                                    icon: Icon(
                                      Icons.all_inbox, // Package-related icon
                                      size: 60.sp,
                                      color: ColorConstant.greyColor,
                                    ),
                                    headText: "No Packages Available",
                                    subtext:
                                        "You haven’t added any packages yet.\nStart offering value by creating your first package.",
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        SizedBox(
                          height: mq.height * 0.07,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
