import '../models/investigation_action.dart';
import '../models/investigation_case.dart';
import '../models/investigation_cause.dart';
import '../models/investigation_draft.dart';
import '../models/investigation_finding.dart';

class InvestigationReadinessResult {
  final int completedStages;
  final int totalStages;
  final List<String> blockingIssues;

  const InvestigationReadinessResult({
    required this.completedStages,
    required this.totalStages,
    required this.blockingIssues,
  });

  bool get isReady => blockingIssues.isEmpty;
}

class InvestigationCloseoutResult {
  final List<String> blockingIssues;

  const InvestigationCloseoutResult({required this.blockingIssues});

  bool get isReady => blockingIssues.isEmpty;
}

class InvestigationReadinessService {
  static const int totalStages = 9;

  static bool isStageComplete(InvestigationDraft draft, int stage) {
    switch (stage) {
      case 1:
        return draft.immediateResponse != null;
      case 2:
        return draft.evidence.isNotEmpty;
      case 3:
        return draft.timelineEvents.isNotEmpty;
      case 4:
        return draft.interviews.isNotEmpty;
      case 5:
        return draft.problemStatement.trim().isNotEmpty &&
            draft.causes.any(
              (cause) => cause.causeType == InvestigationCauseType.rootCause,
            );
      case 6:
        return draft.hazard.trim().isNotEmpty &&
            draft.topEvent.trim().isNotEmpty &&
            draft.barriers.isNotEmpty;
      case 7:
        return draft.humanFactors != null;
      case 8:
        return draft.actions.isNotEmpty;
      case 9:
        return draft.findings.isNotEmpty &&
            draft.executiveSummary.trim().isNotEmpty &&
            draft.conclusion.trim().isNotEmpty &&
            draft.lessonsLearned.trim().isNotEmpty &&
            draft.reviewedBy.trim().isNotEmpty &&
            draft.approvedBy.trim().isNotEmpty;
      default:
        return false;
    }
  }

  static InvestigationReadinessResult evaluate(InvestigationDraft draft) {
    final issues = <String>[];

    if (draft.immediateResponse == null) {
      issues.add(
        'Stage 1: Complete the Immediate Response & Scene Control section.',
      );
    }

    if (draft.evidence.isEmpty) {
      issues.add('Stage 2: Add at least one item to the Evidence Register.');
    }

    if (draft.timelineEvents.isEmpty) {
      issues.add(
        'Stage 3: Add at least one verified chronology / timeline event.',
      );
    }

    final level = draft.investigationCase.investigationLevel;

    if ((level == InvestigationLevel.level2Formal ||
            level == InvestigationLevel.level3MajorHighPotential) &&
        draft.interviews.isEmpty) {
      issues.add(
        'Stage 4: Add at least one witness or relevant-person interview.',
      );
    }

    if (draft.problemStatement.trim().isEmpty) {
      issues.add('Stage 5: Record the investigation problem / top event.');
    }

    if (!draft.causes.any(
      (cause) => cause.causeType == InvestigationCauseType.rootCause,
    )) {
      issues.add('Stage 5: Identify at least one root / organisational cause.');
    }

    if (level == InvestigationLevel.level2Formal ||
        level == InvestigationLevel.level3MajorHighPotential) {
      if (draft.hazard.trim().isEmpty ||
          draft.topEvent.trim().isEmpty ||
          draft.barriers.isEmpty) {
        issues.add('Stage 6: Complete Bow-Tie / Barrier Analysis.');
      }

      if (draft.humanFactors == null) {
        issues.add(
          'Stage 7: Complete the Human & Organisational Factors assessment.',
        );
      }
    }

    if (draft.actions.isEmpty) {
      issues.add(
        'Stage 8: Record at least one corrective or preventive action.',
      );
    }

    if (draft.findings.isEmpty) {
      issues.add('Stage 9: Record at least one formal investigation finding.');
    }

    if (draft.findings.any(
      (finding) =>
          finding.status == InvestigationFindingStatus.pendingVerification,
    )) {
      issues.add(
        'Stage 9: Resolve findings that are still Pending Verification.',
      );
    }

    if (draft.findings.any(
      (finding) => finding.outstandingVerification.trim().isNotEmpty,
    )) {
      issues.add(
        'Stage 9: Clear all Outstanding Verification items before final issue.',
      );
    }

    if (draft.executiveSummary.trim().isEmpty) {
      issues.add('Stage 9: Complete the Executive Summary.');
    }

    if (draft.conclusion.trim().isEmpty) {
      issues.add('Stage 9: Complete the Investigation Conclusion.');
    }

    if (draft.lessonsLearned.trim().isEmpty) {
      issues.add(
        'Stage 9: Complete Lessons Learned / Organisational Learning.',
      );
    }

    if (draft.reviewedBy.trim().isEmpty) {
      issues.add('Stage 9: Enter the reviewer / HSE Manager.');
    }

    if (draft.approvedBy.trim().isEmpty) {
      issues.add('Stage 9: Enter the approving manager.');
    }

    issues.addAll(_referenceIntegrityIssues(draft));

    final completedStages = List<int>.generate(
      totalStages,
      (index) => index + 1,
    ).where((stage) => isStageComplete(draft, stage)).length;

    return InvestigationReadinessResult(
      completedStages: completedStages,
      totalStages: totalStages,
      blockingIssues: issues,
    );
  }

  static InvestigationCloseoutResult evaluateCloseout(
    InvestigationDraft draft,
  ) {
    final issues = <String>[];
    final finalReadiness = evaluate(draft);

    if (!finalReadiness.isReady) {
      issues.add('The Final Report Readiness Check must pass before closeout.');
    }

    for (final action in draft.actions) {
      if (action.status != InvestigationActionStatus.closed) {
        issues.add('${action.actionId}: Action status must be Closed.');
      }

      if (action.actualClosureDate == null) {
        issues.add('${action.actionId}: Actual closure date is required.');
      }

      if (action.effectivenessReviewDate == null) {
        issues.add(
          '${action.actionId}: Effectiveness review date is required.',
        );
      }

      if (action.closureComments.trim().isEmpty) {
        issues.add(
          '${action.actionId}: Closure comments / verification result are required.',
        );
      }

      if (action.requiredClosureEvidence.trim().isEmpty) {
        issues.add(
          '${action.actionId}: Required closure evidence must be defined.',
        );
      }

      if (action.verifier.trim().isEmpty) {
        issues.add(
          '${action.actionId}: An independent verifier must be identified.',
        );
      }

      if (action.effectivenessCriteria.trim().isEmpty) {
        issues.add(
          '${action.actionId}: Effectiveness criteria must be defined.',
        );
      }
    }

    return InvestigationCloseoutResult(blockingIssues: issues);
  }

  static List<String> _referenceIntegrityIssues(InvestigationDraft draft) {
    final issues = <String>[];

    final evidenceIds = draft.evidence
        .map((item) => item.evidenceId.trim())
        .where((id) => id.isNotEmpty)
        .toSet();

    final causeIds = draft.causes
        .map((item) => item.causeId.trim())
        .where((id) => id.isNotEmpty)
        .toSet();

    final barrierIds = draft.barriers
        .map((item) => item.barrierId.trim())
        .where((id) => id.isNotEmpty)
        .toSet();

    void checkEvidenceIds(Iterable<String> ids, String owner) {
      for (final rawId in ids) {
        final id = rawId.trim();

        if (id.isNotEmpty && !evidenceIds.contains(id)) {
          issues.add('$owner references missing evidence ID $id.');
        }
      }
    }

    for (final event in draft.timelineEvents) {
      checkEvidenceIds(event.evidenceIds, 'Timeline ${event.eventId}');
    }

    for (final cause in draft.causes) {
      checkEvidenceIds(cause.supportingEvidenceIds, 'Cause ${cause.causeId}');

      final barrierId = cause.relatedBarrierId.trim();

      if (barrierId.isNotEmpty && !barrierIds.contains(barrierId)) {
        issues.add(
          'Cause ${cause.causeId} references missing barrier ID $barrierId.',
        );
      }
    }

    for (final barrier in draft.barriers) {
      checkEvidenceIds(
        barrier.supportingEvidenceIds,
        'Barrier ${barrier.barrierId}',
      );
    }

    for (final finding in draft.findings) {
      checkEvidenceIds(
        finding.supportingEvidenceIds,
        'Finding ${finding.findingId}',
      );

      final causeId = finding.linkedCauseId.trim();
      final barrierId = finding.linkedBarrierId.trim();

      if (causeId.isNotEmpty && !causeIds.contains(causeId)) {
        issues.add(
          'Finding ${finding.findingId} references missing cause ID $causeId.',
        );
      }

      if (barrierId.isNotEmpty && !barrierIds.contains(barrierId)) {
        issues.add(
          'Finding ${finding.findingId} references missing barrier ID $barrierId.',
        );
      }
    }

    for (final action in draft.actions) {
      final causeId = action.linkedCauseId.trim();
      final barrierId = action.linkedBarrierId.trim();

      if (causeId.isNotEmpty && !causeIds.contains(causeId)) {
        issues.add(
          'Action ${action.actionId} references missing cause ID $causeId.',
        );
      }

      if (barrierId.isNotEmpty && !barrierIds.contains(barrierId)) {
        issues.add(
          'Action ${action.actionId} references missing barrier ID $barrierId.',
        );
      }
    }

    return issues;
  }
}
