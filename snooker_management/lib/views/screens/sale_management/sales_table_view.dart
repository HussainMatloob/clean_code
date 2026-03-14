import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/sale_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/sale_management/add_table_sale_dialog.dart';
import 'package:snooker_management/views/screens/sale_management/sale_table_rows.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class SalesTableView extends StatefulWidget {
  const SalesTableView({super.key});

  @override
  State<SalesTableView> createState() => _SalesTableViewState();
}

class _SalesTableViewState extends State<SalesTableView> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<SaleController>(
      init: SaleController(),
      builder: (saleController) {
        return Expanded(
          child: ListView.builder(
            itemCount: saleController.searchedLosers.length,
            itemBuilder: (context, index) {
              return ResponsiveHelper.isMobile(context)
                  ? GestureDetector(
                      onTap: () {
                        saleController.saleAmountController1.text =
                            saleController.searchedLosers[index].payAmount
                                .toString();
                        AddSaleDialog.showCustomDialog(
                          context,
                          height: 400.h,
                          width: 400.w,
                          temporaryLoser: saleController.searchedLosers[index],
                        );
                      },
                      child: Container(
                        width: mq.width,
                        margin: EdgeInsets.only(bottom: 15.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.greenLightColor,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  saleController
                                          .searchedLosers[index].looserName ??
                                      "",
                                  fw: FontWeight.w700,
                                  size: 14.sp,
                                  color: ColorConstant.blackColor,
                                ),
                                CustomText(
                                  saleController.formatDate(
                                    saleController.searchedLosers[index].date!,
                                  ),
                                  fw: FontWeight.w400,
                                  size: 11.sp,
                                  color: ColorConstant.blackColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    textAlign: TextAlign.start,
                                    saleController
                                            .searchedLosers[index].startTime ??
                                        "",
                                    fw: FontWeight.w400,
                                    size: 11.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    textAlign: TextAlign.center,
                                    saleController
                                            .searchedLosers[index].endTime ??
                                        "",
                                    fw: FontWeight.w400,
                                    size: 11.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    textAlign: TextAlign.end,
                                    saleController
                                            .searchedLosers[index].totalTime ??
                                        "",
                                    fw: FontWeight.w400,
                                    size: 11.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.price_change,
                                      size: 20.sp,
                                      color: ColorConstant.primaryColor,
                                    ),
                                    CustomText(
                                      saleController
                                          .searchedLosers[index].tablePrice,
                                      fw: FontWeight.w400,
                                      size: 11.sp,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.cancel,
                                      size: 20.sp,
                                      color: ColorConstant.primaryColor,
                                    ),
                                    CustomText(
                                      saleController
                                          .searchedLosers[index].loosGames
                                          .toString(),
                                      fw: FontWeight.w400,
                                      size: 11.sp,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      size: 20.sp,
                                      color: ColorConstant.primaryColor,
                                    ),
                                    CustomText(
                                      saleController
                                          .searchedLosers[index].payAmount
                                          .toString(),
                                      fw: FontWeight.w400,
                                      size: 11.sp,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(color: ColorConstant.hintTextColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  "Table : ${saleController.searchedLosers[index].tableNumber}",
                                  fw: FontWeight.w700,
                                  size: 12.sp,
                                  color: ColorConstant.blackColor,
                                ),
                                CustomButtonWidget(
                                  radius: 5.r,
                                  height: mq.height * 0.03,
                                  paddingHorizontal: 8.w,
                                  buttonColor: ColorConstant.primaryColor,
                                  textColor: ColorConstant.whiteColor,
                                  text: saleController
                                      .searchedLosers[index].gameType,
                                  textSize: 10.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : SaleTableRows(
                      cells: [
                        CustomTableCell(
                          text:
                              saleController.searchedLosers[index].tableNumber,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: saleController.searchedLosers[index].tablePrice,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: saleController.searchedLosers[index].looserName,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: saleController.searchedLosers[index].loosGames
                              .toString(),
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: saleController.searchedLosers[index].payAmount
                              .toString(),
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: saleController.searchedLosers[index].gameType,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: saleController.searchedLosers[index].startTime,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: saleController.searchedLosers[index].endTime,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: saleController.searchedLosers[index].totalTime,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: saleController.formatDate(
                            saleController.searchedLosers[index].date!,
                          ),
                          padding: 8.r,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: CustomButtonWidget(
                                tabAction: () {
                                  saleController.saleAmountController1.text =
                                      saleController
                                          .searchedLosers[index].payAmount
                                          .toString();
                                  AddSaleDialog.showCustomDialog(
                                    context,
                                    height: 400.h,
                                    width: 400.w,
                                    temporaryLoser:
                                        saleController.searchedLosers[index],
                                  );
                                },
                                icon: Icon(
                                  Icons.add,
                                  size: 20.sp,
                                  color: ColorConstant.whiteColor,
                                ),
                                height: 60.h,
                                width: 40.w,
                                buttonColor: ColorConstant.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        // _buildTableCellImage(employeeDetailModel.image.toString()),
                      ],
                    );
            },
          ),
        );
      },
    );
  }
}
