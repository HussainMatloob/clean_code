import 'package:flutter/material.dart';
import 'package:snooker_management/constants/color_constants.dart';
class PackageTableRow extends StatelessWidget {
  final bool? isHeader;
  final List<Widget> cells;
  const PackageTableRow({super.key, this.isHeader=false, required this.cells});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader==true ? ColorConstant.rowHeaderColor : null,
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
      ),
      child: Table(
        defaultVerticalAlignment: isHeader==true
            ? TableCellVerticalAlignment.middle
            : TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
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