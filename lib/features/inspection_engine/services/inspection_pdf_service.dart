import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/inspection_finding.dart';
import '../models/inspection_report_data.dart';
import '../../branding/models/branding_settings.dart';
import '../../branding/services/branding_service.dart';

class InspectionPdfService {
  static Future<Uint8List> generate(
    PdfPageFormat pageFormat,
    InspectionReportData reportData,
  ) async {
    final branding = await BrandingService.load();

    final logoFile = await BrandingService.getLogoFile(branding.logoPath);

    final Uint8List? logoBytes = logoFile == null
        ? null
        : await logoFile.readAsBytes();

    final brandColor = PdfColor.fromInt(branding.primaryColorValue);
    final document = pw.Document(
      title: reportData.inspectionTitle,
      author: 'Sentinel HSE',
      creator: 'Sentinel HSE Inspection Engine',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _buildHeader(reportData, branding, logoBytes, brandColor),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildInspectionSummary(reportData),
          pw.SizedBox(height: 18),
          _buildSectionTitle('Inspection Details'),
          pw.SizedBox(height: 8),
          _buildInspectionDetails(reportData),
          pw.SizedBox(height: 18),
          _buildSectionTitle('Inspection Summary'),
          pw.SizedBox(height: 8),
          _buildSummaryCards(reportData),
          pw.SizedBox(height: 18),
          _buildSectionTitle('CAPA Findings'),
          pw.SizedBox(height: 8),
          ..._buildFindings(reportData.findings, reportData.findingPhotos),
          pw.SizedBox(height: 18),
          _buildSectionTitle('Checklist Results'),
          pw.SizedBox(height: 8),
          ..._buildChecklistItems(reportData.items),
          pw.SizedBox(height: 24),
          _buildApprovalSection(reportData),
        ],
      ),
    );

    return document.save();
  }

  static pw.Widget _buildHeader(
    InspectionReportData reportData,
    BrandingSettings branding,
    Uint8List? logoBytes,
    PdfColor brandColor,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Row(
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
                            : _pdfSafeText(branding.companyName),
                        style: pw.TextStyle(
                          color: brandColor,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (branding.projectSiteName.isNotEmpty)
                        pw.Text(
                          _pdfSafeText(branding.projectSiteName),
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey700,
                          ),
                        ),
                      if (branding.clientName.isNotEmpty)
                        pw.Text(
                          'Client: '
                          '${_pdfSafeText(branding.clientName)}',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey700,
                          ),
                        ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Inspection and CAPA Report',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(width: 10),

          pw.Text(
            _pdfSafeText(reportData.inspectionTitle),
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.right,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      margin: const pw.EdgeInsets.only(top: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by Sentinel HSE',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInspectionSummary(InspectionReportData reportData) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue900),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            reportData.inspectionTitle,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Report reference: ${reportData.reportReference}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Submission date: ${_formatDateTime(reportData.submittedAt)}',
          ),
          pw.SizedBox(height: 4),
          if (reportData.campName.isNotEmpty) ...[
            pw.Text(
              'Weighted Audit Score: '
              '${reportData.welfareAuditPercentage.toStringAsFixed(1)}%',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'RAG Rating: ${reportData.welfareRagRating}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ] else if (reportData.liftingGroupCompany.isNotEmpty) ...[
            pw.Text(
              'Compliance percentage: '
              '${reportData.compliancePercentage.toStringAsFixed(1)}%',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Group Company: ${reportData.liftingGroupCompany}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Contractor Location: '
              '${reportData.liftingContractorLocation.isEmpty ? 'N/A' : reportData.liftingContractorLocation}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ] else ...[
            pw.Text(
              'Compliance percentage: '
              '${reportData.compliancePercentage.toStringAsFixed(1)}%',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildInspectionDetails(InspectionReportData reportData) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.2),
        1: pw.FlexColumnWidth(1.8),
        2: pw.FlexColumnWidth(1.2),
        3: pw.FlexColumnWidth(1.8),
      },
      children: [
        _inspectionDetailRow(
          'Location',
          reportData.inspectionLocation,
          'Inspection date',
          _formatDateTime(reportData.submittedAt),
        ),
        _inspectionDetailRow(
          'Inspector name',
          reportData.inspectorName,
          'Inspector ID',
          reportData.inspectorEmployeeId,
        ),
        if (reportData.campName.isNotEmpty) ...[
          _inspectionDetailRow(
            'Camp name',
            reportData.campName,
            'Contractor name',
            reportData.contractorName,
          ),
          _inspectionDetailRow(
            'Contract administrator',
            reportData.contractAdministrator,
            'Group company',
            reportData.groupCompany,
          ),
          _inspectionDetailRow(
            'Asset / function',
            reportData.assetFunction,
            'Camp representative',
            reportData.campRepresentative,
          ),
        ] else if (reportData.liftingGroupCompany.isNotEmpty) ...[
          _inspectionDetailRow(
            'Group company',
            reportData.liftingGroupCompany,
            'Contractor location',
            reportData.liftingContractorLocation.isEmpty
                ? 'N/A'
                : reportData.liftingContractorLocation,
          ),
        ] else ...[
          _inspectionDetailRow(
            'Driver name',
            reportData.driverName,
            'Driver ID',
            reportData.driverEmployeeId,
          ),
          _inspectionDetailRow(
            'Vehicle plate',
            reportData.vehiclePlateNumber,
            'Fleet number',
            reportData.vehicleFleetNumber,
          ),
          _inspectionDetailRow(
            'Make / model',
            reportData.vehicleMakeModel,
            'Odometer',
            reportData.odometerReading,
          ),
        ],
      ],
    );
  }

  static pw.TableRow _inspectionDetailRow(
    String firstLabel,
    String firstValue,
    String secondLabel,
    String secondValue,
  ) {
    return pw.TableRow(
      children: [
        _inspectionDetailCell(firstLabel, isLabel: true),
        _inspectionDetailCell(firstValue),
        _inspectionDetailCell(secondLabel, isLabel: true),
        _inspectionDetailCell(secondValue),
      ],
    );
  }

  static pw.Widget _inspectionDetailCell(String text, {bool isLabel = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(7),
      color: isLabel ? PdfColors.grey200 : PdfColors.white,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: isLabel ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildSummaryCards(InspectionReportData reportData) {
    if (reportData.campName.isNotEmpty) {
      int countRating(String rating) {
        return reportData.items
            .where((item) => item.performanceRating == rating)
            .length;
      }

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _summaryCard(
                'VERY GOOD',
                countRating('Very Good').toString(),
                PdfColors.green700,
              ),
              _summaryCard(
                'GOOD',
                countRating('Good').toString(),
                PdfColors.lightGreen700,
              ),
              _summaryCard(
                'FAIR',
                countRating('Fair').toString(),
                PdfColors.amber700,
              ),
              _summaryCard(
                'NEEDS IMPROVEMENT',
                countRating('Needs Improvement').toString(),
                PdfColors.orange700,
              ),
              _summaryCard(
                'UNACCEPTABLE',
                countRating('Unacceptable').toString(),
                PdfColors.red700,
              ),
              _summaryCard(
                'N/A',
                countRating('N/A').toString(),
                PdfColors.grey700,
              ),
              _summaryCard(
                'CAPAs',
                reportData.findings.length.toString(),
                PdfColors.orange700,
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Section Scores',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: const {
              0: pw.FlexColumnWidth(4),
              1: pw.FlexColumnWidth(1),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _inspectionDetailCell('Section', isLabel: true),
                  _inspectionDetailCell('Score', isLabel: true),
                ],
              ),
              ...reportData.welfareSectionScores.entries.map(
                (entry) => pw.TableRow(
                  children: [
                    _inspectionDetailCell(entry.key),
                    _inspectionDetailCell('${entry.value.toStringAsFixed(1)}%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    return pw.Row(
      children: [
        pw.Expanded(
          child: _summaryCard(
            'YES',
            reportData.yesCount.toString(),
            PdfColors.green700,
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: _summaryCard(
            'NO',
            reportData.noCount.toString(),
            PdfColors.red700,
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: _summaryCard(
            'N/A',
            reportData.naCount.toString(),
            PdfColors.grey700,
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: _summaryCard(
            'CAPAs',
            reportData.findings.length.toString(),
            PdfColors.orange700,
          ),
        ),
      ],
    );
  }

  static pw.Widget _summaryCard(String label, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      color: PdfColors.blue900,
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 13,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static List<pw.Widget> _buildFindings(
    List<InspectionFinding> findings,
    Map<int, List<Uint8List>> findingPhotos,
  ) {
    if (findings.isEmpty) {
      return [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Text('No non-compliances were identified.'),
        ),
      ];
    }

    return findings.map((finding) {
      final riskColor = _riskColor(finding.riskLevel);
      final photos = findingPhotos[finding.itemNumber] ?? const <Uint8List>[];
      return pw.Container(
        width: double.infinity,
        margin: const pw.EdgeInsets.only(bottom: 9),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: riskColor),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 25,
                  height: 25,
                  alignment: pw.Alignment.center,
                  decoration: pw.BoxDecoration(
                    color: riskColor,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Text(
                    finding.itemNumber.toString(),
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Expanded(
                  child: pw.Text(
                    _pdfSafeText(finding.requirement),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(width: 8),
                _pdfBadge(finding.riskLevel, riskColor),
              ],
            ),
            pw.SizedBox(height: 9),
            _detailLine('Finding', finding.finding),
            _detailLine('Corrective action', finding.correctiveAction),
            _detailLine('Responsible person', finding.responsiblePerson),
            _detailLine('Target date', _formatDate(finding.targetDate)),
            _detailLine('Status', finding.status),

            if (finding.status == 'Closed') ...[
              pw.SizedBox(height: 8),
              pw.Divider(color: PdfColors.grey400),
              pw.Text(
                'Closure Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),

              _detailLine('Closed by', finding.closedBy),

              if (finding.closedAt != null)
                _detailLine('Closed date', _formatDate(finding.closedAt!)),

              _detailLine('Closure comment', finding.closureComment),

              if (finding.closureEvidence.isNotEmpty) ...[
                pw.SizedBox(height: 8),
                pw.Text(
                  'Close-out Evidence',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 6),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: finding.closureEvidence.map((photoBytes) {
                    return pw.Container(
                      width: 150,
                      height: 105,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400),
                      ),
                      child: pw.Image(
                        pw.MemoryImage(photoBytes),
                        fit: pw.BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],

            if (photos.isNotEmpty) ...[
              pw.SizedBox(height: 8),
              pw.Text(
                'Finding Photos',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 8,
                runSpacing: 8,
                children: photos.map((photoBytes) {
                  return pw.Container(
                    width: 150,
                    height: 105,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey400),
                    ),
                    child: pw.Image(
                      pw.MemoryImage(photoBytes),
                      fit: pw.BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      );
    }).toList();
  }

  static List<pw.Widget> _buildChecklistItems(
    List<InspectionReportItem> items,
  ) {
    return items.map((item) {
      final answerColor = _answerColor(item.answer);

      return pw.Container(
        width: double.infinity,
        margin: const pw.EdgeInsets.only(bottom: 8),
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 24,
              height: 24,
              alignment: pw.Alignment.center,
              decoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
                shape: pw.BoxShape.circle,
              ),
              child: pw.Text(
                item.itemNumber.toString(),
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    _pdfSafeText(item.requirement),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Section: ${_pdfSafeText(item.section)}',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey700,
                    ),
                  ),
                  if (item.comment.isNotEmpty) ...[
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Comment: ${_pdfSafeText(item.comment)}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ],
              ),
            ),
            pw.SizedBox(width: 8),
            _pdfBadge(item.answer, answerColor),
          ],
        ),
      );
    }).toList();
  }

  static pw.Widget _buildApprovalSection(InspectionReportData reportData) {
    final isCampWelfare = reportData.campName.isNotEmpty;

    final isLifting = reportData.inspectionTitle.toLowerCase().contains(
      'lifting and hoisting',
    );

    final isGeneralCompliance =
        reportData.liftingGroupCompany.isNotEmpty && !isLifting;

    String firstSignature;
    String secondSignature;
    String thirdSignature;

    if (isCampWelfare) {
      firstSignature = 'Auditor: ${reportData.inspectorName}';
      secondSignature = 'Camp Representative: ${reportData.campRepresentative}';
      thirdSignature = 'Contractor Representative name and signature';
    } else if (isLifting) {
      firstSignature = 'Completed By: ${reportData.inspectorName}';
      secondSignature = 'Appointed Person / Lifting Supervisor';
      thirdSignature = 'Authorized Representative name and signature';
    } else if (isGeneralCompliance) {
      firstSignature = 'Completed By: ${reportData.inspectorName}';
      secondSignature = _generalComplianceApprover(reportData.inspectionTitle);
      thirdSignature = 'Authorized Representative name and signature';
    } else {
      firstSignature = 'Inspector: ${reportData.inspectorName}';
      secondSignature = 'Driver: ${reportData.driverName}';
      thirdSignature = 'Supervisor name and signature';
    }

    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey500),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            pw.Expanded(child: _signatureBox(firstSignature)),
            pw.SizedBox(width: 16),
            pw.Expanded(child: _signatureBox(secondSignature)),
            pw.SizedBox(width: 16),
            pw.Expanded(child: _signatureBox(thirdSignature)),
          ],
        ),
      ],
    );
  }

  static String _generalComplianceApprover(String inspectionTitle) {
    final title = inspectionTitle.toLowerCase();

    if (title.contains('job safety analysis')) {
      return 'Performing Authority / HSE Officer';
    }

    if (title.contains('confined space')) {
      return 'Performing Authority / HSE Officer';
    }

    if (title.contains('scaffolding')) {
      return 'Scaffolding Supervisor / HSE Officer';
    }

    if (title.contains('electrical safety')) {
      return 'Electrical Supervisor / HSE Officer';
    }

    if (title.contains('compressed gas')) {
      return 'Area Supervisor / HSE Officer';
    }

    if (title.contains('excavation')) {
      return 'Civil Supervisor / HSE Officer';
    }

    if (title.contains('abrasive blasting')) {
      return 'Blasting / Painting Supervisor / HSE Officer';
    }

    if (title.contains('working at height')) {
      return 'Work Supervisor / HSE Officer';
    }

    if (title.contains('land transportation')) {
      return 'Transport Supervisor / Road Safety Coordinator';
    }

    return 'Responsible Supervisor / HSE Officer';
  }

  static pw.Widget _signatureBox(String label) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 28),
        pw.Container(
          width: double.infinity,
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700)),
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static pw.Widget _detailLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: '${_pdfSafeText(label)}: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: _pdfSafeText(value)),
          ],
        ),
      ),
    );
  }

  static pw.Widget _pdfBadge(String text, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: pw.BoxDecoration(
        color: PdfColor(color.red, color.green, color.blue, 0.15),
        border: pw.Border.all(color: color),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static PdfColor _riskColor(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return PdfColors.red700;
      case 'Medium':
        return PdfColors.orange700;
      default:
        return PdfColors.green700;
    }
  }

  static PdfColor _answerColor(String answer) {
    switch (answer) {
      case 'Yes':
        return PdfColors.green700;
      case 'No':
        return PdfColors.red700;
      default:
        return PdfColors.grey700;
    }
  }

  static String _pdfSafeText(String value) {
    return value
        .replaceAll('\u2018', "'")
        .replaceAll('\u2019', "'")
        .replaceAll('\u201C', '"')
        .replaceAll('\u201D', '"')
        .replaceAll('\u2013', '-')
        .replaceAll('\u2014', '-')
        .replaceAll('\u00A0', ' ')
        .replaceAll('\u2026', '...')
        .replaceAll('\u2265', '>=')
        .replaceAll('\u2264', '<=')
        .replaceAll('\u03A9', 'Ohm')
        .replaceAll('\u00AE', '(R)')
        .replaceAll('\u2122', '(TM)')
        .replaceAll('\u00D7', 'x');
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  static String _formatDateTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '${_formatDate(date)} $hour:$minute';
  }
}
