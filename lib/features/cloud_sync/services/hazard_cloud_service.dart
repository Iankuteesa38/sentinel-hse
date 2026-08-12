import 'dart:io';
import 'evidence_cloud_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/inspection_record.dart';

class HazardCloudService {
  HazardCloudService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static Future<String?> _organizationId() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final profile = await _client
        .from('profiles')
        .select('organization_id')
        .eq('id', user.id)
        .maybeSingle();

    return profile?['organization_id']?.toString();
  }

  static Future<void> upsertHazard({
    required String localId,
    required String title,
    required String description,
    required String location,
    required String category,
    required String riskLevel,
    required String status,
    required String responsiblePerson,
    required DateTime? targetDate,
    required String reportedBy,
    required List<String> closureEvidencePaths,
  }) async {
    final user = _client.auth.currentUser;
    final organizationId = await _organizationId();

    if (user == null || organizationId == null || organizationId.isEmpty) {
      return;
    }

    await _client.from('hazards').upsert({
      'organization_id': organizationId,
      'local_id': localId,
      'title': title,
      'description': description,
      'location': location,
      'category': category,
      'risk_level': riskLevel,
      'status': status,
      'responsible_person': responsiblePerson,
      'target_date': targetDate?.toIso8601String(),
      'reported_by': reportedBy,
      'created_by': user.id,
      'updated_at': DateTime.now().toIso8601String(),
      'closure_evidence_paths': closureEvidencePaths,
    }, onConflict: 'organization_id,local_id');
  }

  static Future<void> upsertRecord(InspectionRecord record) async {
    final closureEvidenceCloudPaths = <String>[];

    for (final localPath in record.closureEvidencePaths) {
      final file = File(localPath);

      if (!await file.exists()) {
        continue;
      }

      final cloudPath = await EvidenceCloudService.uploadFile(
        file: file,
        module: 'hazard_closure',
        recordId: record.inspectionId,
        fileName: file.uri.pathSegments.last,
      );

      if (cloudPath != null) {
        closureEvidenceCloudPaths.add(cloudPath);
      }
    }
    String readField(String label) {
      for (final line in record.analysis.split('\n')) {
        final trimmed = line.trim();

        if (trimmed.toLowerCase().startsWith('${label.toLowerCase()}:')) {
          return trimmed.substring(trimmed.indexOf(':') + 1).trim();
        }
      }

      return '';
    }

    await upsertHazard(
      localId: record.inspectionId,
      title: readField('Description').isNotEmpty
          ? readField('Description')
          : 'Hazard ${record.inspectionId}',
      description: record.analysis,
      location: record.location,
      category: readField('Category'),
      riskLevel: record.riskLevel,
      status: record.status,
      responsiblePerson: record.responsiblePerson,
      targetDate: record.targetDate,
      reportedBy: record.inspector,
      closureEvidencePaths: closureEvidenceCloudPaths,
    );
  }
}
