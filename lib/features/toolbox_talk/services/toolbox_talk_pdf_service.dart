import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/toolbox_talk_result.dart';

class ToolboxTalkPdfService {
  ToolboxTalkPdfService._();

  static Future<void> generateReport({
    required ToolboxTalkResult result,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            'Toolbox Talk',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),

          _sectionTitle('Topic'),
          pw.Text(result.topic),
          pw.SizedBox(height: 16),

          _sectionTitle('Objective'),
          pw.Text(result.objective),
          pw.SizedBox(height: 16),

          _listSection('Key Hazards', result.keyHazards),

          _listSection('Safety Precautions', result.safetyPrecautions),

          _listSection('Required PPE', result.requiredPpe),

          _listSection('Discussion Questions', result.discussionQuestions),

          _sectionTitle('Supervisor Message'),
          pw.Text(result.supervisorMessage),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Toolbox_Talk_Report.pdf',
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _listSection(String title, List<String> items) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 14),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle(title),
          ...items.map(
            (item) => pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8, bottom: 4),
              child: pw.Text('• $item'),
            ),
          ),
        ],
      ),
    );
  }
}
