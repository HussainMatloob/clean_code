import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/expenses_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/expense_model.dart';
import 'package:snooker_management/services/expense_services.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/expense_management/add_and_update_expenses_dialog.dart';
import 'package:snooker_management/views/screens/expense_management/expense_tale_row.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

import '../../widgets/custom_empty_screen_message.dart';

class ExpensesTableView extends StatefulWidget {
  const ExpensesTableView({super.key});
  @override
  State<ExpensesTableView> createState() => _ExpensesTableViewState();
}

class _ExpensesTableViewState extends State<ExpensesTableView> {
  ExpensesController expensesController = Get.put(ExpensesController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expensesController.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return GetBuilder<ExpensesController>(
      init: ExpensesController(),
      builder: (expensesController) {
        return expensesController.userUid == null
            ? SizedBox()
            : expensesController.searchedExpenses.isEmpty ||
                    ResponsiveHelper.isMobile(context)
                ? PaginateFirestore(
                    shrinkWrap: true,
                    itemBuilder: (context, documentSnapshot, index) {
                      ExpensesModel expenseModel = ExpensesModel.fromJson(
                          documentSnapshot[index].data()
                              as Map<String, dynamic>);

                      return ResponsiveHelper.isMobile(context)
                          ? GestureDetector(
                              onTap: () {
                                expensesController.expenseNameController.text =
                                    expenseModel.expenseName!;
                                expensesController.descriptionController.text =
                                    expenseModel.expenseDescription!;
                                expensesController
                                        .expenseAmountController.text =
                                    expenseModel.expenseAmount.toString();
                                expensesController.dateController.text =
                                    expensesController
                                        .formatDate(expenseModel.expenseDate!);
                                AddAndUpdateExpensesDialog.showCustomDialog(
                                    isDataAddAble: false,
                                    context,
                                    id: expenseModel.id,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          expenseModel.expenseName ?? "",
                                          fw: FontWeight.w700,
                                          size: 14.sp,
                                          color: ColorConstant.blackColor,
                                        ),
                                        CustomText(
                                          expensesController.formatDate(
                                              expenseModel.expenseDate!),
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
                                            expenseModel.expenseDescription,
                                            fw: FontWeight.w400,
                                            size: 11.sp,
                                            color: ColorConstant.blackColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        CustomText(
                                          expenseModel.expenseAmount.toString(),
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
                                                      expenseModel, context);
                                            }, noAction: () {
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                          : ExpenseTableRow(
                              cells: [
                                CustomTableCell(
                                  text: expenseModel.expenseName,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: expenseModel.expenseDescription,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: expenseModel.expenseAmount.toString(),
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: expensesController
                                      .formatDate(expenseModel.expenseDate!),
                                  padding: 8.r,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: CustomButtonWidget(
                                        tabAction: () {
                                          expensesController
                                              .expenseNameController
                                              .text = expenseModel.expenseName!;
                                          expensesController
                                                  .descriptionController.text =
                                              expenseModel.expenseDescription!;
                                          expensesController
                                                  .expenseAmountController
                                                  .text =
                                              expenseModel.expenseAmount
                                                  .toString();
                                          expensesController
                                                  .dateController.text =
                                              expensesController.formatDate(
                                                  expenseModel.expenseDate!);
                                          AddAndUpdateExpensesDialog
                                              .showCustomDialog(
                                                  isDataAddAble: false,
                                                  context,
                                                  id: expenseModel.id,
                                                  height: 620.h,
                                                  width: 600.w);
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
                                    FittedBox(
                                      child: CustomButtonWidget(
                                        tabAction: () {
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
                                                    expenseModel, context);
                                          }, noAction: () {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          size: 18.sp,
                                          color: ColorConstant.whiteColor,
                                        ),
                                        height: 50.h,
                                        width: 40.w,
                                        buttonColor: ColorConstant.redColor,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                    },
                    query: FirebaseExpenseServices.getExpenses(
                        expensesController.userUid ?? ""),
                    itemBuilderType: PaginateBuilderType.listView,
                    isLive: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    onEmpty: Center(
                      child: CustomEmptyScreenMessage(
                        icon: Icon(
                          Icons
                              .receipt_long, // Represents receipts or financial records
                          size: 60.sp,
                          color: ColorConstant.greyColor,
                        ),
                        headText: "No Expenses Recorded",
                        subtext:
                            "You haven’t added any expenses yet.\nStart tracking your spending by adding your first expense.",
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: expensesController.searchedExpenses.length,
                    itemBuilder: (context, index) {
                      return ExpenseTableRow(
                        cells: [
                          CustomTableCell(
                            text: expensesController
                                .searchedExpenses[index].expenseName,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: expensesController
                                .searchedExpenses[index].expenseDescription,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: expensesController
                                .searchedExpenses[index].expenseAmount
                                .toString(),
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: expensesController.formatDate(
                                expensesController
                                    .searchedExpenses[index].expenseDate!),
                            padding: 8.r,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: CustomButtonWidget(
                                  tabAction: () {
                                    expensesController
                                            .expenseNameController.text =
                                        expensesController
                                            .searchedExpenses[index]
                                            .expenseName!;
                                    expensesController
                                            .descriptionController.text =
                                        expensesController
                                            .searchedExpenses[index]
                                            .expenseDescription!;
                                    expensesController
                                            .expenseAmountController.text =
                                        expensesController
                                            .searchedExpenses[index]
                                            .expenseAmount
                                            .toString();
                                    expensesController.dateController.text =
                                        expensesController.formatDate(
                                            expensesController
                                                .searchedExpenses[index]
                                                .expenseDate!);

                                    AddAndUpdateExpensesDialog.showCustomDialog(
                                      isDataAddAble: false,
                                      context,
                                      id: expensesController
                                          .searchedExpenses[index].id,
                                      height: 700.h,
                                      width: 600.w,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.update,
                                    size: 18.sp,
                                    color: ColorConstant.whiteColor,
                                  ),
                                  height: 50.h,
                                  width: 40.w,
                                  buttonColor: ColorConstant.blueColor,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              FittedBox(
                                child: CustomButtonWidget(
                                  tabAction: () {
                                    CustomAlertDialog.CustomDialog(
                                        containerHeight: 300.h,
                                        containerWidth: 100.w,
                                        height: 30.h,
                                        context,
                                        text:
                                            "You sure want to delete this expense record!",
                                        textFw: FontWeight.bold, yesAction: () {
                                      expensesController.expenseDeleteAction(
                                          expensesController
                                              .searchedExpenses[index],
                                          context);
                                    }, noAction: () {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 18.sp,
                                    color: ColorConstant.whiteColor,
                                  ),
                                  height: 50.h,
                                  width: 40.w,
                                  buttonColor: ColorConstant.redColor,
                                ),
                              )
                            ],
                          )
                          // _buildTableCellImage(employeeDetailModel.image.toString()),
                        ],
                      );
                    });
      },
    );
  }
}
