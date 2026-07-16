String buildProjectSafetySummary({
  required int safetyScore,
  required int totalHazards,
  required int openActions,
  required int closedActions,
  required int highRiskInspections,
  required int overdueActions,
  required String projectStatus,
}) {
  final String recommendation;

  if (overdueActions > 0) {
    recommendation =
        'Immediate attention is required. Close overdue corrective actions '
        'and follow up with the responsible persons.';
  } else if (highRiskInspections > 0) {
    recommendation =
        'Prioritize high-risk inspection findings and complete follow-up '
        'inspections within 24 hours.';
  } else if (openActions > 0) {
    recommendation =
        'Continue monitoring open corrective actions and confirm that '
        'responsible persons complete them before their due dates.';
  } else {
    recommendation =
        'The project is currently under control. Continue inspections and '
        'preventive monitoring.';
  }

  return '''
SENTINEL AI PROJECT SAFETY SUMMARY

Safety Score:
$safetyScore%

Project Status:
$projectStatus

Open Hazards:
$totalHazards

Open Actions:
$openActions

Closed Actions:
$closedActions

High-Risk Inspections:
$highRiskInspections

Overdue Actions:
$overdueActions

AI Recommendation:
$recommendation
''';
}
