import 'manage_team_member_page.dart';
import 'package:flutter/material.dart';
import 'invite_team_member_page.dart';
import '../models/team_member.dart';
import '../services/team_service.dart';

class TeamMembersPage extends StatefulWidget {
  const TeamMembersPage({super.key});

  @override
  State<TeamMembersPage> createState() => _TeamMembersPageState();
}

class _TeamMembersPageState extends State<TeamMembersPage> {
  late Future<List<TeamMember>> membersFuture;
  late Future<String> userRoleFuture;
  @override
  void initState() {
    super.initState();
    membersFuture = TeamService.getTeamMembers();
    userRoleFuture = TeamService.getCurrentUserRole();
  }

  Future<void> _refresh() async {
    setState(() {
      membersFuture = TeamService.getTeamMembers();
    });

    await membersFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Members'),
        actions: [
          FutureBuilder<String>(
            future: userRoleFuture,
            builder: (context, snapshot) {
              if (snapshot.data != 'admin') {
                return const SizedBox.shrink();
              }

              return IconButton(
                icon: const Icon(Icons.person_add_alt_1),
                tooltip: 'Invite Team Member',
                onPressed: () async {
                  final created = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InviteTeamMemberPage(),
                    ),
                  );

                  if (created == true && mounted) {
                    await _refresh();
                  }
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: FutureBuilder<String>(
        future: userRoleFuture,
        builder: (context, snapshot) {
          final role = snapshot.data ?? 'viewer';

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Your role: ${role.toUpperCase()}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<TeamMember>>(
          future: membersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load team members:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }

            final members = snapshot.data ?? [];

            if (members.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  Icon(Icons.groups_outlined, size: 72),
                  SizedBox(height: 16),
                  Text('No team members found.', textAlign: TextAlign.center),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: members.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final member = members[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        member.fullName.isEmpty
                            ? '?'
                            : member.fullName[0].toUpperCase(),
                      ),
                    ),
                    title: Text(
                      member.fullName.isEmpty ? member.email : member.fullName,
                    ),
                    subtitle: Text('${member.jobTitle}\n${member.email}'),
                    isThreeLine: true,
                    trailing: FutureBuilder<String>(
                      future: userRoleFuture,
                      builder: (context, roleSnapshot) {
                        final currentRole = roleSnapshot.data ?? 'viewer';

                        if (currentRole != 'admin') {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                member.role.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                member.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: member.isActive
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          );
                        }

                        return IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Manage Team Member',
                          onPressed: () async {
                            final updated = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ManageTeamMemberPage(member: member),
                              ),
                            );

                            if (updated == true && mounted) {
                              await _refresh();
                            }
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
