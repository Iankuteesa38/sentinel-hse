import 'package:supabase_flutter/supabase_flutter.dart';

class OperationalReportCloudService {
  OperationalReportCloudService._();

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

  static Future<void> syncReport({
    required String moduleType,
    required String localId,
    required String title,
    required Map<String, dynamic> reportData,
    required DateTime createdAt,
  }) async {
    final user = _client.auth.currentUser;
    final organizationId = await _organizationId();

    if (user == null || organizationId == null || organizationId.isEmpty) {
      return;
    }

    await _client.from('operational_reports').upsert({
      'organization_id': organizationId,
      'module_type': moduleType,
      'local_id': localId,
      'title': title,
      'report_data': reportData,
      'created_by': user.id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'organization_id,module_type,local_id');
  }
}
