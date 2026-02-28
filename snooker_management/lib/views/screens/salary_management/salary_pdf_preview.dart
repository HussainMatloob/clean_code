import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/salary_controller.dart';
import 'package:snooker_management/models/salary_model.dart';

//With Left Right Arrow
class SalaryPdfPreviewPage extends StatelessWidget {
  const SalaryPdfPreviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalaryController>(
      init: Get.isRegistered<SalaryController>() ? null : SalaryController(),
      builder: (salaryController) {
        // Get current page data

        // Generate the page for the current data
        pw.Document currentPagePdf = pw.Document();
        // Get the current page data dynamically
        if (salaryController.allPages.isEmpty ||
            salaryController.allPages == []) {
        } else {
          // Ensure we are not trying to access a page out of bounds
          List<SalaryModel> currentPageData =
              salaryController.allPages[salaryController.currentPage - 1];

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
                                    pw.MemoryImage(salaryController.image!),
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
                                      'Salary Report',
                                      style: pw.TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      salaryController.snookerName ?? "",
                                      style: pw.TextStyle(
                                        fontSize: 7.sp,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      '(Page ${salaryController.currentPage})',
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
                        'Employee Name',
                        'Employee Salary',
                        'Shift',
                        'Date'
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
                      data: currentPageData.map((salary) {
                        return [
                          salary.employeeName,
                          salary.employeeSalary,
                          salary.shift,
                          salaryController.formatDate(salary.date!),
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
          body: salaryController.allPages.isEmpty ||
                  salaryController.allPages == []
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
                          onPressed: () => salaryController.goToFirstPage(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => salaryController.goToPreviousPage(),
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
                                  salaryController.currentPage;
                              salaryController.goToPage(
                                  pageNumber, salaryController.totalPages);
                            },
                          ),
                        ),
                        Text(
                            'Page ${salaryController.currentPage} of ${salaryController.totalPages}'),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => salaryController
                                .goToNextPage(salaryController.totalPages)),
                        IconButton(
                          icon: const Icon(Icons.last_page),
                          onPressed: () => salaryController
                              .goToLastPage(salaryController.totalPages),
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
