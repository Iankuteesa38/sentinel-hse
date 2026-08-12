import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cloud_sync/services/operational_report_cloud_service.dart';
import '../models/toolbox_talk_result.dart';
import '../../cloud_sync/services/evidence_cloud_service.dart';

class ToolboxTalkStorageService {
  ToolboxTalkStorageService._();

  static const String _storageKey = 'toolbox_talk_reports';

  static Future<void> saveReport(ToolboxTalkResult report) async {
    final prefs = await SharedPreferences.getInstance();

    final reports = prefs.getStringList(_storageKey) ?? [];
    final createdAt = DateTime.now();
    reports.insert(
      0,
      jsonEncode({
        'topic': report.topic,
        'objective': report.objective,
        'keyHazards': report.keyHazards,
        'safetyPrecautions': report.safetyPrecautions,
        'requiredPpe': report.requiredPpe,
        'discussionQuestions': report.discussionQuestions,
        'supervisorMessage': report.supervisorMessage,
        'evidencePhotoPath': report.evidencePhotoPath,
        'createdAt': createdAt.toIso8601String(),
      }),
    );

    await prefs.setStringList(_storageKey, reports);
    try {
      String? cloudEvidencePath;

      final localEvidencePath = report.evidencePhotoPath.trim();

      if (localEvidencePath.isNotEmpty) {
        final evidenceFile = File(localEvidencePath);

        if (await evidenceFile.exists()) {
          cloudEvidencePath = await EvidenceCloudService.uploadFile(
            file: evidenceFile,
            module: 'toolbox_talk',
            recordId: 'TBT-${createdAt.microsecondsSinceEpoch}',
            fileName: evidenceFile.uri.pathSegments.last,
          );
        }
      }
      await OperationalReportCloudService.syncReport(
        moduleType: 'toolbox_talk',
        localId: 'TBT-${createdAt.microsecondsSinceEpoch}',
        title: report.topic,
        reportData: {
          'topic': report.topic,
          'objective': report.objective,
          'keyHazards': report.keyHazards,
          'safetyPrecautions': report.safetyPrecautions,
          'requiredPpe': report.requiredPpe,
          'discussionQuestions': report.discussionQuestions,
          'supervisorMessage': report.supervisorMessage,
          'evidencePhotoPath': report.evidencePhotoPath,
          'evidenceCloudPath': cloudEvidencePath,
          'createdAt': createdAt.toIso8601String(),
        },
        createdAt: createdAt,
      );
    } catch (_) {
      // Local toolbox talk save remains available offline.
    }
  }

  static Future<List<ToolboxTalkResult>> getReports() async {
    final prefs = await SharedPreferences.getInstance();

    final reports = prefs.getStringList(_storageKey) ?? [];

    return reports
        .map(
          (report) => ToolboxTalkResult.fromJson(
            jsonDecode(report) as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
