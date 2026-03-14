import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/constants/data_constant.dart';

import 'package:snooker_management/controller/salary_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/salary_management/add_and_update_salary_dialog.dart';
import 'package:snooker_management/views/screens/salary_management/salary_table_row.dart';
import 'package:snooker_management/views/screens/salary_management/salary_table_view.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class SalaryScreen extends StatefulWidget {
  final String? snookerLogo;
  const SalaryScreen({super.key, this.snookerLogo});
  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  SalaryController salaryController = Get.put(SalaryController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      salaryController.setSearchedSalaryNull();
      salaryController.clearAllSelections();
      salaryController.clearEmployeesNameList();
      salaryController.getExpensesName(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<SalaryController>(
      init: SalaryController(),
      builder: (salaryController) {
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
                        Visibility(
                          visible: ResponsiveHelper.isMobile(context),
                          child: SizedBox(
                            height: mq.height * 0.03,
                          ),
                        ),
                        Visibility(
                          visible: ResponsiveHelper.isMobile(context),
                          child: GestureDetector(
                            onTap: () {
                              context.go('/app/searchSalaryScreen');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              width: mq.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: ColorConstant.greenLightColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    size: 20.sp,
                                    Icons.search,
                                    color: ColorConstant.greyColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                salaryController.setSearchedSalaryNull();
                                salaryController.clearAllSelections();
                                AddAndUpdateSalaryDialog.showCustomDialog(
                                    isDataAddAble: true,
                                    context,
                                    height: 620.h,
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
                                Icons.add,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomDropDownButton(
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
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ColorConstant.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(50.r)),
                                    child: Row(
                                      children: [
                                        CustomButtonWidget(
                                          tabAction: () {
                                            salaryController
                                                .selectSalaryReportOption(
                                                    "Monthly");
                                          },
                                          buttonColor: salaryController
                                                      .selectedSalaryReportOption ==
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
                                                .selectSalaryReportOption(
                                                    "Yearly");
                                          },
                                          buttonColor: salaryController
                                                      .selectedSalaryReportOption ==
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
                                width: 10.w,
                              ),
                              CustomButtonWidget(
                                sizedBoxWidth: 10.w,
                                tabAction: () async {
                                  salaryController
                                      .generateSalaryReport(context);
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
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: SizedBox(
                            height: mq.height * 0.03,
                          ),
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomTextFormField(
                                width: 200.w,
                                height: mq.height * 0.04,
                                controller:
                                    salaryController.searchDateController,
                                horizontalPadding: 10.w,
                                labelText: "dd-MM-yyyy",
                                icon: Icon(
                                  Icons.event,
                                  color: ColorConstant.hintTextColor,
                                ),
                                suffixTapAction: () {
                                  salaryController.selectDate(context,
                                      salaryController.searchDateController);
                                },
                                onTap: () {
                                  salaryController.selectDate(context,
                                      salaryController.searchDateController);
                                },
                                hintTextSize: 12.sp,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              CustomDropDownButton(
                                isSearching: true,
                                width: 200.w,
                                height: mq.height * 0.04,
                                dropDownButtonList:
                                    salaryController.employeesNameList,
                                text: 'Search & generate report',
                                textColor: ColorConstant.hintTextColor,
                                textSize: 12.sp,
                                textFw: FontWeight.w400,
                                dropDownListTextSize: 12.sp,
                                controller: salaryController,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              salaryController.isSalarySearching
                                  ? SizedBox(
                                      height: 30.h,
                                      width: 30.w,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: ColorConstant.blueColor),
                                    )
                                  : CustomButtonWidget(
                                      radius: 5.r,
                                      height: mq.height * 0.04,
                                      paddingHorizontal: 8.w,
                                      buttonColor: ColorConstant.blueColor,
                                      text: "Search",
                                      textSize: 10.sp,
                                      tabAction: () async {
                                        if (salaryController
                                                    .selectedSearchedName !=
                                                null &&
                                            salaryController
                                                .searchDateController.text
                                                .toString()
                                                .isNotEmpty) {
                                          salaryController
                                              .salarySearchingProgress(true);
                                          salaryController
                                              .searchSalary(context);
                                        }
                                      },
                                    ),
                              SizedBox(
                                width: 10.w,
                              ),
                              CustomButtonWidget(
                                radius: 5.r,
                                height: mq.height * 0.04,
                                paddingHorizontal: 8.w,
                                buttonColor: ColorConstant.blueColor,
                                sizedBoxWidth: 4.w,
                                text: "Clear",
                                textSize: 10.sp,
                                tabAction: () {
                                  salaryController.clearAllSelections();
                                  salaryController.setSearchedSalaryNull();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: SalaryTableRow(
                            cells: [
                              CustomTableCell(
                                text: "Employee Name",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Employee Salary",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Shift",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Date",
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
                        const SalaryTableView()
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
