import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/table_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/services/table_services.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/table_management/add_and_update_table_dialog.dart';
import 'package:snooker_management/views/screens/table_management/table_row.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import '../../widgets/custom_empty_screen_message.dart';

class TableView extends StatefulWidget {
  const TableView({super.key});
  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  TableController tableController = Get.put(TableController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tableController.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<TableController>(
      init: TableController(),
      builder: (tableController) {
        return tableController.userUid == null
            ? SizedBox()
            : tableController.searchedTable == null
                ? PaginateFirestore(
                    shrinkWrap: true,
                    itemBuilder: (context, documentSnapshot, index) {
                      TableDetailModel tableDetailModel =
                          TableDetailModel.fromJson(documentSnapshot[index]
                              .data() as Map<String, dynamic>);
                      return ResponsiveHelper.isMobile(context) ||
                              ResponsiveHelper.isTablet(context)
                          ? GestureDetector(
                              onTap: () {
                                tableController.tableNumberController.text =
                                    tableDetailModel.tableNumber;
                                tableController.nameController.text =
                                    tableDetailModel.tableName;
                                tableController.typeController.text =
                                    tableDetailModel.tableType;
                                tableController.descriptionController.text =
                                    tableDetailModel.tableDescription;
                                tableController.priceController.text =
                                    tableDetailModel.tablePrice;
                                AddAndUpdateTableDialog.showCustomDialog(
                                    isDataAddAble: false,
                                    context,
                                    id: tableDetailModel.id,
                                    height: 700.h,
                                    width: 600.w,
                                    tableNumber: tableDetailModel.tableNumber);
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
                                          tableDetailModel.tableName,
                                          fw: FontWeight.w700,
                                          size: 14.sp,
                                          color: ColorConstant.blackColor,
                                        ),
                                        CustomText(
                                          tableDetailModel.tableNumber,
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
                                            tableDetailModel.tableDescription,
                                            fw: FontWeight.w400,
                                            size: 11.sp,
                                            color: ColorConstant.blackColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        CustomText(
                                          tableDetailModel.tablePrice,
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
                                                    "You sure want to delete this table record!",
                                                textFw: FontWeight.bold,
                                                yesAction: () {
                                              tableController.tableDeleteAction(
                                                  tableDetailModel, context);
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
                          : SnookerTableRow(
                              cells: [
                                CustomTableCell(
                                  text: tableDetailModel.tableNumber,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: tableDetailModel.tableName,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: tableDetailModel.tableType,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: tableDetailModel.tableDescription,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: tableDetailModel.tablePrice,
                                  padding: 8.r,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: CustomButtonWidget(
                                        tabAction: () {
                                          tableController
                                                  .tableNumberController.text =
                                              tableDetailModel.tableNumber;
                                          tableController.nameController.text =
                                              tableDetailModel.tableName;
                                          tableController.typeController.text =
                                              tableDetailModel.tableType;
                                          tableController
                                                  .descriptionController.text =
                                              tableDetailModel.tableDescription;
                                          tableController.priceController.text =
                                              tableDetailModel.tablePrice;
                                          AddAndUpdateTableDialog
                                              .showCustomDialog(
                                                  isDataAddAble: false,
                                                  context,
                                                  id: tableDetailModel.id,
                                                  height: 700.h,
                                                  width: 600.w,
                                                  tableNumber: tableDetailModel
                                                      .tableNumber);
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
                                                  "You sure want to delete this table record!",
                                              textFw: FontWeight.bold,
                                              yesAction: () {
                                            tableController.tableDeleteAction(
                                                tableDetailModel, context);
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
                    query: FirebaseTableServices.getTable(
                        tableController.userUid ?? ""),
                    itemBuilderType: PaginateBuilderType.listView,
                    isLive: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    onEmpty: CustomEmptyScreenMessage(
                      icon: Icon(
                        Icons
                            .table_bar_outlined, // or Icons.event_seat if you want chair-style
                        size: 60.sp,
                        color: ColorConstant.greyColor,
                      ),
                      headText: "No Tables Found",
                      subtext:
                          "You haven't created any tables yet.\nAdd at least one table to manage allocations.",
                    ),
                  )
                : ResponsiveHelper.isMobile(context) ||
                        ResponsiveHelper.isTablet(context)
                    ? GestureDetector(
                        onTap: () {
                          tableController.tableNumberController.text =
                              tableController.searchedTable!.tableNumber;
                          tableController.nameController.text =
                              tableController.searchedTable!.tableName;
                          tableController.typeController.text =
                              tableController.searchedTable!.tableType;
                          tableController.descriptionController.text =
                              tableController.searchedTable!.tableDescription;
                          tableController.priceController.text =
                              tableController.searchedTable!.tablePrice;

                          AddAndUpdateTableDialog.showCustomDialog(
                            isDataAddAble: false,
                            context,
                            id: tableController.searchedTable!.id,
                            height: 700.h,
                            width: 600.w,
                            tableNumber:
                                tableController.searchedTable!.tableNumber,
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
                                      tableController.setTableNull();
                                      tableController.searchController.clear();
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
                                    tableController.searchedTable?.tableName ??
                                        "",
                                    fw: FontWeight.w700,
                                    size: 14.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                  CustomText(
                                    tableController
                                            .searchedTable?.tableNumber ??
                                        "",
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
                                      tableController.searchedTable
                                              ?.tableDescription ??
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
                                    tableController.searchedTable?.tablePrice ??
                                        '',
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
                                              "You sure want to delete this table record!",
                                          textFw: FontWeight.bold,
                                          yesAction: () {
                                        tableController.tableDeleteAction(
                                            tableController.searchedTable!,
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
                        ))
                    : SnookerTableRow(
                        cells: [
                          CustomTableCell(
                            text: tableController.searchedTable!.tableNumber,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: tableController.searchedTable!.tableName,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: tableController.searchedTable!.tableType,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text:
                                tableController.searchedTable!.tableDescription,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: tableController.searchedTable!.tablePrice,
                            padding: 8.r,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: CustomButtonWidget(
                                  tabAction: () {
                                    tableController.tableNumberController.text =
                                        tableController
                                            .searchedTable!.tableNumber;
                                    tableController.nameController.text =
                                        tableController
                                            .searchedTable!.tableName;
                                    tableController.typeController.text =
                                        tableController
                                            .searchedTable!.tableType;
                                    tableController.descriptionController.text =
                                        tableController
                                            .searchedTable!.tableDescription;
                                    tableController.priceController.text =
                                        tableController
                                            .searchedTable!.tablePrice;

                                    AddAndUpdateTableDialog.showCustomDialog(
                                      isDataAddAble: false,
                                      context,
                                      id: tableController.searchedTable!.id,
                                      height: 700.h,
                                      width: 600.w,
                                      tableNumber: tableController
                                          .searchedTable!.tableNumber,
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
                                            "You sure want to delete this table record!",
                                        textFw: FontWeight.bold, yesAction: () {
                                      tableController.tableDeleteAction(
                                          tableController.searchedTable!,
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
