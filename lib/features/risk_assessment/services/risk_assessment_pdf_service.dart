import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/risk_assessment_result.dart';

class RiskAssessmentPdfService {
  RiskAssessmentPdfService._();

  static final PdfColor _navy = PdfColor.fromInt(0xFF123B5D);
  static final PdfColor _blue = PdfColor.fromInt(0xFF1D6FA5);
  static final PdfColor _lightBlue = PdfColor.fromInt(0xFFEAF3F8);
  static final PdfColor _lightGrey = PdfColor.fromInt(0xFFF4F6F8);
  static final PdfColor _border = PdfColor.fromInt(0xFFB7C4CE);

  static final PdfColor _lowRisk = PdfColor.fromInt(0xFF5CB85C);
  static final PdfColor _mediumRisk = PdfColor.fromInt(0xFFFFC857);
  static final PdfColor _highRisk = PdfColor.fromInt(0xFFF28E2B);
  static final PdfColor _extremeRisk = PdfColor.fromInt(0xFFD9534F);

  static Future<void> generateReport({
    required RiskAssessmentResult result,
  }) async {
    final now = DateTime.now();

    final formattedDate = DateFormat('dd MMM yyyy').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);

    final reportNumber = 'RA-${DateFormat('yyyyMMdd-HHmmss').format(now)}';

    final entries = result.entries;

    final initialHighCount = entries.where((entry) {
      final band = _riskBand(entry.initialRating);

      return band == 'High' || band == 'Extreme';
    }).length;

    final residualHighCount = entries.where((entry) {
      final band = _riskBand(entry.residualRating);

      return band == 'High' || band == 'Extreme';
    }).length;

    final reducedRiskCount = entries.where((entry) {
      return _riskScore(entry.residualRating) < _riskScore(entry.initialRating);
    }).length;

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a3.landscape,
        margin: const pw.EdgeInsets.fromLTRB(18, 30, 18, 24),
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }

          return _continuationHeader(reportNumber);
        },
        footer: (context) {
          return _footer(context, reportNumber);
        },
        build: (context) {
          return [
            _reportHeader(
              reportNumber: reportNumber,
              formattedDate: formattedDate,
              formattedTime: formattedTime,
            ),
            pw.SizedBox(height: 8),

            _documentInformation(
              result: result,
              reportNumber: reportNumber,
              formattedDate: formattedDate,
              formattedTime: formattedTime,
            ),
            pw.SizedBox(height: 10),

            if (entries.isNotEmpty) ...[
              _summaryStrip(
                hazardCount: entries.length,
                initialHighCount: initialHighCount,
                residualHighCount: residualHighCount,
                reducedRiskCount: reducedRiskCount,
              ),
              pw.SizedBox(height: 10),

              _sectionHeading('Hazard-by-Hazard Risk Register'),
              pw.SizedBox(height: 5),

              _riskRegisterTable(entries),
              pw.SizedBox(height: 12),

              _sectionHeading('Risk Matrix and Rating Guide'),
              pw.SizedBox(height: 6),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(flex: 3, child: _riskMatrix()),
                  pw.SizedBox(width: 10),
                  pw.Expanded(flex: 2, child: _riskGuide()),
                ],
              ),
              pw.SizedBox(height: 12),

              ..._supportingSections(result),

              pw.SizedBox(height: 12),
              _signOffSection(),
            ] else ...[
              _sectionHeading('Legacy Risk Assessment Summary'),
              pw.SizedBox(height: 6),

              _legacyRiskSummary(result),
              pw.SizedBox(height: 12),

              ..._supportingSections(result),

              pw.SizedBox(height: 12),
              _signOffSection(),
            ],
          ];
        },
      ),
    );

    final pdfBytes = await pdf.save();

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Sentinel_HSE_Risk_Assessment_$reportNumber.pdf',
    );
  }

  static pw.Widget _reportHeader({
    required String reportNumber,
    required String formattedDate,
    required String formattedTime,
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
              color: _navy,
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'SENTINEL HSE AI',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Intelligent Safety Management',
                    style: const pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 7,
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
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'TASK RISK ASSESSMENT',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: _navy,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Hazard Identification, Controls and Residual Risk Register',
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
                mainAxisAlignment: pw.MainAxisAlignment.center,
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
    required RiskAssessmentResult result,
    required String reportNumber,
    required String formattedDate,
    required String formattedTime,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.7),
      columnWidths: const {
        0: pw.FixedColumnWidth(70),
        1: pw.FlexColumnWidth(3),
        2: pw.FixedColumnWidth(70),
        3: pw.FlexColumnWidth(1.2),
      },
      children: [
        pw.TableRow(
          children: [
            _informationLabel('Task / Activity'),
            _informationValue(
              result.task.trim().isEmpty ? 'Not specified' : result.task,
            ),
            _informationLabel('Assessment Type'),
            _informationValue('Task Risk Assessment'),
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
              'AI-assisted assessment requiring competent-person review before approval.',
            ),
            _informationLabel('Hazards Assessed'),
            _informationValue(
              result.entries.isNotEmpty
                  ? result.entries.length.toString()
                  : result.hazards.length.toString(),
            ),
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
    required int hazardCount,
    required int initialHighCount,
    required int residualHighCount,
    required int reducedRiskCount,
  }) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _summaryCard(
            label: 'Hazards Assessed',
            value: hazardCount.toString(),
            color: _blue,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: _summaryCard(
            label: 'Initial High / Extreme',
            value: initialHighCount.toString(),
            color: _extremeRisk,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: _summaryCard(
            label: 'Residual High / Extreme',
            value: residualHighCount.toString(),
            color: _highRisk,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: _summaryCard(
            label: 'Risks Reduced',
            value: reducedRiskCount.toString(),
            color: _lowRisk,
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
          pw.Expanded(
            child: pw.Column(
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

  static pw.Widget _riskRegisterTable(List<RiskAssessmentEntry> entries) {
    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.6),
      columnWidths: const {
        0: pw.FixedColumnWidth(22),
        1: pw.FlexColumnWidth(1.25),
        2: pw.FlexColumnWidth(1.35),
        3: pw.FlexColumnWidth(1.55),
        4: pw.FlexColumnWidth(2.0),
        5: pw.FixedColumnWidth(47),
        6: pw.FlexColumnWidth(1.85),
        7: pw.FixedColumnWidth(47),
        8: pw.FlexColumnWidth(1.55),
      },
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _blue),
          children: [
            _tableHeaderCell('No.'),
            _tableHeaderCell('Hazard / Top Event'),
            _tableHeaderCell('Causes / Threats'),
            _tableHeaderCell('Consequences / Persons at Risk'),
            _tableHeaderCell('Preventive Controls'),
            _tableHeaderCell('Initial\nS / L / R'),
            _tableHeaderCell('Mitigation / Recovery Measures'),
            _tableHeaderCell('Residual\nS / L / R'),
            _tableHeaderCell('Recommended Actions'),
          ],
        ),
        ...entries.asMap().entries.map((item) {
          final entry = item.value;

          return pw.TableRow(
            children: [
              _tableBodyCell(
                pw.Text(
                  '${item.key + 1}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 6.5,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              _tableBodyCell(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      entry.hazard.trim().isEmpty
                          ? 'Not specified'
                          : entry.hazard,
                      style: pw.TextStyle(
                        fontSize: 6.4,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Top Event:',
                      style: pw.TextStyle(
                        fontSize: 5.8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      entry.topEvent.trim().isEmpty
                          ? 'Not specified'
                          : entry.topEvent,
                      style: const pw.TextStyle(fontSize: 5.8),
                    ),
                  ],
                ),
              ),
              _tableBodyCell(_compactList(entry.causes)),
              _tableBodyCell(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Consequences',
                      style: pw.TextStyle(
                        fontSize: 5.8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    _compactList(entry.consequences),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Persons at Risk',
                      style: pw.TextStyle(
                        fontSize: 5.8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    _compactList(entry.personsAtRisk),
                  ],
                ),
              ),
              _tableBodyCell(_compactList(entry.preventiveControls)),
              _tableBodyCell(_riskRatingCell(entry.initialRating), padding: 3),
              _tableBodyCell(_compactList(entry.mitigationMeasures)),
              _tableBodyCell(_riskRatingCell(entry.residualRating), padding: 3),
              _tableBodyCell(_compactList(entry.recommendedActions)),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _tableHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 6,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _tableBodyCell(pw.Widget child, {double padding = 4}) {
    return pw.Padding(padding: pw.EdgeInsets.all(padding), child: child);
  }

  static pw.Widget _compactList(List<String> items) {
    final visibleItems = items.where((item) => item.trim().isNotEmpty).toList();

    if (visibleItems.isEmpty) {
      return pw.Text('Not specified', style: const pw.TextStyle(fontSize: 5.8));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: visibleItems.map((item) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 2),
          child: pw.Text(
            '- $item',
            style: const pw.TextStyle(fontSize: 5.8, lineSpacing: 1),
          ),
        );
      }).toList(),
    );
  }

  static pw.Widget _riskRatingCell(RiskRating rating) {
    final color = _riskColor(rating);
    final band = _riskBand(rating);

    final useWhiteText = band == 'High' || band == 'Extreme';

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      color: color,
      child: pw.Column(
        children: [
          pw.Text(
            rating.code,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: useWhiteText ? PdfColors.white : PdfColors.black,
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'S:${rating.severity}  L:${rating.likelihood}',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: useWhiteText ? PdfColors.white : PdfColors.black,
              fontSize: 5.5,
            ),
          ),
          pw.Text(
            band,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: useWhiteText ? PdfColors.white : PdfColors.black,
              fontSize: 5.5,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static int _riskScore(RiskRating rating) {
    final likelihoodValue = switch (rating.likelihood.trim().toUpperCase()) {
      'A' => 1,
      'B' => 2,
      'C' => 3,
      'D' => 4,
      'E' => 5,
      _ => 0,
    };

    return rating.severity * likelihoodValue;
  }

  static String _riskBand(RiskRating rating) {
    final score = _riskScore(rating);

    if (score <= 0) {
      return 'N/A';
    }

    if (score <= 4) {
      return 'Low';
    }

    if (score <= 9) {
      return 'Medium';
    }

    if (score <= 16) {
      return 'High';
    }

    return 'Extreme';
  }

  static PdfColor _riskColor(RiskRating rating) {
    return switch (_riskBand(rating)) {
      'Low' => _lowRisk,
      'Medium' => _mediumRisk,
      'High' => _highRisk,
      'Extreme' => _extremeRisk,
      _ => _border,
    };
  }

  static pw.Widget _riskMatrix() {
    const likelihoods = <String>['A', 'B', 'C', 'D', 'E'];

    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.6),
      columnWidths: const {
        0: pw.FixedColumnWidth(58),
        1: pw.FlexColumnWidth(),
        2: pw.FlexColumnWidth(),
        3: pw.FlexColumnWidth(),
        4: pw.FlexColumnWidth(),
        5: pw.FlexColumnWidth(),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _navy),
          children: [
            _matrixHeaderCell('Severity'),
            ...likelihoods.map((likelihood) => _matrixHeaderCell(likelihood)),
          ],
        ),
        ...List.generate(5, (index) {
          final severity = 5 - index;

          return pw.TableRow(
            children: [
              _matrixSideCell('$severity - ${_severityMeaning(severity)}'),
              ...likelihoods.map((likelihood) {
                final rating = RiskRating(
                  severity: severity,
                  likelihood: likelihood,
                );

                return _matrixRiskCell(rating);
              }),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _matrixHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 6,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _matrixSideCell(String text) {
    return pw.Container(
      color: _lightGrey,
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 5.8, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _matrixRiskCell(RiskRating rating) {
    final band = _riskBand(rating);
    final color = _riskColor(rating);

    final useWhiteText = band == 'High' || band == 'Extreme';

    return pw.Container(
      color: color,
      padding: const pw.EdgeInsets.all(4),
      alignment: pw.Alignment.center,
      child: pw.Text(
        rating.code,
        style: pw.TextStyle(
          color: useWhiteText ? PdfColors.white : PdfColors.black,
          fontSize: 7,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _riskGuide() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(7),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border, width: 0.7),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Likelihood',
            style: pw.TextStyle(
              color: _navy,
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 3),
          _guideLine('A', 'Rare'),
          _guideLine('B', 'Unlikely'),
          _guideLine('C', 'Possible'),
          _guideLine('D', 'Likely'),
          _guideLine('E', 'Almost Certain'),
          pw.SizedBox(height: 6),
          pw.Text(
            'Risk Classification',
            style: pw.TextStyle(
              color: _navy,
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 3),
          _riskLegendLine(_lowRisk, 'Low', 'Score 1–4'),
          _riskLegendLine(_mediumRisk, 'Medium', 'Score 5–9'),
          _riskLegendLine(_highRisk, 'High', 'Score 10–16'),
          _riskLegendLine(_extremeRisk, 'Extreme', 'Score 17–25'),
        ],
      ),
    );
  }

  static pw.Widget _guideLine(String code, String meaning) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Text(
        '$code - $meaning',
        style: const pw.TextStyle(fontSize: 6),
      ),
    );
  }

  static pw.Widget _riskLegendLine(PdfColor color, String title, String score) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        children: [
          pw.Container(width: 12, height: 8, color: color),
          pw.SizedBox(width: 5),
          pw.Text('$title: $score', style: const pw.TextStyle(fontSize: 6)),
        ],
      ),
    );
  }

  static String _severityMeaning(int severity) {
    return switch (severity) {
      1 => 'Insignificant',
      2 => 'Minor',
      3 => 'Moderate',
      4 => 'Major',
      5 => 'Catastrophic',
      _ => 'Unknown',
    };
  }

  static List<pw.Widget> _supportingSections(RiskAssessmentResult result) {
    return [
      if (result.requiredPpe.isNotEmpty) ...[
        _informationBox('Required PPE', result.requiredPpe),
        pw.SizedBox(height: 7),
      ],
      if (result.requiredPermits.isNotEmpty) ...[
        _informationBox('Required Permits', result.requiredPermits),
        pw.SizedBox(height: 7),
      ],
      if (result.emergencyResponse.isNotEmpty) ...[
        _informationBox(
          'Emergency Response and Recovery',
          result.emergencyResponse,
        ),
        pw.SizedBox(height: 7),
      ],
      if (result.applicableStandards.isNotEmpty)
        _informationBox(
          'Applicable Standards and References',
          result.applicableStandards,
        ),
    ];
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

  static pw.Widget _legacyRiskSummary(RiskAssessmentResult result) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _informationBox('Hazards', result.hazards),
        pw.SizedBox(height: 7),
        _informationBox('Persons at Risk', result.personsAtRisk),
        pw.SizedBox(height: 7),
        _informationBox('Existing Controls', result.existingControls),
        pw.SizedBox(height: 7),
        _informationBox('Additional Controls', result.additionalControls),
        pw.SizedBox(height: 7),
        pw.Table(
          border: pw.TableBorder.all(color: _border, width: 0.7),
          columnWidths: const {
            0: pw.FlexColumnWidth(),
            1: pw.FlexColumnWidth(),
          },
          children: [
            pw.TableRow(
              children: [
                _legacyRiskBox('Initial Risk', result.initialRisk, _highRisk),
                _legacyRiskBox('Residual Risk', result.residualRisk, _lowRisk),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _legacyRiskBox(String title, String value, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(7),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Container(
            color: color,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: pw.Text(
              value.trim().isEmpty ? 'Not specified' : value,
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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

  static pw.Widget _continuationHeader(String reportNumber) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 7),
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _navy, width: 0.8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'SENTINEL HSE AI — TASK RISK ASSESSMENT',
            style: pw.TextStyle(
              color: _navy,
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
