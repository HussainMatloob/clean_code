import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:snooker_management/controller/expenses_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OtherExpensesPdfPreviewPage extends StatefulWidget {
  const OtherExpensesPdfPreviewPage({
    super.key,
  });

  @override
  State<OtherExpensesPdfPreviewPage> createState() =>
      _AllocationPdfScreenState();
}

class _AllocationPdfScreenState extends State<OtherExpensesPdfPreviewPage> {
  final PdfViewerController pdfController = PdfViewerController();
  final TextEditingController pageController = TextEditingController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesController>(
      init:
          Get.isRegistered<ExpensesController>() ? null : ExpensesController(),
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: controller.otherExpensepdfBytes == null
                    ? const Center(
                        child: Text(
                        "We couldn’t find any data at the moment. Please refresh the page and try again using the proper steps or process.",
                      ))
                    : PdfPreview(
                        build: (format) async =>
                            controller.otherExpensepdfBytes!,
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
