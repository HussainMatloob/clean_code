import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/expenses_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/date_time_utils.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/expense_management/add_and_update_expenses_dialog.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_drop_down_button.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class SearchExpenseScreen extends StatefulWidget {
  const SearchExpenseScreen({super.key});

  @override
  State<SearchExpenseScreen> createState() => _SearchExpenseScreenState();
}

class _SearchExpenseScreenState extends State<SearchExpenseScreen> {
  ExpensesController? expensesController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      expensesController = Get.isRegistered<ExpensesController>()
          ? null
          : Get.put(ExpensesController());
      expensesController!.clearExpensesNameList();
      expensesController!.getExpensesName(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<ExpensesController>(
      init:
          Get.isRegistered<ExpensesController>() ? null : ExpensesController(),
      builder: (expensesController) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: ColorConstant.linearGradian),
          ),
          child: Container(
            color: ColorConstant.secondaryColor,
            width: mq.width,
            padding: EdgeInsets.all(30.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              expensesController
                                  .selectExpenseReportOption("Monthly");
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
                                  .selectExpenseReportOption("Yearly");
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
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButtonWidget(
                      sizedBoxWidth: 10.w,
                      tabAction: () async {
                        expensesController.generateExpensesReport(context);
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
                SizedBox(height: mq.height * 0.03),
                CustomTextFormField(
                  height: mq.height * 0.04,
                  controller: expensesController.searchDateController,
                  horizontalPadding: 10.w,
                  labelText: "dd-MM-yyyy",
                  icon: Icon(
                    Icons.event,
                    color: ColorConstant.hintTextColor,
                  ),
                  suffixTapAction: () {
                    expensesController.selectDate(
                        context, expensesController.searchDateController);
                  },
                  onTap: () {
                    expensesController.selectDate(
                        context, expensesController.searchDateController);
                  },
                  hintTextSize: 12.sp,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: CustomDropDownButton(
                        height: mq.height * 0.04,
                        dropDownButtonList: expensesController.expensesNameList,
                        text: 'Search & generate report',
                        textColor: ColorConstant.hintTextColor,
                        textSize: 12.sp,
                        textFw: FontWeight.w400,
                        dropDownListTextSize: 12.sp,
                        isShowingCustomNames: true,
                        controller: expensesController,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                expensesController.isExpenseSearching
                    ? Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height:
                              ResponsiveHelper.isMobile(context) ? 20.h : 30.h,
                          width:
                              ResponsiveHelper.isMobile(context) ? 20.w : 30.w,
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
                          if (expensesController.selectedCustomName != null &&
                              expensesController.searchDateController.text
                                  .toString()
                                  .isNotEmpty) {
                            expensesController.expenseSearchingProgress(true);
                            expensesController.searchExpense(context);
                          }
                        },
                      ),
                SizedBox(
                  height: 20.h,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: expensesController.searchedExpenses.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            expensesController.expenseNameController.text =
                                expensesController
                                    .searchedExpenses[index].expenseName!;
                            expensesController.descriptionController.text =
                                expensesController.searchedExpenses[index]
                                    .expenseDescription!;
                            expensesController.expenseAmountController.text =
                                expensesController
                                    .searchedExpenses[index].expenseAmount
                                    .toString();
                            expensesController.dateController.text =
                                DateTimeUtils.formatDate(expensesController
                                    .searchedExpenses[index].expenseDate!);

                            AddAndUpdateExpensesDialog.showCustomDialog(
                              isDataAddAble: false,
                              context,
                              id: expensesController.searchedExpenses[index].id,
                              height: 700.h,
                              width: 600.w,
                            );
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
                                        expensesController.clearAllSelections();
                                        expensesController
                                            .setSearchedExpenseEmpty();
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
                                      expensesController.searchedExpenses[index]
                                              .expenseName ??
                                          "",
                                      fw: FontWeight.w700,
                                      size: 14.sp,
                                      color: ColorConstant.blackColor,
                                    ),
                                    CustomText(
                                      DateTimeUtils.formatDate(
                                          expensesController
                                              .searchedExpenses[index]
                                              .expenseDate!),
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
                                        expensesController
                                                .searchedExpenses[index]
                                                .expenseDescription ??
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
                                      expensesController
                                          .searchedExpenses[index].expenseAmount
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
                                                "You sure want to delete this expense record!",
                                            textFw: FontWeight.bold,
                                            yesAction: () {
                                          expensesController
                                              .expenseDeleteAction(
                                                  expensesController
                                                      .searchedExpenses[index],
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
                          ));
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
