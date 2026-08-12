import 'dart:typed_data';

class InspectionFinding {
  final int itemNumber;
  final String requirement;
  final String finding;
  final String riskLevel;
  final String correctiveAction;
  final String responsiblePerson;
  final DateTime targetDate;

  String status;

  String closedBy;
  String closureComment;
  DateTime? closedAt;
  List<Uint8List> closureEvidence;

  InspectionFinding({
    required this.itemNumber,
    required this.requirement,
    required this.finding,
    required this.riskLevel,
    required this.correctiveAction,
    required this.responsiblePerson,
    required this.targetDate,
    this.status = 'Open',
    this.closedBy = '',
    this.closureComment = '',
    this.closedAt,
    List<Uint8List>? closureEvidence,
  }) : closureEvidence = closureEvidence ?? [];
}
