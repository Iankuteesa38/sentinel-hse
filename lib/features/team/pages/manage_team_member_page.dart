import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/team_member.dart';
import '../services/team_service.dart';

class ManageTeamMemberPage extends StatefulWidget {
  final TeamMember member;

  const ManageTeamMemberPage({super.key, required this.member});

  @override
  State<ManageTeamMemberPage> createState() => _ManageTeamMemberPageState();
}

class _ManageTeamMemberPageState extends State<ManageTeamMemberPage> {
  late String selectedRole;
  late bool isActive;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.member.role;
    isActive = widget.member.isActive;
  }

  Future<void> _save() async {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    final isManagingSelf = currentUserId == widget.member.id;

    if (isManagingSelf && (selectedRole != 'admin' || !isActive)) {
      final activeAdminCount = await TeamService.getActiveAdminCount();

      if (activeAdminCount <= 1) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You are the only active admin. Assign another admin before changing your own admin access.',
            ),
          ),
        );

        return;
      }
    }
    setState(() {
      isSaving = true;
    });

    try {
      await TeamService.updateTeamMember(
        memberId: widget.member.id,
        role: selectedRole,
        isActive: isActive,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to update team member: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Team Member')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.member.fullName.isEmpty
                    ? widget.member.email
                    : widget.member.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(widget.member.email),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'hse', child: Text('HSE')),
                  DropdownMenuItem(
                    value: 'supervisor',
                    child: Text('Supervisor'),
                  ),
                  DropdownMenuItem(value: 'viewer', child: Text('Viewer')),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active Member'),
                subtitle: Text(
                  isActive
                      ? 'This user can access the organization.'
                      : 'This user is marked inactive.',
                ),
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: isSaving ? null : _save,
                icon: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(isSaving ? 'Saving...' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
