import 'investigation_action.dart';
import 'investigation_barrier.dart';
import 'investigation_case.dart';
import 'investigation_cause.dart';
import 'investigation_evidence.dart';
import 'investigation_finding.dart';
import 'investigation_human_factors.dart';
import 'investigation_immediate_response.dart';
import 'investigation_interview.dart';
import 'investigation_timeline_event.dart';

class InvestigationDraft {
  final InvestigationCase investigationCase;

  InvestigationImmediateResponse? immediateResponse;

  final List<InvestigationEvidence> evidence;
  final List<InvestigationTimelineEvent> timelineEvents;
  final List<InvestigationInterview> interviews;

  String problemStatement;

  String why1;
  String why2;
  String why3;
  String why4;
  String why5;

  final List<InvestigationCause> causes;

  String hazard;
  String topEvent;

  final List<InvestigationBarrier> barriers;

  InvestigationHumanFactors? humanFactors;

  final List<InvestigationFinding> findings;
  final List<InvestigationAction> actions;

  String executiveSummary;
  String conclusion;
  String lessonsLearned;

  String reviewedBy;
  String approvedBy;

  InvestigationDraft({
    required this.investigationCase,
    this.immediateResponse,
    List<InvestigationEvidence>? evidence,
    List<InvestigationTimelineEvent>? timelineEvents,
    List<InvestigationInterview>? interviews,
    this.problemStatement = '',
    this.why1 = '',
    this.why2 = '',
    this.why3 = '',
    this.why4 = '',
    this.why5 = '',
    List<InvestigationCause>? causes,
    this.hazard = '',
    this.topEvent = '',
    List<InvestigationBarrier>? barriers,
    this.humanFactors,
    List<InvestigationFinding>? findings,
    List<InvestigationAction>? actions,
    this.executiveSummary = '',
    this.conclusion = '',
    this.lessonsLearned = '',
    this.reviewedBy = '',
    this.approvedBy = '',
  }) : evidence = evidence ?? [],
       timelineEvents = timelineEvents ?? [],
       interviews = interviews ?? [],
       causes = causes ?? [],
       barriers = barriers ?? [],
       findings = findings ?? [],
       actions = actions ?? [];
}
