enum SmartAlertSeverity { critical, high, medium, info }

enum SmartAlertSource {
  inspectionCapa,
  investigationAction,
  investigation,
  hazard,
}

class SmartAlert {
  final String id;
  final SmartAlertSource source;
  final SmartAlertSeverity severity;

  final String title;
  final String message;

  final String reference;
  final String location;
  final String responsiblePerson;
  final String status;

  final DateTime createdAt;
  final DateTime? targetDate;

  final bool overdue;

  const SmartAlert({
    required this.id,
    required this.source,
    required this.severity,
    required this.title,
    required this.message,
    required this.reference,
    required this.location,
    required this.responsiblePerson,
    required this.status,
    required this.createdAt,
    required this.targetDate,
    required this.overdue,
  });
}
