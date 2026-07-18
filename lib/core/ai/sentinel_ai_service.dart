import 'dart:convert';
import '../constants/api_constants.dart';
import 'sentinel_prompts.dart';

import 'package:http/http.dart' as http;

class SentinelAIService {
  SentinelAIService._();

  static Future<Map<String, dynamic>> generateRiskAssessment({
    required String taskDescription,
  }) async {
    final prompt = SentinelPrompts.riskAssessmentPrompt(
      taskDescription: taskDescription,
    );
    return generate(prompt: prompt);
  }

  static Future<Map<String, dynamic>> generateJsa({
    required String taskDescription,
  }) async {
    final prompt = SentinelPrompts.jsaPrompt(taskDescription: taskDescription);

    return generate(prompt: prompt);
  }

  static Future<Map<String, dynamic>> generateToolboxTalk({
    required String topic,
  }) async {
    final prompt = SentinelPrompts.toolboxTalkPrompt(topic: topic);

    return generate(prompt: prompt);
  }

  static Future<Map<String, dynamic>> generate({required String prompt}) async {
    final response = await http.post(
      Uri.parse(ApiConstants.generateRiskAssessment),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode != 200) {
      throw Exception('AI request failed.');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
