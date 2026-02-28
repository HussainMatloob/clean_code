import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/reports_controller.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';

class ReportGraphsScreen extends StatefulWidget {
  const ReportGraphsScreen({super.key});

  @override
  State<ReportGraphsScreen> createState() => _ReportGraphsScreenState();
}

class _ReportGraphsScreenState extends State<ReportGraphsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsController>(
      init: ReportsController(),
      builder: (reportsController) {
        return SizedBox(
          width: 600.w,
          child: PieChart(
            dataMap: {
              "Profit": reportsController.profitAndLoss[1],
              "Loss": reportsController.profitAndLoss[2],
            },
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true,
            ),
            chartRadius: ResponsiveHelper.isMobile(context)
                ? MediaQuery.of(context).size.width / 4.2
                : MediaQuery.of(context).size.width / 8.2,
            legendOptions: const LegendOptions(
              legendPosition: LegendPosition.left,
            ),
            animationDuration: const Duration(milliseconds: 1200),
            chartType: ChartType.disc,
            colorList: ColorConstant.piaChartColorList,
          ),
        );
      },
    );
  }
}
