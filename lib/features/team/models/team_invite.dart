class TeamInvite {
  final String id;
  final String organizationId;
  final String email;
  final String fullName;
  final String jobTitle;
  final String role;
  final String status;
  final String invitedBy;
  final DateTime? createdAt;
  final DateTime? acceptedAt;

  const TeamInvite({
    required this.id,
    required this.organizationId,
    required this.email,
    required this.fullName,
    required this.jobTitle,
    required this.role,
    required this.status,
    required this.invitedBy,
    required this.createdAt,
    required this.acceptedAt,
  });

  factory TeamInvite.fromJson(Map<String, dynamic> json) {
    return TeamInvite(
      id: json['id']?.toString() ?? '',
      organizationId: json['organization_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      jobTitle: json['job_title']?.toString() ?? '',
      role: json['role']?.toString() ?? 'viewer',
      status: json['status']?.toString() ?? 'pending',
      invitedBy: json['invited_by']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      acceptedAt: DateTime.tryParse(json['accepted_at']?.toString() ?? ''),
    );
  }
}
