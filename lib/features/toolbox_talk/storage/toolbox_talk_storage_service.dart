import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/toolbox_talk_result.dart';

class ToolboxTalkStorageService {
  ToolboxTalkStorageService._();

  static const String _storageKey = 'toolbox_talk_reports';

  static Future<void> saveReport(ToolboxTalkResult report) async {
    final prefs = await SharedPreferences.getInstance();

    final reports = prefs.getStringList(_storageKey) ?? [];

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
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );

    await prefs.setStringList(_storageKey, reports);
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
