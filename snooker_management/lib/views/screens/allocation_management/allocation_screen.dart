import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/allocation_controller.dart';

import 'package:snooker_management/services/allocation_services.dart';
import 'package:snooker_management/views/screens/allocation_management/report_generator_views.dart';
import 'package:snooker_management/views/screens/allocation_management/tables_view.dart';
import 'package:snooker_management/views/widgets/custom_empty_screen_message.dart';

import '../../../models/table_details_model.dart';

class AllocationScreenPage extends StatefulWidget {
  final String? snookerLogo;
  const AllocationScreenPage({super.key, this.snookerLogo});
  @override
  State<AllocationScreenPage> createState() => _AllocationScreenPageState();
}

class _AllocationScreenPageState extends State<AllocationScreenPage> {
  AllocationController allocationController = Get.put(AllocationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      allocationController.initialmethodsOfAllocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllocationController>(
      builder: (allocationController) {
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
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: Column(
            children: [
              Column(
                children: [
                  // Icon Button for toggling
                  Center(
                    child: InkWell(
                      onTap: () {
                        allocationController.showOrHideReportOption();
                      },
                      child: Icon(
                        allocationController.isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                      ),
                    ),
                  ),
                  // Data to show/hide
                  AnimatedSwitcher(
                    duration:
                        const Duration(milliseconds: 700), // Smooth transition
                    child: allocationController.isExpanded
                        ? Container(
                            key: const ValueKey(1), // Key for animation
                            padding: EdgeInsets.all(20.r),
                            color: Colors.transparent,
                            child: ReportGeneratorView(
                              snookerLogo: widget.snookerLogo,
                            ))
                        : const SizedBox(), // Empty space
                  ),
                ],
              ),
              Expanded(
                child: Container(
                    child: StreamBuilder(
                        stream: allocationController.useruid == null ||
                                allocationController.useruid!.isEmpty
                            ? Stream.value(null) // empty stream, so no crash
                            : FirebaseAllocationServices.getTablesForAllocation(
                                allocationController.useruid!),
                        // stream:
                        //     FirebaseAllocationServices.getTablesForAllocation(
                        //         allocationController.useruid ?? ""),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return CustomEmptyScreenMessage(
                                icon: Icon(
                                  Icons.event_seat,
                                  size: 60.sp,
                                  color: ColorConstant.greyColor,
                                ),
                                headText: "No Allocations Yet",
                                subtext:
                                    "You haven't created any table allocations.\nPlease add at least one table to proceed.",
                              );
                            } else {
                              var data = snapshot.data?.docs;
                              List<TableDetailModel> tables = data
                                      ?.map((e) =>
                                          TableDetailModel.fromJson(e.data()))
                                      .toList() ??
                                  [];
                              return allocationController
                                          .allocationsStatus.length ==
                                      tables.length
                                  ? GridView.builder(
                                      padding: EdgeInsets.all(5.w),
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            250, // max width per table
                                        crossAxisSpacing: 20.w,
                                        mainAxisSpacing: 20.h,
                                        childAspectRatio:
                                            0.8, // width / height ratio, adjust as needed
                                      ),
                                      itemCount: tables.length,
                                      itemBuilder: (context, index) {
                                        return TablesView(
                                          tableModel: tables[index],
                                          index: index,
                                        );
                                      },
                                    )
                                  : SizedBox();
                            }
                          } else {
                            return SizedBox(
                                height: 50.h,
                                width: 50.w,
                                child: const Center(
                                    child: CircularProgressIndicator()));
                          }
                        })),
              )
            ],
          ),
        );
      },
    );
  }
}
