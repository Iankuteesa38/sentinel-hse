import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import '../../cloud_sync/services/inspection_cloud_service.dart';
import '../models/inspection_finding.dart';
import '../models/inspection_report_data.dart';

class InspectionHistoryService {
  static const String _fileName = 'sentinel_inspection_history.json';

  static String generateReference({required String templateId}) {
    final now = DateTime.now();

    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    String prefix;

    switch (templateId) {
      case 'camp_welfare':
        prefix = 'CWA';
        break;
      case 'lifting_hoisting':
        prefix = 'LHO';
        break;
      case 'adnoc_vaai_vehicle':
        prefix = 'VSC';
        break;
      default:
        prefix = 'INS';
    }

    return 'SEN-$prefix-'
        '${now.year}'
        '${twoDigits(now.month)}'
        '${twoDigits(now.day)}-'
        '${twoDigits(now.hour)}'
        '${twoDigits(now.minute)}'
        '${twoDigits(now.second)}';
  }

  static Future<File> _getHistoryFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/$_fileName');
  }

  static Future<void> saveReport(InspectionReportData report) async {
    final reports = await loadReports();

    reports.removeWhere(
      (savedReport) => savedReport.reportReference == report.reportReference,
    );

    reports.insert(0, report);

    final file = await _getHistoryFile();

    final encodedReports = reports.map(_reportToJson).toList();

    await file.writeAsString(jsonEncode(encodedReports), flush: true);
    try {
      await InspectionCloudService.syncReport(report);
    } catch (_) {
      // Keep local/offline save successful if cloud sync is unavailable.
    }
  }

  static Future<List<InspectionReportData>> loadReports() async {
    try {
      final file = await _getHistoryFile();

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();

      if (contents.trim().isEmpty) {
        return [];
      }

      final decoded = jsonDecode(contents);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map((report) => _reportFromJson(Map<String, dynamic>.from(report)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Map<String, dynamic> _reportToJson(InspectionReportData report) {
    return {
      'reportReference': report.reportReference,
      'inspectionTitle': report.inspectionTitle,
      'inspectionLocation': report.inspectionLocation,
      'inspectorName': report.inspectorName,
      'inspectorEmployeeId': report.inspectorEmployeeId,
      'driverName': report.driverName,
      'driverEmployeeId': report.driverEmployeeId,
      'vehiclePlateNumber': report.vehiclePlateNumber,
      'vehicleFleetNumber': report.vehicleFleetNumber,
      'vehicleMakeModel': report.vehicleMakeModel,
      'odometerReading': report.odometerReading,
      'campName': report.campName,
      'contractorName': report.contractorName,
      'contractAdministrator': report.contractAdministrator,
      'groupCompany': report.groupCompany,
      'assetFunction': report.assetFunction,
      'campRepresentative': report.campRepresentative,
      'liftingGroupCompany': report.liftingGroupCompany,
      'liftingContractorLocation': report.liftingContractorLocation,
      'submittedAt': report.submittedAt.toIso8601String(),
      'items': report.items.map((item) {
        return {
          'itemNumber': item.itemNumber,
          'section': item.section,
          'requirement': item.requirement,
          'answer': item.answer,
          'comment': item.comment,
          'performanceRating': item.performanceRating,
          'revisedRiskRanking': item.revisedRiskRanking,
          'marks': item.marks,
          'weight': item.weight,
          'weightedScore': item.weightedScore,
        };
      }).toList(),
      'findings': report.findings.map((finding) {
        return {
          'itemNumber': finding.itemNumber,
          'requirement': finding.requirement,
          'finding': finding.finding,
          'riskLevel': finding.riskLevel,
          'correctiveAction': finding.correctiveAction,
          'responsiblePerson': finding.responsiblePerson,
          'targetDate': finding.targetDate.toIso8601String(),
          'status': finding.status,
          'closedBy': finding.closedBy,
          'closureComment': finding.closureComment,
          'closedAt': finding.closedAt?.toIso8601String(),
          'closureEvidence': finding.closureEvidence.map(base64Encode).toList(),
        };
      }).toList(),
      'findingPhotos': report.findingPhotos.map(
        (itemNumber, photos) =>
            MapEntry(itemNumber.toString(), photos.map(base64Encode).toList()),
      ),
    };
  }

  static InspectionReportData _reportFromJson(Map<String, dynamic> json) {
    final itemJsonList = json['items'] as List<dynamic>? ?? [];

    final findingJsonList = json['findings'] as List<dynamic>? ?? [];

    final rawPhotos = json['findingPhotos'];

    final photosJson = rawPhotos is Map
        ? Map<String, dynamic>.from(rawPhotos)
        : <String, dynamic>{};

    final items = itemJsonList.map((itemJson) {
      final item = Map<String, dynamic>.from(itemJson as Map);

      return InspectionReportItem(
        itemNumber: item['itemNumber'] as int? ?? 0,
        section: item['section'] as String? ?? '',
        requirement: item['requirement'] as String? ?? '',
        answer: item['answer'] as String? ?? '',
        comment: item['comment'] as String? ?? '',
        performanceRating: item['performanceRating'] as String? ?? '',
        revisedRiskRanking: item['revisedRiskRanking'] as String? ?? '',
        marks: (item['marks'] as num?)?.toDouble() ?? 0,
        weight: (item['weight'] as num?)?.toDouble() ?? 1.0,
        weightedScore: (item['weightedScore'] as num?)?.toDouble() ?? 0,
      );
    }).toList();

    final findings = findingJsonList.map((findingJson) {
      final finding = Map<String, dynamic>.from(findingJson as Map);

      return InspectionFinding(
        itemNumber: finding['itemNumber'] as int? ?? 0,
        requirement: finding['requirement'] as String? ?? '',
        finding: finding['finding'] as String? ?? '',
        riskLevel: finding['riskLevel'] as String? ?? 'Low',
        correctiveAction: finding['correctiveAction'] as String? ?? '',
        responsiblePerson: finding['responsiblePerson'] as String? ?? '',
        targetDate:
            DateTime.tryParse(finding['targetDate'] as String? ?? '') ??
            DateTime.now(),
        status: finding['status'] as String? ?? 'Open',
        closedBy: finding['closedBy'] as String? ?? '',
        closureComment: finding['closureComment'] as String? ?? '',
        closedAt: DateTime.tryParse(finding['closedAt'] as String? ?? ''),
        closureEvidence: (finding['closureEvidence'] as List<dynamic>? ?? [])
            .whereType<String>()
            .map(base64Decode)
            .toList(),
      );
    }).toList();

    final findingPhotos = <int, List<Uint8List>>{};

    for (final entry in photosJson.entries) {
      final itemNumber = int.tryParse(entry.key);

      if (itemNumber == null || entry.value is! List) {
        continue;
      }

      findingPhotos[itemNumber] = (entry.value as List)
          .whereType<String>()
          .map(base64Decode)
          .toList();
    }

    return InspectionReportData(
      reportReference: json['reportReference'] as String? ?? 'Unknown',
      inspectionTitle: json['inspectionTitle'] as String? ?? '',
      inspectionLocation: json['inspectionLocation'] as String? ?? '',
      inspectorName: json['inspectorName'] as String? ?? '',
      inspectorEmployeeId: json['inspectorEmployeeId'] as String? ?? '',
      driverName: json['driverName'] as String? ?? '',
      driverEmployeeId: json['driverEmployeeId'] as String? ?? '',
      vehiclePlateNumber: json['vehiclePlateNumber'] as String? ?? '',
      vehicleFleetNumber: json['vehicleFleetNumber'] as String? ?? '',
      vehicleMakeModel: json['vehicleMakeModel'] as String? ?? '',
      odometerReading: json['odometerReading'] as String? ?? '',
      campName: json['campName'] as String? ?? '',
      contractorName: json['contractorName'] as String? ?? '',
      contractAdministrator: json['contractAdministrator'] as String? ?? '',
      groupCompany: json['groupCompany'] as String? ?? '',
      assetFunction: json['assetFunction'] as String? ?? '',
      campRepresentative: json['campRepresentative'] as String? ?? '',
      liftingGroupCompany: json['liftingGroupCompany'] as String? ?? '',
      liftingContractorLocation:
          json['liftingContractorLocation'] as String? ?? '',
      submittedAt:
          DateTime.tryParse(json['submittedAt'] as String? ?? '') ??
          DateTime.now(),
      items: items,
      findings: findings,
      findingPhotos: findingPhotos,
    );
  }
}
