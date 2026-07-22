import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'storage_service.dart';

class PdfService {
  static Future<void> generateHazardReport({
    required String inspectionId,
    required String inspector,
    required String location,
    required String analysis,
    required List<File> imageFiles,
  }) async {
    final now = DateTime.now();
    final pdf = pw.Document();

    final navy = PdfColor.fromInt(0xFF123B5D);
    final blue = PdfColor.fromInt(0xFF1D6FA5);
    final lightBlue = PdfColor.fromInt(0xFFEAF3F8);
    final lightGrey = PdfColor.fromInt(0xFFF4F6F8);
    final border = PdfColor.fromInt(0xFFB7C4CE);
    final green = PdfColor.fromInt(0xFF2E8B57);
    final orange = PdfColor.fromInt(0xFFE58C24);
    final red = PdfColor.fromInt(0xFFC94C4C);
    final amber = PdfColor.fromInt(0xFFFFC857);

    final formattedDate = DateFormat('dd MMM yyyy').format(now);

    final formattedTime = DateFormat('HH:mm').format(now);

    final reportNumber = inspectionId.trim().isEmpty
        ? 'HSE-${DateFormat('yyyyMMdd-HHmmss').format(now)}'
        : inspectionId.trim();

    final inspectionImages = <pw.MemoryImage>[];

    for (final imageFile in imageFiles) {
      inspectionImages.add(pw.MemoryImage(await imageFile.readAsBytes()));
    }

    final inspectionValues = <String, String>{};

    for (final rawLine in analysis.split('\n')) {
      final line = rawLine.trim();
      final separatorIndex = line.indexOf(':');

      if (separatorIndex <= 0) continue;

      final key = line.substring(0, separatorIndex).trim();

      final value = line.substring(separatorIndex + 1).trim();

      inspectionValues[key] = value;
    }

    const checklistItems = <String>[
      'Housekeeping',
      'PPE Compliance',
      'Fire Extinguishers',
      'Emergency Exit',
      'Working at Height',
      'Scaffolding',
      'Access and Egress',
      'Barricades and Signage',
      'Excavation Safety',
      'Lifting Operations',
      'Electrical Safety',
      'Hot Work',
      'Tools and Equipment',
      'First Aid Facilities',
      'Chemical Storage',
      'Environmental Controls',
      'Vehicle Movement',
      'Welfare Facilities',
    ];

    String checklistStatus(String item) {
      final rawStatus =
          inspectionValues[item]?.trim().toLowerCase() ?? 'not applicable';

      if (rawStatus == 'true' || rawStatus == 'compliant') {
        return 'Compliant';
      }

      if (rawStatus == 'false' ||
          rawStatus == 'non-compliant' ||
          rawStatus == 'not compliant') {
        return 'Non-Compliant';
      }

      return 'Not Applicable';
    }

    String checklistComment(String item) {
      final comment = inspectionValues['$item Comment']?.trim() ?? '';

      return comment.isEmpty ? 'No comment' : comment;
    }

    final compliantCount = checklistItems
        .where((item) => checklistStatus(item) == 'Compliant')
        .length;

    final nonCompliantCount = checklistItems
        .where((item) => checklistStatus(item) == 'Non-Compliant')
        .length;

    final applicableCount = compliantCount + nonCompliantCount;

    final compliancePercentage = applicableCount == 0
        ? 0.0
        : (compliantCount / applicableCount) * 100;

    final projectName = inspectionValues['Project']?.trim().isNotEmpty == true
        ? inspectionValues['Project']!.trim()
        : 'Not specified';

    final nonCompliantItems = checklistItems
        .where((item) => checklistStatus(item) == 'Non-Compliant')
        .toList();

    final overallResult = applicableCount == 0
        ? 'Not Assessed'
        : nonCompliantCount > 0
        ? 'Action Required'
        : 'Satisfactory';

    final riskLevel = applicableCount == 0
        ? 'Not Rated'
        : nonCompliantCount >= 3
        ? 'High'
        : nonCompliantCount >= 1
        ? 'Medium'
        : 'Low';

    PdfColor statusBackground(String status) {
      return switch (status) {
        'Compliant' => PdfColor.fromInt(0xFFEAF7EF),
        'Non-Compliant' => PdfColor.fromInt(0xFFFBECEC),
        _ => lightGrey,
      };
    }

    PdfColor statusForeground(String status) {
      return switch (status) {
        'Compliant' => green,
        'Non-Compliant' => red,
        _ => PdfColors.grey700,
      };
    }

    pw.Widget smallHeaderLine(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 3),
        child: pw.RichText(
          text: pw.TextSpan(
            style: const pw.TextStyle(fontSize: 6.5, color: PdfColors.black),
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

    pw.Widget informationLabel(String text) {
      return pw.Container(
        color: lightGrey,
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
        ),
      );
    }

    pw.Widget informationValue(String text) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(
          text.trim().isEmpty ? 'Not specified' : text,
          style: const pw.TextStyle(fontSize: 7),
        ),
      );
    }

    pw.Widget sectionHeading(String title) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        color: navy,
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

    pw.Widget summaryCard({
      required String label,
      required String value,
      required PdfColor color,
    }) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color, width: 0.8),
          borderRadius: pw.BorderRadius.circular(3),
        ),
        child: pw.Row(
          children: [
            pw.Container(width: 6, height: 25, color: color),
            pw.SizedBox(width: 7),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    value,
                    style: pw.TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(label, style: const pw.TextStyle(fontSize: 5.8)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget reportHeader() {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: navy, width: 1.2),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                color: navy,
                padding: const pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'SENTINEL HSE AI',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 17,
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
                  children: [
                    pw.Text(
                      'DAILY SITE INSPECTION',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      'Workplace Compliance, Findings and Corrective Action Report',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                color: lightBlue,
                padding: const pw.EdgeInsets.all(8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    smallHeaderLine('Inspection ID', reportNumber),
                    smallHeaderLine(
                      'Generated',
                      '$formattedDate, $formattedTime',
                    ),
                    smallHeaderLine('Revision', 'Rev. 0'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget continuationHeader() {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 7),
        padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: navy, width: 0.8)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'SENTINEL HSE AI - DAILY SITE INSPECTION',
              style: pw.TextStyle(
                color: navy,
                fontSize: 7,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(reportNumber, style: const pw.TextStyle(fontSize: 6.5)),
          ],
        ),
      );
    }

    pw.Widget footer(pw.Context context) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(top: 7),
        padding: const pw.EdgeInsets.only(top: 4),
        decoration: pw.BoxDecoration(
          border: pw.Border(top: pw.BorderSide(color: border, width: 0.6)),
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

    pw.Widget photoCard({
      required pw.MemoryImage image,
      required int number,
      required int total,
    }) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: border, width: 0.7),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Inspection Evidence Photo $number of $total',
              style: pw.TextStyle(
                color: navy,
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Container(
              width: double.infinity,
              height: 250,
              alignment: pw.Alignment.center,
              child: pw.Image(image, fit: pw.BoxFit.contain),
            ),
          ],
        ),
      );
    }

    pw.Widget signOffHeader(String text) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
        ),
      );
    }

    pw.Widget signOffCell() {
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

    final actionContent = applicableCount == 0
        ? pw.Text(
            'No checklist items were assessed. Mark each applicable item as Compliant or Non-Compliant before this inspection is approved.',
            style: const pw.TextStyle(fontSize: 8, lineSpacing: 2),
          )
        : nonCompliantItems.isEmpty
        ? pw.Text(
            'No non-compliant items were identified. Maintain existing controls and continue routine monitoring.',
            style: const pw.TextStyle(fontSize: 8, lineSpacing: 2),
          )
        : pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: nonCompliantItems.map((item) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Text(
                  '- $item requires corrective action, assignment of responsibility and verified closure.',
                  style: const pw.TextStyle(fontSize: 8, lineSpacing: 2),
                ),
              );
            }).toList(),
          );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 42, 28, 28),
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }

          return continuationHeader();
        },
        footer: footer,
        build: (context) => [
          reportHeader(),
          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: border, width: 0.7),
            columnWidths: const {
              0: pw.FixedColumnWidth(72),
              1: pw.FlexColumnWidth(2.4),
              2: pw.FixedColumnWidth(72),
              3: pw.FlexColumnWidth(1.3),
            },
            children: [
              pw.TableRow(
                children: [
                  informationLabel('Project'),
                  informationValue(projectName),
                  informationLabel('Status'),
                  informationValue('Open'),
                ],
              ),
              pw.TableRow(
                children: [
                  informationLabel('Inspector'),
                  informationValue(inspector),
                  informationLabel('Overall Result'),
                  informationValue(overallResult),
                ],
              ),
              pw.TableRow(
                children: [
                  informationLabel('Location'),
                  informationValue(location),
                  informationLabel('Risk Level'),
                  informationValue(riskLevel),
                ],
              ),
              pw.TableRow(
                children: [
                  informationLabel('Inspection Date'),
                  informationValue('$formattedDate, $formattedTime'),
                  informationLabel('Evidence Photos'),
                  informationValue(inspectionImages.length.toString()),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 10),

          pw.Row(
            children: [
              pw.Expanded(
                child: summaryCard(
                  label: 'Applicable Items',
                  value: '$applicableCount/${checklistItems.length}',
                  color: blue,
                ),
              ),
              pw.SizedBox(width: 6),
              pw.Expanded(
                child: summaryCard(
                  label: 'Compliant',
                  value: compliantCount.toString(),
                  color: green,
                ),
              ),
              pw.SizedBox(width: 6),
              pw.Expanded(
                child: summaryCard(
                  label: 'Non-Compliant',
                  value: nonCompliantCount.toString(),
                  color: red,
                ),
              ),
              pw.SizedBox(width: 6),
              pw.Expanded(
                child: summaryCard(
                  label: 'Compliance',
                  value: applicableCount == 0
                      ? 'N/A'
                      : '${compliancePercentage.toStringAsFixed(1)}%',
                  color: applicableCount == 0
                      ? PdfColors.grey600
                      : compliancePercentage >= 90
                      ? green
                      : compliancePercentage >= 70
                      ? amber
                      : red,
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 12),
          sectionHeading('Inspection Checklist'),
          pw.SizedBox(height: 6),

          pw.Table(
            border: pw.TableBorder.all(color: border, width: 0.7),
            columnWidths: const {
              0: pw.FixedColumnWidth(25),
              1: pw.FlexColumnWidth(2.2),
              2: pw.FlexColumnWidth(1.3),
              3: pw.FlexColumnWidth(3),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: blue),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'No.',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'Checklist Item',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'Status',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      'Comment / Observation',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ...checklistItems.asMap().entries.map((entry) {
                final item = entry.value;
                final status = checklistStatus(item);
                final comment = checklistComment(item);

                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        '${entry.key + 1}',
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 6.5),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        item,
                        style: const pw.TextStyle(fontSize: 6.5),
                      ),
                    ),
                    pw.Container(
                      color: statusBackground(status),
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        status,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 6.5,
                          fontWeight: pw.FontWeight.bold,
                          color: statusForeground(status),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        comment,
                        style: const pw.TextStyle(fontSize: 6.5),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 12),
          sectionHeading('Findings and Action Summary'),
          pw.SizedBox(height: 6),

          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: nonCompliantCount > 0
                    ? red
                    : applicableCount == 0
                    ? orange
                    : green,
                width: 0.8,
              ),
              color: lightGrey,
            ),
            child: actionContent,
          ),

          if (applicableCount == 0) ...[
            pw.SizedBox(height: 8),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFFFF4E5),
                border: pw.Border.all(color: orange, width: 0.8),
              ),
              child: pw.Text(
                'Assessment Warning: The inspection cannot be classified as Satisfactory or Low Risk because all checklist items were marked Not Applicable.',
                style: const pw.TextStyle(fontSize: 7),
              ),
            ),
          ],

          if (inspectionImages.isNotEmpty) ...[
            pw.NewPage(),
            sectionHeading('Inspection Evidence Photos'),
            pw.SizedBox(height: 8),

            for (int index = 0; index < inspectionImages.length; index++) ...[
              photoCard(
                image: inspectionImages[index],
                number: index + 1,
                total: inspectionImages.length,
              ),
              pw.SizedBox(height: 12),
            ],
          ],

          pw.SizedBox(height: 10),

          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: lightGrey,
              border: pw.Border.all(color: orange, width: 0.8),
            ),
            child: pw.Text(
              'Review Requirement: The inspector and responsible supervisor must review all findings. Non-compliant items require assigned corrective actions, target dates and verified closure before the inspection is considered complete.',
              style: const pw.TextStyle(fontSize: 7),
            ),
          ),

          pw.SizedBox(height: 12),

          pw.Table(
            border: pw.TableBorder.all(color: border, width: 0.7),
            columnWidths: const {
              0: pw.FlexColumnWidth(),
              1: pw.FlexColumnWidth(),
              2: pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: lightGrey),
                children: [
                  signOffHeader('Inspected By'),
                  signOffHeader('Reviewed By'),
                  signOffHeader('Approved By'),
                ],
              ),
              pw.TableRow(
                children: [signOffCell(), signOffCell(), signOffCell()],
              ),
            ],
          ),
        ],
      ),
    );

    final pdfBytes = await pdf.save();

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Sentinel_HSE_Daily_Inspection_$reportNumber.pdf',
    );
  }

  static Future<void> generateTextHazardReport({
    required int hazardNumber,
    required String hazardData,
  }) async {
    final pdf = pw.Document();

    final photoLine = hazardData.split('\n').firstWhere((line) {
      final trimmedLine = line.trim();

      return trimmedLine.startsWith('Photos:') ||
          trimmedLine.startsWith('Photo:');
    }, orElse: () => '');

    final photoText = photoLine.contains(':')
        ? photoLine.substring(photoLine.indexOf(':') + 1).trim()
        : '';

    final photoPaths = photoText
        .split('|')
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty && path.toLowerCase() != 'no photo')
        .toList();
    final visibleLines = hazardData
        .split('\n')
        .map((line) => line.trim())
        .where(
          (line) =>
              line.isNotEmpty &&
              !line.startsWith('Photo:') &&
              !line.startsWith('Photos:'),
        )
        .toList();

    String? finalHazardStatus;
    final cleanedHazardLines = <String>[];

    for (int index = 0; index < visibleLines.length; index++) {
      final line = visibleLines[index];
      final lowerLine = line.toLowerCase();

      if (lowerLine == 'status:') {
        if (index + 1 < visibleLines.length) {
          finalHazardStatus = visibleLines[index + 1];
          index++;
        }
        continue;
      }

      if (lowerLine.startsWith('status:')) {
        final statusValue = line.substring(line.indexOf(':') + 1).trim();

        if (statusValue.isNotEmpty) {
          finalHazardStatus = statusValue;
        }

        continue;
      }

      cleanedHazardLines.add(line);
    }

    if (finalHazardStatus != null) {
      cleanedHazardLines.add('Status: $finalHazardStatus');
    }

    final visibleHazardData = cleanedHazardLines.join('\n');
    final List<pw.MemoryImage> hazardPhotos = [];

    for (final photoPath in photoPaths) {
      final recoveredPhoto = await StorageService.getInspectionImage(photoPath);

      if (recoveredPhoto != null) {
        hazardPhotos.add(pw.MemoryImage(await recoveredPhoto.readAsBytes()));
      }
    }

    final formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    final formattedTime = DateFormat('HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 48, 32, 32),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'SENTINEL HSE AI',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                'Hazard Report',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 24),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: const {
                0: pw.FlexColumnWidth(1.2),
                1: pw.FlexColumnWidth(2.8),
              },
              children: [
                _reportRow('Hazard Number', hazardNumber.toString()),
                _reportRow('Date', formattedDate),
                _reportRow('Time', formattedTime),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Text(
              'Hazard Details',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            ...visibleHazardData
                .split('\n')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .map(
                  (line) => pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    margin: const pw.EdgeInsets.only(bottom: 4),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey400),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      line,
                      style: const pw.TextStyle(fontSize: 11, lineSpacing: 3),
                    ),
                  ),
                ),
            pw.SizedBox(height: 24),

            if (hazardPhotos.isNotEmpty) ...[
              pw.Text(
                'Hazard Evidence Photos',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              for (int index = 0; index < hazardPhotos.length; index++) ...[
                pw.Text(
                  'Photo ${index + 1} of ${hazardPhotos.length}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  width: double.infinity,
                  height: 260,
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Image(hazardPhotos[index], fit: pw.BoxFit.contain),
                ),
                pw.SizedBox(height: 18),
              ],
            ],

            pw.SizedBox(height: 30),
            pw.Text(
              'Prepared By',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 30),
            pw.Container(
              width: 200,
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.black),
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      name: 'Sentinel_HSE_Hazard_$hazardNumber.pdf',
      onLayout: (format) async => pdf.save(),
    );
  }

  static Future<void> generateAIInvestigationReport({
    required String incidentType,
    required String severity,
    required String riskLevel,
    required String location,
    required String investigationSummary,
    String evidencePhotoPath = '',
  }) async {
    final now = DateTime.now();

    final formattedDate = DateFormat('dd MMM yyyy').format(now);

    final formattedTime = DateFormat('HH:mm').format(now);

    final reportNumber = 'AI-${DateFormat('yyyyMMdd-HHmmss').format(now)}';

    final navy = PdfColor.fromInt(0xFF123B5D);
    final blue = PdfColor.fromInt(0xFF1D6FA5);
    final lightBlue = PdfColor.fromInt(0xFFEAF3F8);
    final lightGrey = PdfColor.fromInt(0xFFF4F6F8);
    final border = PdfColor.fromInt(0xFFB7C4CE);
    final green = PdfColor.fromInt(0xFF2E8B57);
    final orange = PdfColor.fromInt(0xFFE58C24);
    final red = PdfColor.fromInt(0xFFC94C4C);

    final evidencePhotoPaths = evidencePhotoPath
        .split('|')
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty && path.toLowerCase() != 'no photo')
        .toList();

    final evidencePhotoImages = <pw.MemoryImage>[];

    for (final photoPath in evidencePhotoPaths) {
      final recoveredPhoto = await StorageService.getInspectionImage(photoPath);

      if (recoveredPhoto != null) {
        evidencePhotoImages.add(
          pw.MemoryImage(await recoveredPhoto.readAsBytes()),
        );
      }
    }

    final type = incidentType.toLowerCase();

    String aiRootCause;
    String aiCorrectiveActions;
    String aiPreventiveActions;
    String aiLessonsLearned;

    if (type.contains('vehicle')) {
      aiRootCause =
          'Possible contributing factors include driver inattention, unsafe speed, poor lane discipline, fatigue, ineffective journey management, inadequate traffic controls, or failure to follow defensive-driving requirements.';

      aiCorrectiveActions =
          'Secure the incident scene, assist injured persons, notify the control room and relevant authorities, preserve evidence, inspect the vehicles, review IVMS information, and suspend the affected activity until the investigation is completed.';

      aiPreventiveActions =
          'Strengthen journey management, defensive-driving training, IVMS monitoring, speed control, fatigue management, vehicle inspection, route assessment, supervision, and closure of driving violations.';

      aiLessonsLearned =
          'Vehicle movements must be planned and controlled, drivers must remain fit and competent, and unsafe driving indicators must be corrected before they result in a serious incident.';
    } else if (type.contains('fire')) {
      aiRootCause =
          'Possible contributing factors include uncontrolled ignition sources, poor housekeeping, ineffective hot-work controls, improper storage of flammable materials, equipment failure, or inadequate fire-prevention arrangements.';

      aiCorrectiveActions =
          'Raise the alarm, stop work, evacuate personnel, isolate energy sources where safe, contact emergency services, preserve the scene, and use firefighting equipment only when personnel are trained and conditions are safe.';

      aiPreventiveActions =
          'Strengthen hot-work permits, gas testing, fire-watch arrangements, housekeeping, flammable-material storage, equipment inspection, ignition-source control, emergency drills, and fire-extinguisher readiness.';

      aiLessonsLearned =
          'Fire prevention requires effective permit control, ignition-source management, good housekeeping, trained personnel, and immediate emergency response.';
    } else if (type.contains('height') || type.contains('fall')) {
      aiRootCause =
          'Possible contributing factors include inadequate work-at-height planning, unsafe access equipment, missing edge protection, unsuitable anchorage, failure to maintain continuous attachment, poor supervision, or an incomplete rescue plan.';

      aiCorrectiveActions =
          'Stop the work, initiate rescue arrangements, assist affected persons, secure the area, inspect access and fall-protection equipment, preserve evidence, and review the work-at-height permit and risk assessment.';

      aiPreventiveActions =
          'Use approved scaffolds and access systems, inspect harnesses and anchor points, maintain edge protection, enforce continuous attachment, provide competent supervision, and ensure a task-specific rescue plan is available.';

      aiLessonsLearned =
          'Work at height must be properly planned, permitted, supervised, and carried out only with suitable access, fall prevention, fall arrest, and rescue arrangements.';
    } else if (type.contains('confined')) {
      aiRootCause =
          'Possible contributing factors include inadequate atmospheric testing, poor ventilation, ineffective isolation, failure of entry-permit controls, weak communication, or insufficient rescue preparedness.';

      aiCorrectiveActions =
          'Evacuate the confined space, isolate and barricade the area, conduct atmospheric testing, provide ventilation, account for all entrants, notify emergency personnel, and review the entry permit before any re-entry.';

      aiPreventiveActions =
          'Maintain continuous gas monitoring, positive isolation, trained attendants, reliable communication, controlled entry and exit, suitable ventilation, competent supervision, and a rehearsed confined-space rescue plan.';

      aiLessonsLearned =
          'Confined-space entry must never begin without effective isolation, testing, ventilation, communication, supervision, standby personnel, and rescue readiness.';
    } else {
      aiRootCause =
          'The incident may have resulted from inadequate hazard identification, ineffective controls, equipment defects, unsafe acts, unsafe conditions, weak supervision, insufficient maintenance, or failure to follow the approved procedure.';

      aiCorrectiveActions =
          'Stop the activity, secure the area, assist affected persons, notify responsible personnel, preserve evidence, inspect the equipment or workplace, and complete the investigation before work resumes.';

      aiPreventiveActions =
          'Review the risk assessment and work procedure, correct defective conditions, strengthen preventive maintenance, retrain affected personnel, improve supervision, communicate lessons learned, and verify effective closure of all corrective actions.';

      aiLessonsLearned =
          'All incidents and near misses must be reported promptly, investigated thoroughly, corrected effectively, and communicated to prevent recurrence.';
    }

    final cleanedSummary = investigationSummary
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll(RegExp(r',\s*(?=[A-Za-z][A-Za-z ]{1,40}:)'), '\n');

    final summaryLines = cleanedSummary
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final investigationFields = <MapEntry<String, String>>[];

    final additionalDetails = <String>[];

    for (final line in summaryLines) {
      final separatorIndex = line.indexOf(':');

      if (separatorIndex <= 0) {
        if (!line.contains('/var/mobile/')) {
          additionalDetails.add(line);
        }

        continue;
      }

      var title = line.substring(0, separatorIndex).trim();

      var value = line.substring(separatorIndex + 1).trim();

      final lowerTitle = title.toLowerCase();
      final lowerValue = value.toLowerCase();

      if (lowerTitle.contains('photo') ||
          lowerTitle.contains('evidence path') ||
          value.contains('/var/mobile/') ||
          lowerValue == 'no photo') {
        continue;
      }

      if (lowerTitle == 'location' ||
          lowerTitle == 'incident type' ||
          lowerTitle == 'severity') {
        continue;
      }

      if (lowerTitle == 'date') {
        final parsedDate = DateTime.tryParse(value);

        if (parsedDate != null) {
          title = 'Record Created';
          value = DateFormat('dd MMM yyyy, HH:mm').format(parsedDate.toLocal());
        }
      }

      if (title.isNotEmpty && value.isNotEmpty) {
        investigationFields.add(MapEntry(title, value));
      }
    }

    if (additionalDetails.isNotEmpty) {
      investigationFields.add(
        MapEntry('Additional Details', additionalDetails.join(' ')),
      );
    }

    PdfColor riskColor(String value) {
      final normalized = value.toLowerCase();

      if (normalized.contains('critical') || normalized.contains('extreme')) {
        return red;
      }

      if (normalized.contains('high')) {
        return orange;
      }

      if (normalized.contains('medium') || normalized.contains('moderate')) {
        return PdfColor.fromInt(0xFFFFC857);
      }

      if (normalized.contains('low')) {
        return green;
      }

      return border;
    }

    pw.Widget smallHeaderLine(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 3),
        child: pw.RichText(
          text: pw.TextSpan(
            style: const pw.TextStyle(fontSize: 6.5, color: PdfColors.black),
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

    pw.Widget informationLabel(String text) {
      return pw.Container(
        color: lightGrey,
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
        ),
      );
    }

    pw.Widget informationValue(String text) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(
          text.trim().isEmpty ? 'Not specified' : text,
          style: const pw.TextStyle(fontSize: 7),
        ),
      );
    }

    pw.Widget sectionHeading(String title) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        color: navy,
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

    pw.Widget summaryCard({
      required String label,
      required String value,
      required PdfColor color,
    }) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color, width: 0.8),
          borderRadius: pw.BorderRadius.circular(3),
        ),
        child: pw.Row(
          children: [
            pw.Container(width: 6, height: 25, color: color),
            pw.SizedBox(width: 7),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    value.trim().isEmpty ? 'N/A' : value,
                    style: pw.TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(label, style: const pw.TextStyle(fontSize: 6.2)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget analysisSection({
      required String title,
      required String value,
      required PdfColor color,
    }) {
      return pw.Container(
        width: double.infinity,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: border, width: 0.7),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: double.infinity,
              color: lightBlue,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 5,
              ),
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  color: color,
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                value.trim().isEmpty ? 'Not specified' : value,
                style: const pw.TextStyle(fontSize: 8, lineSpacing: 2),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget evidencePhotoCard({
      required pw.MemoryImage image,
      required int number,
      required int total,
    }) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: border, width: 0.7),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Incident Evidence Photo $number of $total',
              style: pw.TextStyle(
                color: navy,
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Container(
              width: double.infinity,
              height: 220,
              alignment: pw.Alignment.center,
              child: pw.Image(image, fit: pw.BoxFit.contain),
            ),
          ],
        ),
      );
    }

    pw.Widget signOffHeader(String text) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
        ),
      );
    }

    pw.Widget signOffCell() {
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

    pw.Widget signOffSection() {
      return pw.Table(
        border: pw.TableBorder.all(color: border, width: 0.7),
        columnWidths: const {
          0: pw.FlexColumnWidth(),
          1: pw.FlexColumnWidth(),
          2: pw.FlexColumnWidth(),
        },
        children: [
          pw.TableRow(
            decoration: pw.BoxDecoration(color: lightGrey),
            children: [
              signOffHeader('Prepared By'),
              signOffHeader('Reviewed By'),
              signOffHeader('Approved By'),
            ],
          ),
          pw.TableRow(children: [signOffCell(), signOffCell(), signOffCell()]),
        ],
      );
    }

    pw.Widget reportHeader() {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: navy, width: 1.2),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                color: navy,
                padding: const pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'SENTINEL HSE AI',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 17,
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
                  children: [
                    pw.Text(
                      'INCIDENT INVESTIGATION REPORT',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      'Incident Details, Evidence, Root Cause and Corrective Actions',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 7.5),
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                color: lightBlue,
                padding: const pw.EdgeInsets.all(8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    smallHeaderLine('Report No.', reportNumber),
                    smallHeaderLine(
                      'Generated',
                      '$formattedDate, $formattedTime',
                    ),
                    smallHeaderLine('Revision', 'Rev. 0'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget continuationHeader() {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 7),
        padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: navy, width: 0.8)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'SENTINEL HSE AI - INCIDENT INVESTIGATION',
              style: pw.TextStyle(
                color: navy,
                fontSize: 7,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(reportNumber, style: const pw.TextStyle(fontSize: 6.5)),
          ],
        ),
      );
    }

    pw.Widget footer(pw.Context context) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(top: 7),
        padding: const pw.EdgeInsets.only(top: 4),
        decoration: pw.BoxDecoration(
          border: pw.Border(top: pw.BorderSide(color: border, width: 0.6)),
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

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 42, 28, 28),
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }

          return continuationHeader();
        },
        footer: footer,
        build: (context) => [
          reportHeader(),
          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: border, width: 0.7),
            columnWidths: const {
              0: pw.FixedColumnWidth(72),
              1: pw.FlexColumnWidth(2.4),
              2: pw.FixedColumnWidth(72),
              3: pw.FlexColumnWidth(1.3),
            },
            children: [
              pw.TableRow(
                children: [
                  informationLabel('Incident Type'),
                  informationValue(incidentType),
                  informationLabel('Severity'),
                  informationValue(severity),
                ],
              ),
              pw.TableRow(
                children: [
                  informationLabel('Location'),
                  informationValue(location),
                  informationLabel('AI Risk Level'),
                  informationValue(riskLevel),
                ],
              ),
              pw.TableRow(
                children: [
                  informationLabel('Report Date'),
                  informationValue('$formattedDate, $formattedTime'),
                  informationLabel('Evidence Photos'),
                  informationValue(evidencePhotoImages.length.toString()),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 10),

          pw.Row(
            children: [
              pw.Expanded(
                child: summaryCard(
                  label: 'Incident Type',
                  value: incidentType,
                  color: blue,
                ),
              ),
              pw.SizedBox(width: 6),
              pw.Expanded(
                child: summaryCard(
                  label: 'Severity',
                  value: severity,
                  color: riskColor(severity),
                ),
              ),
              pw.SizedBox(width: 6),
              pw.Expanded(
                child: summaryCard(
                  label: 'AI Risk Level',
                  value: riskLevel,
                  color: riskColor(riskLevel),
                ),
              ),
              pw.SizedBox(width: 6),
              pw.Expanded(
                child: summaryCard(
                  label: 'Evidence Photos',
                  value: evidencePhotoImages.length.toString(),
                  color: green,
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 12),
          sectionHeading('Incident Investigation Details'),
          pw.SizedBox(height: 6),

          if (investigationFields.isEmpty)
            analysisSection(
              title: 'Investigation Summary',
              value: cleanedSummary,
              color: blue,
            )
          else
            pw.Table(
              border: pw.TableBorder.all(color: border, width: 0.7),
              columnWidths: const {
                0: pw.FixedColumnWidth(110),
                1: pw.FlexColumnWidth(),
              },
              children: investigationFields.map((field) {
                return pw.TableRow(
                  children: [
                    informationLabel(field.key),
                    informationValue(field.value),
                  ],
                );
              }).toList(),
            ),

          if (evidencePhotoImages.isNotEmpty) ...[
            pw.NewPage(),
            pw.SizedBox(height: 12),
            sectionHeading('Incident Evidence Photos'),
            pw.SizedBox(height: 8),

            for (
              int index = 0;
              index < evidencePhotoImages.length;
              index++
            ) ...[
              evidencePhotoCard(
                image: evidencePhotoImages[index],
                number: index + 1,
                total: evidencePhotoImages.length,
              ),
              pw.SizedBox(height: 12),
            ],
          ],

          pw.SizedBox(height: 8),
          sectionHeading('Investigation Findings and Actions'),
          pw.SizedBox(height: 7),

          analysisSection(
            title: 'AI Root Cause Analysis',
            value: aiRootCause,
            color: red,
          ),
          pw.SizedBox(height: 8),

          analysisSection(
            title: 'Immediate Corrective Actions',
            value: aiCorrectiveActions,
            color: orange,
          ),
          pw.SizedBox(height: 8),

          analysisSection(
            title: 'Preventive Actions',
            value: aiPreventiveActions,
            color: green,
          ),
          pw.SizedBox(height: 8),

          analysisSection(
            title: 'Lessons Learned',
            value: aiLessonsLearned,
            color: navy,
          ),

          pw.SizedBox(height: 12),

          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: lightGrey,
              border: pw.Border.all(color: orange, width: 0.8),
            ),
            child: pw.Text(
              'Review Requirement: This AI-assisted investigation must be reviewed by a competent investigation team. Corrective actions must be assigned, tracked, verified for effectiveness, and formally closed before the incident is considered complete.',
              style: const pw.TextStyle(fontSize: 7),
            ),
          ),

          pw.SizedBox(height: 12),
          signOffSection(),
        ],
      ),
    );

    final pdfBytes = await pdf.save();

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Sentinel_HSE_AI_Investigation_Report_$reportNumber.pdf',
    );
  }

  static Future<void> generateCapaReport({required String capaData}) async {
    final pdf = pw.Document();

    final lines = capaData
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final actionIndex = lines.indexWhere((line) => line.startsWith('Action:'));

    final hazardLines = actionIndex == -1
        ? List<String>.from(lines)
        : lines.sublist(0, actionIndex);

    final actionLines = actionIndex == -1
        ? <String>[]
        : lines.sublist(actionIndex);

    if (hazardLines.isNotEmpty && hazardLines.first.startsWith('Hazard:')) {
      hazardLines[0] = hazardLines.first.substring('Hazard:'.length).trim();
    }

    final hazardFields = <String, String>{};
    final hazardDescriptions = <String>[];

    for (final line in hazardLines) {
      final separatorIndex = line.indexOf(':');

      if (separatorIndex == -1) {
        hazardDescriptions.add(line);
        continue;
      }

      final title = line.substring(0, separatorIndex).trim();
      final value = line.substring(separatorIndex + 1).trim();

      hazardFields[title] = value;
    }

    final actionFields = <String, String>{};

    for (final line in actionLines) {
      final separatorIndex = line.indexOf(':');

      if (separatorIndex == -1) continue;

      final title = line.substring(0, separatorIndex).trim();
      final value = line.substring(separatorIndex + 1).trim();

      actionFields[title] = value;
    }

    List<String> extractPhotoPaths(String? storedPaths) {
      if (storedPaths == null ||
          storedPaths.trim().isEmpty ||
          storedPaths.toLowerCase() == 'no photo') {
        return [];
      }

      return storedPaths
          .split('|')
          .map((path) => path.trim())
          .where((path) => path.isNotEmpty)
          .toList();
    }

    Future<List<pw.MemoryImage>> loadPhotos(List<String> storedPaths) async {
      final images = <pw.MemoryImage>[];

      for (final storedPath in storedPaths) {
        final recoveredFile = await StorageService.getInspectionImage(
          storedPath,
        );

        if (recoveredFile != null) {
          images.add(pw.MemoryImage(await recoveredFile.readAsBytes()));
        }
      }

      return images;
    }

    final inspectionPhotoPaths = extractPhotoPaths(
      hazardFields['Photos'] ?? hazardFields['Photo'],
    );

    final evidencePhotoPaths = extractPhotoPaths(
      actionFields['Evidence Photos'] ?? actionFields['Evidence Photo'],
    );

    final inspectionPhotos = await loadPhotos(inspectionPhotoPaths);

    final evidencePhotos = await loadPhotos(evidencePhotoPaths);

    const checklistItems = <String>[
      'Housekeeping',
      'PPE Compliance',
      'Fire Extinguishers',
      'Emergency Exit',
      'Working at Height',
      'Scaffolding',
      'Access and Egress',
      'Barricades and Signage',
      'Excavation Safety',
      'Lifting Operations',
      'Electrical Safety',
      'Hot Work',
      'Tools and Equipment',
      'First Aid Facilities',
      'Chemical Storage',
      'Environmental Controls',
      'Vehicle Movement',
      'Welfare Facilities',
    ];

    final checklistEntries = checklistItems
        .where((item) => hazardFields[item] != null)
        .map((item) => MapEntry(item, hazardFields[item] ?? 'Not specified'))
        .toList();

    String friendlyStatus(String value) {
      final status = value.trim().toLowerCase();

      if (status == 'true' || status == 'compliant') {
        return 'Compliant';
      }

      if (status == 'false' ||
          status == 'non-compliant' ||
          status == 'not compliant') {
        return 'Non-Compliant';
      }

      if (status == 'not applicable' || status == 'n/a' || status == 'na') {
        return 'Not Applicable';
      }

      return value;
    }

    final reportNumber =
        'CAPA-${DateFormat('yyyyMMdd-HHmmss').format(DateTime.now())}';

    final generatedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    final generatedTime = DateFormat('HH:mm').format(DateTime.now());
    String formatStoredDate(String? value, {bool includeTime = false}) {
      if (value == null || value.trim().isEmpty) {
        return 'Not specified';
      }

      final parsedDate = DateTime.tryParse(value.trim());

      if (parsedDate == null) {
        return value.trim();
      }

      return DateFormat(
        includeTime ? 'dd MMM yyyy, HH:mm' : 'dd MMM yyyy',
      ).format(parsedDate);
    }

    final status = actionFields['Status'] ?? 'Not specified';
    final priority = actionFields['Priority'] ?? 'Not specified';
    final dueDate = formatStoredDate(actionFields['Due Date']);
    final responsible = actionFields['Responsible'] ?? 'Not specified';
    final actionRequired = actionFields['Action'] ?? 'Not specified';
    final createdDate = formatStoredDate(
      actionFields['Date'],
      includeTime: true,
    );

    final sourceFields = <String, String>{
      if (hazardFields['Project']?.isNotEmpty == true)
        'Project': hazardFields['Project']!,
      if (hazardFields['Location']?.isNotEmpty == true)
        'Location': hazardFields['Location']!,
      if (hazardFields['Inspector']?.isNotEmpty == true)
        'Inspector': hazardFields['Inspector']!,
      if (hazardFields['Date']?.isNotEmpty == true)
        'Inspection Date': formatStoredDate(
          hazardFields['Date'],
          includeTime: true,
        ),
    };

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 48, 32, 32),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'SENTINEL HSE AI',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                'Corrective Action / CAPA Report',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                'Report Number: $reportNumber',
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
            pw.SizedBox(height: 24),

            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: const {
                0: pw.FlexColumnWidth(1.3),
                1: pw.FlexColumnWidth(2.7),
              },
              children: [
                _reportRow('Generated Date', generatedDate),
                _reportRow('Generated Time', generatedTime),
                _reportRow('Status', status),
                _reportRow('Priority', priority),
                _reportRow('Due Date', dueDate),
                _reportRow('Responsible Person', responsible),
                _reportRow('Created', createdDate),
              ],
            ),

            if (sourceFields.isNotEmpty) ...[
              pw.SizedBox(height: 24),
              pw.Text(
                'Source Inspection',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.3),
                  1: pw.FlexColumnWidth(2.7),
                },
                children: sourceFields.entries
                    .map((entry) => _reportRow(entry.key, entry.value))
                    .toList(),
              ),
            ],

            pw.SizedBox(height: 24),
            pw.Text(
              'Hazard Description',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                hazardDescriptions.isEmpty
                    ? 'Not specified'
                    : hazardDescriptions.join('\n'),
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
              ),
            ),

            if (checklistEntries.isNotEmpty) ...[
              pw.SizedBox(height: 24),
              pw.Text(
                'Inspection Checklist',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(1.5),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(9),
                        child: pw.Text(
                          'Checklist Item',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(9),
                        child: pw.Text(
                          'Status',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...checklistEntries.map((entry) {
                    final displayStatus = friendlyStatus(entry.value);

                    final statusColor = displayStatus == 'Compliant'
                        ? PdfColors.green
                        : displayStatus == 'Non-Compliant'
                        ? PdfColors.red
                        : PdfColors.grey700;

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(9),
                          child: pw.Text(
                            entry.key,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(9),
                          child: pw.Text(
                            displayStatus,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],

            pw.SizedBox(height: 24),
            pw.Text(
              'Corrective Action Required',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                actionRequired,
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
              ),
            ),

            if (inspectionPhotos.isNotEmpty) ...[
              pw.SizedBox(height: 24),
              pw.Text(
                'Source Inspection Photos',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              for (int index = 0; index < inspectionPhotos.length; index++) ...[
                pw.Text(
                  'Photo ${index + 1} of ${inspectionPhotos.length}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  width: double.infinity,
                  height: 250,
                  alignment: pw.Alignment.center,
                  child: pw.Image(
                    inspectionPhotos[index],
                    fit: pw.BoxFit.contain,
                  ),
                ),
                pw.SizedBox(height: 18),
              ],
            ],

            if (evidencePhotos.isNotEmpty) ...[
              pw.SizedBox(height: 24),
              pw.Text(
                'Corrective Action Evidence',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              for (int index = 0; index < evidencePhotos.length; index++) ...[
                pw.Text(
                  'Evidence ${index + 1} of ${evidencePhotos.length}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  width: double.infinity,
                  height: 250,
                  alignment: pw.Alignment.center,
                  child: pw.Image(
                    evidencePhotos[index],
                    fit: pw.BoxFit.contain,
                  ),
                ),
                pw.SizedBox(height: 18),
              ],
            ],

            pw.SizedBox(height: 30),
            pw.Text(
              'Responsible Person Signature',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 30),
            pw.Container(
              width: 220,
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.black),
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      name: 'Sentinel_HSE_CAPA_$reportNumber.pdf',
      onLayout: (format) async => pdf.save(),
    );
  }

  static pw.TableRow _reportRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(value)),
      ],
    );
  }
}
