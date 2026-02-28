import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/controller/sale_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/dialog_helper.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';

import 'package:snooker_management/views/screens/sale_management/sale_table_rows.dart';
import 'package:snooker_management/views/screens/sale_management/sales_table_view.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';
import 'package:snooker_management/views/widgets/edit_able_custom_drop_down.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});
  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  SaleController saleController = Get.put(SaleController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saleController.clearAllSearchedLoserSelections(true);
      saleController.getLosersName(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<SaleController>(
      init: SaleController(),
      builder: (saleController) {
        return Form(
          key: saleController.fieldsKey1,
          child: Container(
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
                SizedBox(
                  height: 15.w,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: EditAbleCustomDropDownButton(
                            isValidateTrue: false,
                            dropDownButtonList:
                                saleController.allTemporaryLosersNameList,
                            text: "Select or enter loser name",
                            textColor: ColorConstant.hintTextColor,
                            textSize: 15.sp,
                            textFw: FontWeight.w400,
                            dropDownListTextSize: 12.sp,
                            controller: saleController,
                            customFieldController:
                                saleController.searchLoserController,
                            isAllocation: true,
                            hintTextSize: 12.sp,
                          ),
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
                            radius: 5.r,
                            height: mq.height * 0.04,
                            paddingHorizontal: 9.w,
                            buttonColor: ColorConstant.blueColor,
                            text: "Search",
                            textSize: 12.sp,
                            tabAction: () async {
                              if (saleController.searchLoserController.text
                                  .trim()
                                  .isNotEmpty) {
                                saleController.searchLoser(context);
                              } else {
                                DialogHelper.showAttentionDialog(context,
                                    "Please select or enter the name of the losing participant");
                              }
                            },
                          ),
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
                            radius: 5.r,
                            height: mq.height * 0.04,
                            paddingHorizontal: 9.w,
                            buttonColor: ColorConstant.blueColor,
                            sizedBoxWidth: 4.w,
                            text: "Sale reports",
                            textSize: 12.sp,
                            tabAction: () {
                              saleController
                                  .clearAllSearchedLoserSelections(false);
                              context.go('/app/reportsAndSales');
                            },
                            icon: Icon(
                              size: 12.sp,
                              Icons.picture_as_pdf,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
                Visibility(
                  visible: ResponsiveHelper.isMobile(context),
                  child: SizedBox(
                    height: 8.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 30.w),
                  child: Row(
                    children: [
                      Visibility(
                        visible: ResponsiveHelper.isMobile(context),
                        child: CustomButtonWidget(
                          radius: 5.r,
                          height: mq.height * 0.04,
                          paddingHorizontal: 9.w,
                          buttonColor: ColorConstant.blueColor,
                          text: "Search",
                          textSize: 12.sp,
                          tabAction: () async {
                            if (saleController.searchLoserController.text
                                .trim()
                                .isNotEmpty) {
                              saleController.searchLoser(context);
                            } else {
                              DialogHelper.showAttentionDialog(context,
                                  "Please select or enter the name of the losing participant");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: ResponsiveHelper.isMobile(context),
                  child: SizedBox(
                    height: 10.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 30.w),
                  child: Row(
                    children: [
                      Visibility(
                        visible: ResponsiveHelper.isMobile(context),
                        child: CustomButtonWidget(
                          radius: 5.r,
                          height: mq.height * 0.04,
                          paddingHorizontal: 9.w,
                          buttonColor: ColorConstant.blueColor,
                          sizedBoxWidth: 4.w,
                          text: "Sale reports",
                          textSize: 12.sp,
                          tabAction: () {
                            saleController
                                .clearAllSearchedLoserSelections(false);
                            context.go('/app/reportsAndSales');
                          },
                          icon: Icon(
                            size: 12.sp,
                            Icons.picture_as_pdf,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Visibility(
                                visible: !ResponsiveHelper.isMobile(context),
                                child: SaleTableRows(
                                  cells: [
                                    CustomTableCell(
                                      text: "Table No",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "Table Price",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "Loser Name",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "Lose Games",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "Amount",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "Game Type",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "Start Time",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "End Time",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "Total Time",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "date",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                    CustomTableCell(
                                      text: "Action",
                                      textColor: ColorConstant.primaryColor,
                                      textFw: FontWeight.bold,
                                    ),
                                  ],
                                  isHeader: true,
                                ),
                              ),
                              const SalesTableView(),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CustomText(
                                    "Total:${saleController.totalAmount}",
                                    fw: FontWeight.w700,
                                    size: 16.sp,
                                    color: ColorConstant.greyColor,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Container(
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.w,
                                            color: ColorConstant.greyColor)),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: saleController
                                          .totalSaleAmountController,
                                      horizontalPadding: 10.w,
                                      labelText: "Final Amount",
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly, // Allow only digits
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            CustomButtonWidget(
                              tabAction: () {
                                if (saleController.totalSaleAmountController
                                    .text.isNotEmpty) {
                                  if (saleController
                                      .searchedLosers.isNotEmpty) {
                                    saleController.addSearchedLoserSale(
                                        context,
                                        saleController.searchedLosers[0],
                                        saleController.searchedLosers,
                                        true,
                                        saleController.totalAmount.toString(),
                                        saleController
                                            .totalSaleAmountController.text);
                                  }
                                }
                              },
                              buttonColor: ColorConstant.primaryColor,
                              height: 50.h,
                              width: 90.w,
                              textSize: 12.sp,
                              textFw: FontWeight.w400,
                              textColor: ColorConstant.whiteColor,
                              text: "Add All",
                              radius: 5.r,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
