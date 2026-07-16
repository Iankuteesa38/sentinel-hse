import 'hazard_recognition.dart';
import 'hse_knowledge.dart';
import 'incident_analysis.dart';
import 'toolbox_talks.dart';
import 'risk_assessment.dart';
import 'jsa_generator.dart';
import 'photo_hazard_scanner.dart';

String routeAiQuestion({
  required String question,
  required String projectSummary,
}) {
  if (question.contains('project summary') ||
      question.contains('safety summary') ||
      question.contains('project status')) {
    return projectSummary;
  }
  final jsaResponse = handleJsaGenerator(question);
  if (jsaResponse != null) {
    return jsaResponse;
  }
  if (question.contains('analyze photo')) {
    return PhotoHazardScanner.analyze(question);
  }
  final toolboxResponse = handleToolboxTalk(question);
  if (toolboxResponse != null) {
    return toolboxResponse;
  }
  final riskAssessmentResponse = handleRiskAssessment(question);
  if (riskAssessmentResponse != null) {
    return riskAssessmentResponse;
  }
  final knowledgeResponse = handleHseKnowledge(question);
  if (knowledgeResponse != null) {
    return knowledgeResponse;
  }

  // Incident analysis is checked before hazard recognition so phrases such
  // as "worker fell from scaffold" are treated as incidents.
  final incidentResponse = handleIncidentAnalysis(question);
  if (incidentResponse != null) {
    return incidentResponse;
  }

  final hazardResponse = handleHazardRecognition(question);
  if (hazardResponse != null) {
    return hazardResponse;
  }

  return '''
I could not identify the request yet.

Try describing the activity, incident, or required document more clearly.

Examples:
•⁠  ⁠Worker welding on a tank
•⁠  ⁠Excavator digging a trench
•⁠  ⁠Worker fell from a scaffold
•⁠  ⁠Confined-space incident analysis
•⁠  ⁠Forklift reversing near pedestrians
•⁠  ⁠Toolbox talk for working at height
•⁠  ⁠PPE requirements
''';
}
