class TeamMember {
  final String id;
  final String organizationId;
  final String fullName;
  final String email;
  final String jobTitle;
  final String role;
  final bool isActive;

  const TeamMember({
    required this.id,
    required this.organizationId,
    required this.fullName,
    required this.email,
    required this.jobTitle,
    required this.role,
    required this.isActive,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id']?.toString() ?? '',
      organizationId: json['organization_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      jobTitle: json['job_title']?.toString() ?? '',
      role: json['role']?.toString() ?? 'viewer',
      isActive: json['is_active'] == true,
    );
  }
}
