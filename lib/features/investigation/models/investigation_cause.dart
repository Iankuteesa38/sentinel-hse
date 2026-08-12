enum InvestigationCauseType {
  immediateCause,
  contributingFactor,
  underlyingCause,
  rootCause,
  humanPerformanceFactor,
  organizationalFactor,
  failedBarrier,
}

enum InvestigationConfidence {
  confirmed,
  high,
  medium,
  low,
  pendingVerification,
}

class InvestigationCause {
  final String causeId;
  final InvestigationCauseType causeType;
  final String statement;

  final List<String> supportingEvidenceIds;

  final InvestigationConfidence confidence;

  final String relatedBarrierId;
  final String notes;

  const InvestigationCause({
    required this.causeId,
    required this.causeType,
    required this.statement,
    required this.supportingEvidenceIds,
    required this.confidence,
    this.relatedBarrierId = '',
    this.notes = '',
  });
}
