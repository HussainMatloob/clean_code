import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/constants/data_constant.dart';
import 'package:snooker_management/controller/salary_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/views/screens/salary_management/add_and_update_salary_dialog.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class SearchSalaryScreen extends StatefulWidget {
  const SearchSalaryScreen({super.key});

  @override
  State<SearchSalaryScreen> createState() => _SearchSalaryScreenState();
}

class _SearchSalaryScreenState extends State<SearchSalaryScreen> {
  SalaryController? salaryController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      salaryController = Get.isRegistered<SalaryController>()
          ? null
          : Get.put(SalaryController());
      salaryController!.setSearchedSalaryNull();
      salaryController!.clearAllSelections();
      salaryController!.clearEmployeesNameList();
      salaryController!.getExpensesName(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<SalaryController>(
      init: Get.isRegistered<SalaryController>() ? null : SalaryController(),
      builder: (salaryController) {
        return Scaffold(
          backgroundColor: ColorConstant.secondaryColor,
          body: Container(
            width: mq.width,
            padding: EdgeInsets.all(30.r),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: ColorConstant.linearGradian)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomDropDownButton(
                        isMonthsOrTables: true,
                        width: 200.w,
                        height: mq.height * 0.04,
                        dropDownButtonList: DataConstant.monthsName,
                        text: 'Select Month',
                        textColor: ColorConstant.hintTextColor,
                        textSize: 12.sp,
                        textFw: FontWeight.w400,
                        dropDownListTextSize: 12.sp,
                        controller: salaryController,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ColorConstant.primaryColor,
                          borderRadius: BorderRadius.circular(50.r)),
                      child: Row(
                        children: [
                          CustomButtonWidget(
                            tabAction: () {
                              salaryController
                                  .selectSalaryReportOption("Monthly");
                            },
                            buttonColor:
                                salaryController.selectedSalaryReportOption ==
                                        "Monthly"
                                    ? ColorConstant.blueColor
                                    : Colors.transparent,
                            height: mq.height * 0.04,
                            radius: 50.r,
                            paddingHorizontal: 15.w,
                            textSize: 12.sp,
                            textFw: FontWeight.w400,
                            text: "Monthly",
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          CustomButtonWidget(
                            tabAction: () {
                              salaryController
                                  .selectSalaryReportOption("Yearly");
                            },
                            buttonColor:
                                salaryController.selectedSalaryReportOption ==
                                        "Yearly"
                                    ? ColorConstant.blueColor
                                    : Colors.transparent,
                            height: mq.height * 0.04,
                            radius: 50.r,
                            paddingHorizontal: 15.w,
                            textSize: 12.sp,
                            textFw: FontWeight.w400,
                            text: "Yearly",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    CustomButtonWidget(
                      sizedBoxWidth: 10.w,
                      tabAction: () async {
                        salaryController.resetPdfCurrentPage();
                        salaryController.generateSalaryReport(context);
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
                        Icons.receipt_long,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        width: 200.w,
                        height: mq.height * 0.04,
                        controller: salaryController.searchDateController,
                        horizontalPadding: 10.w,
                        labelText: "dd-MM-yyyy",
                        icon: Icon(
                          Icons.event,
                          color: ColorConstant.hintTextColor,
                        ),
                        suffixTapAction: () {
                          salaryController.selectDate(
                              context, salaryController.searchDateController);
                        },
                        onTap: () {
                          salaryController.selectDate(
                              context, salaryController.searchDateController);
                        },
                        hintTextSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDownButton(
                        isSearching: true,
                        width: 200.w,
                        height: mq.height * 0.04,
                        dropDownButtonList: salaryController.employeesNameList,
                        text: 'Search & generate report',
                        textColor: ColorConstant.hintTextColor,
                        textSize: 12.sp,
                        textFw: FontWeight.w400,
                        dropDownListTextSize: 12.sp,
                        controller: salaryController,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                salaryController.isSalarySearching
                    ? Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: ColorConstant.blueColor),
                        ),
                      )
                    : CustomButtonWidget(
                        radius: 5.r,
                        height: mq.height * 0.04,
                        paddingHorizontal: 8.w,
                        buttonColor: ColorConstant.blueColor,
                        text: "Search",
                        textSize: 10.sp,
                        tabAction: () async {
                          if (salaryController.selectedSearchedName != null &&
                              salaryController.searchDateController.text
                                  .toString()
                                  .isNotEmpty) {
                            salaryController.salarySearchingProgress(true);
                            salaryController.searchSalary(context);
                          }
                        },
                      ),
                SizedBox(
                  height: 20.h,
                ),
                salaryController.searchedSalary == null
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          salaryController.setEmployeeName(
                              salaryController.searchedSalary!.employeeName!);
                          salaryController.employeeSalary.text =
                              (salaryController.searchedSalary!.employeeSalary
                                  .toString());
                          salaryController.shiftController.text =
                              (salaryController.searchedSalary!.shift
                                  .toString());
                          salaryController.dateController.text =
                              salaryController.formatDate(
                                  (salaryController.searchedSalary!.date!));

                          AddAndUpdateSalaryDialog.showCustomDialog(
                              isDataAddAble: false,
                              context,
                              id: salaryController.searchedSalary!.id,
                              height: 620.h,
                              width: 600.w);
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
                                      salaryController.clearAllSelections();
                                      salaryController.setSearchedSalaryNull();
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
                                    salaryController
                                            .searchedSalary!.employeeName ??
                                        "",
                                    fw: FontWeight.w700,
                                    size: 14.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                  CustomText(
                                    salaryController.formatDate(
                                        salaryController.searchedSalary!.date!),
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
                                      salaryController
                                              .searchedSalary!.employeeSalary
                                              .toString() ??
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
                                    salaryController.searchedSalary!.shift
                                        .toString(),
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
                                              "You sure want to delete this salary record!",
                                          textFw: FontWeight.bold,
                                          yesAction: () {
                                        salaryController.salaryDeleteAction(
                                            salaryController.searchedSalary!,
                                            context);
                                      }, noAction: () {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
              ],
            ),
          ),
        );
      },
    );
  }
}
