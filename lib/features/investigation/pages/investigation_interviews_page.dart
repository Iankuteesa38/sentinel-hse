import 'package:flutter/material.dart';

import '../models/investigation_interview.dart';
import '../services/investigation_draft_service.dart';

class InvestigationInterviewsPage extends StatefulWidget {
  const InvestigationInterviewsPage({super.key});

  @override
  State<InvestigationInterviewsPage> createState() =>
      _InvestigationInterviewsPageState();
}

class _InvestigationInterviewsPageState
    extends State<InvestigationInterviewsPage> {
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final companyController = TextEditingController();

  final interviewersController = TextEditingController();

  final statementController = TextEditingController();
  final observationsController = TextEditingController();
  final hearsayController = TextEditingController();
  final contradictionsController = TextEditingController();
  final corroborationController = TextEditingController();
  final followUpController = TextEditingController();

  bool signedStatementAvailable = false;

  void _addInterview() {
    if (nameController.text.trim().isEmpty ||
        statementController.text.trim().isEmpty) {
      return;
    }

    final interviews = InvestigationDraftService.current.interviews;

    final interviewers = interviewersController.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    setState(() {
      interviews.add(
        InvestigationInterview(
          interviewId:
              'INT-${(interviews.length + 1).toString().padLeft(3, '0')}',
          personName: nameController.text.trim(),
          role: roleController.text.trim(),
          company: companyController.text.trim(),
          interviewDate: DateTime.now(),
          interviewers: interviewers,
          statementSummary: statementController.text.trim(),
          directObservations: observationsController.text.trim(),
          assumptionsOrHearsay: hearsayController.text.trim(),
          contradictions: contradictionsController.text.trim(),
          corroboratingEvidence: corroborationController.text.trim(),
          followUpRequired: followUpController.text.trim(),
          signedStatementAvailable: signedStatementAvailable,
        ),
      );

      nameController.clear();
      roleController.clear();
      companyController.clear();
      interviewersController.clear();
      statementController.clear();
      observationsController.clear();
      hearsayController.clear();
      contradictionsController.clear();
      corroborationController.clear();
      followUpController.clear();

      signedStatementAvailable = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    companyController.dispose();
    interviewersController.dispose();
    statementController.dispose();
    observationsController.dispose();
    hearsayController.dispose();
    contradictionsController.dispose();
    corroborationController.dispose();
    followUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interviews = InvestigationDraftService.current.interviews;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Witness Interviews'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Person Interviewed',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: roleController,
            decoration: const InputDecoration(
              labelText: 'Role',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: companyController,
            decoration: const InputDecoration(
              labelText: 'Company',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: interviewersController,
            decoration: const InputDecoration(
              labelText: 'Interviewers',
              hintText: 'Ian, HSE Manager',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: statementController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Statement Summary',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: observationsController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Direct Observations',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: hearsayController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Assumptions / Hearsay',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: contradictionsController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Contradictions',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: corroborationController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Corroborating Evidence',
              hintText: 'EV-002, EV-004',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: followUpController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Follow-up Required',
              border: OutlineInputBorder(),
            ),
          ),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: signedStatementAvailable,
            title: const Text('Signed statement available'),
            onChanged: (value) {
              setState(() => signedStatementAvailable = value ?? false);
            },
          ),

          ElevatedButton.icon(
            onPressed: _addInterview,
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Add Interview'),
          ),

          const SizedBox(height: 20),

          ...interviews.map(
            (interview) => Card(
              child: ListTile(
                leading: const Icon(Icons.record_voice_over),
                title: Text(
                  '${interview.interviewId} - '
                  '${interview.personName}',
                ),
                subtitle: Text(
                  '${interview.role} | '
                  '${interview.company}\n'
                  '${interview.statementSummary}',
                ),
                isThreeLine: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
