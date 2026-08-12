import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class EvidenceCloudService {
  EvidenceCloudService._();

  static const String bucketName = 'sentinel-evidence';

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

  static String _safeSegment(String value) {
    return value.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  }

  static Future<String?> uploadFile({
    required File file,
    required String module,
    required String recordId,
    required String fileName,
  }) async {
    final organizationId = await _organizationId();

    if (organizationId == null || organizationId.isEmpty) {
      return null;
    }

    final path =
        '$organizationId/'
        '${_safeSegment(module)}/'
        '${_safeSegment(recordId)}/'
        '${DateTime.now().microsecondsSinceEpoch}_${_safeSegment(fileName)}';

    await _client.storage
        .from(bucketName)
        .upload(path, file, fileOptions: const FileOptions(upsert: true));

    return path;
  }

  static Future<String?> uploadBytes({
    required Uint8List bytes,
    required String module,
    required String recordId,
    required String fileName,
  }) async {
    final organizationId = await _organizationId();

    if (organizationId == null || organizationId.isEmpty) {
      return null;
    }

    final path =
        '$organizationId/'
        '${_safeSegment(module)}/'
        '${_safeSegment(recordId)}/'
        '${DateTime.now().microsecondsSinceEpoch}_${_safeSegment(fileName)}';

    await _client.storage
        .from(bucketName)
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return path;
  }

  static Future<Uint8List?> downloadBytes(String path) async {
    if (path.trim().isEmpty) {
      return null;
    }

    return _client.storage.from(bucketName).download(path);
  }
}
