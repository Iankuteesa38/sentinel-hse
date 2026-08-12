import 'package:flutter/material.dart';

import '../models/investigation_barrier.dart';
import '../services/investigation_draft_service.dart';

class InvestigationBarrierAnalysisPage extends StatefulWidget {
  const InvestigationBarrierAnalysisPage({super.key});

  @override
  State<InvestigationBarrierAnalysisPage> createState() =>
      _InvestigationBarrierAnalysisPageState();
}

class _InvestigationBarrierAnalysisPageState
    extends State<InvestigationBarrierAnalysisPage> {
  final hazardController = TextEditingController();
  final topEventController = TextEditingController();

  final threatController = TextEditingController();
  final barrierTitleController = TextEditingController();
  final expectedFunctionController = TextEditingController();
  final escalationFactorController = TextEditingController();
  final consequenceController = TextEditingController();
  final findingController = TextEditingController();

  final Set<String> selectedEvidenceIds = {};

  BarrierType barrierType = BarrierType.preventive;
  BarrierStatus barrierStatus = BarrierStatus.effective;

  @override
  void initState() {
    super.initState();

    final draft = InvestigationDraftService.current;

    hazardController.text = draft.hazard;
    topEventController.text = draft.topEvent;
  }

  String _label(Object value) {
    final raw = value.toString().split('.').last;

    return raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _pickEvidence() async {
    final evidence = InvestigationDraftService.current.evidence;

    if (evidence.isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add evidence to the Evidence Register first.'),
        ),
      );
      return;
    }

    final working = Set<String>.from(selectedEvidenceIds);

    final result = await showDialog<Set<String>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Supporting Evidence'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: evidence.map((item) {
                    return CheckboxListTile(
                      value: working.contains(item.evidenceId),
                      title: Text('${item.evidenceId} - ${item.title}'),
                      onChanged: (value) {
                        setDialogState(() {
                          if (value ?? false) {
                            working.add(item.evidenceId);
                          } else {
                            working.remove(item.evidenceId);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, working),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedEvidenceIds
          ..clear()
          ..addAll(result);
      });
    }
  }

  void _addBarrier() {
    if (barrierTitleController.text.trim().isEmpty) {
      return;
    }

    final draft = InvestigationDraftService.current;

    draft.hazard = hazardController.text.trim();
    draft.topEvent = topEventController.text.trim();

    setState(() {
      draft.barriers.add(
        InvestigationBarrier(
          barrierId:
              'BR-${(draft.barriers.length + 1).toString().padLeft(3, '0')}',
          title: barrierTitleController.text.trim(),
          barrierType: barrierType,
          status: barrierStatus,
          expectedFunction: expectedFunctionController.text.trim(),
          investigationFinding: findingController.text.trim(),
          relatedThreat: threatController.text.trim(),
          relatedConsequence: consequenceController.text.trim(),
          supportingEvidenceIds: selectedEvidenceIds.toList()..sort(),
          escalationFactor: escalationFactorController.text.trim(),
        ),
      );

      threatController.clear();
      barrierTitleController.clear();
      expectedFunctionController.clear();
      escalationFactorController.clear();
      consequenceController.clear();
      findingController.clear();

      selectedEvidenceIds.clear();
      barrierType = BarrierType.preventive;
      barrierStatus = BarrierStatus.effective;
    });
  }

  void _saveAndReturn() {
    final draft = InvestigationDraftService.current;

    draft.hazard = hazardController.text.trim();
    draft.topEvent = topEventController.text.trim();

    Navigator.pop(context);
  }

  @override
  void dispose() {
    hazardController.dispose();
    topEventController.dispose();
    threatController.dispose();
    barrierTitleController.dispose();
    expectedFunctionController.dispose();
    escalationFactorController.dispose();
    consequenceController.dispose();
    findingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barriers = InvestigationDraftService.current.barriers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bow-Tie / Barrier Analysis'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Bow-Tie Analysis',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _field(hazardController, 'Hazard'),

          _field(topEventController, 'Top Event'),

          const Divider(height: 30),

          _field(threatController, 'Threat / Cause'),

          DropdownButtonFormField<BarrierType>(
            initialValue: barrierType,
            decoration: const InputDecoration(
              labelText: 'Barrier Type',
              border: OutlineInputBorder(),
            ),
            items: BarrierType.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(_label(value)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => barrierType = value);
              }
            },
          ),

          const SizedBox(height: 12),

          _field(barrierTitleController, 'Barrier'),

          _field(expectedFunctionController, 'Expected Function'),

          _field(
            escalationFactorController,
            'Barrier Weakness / Escalation Factor',
          ),

          DropdownButtonFormField<BarrierStatus>(
            initialValue: barrierStatus,
            decoration: const InputDecoration(
              labelText: 'Barrier Status',
              border: OutlineInputBorder(),
            ),
            items: BarrierStatus.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(_label(value)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => barrierStatus = value);
              }
            },
          ),

          const SizedBox(height: 12),

          _field(consequenceController, 'Related Consequence / Outcome'),

          _field(findingController, 'Investigation Finding'),

          OutlinedButton.icon(
            onPressed: _pickEvidence,
            icon: const Icon(Icons.link_outlined),
            label: Text(
              selectedEvidenceIds.isEmpty
                  ? 'Select Supporting Evidence'
                  : '${selectedEvidenceIds.length} Evidence Item(s) Selected',
            ),
          ),

          if (selectedEvidenceIds.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: selectedEvidenceIds
                  .map(
                    (id) => Chip(
                      label: Text(id),
                      onDeleted: () {
                        setState(() {
                          selectedEvidenceIds.remove(id);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ],

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: _addBarrier,
            icon: const Icon(Icons.add),
            label: const Text('Add Barrier Assessment'),
          ),

          const SizedBox(height: 20),

          ...barriers.map(
            (barrier) => Card(
              child: ListTile(
                leading: const Icon(Icons.security),
                title: Text('${barrier.barrierId} - ${barrier.title}'),
                subtitle: Text(
                  '${_label(barrier.barrierType)} | '
                  '${_label(barrier.status)}\n'
                  'Evidence: '
                  '${barrier.supportingEvidenceIds.isEmpty ? 'None linked' : barrier.supportingEvidenceIds.join(', ')}\n'
                  'Finding: ${barrier.investigationFinding}',
                ),
                isThreeLine: true,
              ),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: _saveAndReturn,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save & Return'),
          ),
        ],
      ),
    );
  }
}
