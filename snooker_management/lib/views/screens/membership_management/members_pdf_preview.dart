import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/controller/member_controller.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class MemberPdfPreviewPage extends StatelessWidget {
  const MemberPdfPreviewPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemberController>(
      init: Get.isRegistered<MemberController>() ? null : MemberController(),
      builder: (memberController) {
        // Generate the page for the current data
        pw.Document currentPagePdf = pw.Document();
        // Get the current page data dynamically
        if (memberController.allPages.isEmpty ||
            memberController.allPages == []) {
        } else {
          List<dynamic> currentPageData =
              memberController.allPages[memberController.currentPage - 1];

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
                                    pw.MemoryImage(memberController.image!),
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
                                      'Members Report',
                                      style: pw.TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    pw.Text(
                                      memberController.snookerName ?? "",
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
                        'Contact',
                        'Address',
                        'Package',
                        "Price",
                        "Duration",
                        'NIC',
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
                      data: currentPageData.map((member) {
                        return [
                          member.memberName.length > 25
                              ? '${member.memberName.substring(0, 25)}...'
                              : member.memberName,
                          member.memberContact,
                          member.memberAddress.length > 15
                              ? '${member.memberAddress.substring(0, 15)}...'
                              : member.memberAddress,
                          member.packageName,
                          member.packagePrice,
                          member.packageDuration,
                          member.memberNic,
                          memberController.formatDate(member.startDate!),
                          memberController.formatDate(member.endDate!)
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
          body: memberController.allPages.isEmpty ||
                  memberController.allPages == []
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
                          onPressed: () => memberController.goToFirstPage(),
                        ),
                        IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () =>
                                memberController.goToPreviousPage()),
                        SizedBox(
                          width: 50.w,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration:
                                const InputDecoration(hintText: "Go to page"),
                            onSubmitted: (value) {
                              final pageNumber = int.tryParse(value) ??
                                  memberController.currentPage;
                              memberController.goToPage(
                                  pageNumber, memberController.totalPages);
                            },
                          ),
                        ),
                        CustomText(
                            'Page ${memberController.currentPage} of ${memberController.totalPages}'),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => memberController
                                .goToNextPage(memberController.totalPages)),
                        IconButton(
                          icon: const Icon(Icons.last_page),
                          onPressed: () => memberController
                              .goToLastPage(memberController.totalPages),
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
