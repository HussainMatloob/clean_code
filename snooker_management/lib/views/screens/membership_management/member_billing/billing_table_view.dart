import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/member_controller.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/models/member_billing_model.dart';
import 'package:snooker_management/services/membership_services.dart';
import 'package:snooker_management/views/screens/membership_management/member_billing/billing_table_row.dart';
import 'package:snooker_management/views/widgets/custom_alart_dialog.dart';
import 'package:snooker_management/views/widgets/custom_button_widget.dart';
import 'package:snooker_management/views/widgets/custom_table_cell.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class BillingTableView extends StatefulWidget {
  const BillingTableView({super.key});

  @override
  State<BillingTableView> createState() => _BillingTableViewState();
}

class _BillingTableViewState extends State<BillingTableView> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<MemberController>(
      init: MemberController(),
      builder: (memberController) {
        return SizedBox(
          height: mq.width * 0.3,
          child: memberController.searchedMemberBill == null
              ? PaginateFirestore(
                  itemBuilder: (context, documentSnapshot, index) {
                    MemberBillingModel memberBillingModel =
                        MemberBillingModel.fromJson(documentSnapshot[index]
                            .data() as Map<String, dynamic>);

                    return BillingTableRow(
                      cells: [
                        CustomTableCell(
                          text: memberBillingModel.memberName,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: memberBillingModel.packageName,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: memberBillingModel.packageDuration,
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: memberBillingModel.packagePrice.toString(),
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: memberBillingModel.paymentMethod.toString(),
                          padding: 8.r,
                        ),
                        CustomTableCell(
                          text: memberController
                              .formatDate(memberBillingModel.billDate!),
                          padding: 8.r,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 5.w,
                              ),
                              CustomButtonWidget(
                                tabAction: () {
                                  CustomAlertDialog.CustomDialog(context,
                                      text: "You sure delete this Member Bill!",
                                      textFw: FontWeight.bold, yesAction: () {
                                    memberController.memberBillDeleteAction(
                                        memberBillingModel, context);
                                  }, noAction: () {
                                    Navigator.of(context).pop();
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: ColorConstant.whiteColor,
                                  size: 20.sp,
                                ),
                                height: 50.h,
                                width: 40.w,
                                buttonColor: ColorConstant.redColor,
                              ),
                            ],
                          ),
                        ),

                        // _buildTableCellImage(employeeDetailModel.image.toString()),
                      ],
                    );
                  },
                  query: FirebaseMembershipServices.getMembersBill(
                      memberController.userUid ?? ""),
                  itemBuilderType: PaginateBuilderType.listView,
                  isLive: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  onEmpty: Center(
                    child: CustomText(
                      "There is no any record",
                      size: 20.sp,
                      color: ColorConstant.whiteColor,
                    ),
                  ),
                )
              : BillingTableRow(
                  cells: [
                    CustomTableCell(
                      text: memberController.searchedMemberBill!.memberName,
                      padding: 8.r,
                    ),
                    CustomTableCell(
                      text: memberController.searchedMemberBill!.packageName,
                      padding: 8.r,
                    ),
                    CustomTableCell(
                      text:
                          memberController.searchedMemberBill!.packageDuration,
                      padding: 8.r,
                    ),
                    CustomTableCell(
                      text: memberController.searchedMemberBill!.packagePrice
                          .toString(),
                      padding: 8.r,
                    ),
                    CustomTableCell(
                      text: memberController.searchedMemberBill!.paymentMethod,
                      padding: 8.r,
                    ),
                    CustomTableCell(
                      text: memberController.formatDate(
                          memberController.searchedMemberBill!.billDate!),
                      padding: 8.r,
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButtonWidget(
                            tabAction: () {
                              CustomAlertDialog.CustomDialog(context,
                                  text: "You sure delete this Member Bill!",
                                  textFw: FontWeight.bold, yesAction: () {
                                memberController.memberBillDeleteAction(
                                    memberController.searchedMemberBill!,
                                    context);
                              }, noAction: () {
                                Navigator.of(context).pop();
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: ColorConstant.whiteColor,
                              size: 20.sp,
                            ),
                            height: 50.h,
                            width: 40.w,
                            buttonColor: ColorConstant.redColor,
                          )
                        ],
                      ),
                    ),

                    // _buildTableCellImage(employeeDetailModel.image.toString()),
                  ],
                ),
        );
      },
    );
  }
}
