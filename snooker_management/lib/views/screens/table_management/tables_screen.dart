import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/auth_controller.dart';
import 'package:snooker_management/controller/table_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/table_management/table_row.dart';
import 'package:snooker_management/views/screens/table_management/add_and_update_table_dialog.dart';
import 'package:snooker_management/views/screens/table_management/table_view.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';
import '../../../main.dart';
import '../../widgets/custom_button_widget.dart';

class TablesScreen extends StatefulWidget {
  final String? snookerLogo;
  const TablesScreen({super.key, this.snookerLogo});
  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<TableController>(
      init: TableController(),
      builder: (tableController) {
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
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment:
                              ResponsiveHelper.isMobile(context) ||
                                      ResponsiveHelper.isTablet(context)
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                          children: [
                            CustomButtonWidget(
                              sizedBoxWidth: 10.w,
                              tabAction: () {
                                tableController.tableNumberController.clear();
                                tableController.nameController.clear();
                                tableController.typeController.clear();
                                tableController.descriptionController.clear();
                                tableController.priceController.clear();
                                AddAndUpdateTableDialog.showCustomDialog(
                                    isDataAddAble: true,
                                    context,
                                    height: 700.h,
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
                          mainAxisAlignment:
                              ResponsiveHelper.isMobile(context) ||
                                      ResponsiveHelper.isTablet(context)
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                          children: [
                            CustomButtonWidget(
                              sizedBoxWidth: 10.w,
                              tabAction: () async {
                                tableController.generateTablesReport(context);
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
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment:
                              ResponsiveHelper.isMobile(context) ||
                                      ResponsiveHelper.isTablet(context)
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                          crossAxisAlignment:
                              ResponsiveHelper.isMobile(context) ||
                                      ResponsiveHelper.isTablet(context)
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                          children: [
                            CustomTextFormField(
                              controller: tableController.searchController,
                              width: 200.w,
                              height: mq.height * 0.04,
                              horizontalPadding: 10.w,
                              labelText: "Search by table number",
                              hintTextSize: 12.sp,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // Allow only digits
                              ],
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            tableController.isTableSearching
                                ? SizedBox(
                                    height: ResponsiveHelper.isMobile(context)
                                        ? 25.h
                                        : 30.h,
                                    width: ResponsiveHelper.isMobile(context)
                                        ? 25.w
                                        : 30.w,
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
                                      if (tableController.searchController.text
                                          .toString()
                                          .isNotEmpty) {
                                        tableController
                                            .tableSearchingProgress(true);
                                        tableController.searchTable(context);
                                      }
                                    },
                                  ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Visibility(
                              visible: !ResponsiveHelper.isMobile(context) &&
                                  !ResponsiveHelper.isTablet(context),
                              child: CustomButtonWidget(
                                radius: 5.r,
                                height: mq.height * 0.04,
                                paddingHorizontal: 8.w,
                                buttonColor: ColorConstant.blueColor,
                                sizedBoxWidth: 4.w,
                                text: "Clear",
                                textSize: 12.sp,
                                tabAction: () {
                                  tableController.setTableNull();
                                  tableController.searchController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context) &&
                              !ResponsiveHelper.isTablet(context),
                          child: SnookerTableRow(
                            cells: [
                              CustomTableCell(
                                text: "Table Number",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Name",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Type",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Description",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Price",
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
                        const TableView()
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
