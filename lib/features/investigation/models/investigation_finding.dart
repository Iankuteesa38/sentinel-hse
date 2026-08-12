enum InvestigationFindingStatus {
  confirmed,
  probable,
  pendingVerification,
  contradicted,
  closed,
}

class InvestigationFinding {
  final String findingId;
  final String findingStatement;

  final List<String> supportingEvidenceIds;

  final String linkedCauseId;
  final String linkedBarrierId;

  final InvestigationFindingStatus status;

  final String confidenceBasis;
  final String outstandingVerification;

  const InvestigationFinding({
    required this.findingId,
    required this.findingStatement,
    required this.supportingEvidenceIds,
    required this.linkedCauseId,
    required this.linkedBarrierId,
    required this.status,
    required this.confidenceBasis,
    this.outstandingVerification = '',
  });
}
