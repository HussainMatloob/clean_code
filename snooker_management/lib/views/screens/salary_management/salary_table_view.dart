import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/salary_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/salary_model.dart';
import 'package:snooker_management/services/salary_servces.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/expense_management/expense_tale_row.dart';
import 'package:snooker_management/views/screens/salary_management/add_and_update_salary_dialog.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_empty_screen_message.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class SalaryTableView extends StatefulWidget {
  const SalaryTableView({super.key});
  @override
  State<SalaryTableView> createState() => _ExpensesTableViewState();
}

class _ExpensesTableViewState extends State<SalaryTableView> {
  SalaryController salaryController = Get.put(SalaryController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    salaryController.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return GetBuilder<SalaryController>(
      init: SalaryController(),
      builder: (salaryController) {
        return salaryController.userUid == null
            ? SizedBox()
            : salaryController.searchedSalary == null
                ? PaginateFirestore(
                    shrinkWrap: true,
                    itemBuilder: (context, documentSnapshot, index) {
                      SalaryModel salaryModel = SalaryModel.fromJson(
                          documentSnapshot[index].data()
                              as Map<String, dynamic>);

                      return ResponsiveHelper.isMobile(context)
                          ? GestureDetector(
                              onTap: () {
                                salaryController
                                    .setEmployeeName(salaryModel.employeeName!);
                                salaryController.employeeSalary.text =
                                    salaryModel.employeeSalary.toString();
                                salaryController.shiftController.text =
                                    salaryModel.shift.toString();
                                salaryController.dateController.text =
                                    salaryController
                                        .formatDate(salaryModel.date!);
                                AddAndUpdateSalaryDialog.showCustomDialog(
                                    isDataAddAble: false,
                                    context,
                                    id: salaryModel.id,
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
                                          salaryModel.employeeName ?? "",
                                          fw: FontWeight.w700,
                                          size: 14.sp,
                                          color: ColorConstant.blackColor,
                                        ),
                                        CustomText(
                                          salaryController
                                              .formatDate(salaryModel.date!),
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
                                            salaryModel.employeeSalary
                                                .toString(),
                                            fw: FontWeight.w400,
                                            size: 11.sp,
                                            color: ColorConstant.blackColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        CustomText(
                                          salaryModel.shift.toString(),
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
                                              salaryController
                                                  .salaryDeleteAction(
                                                      salaryModel, context);
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
                                  text: salaryModel.employeeName,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: salaryModel.employeeSalary.toString(),
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: salaryModel.shift.toString(),
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: salaryController
                                      .formatDate(salaryModel.date!),
                                  padding: 8.r,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: CustomButtonWidget(
                                        tabAction: () {
                                          salaryController.setEmployeeName(
                                              salaryModel.employeeName!);
                                          salaryController.employeeSalary.text =
                                              salaryModel.employeeSalary
                                                  .toString();
                                          salaryController
                                                  .shiftController.text =
                                              salaryModel.shift.toString();
                                          salaryController.dateController.text =
                                              salaryController.formatDate(
                                                  salaryModel.date!);
                                          AddAndUpdateSalaryDialog
                                              .showCustomDialog(
                                                  isDataAddAble: false,
                                                  context,
                                                  id: salaryModel.id,
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
                                                  "You sure want to delete this salary record!",
                                              textFw: FontWeight.bold,
                                              yesAction: () {
                                            salaryController.salaryDeleteAction(
                                                salaryModel, context);
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
                    query: FirebaseSalaryServices.getSalaries(
                        salaryController.userUid ?? ""),
                    itemBuilderType: PaginateBuilderType.listView,
                    isLive: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    onEmpty: Center(
                      child: CustomEmptyScreenMessage(
                        icon: Icon(
                          Icons.payments, // Salary-related icon
                          size: 60.sp,
                          color: ColorConstant.greyColor,
                        ),
                        headText: "No Salaries Recorded",
                        subtext:
                            "You haven’t added any salary records yet.\nStart by adding salary details to keep track of payments.",
                      ),
                    ),
                  )
                : ExpenseTableRow(
                    cells: [
                      CustomTableCell(
                        text: salaryController.searchedSalary!.employeeName,
                        padding: 8.r,
                      ),
                      CustomTableCell(
                        text: salaryController.searchedSalary!.employeeSalary
                            .toString(),
                        padding: 8.r,
                      ),
                      CustomTableCell(
                        text: salaryController.searchedSalary!.shift.toString(),
                        padding: 8.r,
                      ),
                      CustomTableCell(
                        text: salaryController
                            .formatDate(salaryController.searchedSalary!.date!),
                        padding: 8.r,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: CustomButtonWidget(
                              tabAction: () {
                                salaryController.setEmployeeName(
                                    salaryController
                                        .searchedSalary!.employeeName!);
                                salaryController.employeeSalary.text =
                                    (salaryController
                                        .searchedSalary!.employeeSalary
                                        .toString());
                                salaryController.shiftController.text =
                                    (salaryController.searchedSalary!.shift
                                        .toString());
                                salaryController.dateController.text =
                                    salaryController.formatDate(
                                        (salaryController
                                            .searchedSalary!.date!));

                                AddAndUpdateSalaryDialog.showCustomDialog(
                                    isDataAddAble: false,
                                    context,
                                    id: salaryController.searchedSalary!.id,
                                    height: 620.h,
                                    width: 600.w);
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
                                        "You sure want to delete this salary record!",
                                    textFw: FontWeight.bold, yesAction: () {
                                  salaryController.salaryDeleteAction(
                                      salaryController.searchedSalary!,
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
      },
    );
  }
}
