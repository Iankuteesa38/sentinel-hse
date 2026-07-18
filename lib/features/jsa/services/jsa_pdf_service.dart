import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/jsa_result.dart';

class JsaPdfService {
  JsaPdfService._();

  static Future<void> generateReport({required JsaResult result}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            'Job Safety Analysis',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),

          _sectionTitle('Task'),
          pw.Text(result.task),
          pw.SizedBox(height: 20),

          ...result.steps.asMap().entries.map((entry) {
            final stepNumber = entry.key + 1;
            final step = entry.value;

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 16),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Job Step $stepNumber',
                    style: pw.TextStyle(
                      fontSize: 17,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6),

                  pw.Text(
                    step.jobStep,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  _listSection('Hazards', step.hazards),
                  _listSection('Control Measures', step.controlMeasures),
                  _listSection('Required PPE', step.requiredPpe),

                  pw.Text('Responsible Person: ${step.responsiblePerson}'),
                ],
              ),
            );
          }),

          _listSection('Required Permits', result.permits),

          _listSection('Emergency Requirements', result.emergencyRequirements),

          _listSection('Applicable Standards', result.applicableStandards),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'AI_JSA_Report.pdf',
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
      padding: const pw.EdgeInsets.only(bottom: 10),
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
