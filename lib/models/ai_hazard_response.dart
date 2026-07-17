import 'hazard_analysis_result.dart';

class AIHazardResponse {
  final String analysis;
  final HazardAnalysisResult? structuredAnalysis;

  const AIHazardResponse({
    required this.analysis,
    required this.structuredAnalysis,
  });
}
