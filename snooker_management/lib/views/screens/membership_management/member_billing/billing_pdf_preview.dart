import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:snooker_management/controller/member_controller.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class MemberBillingPdfPreviewPage extends StatelessWidget {
  final String snookerName;
  final Uint8List image;
  final int totalPages;
  final List<List<dynamic>> allPages;
  const MemberBillingPdfPreviewPage({
    super.key,
    required this.snookerName,
    required this.totalPages,
    required this.allPages,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemberController>(
      init: MemberController(),
      builder: (memberController) {
        // Get current page data
        List<dynamic> currentPageData =
            allPages[memberController.currentPage - 1];

        // Generate the page for the current data
        pw.Document currentPagePdf = pw.Document();
        currentPagePdf.addPage(
          pw.Page(
            margin: pw.EdgeInsets.all(14.w),
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  pw.Container(
                    height: 60.h,
                    padding: pw.EdgeInsets.all(10.r),
                    width: Get.width,
                    color: PdfColor.fromHex("#aaddfbd9"),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Container(
                              child: pw.Image(pw.MemoryImage(image),
                                  width: 40.w,
                                  height: 40.h,
                                  fit: pw.BoxFit.cover)),
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 10.w),
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Members Billing Report',
                                    style: pw.TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.Text(
                                    snookerName,
                                    style: pw.TextStyle(
                                      fontSize: 7.sp,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.Text(
                                    '(Page ${memberController.currentPage})',
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
                      'Member Name',
                      'Package',
                      'Duration',
                      'Amount',
                      'Payment Method',
                      'Billing Date',
                      'Start Date',
                      'End Date'
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
                    data: currentPageData.map((employee) {
                      return [
                        employee.memberName,
                        employee.packageName,
                        employee.packageDuration,
                        employee.packagePrice,
                        employee.paymentMethod,
                        memberController.formatDate(employee.billDate!),
                        memberController.formatDate(employee.startDate!),
                        memberController.formatDate(employee.endDate!)
                      ];
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: CustomText("Members Report"),
          ),
          body: Column(
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
                    onPressed: () => memberController.goToFirstPage(),
                  ),
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => memberController.goToPreviousPage()),
                  SizedBox(
                    width: 50.w,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(hintText: "Go to page"),
                      onSubmitted: (value) {
                        final pageNumber =
                            int.tryParse(value) ?? memberController.currentPage;
                        memberController.goToPage(pageNumber, totalPages);
                      },
                    ),
                  ),
                  CustomText(
                      'Page ${memberController.currentPage} of $totalPages'),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () =>
                          memberController.goToNextPage(totalPages)),
                  IconButton(
                    icon: const Icon(Icons.last_page),
                    onPressed: () => memberController.goToLastPage(totalPages),
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
