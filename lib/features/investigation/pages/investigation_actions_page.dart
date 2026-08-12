import 'package:flutter/material.dart';

import '../models/investigation_action.dart';
import '../services/investigation_draft_service.dart';

class InvestigationActionsPage extends StatefulWidget {
  const InvestigationActionsPage({super.key});

  @override
  State<InvestigationActionsPage> createState() =>
      _InvestigationActionsPageState();
}

class _InvestigationActionsPageState extends State<InvestigationActionsPage> {
  final actionController = TextEditingController();
  final ownerController = TextEditingController();
  final closureEvidenceController = TextEditingController();
  final verifierController = TextEditingController();
  final effectivenessController = TextEditingController();

  InvestigationActionType actionType = InvestigationActionType.correctiveAction;

  InvestigationActionStatus status = InvestigationActionStatus.open;

  String selectedCauseId = '';
  String selectedBarrierId = '';

  DateTime targetDate = DateTime.now().add(const Duration(days: 7));

  String _label(Object value) {
    final raw = value.toString().split('.').last;

    return raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
  }

  String _date(DateTime? value) {
    if (value == null) {
      return 'Not set';
    }

    return '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/'
        '${value.year}';
  }

  Future<void> _selectTargetDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (selected != null) {
      setState(() {
        targetDate = selected;
      });
    }
  }

  void _addAction() {
    if (actionController.text.trim().isEmpty ||
        ownerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Action description and responsible person are required.',
          ),
        ),
      );
      return;
    }

    final actions = InvestigationDraftService.current.actions;

    setState(() {
      actions.add(
        InvestigationAction(
          actionId: 'ACT-${(actions.length + 1).toString().padLeft(3, '0')}',
          linkedCauseId: selectedCauseId,
          linkedBarrierId: selectedBarrierId,
          actionType: actionType,
          action: actionController.text.trim(),
          responsiblePerson: ownerController.text.trim(),
          targetDate: targetDate,
          requiredClosureEvidence: closureEvidenceController.text.trim(),
          verifier: verifierController.text.trim(),
          effectivenessCriteria: effectivenessController.text.trim(),
          status: status,
        ),
      );

      actionController.clear();
      ownerController.clear();
      closureEvidenceController.clear();
      verifierController.clear();
      effectivenessController.clear();

      selectedCauseId = '';
      selectedBarrierId = '';

      actionType = InvestigationActionType.correctiveAction;
      status = InvestigationActionStatus.open;

      targetDate = DateTime.now().add(const Duration(days: 7));
    });
  }

  Future<void> _manageAction(int index) async {
    final actions = InvestigationDraftService.current.actions;

    final action = actions[index];

    var selectedStatus = action.status;
    var effectivenessReviewDate = action.effectivenessReviewDate;
    var actualClosureDate = action.actualClosureDate;

    final closureCommentsController = TextEditingController(
      text: action.closureComments,
    );

    final updated = await showDialog<InvestigationAction>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickEffectivenessDate() async {
              final selected = await showDatePicker(
                context: context,
                initialDate: effectivenessReviewDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );

              if (selected != null) {
                setDialogState(() {
                  effectivenessReviewDate = selected;
                });
              }
            }

            Future<void> pickClosureDate() async {
              final selected = await showDatePicker(
                context: context,
                initialDate: actualClosureDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );

              if (selected != null) {
                setDialogState(() {
                  actualClosureDate = selected;
                });
              }
            }

            return AlertDialog(
              title: Text('Manage ${action.actionId}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.action,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<InvestigationActionStatus>(
                      initialValue: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Action Status',
                        border: OutlineInputBorder(),
                      ),
                      items: InvestigationActionStatus.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(_label(value)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedStatus = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Effectiveness Review Date'),
                      subtitle: Text(_date(effectivenessReviewDate)),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: pickEffectivenessDate,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Actual Closure Date'),
                      subtitle: Text(_date(actualClosureDate)),
                      trailing: const Icon(Icons.event_available),
                      onTap: pickClosureDate,
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: closureCommentsController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Closure Comments / Verification Result',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Required closure evidence: '
                      '${action.requiredClosureEvidence.isEmpty ? 'Not defined' : action.requiredClosureEvidence}',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Verifier: '
                      '${action.verifier.isEmpty ? 'Not defined' : action.verifier}',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Effectiveness criteria: '
                      '${action.effectivenessCriteria.isEmpty ? 'Not defined' : action.effectivenessCriteria}',
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (selectedStatus == InvestigationActionStatus.closed) {
                      if (effectivenessReviewDate == null ||
                          actualClosureDate == null ||
                          closureCommentsController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'To close an action, add effectiveness review date, actual closure date and closure comments.',
                            ),
                          ),
                        );
                        return;
                      }
                    }

                    Navigator.pop(
                      dialogContext,
                      InvestigationAction(
                        actionId: action.actionId,
                        linkedCauseId: action.linkedCauseId,
                        linkedBarrierId: action.linkedBarrierId,
                        actionType: action.actionType,
                        action: action.action,
                        responsiblePerson: action.responsiblePerson,
                        targetDate: action.targetDate,
                        requiredClosureEvidence: action.requiredClosureEvidence,
                        verifier: action.verifier,
                        effectivenessCriteria: action.effectivenessCriteria,
                        effectivenessReviewDate: effectivenessReviewDate,
                        status: selectedStatus,
                        actualClosureDate: actualClosureDate,
                        closureComments: closureCommentsController.text.trim(),
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || updated == null) {
      return;
    }

    final savedAction = updated;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      setState(() {
        actions[index] = savedAction;
      });
    });
  }

  void _deleteAction(int index) {
    setState(() {
      InvestigationDraftService.current.actions.removeAt(index);
    });
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

  @override
  void dispose() {
    actionController.dispose();
    ownerController.dispose();
    closureEvidenceController.dispose();
    verifierController.dispose();
    effectivenessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = InvestigationDraftService.current;
    final actions = draft.actions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Corrective Actions'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedCauseId,
            decoration: const InputDecoration(
              labelText: 'Linked Cause',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: '', child: Text('Not linked')),
              ...draft.causes.map(
                (cause) => DropdownMenuItem(
                  value: cause.causeId,
                  child: Text('${cause.causeId} - ${_label(cause.causeType)}'),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedCauseId = value ?? '';
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: selectedBarrierId,
            decoration: const InputDecoration(
              labelText: 'Linked Barrier',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: '', child: Text('Not linked')),
              ...draft.barriers.map(
                (barrier) => DropdownMenuItem(
                  value: barrier.barrierId,
                  child: Text('${barrier.barrierId} - ${barrier.title}'),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedBarrierId = value ?? '';
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<InvestigationActionType>(
            initialValue: actionType,
            decoration: const InputDecoration(
              labelText: 'Action Type',
              border: OutlineInputBorder(),
            ),
            items: InvestigationActionType.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(_label(value)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => actionType = value);
              }
            },
          ),

          const SizedBox(height: 12),

          _field(actionController, 'Corrective / Preventive Action'),

          _field(ownerController, 'Responsible Person / Action Owner'),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Target Date'),
            subtitle: Text(_date(targetDate)),
            trailing: const Icon(Icons.calendar_month),
            onTap: _selectTargetDate,
          ),

          _field(closureEvidenceController, 'Required Closure Evidence'),

          _field(verifierController, 'Independent Verifier'),

          _field(effectivenessController, 'Effectiveness Criteria'),

          ElevatedButton.icon(
            onPressed: _addAction,
            icon: const Icon(Icons.add_task),
            label: const Text('Add Action'),
          ),

          const SizedBox(height: 20),

          ...List.generate(actions.length, (index) {
            final action = actions[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.assignment_turned_in),
                      title: Text(
                        '${action.actionId} - '
                        '${_label(action.actionType)}',
                      ),
                      subtitle: Text(
                        '${action.action}\n'
                        'Owner: ${action.responsiblePerson}\n'
                        'Status: ${_label(action.status)}\n'
                        'Cause: ${action.linkedCauseId.isEmpty ? 'Not linked' : action.linkedCauseId} | '
                        'Barrier: ${action.linkedBarrierId.isEmpty ? 'Not linked' : action.linkedBarrierId}',
                      ),
                      isThreeLine: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _manageAction(index),
                          icon: const Icon(Icons.fact_check_outlined),
                          label: const Text('Manage / Close'),
                        ),
                        TextButton.icon(
                          onPressed: () => _deleteAction(index),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
