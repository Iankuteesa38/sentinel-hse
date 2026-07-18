import '../../../core/ai/sentinel_ai_service.dart';
import '../models/risk_assessment_result.dart';

class RiskAssessmentService {
  RiskAssessmentService._();

  static Future<RiskAssessmentResult> generateRiskAssessment({
    required String taskDescription,
  }) async {
    final result = await SentinelAIService.generateRiskAssessment(
      taskDescription: taskDescription,
    );

    return RiskAssessmentResult.fromJson(result);
  }
}
