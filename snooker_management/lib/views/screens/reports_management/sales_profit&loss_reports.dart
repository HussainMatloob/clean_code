import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/constants/data_constant.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/controller/reports_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/reports_management/report_graphs_screen.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class SalesProfitAndLossReports extends StatefulWidget {
  const SalesProfitAndLossReports({super.key});
  @override
  State<SalesProfitAndLossReports> createState() =>
      _SalesProfitAndLossReportsState();
}

class _SalesProfitAndLossReportsState extends State<SalesProfitAndLossReports> {
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  ReportsController reportsController = Get.put(ReportsController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportsController.resetAllSelections(true);
    reportsController.getToDayTablesSale();
    reportsController.getTodayExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsController>(
      init: ReportsController(),
      builder: (reportsController) {
        final subchildren = [
          Container(
            color: ColorConstant.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButtonWidget(
                  tabAction: () {
                    reportsController.selectReportMethod("Daily");
                  },
                  buttonColor: reportsController.selectedReportMethod == "Daily"
                      ? ColorConstant.blueColor
                      : Colors.transparent,
                  height: mq.height * 0.04,
                  paddingHorizontal: 10.w,
                  textSize: 12.sp,
                  radius: 0.r,
                  textFw: FontWeight.w400,
                  text: "Daily",
                ),
                SizedBox(
                  width: 10.w,
                ),
                CustomButtonWidget(
                  radius: 0.r,
                  tabAction: () {
                    reportsController.selectReportMethod("Weekly");
                  },
                  buttonColor:
                      reportsController.selectedReportMethod == "Weekly"
                          ? ColorConstant.blueColor
                          : Colors.transparent,
                  height: mq.height * 0.04,
                  paddingHorizontal: 10.w,
                  textSize: 12.sp,
                  textFw: FontWeight.w400,
                  text: "Weekly",
                ),
                SizedBox(
                  width: 10.w,
                ),
                CustomButtonWidget(
                  radius: 0.r,
                  tabAction: () {
                    reportsController.selectReportMethod("Monthly");
                  },
                  buttonColor:
                      reportsController.selectedReportMethod == "Monthly"
                          ? ColorConstant.blueColor
                          : Colors.transparent,
                  height: mq.height * 0.04,
                  paddingHorizontal: 10.w,
                  textSize: 12.sp,
                  textFw: FontWeight.w400,
                  text: "Monthly",
                ),
                SizedBox(
                  width: 10.w,
                ),
                CustomButtonWidget(
                  radius: 0.r,
                  tabAction: () {
                    reportsController.selectReportMethod("Yearly");
                  },
                  buttonColor:
                      reportsController.selectedReportMethod == "Yearly"
                          ? ColorConstant.blueColor
                          : Colors.transparent,
                  height: mq.height * 0.04,
                  paddingHorizontal: 10.w,
                  textSize: 12.sp,
                  textFw: FontWeight.w400,
                  text: "Yearly",
                ),
              ],
            ),
          ),
          ResponsiveHelper.isMobile(context)
              ? SizedBox(
                  height: 10.h,
                )
              : SizedBox(
                  width: 10.w,
                ),
          Row(
            children: [
              CustomButtonWidget(
                tabAction: () {
                  reportsController.getTotalOfSalesAndExpenses(context);
                },
                buttonColor: ColorConstant.blueColor,
                height: mq.height * 0.04,
                paddingHorizontal: 15.w,
                textSize: 12.sp,
                textFw: FontWeight.w400,
                text: "Generate",
              ),
            ],
          ),
          ResponsiveHelper.isMobile(context)
              ? SizedBox(
                  height: 10.h,
                )
              : SizedBox(
                  width: 10.w,
                ),
          Row(
            children: [
              CustomButtonWidget(
                tabAction: () {
                  reportsController.resetAllSelections(false);
                },
                buttonColor: ColorConstant.blueColor,
                height: mq.height * 0.04,
                paddingHorizontal: 15.w,
                textSize: 12.sp,
                textFw: FontWeight.w400,
                text: "Clear",
              ),
            ],
          )
        ];

        final children = [
          CustomDropDownButton(
            isShowingCustomNames: true,
            width: 200.w,
            height: mq.height * 0.043,
            dropDownButtonList: DataConstant.reportMethods,
            text: 'Select Method',
            textColor: ColorConstant.hintTextColor,
            textSize: 12.sp,
            textFw: FontWeight.w400,
            dropDownListTextSize: 12.sp,
            controller: reportsController,
          ),
          ResponsiveHelper.isTablet(context) ||
                  ResponsiveHelper.isMobile(context)
              ? SizedBox(
                  height: 15.h,
                )
              : SizedBox(
                  width: 10.w,
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveHelper.isMobile(context)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: subchildren,
                    )
                  : Row(
                      children: subchildren,
                    ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.all(10.sp),
                width: 200.w,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: ColorConstant.hintTextColor!)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Rs.",
                      size: 18.sp,
                      fw: FontWeight.w700,
                      color: ColorConstant.blackColor,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      "${reportsController.totalOfSalesAndExpenses}",
                      size: 18.sp,
                      fw: FontWeight.w700,
                      color: ColorConstant.blackColor,
                    )
                  ],
                ),
              )
            ],
          )
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
              SizedBox(
                height: 20.w,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 30.w,
                  ),
                  CustomText(
                    "Cash Flow",
                    color: ColorConstant.blackColor,
                    size: 20.sp,
                    fw: FontWeight.w700,
                  )
                ],
              ),
              Container(
                color: ColorConstant.hintTextColor,
                height: 2.h,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          padding: EdgeInsets.all(40.r),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormField(
                                width: 200.w,
                                height: mq.height * 0.05,
                                controller: reportsController.dateController,
                                horizontalPadding: 10.w,
                                labelText: "dd-MM-yyyy",
                                icon: Icon(
                                  Icons.event,
                                  color: ColorConstant.hintTextColor,
                                ),
                                suffixTapAction: () {
                                  reportsController.selectDate(context,
                                      reportsController.dateController);
                                },
                                onTap: () {
                                  reportsController.selectDate(context,
                                      reportsController.dateController);
                                },
                                hintTextSize: 15.sp,
                              ),
                              SizedBox(
                                height: 10.w,
                              ),
                              Visibility(
                                visible: ResponsiveHelper.isMobile(context) ||
                                    ResponsiveHelper.isTablet(context),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: children),
                              ),
                              Visibility(
                                visible: ResponsiveHelper.isDesktop(context),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: children),
                              ),
                              SizedBox(
                                height: 40.sp,
                              ),
                              CustomText(
                                "Today Tables Sale:${reportsController.toDayTablesSale}",
                                fw: FontWeight.w700,
                                size: 12.sp,
                                color: ColorConstant.blackColor,
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              CustomText(
                                "Today Expenses:${reportsController.toDayExpenses}",
                                fw: FontWeight.w700,
                                size: 12.sp,
                                color: ColorConstant.blackColor,
                              ),
                              SizedBox(
                                height: 50.h,
                              ),
                              const ReportGraphsScreen()
                            ],
                          ),
                        ),
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
