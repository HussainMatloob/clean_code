import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/allocation_controller.dart';
import 'package:snooker_management/models/allocation_model.dart';

//With Left Right Arrow
class AllocationPdfPreview extends StatelessWidget {
  const AllocationPdfPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final allocationController = Get.find<AllocationController>();
    return GetBuilder<AllocationController>(
      init: Get.isRegistered<AllocationController>()
          ? null
          : AllocationController(),
      builder: (allocationController) {
        // Get current page data
        pw.Document currentPagePdf = pw.Document();
        if (allocationController.allPages?.isEmpty == null) {
        } else {
          List<AllocationModel> currentPageData = allocationController
              .allPages![allocationController.currentPage - 1];
          // Generate the page for the current data

          currentPagePdf.addPage(
            pw.Page(
              margin: pw.EdgeInsets.all(14.w),
              build: (pw.Context context) {
                return pw.Column(
                  children: [
                    pw.Container(
                      height: 60.h,
                      padding: pw.EdgeInsets.all(10.r),
                      color: PdfColor.fromHex("#aaddfbd9"),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Container(
                              child: pw.Image(
                                pw.MemoryImage(allocationController
                                    .image!), // Display the image from bytes
                                width: 40.0, // Set width
                                height: 40.0, // Set height
                                fit: pw.BoxFit.cover, // Optional fit
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 10.w),
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'Allocations Report',
                                      style: pw.TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      '${allocationController.snookerName}',
                                      style: pw.TextStyle(
                                        fontSize: 7.sp,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      '(Page ${allocationController.currentPage})',
                                      style: pw.TextStyle(
                                        fontSize: 6.sp,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                  ]),
                            )
                          ]),
                    ),
                    pw.SizedBox(height: 14.h),
                    pw.Table.fromTextArray(
                      headers: [
                        'Table',
                        'Game',
                        'Amount',
                        "Players",
                        "Start_Time",
                        "End_Time",
                        "Total_Time",
                        "date"
                      ],
                      headerStyle: pw.TextStyle(
                        fontSize: 5.sp,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                      headerDecoration: const pw.BoxDecoration(
                        color: PdfColors.grey300, // Set header background color
                      ),
                      cellStyle: pw.TextStyle(
                        fontSize: 4.sp, // Set data row text size
                      ),
                      data: currentPageData.map((allocations) {
                        return [
                          allocations.tableNumber,
                          allocations.gameType,
                          allocations.totalAmount,
                          allocationController
                              .getPlayersList(allocations.playersName),
                          allocations.startTime,
                          allocations.endTime,
                          allocations.totalTime,
                          allocationController.formatDate(allocations.date!),
                        ];
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return Scaffold(
          body: allocationController.allPages?.isEmpty == null
              ? Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "We couldn’t find any data at the moment. Please refresh the page and try again using the proper steps or process.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: ColorConstant.blackColor),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: PdfPreview(
                        build: (format) async => currentPagePdf.save(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.first_page),
                          onPressed: () => allocationController.goToFirstPage(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () =>
                              allocationController.goToPreviousPage(),
                        ),
                        SizedBox(
                          width: 50.w,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration:
                                const InputDecoration(hintText: "Go to page"),
                            onSubmitted: (value) {
                              final pageNumber = int.tryParse(value) ??
                                  allocationController.currentPage;
                              allocationController.goToPage(
                                  pageNumber, allocationController.totalPages);
                            },
                          ),
                        ),
                        Text(
                            'Page ${allocationController.currentPage} of ${allocationController.totalPages}'),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => allocationController
                                .goToNextPage(allocationController.totalPages)),
                        IconButton(
                          icon: const Icon(Icons.last_page),
                          onPressed: () => allocationController
                              .goToLastPage(allocationController.totalPages),
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}
