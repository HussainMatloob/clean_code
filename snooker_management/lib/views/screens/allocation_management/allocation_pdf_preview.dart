import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:snooker_management/controller/allocation_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AllocationPdfPreview extends StatefulWidget {
  const AllocationPdfPreview({
    super.key,
  });

  @override
  State<AllocationPdfPreview> createState() => _AllocationPdfScreenState();
}

class _AllocationPdfScreenState extends State<AllocationPdfPreview> {
  final PdfViewerController pdfController = PdfViewerController();
  final TextEditingController pageController = TextEditingController();
  int totalPages = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllocationController>(
        init: Get.isRegistered<AllocationController>()
            ? null
            : AllocationController(),
        builder: (controller) {
          return Scaffold(
            body:
                // controller.pdfBytes == null
                //     ? const Center(child: CircularProgressIndicator())
                //     : SfPdfViewer.memory(
                //         controller.pdfBytes!,
                //         controller: pdfController,
                //         key: ValueKey(controller.pdfBytes),
                //         onDocumentLoaded: (details) {
                //           setState(() {
                //             totalPages = details.document.pages.count;
                //           });
                //         },
                //       )
                Column(
              children: [
                Expanded(
                  child: controller.pdfBytes == null
                      ? const Center(
                          child: Text(
                          "We couldn’t find any data at the moment. Please refresh the page and try again using the proper steps or process.",
                        ))
                      : PdfPreview(
                          build: (format) async => controller.pdfBytes!,
                          allowPrinting: true,
                          allowSharing: true,
                          canChangePageFormat: true,
                          dpi: 300, //  IMPORTANT
                        ),
                ),
                //_buildBottomBar(),
              ],
            ),
          );
        });
  }

  // Widget _buildBottomBar() {
  //   return Container(
  //     color: Colors.grey.shade200,
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           icon: const Icon(Icons.first_page),
  //           onPressed: () => pdfController.jumpToPage(1),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.chevron_left),
  //           onPressed: () => pdfController.previousPage(),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.chevron_right),
  //           onPressed: () => pdfController.nextPage(),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.last_page),
  //           onPressed: () => pdfController.jumpToPage(totalPages),
  //         ),
  //         const SizedBox(width: 10),
  //         SizedBox(
  //           width: 60,
  //           child: TextField(
  //             controller: pageController,
  //             keyboardType: TextInputType.number,
  //             decoration: const InputDecoration(
  //               hintText: "Page",
  //               isDense: true,
  //               contentPadding:
  //                   EdgeInsets.symmetric(horizontal: 6, vertical: 8),
  //             ),
  //             onSubmitted: (value) {
  //               final page = int.tryParse(value);
  //               if (page != null && page > 0 && page <= totalPages) {
  //                 pdfController.jumpToPage(page);
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text("Invalid page number")),
  //                 );
  //               }
  //             },
  //           ),
  //         ),
  //         const Spacer(),
  //         IconButton(
  //           icon: const Icon(Icons.print),
  //           onPressed: () => Printing.layoutPdf(
  //             onLayout: (format) async => controller.pdfBytes!,
  //           ),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.share),
  //           onPressed: () => Printing.sharePdf(
  //             bytes: controller.pdfBytes!,
  //             filename: "allocation_report.pdf",
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
