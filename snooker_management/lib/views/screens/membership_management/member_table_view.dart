import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/member_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/member_model.dart';
import 'package:snooker_management/services/membership_services.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/membership_management/add_and_update_member_dialog.dart';
import 'package:snooker_management/views/screens/membership_management/member_table_row.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_empty_screen_message.dart';
import 'package:snooker_management/views/widgets/custom_image_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class MemberTableView extends StatefulWidget {
  const MemberTableView({super.key});

  @override
  State<MemberTableView> createState() => _MemberTableViewState();
}

class _MemberTableViewState extends State<MemberTableView> {
  MemberController memberController = Get.put(MemberController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memberController.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<MemberController>(
      init: MemberController(),
      builder: (memberController) {
        return memberController.userUid == null
            ? const SizedBox()
            : memberController.searchedMember == null
                ? PaginateFirestore(
                    shrinkWrap: true,
                    itemBuilder: (context, documentSnapshot, index) {
                      MemberModel memberModel = MemberModel.fromJson(
                          documentSnapshot[index].data()
                              as Map<String, dynamic>);

                      return ResponsiveHelper.isMobile(context) ||
                              ResponsiveHelper.isTablet(context)
                          ? GestureDetector(
                              onTap: () {
                                memberController.pickImage(null);
                                memberController.memberNameController.text =
                                    memberModel.memberName!;
                                memberController.memberContactController.text =
                                    memberModel.memberContact!;
                                memberController.memberAddressController.text =
                                    memberModel.memberAddress!;
                                memberController.memberNICController.text =
                                    memberModel.memberNic!;
                                memberController.discountController.text =
                                    memberModel.discount.toString();
                                memberController
                                    .setBlockStatus(memberModel.blockStatus!);
                                memberController.setSelectedPackage(
                                    memberModel.packageName!);
                                memberController.startDateController.text =
                                    memberController
                                        .formatDate(memberModel.startDate!);
                                memberController.endDateController.text =
                                    memberController
                                        .formatDate(memberModel.endDate!);
                                memberController.packagePrice.text =
                                    memberModel.packagePrice!;
                                memberController.packageDuration.text =
                                    memberModel.packageDuration!;

                                AddAndUpdateMemberDialog.showCustomDialog(
                                    isDataAddAble: false,
                                    context,
                                    id: memberModel.id,
                                    memberImage: memberModel.image,
                                    memberName: memberModel.memberName);
                              },
                              child: Container(
                                width: mq.width,
                                margin: EdgeInsets.only(bottom: 15.h),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                    color: ColorConstant.greenLightColor,
                                    borderRadius: BorderRadius.circular(5.r)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          memberModel.memberName ?? "",
                                          fw: FontWeight.w700,
                                          size: 14.sp,
                                          color: ColorConstant.blackColor,
                                        ),
                                        CustomText(
                                          memberController.formatDate(
                                              memberModel.startDate!),
                                          fw: FontWeight.w400,
                                          size: 11.sp,
                                          color: ColorConstant.blackColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            memberModel.memberAddress ?? "",
                                            fw: FontWeight.w400,
                                            size: 11.sp,
                                            color: ColorConstant.blackColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        CustomText(
                                          memberModel.memberContact ?? "",
                                          fw: FontWeight.w400,
                                          size: 11.sp,
                                          color: ColorConstant.blackColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(
                                          memberModel.packageName,
                                          fw: FontWeight.w400,
                                          size: 11.sp,
                                          color: ColorConstant.blackColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomButtonWidget(
                                          radius: 5.r,
                                          height: mq.height * 0.03,
                                          paddingHorizontal: 8.w,
                                          buttonColor: ColorConstant.redColor,
                                          textColor: ColorConstant.whiteColor,
                                          text: "Delete",
                                          textSize: 10.sp,
                                          tabAction: () async {
                                            CustomAlertDialog.CustomDialog(
                                                containerHeight: 300.h,
                                                containerWidth: 100.w,
                                                height: 30.h,
                                                context,
                                                text:
                                                    "You sure want to delete this member record!",
                                                textFw: FontWeight.bold,
                                                yesAction: () {
                                              memberController
                                                  .memberDeleteAction(
                                                      memberModel, context);
                                            }, noAction: () {
                                              Navigator.of(context).pop();
                                              memberController.pickImage(null);
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                          : MemberTableRow(
                              cells: [
                                CustomTableCell(
                                  text: memberModel.memberName,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: memberModel.memberContact,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: memberModel.memberAddress,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: memberModel.memberNic,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: memberController
                                      .formatDate(memberModel.startDate!),
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: memberController
                                      .formatDate(memberModel.endDate!),
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: memberModel.packageName,
                                  padding: 8.r,
                                ),

                                CustomImageWidget(
                                  color: ColorConstant.greyLightColor,
                                  image: memberModel.image.toString(),
                                  height: 150.h,
                                  width: 30.w,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: CustomButtonWidget(
                                        tabAction: () {
                                          memberController.pickImage(null);
                                          memberController.memberNameController
                                              .text = memberModel.memberName!;
                                          memberController
                                                  .memberContactController
                                                  .text =
                                              memberModel.memberContact!;
                                          memberController
                                                  .memberAddressController
                                                  .text =
                                              memberModel.memberAddress!;
                                          memberController.memberNICController
                                              .text = memberModel.memberNic!;
                                          memberController
                                                  .discountController.text =
                                              memberModel.discount.toString();
                                          memberController.setBlockStatus(
                                              memberModel.blockStatus!);
                                          memberController.setSelectedPackage(
                                              memberModel.packageName!);
                                          memberController
                                                  .startDateController.text =
                                              memberController.formatDate(
                                                  memberModel.startDate!);
                                          memberController
                                                  .endDateController.text =
                                              memberController.formatDate(
                                                  memberModel.endDate!);
                                          memberController.packagePrice.text =
                                              memberModel.packagePrice!;
                                          memberController
                                                  .packageDuration.text =
                                              memberModel.packageDuration!;

                                          AddAndUpdateMemberDialog
                                              .showCustomDialog(
                                                  isDataAddAble: false,
                                                  context,
                                                  id: memberModel.id,
                                                  memberImage:
                                                      memberModel.image,
                                                  memberName:
                                                      memberModel.memberName);
                                        },
                                        icon: Icon(
                                          Icons.update,
                                          color: ColorConstant.whiteColor,
                                          size: 18.sp,
                                        ),
                                        height: 50.h,
                                        width: 40.w,
                                        buttonColor: ColorConstant.blueColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    // CustomButtonWidget(
                                    //   tabAction: () {
                                    //     memberController
                                    //         .setBillingData(memberModel);
                                    //     memberController
                                    //         .paymentMethodController.text = "Cash";
                                    //     AddMemberBillDialog.showCustomDialog(
                                    //         context,
                                    //         memberModel: memberModel);
                                    //   },
                                    //   icon: Icon(
                                    //     Icons.currency_exchange,
                                    //     color: ColorConstant.whiteColor,
                                    //     size: 18.sp,
                                    //   ),
                                    //   height: 50.h,
                                    //   width: 40.w,
                                    //   buttonColor: ColorConstant.blueColor,
                                    // ),
                                    // SizedBox(
                                    //   width: 5.w,
                                    // ),
                                    FittedBox(
                                      child: CustomButtonWidget(
                                        tabAction: () {
                                          CustomAlertDialog.CustomDialog(
                                              containerHeight: 300.h,
                                              containerWidth: 100.w,
                                              height: 30.h,
                                              context,
                                              text:
                                                  "You sure want to delete this member record!",
                                              textFw: FontWeight.bold,
                                              yesAction: () {
                                            memberController.memberDeleteAction(
                                                memberModel, context);
                                          }, noAction: () {
                                            Navigator.of(context).pop();
                                            memberController.pickImage(null);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: ColorConstant.whiteColor,
                                          size: 18.sp,
                                        ),
                                        height: 50.h,
                                        width: 40.w,
                                        buttonColor: ColorConstant.redColor,
                                      ),
                                    ),
                                  ],
                                ),

                                // _buildTableCellImage(employeeDetailModel.image.toString()),
                              ],
                            );
                    },
                    query: FirebaseMembershipServices.getMembers(
                        memberController.userUid ?? ""),
                    itemBuilderType: PaginateBuilderType.listView,
                    isLive: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    onEmpty: Center(
                      child: CustomEmptyScreenMessage(
                        icon: Icon(
                          Icons.card_membership, // Membership-related icon
                          size: 60.sp,
                          color: ColorConstant.greyColor,
                        ),
                        headText: "No Memberships Found",
                        subtext:
                            "You haven’t added any memberships yet.\nStart managing your memberships by adding one now.",
                      ),
                    ),
                  )
                : ResponsiveHelper.isMobile(context) ||
                        ResponsiveHelper.isTablet(context)
                    ? GestureDetector(
                        onTap: () {
                          memberController.pickImage(null);
                          memberController.memberNameController.text =
                              memberController.searchedMember!.memberName!;
                          memberController.memberContactController.text =
                              memberController.searchedMember!.memberContact!;
                          memberController.memberAddressController.text =
                              memberController.searchedMember!.memberAddress!;
                          memberController.memberNICController.text =
                              memberController.searchedMember!.memberNic!;
                          memberController.discountController.text =
                              memberController.searchedMember!.discount
                                  .toString();
                          memberController.setBlockStatus(
                              memberController.searchedMember!.blockStatus!);
                          memberController.setSelectedPackage(
                              memberController.searchedMember!.packageName!);
                          memberController.startDateController.text =
                              memberController.formatDate(
                                  memberController.searchedMember!.startDate!);
                          memberController.endDateController.text =
                              memberController.formatDate(
                                  memberController.searchedMember!.endDate!);
                          memberController.packagePrice.text =
                              memberController.searchedMember!.packagePrice!;
                          memberController.packageDuration.text =
                              memberController.searchedMember!.packageDuration!;

                          AddAndUpdateMemberDialog.showCustomDialog(
                              isDataAddAble: false,
                              context,
                              id: memberController.searchedMember!.id,
                              memberImage:
                                  memberController.searchedMember!.image,
                              memberName:
                                  memberController.searchedMember!.memberName);
                        },
                        child: Container(
                          width: mq.width,
                          margin: EdgeInsets.only(bottom: 15.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              color: ColorConstant.greenLightColor,
                              borderRadius: BorderRadius.circular(5.r)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      memberController
                                          .setMemberAndBillingNull();
                                      memberController.searchController.clear();
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Icon(
                                          size: 12.sp,
                                          Icons.cancel,
                                          color: ColorConstant.greyColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    memberController
                                            .searchedMember?.memberName ??
                                        "",
                                    fw: FontWeight.w700,
                                    size: 14.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                  CustomText(
                                    memberController.formatDate(memberController
                                        .searchedMember!.startDate!),
                                    fw: FontWeight.w400,
                                    size: 11.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      memberController
                                              .searchedMember?.memberAddress ??
                                          "",
                                      fw: FontWeight.w400,
                                      size: 11.sp,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  CustomText(
                                    memberController
                                            .searchedMember?.memberContact ??
                                        "",
                                    fw: FontWeight.w400,
                                    size: 11.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomText(
                                    memberController
                                            .searchedMember?.packageName ??
                                        "",
                                    fw: FontWeight.w400,
                                    size: 11.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomButtonWidget(
                                    radius: 5.r,
                                    height: mq.height * 0.03,
                                    paddingHorizontal: 8.w,
                                    buttonColor: ColorConstant.redColor,
                                    textColor: ColorConstant.whiteColor,
                                    text: "Delete",
                                    textSize: 10.sp,
                                    tabAction: () async {
                                      CustomAlertDialog.CustomDialog(
                                          containerHeight: 300.h,
                                          containerWidth: 100.w,
                                          height: 30.h,
                                          context,
                                          text:
                                              "You sure want to delete this member record!",
                                          textFw: FontWeight.bold,
                                          yesAction: () {
                                        memberController.memberDeleteAction(
                                            memberController.searchedMember!,
                                            context);
                                      }, noAction: () {
                                        Navigator.of(context).pop();
                                        memberController.pickImage(null);
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ))
                    : MemberTableRow(
                        cells: [
                          CustomTableCell(
                            text: memberController.searchedMember!.memberName,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text:
                                memberController.searchedMember!.memberContact,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text:
                                memberController.searchedMember!.memberAddress,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: memberController.searchedMember!.memberNic,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: memberController.formatDate(
                                memberController.searchedMember!.startDate!),
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: memberController.formatDate(
                                memberController.searchedMember!.endDate!),
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: memberController.searchedMember!.packageName,
                            padding: 8.r,
                          ),

                          CustomImageWidget(
                            color: ColorConstant.greyLightColor,
                            image: memberController.searchedMember!.image
                                .toString(),
                            height: 150.h,
                            width: 30.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: CustomButtonWidget(
                                  tabAction: () {
                                    memberController.pickImage(null);
                                    memberController.memberNameController.text =
                                        memberController
                                            .searchedMember!.memberName!;
                                    memberController
                                            .memberContactController.text =
                                        memberController
                                            .searchedMember!.memberContact!;
                                    memberController
                                            .memberAddressController.text =
                                        memberController
                                            .searchedMember!.memberAddress!;
                                    memberController.memberNICController.text =
                                        memberController
                                            .searchedMember!.memberNic!;
                                    memberController.discountController.text =
                                        memberController
                                            .searchedMember!.discount
                                            .toString();
                                    memberController.setBlockStatus(
                                        memberController
                                            .searchedMember!.blockStatus!);
                                    memberController.setSelectedPackage(
                                        memberController
                                            .searchedMember!.packageName!);
                                    memberController.startDateController.text =
                                        memberController.formatDate(
                                            memberController
                                                .searchedMember!.startDate!);
                                    memberController.endDateController.text =
                                        memberController.formatDate(
                                            memberController
                                                .searchedMember!.endDate!);
                                    memberController.packagePrice.text =
                                        memberController
                                            .searchedMember!.packagePrice!;
                                    memberController.packageDuration.text =
                                        memberController
                                            .searchedMember!.packageDuration!;

                                    AddAndUpdateMemberDialog.showCustomDialog(
                                        isDataAddAble: false,
                                        context,
                                        id: memberController.searchedMember!.id,
                                        memberImage: memberController
                                            .searchedMember!.image,
                                        memberName: memberController
                                            .searchedMember!.memberName);
                                  },
                                  icon: Icon(
                                    Icons.update,
                                    color: ColorConstant.whiteColor,
                                    size: 18.sp,
                                  ),
                                  height: 50.h,
                                  width: 40.w,
                                  buttonColor: ColorConstant.blueColor,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              // CustomButtonWidget(
                              //   tabAction: () {
                              //     memberController.setBillingData(
                              //         memberController.searchedMember!);
                              //     AddMemberBillDialog.showCustomDialog(context,
                              //         memberModel:
                              //             memberController.searchedMember!);
                              //   },
                              //   icon: Icon(
                              //     Icons.currency_exchange,
                              //     color: ColorConstant.whiteColor,
                              //     size: 18.sp,
                              //   ),
                              //   height: 50.h,
                              //   width: 40.w,
                              //   buttonColor: ColorConstant.blueColor,
                              // ),
                              // SizedBox(
                              //   width: 5.w,
                              // ),
                              FittedBox(
                                child: CustomButtonWidget(
                                  tabAction: () {
                                    CustomAlertDialog.CustomDialog(
                                        containerHeight: 300.h,
                                        containerWidth: 100.w,
                                        height: 30.h,
                                        context,
                                        text:
                                            "You sure want to delete this member record!",
                                        textFw: FontWeight.bold, yesAction: () {
                                      memberController.memberDeleteAction(
                                          memberController.searchedMember!,
                                          context);
                                    }, noAction: () {
                                      Navigator.of(context).pop();
                                      memberController.pickImage(null);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: ColorConstant.whiteColor,
                                    size: 18.sp,
                                  ),
                                  height: 50.h,
                                  width: 40.w,
                                  buttonColor: ColorConstant.redColor,
                                ),
                              )
                            ],
                          ),

                          // _buildTableCellImage(employeeDetailModel.image.toString()),
                        ],
                      );
      },
    );
  }
}
