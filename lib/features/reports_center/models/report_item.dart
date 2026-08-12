enum ReportType {
  hazard,
  riskAssessment,
  jsa,
  toolboxTalk,
  inspection,
  incident,
}

class ReportItem {
  final String id;
  final ReportType type;
  final String title;
  final String subtitle;
  final DateTime createdAt;
  final double? compliancePercentage;
  final int capaCount;
  final int openCapaCount;
  final int inProgressCapaCount;
  final int closedCapaCount;
  final String location;
  const ReportItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    this.compliancePercentage,
    this.capaCount = 0,
    this.openCapaCount = 0,
    this.inProgressCapaCount = 0,
    this.closedCapaCount = 0,
    this.location = '',
  });
}
