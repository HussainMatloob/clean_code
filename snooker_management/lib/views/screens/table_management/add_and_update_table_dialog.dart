import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/table_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import '../../../main.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/custom_text_form_field.dart';

class AddAndUpdateTableDialog {
  static void showCustomDialog(
    BuildContext context, {
    bool? isDataAddAble,
    String? id,
    double? height,
    double? width,
    String? tableNumber,
  }) {
    mq = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GetBuilder<TableController>(
            init: TableController(),
            builder: (tableController) {
              return Form(
                key: tableController.fieldsKey,
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: CustomText(
                                        textOverflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        isDataAddAble == true
                                            ? "Add New Table"
                                            : "Update Table",
                                        fw: FontWeight.w700,
                                        color: ColorConstant.blackColor,
                                        size: 16.sp,
                                      )),
                                ),
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
                              children: [
                                CustomTextFormField(
                                  controller:
                                      tableController.tableNumberController,
                                  horizontalPadding: 10.w,
                                  labelText: "Table Number",
                                  validateFunction:
                                      tableController.tableNumberValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        tableController.focusNode2);
                                  },
                                  focusNode: tableController.focusNode1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller: tableController.nameController,
                                  horizontalPadding: 10.w,
                                  labelText: "Name",
                                  validateFunction:
                                      tableController.tableNameValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        tableController.focusNode3);
                                  },
                                  focusNode: tableController.focusNode2,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller: tableController.typeController,
                                  horizontalPadding: 10.w,
                                  labelText: "Type",
                                  validateFunction:
                                      tableController.tableTypeValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        tableController.focusNode4);
                                  },
                                  focusNode: tableController.focusNode3,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller:
                                      tableController.descriptionController,
                                  horizontalPadding: 10.w,
                                  labelText: "Description",
                                  validateFunction:
                                      tableController.tableDescriptionValidate,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        tableController.focusNode5);
                                  },
                                  focusNode: tableController.focusNode4,
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                                CustomTextFormField(
                                  controller: tableController.priceController,
                                  horizontalPadding: 10.w,
                                  labelText: "Price",
                                  validateFunction:
                                      tableController.tablePriceValidate,
                                  onFieldSubmitted: (_) {
                                    tableController.focusNode5.unfocus();
                                  },
                                  focusNode: tableController.focusNode5,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                ),
                                SizedBox(
                                  height: mq.height * 0.04,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: ResponsiveHelper.isMobile(context) ||
                                ResponsiveHelper.isTablet(context)
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.end,
                        children: [
                          CustomButtonWidget(
                            tabAction: () {
                              if (isDataAddAble == true) {
                                if (tableController.fieldsKey.currentState!
                                    .validate()) {
                                  tableController.addTableFunction(context);
                                }
                              } else {
                                if (tableController.fieldsKey.currentState!
                                    .validate()) {
                                  tableController.updateTableFunction(
                                      context, id!, tableNumber!);
                                }
                              }
                            },
                            buttonColor: ColorConstant.primaryColor,
                            height: mq.height * 0.05,
                            paddingHorizontal: 10.w,
                            textSize: 14.sp,
                            textFw: FontWeight.w400,
                            textColor: ColorConstant.whiteColor,
                            text: isDataAddAble == true ? "Add" : "Update",
                            radius: 5.r,
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          CustomButtonWidget(
                            tabAction: () {
                              tableController.tableNumberController.clear();
                              tableController.nameController.clear();
                              tableController.typeController.clear();
                              tableController.descriptionController.clear();
                              tableController.priceController.clear();
                            },
                            buttonColor: ColorConstant.blueColor,
                            height: mq.height * 0.05,
                            paddingHorizontal: 10.w,
                            textSize: 14.sp,
                            textFw: FontWeight.w400,
                            textColor: ColorConstant.whiteColor,
                            text: "Clear",
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
