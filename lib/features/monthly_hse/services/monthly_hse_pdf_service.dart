import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../reports_center/models/report_item.dart';
import '../models/monthly_hse_report_data.dart';
import '../../branding/models/branding_settings.dart';
import '../../branding/services/branding_service.dart';

class MonthlyHsePdfService {
  MonthlyHsePdfService._();

  static Future<Uint8List> generate(
    PdfPageFormat pageFormat,
    MonthlyHseReportData data,
  ) async {
    final branding = await BrandingService.load();

    final logoFile = await BrandingService.getLogoFile(branding.logoPath);

    final Uint8List? logoBytes = logoFile == null
        ? null
        : await logoFile.readAsBytes();

    final brandColor = PdfColor.fromInt(branding.primaryColorValue);
    final document = pw.Document(
      title: 'Sentinel HSE Monthly Report - ${data.periodLabel}',
      author: 'Sentinel HSE',
      creator: 'Sentinel HSE Monthly Reporting',
    );

    final capaClosureRate = data.totalCapaCount == 0
        ? 0.0
        : (data.closedCapaCount / data.totalCapaCount) * 100;

    document.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(30),
        header: (context) => _header(data, branding, logoBytes, brandColor),
        footer: _footer,
        build: (context) => [
          _titleBlock(data, branding, logoBytes, brandColor),
          pw.SizedBox(height: 18),

          _sectionTitle('1. Executive Summary'),
          _executiveSummary(data),
          pw.SizedBox(height: 18),

          _sectionTitle('2. Monthly HSE Performance'),
          _twoColumnTable([
            ['Total HSE Reports', '${data.totalReports}'],
            ['Inspections', '${data.inspectionCount}'],
            ['Investigations', '${data.investigationCount}'],
            ['Hazard Reports', '${data.hazardCount}'],
            ['JSA Reports', '${data.jsaCount}'],
            ['Risk Assessments', '${data.riskAssessmentCount}'],
            ['Toolbox Talks', '${data.toolboxTalkCount}'],
            [
              'Average Inspection Score',
              data.averageInspectionScore == null
                  ? 'N/A'
                  : '${data.averageInspectionScore!.toStringAsFixed(1)}%',
            ],
          ]),
          pw.SizedBox(height: 18),

          _sectionTitle('3. CAPA Performance'),
          _twoColumnTable([
            ['Total CAPAs', '${data.totalCapaCount}'],
            ['Open CAPAs', '${data.openCapaCount}'],
            ['In Progress CAPAs', '${data.inProgressCapaCount}'],
            ['Closed CAPAs', '${data.closedCapaCount}'],
            ['CAPA Closure Rate', '${capaClosureRate.toStringAsFixed(1)}%'],
          ]),
          pw.SizedBox(height: 18),

          _sectionTitle('4. Management Performance Review'),
          _managementReview(data, capaClosureRate),
          pw.SizedBox(height: 18),

          _sectionTitle(
            '5. Monthly HSE Record Register '
            '(${data.totalReports})',
          ),

          if (data.reports.isEmpty)
            _emptyBox('No HSE records were recorded for this reporting period.')
          else
            ...data.reports.map(_reportCard),

          pw.SizedBox(height: 20),

          _sectionTitle('6. Management Sign-Off'),
          _approvalBlock(),
        ],
      ),
    );

    return document.save();
  }

  static pw.Widget _header(
    MonthlyHseReportData data,
    BrandingSettings branding,
    Uint8List? logoBytes,
    PdfColor brandColor,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 0.8, color: PdfColors.grey500),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (logoBytes != null) ...[
            pw.Container(
              width: 38,
              height: 38,
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
                      : _safe(branding.companyName),
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: brandColor,
                  ),
                ),
                if (branding.projectSiteName.isNotEmpty)
                  pw.Text(
                    _safe(branding.projectSiteName),
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey700,
                    ),
                  ),
              ],
            ),
          ),
          pw.Text(
            _safe(data.periodLabel),
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  static pw.Widget _footer(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(width: 0.5, color: PdfColors.grey400),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Sentinel HSE - Monthly Management Report',
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

  static pw.Widget _titleBlock(
    MonthlyHseReportData data,
    BrandingSettings branding,
    Uint8List? logoBytes,
    PdfColor brandColor,
  ) {
    final generated = DateTime.now();

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: brandColor),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (logoBytes != null) ...[
            pw.Container(
              height: 55,
              child: pw.Image(
                pw.MemoryImage(logoBytes),
                fit: pw.BoxFit.contain,
              ),
            ),
            pw.SizedBox(height: 10),
          ],

          pw.Text(
            'MONTHLY HSE PERFORMANCE REPORT',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: brandColor,
            ),
          ),

          pw.SizedBox(height: 8),

          if (branding.companyName.isNotEmpty)
            pw.Text(
              _safe(branding.companyName),
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
            ),

          if (branding.projectSiteName.isNotEmpty)
            pw.Text(
              'Project / Site: '
              '${_safe(branding.projectSiteName)}',
              style: const pw.TextStyle(fontSize: 10),
            ),

          if (branding.clientName.isNotEmpty)
            pw.Text(
              'Client: '
              '${_safe(branding.clientName)}',
              style: const pw.TextStyle(fontSize: 10),
            ),

          pw.SizedBox(height: 8),

          pw.Text(
            _safe(data.periodLabel),
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 6),

          pw.Text(
            'Generated: '
            '${_formatDate(generated)}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),

          pw.SizedBox(height: 8),

          pw.Text(
            'Generated by Sentinel HSE',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static pw.Widget _executiveSummary(MonthlyHseReportData data) {
    if (data.totalReports == 0) {
      return _textBlock(
        'No HSE activity records were available in Sentinel HSE '
        'for ${data.periodLabel}. Management should confirm that '
        'all required HSE activities and records have been entered.',
      );
    }

    final score = data.averageInspectionScore == null
        ? 'N/A'
        : '${data.averageInspectionScore!.toStringAsFixed(1)}%';

    return _textBlock(
      'During ${data.periodLabel}, Sentinel HSE recorded '
      '${data.totalReports} HSE reports. These included '
      '${data.inspectionCount} inspections, '
      '${data.investigationCount} investigations, '
      '${data.hazardCount} hazard reports, '
      '${data.jsaCount} JSA reports, '
      '${data.riskAssessmentCount} risk assessments and '
      '${data.toolboxTalkCount} toolbox talks. '
      'The average inspection score was $score. '
      '${data.totalCapaCount} CAPA actions were recorded, '
      'of which ${data.closedCapaCount} were closed, '
      '${data.inProgressCapaCount} were in progress and '
      '${data.openCapaCount} remained open.',
    );
  }

  static pw.Widget _managementReview(
    MonthlyHseReportData data,
    double capaClosureRate,
  ) {
    final observations = <String>[];

    if (data.averageInspectionScore != null) {
      if (data.averageInspectionScore! >= 90) {
        observations.add(
          'Inspection performance was strong with an average '
          'score of ${data.averageInspectionScore!.toStringAsFixed(1)}%.',
        );
      } else if (data.averageInspectionScore! >= 70) {
        observations.add(
          'Inspection performance was acceptable but improvement '
          'opportunities remain. Average score: '
          '${data.averageInspectionScore!.toStringAsFixed(1)}%.',
        );
      } else {
        observations.add(
          'Inspection performance requires management attention. '
          'Average score: '
          '${data.averageInspectionScore!.toStringAsFixed(1)}%.',
        );
      }
    }

    if (data.totalCapaCount == 0) {
      observations.add(
        'No CAPA actions were generated during the reporting period.',
      );
    } else if (data.openCapaCount > 0) {
      observations.add(
        '${data.openCapaCount} CAPA action(s) remain open and '
        'require follow-up.',
      );
    } else {
      observations.add(
        'No open CAPA actions remained at the end of the period.',
      );
    }

    observations.add(
      'CAPA closure performance for the period was '
      '${capaClosureRate.toStringAsFixed(1)}%.',
    );

    if (data.investigationCount > 0) {
      observations.add(
        '${data.investigationCount} incident investigation(s) '
        'were recorded during the month.',
      );
    }

    if (data.hazardCount > 0) {
      observations.add(
        '${data.hazardCount} proactive hazard report(s) were recorded.',
      );
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: observations
            .map(
              (item) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Text(
                  '- ${_safe(item)}',
                  style: const pw.TextStyle(fontSize: 10, lineSpacing: 2),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static pw.Widget _reportCard(ReportItem report) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 7),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  _safe(report.title),
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                _formatDate(report.createdAt),
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            _typeLabel(report.type),
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
            ),
          ),
          if (report.subtitle.trim().isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              _safe(report.subtitle),
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _twoColumnTable(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.6),
      columnWidths: const {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
      children: rows.map((row) {
        return pw.TableRow(
          children: [_tableCell(row[0], bold: true), _tableCell(row[1])],
        );
      }).toList(),
    );
  }

  static pw.Widget _tableCell(String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        _safe(value),
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: PdfColors.blue50,
      child: pw.Text(
        _safe(title),
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
        ),
      ),
    );
  }

  static pw.Widget _textBlock(String text) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      child: pw.Text(
        _safe(text),
        style: const pw.TextStyle(fontSize: 10, lineSpacing: 3),
      ),
    );
  }

  static pw.Widget _emptyBox(String text) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Text(
        _safe(text),
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
      ),
    );
  }

  static pw.Widget _approvalBlock() {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        pw.TableRow(
          children: [
            _approvalCell('Prepared By'),
            _approvalCell('Reviewed By'),
            _approvalCell('Approved By'),
          ],
        ),
        pw.TableRow(
          children: [
            _approvalCell('Name:\n\nSignature:\n\nDate:'),
            _approvalCell('Name:\n\nSignature:\n\nDate:'),
            _approvalCell('Name:\n\nSignature:\n\nDate:'),
          ],
        ),
      ],
    );
  }

  static pw.Widget _approvalCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9, lineSpacing: 4),
      ),
    );
  }

  static String _typeLabel(ReportType type) {
    switch (type) {
      case ReportType.inspection:
        return 'Inspection';
      case ReportType.incident:
        return 'Incident Investigation';
      case ReportType.hazard:
        return 'Hazard Report';
      case ReportType.jsa:
        return 'JSA';
      case ReportType.riskAssessment:
        return 'Risk Assessment';
      case ReportType.toolboxTalk:
        return 'Toolbox Talk';
    }
  }

  static String _formatDate(DateTime value) {
    final date = value.toLocal();

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  static String _safe(String value) {
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
        .replaceAll('\u00D7', 'x');
  }
}
