import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:snooker_management/controller/table_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TablePdfPreviewPage extends StatefulWidget {
  const TablePdfPreviewPage({
    super.key,
  });

  @override
  State<TablePdfPreviewPage> createState() => _AllocationPdfScreenState();
}

class _AllocationPdfScreenState extends State<TablePdfPreviewPage> {
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
    return GetBuilder<TableController>(
      init: Get.isRegistered<TableController>() ? null : TableController(),
      builder: (controller) {
        return Scaffold(
          body: Column(
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
            ],
          ),
        );
      },
    );
  }
}
