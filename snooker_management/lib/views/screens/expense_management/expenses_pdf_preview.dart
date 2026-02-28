import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/expenses_controller.dart';

//With Left Right Arrow
class ExpensesPdfPreviewPage extends StatelessWidget {
  const ExpensesPdfPreviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesController>(
      init:
          Get.isRegistered<ExpensesController>() ? null : ExpensesController(),
      builder: (expensesController) {
        pw.Document currentPagePdf = pw.Document();
        // Get the current page data dynamically
        if (expensesController.allPages.isEmpty ||
            expensesController.allPages == []) {
        } else {
          // Ensure we are not trying to access a page out of bounds
          final currentPageData =
              expensesController.allPages[expensesController.currentPage - 1];
          // Create the PDF for the current page

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
                                    pw.MemoryImage(expensesController.image!),
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
                                      'Expenses',
                                      style: pw.TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      expensesController.snookerName ?? "",
                                      style: pw.TextStyle(
                                        fontSize: 7.sp,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      '(Page ${expensesController.currentPage})',
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
                        'Expense Name',
                        'Description',
                        'Amount',
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
                      data: currentPageData.map((expense) {
                        return [
                          expense.expenseName,
                          expense.expenseDescription.length > 50
                              ? '${expense.expenseDescription.substring(0, 50)}...'
                              : expense.expenseDescription,
                          expense.expenseAmount,
                          expensesController.formatDate(expense.expenseDate!),
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
          body: expensesController.allPages.isEmpty ||
                  expensesController.allPages == []
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
                          onPressed: () => expensesController.goToFirstPage(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () =>
                              expensesController.goToPreviousPage(),
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
                                  expensesController.currentPage;
                              expensesController.goToPage(
                                  pageNumber, expensesController.totalPages);
                            },
                          ),
                        ),
                        Text(
                            'Page ${expensesController.currentPage} of ${expensesController.totalPages}'),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => expensesController
                                .goToNextPage(expensesController.totalPages)),
                        IconButton(
                          icon: const Icon(Icons.last_page),
                          onPressed: () => expensesController
                              .goToLastPage(expensesController.totalPages),
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
