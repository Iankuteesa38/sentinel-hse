import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/risk_assessment_result.dart';

class SavedRiskAssessmentReport {
  final RiskAssessmentResult result;
  final DateTime createdAt;

  const SavedRiskAssessmentReport({
    required this.result,
    required this.createdAt,
  });
}

class RiskAssessmentStorageService {
  RiskAssessmentStorageService._();

  static const String _storageKey = 'risk_assessment_reports';
  static Future<void> saveReport(RiskAssessmentResult report) async {
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList(_storageKey) ?? [];

    reports.insert(
      0,
      jsonEncode({
        'task': report.task,
        'entries': report.entries.map((entry) {
          return {
            'hazard': entry.hazard,
            'causes': entry.causes,
            'topEvent': entry.topEvent,
            'consequences': entry.consequences,
            'personsAtRisk': entry.personsAtRisk,
            'preventiveControls': entry.preventiveControls,
            'mitigationMeasures': entry.mitigationMeasures,
            'initialRating': {
              'severity': entry.initialRating.severity,
              'likelihood': entry.initialRating.likelihood,
              'rating': entry.initialRating.code,
            },
            'residualRating': {
              'severity': entry.residualRating.severity,
              'likelihood': entry.residualRating.likelihood,
              'rating': entry.residualRating.code,
            },
            'recommendedActions': entry.recommendedActions,
          };
        }).toList(),
        'hazards': report.hazards,
        'personsAtRisk': report.personsAtRisk,
        'existingControls': report.existingControls,
        'additionalControls': report.additionalControls,
        'initialRisk': report.initialRisk,
        'residualRisk': report.residualRisk,
        'requiredPpe': report.requiredPpe,
        'requiredPermits': report.requiredPermits,
        'emergencyResponse': report.emergencyResponse,
        'applicableStandards': report.applicableStandards,
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );

    await prefs.setStringList(_storageKey, reports);
  }

  static Future<List<SavedRiskAssessmentReport>> getReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList(_storageKey) ?? [];

    return reports.map((encodedReport) {
      final json = Map<String, dynamic>.from(jsonDecode(encodedReport) as Map);

      return SavedRiskAssessmentReport(
        result: RiskAssessmentResult.fromJson(json),
        createdAt:
            DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
            DateTime.now(),
      );
    }).toList();
  }
}
