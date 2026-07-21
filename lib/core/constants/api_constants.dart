class ApiConstants {
  ApiConstants._();

  /// AI Backend
  static const String aiBaseUrl =
      'https://sentinel-ai-backend-0qlb.onrender.com';

  /// Endpoints
  static const String analyzeHazard = '$aiBaseUrl/analyze-hazard';

  // Future Endpoints
  static const String generateRiskAssessment =
      '$aiBaseUrl/generate-risk-assessment';

  static const String generateJsa = '$aiBaseUrl/generate-jsa';

  static const String generateToolboxTalk = '$aiBaseUrl/generate-toolbox-talk';

  static const String investigateIncident = '$aiBaseUrl/investigate-incident';
}
