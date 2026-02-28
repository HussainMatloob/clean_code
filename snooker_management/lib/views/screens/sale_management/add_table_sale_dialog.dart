import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/sale_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/TemporaryLoosersModel.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class AddSaleDialog {
  static void showCustomDialog(
    BuildContext context, {
    double? height,
    double? width,
    TemporaryLosersModel? temporaryLoser,
  }) {
    mq = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<SaleController>(
            init: SaleController(),
            builder: (saleController) {
              return Form(
                key: saleController.fieldsKey2,
                child: Container(
                  decoration: BoxDecoration(color: ColorConstant.whiteColor),
                  padding: EdgeInsets.all(20.r),
                  height: height ?? 800.h,
                  width: width ?? 600.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 50.w),
                                    child: CustomText(
                                      "Add Sale",
                                      fw: FontWeight.w700,
                                      color: ColorConstant.blackColor,
                                      size: 16.sp,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close,
                                size: 20.sp,
                                color: ColorConstant.blackColor,
                              ))
                        ],
                      ),
                      const Divider(
                        height: 1,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: EdgeInsets.all(30.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "Loser Name: ${temporaryLoser!.looserName}",
                                  fw: FontWeight.w700,
                                  color: ColorConstant.blackColor,
                                  size: 14.sp,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomText(
                                  "Total Amount: ${temporaryLoser.payAmount}",
                                  fw: FontWeight.w700,
                                  color: ColorConstant.blackColor,
                                  size: 14.sp,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextFormField(
                                  controller:
                                      saleController.saleAmountController1,
                                  horizontalPadding: 10.w,
                                  labelText: "Final Amount",
                                  validateFunction:
                                      saleController.saleAmountValidate,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: ResponsiveHelper.isMobile(context)
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.end,
                        children: [
                          CustomButtonWidget(
                            tabAction: () {
                              if (saleController.fieldsKey2.currentState!
                                  .validate()) {
                                saleController.addSearchedLoserSale(
                                    context,
                                    temporaryLoser,
                                    saleController.searchedLosers,
                                    false,
                                    "0",
                                    saleController.saleAmountController1.text);
                              }
                            },
                            buttonColor: ColorConstant.primaryColor,
                            height: mq.height * 0.05,
                            width: mq.height * 0.14,
                            textSize: 14.sp,
                            textFw: FontWeight.w400,
                            textColor: ColorConstant.whiteColor,
                            text: "Add",
                            radius: 5.r,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
