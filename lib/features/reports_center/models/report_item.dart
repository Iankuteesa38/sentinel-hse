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

  const ReportItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.createdAt,
  });
}
