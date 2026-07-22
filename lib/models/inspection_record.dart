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
  }) : imagePaths =
           imagePaths ?? (imagePath.isEmpty ? <String>[] : <String>[imagePath]);

  String get imagePath {
    return imagePaths.isEmpty ? '' : imagePaths.first;
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

    final legacyImagePath = json['imagePath']?.toString() ?? '';
    final storedHazardResult = json['hazardResult'];

    final hazardResult = storedHazardResult is Map
        ? HazardAnalysisResult.fromJson(
            Map<String, dynamic>.from(storedHazardResult),
          )
        : null;
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
    );
  }
}
