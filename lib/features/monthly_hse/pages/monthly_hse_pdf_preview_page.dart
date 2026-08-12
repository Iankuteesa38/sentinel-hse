import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../models/monthly_hse_report_data.dart';
import '../services/monthly_hse_pdf_service.dart';

class MonthlyHsePdfPreviewPage extends StatelessWidget {
  final MonthlyHseReportData data;

  const MonthlyHsePdfPreviewPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${data.periodLabel} HSE Report'),
        centerTitle: true,
      ),
      body: PdfPreview(
        build: (pageFormat) => MonthlyHsePdfService.generate(pageFormat, data),
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: true,
        canChangeOrientation: true,
      ),
    );
  }
}
