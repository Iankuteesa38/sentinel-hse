import 'dart:convert';
import 'dart:io';
import '../../cloud_sync/services/evidence_cloud_service.dart';
import 'package:path_provider/path_provider.dart';
import '../../cloud_sync/services/operational_report_cloud_service.dart';
import '../models/investigation_action.dart';
import '../models/investigation_barrier.dart';
import '../models/investigation_case.dart';
import '../models/investigation_cause.dart';
import '../models/investigation_draft.dart';
import '../models/investigation_evidence.dart';
import '../models/investigation_finding.dart';
import '../models/investigation_human_factors.dart';
import '../models/investigation_immediate_response.dart';
import '../models/investigation_interview.dart';
import '../models/investigation_timeline_event.dart';

class InvestigationHistoryService {
  static const String _fileName = 'sentinel_investigation_history.json';

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/$_fileName');
  }

  static Future<void> saveDraft(InvestigationDraft draft) async {
    final drafts = await loadDrafts();

    drafts.removeWhere(
      (item) =>
          item.investigationCase.investigationReference ==
          draft.investigationCase.investigationReference,
    );

    drafts.insert(0, draft);

    final file = await _getFile();

    await file.writeAsString(
      jsonEncode(drafts.map(_draftToJson).toList()),
      flush: true,
    );
    try {
      final cloudDraftJson = _draftToJson(draft);

      final cloudEvidence = <Map<String, dynamic>>[];

      for (final evidence in draft.evidence) {
        String? cloudPath;

        if (evidence.filePath.trim().isNotEmpty) {
          final file = File(evidence.filePath);

          if (await file.exists()) {
            cloudPath = await EvidenceCloudService.uploadFile(
              file: file,
              module: 'investigation',
              recordId: draft.investigationCase.investigationReference,
              fileName: file.uri.pathSegments.last,
            );
          }
        }

        cloudEvidence.add({
          'evidenceId': evidence.evidenceId,
          'title': evidence.title,
          'type': evidence.type.name,
          'status': evidence.status.name,
          'source': evidence.source,
          'obtainedAt': evidence.obtainedAt.toIso8601String(),
          'obtainedBy': evidence.obtainedBy,
          'storageLocation': evidence.storageLocation,
          'integrityVerified': evidence.integrityVerified,
          'description': evidence.description,
          'relevance': evidence.relevance,
          'filePath': evidence.filePath,
          'cloudPath': cloudPath,
        });
      }

      cloudDraftJson['evidence'] = cloudEvidence;
      await OperationalReportCloudService.syncReport(
        moduleType: 'investigation',
        localId: draft.investigationCase.investigationReference,
        title: draft.investigationCase.incidentTitle,
        reportData: cloudDraftJson,
        createdAt: draft.investigationCase.reportedDateTime,
      );
    } catch (_) {
      // Local investigation save remains available offline.
    }
  }

  static Future<List<InvestigationDraft>> loadDrafts() async {
    try {
      final file = await _getFile();

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();

      if (contents.trim().isEmpty) {
        return [];
      }

      final decoded = jsonDecode(contents);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map((item) => _draftFromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> deleteDraft(String investigationReference) async {
    final drafts = await loadDrafts();

    drafts.removeWhere(
      (item) =>
          item.investigationCase.investigationReference ==
          investigationReference,
    );

    final file = await _getFile();

    await file.writeAsString(
      jsonEncode(drafts.map(_draftToJson).toList()),
      flush: true,
    );
  }

  static T _enumValue<T extends Enum>(List<T> values, dynamic raw, T fallback) {
    final name = raw?.toString() ?? '';

    return values.firstWhere(
      (value) => value.name == name,
      orElse: () => fallback,
    );
  }

  static DateTime _date(dynamic value) {
    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }

  static DateTime? _dateOrNull(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString());
  }

  static Map<String, dynamic> _draftToJson(InvestigationDraft draft) {
    final incident = draft.investigationCase;

    return {
      'investigationCase': {
        'investigationReference': incident.investigationReference,
        'incidentTitle': incident.incidentTitle,
        'reportStatus': incident.reportStatus.name,
        'investigationLevel': incident.investigationLevel.name,
        'incidentCategory': incident.incidentCategory.name,
        'actualSeverity': incident.actualSeverity.name,
        'potentialSeverity': incident.potentialSeverity.name,
        'highPotential': incident.highPotential,
        'incidentDateTime': incident.incidentDateTime.toIso8601String(),
        'reportedDateTime': incident.reportedDateTime.toIso8601String(),
        'location': incident.location,
        'project': incident.project,
        'company': incident.company,
        'contractor': incident.contractor,
        'preparedBy': incident.preparedBy,
        'reviewedBy': incident.reviewedBy,
        'approvedBy': incident.approvedBy,
        'revisionNumber': incident.revisionNumber,
        'confidentialityClassification': incident.confidentialityClassification,
      },

      'immediateResponse': draft.immediateResponse == null
          ? null
          : {
              'emergencyResponseActivated':
                  draft.immediateResponse!.emergencyResponseActivated,
              'medicalTreatmentProvided':
                  draft.immediateResponse!.medicalTreatmentProvided,
              'sceneIsolated': draft.immediateResponse!.sceneIsolated,
              'equipmentMadeSafe': draft.immediateResponse!.equipmentMadeSafe,
              'authorityNotified': draft.immediateResponse!.authorityNotified,
              'evidencePreserved': draft.immediateResponse!.evidencePreserved,
              'stopWorkApplied': draft.immediateResponse!.stopWorkApplied,
              'immediateActions': draft.immediateResponse!.immediateActions,
              'sceneControlDetails':
                  draft.immediateResponse!.sceneControlDetails,
              'notifications': draft.immediateResponse!.notifications,
              'temporaryControls': draft.immediateResponse!.temporaryControls,
            },

      'evidence': draft.evidence.map((item) {
        return {
          'evidenceId': item.evidenceId,
          'title': item.title,
          'type': item.type.name,
          'status': item.status.name,
          'source': item.source,
          'obtainedAt': item.obtainedAt.toIso8601String(),
          'obtainedBy': item.obtainedBy,
          'storageLocation': item.storageLocation,
          'integrityVerified': item.integrityVerified,
          'description': item.description,
          'relevance': item.relevance,
          'filePath': item.filePath,
        };
      }).toList(),

      'timelineEvents': draft.timelineEvents.map((item) {
        return {
          'eventId': item.eventId,
          'eventDateTime': item.eventDateTime.toIso8601String(),
          'eventDescription': item.eventDescription,
          'evidenceIds': item.evidenceIds,
          'evidenceStatus': item.evidenceStatus.name,
          'source': item.source,
          'significance': item.significance,
        };
      }).toList(),

      'interviews': draft.interviews.map((item) {
        return {
          'interviewId': item.interviewId,
          'personName': item.personName,
          'role': item.role,
          'company': item.company,
          'interviewDate': item.interviewDate.toIso8601String(),
          'interviewers': item.interviewers,
          'statementSummary': item.statementSummary,
          'directObservations': item.directObservations,
          'assumptionsOrHearsay': item.assumptionsOrHearsay,
          'contradictions': item.contradictions,
          'corroboratingEvidence': item.corroboratingEvidence,
          'followUpRequired': item.followUpRequired,
          'signedStatementAvailable': item.signedStatementAvailable,
        };
      }).toList(),

      'problemStatement': draft.problemStatement,
      'why1': draft.why1,
      'why2': draft.why2,
      'why3': draft.why3,
      'why4': draft.why4,
      'why5': draft.why5,

      'causes': draft.causes.map((item) {
        return {
          'causeId': item.causeId,
          'causeType': item.causeType.name,
          'statement': item.statement,
          'supportingEvidenceIds': item.supportingEvidenceIds,
          'confidence': item.confidence.name,
          'relatedBarrierId': item.relatedBarrierId,
          'notes': item.notes,
        };
      }).toList(),

      'hazard': draft.hazard,
      'topEvent': draft.topEvent,

      'barriers': draft.barriers.map((item) {
        return {
          'barrierId': item.barrierId,
          'title': item.title,
          'barrierType': item.barrierType.name,
          'status': item.status.name,
          'expectedFunction': item.expectedFunction,
          'investigationFinding': item.investigationFinding,
          'relatedThreat': item.relatedThreat,
          'relatedConsequence': item.relatedConsequence,
          'escalationFactor': item.escalationFactor,
          'supportingEvidenceIds': item.supportingEvidenceIds,
        };
      }).toList(),

      'humanFactors': draft.humanFactors == null
          ? null
          : {
              'workloadFatigue': draft.humanFactors!.workloadFatigue,
              'competenceExperience': draft.humanFactors!.competenceExperience,
              'supervisionLeadership':
                  draft.humanFactors!.supervisionLeadership,
              'communicationCoordination':
                  draft.humanFactors!.communicationCoordination,
              'proceduresUsability': draft.humanFactors!.proceduresUsability,
              'timeProductionPressure':
                  draft.humanFactors!.timeProductionPressure,
              'equipmentWorkplaceDesign':
                  draft.humanFactors!.equipmentWorkplaceDesign,
              'situationalAwareness': draft.humanFactors!.situationalAwareness,
              'riskPerceptionDecisionMaking':
                  draft.humanFactors!.riskPerceptionDecisionMaking,
              'teamworkChallengeCulture':
                  draft.humanFactors!.teamworkChallengeCulture,
              'safetyReportingCulture':
                  draft.humanFactors!.safetyReportingCulture,
              'managementDecisions': draft.humanFactors!.managementDecisions,
              'contractorManagement': draft.humanFactors!.contractorManagement,
              'managementOfChange': draft.humanFactors!.managementOfChange,
              'previousWarningSigns': draft.humanFactors!.previousWarningSigns,
            },

      'findings': draft.findings.map((item) {
        return {
          'findingId': item.findingId,
          'findingStatement': item.findingStatement,
          'supportingEvidenceIds': item.supportingEvidenceIds,
          'linkedCauseId': item.linkedCauseId,
          'linkedBarrierId': item.linkedBarrierId,
          'status': item.status.name,
          'confidenceBasis': item.confidenceBasis,
          'outstandingVerification': item.outstandingVerification,
        };
      }).toList(),

      'actions': draft.actions.map((item) {
        return {
          'actionId': item.actionId,
          'linkedCauseId': item.linkedCauseId,
          'linkedBarrierId': item.linkedBarrierId,
          'actionType': item.actionType.name,
          'action': item.action,
          'responsiblePerson': item.responsiblePerson,
          'targetDate': item.targetDate.toIso8601String(),
          'requiredClosureEvidence': item.requiredClosureEvidence,
          'verifier': item.verifier,
          'effectivenessCriteria': item.effectivenessCriteria,
          'effectivenessReviewDate': item.effectivenessReviewDate
              ?.toIso8601String(),
          'status': item.status.name,
          'actualClosureDate': item.actualClosureDate?.toIso8601String(),
          'closureComments': item.closureComments,
        };
      }).toList(),

      'executiveSummary': draft.executiveSummary,
      'conclusion': draft.conclusion,
      'lessonsLearned': draft.lessonsLearned,
      'reviewedBy': draft.reviewedBy,
      'approvedBy': draft.approvedBy,
    };
  }

  static InvestigationDraft _draftFromJson(Map<String, dynamic> json) {
    final caseJson = Map<String, dynamic>.from(
      json['investigationCase'] as Map? ?? {},
    );

    final investigationCase = InvestigationCase(
      investigationReference:
          caseJson['investigationReference'] as String? ?? '',
      incidentTitle: caseJson['incidentTitle'] as String? ?? '',
      reportStatus: _enumValue(
        InvestigationReportStatus.values,
        caseJson['reportStatus'],
        InvestigationReportStatus.draft,
      ),
      investigationLevel: _enumValue(
        InvestigationLevel.values,
        caseJson['investigationLevel'],
        InvestigationLevel.level1Basic,
      ),
      incidentCategory: _enumValue(
        IncidentCategory.values,
        caseJson['incidentCategory'],
        IncidentCategory.other,
      ),
      actualSeverity: _enumValue(
        IncidentSeverity.values,
        caseJson['actualSeverity'],
        IncidentSeverity.minor,
      ),
      potentialSeverity: _enumValue(
        IncidentSeverity.values,
        caseJson['potentialSeverity'],
        IncidentSeverity.minor,
      ),
      highPotential: caseJson['highPotential'] as bool? ?? false,
      incidentDateTime: _date(caseJson['incidentDateTime']),
      reportedDateTime: _date(caseJson['reportedDateTime']),
      location: caseJson['location'] as String? ?? '',
      project: caseJson['project'] as String? ?? '',
      company: caseJson['company'] as String? ?? '',
      contractor: caseJson['contractor'] as String? ?? '',
      preparedBy: caseJson['preparedBy'] as String? ?? '',
      reviewedBy: caseJson['reviewedBy'] as String? ?? '',
      approvedBy: caseJson['approvedBy'] as String? ?? '',
      revisionNumber: caseJson['revisionNumber'] as String? ?? '00',
      confidentialityClassification:
          caseJson['confidentialityClassification'] as String? ?? 'Internal',
    );

    InvestigationImmediateResponse? immediateResponse;

    if (json['immediateResponse'] is Map) {
      final item = Map<String, dynamic>.from(json['immediateResponse'] as Map);

      immediateResponse = InvestigationImmediateResponse(
        emergencyResponseActivated:
            item['emergencyResponseActivated'] as bool? ?? false,
        medicalTreatmentProvided:
            item['medicalTreatmentProvided'] as bool? ?? false,
        sceneIsolated: item['sceneIsolated'] as bool? ?? false,
        equipmentMadeSafe: item['equipmentMadeSafe'] as bool? ?? false,
        authorityNotified: item['authorityNotified'] as bool? ?? false,
        evidencePreserved: item['evidencePreserved'] as bool? ?? false,
        stopWorkApplied: item['stopWorkApplied'] as bool? ?? false,
        immediateActions: item['immediateActions'] as String? ?? '',
        sceneControlDetails: item['sceneControlDetails'] as String? ?? '',
        notifications: item['notifications'] as String? ?? '',
        temporaryControls: item['temporaryControls'] as String? ?? '',
      );
    }

    final evidence = (json['evidence'] as List? ?? []).whereType<Map>().map((
      raw,
    ) {
      final item = Map<String, dynamic>.from(raw);

      return InvestigationEvidence(
        evidenceId: item['evidenceId'] as String? ?? '',
        title: item['title'] as String? ?? '',
        type: _enumValue(
          InvestigationEvidenceType.values,
          item['type'],
          InvestigationEvidenceType.other,
        ),
        status: _enumValue(
          InvestigationEvidenceStatus.values,
          item['status'],
          InvestigationEvidenceStatus.unverified,
        ),
        source: item['source'] as String? ?? '',
        obtainedAt: _date(item['obtainedAt']),
        obtainedBy: item['obtainedBy'] as String? ?? '',
        storageLocation: item['storageLocation'] as String? ?? '',
        integrityVerified: item['integrityVerified'] as bool? ?? false,
        description: item['description'] as String? ?? '',
        relevance: item['relevance'] as String? ?? '',
        filePath: item['filePath'] as String? ?? '',
      );
    }).toList();

    final timelineEvents = (json['timelineEvents'] as List? ?? [])
        .whereType<Map>()
        .map((raw) {
          final item = Map<String, dynamic>.from(raw);

          return InvestigationTimelineEvent(
            eventId: item['eventId'] as String? ?? '',
            eventDateTime: _date(item['eventDateTime']),
            eventDescription: item['eventDescription'] as String? ?? '',
            evidenceIds: (item['evidenceIds'] as List? ?? [])
                .map((value) => value.toString())
                .toList(),
            evidenceStatus: _enumValue(
              InvestigationEvidenceStatus.values,
              item['evidenceStatus'],
              InvestigationEvidenceStatus.unverified,
            ),
            source: item['source'] as String? ?? '',
            significance: item['significance'] as String? ?? '',
          );
        })
        .toList();

    final interviews = (json['interviews'] as List? ?? []).whereType<Map>().map(
      (raw) {
        final item = Map<String, dynamic>.from(raw);

        return InvestigationInterview(
          interviewId: item['interviewId'] as String? ?? '',
          personName: item['personName'] as String? ?? '',
          role: item['role'] as String? ?? '',
          company: item['company'] as String? ?? '',
          interviewDate: _date(item['interviewDate']),
          interviewers: (item['interviewers'] as List? ?? [])
              .map((value) => value.toString())
              .toList(),
          statementSummary: item['statementSummary'] as String? ?? '',
          directObservations: item['directObservations'] as String? ?? '',
          assumptionsOrHearsay: item['assumptionsOrHearsay'] as String? ?? '',
          contradictions: item['contradictions'] as String? ?? '',
          corroboratingEvidence: item['corroboratingEvidence'] as String? ?? '',
          followUpRequired: item['followUpRequired'] as String? ?? '',
          signedStatementAvailable:
              item['signedStatementAvailable'] as bool? ?? false,
        );
      },
    ).toList();

    final causes = (json['causes'] as List? ?? []).whereType<Map>().map((raw) {
      final item = Map<String, dynamic>.from(raw);

      return InvestigationCause(
        causeId: item['causeId'] as String? ?? '',
        causeType: _enumValue(
          InvestigationCauseType.values,
          item['causeType'],
          InvestigationCauseType.contributingFactor,
        ),
        statement: item['statement'] as String? ?? '',
        supportingEvidenceIds: (item['supportingEvidenceIds'] as List? ?? [])
            .map((value) => value.toString())
            .toList(),
        confidence: _enumValue(
          InvestigationConfidence.values,
          item['confidence'],
          InvestigationConfidence.medium,
        ),
        relatedBarrierId: item['relatedBarrierId'] as String? ?? '',
        notes: item['notes'] as String? ?? '',
      );
    }).toList();

    final barriers = (json['barriers'] as List? ?? []).whereType<Map>().map((
      raw,
    ) {
      final item = Map<String, dynamic>.from(raw);

      return InvestigationBarrier(
        barrierId: item['barrierId'] as String? ?? '',
        title: item['title'] as String? ?? '',
        barrierType: _enumValue(
          BarrierType.values,
          item['barrierType'],
          BarrierType.preventive,
        ),
        status: _enumValue(
          BarrierStatus.values,
          item['status'],
          BarrierStatus.degraded,
        ),
        expectedFunction: item['expectedFunction'] as String? ?? '',
        investigationFinding: item['investigationFinding'] as String? ?? '',
        relatedThreat: item['relatedThreat'] as String? ?? '',
        relatedConsequence: item['relatedConsequence'] as String? ?? '',
        escalationFactor: item['escalationFactor'] as String? ?? '',
        supportingEvidenceIds: (item['supportingEvidenceIds'] as List? ?? [])
            .map((value) => value.toString())
            .toList(),
      );
    }).toList();

    InvestigationHumanFactors? humanFactors;

    if (json['humanFactors'] is Map) {
      final item = Map<String, dynamic>.from(json['humanFactors'] as Map);

      humanFactors = InvestigationHumanFactors(
        workloadFatigue: item['workloadFatigue'] as String? ?? '',
        competenceExperience: item['competenceExperience'] as String? ?? '',
        supervisionLeadership: item['supervisionLeadership'] as String? ?? '',
        communicationCoordination:
            item['communicationCoordination'] as String? ?? '',
        proceduresUsability: item['proceduresUsability'] as String? ?? '',
        timeProductionPressure: item['timeProductionPressure'] as String? ?? '',
        equipmentWorkplaceDesign:
            item['equipmentWorkplaceDesign'] as String? ?? '',
        situationalAwareness: item['situationalAwareness'] as String? ?? '',
        riskPerceptionDecisionMaking:
            item['riskPerceptionDecisionMaking'] as String? ?? '',
        teamworkChallengeCulture:
            item['teamworkChallengeCulture'] as String? ?? '',
        safetyReportingCulture: item['safetyReportingCulture'] as String? ?? '',
        managementDecisions: item['managementDecisions'] as String? ?? '',
        contractorManagement: item['contractorManagement'] as String? ?? '',
        managementOfChange: item['managementOfChange'] as String? ?? '',
        previousWarningSigns: item['previousWarningSigns'] as String? ?? '',
      );
    }

    final findings = (json['findings'] as List? ?? []).whereType<Map>().map((
      raw,
    ) {
      final item = Map<String, dynamic>.from(raw);

      return InvestigationFinding(
        findingId: item['findingId'] as String? ?? '',
        findingStatement: item['findingStatement'] as String? ?? '',
        supportingEvidenceIds: (item['supportingEvidenceIds'] as List? ?? [])
            .map((value) => value.toString())
            .toList(),
        linkedCauseId: item['linkedCauseId'] as String? ?? '',
        linkedBarrierId: item['linkedBarrierId'] as String? ?? '',
        status: _enumValue(
          InvestigationFindingStatus.values,
          item['status'],
          InvestigationFindingStatus.pendingVerification,
        ),
        confidenceBasis: item['confidenceBasis'] as String? ?? '',
        outstandingVerification:
            item['outstandingVerification'] as String? ?? '',
      );
    }).toList();

    final actions = (json['actions'] as List? ?? []).whereType<Map>().map((
      raw,
    ) {
      final item = Map<String, dynamic>.from(raw);

      return InvestigationAction(
        actionId: item['actionId'] as String? ?? '',
        linkedCauseId: item['linkedCauseId'] as String? ?? '',
        linkedBarrierId: item['linkedBarrierId'] as String? ?? '',
        actionType: _enumValue(
          InvestigationActionType.values,
          item['actionType'],
          InvestigationActionType.correctiveAction,
        ),
        action: item['action'] as String? ?? '',
        responsiblePerson: item['responsiblePerson'] as String? ?? '',
        targetDate: _date(item['targetDate']),
        requiredClosureEvidence:
            item['requiredClosureEvidence'] as String? ?? '',
        verifier: item['verifier'] as String? ?? '',
        effectivenessCriteria: item['effectivenessCriteria'] as String? ?? '',
        effectivenessReviewDate: _dateOrNull(item['effectivenessReviewDate']),
        status: _enumValue(
          InvestigationActionStatus.values,
          item['status'],
          InvestigationActionStatus.open,
        ),
        actualClosureDate: _dateOrNull(item['actualClosureDate']),
        closureComments: item['closureComments'] as String? ?? '',
      );
    }).toList();

    return InvestigationDraft(
      investigationCase: investigationCase,
      immediateResponse: immediateResponse,
      evidence: evidence,
      timelineEvents: timelineEvents,
      interviews: interviews,
      problemStatement: json['problemStatement'] as String? ?? '',
      why1: json['why1'] as String? ?? '',
      why2: json['why2'] as String? ?? '',
      why3: json['why3'] as String? ?? '',
      why4: json['why4'] as String? ?? '',
      why5: json['why5'] as String? ?? '',
      causes: causes,
      hazard: json['hazard'] as String? ?? '',
      topEvent: json['topEvent'] as String? ?? '',
      barriers: barriers,
      humanFactors: humanFactors,
      findings: findings,
      actions: actions,
      executiveSummary: json['executiveSummary'] as String? ?? '',
      conclusion: json['conclusion'] as String? ?? '',
      lessonsLearned: json['lessonsLearned'] as String? ?? '',
      reviewedBy: json['reviewedBy'] as String? ?? '',
      approvedBy: json['approvedBy'] as String? ?? '',
    );
  }
}
