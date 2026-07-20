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
    final pdf = pw.Document();

    final List<pw.MemoryImage> inspectionImages = [];

    for (final imageFile in imageFiles) {
      final imageBytes = await imageFile.readAsBytes();
      inspectionImages.add(pw.MemoryImage(imageBytes));
    }

    final String formattedDate = DateFormat(
      'dd MMMM yyyy',
    ).format(DateTime.now());

    final String formattedTime = DateFormat('HH:mm').format(DateTime.now());

    final inspectionValues = <String, String>{};

    for (final rawLine in analysis.split('\n')) {
      final line = rawLine.trim();
      final separatorIndex = line.indexOf(':');

      if (separatorIndex <= 0) {
        continue;
      }

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

    final compliantCount = checklistItems
        .where((item) => checklistStatus(item) == 'Compliant')
        .length;

    final nonCompliantCount = checklistItems
        .where((item) => checklistStatus(item) == 'Non-Compliant')
        .length;

    final notApplicableCount = checklistItems
        .where((item) => checklistStatus(item) == 'Not Applicable')
        .length;

    final projectName = inspectionValues['Project']?.trim().isNotEmpty == true
        ? inspectionValues['Project']!.trim()
        : 'Not specified';

    final overallResult = nonCompliantCount > 0
        ? 'Action Required'
        : 'Satisfactory';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
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
                'Daily Site Inspection Report',
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
                _reportRow('Inspection ID', inspectionId),
                _reportRow('Project', projectName),
                _reportRow('Date', formattedDate),
                _reportRow('Time', formattedTime),
                _reportRow('Inspector', inspector),
                _reportRow('Location', location),
                _reportRow('Overall Result', overallResult),
                _reportRow('Status', 'Open'),
              ],
            ),

            pw.SizedBox(height: 24),

            pw.Text(
              'Inspection Summary',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: const {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(1),
              },
              children: [
                _reportRow('Compliant Items', compliantCount.toString()),
                _reportRow('Non-Compliant Items', nonCompliantCount.toString()),
                _reportRow(
                  'Not Applicable Items',
                  notApplicableCount.toString(),
                ),
                _reportRow(
                  'Total Checklist Items',
                  checklistItems.length.toString(),
                ),
              ],
            ),

            pw.SizedBox(height: 24),

            pw.Text(
              'Inspection Checklist',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
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
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
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
                ...checklistItems.map((item) {
                  final status = checklistStatus(item);

                  final statusColor = status == 'Compliant'
                      ? PdfColors.green
                      : status == 'Non-Compliant'
                      ? PdfColors.red
                      : PdfColors.grey700;

                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(9),
                        child: pw.Text(
                          item,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(9),
                        child: pw.Text(
                          status,
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

            pw.SizedBox(height: 24),

            pw.Text(
              'Inspection Photos',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            if (inspectionImages.isEmpty)
              pw.Text('No inspection photos attached.')
            else
              for (int index = 0; index < inspectionImages.length; index++) ...[
                pw.Text(
                  'Photo ${index + 1} of ${inspectionImages.length}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Center(
                  child: pw.Container(
                    height: 300,
                    child: pw.Image(
                      inspectionImages[index],
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
                pw.SizedBox(height: 18),
              ],

            pw.SizedBox(height: 30),

            pw.Text(
              'Inspector Signature',
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
      name: 'Sentinel_HSE_Hazard_Report_$inspectionId.pdf',
      onLayout: (format) async => pdf.save(),
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

    final List<pw.MemoryImage> hazardPhotos = [];

    for (final photoPath in photoPaths) {
      final recoveredPhoto = await StorageService.getInspectionImage(photoPath);

      if (recoveredPhoto != null) {
        hazardPhotos.add(pw.MemoryImage(await recoveredPhoto.readAsBytes()));
      }
    }

    final formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

    final formattedTime = DateFormat('HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
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
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                hazardData,
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
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
    final pdf = pw.Document();

    final evidencePhotoPaths = evidencePhotoPath
        .split('|')
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty && path.toLowerCase() != 'no photo')
        .toList();

    final List<pw.MemoryImage> evidencePhotoImages = [];

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
          'Possible causes include driver inattention, unsafe speed, poor lane discipline, fatigue, or inadequate journey management.';

      aiCorrectiveActions =
          'Secure the scene, assist injured persons, notify the control room and police where required, inspect the vehicles, and suspend involved drivers pending investigation.';

      aiPreventiveActions =
          'Conduct defensive-driving refresher training, review IVMS data, strengthen journey management, monitor speed compliance, and carry out regular road-safety inspections.';

      aiLessonsLearned =
          'Vehicle movements must be properly planned, drivers must follow defensive-driving rules, and IVMS violations must be addressed promptly.';
    } else if (type.contains('fire')) {
      aiRootCause =
          'Possible causes include uncontrolled ignition sources, poor housekeeping, hot-work failures, flammable materials, or inadequate fire-prevention controls.';

      aiCorrectiveActions =
          'Raise the alarm, stop work, evacuate personnel, isolate energy sources where safe, and use the correct fire extinguisher only if trained.';

      aiPreventiveActions =
          'Strengthen hot-work controls, provide fire watches, inspect extinguishers, store flammable materials safely, and conduct regular emergency drills.';

      aiLessonsLearned =
          'Fire incidents are prevented through strict ignition control, good housekeeping, effective permits, and emergency readiness.';
    } else if (type.contains('height') || type.contains('fall')) {
      aiRootCause =
          'Possible causes include inadequate work-at-height planning, unsafe access equipment, missing edge protection, or failure to maintain 100% tie-off.';

      aiCorrectiveActions =
          'Stop the work, rescue and assist affected persons, secure the area, inspect access equipment, and verify the fall-protection system.';

      aiPreventiveActions =
          'Use approved scaffolds and ladders, inspect harnesses, provide suitable anchor points, enforce 100% tie-off, and maintain a rescue plan.';

      aiLessonsLearned =
          'Work at height must be properly planned, supervised, and performed only with approved fall-protection systems.';
    } else if (type.contains('confined')) {
      aiRootCause =
          'Possible causes include inadequate gas testing, poor ventilation, failure of permit controls, or insufficient rescue preparedness.';

      aiCorrectiveActions =
          'Evacuate the confined space, isolate the area, perform atmospheric testing, provide ventilation, and review the entry permit.';

      aiPreventiveActions =
          'Maintain continuous gas monitoring, assign a trained standby person, confirm rescue equipment is available, and strictly control entry permits.';

      aiLessonsLearned =
          'Confined-space entry must never begin without gas testing, ventilation, supervision, communication, and a rescue plan.';
    } else {
      aiRootCause =
          'The incident may have resulted from inadequate hazard control, unsafe behavior, weak supervision, or failure to follow the approved procedure.';

      aiCorrectiveActions =
          'Stop the activity, secure the area, assist affected persons, notify responsible personnel, and investigate before work resumes.';

      aiPreventiveActions =
          'Review the risk assessment and procedure, retrain the workforce, strengthen supervision, and verify effective closure of corrective actions.';

      aiLessonsLearned =
          'All incidents must be reported promptly, investigated thoroughly, and communicated to prevent recurrence.';
    }
    final formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
    final formattedTime = DateFormat('HH:mm').format(DateTime.now());
    final reportNumber =
        'AI-${DateFormat('yyyyMMdd-HHmmss').format(DateTime.now())}';
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
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
                'AI Incident Investigation Report',
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
                0: pw.FlexColumnWidth(1.2),
                1: pw.FlexColumnWidth(2.8),
              },
              children: [
                _reportRow('Date', formattedDate),
                _reportRow('Time', formattedTime),
                _reportRow('Incident Type', incidentType),
                _reportRow('Severity', severity),
                _reportRow('AI Risk Level', riskLevel),
                _reportRow('Location', location),
              ],
            ),

            pw.SizedBox(height: 24),

            pw.Text(
              'Incident Investigation Details',
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
                investigationSummary
                    .replaceAll('{', '')
                    .replaceAll('}', '')
                    .replaceAll(', ', '\n'),
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 5),
              ),
            ),
            pw.SizedBox(height: 20),

            if (evidencePhotoImages.isNotEmpty) ...[
              pw.Text(
                'Incident Evidence Photos',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),

              for (
                int index = 0;
                index < evidencePhotoImages.length;
                index++
              ) ...[
                pw.Text(
                  'Photo ${index + 1} of ${evidencePhotoImages.length}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  width: double.infinity,
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Image(
                    evidencePhotoImages[index],
                    height: 220,
                    fit: pw.BoxFit.contain,
                  ),
                ),
                pw.SizedBox(height: 18),
              ],

              pw.SizedBox(height: 20),
            ],

            pw.Text(
              'AI Root Cause Analysis',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              aiRootCause,
              style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
            ),

            pw.SizedBox(height: 16),

            pw.Text(
              'Immediate Corrective Actions',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              aiCorrectiveActions,
              style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
            ),

            pw.SizedBox(height: 16),

            pw.Text(
              'Preventive Actions',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              aiPreventiveActions,
              style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
            ),

            pw.SizedBox(height: 16),

            pw.Text(
              'Lessons Learned',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              aiLessonsLearned,
              style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
            ),
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
      name: 'Sentinel_HSE_AI_Investigation_Report_$reportNumber.pdf',
      onLayout: (format) async => pdf.save(),
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

    final generatedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

    final generatedTime = DateFormat('HH:mm').format(DateTime.now());

    final status = actionFields['Status'] ?? 'Not specified';
    final priority = actionFields['Priority'] ?? 'Not specified';
    final dueDate = actionFields['Due Date'] ?? 'Not specified';
    final responsible = actionFields['Responsible'] ?? 'Not specified';
    final actionRequired = actionFields['Action'] ?? 'Not specified';
    final createdDate = actionFields['Date'] ?? 'Not specified';

    final sourceFields = <String, String>{
      if (hazardFields['Project']?.isNotEmpty == true)
        'Project': hazardFields['Project']!,
      if (hazardFields['Location']?.isNotEmpty == true)
        'Location': hazardFields['Location']!,
      if (hazardFields['Inspector']?.isNotEmpty == true)
        'Inspector': hazardFields['Inspector']!,
      if (hazardFields['Date']?.isNotEmpty == true)
        'Inspection Date': hazardFields['Date']!,
    };

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
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
