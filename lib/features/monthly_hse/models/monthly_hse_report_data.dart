import '../../reports_center/models/report_item.dart';

class MonthlyHseReportData {
  final int year;
  final int month;
  final List<ReportItem> reports;

  final int totalReports;
  final int inspectionCount;
  final int investigationCount;
  final int hazardCount;
  final int jsaCount;
  final int riskAssessmentCount;
  final int toolboxTalkCount;

  final int totalCapaCount;
  final int openCapaCount;
  final int inProgressCapaCount;
  final int closedCapaCount;

  final double? averageInspectionScore;
  final int scoredInspectionCount;

  const MonthlyHseReportData({
    required this.year,
    required this.month,
    required this.reports,
    required this.totalReports,
    required this.inspectionCount,
    required this.investigationCount,
    required this.hazardCount,
    required this.jsaCount,
    required this.riskAssessmentCount,
    required this.toolboxTalkCount,
    required this.totalCapaCount,
    required this.openCapaCount,
    required this.inProgressCapaCount,
    required this.closedCapaCount,
    required this.averageInspectionScore,
    required this.scoredInspectionCount,
  });

  factory MonthlyHseReportData.fromReports({
    required int year,
    required int month,
    required List<ReportItem> allReports,
  }) {
    final reports = allReports.where((report) {
      final date = report.createdAt.toLocal();

      return date.year == year && date.month == month;
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    int countType(ReportType type) {
      return reports.where((report) => report.type == type).length;
    }

    final inspectionReports = reports
        .where((report) => report.type == ReportType.inspection)
        .toList();

    final scores = inspectionReports
        .map((report) => report.compliancePercentage)
        .whereType<double>()
        .toList();

    final averageScore = scores.isEmpty
        ? null
        : scores.reduce((a, b) => a + b) / scores.length;

    final totalCapaCount = inspectionReports.fold<int>(
      0,
      (total, report) => total + report.capaCount,
    );

    final openCapaCount = inspectionReports.fold<int>(
      0,
      (total, report) => total + report.openCapaCount,
    );

    final inProgressCapaCount = inspectionReports.fold<int>(
      0,
      (total, report) => total + report.inProgressCapaCount,
    );

    final closedCapaCount = inspectionReports.fold<int>(
      0,
      (total, report) => total + report.closedCapaCount,
    );

    return MonthlyHseReportData(
      year: year,
      month: month,
      reports: reports,
      totalReports: reports.length,
      inspectionCount: inspectionReports.length,
      investigationCount: countType(ReportType.incident),
      hazardCount: countType(ReportType.hazard),
      jsaCount: countType(ReportType.jsa),
      riskAssessmentCount: countType(ReportType.riskAssessment),
      toolboxTalkCount: countType(ReportType.toolboxTalk),
      totalCapaCount: totalCapaCount,
      openCapaCount: openCapaCount,
      inProgressCapaCount: inProgressCapaCount,
      closedCapaCount: closedCapaCount,
      averageInspectionScore: averageScore,
      scoredInspectionCount: scores.length,
    );
  }

  String get monthLabel {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  String get periodLabel => '$monthLabel $year';
}
