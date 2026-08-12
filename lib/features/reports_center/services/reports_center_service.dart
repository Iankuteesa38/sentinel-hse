import '../../toolbox_talk/models/toolbox_talk_result.dart';
import '../../toolbox_talk/storage/toolbox_talk_storage_service.dart';
import '../../jsa/storage/jsa_storage_service.dart';
import '../../risk_assessment/storage/risk_assessment_storage_service.dart';
import '../../../services/storage_service.dart';
import '../../../models/inspection_record.dart';
import '../../inspection_engine/models/inspection_report_data.dart';
import '../../inspection_engine/services/inspection_history_service.dart';
import '../../investigation/models/investigation_draft.dart';
import '../../investigation/services/investigation_history_service.dart';
import '../models/report_item.dart';

class ReportsCenterService {
  ReportsCenterService._();

  static Future<List<ReportItem>> getAllReports() async {
    final List<ReportItem> reports = [];

    final toolboxTalks = await ToolboxTalkStorageService.getReports();

    reports.addAll(toolboxTalks.map(_toolboxTalkToReport));
    final jsaReports = await JsaStorageService.getReports();

    reports.addAll(jsaReports.map(_jsaToReport));
    final riskAssessments = await RiskAssessmentStorageService.getReports();

    reports.addAll(riskAssessments.map(_riskAssessmentToReport));
    final hazardRecords = await StorageService.getHazardRecords();

    reports.addAll(hazardRecords.map(_hazardToReport));
    final inspectionReports = await InspectionHistoryService.loadReports();

    reports.addAll(inspectionReports.map(_inspectionToReport));

    final investigationDrafts = await InvestigationHistoryService.loadDrafts();

    reports.addAll(investigationDrafts.map(_investigationToReport));

    reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return reports;
  }

  static ReportItem _toolboxTalkToReport(ToolboxTalkResult talk) {
    return ReportItem(
      id: talk.createdAt.toIso8601String(),
      type: ReportType.toolboxTalk,
      title: talk.topic,
      subtitle: talk.objective,
      createdAt: talk.createdAt,
    );
  }

  static ReportItem _jsaToReport(SavedJsaReport savedReport) {
    final result = savedReport.result;
    return ReportItem(
      id: savedReport.createdAt.toIso8601String(),
      type: ReportType.jsa,
      title: result.task,
      subtitle: '',
      createdAt: savedReport.createdAt,
    );
  }

  static ReportItem _riskAssessmentToReport(
    SavedRiskAssessmentReport savedReport,
  ) {
    final result = savedReport.result;

    return ReportItem(
      id: savedReport.createdAt.toIso8601String(),
      type: ReportType.riskAssessment,
      title: result.task,
      subtitle: result.initialRisk,
      createdAt: savedReport.createdAt,
    );
  }

  static ReportItem _hazardToReport(InspectionRecord record) {
    return ReportItem(
      id: record.inspectionId,
      type: ReportType.hazard,
      title: record.location.isEmpty
          ? 'Hazard Report'
          : 'Hazard Report - ${record.location}',
      subtitle:
          'Risk: ${record.riskLevel} | '
          'Status: ${record.status}',
      createdAt: record.createdAt,
      location: record.location,
    );
  }

  static ReportItem _inspectionToReport(InspectionReportData report) {
    final location = report.inspectionLocation.trim().isEmpty
        ? 'No location'
        : report.inspectionLocation.trim();

    final title = report.inspectionTitle.toLowerCase();

    final isWelfare =
        title.contains('contractor welfare') ||
        title.contains('welfare management audit') ||
        report.campName.isNotEmpty;

    final hasWelfareRatingData = report.items.any(
      (item) => item.performanceRating.trim().isNotEmpty,
    );

    final hasWelfareScore =
        !isWelfare || (hasWelfareRatingData && report.welfareTotalWeight > 0);

    final double? reportPercentage = isWelfare
        ? (hasWelfareScore ? report.welfareAuditPercentage : null)
        : report.compliancePercentage;

    final percentageText = isWelfare
        ? reportPercentage == null
              ? 'Audit Score: N/A (legacy record)'
              : 'Audit Score: ${reportPercentage.toStringAsFixed(1)}%'
        : 'Compliance: ${reportPercentage!.toStringAsFixed(1)}%';

    final openCapaCount = report.findings
        .where((finding) => finding.status == 'Open')
        .length;

    final inProgressCapaCount = report.findings
        .where((finding) => finding.status == 'In Progress')
        .length;

    final closedCapaCount = report.findings
        .where((finding) => finding.status == 'Closed')
        .length;

    return ReportItem(
      id: report.reportReference,
      type: ReportType.inspection,
      title: report.inspectionTitle,
      subtitle:
          '$location | ${report.reportReference} | '
          '$percentageText | '
          'CAPAs: ${report.findings.length}',
      createdAt: report.submittedAt,
      compliancePercentage: reportPercentage,
      capaCount: report.findings.length,
      openCapaCount: openCapaCount,
      inProgressCapaCount: inProgressCapaCount,
      closedCapaCount: closedCapaCount,
      location: location,
    );
  }

  static ReportItem _investigationToReport(InvestigationDraft draft) {
    final investigation = draft.investigationCase;

    final location = investigation.location.trim().isEmpty
        ? 'No location'
        : investigation.location.trim();

    final title = investigation.incidentTitle.trim().isEmpty
        ? 'Incident Investigation'
        : investigation.incidentTitle.trim();

    String status;

    switch (investigation.reportStatus.name) {
      case 'finalReport':
        status = 'Final';
        break;
      case 'closed':
        status = 'Closed';
        break;
      case 'preliminary':
        status = 'Preliminary';
        break;
      case 'interim':
        status = 'Interim';
        break;
      default:
        status = 'Draft';
    }

    return ReportItem(
      id: investigation.investigationReference,
      type: ReportType.incident,
      title: title,
      subtitle:
          '$location | ${investigation.investigationReference} | '
          'Status: $status',
      createdAt: investigation.incidentDateTime,
    );
  }
}
