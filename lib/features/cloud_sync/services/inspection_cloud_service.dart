import 'package:supabase_flutter/supabase_flutter.dart';
import 'evidence_cloud_service.dart';
import '../../inspection_engine/models/inspection_report_data.dart';

class InspectionCloudService {
  InspectionCloudService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static Future<String?> _organizationId() async {
    final user = _client.auth.currentUser;

    if (user == null) return null;

    final profile = await _client
        .from('profiles')
        .select('organization_id')
        .eq('id', user.id)
        .maybeSingle();

    return profile?['organization_id']?.toString();
  }

  static Future<void> syncReport(InspectionReportData report) async {
    final user = _client.auth.currentUser;
    final organizationId = await _organizationId();

    if (user == null || organizationId == null || organizationId.isEmpty) {
      return;
    }

    final reportPayload = <String, dynamic>{
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
    };

    final inspection = await _client
        .from('inspections')
        .upsert({
          'organization_id': organizationId,
          'report_reference': report.reportReference,
          'inspection_title': report.inspectionTitle,
          'inspection_location': report.inspectionLocation,
          'inspector_name': report.inspectorName,
          'submitted_at': report.submittedAt.toIso8601String(),
          'compliance_percentage': report.compliancePercentage,
          'report_json': reportPayload,
          'created_by': user.id,
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'organization_id,report_reference')
        .select('id')
        .single();

    final inspectionId = inspection['id'].toString();

    await _client
        .from('inspection_findings')
        .delete()
        .eq('inspection_id', inspectionId);

    if (report.findings.isEmpty) return;

    final findingRows = <Map<String, dynamic>>[];

    for (final finding in report.findings) {
      final closureEvidencePaths = <String>[];

      for (int i = 0; i < finding.closureEvidence.length; i++) {
        final cloudPath = await EvidenceCloudService.uploadBytes(
          bytes: finding.closureEvidence[i],
          module: 'capa',
          recordId: report.reportReference,
          fileName: 'item_${finding.itemNumber}_closure_$i.jpg',
        );

        if (cloudPath != null) {
          closureEvidencePaths.add(cloudPath);
        }
      }

      final findingPhotoPaths = <String>[];
      final photos = report.findingPhotos[finding.itemNumber] ?? [];

      for (int i = 0; i < photos.length; i++) {
        final cloudPath = await EvidenceCloudService.uploadBytes(
          bytes: photos[i],
          module: 'inspection',
          recordId: report.reportReference,
          fileName: 'item_${finding.itemNumber}_finding_$i.jpg',
        );

        if (cloudPath != null) {
          findingPhotoPaths.add(cloudPath);
        }
      }

      findingRows.add({
        'inspection_id': inspectionId,
        'organization_id': organizationId,
        'item_number': finding.itemNumber,
        'requirement': finding.requirement,
        'finding': finding.finding,
        'risk_level': finding.riskLevel,
        'corrective_action': finding.correctiveAction,
        'responsible_person': finding.responsiblePerson,
        'target_date': finding.targetDate.toIso8601String(),
        'status': finding.status,
        'closed_by': finding.closedBy,
        'closure_comment': finding.closureComment,
        'closed_at': finding.closedAt?.toIso8601String(),
        'closure_evidence_paths': closureEvidencePaths,
        'finding_photo_paths': findingPhotoPaths,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }

    await _client.from('inspection_findings').insert(findingRows);
  }
}
