import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/expenses_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/expense_management/other_expenses/add_and_update_other_expenses.dart';
import 'package:snooker_management/views/screens/expense_management/other_expenses/other_expense_table_view.dart';
import 'package:snooker_management/views/screens/expense_management/other_expenses/other_expenses_table_row.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';

class OtherExpensesScreen extends StatefulWidget {
  const OtherExpensesScreen({super.key});

  @override
  State<OtherExpensesScreen> createState() => _OtherExpensesScreenState();
}

class _OtherExpensesScreenState extends State<OtherExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return GetBuilder<ExpensesController>(
      init: ExpensesController(),
      builder: (expensesController) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: ColorConstant.linearGradian),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: mq.height,
                    width: mq.width,
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    decoration:
                        BoxDecoration(color: ColorConstant.secondaryColor),
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
                                expensesController.clearAllSelections();
                                AddAndUpdateOtherExpensesDialog
                                    .showCustomDialog(
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
                            Visibility(
                              visible: ResponsiveHelper.isMobile(context),
                              child: SizedBox(
                                width: 10.w,
                              ),
                            ),
                            Visibility(
                              visible: ResponsiveHelper.isMobile(context),
                              child: CustomButtonWidget(
                                sizedBoxWidth: 10.w,
                                tabAction: () async {
                                  expensesController
                                      .generateOtherExpensesReport(context);
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
                                  Icons.picture_as_pdf,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
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
                                          expensesController
                                              .selectOtherExpenseReportOption(
                                                  "Daily");
                                        },
                                        buttonColor: expensesController
                                                    .selectedOtherExpenseReportOption ==
                                                "Daily"
                                            ? ColorConstant.blueColor
                                            : Colors.transparent,
                                        height: mq.height * 0.04,
                                        radius: 50.r,
                                        paddingHorizontal: 15.w,
                                        textSize: 12.sp,
                                        textFw: FontWeight.w400,
                                        text: "Daily",
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      CustomButtonWidget(
                                        tabAction: () {
                                          expensesController
                                              .selectOtherExpenseReportOption(
                                                  "Weekly");
                                        },
                                        buttonColor: expensesController
                                                    .selectedOtherExpenseReportOption ==
                                                "Weekly"
                                            ? ColorConstant.blueColor
                                            : Colors.transparent,
                                        height: mq.height * 0.04,
                                        radius: 50.r,
                                        paddingHorizontal: 15.w,
                                        textSize: 12.sp,
                                        textFw: FontWeight.w400,
                                        text: "Weekly",
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      CustomButtonWidget(
                                        tabAction: () {
                                          expensesController
                                              .selectOtherExpenseReportOption(
                                                  "Monthly");
                                        },
                                        buttonColor: expensesController
                                                    .selectedOtherExpenseReportOption ==
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
                              child: CustomButtonWidget(
                                sizedBoxWidth: 10.w,
                                tabAction: () async {
                                  expensesController
                                      .generateOtherExpensesReport(context);
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
                                  Icons.picture_as_pdf,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: OtherExpensesTableRow(
                            cells: [
                              CustomTableCell(
                                text: "Person Name",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Expense Name",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Amount",
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
                        const OtherExpensesTableView()
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
