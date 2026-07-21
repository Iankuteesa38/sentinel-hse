import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/risk_assessment_result.dart';

class RiskAssessmentPdfService {
  RiskAssessmentPdfService._();

  static Future<void> generateReport({
    required RiskAssessmentResult result,
  }) async {
    final pdf = pw.Document();
    final formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    final formattedTime = DateFormat('HH:mm').format(DateTime.now());
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 48, 32, 32),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'SENTINEL HSE AI',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text(
              'AI Risk Assessment Report',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Center(
            child: pw.Text(
              'Generated: $formattedDate, $formattedTime',
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
          pw.SizedBox(height: 24),

          _sectionTitle('Task'),
          pw.Text(result.task),
          pw.SizedBox(height: 20),

          _listSection('Hazards', result.hazards),
          _listSection('Persons at Risk', result.personsAtRisk),
          _listSection('Existing Controls', result.existingControls),
          _listSection('Additional Controls', result.additionalControls),
          _textSection('Initial Risk', result.initialRisk),
          _textSection('Residual Risk', result.residualRisk),
          _listSection('Required PPE', result.requiredPpe),
          _listSection('Required Permits', result.requiredPermits),
          _listSection('Emergency Response', result.emergencyResponse),
          _listSection('Applicable Standards', result.applicableStandards),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'AI_Risk_Assessment_Report.pdf',
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
      padding: const pw.EdgeInsets.only(bottom: 12),
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

  static pw.Widget _textSection(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [_sectionTitle(title), pw.Text(value)],
      ),
    );
  }
}
