import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/employee_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/employee_detail_model.dart';
import 'package:snooker_management/services/employee_services.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/employee_management/add_and_update_employee_dialog.dart';
import 'package:snooker_management/views/screens/employee_management/employee_table_Row.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_image_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

import '../../widgets/custom_empty_screen_message.dart';

class EmployeesTableView extends StatefulWidget {
  const EmployeesTableView({super.key});

  @override
  State<EmployeesTableView> createState() => _EmployeesTableViewState();
}

class _EmployeesTableViewState extends State<EmployeesTableView> {
  EmployeeController employeeController = Get.put(EmployeeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    employeeController.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<EmployeeController>(
      init: EmployeeController(),
      builder: (employeeController) {
        return employeeController.userUid == null
            ? const SizedBox()
            : employeeController.searchedEmployee == null
                ? PaginateFirestore(
                    shrinkWrap: true,
                    itemBuilder: (context, documentSnapshot, index) {
                      EmployeeModel employeeDetailModel =
                          EmployeeModel.fromJson(documentSnapshot[index].data()
                              as Map<String, dynamic>);

                      return ResponsiveHelper.isMobile(context)
                          ? GestureDetector(
                              onTap: () {
                                employeeController.pickImage(null);
                                employeeController.employeeNameController.text =
                                    employeeDetailModel.employeeName;
                                employeeController.employeeNicController.text =
                                    employeeDetailModel.employeeNic;
                                employeeController.employeeTypeController.text =
                                    employeeDetailModel.employeeType;
                                employeeController.employeeContactController
                                    .text = employeeDetailModel.employeeContact;
                                employeeController.employeeAddressController
                                    .text = employeeDetailModel.employeeAddress;
                                employeeController.setEmployeeShift(
                                    employeeDetailModel.shift);

                                AddAndUpdateEmployeeDialog.showCustomDialog(
                                    isDataAddAble: false,
                                    context,
                                    id: employeeDetailModel.id,
                                    employeeImage: employeeDetailModel.image,
                                    employeeName:
                                        employeeDetailModel.employeeName);
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
                                          employeeDetailModel.employeeName,
                                          fw: FontWeight.w700,
                                          size: 14.sp,
                                          color: ColorConstant.blackColor,
                                        ),
                                        CustomText(
                                          employeeDetailModel.shift,
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
                                            employeeDetailModel.employeeAddress,
                                            fw: FontWeight.w400,
                                            size: 11.sp,
                                            color: ColorConstant.blackColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        CustomText(
                                          employeeDetailModel.employeeContact,
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
                                        CustomText(
                                          employeeDetailModel.employeeType,
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
                                                    "You sure want to delete this employee record!",
                                                textFw: FontWeight.bold,
                                                yesAction: () {
                                              employeeController
                                                  .userDeleteAction(
                                                      employeeDetailModel,
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
                          : EmployeeTableRow(
                              cells: [
                                CustomTableCell(
                                  text: employeeDetailModel.employeeName,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: employeeDetailModel.employeeNic,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: employeeDetailModel.employeeType,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: employeeDetailModel.employeeContact,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: employeeDetailModel.employeeAddress,
                                  padding: 8.r,
                                ),
                                CustomTableCell(
                                  text: employeeDetailModel.shift,
                                  padding: 8.r,
                                ),
                                CustomImageWidget(
                                  color: ColorConstant.greyLightColor,
                                  image: employeeDetailModel.image.toString(),
                                  height: 150.h,
                                  width: 30.w,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: CustomButtonWidget(
                                        tabAction: () {
                                          employeeController.pickImage(null);
                                          employeeController
                                                  .employeeNameController.text =
                                              employeeDetailModel.employeeName;
                                          employeeController
                                                  .employeeNicController.text =
                                              employeeDetailModel.employeeNic;
                                          employeeController
                                                  .employeeTypeController.text =
                                              employeeDetailModel.employeeType;
                                          employeeController
                                                  .employeeContactController
                                                  .text =
                                              employeeDetailModel
                                                  .employeeContact;
                                          employeeController
                                                  .employeeAddressController
                                                  .text =
                                              employeeDetailModel
                                                  .employeeAddress;
                                          employeeController.setEmployeeShift(
                                              employeeDetailModel.shift);

                                          AddAndUpdateEmployeeDialog
                                              .showCustomDialog(
                                                  isDataAddAble: false,
                                                  context,
                                                  id: employeeDetailModel.id,
                                                  employeeImage:
                                                      employeeDetailModel.image,
                                                  employeeName:
                                                      employeeDetailModel
                                                          .employeeName);
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
                                                  "You sure want to delete this employee record!",
                                              textFw: FontWeight.bold,
                                              yesAction: () {
                                            employeeController.userDeleteAction(
                                                employeeDetailModel, context);
                                          }, noAction: () {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: ColorConstant.whiteColor,
                                          size: 18.sp,
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
                    query: FirebaseEmployeeServices.getEmployees(
                        employeeController.userUid ?? ""),
                    itemBuilderType: PaginateBuilderType.listView,
                    isLive: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    onEmpty: Center(
                      child: CustomEmptyScreenMessage(
                        icon: Icon(
                          Icons
                              .group_outlined, // Represents a group or team of people
                          size: 60.sp,
                          color: ColorConstant.greyColor,
                        ),
                        headText: "No Employees Found",
                        subtext:
                            "You haven’t added any employees yet.\nPlease add employees to start managing your team.",
                      ),
                    ),
                  )
                : ResponsiveHelper.isMobile(context)
                    ? GestureDetector(
                        onTap: () {
                          employeeController.pickImage(null);
                          employeeController.employeeNameController.text =
                              employeeController.searchedEmployee!.employeeName;
                          employeeController.employeeNicController.text =
                              employeeController.searchedEmployee!.employeeNic;
                          employeeController.employeeTypeController.text =
                              employeeController.searchedEmployee!.employeeType;
                          employeeController.employeeContactController.text =
                              employeeController
                                  .searchedEmployee!.employeeContact;
                          employeeController.employeeAddressController.text =
                              employeeController
                                  .searchedEmployee!.employeeAddress;
                          AddAndUpdateEmployeeDialog.showCustomDialog(
                              isDataAddAble: false,
                              context,
                              id: employeeController.searchedEmployee!.id,
                              employeeImage:
                                  employeeController.searchedEmployee!.image,
                              employeeName: employeeController
                                  .searchedEmployee!.employeeName);
                          employeeController.setEmployeeShift(
                              employeeController.searchedEmployee!.shift);
                        },
                        child: Container(
                          width: mq.width,
                          margin: EdgeInsets.only(bottom: 15.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
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
                                      employeeController.setEmployeeNull();
                                      employeeController.searchController
                                          .clear();
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
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    employeeController
                                            .searchedEmployee?.employeeName ??
                                        "",
                                    fw: FontWeight.w700,
                                    size: 14.sp,
                                    color: ColorConstant.blackColor,
                                  ),
                                  CustomText(
                                    employeeController
                                            .searchedEmployee?.shift ??
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
                                      employeeController.searchedEmployee
                                              ?.employeeAddress ??
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
                                    employeeController.searchedEmployee
                                            ?.employeeContact ??
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomText(
                                    employeeController
                                            .searchedEmployee?.employeeType ??
                                        "",
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
                                              "You sure want to delete this employee record!",
                                          textFw: FontWeight.bold,
                                          yesAction: () {
                                        employeeController.userDeleteAction(
                                            employeeController
                                                .searchedEmployee!,
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
                        ),
                      )
                    : EmployeeTableRow(
                        cells: [
                          CustomTableCell(
                            text: employeeController
                                .searchedEmployee!.employeeName,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: employeeController
                                .searchedEmployee!.employeeNic,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: employeeController
                                .searchedEmployee!.employeeType,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: employeeController
                                .searchedEmployee!.employeeContact,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: employeeController
                                .searchedEmployee!.employeeAddress,
                            padding: 8.r,
                          ),
                          CustomTableCell(
                            text: employeeController.searchedEmployee!.shift,
                            padding: 8.r,
                          ),
                          CustomImageWidget(
                            color: ColorConstant.greyLightColor,
                            image: employeeController.searchedEmployee!.image
                                .toString(),
                            height: 150.h,
                            width: 30.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: CustomButtonWidget(
                                  tabAction: () {
                                    employeeController.pickImage(null);
                                    employeeController
                                            .employeeNameController.text =
                                        employeeController
                                            .searchedEmployee!.employeeName;
                                    employeeController
                                            .employeeNicController.text =
                                        employeeController
                                            .searchedEmployee!.employeeNic;
                                    employeeController
                                            .employeeTypeController.text =
                                        employeeController
                                            .searchedEmployee!.employeeType;
                                    employeeController
                                            .employeeContactController.text =
                                        employeeController
                                            .searchedEmployee!.employeeContact;
                                    employeeController
                                            .employeeAddressController.text =
                                        employeeController
                                            .searchedEmployee!.employeeAddress;
                                    AddAndUpdateEmployeeDialog.showCustomDialog(
                                        isDataAddAble: false,
                                        context,
                                        id: employeeController
                                            .searchedEmployee!.id,
                                        employeeImage: employeeController
                                            .searchedEmployee!.image,
                                        employeeName: employeeController
                                            .searchedEmployee!.employeeName);
                                    employeeController.setEmployeeShift(
                                        employeeController
                                            .searchedEmployee!.shift);
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
                                            "You sure want to delete this employee record!",
                                        textFw: FontWeight.bold, yesAction: () {
                                      employeeController.userDeleteAction(
                                          employeeController.searchedEmployee!,
                                          context);
                                    }, noAction: () {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: ColorConstant.whiteColor,
                                    size: 18.sp,
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
