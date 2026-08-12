import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSetupService {
  AccountSetupService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static Future<bool> hasProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cloud_profile_exists_${user.id}';

    try {
      final result = await _client
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      final exists = result != null;

      await prefs.setBool(cacheKey, exists);

      return exists;
    } catch (_) {
      return prefs.getBool(cacheKey) ?? false;
    }
  }

  static Future<bool> isCurrentUserActive() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cloud_profile_active_${user.id}';

    try {
      final result = await _client
          .from('profiles')
          .select('is_active')
          .eq('id', user.id)
          .maybeSingle();

      final isActive = result?['is_active'] == true;

      await prefs.setBool(cacheKey, isActive);

      return isActive;
    } catch (_) {
      return prefs.getBool(cacheKey) ?? true;
    }
  }

  static Future<bool> completeInvitedAccount() async {
    final session = _client.auth.currentSession;

    if (session == null) {
      return false;
    }

    final response = await _client.functions.invoke(
      'complete-invited-account',
      headers: {'Authorization': 'Bearer ${session.accessToken}'},
    );

    final data = response.data;

    if (data is! Map) {
      return false;
    }

    if (data['success'] == true &&
        (data['invited'] == true || data['alreadyCompleted'] == true)) {
      return true;
    }

    return false;
  }

  static Future<void> createInitialAccount({
    required String organizationName,
    required String fullName,
    required String jobTitle,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    final organization = await _client
        .from('organizations')
        .insert({'name': organizationName.trim(), 'created_by': user.id})
        .select('id')
        .single();

    final organizationId = organization['id'] as String;

    await _client.from('profiles').insert({
      'id': user.id,
      'organization_id': organizationId,
      'full_name': fullName.trim(),
      'email': user.email ?? '',
      'job_title': jobTitle.trim(),
      'role': 'admin',
      'is_active': true,
    });
  }
}
