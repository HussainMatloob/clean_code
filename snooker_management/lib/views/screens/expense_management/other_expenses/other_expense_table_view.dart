import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/expenses_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/other_expenses_model.dart';
import 'package:snooker_management/services/expense_services.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/expense_management/other_expenses/add_and_update_other_expenses.dart';
import 'package:snooker_management/views/screens/expense_management/other_expenses/other_expenses_table_row.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

import '../../../widgets/custom_empty_screen_message.dart';

class OtherExpensesTableView extends StatefulWidget {
  const OtherExpensesTableView({super.key});
  @override
  State<OtherExpensesTableView> createState() => _OtherExpensesTableViewState();
}

class _OtherExpensesTableViewState extends State<OtherExpensesTableView> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return GetBuilder<ExpensesController>(
      init: ExpensesController(),
      builder: (expensesController) {
        return PaginateFirestore(
          shrinkWrap: true,
          itemBuilder: (context, documentSnapshot, index) {
            OtherExpensesModel otherExpensesModel = OtherExpensesModel.fromJson(
                documentSnapshot[index].data() as Map<String, dynamic>);

            return ResponsiveHelper.isMobile(context)
                ? GestureDetector(
                    onTap: () {
                      expensesController.nameController.text =
                          otherExpensesModel.name!;
                      expensesController.expenseNameController.text =
                          otherExpensesModel.expenseName!;
                      expensesController.expenseAmountController.text =
                          otherExpensesModel.otherExpenseAmount.toString();
                      expensesController.dateController.text =
                          expensesController
                              .formatDate(otherExpensesModel.expenseDate!);
                      AddAndUpdateOtherExpensesDialog.showCustomDialog(
                          isDataAddAble: false,
                          context,
                          id: otherExpensesModel.id,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                otherExpensesModel.name ?? "",
                                fw: FontWeight.w700,
                                size: 14.sp,
                                color: ColorConstant.blackColor,
                              ),
                              CustomText(
                                expensesController.formatDate(
                                    otherExpensesModel.expenseDate!),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  otherExpensesModel.expenseName,
                                  fw: FontWeight.w400,
                                  size: 11.sp,
                                  color: ColorConstant.blackColor,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              CustomText(
                                "${otherExpensesModel.otherExpenseAmount}",
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
                                      textFw: FontWeight.bold, yesAction: () {
                                    expensesController.otherExpenseDeleteAction(
                                        otherExpensesModel, context);
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
                : OtherExpensesTableRow(
                    cells: [
                      CustomTableCell(
                        text: otherExpensesModel.name,
                        padding: 8.r,
                      ),
                      CustomTableCell(
                        text: otherExpensesModel.expenseName,
                        padding: 8.r,
                      ),
                      CustomTableCell(
                        text: otherExpensesModel.otherExpenseAmount.toString(),
                        padding: 8.r,
                      ),
                      CustomTableCell(
                        text: expensesController
                            .formatDate(otherExpensesModel.expenseDate!),
                        padding: 8.r,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: CustomButtonWidget(
                              tabAction: () {
                                expensesController.nameController.text =
                                    otherExpensesModel.name!;
                                expensesController.expenseNameController.text =
                                    otherExpensesModel.expenseName!;
                                expensesController
                                        .expenseAmountController.text =
                                    otherExpensesModel.otherExpenseAmount
                                        .toString();
                                expensesController.dateController.text =
                                    expensesController.formatDate(
                                        otherExpensesModel.expenseDate!);
                                AddAndUpdateOtherExpensesDialog
                                    .showCustomDialog(
                                        isDataAddAble: false,
                                        context,
                                        id: otherExpensesModel.id,
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
                                    textFw: FontWeight.bold, yesAction: () {
                                  expensesController.otherExpenseDeleteAction(
                                      otherExpensesModel, context);
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
                    ],
                  );
          },
          query: FirebaseExpenseServices.getOtherExpenses(
              expensesController.userUid ?? ""),
          itemBuilderType: PaginateBuilderType.listView,
          isLive: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          onEmpty: Center(
            child: CustomEmptyScreenMessage(
              icon: Icon(
                Icons
                    .payments_outlined, // Represents miscellaneous financial transactions
                size: 60.sp,
                color: ColorConstant.greyColor,
              ),
              headText: "No Other Expenses Found",
              subtext:
                  "You haven’t added any other expenses yet.\nStart tracking miscellaneous costs by adding one now.",
            ),
          ),
        );
      },
    );
  }
}
