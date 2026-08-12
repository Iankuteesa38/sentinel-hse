enum BarrierType { preventive, mitigation, recovery }

enum BarrierStatus {
  effective,
  partiallyEffective,
  failed,
  missing,
  degraded,
  notApplicable,
}

class InvestigationBarrier {
  final String barrierId;
  final String title;

  final BarrierType barrierType;
  final BarrierStatus status;

  final String expectedFunction;
  final String investigationFinding;

  final String relatedThreat;
  final String relatedConsequence;

  final String escalationFactor;

  final List<String> supportingEvidenceIds;

  const InvestigationBarrier({
    required this.barrierId,
    required this.title,
    required this.barrierType,
    required this.status,
    required this.expectedFunction,
    required this.investigationFinding,
    required this.relatedThreat,
    required this.relatedConsequence,
    required this.supportingEvidenceIds,
    this.escalationFactor = '',
  });
}
