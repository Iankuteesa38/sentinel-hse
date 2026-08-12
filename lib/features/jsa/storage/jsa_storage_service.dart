import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../cloud_sync/services/operational_report_cloud_service.dart';
import '../models/jsa_result.dart';

class SavedJsaReport {
  final JsaResult result;
  final DateTime createdAt;

  const SavedJsaReport({required this.result, required this.createdAt});
}

class JsaStorageService {
  JsaStorageService._();

  static const String _storageKey = 'jsa_reports';

  static Future<void> saveReport(JsaResult report) async {
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList(_storageKey) ?? [];
    final createdAt = DateTime.now();
    reports.insert(
      0,
      jsonEncode({
        'task': report.task,
        'steps': report.steps
            .map(
              (step) => {
                'jobStep': step.jobStep,
                'hazards': step.hazards,
                'controlMeasures': step.controlMeasures,
                'requiredPpe': step.requiredPpe,
                'responsiblePerson': step.responsiblePerson,
              },
            )
            .toList(),
        'permits': report.permits,
        'emergencyRequirements': report.emergencyRequirements,
        'applicableStandards': report.applicableStandards,
        'createdAt': createdAt.toIso8601String(),
      }),
    );

    await prefs.setStringList(_storageKey, reports);
    try {
      await OperationalReportCloudService.syncReport(
        moduleType: 'jsa',
        localId: 'JSA-${createdAt.microsecondsSinceEpoch}',
        title: report.task,
        reportData: {
          'task': report.task,
          'steps': report.steps.map((step) {
            return {
              'jobStep': step.jobStep,
              'hazards': step.hazards,
              'controlMeasures': step.controlMeasures,
              'requiredPpe': step.requiredPpe,
              'responsiblePerson': step.responsiblePerson,
            };
          }).toList(),
          'permits': report.permits,
          'emergencyRequirements': report.emergencyRequirements,
          'applicableStandards': report.applicableStandards,
          'createdAt': createdAt.toIso8601String(),
        },
        createdAt: createdAt,
      );
    } catch (_) {
      // Local JSA save remains available offline.
    }
  }

  static Future<List<SavedJsaReport>> getReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList(_storageKey) ?? [];

    return reports.map((encodedReport) {
      final json = Map<String, dynamic>.from(jsonDecode(encodedReport) as Map);

      return SavedJsaReport(
        result: JsaResult.fromJson(json),
        createdAt:
            DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
            DateTime.now(),
      );
    }).toList();
  }
}
