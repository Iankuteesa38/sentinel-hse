import 'package:flutter/material.dart';

import '../models/investigation_human_factors.dart';
import '../services/investigation_draft_service.dart';

class InvestigationHumanFactorsPage extends StatefulWidget {
  const InvestigationHumanFactorsPage({super.key});

  @override
  State<InvestigationHumanFactorsPage> createState() =>
      _InvestigationHumanFactorsPageState();
}

class _InvestigationHumanFactorsPageState
    extends State<InvestigationHumanFactorsPage> {
  final fatigueController = TextEditingController();
  final competenceController = TextEditingController();
  final supervisionController = TextEditingController();
  final communicationController = TextEditingController();
  final proceduresController = TextEditingController();
  final pressureController = TextEditingController();
  final equipmentDesignController = TextEditingController();
  final situationalAwarenessController = TextEditingController();
  final riskPerceptionController = TextEditingController();
  final teamworkController = TextEditingController();
  final cultureController = TextEditingController();
  final managementController = TextEditingController();
  final contractorManagementController = TextEditingController();
  final changeManagementController = TextEditingController();
  final previousWarningsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final existing = InvestigationDraftService.current.humanFactors;

    if (existing != null) {
      fatigueController.text = existing.workloadFatigue;
      competenceController.text = existing.competenceExperience;
      supervisionController.text = existing.supervisionLeadership;
      communicationController.text = existing.communicationCoordination;
      proceduresController.text = existing.proceduresUsability;
      pressureController.text = existing.timeProductionPressure;
      equipmentDesignController.text = existing.equipmentWorkplaceDesign;
      situationalAwarenessController.text = existing.situationalAwareness;
      riskPerceptionController.text = existing.riskPerceptionDecisionMaking;
      teamworkController.text = existing.teamworkChallengeCulture;
      cultureController.text = existing.safetyReportingCulture;
      managementController.text = existing.managementDecisions;
      contractorManagementController.text = existing.contractorManagement;
      changeManagementController.text = existing.managementOfChange;
      previousWarningsController.text = existing.previousWarningSigns;
    }
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: 2,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _save() {
    InvestigationDraftService.current.humanFactors = InvestigationHumanFactors(
      workloadFatigue: fatigueController.text.trim(),
      competenceExperience: competenceController.text.trim(),
      supervisionLeadership: supervisionController.text.trim(),
      communicationCoordination: communicationController.text.trim(),
      proceduresUsability: proceduresController.text.trim(),
      timeProductionPressure: pressureController.text.trim(),
      equipmentWorkplaceDesign: equipmentDesignController.text.trim(),
      situationalAwareness: situationalAwarenessController.text.trim(),
      riskPerceptionDecisionMaking: riskPerceptionController.text.trim(),
      teamworkChallengeCulture: teamworkController.text.trim(),
      safetyReportingCulture: cultureController.text.trim(),
      managementDecisions: managementController.text.trim(),
      contractorManagement: contractorManagementController.text.trim(),
      managementOfChange: changeManagementController.text.trim(),
      previousWarningSigns: previousWarningsController.text.trim(),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    fatigueController.dispose();
    competenceController.dispose();
    supervisionController.dispose();
    communicationController.dispose();
    proceduresController.dispose();
    pressureController.dispose();
    equipmentDesignController.dispose();
    situationalAwarenessController.dispose();
    riskPerceptionController.dispose();
    teamworkController.dispose();
    cultureController.dispose();
    managementController.dispose();
    contractorManagementController.dispose();
    changeManagementController.dispose();
    previousWarningsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Human & Organisational Factors'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Human Performance & Organisational Conditions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _field(fatigueController, 'Workload / Fatigue / Fitness for Duty'),
          _field(competenceController, 'Competence / Training / Experience'),
          _field(supervisionController, 'Supervision / Leadership'),
          _field(communicationController, 'Communication / Coordination'),
          _field(
            proceduresController,
            'Procedures / Work Instructions / Usability',
          ),
          _field(pressureController, 'Time / Production / Schedule Pressure'),
          _field(
            equipmentDesignController,
            'Equipment / Interface / Workplace Design',
          ),
          _field(
            situationalAwarenessController,
            'Situational Awareness / Attention',
          ),
          _field(riskPerceptionController, 'Risk Perception / Decision Making'),
          _field(teamworkController, 'Teamwork / Challenge Culture'),
          _field(cultureController, 'Safety Culture / Reporting Culture'),
          _field(
            managementController,
            'Management Decisions / Resource Allocation',
          ),
          _field(
            contractorManagementController,
            'Contractor Management / Assurance',
          ),
          _field(changeManagementController, 'Management of Change'),
          _field(
            previousWarningsController,
            'Previous Warning Signs / Similar Events',
          ),

          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save & Return'),
          ),
        ],
      ),
    );
  }
}
