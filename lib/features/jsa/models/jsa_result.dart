class JsaStep {
  final String jobStep;
  final List<String> hazards;
  final List<String> controlMeasures;
  final List<String> requiredPpe;
  final String responsiblePerson;

  const JsaStep({
    required this.jobStep,
    required this.hazards,
    required this.controlMeasures,
    required this.requiredPpe,
    required this.responsiblePerson,
  });

  factory JsaStep.fromJson(Map<String, dynamic> json) {
    List<String> readList(String key) {
      final value = json[key];

      if (value is List) {
        return value.map((item) => item.toString()).toList();
      }

      return [];
    }

    return JsaStep(
      jobStep: json['jobStep']?.toString() ?? '',
      hazards: readList('hazards'),
      controlMeasures: readList('controlMeasures'),
      requiredPpe: readList('requiredPpe'),
      responsiblePerson: json['responsiblePerson']?.toString() ?? '',
    );
  }
}

class JsaResult {
  final String task;
  final List<JsaStep> steps;
  final List<String> permits;
  final List<String> emergencyRequirements;
  final List<String> applicableStandards;

  const JsaResult({
    required this.task,
    required this.steps,
    required this.permits,
    required this.emergencyRequirements,
    required this.applicableStandards,
  });

  factory JsaResult.fromJson(Map<String, dynamic> json) {
    List<String> readList(String key) {
      final value = json[key];

      if (value is List) {
        return value.map((item) => item.toString()).toList();
      }

      return [];
    }

    final rawSteps = json['steps'];

    return JsaResult(
      task: json['task']?.toString() ?? '',
      steps: rawSteps is List
          ? rawSteps
                .whereType<Map>()
                .map(
                  (item) => JsaStep.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : [],
      permits: readList('permits'),
      emergencyRequirements: readList('emergencyRequirements'),
      applicableStandards: readList('applicableStandards'),
    );
  }
}
