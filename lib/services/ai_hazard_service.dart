import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/hazard_analysis_result.dart';

class AIHazardService {
  // We will replace this with your secure backend address later.
  static const String backendUrl =
      'https://sentinel-hse-ai.iankuteesa.workers.dev/analyze-hazard';

  static Future<String> analyzeImage(File imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(backendUrl));

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['analysis']?.toString() ??
            'No hazard analysis was returned.';
      }

      try {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?.toString() ?? response.body;

        return 'Analysis failed: $errorMessage';
      } catch (_) {
        return 'Analysis failed. Server error: '
            '${response.statusCode}\n${response.body}';
      }
    } catch (error) {
      return 'Unable to analyze the image: $error';
    }
  }

  static Future<HazardAnalysisResult?> analyzeImageStructured(
    File imageFile,
  ) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(backendUrl));

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);

      final structuredData = data['structuredAnalysis'];

      if (structuredData is Map<String, dynamic>) {
        return HazardAnalysisResult.fromJson(structuredData);
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
