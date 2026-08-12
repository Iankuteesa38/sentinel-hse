import 'package:flutter/material.dart';

import '../models/investigation_case.dart';
import '../services/investigation_draft_service.dart';
import '../services/investigation_history_service.dart';
import '../services/investigation_readiness_service.dart';

import 'investigation_actions_page.dart';
import 'investigation_barrier_analysis_page.dart';
import 'investigation_causal_analysis_page.dart';
import 'investigation_evidence_page.dart';
import 'investigation_final_review_page.dart';
import 'investigation_human_factors_page.dart';
import 'investigation_immediate_response_page.dart';
import 'investigation_interviews_page.dart';
import 'investigation_pdf_preview_page.dart';
import 'investigation_timeline_page.dart';

class InvestigationCaseSummaryPage extends StatefulWidget {
  final InvestigationCase investigation;

  const InvestigationCaseSummaryPage({super.key, required this.investigation});

  @override
  State<InvestigationCaseSummaryPage> createState() =>
      _InvestigationCaseSummaryPageState();
}

class _InvestigationCaseSummaryPageState
    extends State<InvestigationCaseSummaryPage> {
  InvestigationCase get investigation => widget.investigation;

  String _label(Object value) {
    final raw = value.toString().split('.').last;

    switch (raw) {
      case 'level1Basic':
        return 'Level 1 - Basic Investigation';
      case 'level2Formal':
        return 'Level 2 - Formal Investigation';
      case 'level3MajorHighPotential':
        return 'Level 3 - Major / High Potential';
      case 'finalReport':
        return 'Final';
      case 'motorVehicle':
        return 'Motor Vehicle';
      case 'nearMiss':
        return 'Near Miss';
      case 'propertyDamage':
        return 'Property Damage';
      case 'fireExplosion':
        return 'Fire / Explosion';
      case 'liftingHoisting':
        return 'Lifting & Hoisting';
      case 'equipmentFailure':
        return 'Equipment Failure';
      case 'occupationalHealth':
        return 'Occupational Health';
      default:
        return raw
            .replaceAllMapped(
              RegExp(r'([a-z])([A-Z])'),
              (match) => '${match.group(1)} ${match.group(2)}',
            )
            .replaceAllMapped(
              RegExp(r'^.'),
              (match) => match.group(0)!.toUpperCase(),
            );
    }
  }

  String _formatDateTime(DateTime value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');

    return '${twoDigits(value.day)}/'
        '${twoDigits(value.month)}/'
        '${value.year} '
        '${twoDigits(value.hour)}:'
        '${twoDigits(value.minute)}';
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 135,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _openPage(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Widget _workflowCard({
    required int stage,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    final complete = InvestigationReadinessService.isStageComplete(
      InvestigationDraftService.current,
      stage,
    );

    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: complete
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                complete ? 'Complete' : 'Pending',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: complete
                      ? Colors.green.shade800
                      : Colors.orange.shade900,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => _openPage(page),
      ),
    );
  }

  Future<void> _showIssues({
    required String title,
    required String summary,
    required List<String> issues,
  }) async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(summary),
                  const SizedBox(height: 12),
                  ...issues.map(
                    (issue) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.error_outline, size: 17),
                          const SizedBox(width: 7),
                          Expanded(child: Text(issue)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showReadiness() async {
    final result = InvestigationReadinessService.evaluate(
      InvestigationDraftService.current,
    );

    if (result.isReady) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.verified_outlined, color: Colors.green),
                SizedBox(width: 8),
                Expanded(child: Text('Final Report Ready')),
              ],
            ),
            content: Text(
              '${result.completedStages} of '
              '${result.totalStages} workflow stages complete.\n\n'
              'No blocking issues were identified. '
              'The investigation may now be issued as a Final Report.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    await _showIssues(
      title: 'Final Report Readiness',
      summary:
          '${result.completedStages} of '
          '${result.totalStages} workflow stages complete. '
          'Resolve the following items before final issue:',
      issues: result.blockingIssues,
    );
  }

  Future<void> _manageStatus() async {
    final selected = await showModalBottomSheet<InvestigationReportStatus>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(
                title: Text(
                  'Report Status',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(
                  'Final and Closed statuses are controlled by readiness checks.',
                ),
              ),
              ...InvestigationReportStatus.values.map(
                (status) => ListTile(
                  leading: Icon(
                    status == investigation.reportStatus
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                  ),
                  title: Text(_label(status)),
                  trailing: status == InvestigationReportStatus.finalReport
                      ? const Icon(Icons.verified_outlined)
                      : status == InvestigationReportStatus.closed
                      ? const Icon(Icons.lock_outline)
                      : null,
                  onTap: () => Navigator.pop(sheetContext, status),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      await _changeStatus(selected);
    }
  }

  Future<void> _changeStatus(InvestigationReportStatus target) async {
    final draft = InvestigationDraftService.current;

    if (draft.investigationCase.reportStatus ==
            InvestigationReportStatus.closed &&
        target != InvestigationReportStatus.closed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This investigation is Closed. Reopening control can be added separately if required.',
          ),
        ),
      );
      return;
    }

    if (target == InvestigationReportStatus.finalReport) {
      final readiness = InvestigationReadinessService.evaluate(draft);

      if (!readiness.isReady) {
        await _showIssues(
          title: 'Cannot Issue Final Report',
          summary: 'The investigation still has blocking items:',
          issues: readiness.blockingIssues,
        );
        return;
      }
    }

    if (target == InvestigationReportStatus.closed) {
      if (draft.investigationCase.reportStatus !=
          InvestigationReportStatus.finalReport) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Issue the investigation as Final before closing it.',
            ),
          ),
        );
        return;
      }

      final closeout = InvestigationReadinessService.evaluateCloseout(draft);

      if (!closeout.isReady) {
        await _showIssues(
          title: 'Cannot Close Investigation',
          summary:
              'Complete CAPA closure and effectiveness verification first:',
          issues: closeout.blockingIssues,
        );
        return;
      }
    }

    draft.investigationCase.reportStatus = target;

    await InvestigationHistoryService.saveDraft(draft);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report status changed to ${_label(target)}.')),
    );
  }

  Future<void> _saveInvestigation() async {
    await InvestigationHistoryService.saveDraft(
      InvestigationDraftService.current,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Investigation saved successfully.')),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final readiness = InvestigationReadinessService.evaluate(
      InvestigationDraftService.current,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigation Case'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      investigation.incidentTitle,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _detail('Reference', investigation.investigationReference),
                    _detail('Status', _label(investigation.reportStatus)),
                    _detail('Level', _label(investigation.investigationLevel)),
                    _detail('Category', _label(investigation.incidentCategory)),
                    _detail(
                      'Actual severity',
                      _label(investigation.actualSeverity),
                    ),
                    _detail(
                      'Potential severity',
                      _label(investigation.potentialSeverity),
                    ),
                    _detail(
                      'High potential',
                      investigation.highPotential ? 'Yes' : 'No',
                    ),
                    _detail(
                      'Incident date',
                      _formatDateTime(investigation.incidentDateTime),
                    ),
                    _detail(
                      'Reported date',
                      _formatDateTime(investigation.reportedDateTime),
                    ),
                    _detail('Location', investigation.location),
                    _detail('Project', investigation.project),
                    _detail('Company', investigation.company),
                    if (investigation.contractor.isNotEmpty)
                      _detail('Contractor', investigation.contractor),
                    _detail('Prepared by', investigation.preparedBy),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _manageStatus,
                        icon: const Icon(Icons.published_with_changes),
                        label: const Text('Manage Report Status'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Investigation Workflow',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: readiness.isReady
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.orange.withValues(alpha: 0.12),
                  ),
                  child: Text(
                    '${readiness.completedStages}/'
                    '${readiness.totalStages}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: readiness.isReady
                          ? Colors.green.shade800
                          : Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _workflowCard(
              stage: 1,
              icon: Icons.emergency_outlined,
              title: '1. Immediate Response',
              subtitle:
                  'Emergency response, scene control, notifications and temporary controls',
              page: const InvestigationImmediateResponsePage(),
            ),

            _workflowCard(
              stage: 2,
              icon: Icons.folder_copy_outlined,
              title: '2. Evidence Register',
              subtitle:
                  'Statements, photographs, reports, telematics and other evidence',
              page: const InvestigationEvidencePage(),
            ),

            _workflowCard(
              stage: 3,
              icon: Icons.timeline,
              title: '3. Chronology / Timeline',
              subtitle:
                  'Build the verified sequence of events and evidence sources',
              page: const InvestigationTimelinePage(),
            ),

            _workflowCard(
              stage: 4,
              icon: Icons.record_voice_over_outlined,
              title: '4. Witness Interviews',
              subtitle:
                  'Capture statements, observations and interview evidence',
              page: const InvestigationInterviewsPage(),
            ),

            _workflowCard(
              stage: 5,
              icon: Icons.account_tree_outlined,
              title: '5. Causal Analysis / 5-Why',
              subtitle: 'Immediate, contributing, underlying and root causes',
              page: const InvestigationCausalAnalysisPage(),
            ),

            _workflowCard(
              stage: 6,
              icon: Icons.security_outlined,
              title: '6. Bow-Tie / Barrier Analysis',
              subtitle:
                  'Threats, preventive barriers, escalation factors, mitigation barriers and consequences',
              page: const InvestigationBarrierAnalysisPage(),
            ),

            _workflowCard(
              stage: 7,
              icon: Icons.psychology_outlined,
              title: '7. Human & Organisational Factors',
              subtitle:
                  'Fatigue, competence, supervision, procedures, culture and management systems',
              page: const InvestigationHumanFactorsPage(),
            ),

            _workflowCard(
              stage: 8,
              icon: Icons.task_alt,
              title: '8. Corrective Actions',
              subtitle:
                  'Cause-linked actions, closure evidence and effectiveness verification',
              page: const InvestigationActionsPage(),
            ),

            _workflowCard(
              stage: 9,
              icon: Icons.fact_check_outlined,
              title: '9. Findings & Final Review',
              subtitle:
                  'Formal findings, executive summary, conclusions, lessons learned and management approval',
              page: const InvestigationFinalReviewPage(),
            ),

            const SizedBox(height: 18),

            OutlinedButton.icon(
              onPressed: _showReadiness,
              icon: const Icon(Icons.fact_check_outlined),
              label: Text(
                readiness.isReady
                    ? 'Final Report Ready'
                    : 'Check Final Report Readiness',
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: _saveInvestigation,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Investigation'),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvestigationPdfPreviewPage(
                      draft: InvestigationDraftService.current,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Preview / Export Investigation PDF'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
