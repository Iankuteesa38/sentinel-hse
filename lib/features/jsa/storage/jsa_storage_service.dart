import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );

    await prefs.setStringList(_storageKey, reports);
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
