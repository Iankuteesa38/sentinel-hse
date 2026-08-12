enum InvestigationActionType {
  immediateContainment,
  correctiveAction,
  preventiveAction,
  systemImprovement,
  learningAction,
  longTermImprovement,
}

enum InvestigationActionStatus {
  open,
  inProgress,
  pendingVerification,
  effectivenessReview,
  closed,
  overdue,
}

class InvestigationAction {
  final String actionId;
  final String linkedCauseId;
  final String linkedBarrierId;

  final InvestigationActionType actionType;
  final String action;

  final String responsiblePerson;
  final DateTime targetDate;

  final String requiredClosureEvidence;
  final String verifier;

  final String effectivenessCriteria;
  final DateTime? effectivenessReviewDate;

  final InvestigationActionStatus status;

  final DateTime? actualClosureDate;
  final String closureComments;

  const InvestigationAction({
    required this.actionId,
    required this.linkedCauseId,
    required this.linkedBarrierId,
    required this.actionType,
    required this.action,
    required this.responsiblePerson,
    required this.targetDate,
    required this.requiredClosureEvidence,
    required this.verifier,
    required this.effectivenessCriteria,
    required this.status,
    this.effectivenessReviewDate,
    this.actualClosureDate,
    this.closureComments = '',
  });
}
