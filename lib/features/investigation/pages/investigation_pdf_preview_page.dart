import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../models/investigation_draft.dart';
import '../services/investigation_pdf_service.dart';

class InvestigationPdfPreviewPage extends StatelessWidget {
  final InvestigationDraft draft;

  const InvestigationPdfPreviewPage({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigation PDF Preview'),
        centerTitle: true,
      ),
      body: PdfPreview(
        build: (pageFormat) =>
            InvestigationPdfService.generate(pageFormat, draft),
        canChangePageFormat: true,
        canChangeOrientation: true,
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }
}
