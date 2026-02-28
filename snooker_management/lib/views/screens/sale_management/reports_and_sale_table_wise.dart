import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/sale_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class ReportsAndSaleTableWise extends StatefulWidget {
  final String? snookerLogo;
  const ReportsAndSaleTableWise({super.key, this.snookerLogo});
  @override
  State<ReportsAndSaleTableWise> createState() =>
      _ReportsAndSaleTableWiseState();
}

class _ReportsAndSaleTableWiseState extends State<ReportsAndSaleTableWise> {
  SaleController saleController = Get.put(SaleController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saleController.clearSelectedDropDownValue();
      saleController.clearTablesNumberList();
      saleController.getTablesNumber();
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<SaleController>(
      init: SaleController(),
      builder: (saleController) {
        final children = [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ColorConstant.primaryColor,
                    borderRadius: BorderRadius.circular(50.r)),
                child: Row(
                  children: [
                    CustomButtonWidget(
                      tabAction: () {
                        saleController.selectSaleReportOption("Daily");
                      },
                      buttonColor:
                          saleController.selectedSaleReportOption == "Daily"
                              ? ColorConstant.blueColor
                              : Colors.transparent,
                      height: mq.height * 0.04,
                      radius: 50.r,
                      paddingHorizontal: 15,
                      textSize: 12.sp,
                      textFw: FontWeight.w400,
                      text: "Daily",
                    ),
                    CustomButtonWidget(
                      tabAction: () {
                        saleController.selectSaleReportOption("Weekly");
                      },
                      buttonColor:
                          saleController.selectedSaleReportOption == "Weekly"
                              ? ColorConstant.blueColor
                              : Colors.transparent,
                      height: mq.height * 0.04,
                      radius: 50.r,
                      paddingHorizontal: 15,
                      textSize: 12.sp,
                      textFw: FontWeight.w400,
                      text: "Weekly",
                    ),
                    CustomButtonWidget(
                      tabAction: () {
                        saleController.selectSaleReportOption("Monthly");
                      },
                      buttonColor:
                          saleController.selectedSaleReportOption == "Monthly"
                              ? ColorConstant.blueColor
                              : Colors.transparent,
                      height: mq.height * 0.04,
                      radius: 50.r,
                      paddingHorizontal: 15,
                      textSize: 12.sp,
                      textFw: FontWeight.w400,
                      text: "Monthly",
                    ),
                    CustomButtonWidget(
                      tabAction: () {
                        saleController.selectSaleReportOption("Yearly");
                      },
                      buttonColor:
                          saleController.selectedSaleReportOption == "Yearly"
                              ? ColorConstant.blueColor
                              : Colors.transparent,
                      height: mq.height * 0.04,
                      radius: 50.r,
                      paddingHorizontal: 15,
                      textSize: 12.sp,
                      textFw: FontWeight.w400,
                      text: "Yearly",
                    ),
                  ],
                ),
              ),
            ],
          ),
          ResponsiveHelper.isMobile(context)
              ? SizedBox(
                  height: 15.w,
                )
              : SizedBox(
                  width: 20.w,
                ),
          Row(
            children: [
              CustomButtonWidget(
                sizedBoxWidth: 10.w,
                tabAction: () async {
                  saleController.generateSalesReports(context);
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
                  Icons.details_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          ResponsiveHelper.isMobile(context)
              ? SizedBox(
                  height: 15.w,
                )
              : SizedBox(
                  width: 20.w,
                ),
          Visibility(
            visible: !ResponsiveHelper.isMobile(context),
            child: Row(
              children: [
                CustomButtonWidget(
                  radius: 5.r,
                  height: mq.height * 0.04,
                  paddingHorizontal: 8.w,
                  buttonColor: ColorConstant.blueColor,
                  sizedBoxWidth: 4.w,
                  text: "Clear",
                  textSize: 12.sp,
                  tabAction: () {
                    saleController.clearSelectedDropDownValue();
                  },
                ),
              ],
            ),
          )
        ];
        return Scaffold(
          backgroundColor: ColorConstant.secondaryColor,
          body: Form(
            key: saleController.fieldsKey,
            child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: ColorConstant.linearGradian),
                ),
                child: Center(
                  child: Column(
                    children: [
                      ResponsiveHelper.isMobile(context)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: children)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children),
                      SizedBox(
                        height: 20.h,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: ColorConstant.hintTextColor!)),
                            margin: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.isMobile(context)
                                    ? 20.r
                                    : 200.w),
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ResponsiveHelper.isMobile(context)
                                    ? Column(children: [
                                        CustomDropDownButton(
                                            dropDownButtonList:
                                                saleController.tablesNumberList,
                                            text:
                                                'Select Table & Generate Report',
                                            textColor:
                                                ColorConstant.hintTextColor,
                                            textSize: 14.sp,
                                            textFw: FontWeight.w400,
                                            dropDownListTextSize: 14.sp,
                                            controller: saleController,
                                            isMonthsOrTables: true,
                                            isTableNumber: true),
                                        SizedBox(
                                          height: 10.w,
                                        ),
                                        CustomDropDownButton(
                                          dropDownButtonList:
                                              saleController.losersNameList,
                                          text: 'Select Loser Name',
                                          textColor:
                                              ColorConstant.hintTextColor,
                                          textSize: 14.sp,
                                          textFw: FontWeight.w400,
                                          dropDownListTextSize: 14.sp,
                                          controller: saleController,
                                          isShowingCustomNames: true,
                                        ),
                                      ])
                                    : Row(children: [
                                        Expanded(
                                          child: CustomDropDownButton(
                                              dropDownButtonList: saleController
                                                  .tablesNumberList,
                                              text:
                                                  'Select Table & Generate Report',
                                              textColor:
                                                  ColorConstant.hintTextColor,
                                              textSize: 14.sp,
                                              textFw: FontWeight.w400,
                                              dropDownListTextSize: 14.sp,
                                              controller: saleController,
                                              isMonthsOrTables: true,
                                              isTableNumber: true),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Expanded(
                                          child: CustomDropDownButton(
                                            dropDownButtonList:
                                                saleController.losersNameList,
                                            text: 'Select Loser Name',
                                            textColor:
                                                ColorConstant.hintTextColor,
                                            textSize: 14.sp,
                                            textFw: FontWeight.w400,
                                            dropDownListTextSize: 14.sp,
                                            controller: saleController,
                                            isShowingCustomNames: true,
                                          ),
                                        ),
                                      ]),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Table Number:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    CustomText(
                                      saleController
                                              .selectedLoserData?.tableNumber ??
                                          "",
                                      size: 12.sp,
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Table Price:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    CustomText(
                                      saleController
                                              .selectedLoserData?.tablePrice ??
                                          "",
                                      size: 12.sp,
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Loser name:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    CustomText(
                                      saleController
                                              .selectedLoserData?.looserName ??
                                          "",
                                      size: 12.sp,
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Lose Games:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    CustomText(
                                      saleController
                                              .selectedLoserData?.loosGames
                                              .toString() ??
                                          "",
                                      size: 12.sp,
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "You will be Pay:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    CustomText(
                                      saleController
                                              .selectedLoserData?.payAmount
                                              .toString() ??
                                          "",
                                      size: 12.sp,
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Game Type:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    CustomText(
                                      saleController
                                              .selectedLoserData?.gameType ??
                                          "",
                                      size: 12.sp,
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Start Time:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    CustomText(
                                      saleController
                                              .selectedLoserData?.startTime ??
                                          "",
                                      size: 12.sp,
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "End Time:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    CustomText(
                                      saleController
                                              .selectedLoserData?.endTime ??
                                          "",
                                      size: 12.sp,
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Total Time:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    CustomText(
                                      saleController
                                              .selectedLoserData?.totalTime ??
                                          "",
                                      size: 12.sp,
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      "Date:",
                                      size: 12.sp,
                                      fw: FontWeight.w400,
                                      color: ColorConstant.blackColor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    saleController.selectedLoserData != null
                                        ? CustomText(
                                            saleController.formatDate(
                                                saleController
                                                    .selectedLoserData!.date!),
                                            size: 12.sp,
                                            fw: FontWeight.w700,
                                            color: ColorConstant.blackColor,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextFormField(
                                  controller:
                                      saleController.saleAmountController,
                                  horizontalPadding: 10.w,
                                  labelText: "Sale Amount",
                                  validateFunction:
                                      saleController.saleAmountValidate,
                                  textInputAction: TextInputAction.next,
                                  hintTextSize: 14.sp,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      ResponsiveHelper.isMobile(context)
                                          ? MainAxisAlignment.center
                                          : MainAxisAlignment.end,
                                  children: [
                                    CustomButtonWidget(
                                      tabAction: () {
                                        if (saleController
                                            .fieldsKey.currentState!
                                            .validate()) {
                                          saleController.addLoserSale(context);
                                        }
                                      },
                                      buttonColor: ColorConstant.primaryColor,
                                      height: 50.h,
                                      width: 90.w,
                                      textSize: 12.sp,
                                      textFw: FontWeight.w400,
                                      textColor: ColorConstant.whiteColor,
                                      text: "Add",
                                      radius: 5.r,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
