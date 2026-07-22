class HazardAnalysisResult {
  final String hazardCategory;
  final List<String> hazards;
  final String likelihood;
  final String severity;
  final String riskLevel;
  final List<String> immediateActions;
  final List<String> correctiveActions;
  final List<String> preventiveActions;
  final List<String> requiredPpe;
  final List<String> requiredPermits;
  final List<String> applicableStandards;
  final int confidenceScore;

  const HazardAnalysisResult({
    required this.hazardCategory,
    required this.hazards,
    required this.likelihood,
    required this.severity,
    required this.riskLevel,
    required this.immediateActions,
    required this.correctiveActions,
    required this.preventiveActions,
    required this.requiredPpe,
    required this.requiredPermits,
    required this.applicableStandards,
    required this.confidenceScore,
  });

  factory HazardAnalysisResult.fromJson(Map<String, dynamic> json) {
    List<String> readList(String key) {
      final value = json[key];

      if (value is List) {
        return value.map((item) => item.toString()).toList();
      }

      if (value is String && value.trim().isNotEmpty) {
        return [value];
      }

      return [];
    }

    final rawConfidence = json['confidenceScore'];

    return HazardAnalysisResult(
      hazardCategory: json['hazardCategory']?.toString() ?? 'General Safety',
      hazards: readList('hazards'),
      likelihood: json['likelihood']?.toString() ?? 'Unknown',
      severity: json['severity']?.toString() ?? 'Unknown',
      riskLevel: json['riskLevel']?.toString() ?? 'Unknown',
      immediateActions: readList('immediateActions'),
      correctiveActions: readList('correctiveActions'),
      preventiveActions: readList('preventiveActions'),
      requiredPpe: readList('requiredPpe'),
      requiredPermits: readList('requiredPermits'),
      applicableStandards: readList('applicableStandards'),
      confidenceScore: rawConfidence is int
          ? rawConfidence
          : int.tryParse(rawConfidence?.toString() ?? '') ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'hazardCategory': hazardCategory,
      'hazards': hazards,
      'likelihood': likelihood,
      'severity': severity,
      'riskLevel': riskLevel,
      'immediateActions': immediateActions,
      'correctiveActions': correctiveActions,
      'preventiveActions': preventiveActions,
      'requiredPpe': requiredPpe,
      'requiredPermits': requiredPermits,
      'applicableStandards': applicableStandards,
      'confidenceScore': confidenceScore,
    };
  }
}
