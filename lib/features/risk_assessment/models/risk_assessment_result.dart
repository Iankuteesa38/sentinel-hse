class RiskAssessmentResult {
  final String task;

  final List<String> hazards;

  final List<String> personsAtRisk;

  final List<String> existingControls;

  final List<String> additionalControls;

  final String initialRisk;

  final String residualRisk;

  final List<String> requiredPpe;

  final List<String> requiredPermits;

  final List<String> emergencyResponse;

  final List<String> applicableStandards;

  const RiskAssessmentResult({
    required this.task,
    required this.hazards,
    required this.personsAtRisk,
    required this.existingControls,
    required this.additionalControls,
    required this.initialRisk,
    required this.residualRisk,
    required this.requiredPpe,
    required this.requiredPermits,
    required this.emergencyResponse,
    required this.applicableStandards,
  });
  factory RiskAssessmentResult.fromJson(Map<String, dynamic> json) {
    List<String> readList(String key) {
      final value = json[key];

      if (value is List) {
        return value.map((item) => item.toString()).toList();
      }

      return [];
    }

    return RiskAssessmentResult(
      task: json['task']?.toString() ?? '',
      hazards: readList('hazards'),
      personsAtRisk: readList('personsAtRisk'),
      existingControls: readList('existingControls'),
      additionalControls: readList('additionalControls'),
      initialRisk: json['initialRisk']?.toString() ?? '',
      residualRisk: json['residualRisk']?.toString() ?? '',
      requiredPpe: readList('requiredPpe'),
      requiredPermits: readList('requiredPermits'),
      emergencyResponse: readList('emergencyResponse'),
      applicableStandards: readList('applicableStandards'),
    );
  }
}
