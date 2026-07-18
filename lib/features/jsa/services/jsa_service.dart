import '../../../core/ai/sentinel_ai_service.dart';
import '../models/jsa_result.dart';

class JsaService {
  JsaService._();

  static Future<JsaResult> generateJsa({
    required String taskDescription,
  }) async {
    final result = await SentinelAIService.generateJsa(
      taskDescription: taskDescription,
    );

    return JsaResult.fromJson(result);
  }
}
