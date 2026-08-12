import 'hazard_analysis_result.dart';

class InspectionRecord {
  final String inspectionId;
  final String inspector;
  final String location;
  final String analysis;
  final List<String> imagePaths;
  final DateTime createdAt;
  final String status;
  final String riskLevel;
  final HazardAnalysisResult? hazardResult;

  final String responsiblePerson;
  final DateTime? targetDate;

  final String closedBy;
  final String closureComment;
  final DateTime? closedAt;
  final List<String> closureEvidencePaths;

  InspectionRecord({
    required this.inspectionId,
    required this.inspector,
    required this.location,
    required this.analysis,
    List<String>? imagePaths,
    String imagePath = '',
    required this.createdAt,
    this.status = 'Open',
    required this.riskLevel,
    this.hazardResult,
    this.responsiblePerson = '',
    this.targetDate,
    this.closedBy = '',
    this.closureComment = '',
    this.closedAt,
    List<String>? closureEvidencePaths,
  }) : imagePaths =
           imagePaths ?? (imagePath.isEmpty ? <String>[] : <String>[imagePath]),
       closureEvidencePaths = closureEvidencePaths ?? <String>[];

  String get imagePath {
    return imagePaths.isEmpty ? '' : imagePaths.first;
  }

  bool get isClosed => status.toLowerCase() == 'closed';

  bool get isOverdue {
    if (isClosed || targetDate == null) {
      return false;
    }

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final target = DateTime(
      targetDate!.year,
      targetDate!.month,
      targetDate!.day,
    );

    return target.isBefore(today);
  }

  InspectionRecord copyWith({
    String? inspector,
    String? location,
    String? analysis,
    List<String>? imagePaths,
    String? status,
    String? riskLevel,
    HazardAnalysisResult? hazardResult,
    String? responsiblePerson,
    DateTime? targetDate,
    String? closedBy,
    String? closureComment,
    DateTime? closedAt,
    List<String>? closureEvidencePaths,
    bool clearClosedAt = false,
  }) {
    return InspectionRecord(
      inspectionId: inspectionId,
      inspector: inspector ?? this.inspector,
      location: location ?? this.location,
      analysis: analysis ?? this.analysis,
      imagePaths: imagePaths ?? this.imagePaths,
      createdAt: createdAt,
      status: status ?? this.status,
      riskLevel: riskLevel ?? this.riskLevel,
      hazardResult: hazardResult ?? this.hazardResult,
      responsiblePerson: responsiblePerson ?? this.responsiblePerson,
      targetDate: targetDate ?? this.targetDate,
      closedBy: closedBy ?? this.closedBy,
      closureComment: closureComment ?? this.closureComment,
      closedAt: clearClosedAt ? null : closedAt ?? this.closedAt,
      closureEvidencePaths: closureEvidencePaths ?? this.closureEvidencePaths,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inspectionId': inspectionId,
      'inspector': inspector,
      'location': location,
      'analysis': analysis,
      'imagePaths': imagePaths,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'riskLevel': riskLevel,
      'hazardResult': hazardResult?.toJson(),
      'responsiblePerson': responsiblePerson,
      'targetDate': targetDate?.toIso8601String(),
      'closedBy': closedBy,
      'closureComment': closureComment,
      'closedAt': closedAt?.toIso8601String(),
      'closureEvidencePaths': closureEvidencePaths,
    };
  }

  factory InspectionRecord.fromJson(Map<String, dynamic> json) {
    final storedImagePaths = json['imagePaths'];

    final imagePaths = storedImagePaths is List
        ? storedImagePaths
              .map((item) => item.toString())
              .where((path) => path.isNotEmpty)
              .toList()
        : <String>[];

    final storedClosureEvidence = json['closureEvidencePaths'];

    final closureEvidencePaths = storedClosureEvidence is List
        ? storedClosureEvidence
              .map((item) => item.toString())
              .where((path) => path.isNotEmpty)
              .toList()
        : <String>[];

    final legacyImagePath = json['imagePath']?.toString() ?? '';

    final storedHazardResult = json['hazardResult'];

    final hazardResult = storedHazardResult is Map
        ? HazardAnalysisResult.fromJson(
            Map<String, dynamic>.from(storedHazardResult),
          )
        : null;

    final targetDateText = json['targetDate']?.toString() ?? '';

    final closedAtText = json['closedAt']?.toString() ?? '';

    return InspectionRecord(
      inspectionId: json['inspectionId']?.toString() ?? '',
      inspector: json['inspector']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      analysis: json['analysis']?.toString() ?? '',
      imagePaths: imagePaths.isNotEmpty ? imagePaths : null,
      imagePath: legacyImagePath,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      status: json['status']?.toString() ?? 'Open',
      riskLevel: json['riskLevel']?.toString() ?? 'Unknown',
      hazardResult: hazardResult,
      responsiblePerson: json['responsiblePerson']?.toString() ?? '',
      targetDate: targetDateText.isEmpty
          ? null
          : DateTime.tryParse(targetDateText),
      closedBy: json['closedBy']?.toString() ?? '',
      closureComment: json['closureComment']?.toString() ?? '',
      closedAt: closedAtText.isEmpty ? null : DateTime.tryParse(closedAtText),
      closureEvidencePaths: closureEvidencePaths,
    );
  }
}
