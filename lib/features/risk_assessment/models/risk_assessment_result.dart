class RiskRating {
  final int severity;
  final String likelihood;

  const RiskRating({required this.severity, required this.likelihood});

  String get code {
    final normalizedLikelihood = likelihood.trim().toUpperCase();

    if (severity < 1 || normalizedLikelihood.isEmpty) {
      return 'N/A';
    }

    return '$severity$normalizedLikelihood';
  }

  factory RiskRating.fromJson(dynamic json) {
    if (json is! Map) {
      return const RiskRating(severity: 0, likelihood: '');
    }

    final values = Map<String, dynamic>.from(json);

    int severity = int.tryParse(values['severity']?.toString() ?? '') ?? 0;

    String likelihood = (values['likelihood'] ?? values['probability'] ?? '')
        .toString()
        .trim()
        .toUpperCase();

    final ratingText = values['rating']?.toString().trim().toUpperCase() ?? '';

    final ratingMatch = RegExp(r'^([1-6])([A-F])$').firstMatch(ratingText);

    if (ratingMatch != null) {
      if (severity == 0) {
        severity = int.parse(ratingMatch.group(1)!);
      }

      if (likelihood.isEmpty) {
        likelihood = ratingMatch.group(2)!;
      }
    }

    return RiskRating(severity: severity, likelihood: likelihood);
  }
}

class RiskAssessmentEntry {
  final String hazard;
  final List<String> causes;
  final String topEvent;
  final List<String> consequences;
  final List<String> personsAtRisk;
  final List<String> preventiveControls;
  final List<String> mitigationMeasures;
  final RiskRating initialRating;
  final RiskRating residualRating;
  final List<String> recommendedActions;

  const RiskAssessmentEntry({
    required this.hazard,
    required this.causes,
    required this.topEvent,
    required this.consequences,
    required this.personsAtRisk,
    required this.preventiveControls,
    required this.mitigationMeasures,
    required this.initialRating,
    required this.residualRating,
    required this.recommendedActions,
  });

  factory RiskAssessmentEntry.fromJson(dynamic json) {
    if (json is! Map) {
      return const RiskAssessmentEntry(
        hazard: '',
        causes: [],
        topEvent: '',
        consequences: [],
        personsAtRisk: [],
        preventiveControls: [],
        mitigationMeasures: [],
        initialRating: RiskRating(severity: 0, likelihood: ''),
        residualRating: RiskRating(severity: 0, likelihood: ''),
        recommendedActions: [],
      );
    }

    final values = Map<String, dynamic>.from(json);

    List<String> readList(String key) {
      final value = values[key];

      if (value is List) {
        return value.map((item) => item.toString()).toList();
      }

      if (value is String && value.trim().isNotEmpty) {
        return [value.trim()];
      }

      return [];
    }

    return RiskAssessmentEntry(
      hazard: values['hazard']?.toString() ?? '',
      causes: readList('causes').isNotEmpty
          ? readList('causes')
          : readList('threats'),
      topEvent:
          values['topEvent']?.toString() ?? values['event']?.toString() ?? '',
      consequences: readList('consequences'),
      personsAtRisk: readList('personsAtRisk'),
      preventiveControls: readList('preventiveControls').isNotEmpty
          ? readList('preventiveControls')
          : readList('existingControls'),
      mitigationMeasures: readList('mitigationMeasures').isNotEmpty
          ? readList('mitigationMeasures')
          : readList('additionalControls'),
      initialRating: RiskRating.fromJson(
        values['initialRating'] ?? values['initialRisk'],
      ),
      residualRating: RiskRating.fromJson(
        values['residualRating'] ?? values['residualRisk'],
      ),
      recommendedActions: readList('recommendedActions'),
    );
  }
}

class RiskAssessmentResult {
  final String task;
  final List<RiskAssessmentEntry> entries;
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
    required this.entries,
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
      entries: json['entries'] is List
          ? (json['entries'] as List)
                .map((item) => RiskAssessmentEntry.fromJson(item))
                .toList()
          : <RiskAssessmentEntry>[],
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
