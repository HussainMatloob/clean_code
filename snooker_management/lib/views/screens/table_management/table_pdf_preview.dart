import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/table_controller.dart';
import 'package:snooker_management/models/table_details_model.dart';

//With Left Right Arrow
class TablePdfPreviewPage extends StatelessWidget {
  const TablePdfPreviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableController>(
      init: Get.isRegistered<TableController>() ? null : TableController(),
      builder: (tableController) {
        // Generate the page for the current data
        pw.Document currentPagePdf = pw.Document();
        // Get the current page data dynamically
        if (tableController.allPages.isEmpty ||
            tableController.allPages == []) {
        } else {
          List<TableDetailModel> currentPageData =
              tableController.allPages[tableController.currentPage - 1];

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
                                    pw.MemoryImage(tableController.image!),
                                    width: 40.w,
                                    height: 40.h,
                                    fit: pw.BoxFit.cover)),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 10.w),
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'Tables Report',
                                      style: pw.TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      tableController.snookerName ?? "",
                                      style: pw.TextStyle(
                                        fontSize: 7.sp,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      '(Page ${tableController.currentPage})',
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
                        'Table Number',
                        'Name',
                        'Type',
                        'Description',
                        'Price'
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
                      data: currentPageData.map((table) {
                        return [
                          table.tableNumber,
                          table.tableName,
                          table.tableType,
                          table.tableDescription.length > 15
                              ? '${table.tableDescription.substring(0, 15)}...'
                              : table.tableDescription,
                          table.tablePrice,
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
          body: tableController.allPages.isEmpty ||
                  tableController.allPages == []
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
                          onPressed: () => tableController.goToFirstPage(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => tableController.goToPreviousPage(),
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
                                  tableController.currentPage;
                              tableController.goToPage(
                                  pageNumber, tableController.totalPages);
                            },
                          ),
                        ),
                        Text(
                            'Page ${tableController.currentPage} of ${tableController.totalPages}'),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => tableController
                                .goToNextPage(tableController.totalPages)),
                        IconButton(
                          icon: const Icon(Icons.last_page),
                          onPressed: () => tableController
                              .goToLastPage(tableController.totalPages),
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
