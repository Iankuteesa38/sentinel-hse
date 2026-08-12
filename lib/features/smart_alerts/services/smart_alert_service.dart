import '../../inspection_engine/services/inspection_history_service.dart';
import '../../../services/storage_service.dart';
import '../../investigation/services/investigation_history_service.dart';
import '../models/smart_alert.dart';

class SmartAlertService {
  SmartAlertService._();

  static Future<List<SmartAlert>> loadAlerts() async {
    final alerts = <SmartAlert>[];

    await _loadInspectionAlerts(alerts);
    await _loadHazardAlerts(alerts);
    await _loadInvestigationAlerts(alerts);

    alerts.sort((a, b) {
      final severityComparison = _severityPriority(
        a.severity,
      ).compareTo(_severityPriority(b.severity));

      if (severityComparison != 0) {
        return severityComparison;
      }

      if (a.overdue != b.overdue) {
        return a.overdue ? -1 : 1;
      }

      final aDate = a.targetDate ?? a.createdAt;
      final bDate = b.targetDate ?? b.createdAt;

      return aDate.compareTo(bDate);
    });

    return alerts;
  }

  static Future<void> _loadInspectionAlerts(List<SmartAlert> alerts) async {
    final reports = await InspectionHistoryService.loadReports();

    for (final report in reports) {
      for (final finding in report.findings) {
        final status = finding.status.trim();
        final normalizedStatus = status.toLowerCase();

        if (normalizedStatus == 'closed') {
          continue;
        }

        final risk = finding.riskLevel.trim().toLowerCase();

        final highRisk = risk == 'high' || risk == 'critical';

        final overdue = _isOverdue(finding.targetDate);

        SmartAlertSeverity severity;
        String title;

        if (overdue) {
          severity = SmartAlertSeverity.critical;
          title = 'Overdue Inspection CAPA';
        } else if (highRisk) {
          severity = SmartAlertSeverity.high;
          title = 'High-Risk Inspection Finding';
        } else if (normalizedStatus == 'in progress') {
          severity = SmartAlertSeverity.medium;
          title = 'Inspection CAPA In Progress';
        } else {
          severity = SmartAlertSeverity.medium;
          title = 'Open Inspection CAPA';
        }

        final location = report.inspectionLocation.trim();

        alerts.add(
          SmartAlert(
            id: '${report.reportReference}-${finding.itemNumber}',
            source: SmartAlertSource.inspectionCapa,
            severity: severity,
            title: title,
            message: finding.correctiveAction.trim().isEmpty
                ? finding.finding
                : finding.correctiveAction,
            reference: report.reportReference,
            location: location,
            responsiblePerson: finding.responsiblePerson,
            status: status,
            createdAt: report.submittedAt,
            targetDate: finding.targetDate,
            overdue: overdue,
          ),
        );
      }
    }
  }

  static Future<void> _loadHazardAlerts(List<SmartAlert> alerts) async {
    final records = await StorageService.getHazardRecords();

    for (final record in records) {
      if (record.isClosed) {
        continue;
      }

      final risk = record.riskLevel.toLowerCase();

      final highRisk = risk == 'high' || risk == 'critical';

      final overdue = record.isOverdue;

      SmartAlertSeverity severity;
      String title;

      if (overdue) {
        severity = SmartAlertSeverity.critical;
        title = 'Overdue Hazard Action';
      } else if (highRisk) {
        severity = SmartAlertSeverity.high;
        title = 'High-Risk Open Hazard';
      } else if (record.status == 'Controlled') {
        severity = SmartAlertSeverity.info;
        title = 'Controlled Hazard Awaiting Closure';
      } else {
        severity = SmartAlertSeverity.medium;
        title = 'Active Hazard';
      }

      alerts.add(
        SmartAlert(
          id: '${record.inspectionId}-HAZARD',
          source: SmartAlertSource.hazard,
          severity: severity,
          title: title,
          message: _hazardAlertMessage(record.analysis),
          reference: record.inspectionId,
          location: record.location,
          responsiblePerson: record.responsiblePerson,
          status: record.status,
          createdAt: record.createdAt,
          targetDate: record.targetDate,
          overdue: overdue,
        ),
      );
    }
  }

  static String _hazardAlertMessage(String analysis) {
    for (final line in analysis.split('\n')) {
      final trimmed = line.trim();

      if (trimmed.toLowerCase().startsWith('description:')) {
        final value = trimmed.substring('description:'.length).trim();

        if (value.isNotEmpty) {
          return value;
        }
      }
    }

    final cleaned = analysis.replaceAll(RegExp(r'\s+'), ' ').trim();

    if (cleaned.isEmpty) {
      return 'Hazard follow-up is required.';
    }

    if (cleaned.length <= 220) {
      return cleaned;
    }

    return '${cleaned.substring(0, 217)}...';
  }

  static Future<void> _loadInvestigationAlerts(List<SmartAlert> alerts) async {
    final drafts = await InvestigationHistoryService.loadDrafts();

    for (final draft in drafts) {
      final investigation = draft.investigationCase;

      final investigationStatus = investigation.reportStatus.name;

      final investigationClosed = investigationStatus == 'closed';

      for (final action in draft.actions) {
        final status = action.status.name;

        if (status == 'closed') {
          continue;
        }

        final overdue = status == 'overdue' || _isOverdue(action.targetDate);

        SmartAlertSeverity severity;
        String title;

        if (overdue) {
          severity = SmartAlertSeverity.critical;
          title = 'Overdue Investigation Action';
        } else if (status == 'pendingVerification' ||
            status == 'effectivenessReview') {
          severity = SmartAlertSeverity.high;
          title = 'Investigation Action Awaiting Verification';
        } else if (status == 'inProgress') {
          severity = SmartAlertSeverity.medium;
          title = 'Investigation Action In Progress';
        } else {
          severity = SmartAlertSeverity.medium;
          title = 'Open Investigation Action';
        }

        alerts.add(
          SmartAlert(
            id: '${investigation.investigationReference}-${action.actionId}',
            source: SmartAlertSource.investigationAction,
            severity: severity,
            title: title,
            message: action.action,
            reference: investigation.investigationReference,
            location: investigation.location,
            responsiblePerson: action.responsiblePerson,
            status: _statusLabel(status),
            createdAt: investigation.incidentDateTime,
            targetDate: action.targetDate,
            overdue: overdue,
          ),
        );
      }

      if (!investigationClosed) {
        alerts.add(
          SmartAlert(
            id: '${investigation.investigationReference}-FOLLOWUP',
            source: SmartAlertSource.investigation,
            severity: SmartAlertSeverity.medium,
            title: 'Investigation Follow-Up Required',
            message:
                '${investigation.incidentTitle} is currently '
                '${_statusLabel(investigationStatus)} and has not been closed.',
            reference: investigation.investigationReference,
            location: investigation.location,
            responsiblePerson: investigation.preparedBy,
            status: _statusLabel(investigationStatus),
            createdAt: investigation.incidentDateTime,
            targetDate: null,
            overdue: false,
          ),
        );
      }
    }
  }

  static bool _isOverdue(DateTime targetDate) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);

    return target.isBefore(today);
  }

  static int _severityPriority(SmartAlertSeverity severity) {
    switch (severity) {
      case SmartAlertSeverity.critical:
        return 0;
      case SmartAlertSeverity.high:
        return 1;
      case SmartAlertSeverity.medium:
        return 2;
      case SmartAlertSeverity.info:
        return 3;
    }
  }

  static String _statusLabel(String value) {
    switch (value) {
      case 'inProgress':
        return 'In Progress';

      case 'pendingVerification':
        return 'Pending Verification';

      case 'effectivenessReview':
        return 'Effectiveness Review';

      case 'finalReport':
        return 'Final';

      default:
        return value
            .replaceAllMapped(
              RegExp(r'([a-z])([A-Z])'),
              (match) => '${match.group(1)} ${match.group(2)}',
            )
            .replaceAllMapped(
              RegExp(r'^.'),
              (match) => match.group(0)!.toUpperCase(),
            );
    }
  }
}
