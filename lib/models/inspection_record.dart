class InspectionRecord {
  final String inspectionId;
  final String inspector;
  final String location;
  final String analysis;
  final String imagePath;
  final DateTime createdAt;
  final String status;
  final String riskLevel;

  InspectionRecord({
    required this.inspectionId,
    required this.inspector,
    required this.location,
    required this.analysis,
    required this.imagePath,
    required this.createdAt,
    this.status = 'Open',
    required this.riskLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'inspectionId': inspectionId,
      'inspector': inspector,
      'location': location,
      'analysis': analysis,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'riskLevel': riskLevel,
    };
  }

  factory InspectionRecord.fromJson(Map<String, dynamic> json) {
    return InspectionRecord(
      inspectionId: json['inspectionId']?.toString() ?? '',
      inspector: json['inspector']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      analysis: json['analysis']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      status: json['status']?.toString() ?? 'Open',
      riskLevel: json['riskLevel']?.toString() ?? 'Unknown',
    );
  }
}
