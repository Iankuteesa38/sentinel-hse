import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../models/inspection_report_data.dart';
import '../services/inspection_pdf_service.dart';

class InspectionPdfPreviewPage extends StatelessWidget {
  final InspectionReportData reportData;

  const InspectionPdfPreviewPage({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Report'), centerTitle: true),
      body: PdfPreview(
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        allowPrinting: true,
        allowSharing: true,
        pdfFileName: 'Sentinel_HSE_Inspection_Report.pdf',
        build: (pageFormat) {
          return InspectionPdfService.generate(pageFormat, reportData);
        },
      ),
    );
  }
}
