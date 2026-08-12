import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/jsa_result.dart';
import '../../branding/models/branding_settings.dart';
import '../../branding/services/branding_service.dart';

class JsaPdfService {
  JsaPdfService._();

  static final PdfColor _navy = PdfColor.fromInt(0xFF123B5D);
  static final PdfColor _blue = PdfColor.fromInt(0xFF1D6FA5);
  static final PdfColor _lightBlue = PdfColor.fromInt(0xFFEAF3F8);
  static final PdfColor _lightGrey = PdfColor.fromInt(0xFFF4F6F8);
  static final PdfColor _border = PdfColor.fromInt(0xFFB7C4CE);
  static final PdfColor _green = PdfColor.fromInt(0xFF2E8B57);
  static final PdfColor _orange = PdfColor.fromInt(0xFFE58C24);

  static Future<void> generateReport({required JsaResult result}) async {
    final branding = await BrandingService.load();

    final logoFile = await BrandingService.getLogoFile(branding.logoPath);

    final Uint8List? logoBytes = logoFile == null
        ? null
        : await logoFile.readAsBytes();

    final brandColor = PdfColor.fromInt(branding.primaryColorValue);
    final now = DateTime.now();

    final formattedDate = DateFormat('dd MMM yyyy').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);

    final reportNumber = 'JSA-${DateFormat('yyyyMMdd-HHmmss').format(now)}';

    final hazardCount = result.steps.fold<int>(
      0,
      (total, step) => total + step.hazards.length,
    );

    final controlCount = result.steps.fold<int>(
      0,
      (total, step) => total + step.controlMeasures.length,
    );

    final responsibleRoles = result.steps
        .map((step) => step.responsiblePerson.trim())
        .where((person) => person.isNotEmpty)
        .toSet()
        .length;

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a3.landscape,
        margin: const pw.EdgeInsets.fromLTRB(18, 30, 18, 24),
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }

          return _continuationHeader(
            reportNumber,
            branding,
            logoBytes,
            brandColor,
          );
        },
        footer: (context) => _footer(context, reportNumber),
        build: (context) => [
          _reportHeader(
            reportNumber: reportNumber,
            formattedDate: formattedDate,
            formattedTime: formattedTime,
            branding: branding,
            logoBytes: logoBytes,
            brandColor: brandColor,
          ),
          pw.SizedBox(height: 8),

          _documentInformation(
            result: result,
            reportNumber: reportNumber,
            formattedDate: formattedDate,
            formattedTime: formattedTime,
          ),
          pw.SizedBox(height: 10),

          _summaryStrip(
            stepCount: result.steps.length,
            hazardCount: hazardCount,
            controlCount: controlCount,
            responsibleRoles: responsibleRoles,
          ),
          pw.SizedBox(height: 10),

          _sectionHeading('Job Safety Analysis Register'),
          pw.SizedBox(height: 5),

          if (result.steps.isEmpty)
            _emptyMessage('No job steps were provided.')
          else
            _jsaTable(result.steps),

          pw.SizedBox(height: 12),

          _sectionHeading('Mandatory Requirements'),
          pw.SizedBox(height: 6),

          if (result.permits.isNotEmpty) ...[
            _informationBox('Required Permits', result.permits),
            pw.SizedBox(height: 7),
          ],

          if (result.emergencyRequirements.isNotEmpty) ...[
            _informationBox(
              'Emergency Requirements',
              result.emergencyRequirements,
            ),
            pw.SizedBox(height: 7),
          ],

          if (result.applicableStandards.isNotEmpty)
            _informationBox(
              'Applicable Standards and References',
              result.applicableStandards,
            ),

          pw.SizedBox(height: 12),
          _reviewNotice(),
          pw.SizedBox(height: 12),
          _signOffSection(),
        ],
      ),
    );

    final pdfBytes = await pdf.save();

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Sentinel_HSE_JSA_$reportNumber.pdf',
    );
  }

  static pw.Widget _reportHeader({
    required String reportNumber,
    required String formattedDate,
    required String formattedTime,
    required BrandingSettings branding,
    required Uint8List? logoBytes,
    required PdfColor brandColor,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _navy, width: 1.2),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              color: brandColor,
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoBytes != null) ...[
                    pw.Container(
                      width: 42,
                      height: 42,
                      child: pw.Image(
                        pw.MemoryImage(logoBytes),
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                    pw.SizedBox(width: 8),
                  ],
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          branding.companyName.isEmpty
                              ? 'SENTINEL HSE'
                              : branding.companyName,
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (branding.projectSiteName.isNotEmpty)
                          pw.Text(
                            branding.projectSiteName,
                            style: const pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 7,
                            ),
                          ),
                        if (branding.clientName.isNotEmpty)
                          pw.Text(
                            'Client: ${branding.clientName}',
                            style: const pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 7,
                            ),
                          ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Powered by Sentinel HSE',
                          style: const pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              alignment: pw.Alignment.center,
              child: pw.Column(
                children: [
                  pw.Text(
                    'JOB SAFETY ANALYSIS',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: _navy,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Job Steps, Hazards, Control Measures and Responsibilities',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              color: _lightBlue,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _smallHeaderLine('Report No.', reportNumber),
                  _smallHeaderLine(
                    'Generated',
                    '$formattedDate, $formattedTime',
                  ),
                  _smallHeaderLine('Revision', 'Rev. 0'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _smallHeaderLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.RichText(
        text: pw.TextSpan(
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.black),
          children: [
            pw.TextSpan(
              text: '$label: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  static pw.Widget _documentInformation({
    required JsaResult result,
    required String reportNumber,
    required String formattedDate,
    required String formattedTime,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.7),
      columnWidths: const {
        0: pw.FixedColumnWidth(75),
        1: pw.FlexColumnWidth(3),
        2: pw.FixedColumnWidth(75),
        3: pw.FlexColumnWidth(1.2),
      },
      children: [
        pw.TableRow(
          children: [
            _informationLabel('Task / Activity'),
            _informationValue(
              result.task.trim().isEmpty ? 'Not specified' : result.task,
            ),
            _informationLabel('Document Type'),
            _informationValue('Job Safety Analysis'),
          ],
        ),
        pw.TableRow(
          children: [
            _informationLabel('Assessment Date'),
            _informationValue('$formattedDate, $formattedTime'),
            _informationLabel('Report Number'),
            _informationValue(reportNumber),
          ],
        ),
        pw.TableRow(
          children: [
            _informationLabel('Assessment Basis'),
            _informationValue(
              'AI-assisted JSA requiring competent-person review before work begins.',
            ),
            _informationLabel('Job Steps'),
            _informationValue(result.steps.length.toString()),
          ],
        ),
      ],
    );
  }

  static pw.Widget _informationLabel(String text) {
    return pw.Container(
      color: _lightGrey,
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _informationValue(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 7)),
    );
  }

  static pw.Widget _summaryStrip({
    required int stepCount,
    required int hazardCount,
    required int controlCount,
    required int responsibleRoles,
  }) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _summaryCard(
            label: 'Job Steps',
            value: stepCount.toString(),
            color: _blue,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: _summaryCard(
            label: 'Hazards Identified',
            value: hazardCount.toString(),
            color: _orange,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: _summaryCard(
            label: 'Control Measures',
            value: controlCount.toString(),
            color: _green,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: _summaryCard(
            label: 'Responsible Roles',
            value: responsibleRoles.toString(),
            color: _navy,
          ),
        ),
      ],
    );
  }

  static pw.Widget _summaryCard({
    required String label,
    required String value,
    required PdfColor color,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color, width: 0.8),
        borderRadius: pw.BorderRadius.circular(3),
      ),
      child: pw.Row(
        children: [
          pw.Container(width: 7, height: 26, color: color),
          pw.SizedBox(width: 7),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                value,
                style: pw.TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(label, style: const pw.TextStyle(fontSize: 6.5)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _sectionHeading(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      color: _navy,
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _jsaTable(List<JsaStep> steps) {
    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.6),
      columnWidths: const {
        0: pw.FixedColumnWidth(24),
        1: pw.FlexColumnWidth(1.4),
        2: pw.FlexColumnWidth(2.1),
        3: pw.FlexColumnWidth(3.2),
        4: pw.FlexColumnWidth(1.7),
        5: pw.FlexColumnWidth(1.3),
      },
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _blue),
          children: [
            _tableHeaderCell('No.'),
            _tableHeaderCell('Job Step'),
            _tableHeaderCell('Hazards'),
            _tableHeaderCell('Control Measures'),
            _tableHeaderCell('Required PPE'),
            _tableHeaderCell('Responsible Person'),
          ],
        ),
        ...steps.asMap().entries.map((entry) {
          final step = entry.value;

          return pw.TableRow(
            children: [
              _tableBodyCell(
                pw.Text(
                  '${entry.key + 1}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              _tableBodyCell(
                pw.Text(
                  step.jobStep.trim().isEmpty ? 'Not specified' : step.jobStep,
                  style: pw.TextStyle(
                    fontSize: 6.5,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              _tableBodyCell(_compactList(step.hazards)),
              _tableBodyCell(_compactList(step.controlMeasures)),
              _tableBodyCell(_compactList(step.requiredPpe)),
              _tableBodyCell(
                pw.Text(
                  step.responsiblePerson.trim().isEmpty
                      ? 'Not specified'
                      : step.responsiblePerson,
                  style: const pw.TextStyle(fontSize: 6.2),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _tableHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 6.3,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _tableBodyCell(pw.Widget child) {
    return pw.Padding(padding: const pw.EdgeInsets.all(5), child: child);
  }

  static pw.Widget _compactList(List<String> items) {
    final visibleItems = items.where((item) => item.trim().isNotEmpty).toList();

    if (visibleItems.isEmpty) {
      return pw.Text('Not specified', style: const pw.TextStyle(fontSize: 6.2));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: visibleItems.map((item) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 2),
          child: pw.Text(
            '- $item',
            style: const pw.TextStyle(fontSize: 6.2, lineSpacing: 1),
          ),
        );
      }).toList(),
    );
  }

  static pw.Widget _informationBox(String title, List<String> items) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border, width: 0.7),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            color: _lightBlue,
            padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                color: _navy,
                fontSize: 7,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(7),
            child: _compactList(items),
          ),
        ],
      ),
    );
  }

  static pw.Widget _reviewNotice() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: _lightGrey,
        border: pw.Border.all(color: _orange, width: 0.8),
      ),
      child: pw.Text(
        'Review Requirement: This AI-assisted JSA must be reviewed, amended where necessary and approved by a competent person before the task begins. Conduct a pre-job briefing and stop work if conditions change.',
        style: const pw.TextStyle(fontSize: 7),
      ),
    );
  }

  static pw.Widget _emptyMessage(String text) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _lightGrey,
        border: pw.Border.all(color: _border),
      ),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 7)),
    );
  }

  static pw.Widget _signOffSection() {
    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.7),
      columnWidths: const {
        0: pw.FlexColumnWidth(),
        1: pw.FlexColumnWidth(),
        2: pw.FlexColumnWidth(),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _lightGrey),
          children: [
            _signOffHeader('Prepared By'),
            _signOffHeader('Reviewed By'),
            _signOffHeader('Approved By'),
          ],
        ),
        pw.TableRow(children: [_signOffCell(), _signOffCell(), _signOffCell()]),
      ],
    );
  }

  static pw.Widget _signOffHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _signOffCell() {
    return pw.Container(
      height: 55,
      padding: const pw.EdgeInsets.all(6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text(
            'Name: ______________________________',
            style: const pw.TextStyle(fontSize: 6),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Signature: __________________________',
            style: const pw.TextStyle(fontSize: 6),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Date: _______________________________',
            style: const pw.TextStyle(fontSize: 6),
          ),
        ],
      ),
    );
  }

  static pw.Widget _continuationHeader(
    String reportNumber,
    BrandingSettings branding,
    Uint8List? logoBytes,
    PdfColor brandColor,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 7),
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: brandColor, width: 0.8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            branding.companyName.isEmpty
                ? 'SENTINEL HSE - JOB SAFETY ANALYSIS'
                : '${branding.companyName} - JOB SAFETY ANALYSIS',
            style: pw.TextStyle(
              color: brandColor,
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(reportNumber, style: const pw.TextStyle(fontSize: 6.5)),
        ],
      ),
    );
  }

  static pw.Widget _footer(pw.Context context, String reportNumber) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 7),
      padding: const pw.EdgeInsets.only(top: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _border, width: 0.6)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Sentinel HSE AI | $reportNumber | Rev. 0',
            style: const pw.TextStyle(fontSize: 6),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 6),
          ),
        ],
      ),
    );
  }
}
