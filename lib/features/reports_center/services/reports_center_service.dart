import '../../toolbox_talk/models/toolbox_talk_result.dart';
import '../../toolbox_talk/storage/toolbox_talk_storage_service.dart';
import '../../jsa/storage/jsa_storage_service.dart';
import '../../risk_assessment/storage/risk_assessment_storage_service.dart';
import '../../../services/storage_service.dart';
import '../../../models/inspection_record.dart';
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
      subtitle: 'Risk: ${record.riskLevel}',
      createdAt: record.createdAt,
    );
  }
}
