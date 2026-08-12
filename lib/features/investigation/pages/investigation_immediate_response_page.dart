import 'package:flutter/material.dart';

import '../models/investigation_immediate_response.dart';
import '../services/investigation_draft_service.dart';

class InvestigationImmediateResponsePage extends StatefulWidget {
  const InvestigationImmediateResponsePage({super.key});

  @override
  State<InvestigationImmediateResponsePage> createState() =>
      _InvestigationImmediateResponsePageState();
}

class _InvestigationImmediateResponsePageState
    extends State<InvestigationImmediateResponsePage> {
  bool emergencyResponse = false;
  bool medicalTreatment = false;
  bool sceneIsolated = false;
  bool madeSafe = false;
  bool authorityNotified = false;
  bool evidencePreserved = false;
  bool stopWork = false;

  final immediateActionsController = TextEditingController();
  final sceneControlController = TextEditingController();
  final notificationsController = TextEditingController();
  final temporaryControlsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final existing = InvestigationDraftService.current.immediateResponse;

    if (existing != null) {
      emergencyResponse = existing.emergencyResponseActivated;
      medicalTreatment = existing.medicalTreatmentProvided;
      sceneIsolated = existing.sceneIsolated;
      madeSafe = existing.equipmentMadeSafe;
      authorityNotified = existing.authorityNotified;
      evidencePreserved = existing.evidencePreserved;
      stopWork = existing.stopWorkApplied;

      immediateActionsController.text = existing.immediateActions;
      sceneControlController.text = existing.sceneControlDetails;
      notificationsController.text = existing.notifications;
      temporaryControlsController.text = existing.temporaryControls;
    }
  }

  @override
  void dispose() {
    immediateActionsController.dispose();
    sceneControlController.dispose();
    notificationsController.dispose();
    temporaryControlsController.dispose();
    super.dispose();
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _save() {
    InvestigationDraftService.current.immediateResponse =
        InvestigationImmediateResponse(
          emergencyResponseActivated: emergencyResponse,
          medicalTreatmentProvided: medicalTreatment,
          sceneIsolated: sceneIsolated,
          equipmentMadeSafe: madeSafe,
          authorityNotified: authorityNotified,
          evidencePreserved: evidencePreserved,
          stopWorkApplied: stopWork,
          immediateActions: immediateActionsController.text.trim(),
          sceneControlDetails: sceneControlController.text.trim(),
          notifications: notificationsController.text.trim(),
          temporaryControls: temporaryControlsController.text.trim(),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Immediate Response'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Initial Response & Scene Control',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          CheckboxListTile(
            value: emergencyResponse,
            title: const Text('Emergency response activated'),
            onChanged: (value) {
              setState(() => emergencyResponse = value ?? false);
            },
          ),
          CheckboxListTile(
            value: medicalTreatment,
            title: const Text('Medical treatment / first aid provided'),
            onChanged: (value) {
              setState(() => medicalTreatment = value ?? false);
            },
          ),
          CheckboxListTile(
            value: sceneIsolated,
            title: const Text('Scene isolated and controlled'),
            onChanged: (value) {
              setState(() => sceneIsolated = value ?? false);
            },
          ),
          CheckboxListTile(
            value: madeSafe,
            title: const Text('Vehicle / equipment made safe'),
            onChanged: (value) {
              setState(() => madeSafe = value ?? false);
            },
          ),
          CheckboxListTile(
            value: authorityNotified,
            title: const Text('Police / regulator / client notified'),
            onChanged: (value) {
              setState(() => authorityNotified = value ?? false);
            },
          ),
          CheckboxListTile(
            value: evidencePreserved,
            title: const Text('Evidence preserved'),
            onChanged: (value) {
              setState(() => evidencePreserved = value ?? false);
            },
          ),
          CheckboxListTile(
            value: stopWork,
            title: const Text('Stop-work / temporary suspension applied'),
            onChanged: (value) {
              setState(() => stopWork = value ?? false);
            },
          ),

          const SizedBox(height: 12),

          _field(immediateActionsController, 'Immediate Actions Taken'),
          _field(sceneControlController, 'Scene Control Details'),
          _field(notificationsController, 'Notifications Made'),
          _field(temporaryControlsController, 'Temporary / Interim Controls'),

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
