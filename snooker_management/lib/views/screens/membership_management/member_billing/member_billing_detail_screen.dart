import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/member_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/views/screens/membership_management/member_billing/billing_table_row.dart';
import 'package:snooker_management/views/screens/membership_management/member_billing/billing_table_view.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class MembersBillingDetail extends StatefulWidget {
  const MembersBillingDetail({super.key});
  @override
  State<MembersBillingDetail> createState() => _MembersBillingDetailState();
}

class _MembersBillingDetailState extends State<MembersBillingDetail> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: ColorConstant.secondaryColor,
      appBar: AppBar(
        title: CustomText("Members billing detail"),
      ),
      body: GetBuilder<MemberController>(
        init: MemberController(),
        builder: (memberController) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: ColorConstant.primaryColor,
                                  borderRadius: BorderRadius.circular(50.r)),
                              child: Row(
                                children: [
                                  CustomButtonWidget(
                                    tabAction: () {
                                      memberController
                                          .selectBillingReportOption("Weekly");
                                    },
                                    buttonColor: memberController
                                                .selectedBillingReportOption ==
                                            "Weekly"
                                        ? ColorConstant.blueColor
                                        : Colors.transparent,
                                    height: mq.height * 0.05,
                                    radius: 50.r,
                                    width: 150.w,
                                    textSize: 14.sp,
                                    textFw: FontWeight.w400,
                                    text: "Weekly",
                                  ),
                                  CustomButtonWidget(
                                    tabAction: () {
                                      memberController
                                          .selectBillingReportOption("Monthly");
                                    },
                                    buttonColor: memberController
                                                .selectedBillingReportOption ==
                                            "Monthly"
                                        ? ColorConstant.blueColor
                                        : Colors.transparent,
                                    height: mq.height * 0.05,
                                    radius: 50.r,
                                    width: 150.w,
                                    textSize: 14.sp,
                                    textFw: FontWeight.w400,
                                    text: "Monthly",
                                  ),
                                  CustomButtonWidget(
                                    tabAction: () {
                                      memberController
                                          .selectBillingReportOption("Yearly");
                                    },
                                    buttonColor: memberController
                                                .selectedBillingReportOption ==
                                            "Yearly"
                                        ? ColorConstant.blueColor
                                        : Colors.transparent,
                                    height: mq.height * 0.05,
                                    radius: 50.r,
                                    width: 150.w,
                                    textSize: 14.sp,
                                    textFw: FontWeight.w400,
                                    text: "Yearly",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            CustomButtonWidget(
                              sizedBoxWidth: 10.w,
                              tabAction: () async {
                                memberController
                                    .generateMembersBillPdf(context);
                              },
                              buttonColor: ColorConstant.blueColor,
                              height: mq.height * 0.05,
                              paddingHorizontal: 15.w,
                              textSize: 14.sp,
                              textFw: FontWeight.w400,
                              textColor: ColorConstant.whiteColor,
                              text: "Export to pdf",
                              radius: 5.r,
                              icon: Icon(
                                size: 20.sp,
                                Icons.details_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomTextFormField(
                              width: 200.w,
                              height: mq.height * 0.04,
                              controller: memberController.billDateController,
                              horizontalPadding: 10.w,
                              labelText: "Date",
                              icon: Icon(
                                Icons.event,
                                color: ColorConstant.hintTextColor,
                              ),
                              suffixTapAction: () {
                                memberController.selectDate(context,
                                    memberController.billDateController);
                              },
                              onTap: () {
                                memberController.selectDate(context,
                                    memberController.billDateController);
                              },
                              hintTextSize: 12.sp,
                            ),
                            SizedBox(
                              width: mq.height * 0.03,
                            ),
                            CustomDropDownButton(
                              width: 200.w,
                              height: mq.height * 0.04,
                              dropDownButtonList:
                                  memberController.membersNameList,
                              text: 'Search & generate report',
                              textColor: ColorConstant.hintTextColor,
                              textSize: 12.sp,
                              textFw: FontWeight.w400,
                              dropDownListTextSize: 12.sp,
                              isShowingCustomNames: true,
                              controller: memberController,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            memberController.isMemberBillSearching
                                ? Container(
                                    padding: EdgeInsets.all(3.r),
                                    height: 35.h,
                                    width: 35.w,
                                    child: CircularProgressIndicator(
                                      color: ColorConstant.blueColor,
                                    ))
                                : CustomButtonWidget(
                                    radius: 5.r,
                                    height: mq.height * 0.04,
                                    paddingHorizontal: 6.w,
                                    buttonColor: ColorConstant.blueColor,
                                    text: "Search",
                                    textSize: 12.sp,
                                    tabAction: () async {
                                      if (memberController.selectedCustomName !=
                                              null &&
                                          memberController
                                              .billDateController.text
                                              .toString()
                                              .isNotEmpty) {
                                        memberController
                                            .memberBillSearchingProgress(true);
                                        memberController
                                            .searchMemberBill(context);
                                      }
                                    },
                                  ),
                            SizedBox(
                              width: 10.w,
                            ),
                            CustomButtonWidget(
                              radius: 5.r,
                              height: mq.height * 0.04,
                              paddingHorizontal: 6.w,
                              buttonColor: ColorConstant.blueColor,
                              sizedBoxWidth: 4.w,
                              text: "Refresh",
                              textSize: 12.sp,
                              tabAction: () {
                                memberController.setNullSelectedReportOption();
                                memberController.setMemberAndBillingNull();
                                memberController.clearSelectedDropDownValue();
                                memberController.billDateController.clear();
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: ColorConstant.whiteColor,
                                size: 15.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        BillingTableRow(
                          cells: [
                            CustomTableCell(
                              text: "Member Name",
                              textColor: ColorConstant.primaryColor,
                              textFw: FontWeight.bold,
                            ),
                            CustomTableCell(
                              text: "Package Name",
                              textColor: ColorConstant.primaryColor,
                              textFw: FontWeight.bold,
                            ),
                            CustomTableCell(
                              text: "Duration",
                              textColor: ColorConstant.primaryColor,
                              textFw: FontWeight.bold,
                            ),
                            CustomTableCell(
                              text: "Amount",
                              textColor: ColorConstant.primaryColor,
                              textFw: FontWeight.bold,
                            ),
                            CustomTableCell(
                              text: "Payment Method",
                              textColor: ColorConstant.primaryColor,
                              textFw: FontWeight.bold,
                            ),
                            CustomTableCell(
                              text: "Billing Date",
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
                        const BillingTableView(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
