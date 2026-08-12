import 'package:flutter/material.dart';

import '../models/investigation_finding.dart';
import '../services/investigation_draft_service.dart';

class InvestigationFinalReviewPage extends StatefulWidget {
  const InvestigationFinalReviewPage({super.key});

  @override
  State<InvestigationFinalReviewPage> createState() =>
      _InvestigationFinalReviewPageState();
}

class _InvestigationFinalReviewPageState
    extends State<InvestigationFinalReviewPage> {
  final findingController = TextEditingController();
  final confidenceBasisController = TextEditingController();
  final outstandingVerificationController = TextEditingController();

  final executiveSummaryController = TextEditingController();
  final conclusionController = TextEditingController();
  final lessonsLearnedController = TextEditingController();
  final reviewedByController = TextEditingController();
  final approvedByController = TextEditingController();

  final Set<String> selectedEvidenceIds = {};

  String selectedCauseId = '';
  String selectedBarrierId = '';

  InvestigationFindingStatus findingStatus =
      InvestigationFindingStatus.confirmed;

  @override
  void initState() {
    super.initState();

    final draft = InvestigationDraftService.current;

    executiveSummaryController.text = draft.executiveSummary;
    conclusionController.text = draft.conclusion;
    lessonsLearnedController.text = draft.lessonsLearned;
    reviewedByController.text = draft.reviewedBy;
    approvedByController.text = draft.approvedBy;
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
    int maxLines = 3,
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

  void _addFinding() {
    if (findingController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Finding statement is required.')),
      );
      return;
    }

    final findings = InvestigationDraftService.current.findings;

    setState(() {
      findings.add(
        InvestigationFinding(
          findingId: 'F-${(findings.length + 1).toString().padLeft(3, '0')}',
          findingStatement: findingController.text.trim(),
          supportingEvidenceIds: selectedEvidenceIds.toList()..sort(),
          linkedCauseId: selectedCauseId,
          linkedBarrierId: selectedBarrierId,
          status: findingStatus,
          confidenceBasis: confidenceBasisController.text.trim(),
          outstandingVerification: outstandingVerificationController.text
              .trim(),
        ),
      );

      findingController.clear();
      confidenceBasisController.clear();
      outstandingVerificationController.clear();
      selectedEvidenceIds.clear();
      selectedCauseId = '';
      selectedBarrierId = '';
      findingStatus = InvestigationFindingStatus.confirmed;
    });
  }

  void _deleteFinding(int index) {
    setState(() {
      InvestigationDraftService.current.findings.removeAt(index);
    });
  }

  void _save() {
    final draft = InvestigationDraftService.current;

    draft.executiveSummary = executiveSummaryController.text.trim();

    draft.conclusion = conclusionController.text.trim();

    draft.lessonsLearned = lessonsLearnedController.text.trim();

    draft.reviewedBy = reviewedByController.text.trim();

    draft.approvedBy = approvedByController.text.trim();

    Navigator.pop(context);
  }

  @override
  void dispose() {
    findingController.dispose();
    confidenceBasisController.dispose();
    outstandingVerificationController.dispose();
    executiveSummaryController.dispose();
    conclusionController.dispose();
    lessonsLearnedController.dispose();
    reviewedByController.dispose();
    approvedByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = InvestigationDraftService.current;
    final findings = draft.findings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Findings & Final Review'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Formal Investigation Findings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _field(findingController, 'Finding Statement'),

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

          DropdownButtonFormField<InvestigationFindingStatus>(
            initialValue: findingStatus,
            decoration: const InputDecoration(
              labelText: 'Finding Status',
              border: OutlineInputBorder(),
            ),
            items: InvestigationFindingStatus.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(_label(value)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  findingStatus = value;
                });
              }
            },
          ),

          const SizedBox(height: 12),

          _field(confidenceBasisController, 'Confidence / Evidence Basis'),

          _field(outstandingVerificationController, 'Outstanding Verification'),

          const Text(
            'Leave Outstanding Verification blank when all required verification has been completed.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: _addFinding,
            icon: const Icon(Icons.add),
            label: const Text('Add Finding'),
          ),

          const SizedBox(height: 16),

          ...List.generate(findings.length, (index) {
            final finding = findings[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.fact_check_outlined),
                      title: Text(
                        '${finding.findingId} - '
                        '${_label(finding.status)}',
                      ),
                      subtitle: Text(
                        '${finding.findingStatement}\n'
                        'Evidence: '
                        '${finding.supportingEvidenceIds.isEmpty ? 'None linked' : finding.supportingEvidenceIds.join(', ')}\n'
                        'Cause: '
                        '${finding.linkedCauseId.isEmpty ? 'Not linked' : finding.linkedCauseId} | '
                        'Barrier: '
                        '${finding.linkedBarrierId.isEmpty ? 'Not linked' : finding.linkedBarrierId}\n'
                        'Outstanding: '
                        '${finding.outstandingVerification.isEmpty ? 'None' : finding.outstandingVerification}',
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _deleteFinding(index),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete Finding'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const Divider(height: 36),

          const Text(
            'Executive Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _field(executiveSummaryController, 'Executive Summary', maxLines: 7),

          const Text(
            'Conclusion',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _field(conclusionController, 'Investigation Conclusion', maxLines: 6),

          const Text(
            'Lessons Learned',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _field(
            lessonsLearnedController,
            'Lessons Learned / Organisational Learning',
            maxLines: 6,
          ),

          const Divider(height: 36),

          const Text(
            'Review & Approval',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _field(reviewedByController, 'Reviewed By / HSE Manager'),

          _field(approvedByController, 'Approved By / Operations Manager'),

          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Final Review'),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
