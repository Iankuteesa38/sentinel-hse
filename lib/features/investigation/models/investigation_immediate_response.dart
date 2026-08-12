class InvestigationImmediateResponse {
  final bool emergencyResponseActivated;
  final bool medicalTreatmentProvided;
  final bool sceneIsolated;
  final bool equipmentMadeSafe;
  final bool authorityNotified;
  final bool evidencePreserved;
  final bool stopWorkApplied;

  final String immediateActions;
  final String sceneControlDetails;
  final String notifications;
  final String temporaryControls;

  const InvestigationImmediateResponse({
    required this.emergencyResponseActivated,
    required this.medicalTreatmentProvided,
    required this.sceneIsolated,
    required this.equipmentMadeSafe,
    required this.authorityNotified,
    required this.evidencePreserved,
    required this.stopWorkApplied,
    required this.immediateActions,
    required this.sceneControlDetails,
    required this.notifications,
    required this.temporaryControls,
  });
}
