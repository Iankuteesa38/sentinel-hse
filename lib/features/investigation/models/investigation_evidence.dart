enum InvestigationEvidenceType {
  statement,
  photograph,
  video,
  document,
  policeReport,
  ivmsTelematics,
  medicalRecord,
  inspectionRecord,
  equipmentRecord,
  digitalData,
  other,
}

enum InvestigationEvidenceStatus {
  confirmed,
  corroborated,
  probable,
  witnessAllegation,
  unverified,
  contradicted,
  notApplicable,
}

class InvestigationEvidence {
  final String evidenceId;
  final String title;
  final InvestigationEvidenceType type;
  final InvestigationEvidenceStatus status;

  final String source;
  final DateTime obtainedAt;
  final String obtainedBy;

  final String storageLocation;
  final bool integrityVerified;

  final String description;
  final String relevance;
  final String filePath;

  const InvestigationEvidence({
    required this.evidenceId,
    required this.title,
    required this.type,
    required this.status,
    required this.source,
    required this.obtainedAt,
    required this.obtainedBy,
    required this.storageLocation,
    required this.integrityVerified,
    required this.description,
    required this.relevance,
    this.filePath = '',
  });
}
