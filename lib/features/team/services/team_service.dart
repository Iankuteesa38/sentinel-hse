import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/team_member.dart';
import '../models/team_invite.dart';

class TeamService {
  TeamService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static Future<String?> getCurrentOrganizationId() async {
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

  static Future<String> getCurrentUserRole() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return 'viewer';
    }

    final profile = await _client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    return profile?['role']?.toString() ?? 'viewer';
  }

  static Future<int> getActiveAdminCount() async {
    final organizationId = await getCurrentOrganizationId();

    if (organizationId == null || organizationId.isEmpty) {
      return 0;
    }

    final rows = await _client
        .from('profiles')
        .select('id')
        .eq('organization_id', organizationId)
        .eq('role', 'admin')
        .eq('is_active', true);

    return (rows as List).length;
  }

  static Future<void> updateTeamMember({
    required String memberId,
    required String role,
    required bool isActive,
  }) async {
    await _client
        .from('profiles')
        .update({
          'role': role,
          'is_active': isActive,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', memberId);
  }

  static Future<List<TeamMember>> getTeamMembers() async {
    final organizationId = await getCurrentOrganizationId();

    if (organizationId == null || organizationId.isEmpty) {
      return [];
    }

    final rows = await _client
        .from('profiles')
        .select()
        .eq('organization_id', organizationId)
        .order('full_name');

    return (rows as List)
        .map((item) => TeamMember.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static Future<void> createInvite({
    required String email,
    required String fullName,
    required String jobTitle,
    required String role,
  }) async {
    final session = _client.auth.currentSession;

    if (session == null) {
      throw Exception('No authenticated user found.');
    }

    final response = await _client.functions.invoke(
      'invite-team-member',
      body: {
        'email': email.trim().toLowerCase(),
        'fullName': fullName.trim(),
        'jobTitle': jobTitle.trim(),
        'role': role,
      },
      headers: {'Authorization': 'Bearer ${session.accessToken}'},
    );

    final data = response.data;

    if (data is Map && data['success'] == true) {
      return;
    }

    final message = data is Map ? data['error']?.toString() : null;

    throw Exception(message ?? 'Unable to send team invitation.');
  }

  static Future<List<TeamInvite>> getInvites() async {
    final organizationId = await getCurrentOrganizationId();

    if (organizationId == null || organizationId.isEmpty) {
      return [];
    }

    final rows = await _client
        .from('team_invites')
        .select()
        .eq('organization_id', organizationId)
        .order('created_at', ascending: false);

    return (rows as List)
        .map((item) => TeamInvite.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
