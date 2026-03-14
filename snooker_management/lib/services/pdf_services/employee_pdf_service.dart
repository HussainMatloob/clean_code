import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:snooker_management/models/employee_detail_model.dart';

class EmployeePdfService {
  static Future<Uint8List> generatePdf({
    required List<EmployeeModel> employees,
    required String snookerName,
    Uint8List? image,
  }) async {
    final pdf = pw.Document();
    final logo = image != null ? pw.MemoryImage(image) : null;

    final fontData = await rootBundle.load("fonts/Roboto-Regular.ttf");
    final helvetica = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildHeader(snookerName, logo, helvetica),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            "Page ${context.pageNumber} of ${context.pagesCount}",
            style: pw.TextStyle(font: helvetica, fontSize: 10),
          ),
        ),
        build: (context) => [
          pw.SizedBox(height: 10),
          _buildTable(employees, helvetica),
        ],
      ),
    );

    final bytes = await pdf.save();
    return bytes;
  }

  static pw.Widget _buildHeader(
      String name, pw.MemoryImage? logo, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(width: 1)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          if (logo != null) pw.Image(logo, width: 40, height: 40),
          pw.Text(
            name,
            style: pw.TextStyle(
                font: font, fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(width: 40),
        ],
      ),
    );
  }

  static pw.Widget _buildTable(List<EmployeeModel> data, pw.Font font) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.4),
      columnWidths: const {
        0: pw.FlexColumnWidth(),
        1: pw.FlexColumnWidth(),
        2: pw.FlexColumnWidth(),
        3: pw.FlexColumnWidth(),
        4: pw.FlexColumnWidth(),
        5: pw.FlexColumnWidth(),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _cell('Employee Name', font),
            _cell('NIC', font),
            _cell('Type', font),
            _cell('Contact', font),
            _cell('Address', font),
            _cell('shift', font),
          ],
        ),
        ...data.map((e) => pw.TableRow(
              children: [
                _cell(e.employeeName ?? "", font),
                _cell(e.employeeNic, font),
                _cell(e.employeeType ?? "", font),
                _cell(e.employeeContact ?? "", font),
                _cell(
                    e.employeeAddress.length > 40
                        ? '${e.employeeAddress.substring(0, 40)}...'
                        : e.employeeAddress,
                    font),
                _cell(e.shift ?? "", font),
              ],
            ))
      ],
    );
  }

  static pw.Widget _cell(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 9),
        maxLines: 2,
        overflow: pw.TextOverflow.clip,
      ),
    );
  }
}
