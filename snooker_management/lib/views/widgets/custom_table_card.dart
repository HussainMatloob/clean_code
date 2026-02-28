import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/models/table_details_model.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class CustomTableCard extends StatelessWidget {
  final double? height;
  final double? width;
  final TableDetailModel? tableDetailModel;
  final Color? cardColor;
  final double? radius;
  final VoidCallback? onTap;
  const CustomTableCard(
      {super.key,
      this.height,
      this.width,
      this.tableDetailModel,
      this.cardColor,
      this.radius,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(radius ?? 4.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(tableDetailModel!.id),
        ],
      ),
    );
  }
}
