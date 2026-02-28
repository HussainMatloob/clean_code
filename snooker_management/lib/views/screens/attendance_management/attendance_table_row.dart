import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/constants/color_constants.dart';

class AttendanceTableRow extends StatelessWidget {
  final bool? isHeader;
  final List<Widget> cells;
  final Color? headRowColor;
  final Color? rowsColor;
  final double? padding;
  const AttendanceTableRow(
      {super.key,
      this.isHeader = false,
      required this.cells,
      this.headRowColor,
      this.rowsColor,
      this.padding});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: padding ?? 20.h),
      decoration: BoxDecoration(
        color: isHeader == true
            ? headRowColor ?? ColorConstant.rowHeaderColor
            : rowsColor ?? Colors.transparent,
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
      ),
      child: Table(
        defaultVerticalAlignment: isHeader == true
            ? TableCellVerticalAlignment.middle
            : TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            children: cells,
          ),
        ],
      ),
    );
  }
}
