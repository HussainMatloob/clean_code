import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/expenses_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/expense_management/add_and_update_expenses_dialog.dart';
import 'package:snooker_management/views/screens/expense_management/expenses_table_view.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

import '../../../main.dart';
import '../../widgets/custom_button_widget.dart';
import 'expense_tale_row.dart';

class ExpenseScreen extends StatefulWidget {
  final String? snookerLogo;
  const ExpenseScreen({super.key, this.snookerLogo});
  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  ExpensesController expensesController = Get.put(ExpensesController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      expensesController.clearExpensesNameList();
      expensesController.getExpensesName(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<ExpensesController>(
      init: ExpensesController(),
      builder: (expensesController) {
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
                              context.go('/app/searchExpense');
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
                                expensesController.clearAllSelections();
                                AddAndUpdateExpensesDialog.showCustomDialog(
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
                        Row(
                          mainAxisAlignment: ResponsiveHelper.isMobile(context)
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            CustomButtonWidget(
                              sizedBoxWidth: 10.w,
                              tabAction: () {
                                expensesController.clearAllSelections();
                                context.go('/app/otherExpense');
                              },
                              buttonColor: ColorConstant.blueColor,
                              height: mq.height * 0.04,
                              paddingHorizontal: 15.w,
                              textSize: 12.sp,
                              textFw: FontWeight.w400,
                              textColor: ColorConstant.whiteColor,
                              text: "Other Expenses",
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
                                                .selectExpenseReportOption(
                                                    "Monthly");
                                          },
                                          buttonColor: expensesController
                                                      .selectedExpenseReportOption ==
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
                                            expensesController
                                                .selectExpenseReportOption(
                                                    "Yearly");
                                          },
                                          buttonColor: expensesController
                                                      .selectedExpenseReportOption ==
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
                                  expensesController
                                      .generateExpensesReport(context);
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
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.isMobile(context)
                              ? mq.height * 0.01
                              : mq.height * 0.03,
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
                                    expensesController.searchDateController,
                                horizontalPadding: 10.w,
                                labelText: "dd-MM-yyyy",
                                icon: Icon(
                                  Icons.event,
                                  color: ColorConstant.hintTextColor,
                                ),
                                suffixTapAction: () {
                                  expensesController.selectDate(context,
                                      expensesController.searchDateController);
                                },
                                onTap: () {
                                  expensesController.selectDate(context,
                                      expensesController.searchDateController);
                                },
                                hintTextSize: 12.sp,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              CustomDropDownButton(
                                width: 200.w,
                                height: mq.height * 0.04,
                                dropDownButtonList:
                                    expensesController.expensesNameList,
                                text: 'Search & generate report',
                                textColor: ColorConstant.hintTextColor,
                                textSize: 12.sp,
                                textFw: FontWeight.w400,
                                dropDownListTextSize: 12.sp,
                                isShowingCustomNames: true,
                                controller: expensesController,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              expensesController.isExpenseSearching
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
                                        if (expensesController
                                                    .selectedCustomName !=
                                                null &&
                                            expensesController
                                                .searchDateController.text
                                                .toString()
                                                .isNotEmpty) {
                                          expensesController
                                              .expenseSearchingProgress(true);
                                          expensesController
                                              .searchExpense(context);
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
                                  expensesController.clearAllSelections();
                                  expensesController.setSearchedExpenseEmpty();
                                },
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: SizedBox(
                            height: mq.height * 0.02,
                          ),
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: ExpenseTableRow(
                            cells: [
                              CustomTableCell(
                                text: "Expense Name",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Description",
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
                        const ExpensesTableView()
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
