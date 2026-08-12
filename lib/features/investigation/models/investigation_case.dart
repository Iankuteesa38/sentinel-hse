enum InvestigationReportStatus {
  draft,
  preliminary,
  interim,
  finalReport,
  closed,
}

enum InvestigationLevel { level1Basic, level2Formal, level3MajorHighPotential }

enum IncidentSeverity {
  negligible,
  minor,
  moderate,
  serious,
  major,
  catastrophic,
}

enum IncidentCategory {
  motorVehicle,
  injury,
  nearMiss,
  propertyDamage,
  environmental,
  fireExplosion,
  liftingHoisting,
  droppedObject,
  equipmentFailure,
  occupationalHealth,
  other,
}

class InvestigationCase {
  final String investigationReference;
  final String incidentTitle;
  InvestigationReportStatus reportStatus;
  final InvestigationLevel investigationLevel;
  final IncidentCategory incidentCategory;
  final IncidentSeverity actualSeverity;
  final IncidentSeverity potentialSeverity;
  final bool highPotential;
  final DateTime incidentDateTime;
  final DateTime reportedDateTime;
  final String location;
  final String project;
  final String company;
  final String contractor;
  final String preparedBy;
  final String reviewedBy;
  final String approvedBy;
  final String revisionNumber;
  final String confidentialityClassification;

  InvestigationCase({
    required this.investigationReference,
    required this.incidentTitle,
    required this.reportStatus,
    required this.investigationLevel,
    required this.incidentCategory,
    required this.actualSeverity,
    required this.potentialSeverity,
    required this.highPotential,
    required this.incidentDateTime,
    required this.reportedDateTime,
    required this.location,
    required this.project,
    required this.company,
    required this.contractor,
    required this.preparedBy,
    this.reviewedBy = '',
    this.approvedBy = '',
    this.revisionNumber = '00',
    this.confidentialityClassification = 'Internal',
  });
}
