import 'investigation_evidence.dart';

class InvestigationTimelineEvent {
  final String eventId;
  final DateTime eventDateTime;
  final String eventDescription;

  final List<String> evidenceIds;
  final InvestigationEvidenceStatus evidenceStatus;

  final String source;
  final String significance;

  const InvestigationTimelineEvent({
    required this.eventId,
    required this.eventDateTime,
    required this.eventDescription,
    required this.evidenceIds,
    required this.evidenceStatus,
    required this.source,
    required this.significance,
  });
}
