import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../services/storage_service.dart';
import '../models/toolbox_talk_result.dart';
import '../../branding/models/branding_settings.dart';
import '../../branding/services/branding_service.dart';

class ToolboxTalkPdfService {
  ToolboxTalkPdfService._();

  static final PdfColor _navy = PdfColor.fromInt(0xFF123B5D);
  static final PdfColor _blue = PdfColor.fromInt(0xFF1D6FA5);
  static final PdfColor _lightBlue = PdfColor.fromInt(0xFFEAF3F8);
  static final PdfColor _lightGrey = PdfColor.fromInt(0xFFF4F6F8);
  static final PdfColor _border = PdfColor.fromInt(0xFFB7C4CE);
  static final PdfColor _green = PdfColor.fromInt(0xFF2E8B57);
  static final PdfColor _orange = PdfColor.fromInt(0xFFE58C24);
  static final PdfColor _red = PdfColor.fromInt(0xFFC94C4C);

  static Future<void> generateReport({
    required ToolboxTalkResult result,
  }) async {
    final branding = await BrandingService.load();

    final logoFile = await BrandingService.getLogoFile(branding.logoPath);

    final Uint8List? logoBytes = logoFile == null
        ? null
        : await logoFile.readAsBytes();

    final brandColor = PdfColor.fromInt(branding.primaryColorValue);
    final reportDate = result.createdAt;

    final formattedDate = DateFormat('dd MMM yyyy').format(reportDate);

    final formattedTime = DateFormat('HH:mm').format(reportDate);

    final reportNumber =
        'TBT-${DateFormat('yyyyMMdd-HHmmss').format(reportDate)}';

    final evidencePhotoPaths = result.evidencePhotoPath
        .split('|')
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty && path.toLowerCase() != 'no photo')
        .toList();

    final evidencePhotos = <pw.MemoryImage>[];

    for (final photoPath in evidencePhotoPaths) {
      final evidencePhotoFile = await StorageService.getInspectionImage(
        photoPath,
      );

      if (evidencePhotoFile != null) {
        evidencePhotos.add(
          pw.MemoryImage(await evidencePhotoFile.readAsBytes()),
        );
      }
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

          return _continuationHeader(reportNumber, branding, brandColor);
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
              branding: branding,
              logoBytes: logoBytes,
              brandColor: brandColor,
            ),
            pw.SizedBox(height: 10),

            _documentInformation(
              result: result,
              reportNumber: reportNumber,
              formattedDate: formattedDate,
              formattedTime: formattedTime,
              photoCount: evidencePhotos.length,
            ),
            pw.SizedBox(height: 10),

            _summaryStrip(
              hazardCount: result.keyHazards.length,
              precautionCount: result.safetyPrecautions.length,
              ppeCount: result.requiredPpe.length,
              questionCount: result.discussionQuestions.length,
            ),
            pw.SizedBox(height: 12),

            _sectionHeading('Toolbox Talk Content'),
            pw.SizedBox(height: 7),

            _textSection(
              title: 'Objective',
              value: result.objective,
              color: _blue,
            ),
            pw.SizedBox(height: 8),

            _listSection(
              title: 'Key Hazards',
              items: result.keyHazards,
              color: _red,
            ),
            pw.SizedBox(height: 8),

            _listSection(
              title: 'Safety Precautions',
              items: result.safetyPrecautions,
              color: _green,
            ),
            pw.SizedBox(height: 8),

            _listSection(
              title: 'Required PPE',
              items: result.requiredPpe,
              color: _blue,
            ),
            pw.SizedBox(height: 8),

            _listSection(
              title: 'Discussion Questions',
              items: result.discussionQuestions,
              color: _orange,
            ),
            pw.SizedBox(height: 8),

            _textSection(
              title: 'Supervisor Message',
              value: result.supervisorMessage,
              color: _navy,
            ),

            if (evidencePhotos.isNotEmpty) ...[
              pw.SizedBox(height: 12),
              _sectionHeading('Toolbox Talk Evidence Photos'),
              pw.SizedBox(height: 8),

              for (int index = 0; index < evidencePhotos.length; index++) ...[
                _evidencePhotoCard(
                  image: evidencePhotos[index],
                  number: index + 1,
                  total: evidencePhotos.length,
                ),
                pw.SizedBox(height: 12),
              ],
            ],

            pw.SizedBox(height: 10),
            _reviewNotice(),
            pw.SizedBox(height: 12),

            _attendanceSection(),
            pw.SizedBox(height: 12),

            _signOffSection(),
          ];
        },
      ),
    );

    final pdfBytes = await pdf.save();

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Sentinel_HSE_Toolbox_Talk_$reportNumber.pdf',
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
                          style: pw.TextStyle(
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
                    'TOOLBOX TALK REPORT',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: _navy,
                      fontSize: 17,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Hazard Awareness, Safe Work Precautions and Workforce Engagement',
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
              color: _lightBlue,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _smallHeaderLine('Report No.', reportNumber),
                  _smallHeaderLine(
                    'Delivered',
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

  static pw.Widget _documentInformation({
    required ToolboxTalkResult result,
    required String reportNumber,
    required String formattedDate,
    required String formattedTime,
    required int photoCount,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.7),
      columnWidths: const {
        0: pw.FixedColumnWidth(75),
        1: pw.FlexColumnWidth(2.8),
        2: pw.FixedColumnWidth(75),
        3: pw.FlexColumnWidth(1.2),
      },
      children: [
        pw.TableRow(
          children: [
            _informationLabel('Topic'),
            _informationValue(
              result.topic.trim().isEmpty ? 'Not specified' : result.topic,
            ),
            _informationLabel('Document Type'),
            _informationValue('Toolbox Talk'),
          ],
        ),
        pw.TableRow(
          children: [
            _informationLabel('Delivery Date'),
            _informationValue('$formattedDate, $formattedTime'),
            _informationLabel('Report Number'),
            _informationValue(reportNumber),
          ],
        ),
        pw.TableRow(
          children: [
            _informationLabel('Evidence Photos'),
            _informationValue(photoCount.toString()),
            _informationLabel('Status'),
            _informationValue('Completed'),
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
    required int precautionCount,
    required int ppeCount,
    required int questionCount,
  }) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _summaryCard(
            label: 'Key Hazards',
            value: hazardCount.toString(),
            color: _red,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: _summaryCard(
            label: 'Precautions',
            value: precautionCount.toString(),
            color: _green,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: _summaryCard(
            label: 'PPE Items',
            value: ppeCount.toString(),
            color: _blue,
          ),
        ),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: _summaryCard(
            label: 'Discussion Questions',
            value: questionCount.toString(),
            color: _orange,
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
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color, width: 0.8),
        borderRadius: pw.BorderRadius.circular(3),
      ),
      child: pw.Row(
        children: [
          pw.Container(width: 6, height: 25, color: color),
          pw.SizedBox(width: 7),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                value,
                style: pw.TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(label, style: const pw.TextStyle(fontSize: 6.2)),
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

  static pw.Widget _textSection({
    required String title,
    required String value,
    required PdfColor color,
  }) {
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
            padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 5),
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

  static pw.Widget _listSection({
    required String title,
    required List<String> items,
    required PdfColor color,
  }) {
    final visibleItems = items.where((item) => item.trim().isNotEmpty).toList();

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
            padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 5),
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
            child: visibleItems.isEmpty
                ? pw.Text(
                    'Not specified',
                    style: const pw.TextStyle(fontSize: 8),
                  )
                : pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: visibleItems.map((item) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text(
                          '- $item',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            lineSpacing: 2,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _evidencePhotoCard({
    required pw.MemoryImage image,
    required int number,
    required int total,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border, width: 0.7),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Evidence Photo $number of $total',
            style: pw.TextStyle(
              color: _navy,
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Container(
            width: double.infinity,
            height: 230,
            alignment: pw.Alignment.center,
            child: pw.Image(image, fit: pw.BoxFit.contain),
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
        'Delivery Requirement: The supervisor must explain the topic in a language understood by the workforce, encourage questions, confirm understanding and record attendance before work begins.',
        style: const pw.TextStyle(fontSize: 7),
      ),
    );
  }

  static pw.Widget _attendanceSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeading('Workforce Attendance Record'),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(color: _border, width: 0.7),
          columnWidths: const {
            0: pw.FixedColumnWidth(28),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(1.5),
            3: pw.FlexColumnWidth(1.5),
          },
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: _lightGrey),
              children: [
                _attendanceHeader('No.'),
                _attendanceHeader('Name'),
                _attendanceHeader('Employee ID'),
                _attendanceHeader('Signature'),
              ],
            ),
            ...List.generate(
              6,
              (index) => pw.TableRow(
                children: [
                  _attendanceCell('${index + 1}'),
                  _attendanceCell(''),
                  _attendanceCell(''),
                  _attendanceCell(''),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _attendanceHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _attendanceCell(String text) {
    return pw.Container(
      height: 24,
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 7),
      ),
    );
  }

  static pw.Widget _signOffSection() {
    return pw.Table(
      border: pw.TableBorder.all(color: _border, width: 0.7),
      columnWidths: const {0: pw.FlexColumnWidth(), 1: pw.FlexColumnWidth()},
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _lightGrey),
          children: [
            _signOffHeader('Delivered By'),
            _signOffHeader('HSE Representative'),
          ],
        ),
        pw.TableRow(children: [_signOffCell(), _signOffCell()]),
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
                ? 'SENTINEL HSE - TOOLBOX TALK REPORT'
                : '${branding.companyName} - TOOLBOX TALK REPORT',
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
