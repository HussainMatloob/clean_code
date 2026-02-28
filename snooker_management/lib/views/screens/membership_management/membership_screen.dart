import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/controller/member_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/membership_management/add_and_update_member_dialog.dart';
import 'package:snooker_management/views/screens/membership_management/member_table_row.dart';
import 'package:snooker_management/views/screens/membership_management/member_table_view.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class MembershipScreen extends StatefulWidget {
  final String? snookerLogo;
  const MembershipScreen({super.key, this.snookerLogo});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  MemberController memberController = Get.put(MemberController());
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      memberController.calculateTotalMembers();
      memberController.calculateActivatedMembers();
      memberController.calculateDactivatedMembers();
      memberController.clearPackagesNameList();
      memberController.getPackagesName(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<MemberController>(
      init: MemberController(),
      builder: (memberController) {
        final children = [
          Row(
            children: [
              CustomText(
                "Total Members:${memberController.calculatedTotalMembers.toString()}",
                fw: FontWeight.w400,
                size: 10.sp,
                color: ColorConstant.blueColor,
              ),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                "Activated Members:${memberController.calculatedActivatedMembers.toString()}",
                fw: FontWeight.w400,
                size: 10.sp,
                color: ColorConstant.primaryColor,
              ),
              SizedBox(
                width: 10.w,
              ),
              CustomText(
                "Expire Members:${memberController.calculatedDActivatedMembers.toString()}",
                fw: FontWeight.w400,
                size: 10.sp,
                color: ColorConstant.dullRedColor,
              ),
            ],
          ),
          Visibility(
              visible: ResponsiveHelper.isMobile(context),
              child: SizedBox(
                height: mq.width * 0.02,
              )),
          Row(
            children: [
              CustomTextFormField(
                controller: memberController.searchController,
                width: 200.w,
                height: mq.height * 0.04,
                horizontalPadding: 10.w,
                labelText: "Search by contact or NIC",
                hintTextSize: 12.sp,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              memberController.isMemberSearching
                  ? SizedBox(
                      height: ResponsiveHelper.isMobile(context) ? 20.h : 30.h,
                      width: ResponsiveHelper.isMobile(context) ? 20.w : 30.w,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: ColorConstant.blueColor),
                    )
                  : CustomButtonWidget(
                      radius: 5.r,
                      height: mq.height * 0.04,
                      paddingHorizontal: 8.w,
                      buttonColor: ColorConstant.blueColor,
                      text: "Search",
                      textSize: 10.sp,
                      tabAction: () async {
                        if (memberController.searchController.text
                            .toString()
                            .isNotEmpty) {
                          memberController.memberSearchingProgress(true);
                          memberController.searchMember(context);
                        }
                      },
                    ),
              SizedBox(
                width: 10.w,
              ),
              Visibility(
                visible: !ResponsiveHelper.isMobile(context) &&
                    !ResponsiveHelper.isTablet(context),
                child: CustomButtonWidget(
                  radius: 5.r,
                  height: mq.height * 0.04,
                  paddingHorizontal: 8.w,
                  buttonColor: ColorConstant.blueColor,
                  sizedBoxWidth: 4.w,
                  text: "Clear",
                  textSize: 10.sp,
                  tabAction: () {
                    memberController.setNullSelectedReportOption();
                    memberController.setMemberAndBillingNull();
                    memberController.searchController.clear();
                  },
                ),
              ),
            ],
          ),
        ];
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
                                memberController.clearFieldsAndSelections();
                                AddAndUpdateMemberDialog.showCustomDialog(
                                  isDataAddAble: true,
                                  context,
                                );
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
                        Visibility(
                          visible: ResponsiveHelper.isMobile(context),
                          child: SizedBox(
                            height: mq.height * 0.02,
                          ),
                        ),
                        Visibility(
                          visible: ResponsiveHelper.isMobile(context),
                          child: Row(
                            children: [
                              CustomButtonWidget(
                                sizedBoxWidth: 10.w,
                                tabAction: () async {
                                  memberController.resetPdfCurrentPage();
                                  memberController.generateMembersPdf(context);
                                },
                                buttonColor: ColorConstant.blueColor,
                                height: mq.height * 0.04,
                                paddingHorizontal: 15.w,
                                textSize: 12.sp,
                                textFw: FontWeight.w400,
                                textColor: ColorConstant.whiteColor,
                                text: "Export to pdf",
                                radius: 5.r,
                                icon: Icon(
                                  size: 12.sp,
                                  Icons.picture_as_pdf,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     CustomButtonWidget(
                        //       sizedBoxWidth: 10.w,
                        //       tabAction: () async {
                        //         memberController.clearMembersNameList();
                        //         memberController.getMembersName(context);
                        //         memberController.setNullSelectedReportOption();
                        //         Get.to(() => const MembersBillingDetail());
                        //         memberController.billDateController.clear();
                        //         memberController.setMemberAndBillingNull();
                        //         memberController.clearSelectedDropDownValue();
                        //       },
                        //       buttonColor: ColorConstant.blueColor,
                        //       height: mq.height * 0.04,
                        //       paddingHorizontal: 15.w,
                        //       textSize: 12.sp,
                        //       textFw: FontWeight.w400,
                        //       textColor: ColorConstant.whiteColor,
                        //       text: "Billing Details",
                        //       radius: 5.r,
                        //       icon: Icon(
                        //         size: 12.sp,
                        //         Icons.currency_exchange,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: mq.height * 0.02,
                        // ),
                        Row(
                          mainAxisAlignment: ResponsiveHelper.isMobile(context)
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: ColorConstant.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(50.r)),
                                  child: Row(
                                    children: [
                                      CustomButtonWidget(
                                        tabAction: () {
                                          memberController
                                              .selectMemberReportOption(
                                                  "Activated Members");
                                        },
                                        buttonColor: memberController
                                                    .selectedMemberReportOption ==
                                                "Activated Members"
                                            ? ColorConstant.blueColor
                                            : Colors.transparent,
                                        height: mq.height * 0.04,
                                        radius: 50.r,
                                        paddingHorizontal: 15.w,
                                        textSize: 12.sp,
                                        textFw: FontWeight.w400,
                                        text: "Activated Members",
                                      ),
                                      CustomButtonWidget(
                                        tabAction: () {
                                          memberController
                                              .selectMemberReportOption(
                                                  "Expire Members");
                                        },
                                        buttonColor: memberController
                                                    .selectedMemberReportOption ==
                                                "Expire Members"
                                            ? ColorConstant.blueColor
                                            : Colors.transparent,
                                        height: mq.height * 0.04,
                                        radius: 50.r,
                                        paddingHorizontal: 15.w,
                                        textSize: 12.sp,
                                        textFw: FontWeight.w400,
                                        text: "Expire Members",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: !ResponsiveHelper.isMobile(context),
                              child: SizedBox(
                                width: 10.w,
                              ),
                            ),
                            Visibility(
                              visible: !ResponsiveHelper.isMobile(context),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  CustomButtonWidget(
                                    sizedBoxWidth: 10.w,
                                    tabAction: () async {
                                      memberController.resetPdfCurrentPage();
                                      memberController
                                          .generateMembersPdf(context);
                                    },
                                    buttonColor: ColorConstant.blueColor,
                                    height: mq.height * 0.04,
                                    paddingHorizontal: 15.w,
                                    textSize: 12.sp,
                                    textFw: FontWeight.w400,
                                    textColor: ColorConstant.whiteColor,
                                    text: "Export to pdf",
                                    radius: 5.r,
                                    icon: Icon(
                                      size: 12.sp,
                                      Icons.picture_as_pdf,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: children,
                          ),
                        ),
                        Visibility(
                          visible: ResponsiveHelper.isMobile(context),
                          child: Column(
                            children: children,
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context) &&
                              !ResponsiveHelper.isTablet(context),
                          child: MemberTableRow(
                            cells: [
                              CustomTableCell(
                                text: "Name",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Contact",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Address",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "NIC",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "S_Date",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "E_Date",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Package",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Image",
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
                        const MemberTableView(),
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
