import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/controller/employee_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/screens/employee_management/employee_table_Row.dart';
import 'package:snooker_management/views/screens/employee_management/add_and_update_employee_dialog.dart';
import 'package:snooker_management/views/screens/employee_management/employees_table_view.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';
import '../../../constants/color_constants.dart';
import '../../../controller/auth_controller.dart';
import '../../../main.dart';
import '../../widgets/custom_button_widget.dart';

class EmployeeScreen extends StatefulWidget {
  final String? snookerLogo;
  const EmployeeScreen({super.key, this.snookerLogo});
  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  EmployeeController employeeController = Get.put(EmployeeController());
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<EmployeeController>(
      init: EmployeeController(),
      builder: (employeeController) {
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
                          mainAxisAlignment: ResponsiveHelper.isMobile(context)
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            CustomButtonWidget(
                              sizedBoxWidth: 10.w,
                              tabAction: () {
                                employeeController.setSelectedShiftNull();
                                employeeController.pickImage(null);
                                employeeController.employeeNameController
                                    .clear();
                                employeeController.employeeNicController
                                    .clear();
                                employeeController.employeeTypeController
                                    .clear();
                                employeeController.employeeContactController
                                    .clear();
                                employeeController.employeeAddressController
                                    .clear();
                                AddAndUpdateEmployeeDialog.showCustomDialog(
                                  isDataAddAble: true,
                                  context,
                                );
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
                                size: 12.sp,
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: ResponsiveHelper.isMobile(context)
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            CustomButtonWidget(
                              sizedBoxWidth: 10.w,
                              tabAction: () {
                                employeeController
                                    .generateEmployeereport(context);
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
                                size: 12.sp,
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: ResponsiveHelper.isMobile(context)
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomTextFormField(
                              controller: employeeController.searchController,
                              width: 200.w,
                              height: mq.height * 0.04,
                              horizontalPadding: 10.w,
                              labelText: "Search by contact or NIC",
                              hintTextSize: 12.sp,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // Allow only digits
                              ],
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            employeeController.isEmployeeSearching
                                ? SizedBox(
                                    height: ResponsiveHelper.isMobile(context)
                                        ? 20.h
                                        : 30.h,
                                    width: ResponsiveHelper.isMobile(context)
                                        ? 20.w
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
                                      if (employeeController
                                          .searchController.text
                                          .toString()
                                          .isNotEmpty) {
                                        employeeController
                                            .employeeSearchingProgress(true);
                                        employeeController
                                            .searchEmployee(context);
                                      }
                                    },
                                  ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Visibility(
                              visible: !ResponsiveHelper.isMobile(context),
                              child: CustomButtonWidget(
                                radius: 5.r,
                                height: mq.height * 0.04,
                                paddingHorizontal: 8.w,
                                buttonColor: ColorConstant.blueColor,
                                sizedBoxWidth: 4.w,
                                text: "Clear",
                                textSize: 10.sp,
                                tabAction: () {
                                  employeeController.setEmployeeNull();
                                  employeeController.searchController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Visibility(
                          visible: !ResponsiveHelper.isMobile(context),
                          child: EmployeeTableRow(
                            cells: [
                              CustomTableCell(
                                text: "Name",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "NIC",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Type",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Contact",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Address",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Shift",
                                textColor: ColorConstant.primaryColor,
                                textFw: FontWeight.bold,
                              ),
                              CustomTableCell(
                                text: "Image",
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
                        const EmployeesTableView(),
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
