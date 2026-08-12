import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/investigation_draft.dart';
import '../../branding/models/branding_settings.dart';
import '../../branding/services/branding_service.dart';

class InvestigationPdfService {
  static Future<Uint8List> generate(
    PdfPageFormat pageFormat,
    InvestigationDraft draft,
  ) async {
    final branding = await BrandingService.load();

    final logoFile = await BrandingService.getLogoFile(branding.logoPath);

    final Uint8List? logoBytes = logoFile == null
        ? null
        : await logoFile.readAsBytes();

    final brandColor = PdfColor.fromInt(branding.primaryColorValue);
    final document = pw.Document(
      title:
          'Sentinel HSE Investigation - ${draft.investigationCase.incidentTitle}',
      author: 'Sentinel HSE',
      creator: 'Sentinel HSE Investigation V2',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(30),
        header: (context) =>
            _buildHeader(draft, branding, logoBytes, brandColor),
        footer: _buildFooter,
        build: (context) => [
          _buildTitleBlock(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('1. Document Control'),
          _buildDocumentControl(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('2. Executive Summary'),
          _textBlock(
            draft.executiveSummary,
            emptyText: 'Executive summary not yet completed.',
          ),
          pw.SizedBox(height: 16),
          _sectionTitle('3. Incident Details'),
          _buildIncidentDetails(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('4. Immediate Response & Scene Control'),
          _buildImmediateResponse(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('5. Evidence Register'),
          ..._buildEvidence(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('6. Chronology / Timeline'),
          ..._buildTimeline(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('7. Witness Interviews'),
          ..._buildInterviews(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('8. Causal Analysis / 5-Why'),
          _buildFiveWhy(draft),
          pw.SizedBox(height: 12),
          ..._buildCauses(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('9. Bow-Tie / Barrier Performance'),
          _buildBowTieOverview(draft),
          pw.SizedBox(height: 8),
          ..._buildBarriers(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('10. Human & Organisational Factors'),
          _buildHumanFactors(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('11. Formal Findings'),
          ..._buildFindings(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('12. Corrective & Preventive Action Plan'),
          ..._buildActions(draft),
          pw.SizedBox(height: 16),
          _sectionTitle('13. Investigation Conclusion'),
          _textBlock(
            draft.conclusion,
            emptyText: 'Investigation conclusion not yet completed.',
          ),
          pw.SizedBox(height: 16),
          _sectionTitle('14. Lessons Learned & Organisational Learning'),
          _textBlock(
            draft.lessonsLearned,
            emptyText: 'Lessons learned not yet completed.',
          ),
          pw.SizedBox(height: 16),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _sectionTitle('15. Review, Approval & Closeout'),
              pw.SizedBox(height: 8),
              _buildApproval(draft),
            ],
          ),
        ],
      ),
    );

    return document.save();
  }

  static pw.Widget _buildHeader(
    InvestigationDraft draft,
    BrandingSettings branding,
    Uint8List? logoBytes,
    PdfColor brandColor,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Row(
              children: [
                if (logoBytes != null) ...[
                  pw.Container(
                    width: 42,
                    height: 42,
                    child: pw.Image(
                      pw.MemoryImage(logoBytes),
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                  pw.SizedBox(width: 8),
                ],

                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        branding.companyName.isEmpty
                            ? 'SENTINEL HSE'
                            : branding.companyName,
                        style: pw.TextStyle(
                          color: brandColor,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                      if (branding.projectSiteName.isNotEmpty)
                        pw.Text(
                          branding.projectSiteName,
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey700,
                          ),
                        ),

                      if (branding.clientName.isNotEmpty)
                        pw.Text(
                          'Client: '
                          '${branding.clientName}',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey700,
                          ),
                        ),

                      pw.Text(
                        'Incident Investigation Report',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(width: 10),

          pw.Text(
            draft.investigationCase.investigationReference,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 7),
      margin: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by Sentinel HSE Investigation V2',
            style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTitleBlock(InvestigationDraft draft) {
    final incident = draft.investigationCase;

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue900),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            incident.incidentTitle,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 6),
          _detailLine(
            'Investigation reference',
            incident.investigationReference,
          ),
          _detailLine('Report status', _enumLabel(incident.reportStatus)),
          _detailLine(
            'Investigation level',
            _enumLabel(incident.investigationLevel),
          ),
          _detailLine(
            'Incident category',
            _enumLabel(incident.incidentCategory),
          ),
          _detailLine(
            'Actual / Potential severity',
            '${_enumLabel(incident.actualSeverity)} / '
                '${_enumLabel(incident.potentialSeverity)}',
          ),
          _detailLine('High potential', incident.highPotential ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const pw.BoxDecoration(color: PdfColors.blue900),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _buildDocumentControl(InvestigationDraft draft) {
    final incident = draft.investigationCase;

    return _twoColumnTable([
      ['Reference', incident.investigationReference],
      ['Revision', incident.revisionNumber],
      ['Status', _enumLabel(incident.reportStatus)],
      ['Confidentiality', incident.confidentialityClassification],
      ['Prepared by', incident.preparedBy],
      [
        'Reviewed by',
        draft.reviewedBy.isEmpty ? incident.reviewedBy : draft.reviewedBy,
      ],
      [
        'Approved by',
        draft.approvedBy.isEmpty ? incident.approvedBy : draft.approvedBy,
      ],
    ]);
  }

  static pw.Widget _buildIncidentDetails(InvestigationDraft draft) {
    final incident = draft.investigationCase;

    return _twoColumnTable([
      ['Incident date & time', _formatDateTime(incident.incidentDateTime)],
      ['Reported date & time', _formatDateTime(incident.reportedDateTime)],
      ['Location', incident.location],
      ['Project / Business Unit', incident.project],
      ['Company', incident.company],
      ['Contractor', _value(incident.contractor)],
      ['Category', _enumLabel(incident.incidentCategory)],
      ['Actual severity', _enumLabel(incident.actualSeverity)],
      ['Potential severity', _enumLabel(incident.potentialSeverity)],
      ['High potential', incident.highPotential ? 'Yes' : 'No'],
    ]);
  }

  static pw.Widget _buildImmediateResponse(InvestigationDraft draft) {
    final response = draft.immediateResponse;

    if (response == null) {
      return _emptyBox('Immediate response details not yet recorded.');
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _twoColumnTable([
          [
            'Emergency response activated',
            _yesNo(response.emergencyResponseActivated),
          ],
          [
            'Medical / first aid provided',
            _yesNo(response.medicalTreatmentProvided),
          ],
          ['Scene isolated', _yesNo(response.sceneIsolated)],
          ['Vehicle / equipment made safe', _yesNo(response.equipmentMadeSafe)],
          ['Authority / client notified', _yesNo(response.authorityNotified)],
          ['Evidence preserved', _yesNo(response.evidencePreserved)],
          ['Stop-work applied', _yesNo(response.stopWorkApplied)],
        ]),
        pw.SizedBox(height: 8),
        _labelledText('Immediate actions', response.immediateActions),
        _labelledText('Scene control', response.sceneControlDetails),
        _labelledText('Notifications', response.notifications),
        _labelledText('Temporary controls', response.temporaryControls),
      ],
    );
  }

  static List<pw.Widget> _buildEvidence(InvestigationDraft draft) {
    if (draft.evidence.isEmpty) {
      return [_emptyBox('No evidence recorded.')];
    }

    return draft.evidence.map((item) {
      return _recordCard(
        title: '${item.evidenceId} - ${item.title}',
        rows: [
          ['Type', _enumLabel(item.type)],
          ['Status', _enumLabel(item.status)],
          ['Source', item.source],
          ['Obtained', _formatDateTime(item.obtainedAt)],
          ['Obtained by', item.obtainedBy],
          ['Storage location', item.storageLocation],
          ['Integrity verified', item.integrityVerified ? 'Yes' : 'No'],
          ['Description', item.description],
          ['Relevance', item.relevance],
          ['File / Attachment', item.filePath],
        ],
      );
    }).toList();
  }

  static List<pw.Widget> _buildTimeline(InvestigationDraft draft) {
    if (draft.timelineEvents.isEmpty) {
      return [_emptyBox('No chronology events recorded.')];
    }

    return draft.timelineEvents.map((event) {
      return _recordCard(
        title: '${event.eventId} - ${_formatDateTime(event.eventDateTime)}',
        rows: [
          ['Event', event.eventDescription],
          ['Source', event.source],
          ['Evidence status', _enumLabel(event.evidenceStatus)],
          ['Evidence IDs', event.evidenceIds.join(', ')],
          ['Significance', event.significance],
        ],
      );
    }).toList();
  }

  static List<pw.Widget> _buildInterviews(InvestigationDraft draft) {
    if (draft.interviews.isEmpty) {
      return [_emptyBox('No witness interviews recorded.')];
    }

    return draft.interviews.map((item) {
      return _recordCard(
        title: '${item.interviewId} - ${item.personName}',
        rows: [
          ['Role / Company', '${item.role} / ${item.company}'],
          ['Interview date', _formatDateTime(item.interviewDate)],
          ['Interviewers', item.interviewers.join(', ')],
          ['Statement summary', item.statementSummary],
          ['Direct observations', item.directObservations],
          ['Assumptions / hearsay', item.assumptionsOrHearsay],
          ['Contradictions', item.contradictions],
          ['Corroborating evidence', item.corroboratingEvidence],
          ['Follow-up required', item.followUpRequired],
          [
            'Signed statement available',
            item.signedStatementAvailable ? 'Yes' : 'No',
          ],
        ],
      );
    }).toList();
  }

  static pw.Widget _buildFiveWhy(InvestigationDraft draft) {
    return _twoColumnTable([
      ['Problem / Top Event', _value(draft.problemStatement)],
      ['Why 1', _value(draft.why1)],
      ['Why 2', _value(draft.why2)],
      ['Why 3', _value(draft.why3)],
      ['Why 4', _value(draft.why4)],
      ['Why 5', _value(draft.why5)],
    ]);
  }

  static List<pw.Widget> _buildCauses(InvestigationDraft draft) {
    if (draft.causes.isEmpty) {
      return [_emptyBox('No formal causes classified.')];
    }

    return draft.causes.map((cause) {
      return _recordCard(
        title: '${cause.causeId} - ${_enumLabel(cause.causeType)}',
        rows: [
          ['Cause statement', cause.statement],
          ['Supporting evidence', cause.supportingEvidenceIds.join(', ')],
          ['Confidence', _enumLabel(cause.confidence)],
          ['Related barrier', cause.relatedBarrierId],
          ['Notes', cause.notes],
        ],
      );
    }).toList();
  }

  static pw.Widget _buildBowTieOverview(InvestigationDraft draft) {
    return _twoColumnTable([
      ['Hazard', _value(draft.hazard)],
      ['Top Event', _value(draft.topEvent)],
    ]);
  }

  static List<pw.Widget> _buildBarriers(InvestigationDraft draft) {
    if (draft.barriers.isEmpty) {
      return [_emptyBox('No barrier assessments recorded.')];
    }

    return draft.barriers.map((barrier) {
      return _recordCard(
        title: '${barrier.barrierId} - ${barrier.title}',
        rows: [
          ['Barrier type', _enumLabel(barrier.barrierType)],
          ['Status', _enumLabel(barrier.status)],
          ['Expected function', barrier.expectedFunction],
          ['Threat / Cause', barrier.relatedThreat],
          ['Escalation factor', barrier.escalationFactor],
          ['Related consequence', barrier.relatedConsequence],
          ['Investigation finding', barrier.investigationFinding],
          ['Supporting evidence', barrier.supportingEvidenceIds.join(', ')],
        ],
      );
    }).toList();
  }

  static pw.Widget _buildHumanFactors(InvestigationDraft draft) {
    final factors = draft.humanFactors;

    if (factors == null) {
      return _emptyBox('Human and organisational factors not yet assessed.');
    }

    return _twoColumnTable([
      ['Workload / Fatigue', factors.workloadFatigue],
      ['Competence / Experience', factors.competenceExperience],
      ['Supervision / Leadership', factors.supervisionLeadership],
      ['Communication / Coordination', factors.communicationCoordination],
      ['Procedures / Usability', factors.proceduresUsability],
      ['Time / Production Pressure', factors.timeProductionPressure],
      ['Equipment / Workplace Design', factors.equipmentWorkplaceDesign],
      ['Situational Awareness', factors.situationalAwareness],
      [
        'Risk Perception / Decision Making',
        factors.riskPerceptionDecisionMaking,
      ],
      ['Teamwork / Challenge Culture', factors.teamworkChallengeCulture],
      ['Safety / Reporting Culture', factors.safetyReportingCulture],
      ['Management Decisions', factors.managementDecisions],
      ['Contractor Management', factors.contractorManagement],
      ['Management of Change', factors.managementOfChange],
      ['Previous Warning Signs', factors.previousWarningSigns],
    ]);
  }

  static List<pw.Widget> _buildFindings(InvestigationDraft draft) {
    if (draft.findings.isEmpty) {
      return [_emptyBox('No formal findings recorded.')];
    }

    return draft.findings.map((finding) {
      return _recordCard(
        title: '${finding.findingId} - ${_enumLabel(finding.status)}',
        rows: [
          ['Finding', finding.findingStatement],
          ['Supporting evidence', finding.supportingEvidenceIds.join(', ')],
          ['Linked cause', finding.linkedCauseId],
          ['Linked barrier', finding.linkedBarrierId],
          ['Confidence basis', finding.confidenceBasis],
          ['Outstanding verification', finding.outstandingVerification],
        ],
      );
    }).toList();
  }

  static List<pw.Widget> _buildActions(InvestigationDraft draft) {
    if (draft.actions.isEmpty) {
      return [_emptyBox('No corrective actions recorded.')];
    }

    return draft.actions.map((action) {
      return _recordCard(
        title: '${action.actionId} - ${_enumLabel(action.actionType)}',
        rows: [
          ['Linked cause', action.linkedCauseId],
          ['Linked barrier', action.linkedBarrierId],
          ['Action', action.action],
          ['Responsible person', action.responsiblePerson],
          ['Target date', _formatDate(action.targetDate)],
          ['Required closure evidence', action.requiredClosureEvidence],
          ['Independent verifier', action.verifier],
          ['Effectiveness criteria', action.effectivenessCriteria],
          [
            'Effectiveness review date',
            action.effectivenessReviewDate == null
                ? ''
                : _formatDate(action.effectivenessReviewDate!),
          ],
          ['Status', _enumLabel(action.status)],
          [
            'Actual closure date',
            action.actualClosureDate == null
                ? ''
                : _formatDate(action.actualClosureDate!),
          ],
          ['Closure comments', action.closureComments],
        ],
      );
    }).toList();
  }

  static pw.Widget _buildApproval(InvestigationDraft draft) {
    final incident = draft.investigationCase;

    final reviewedBy = draft.reviewedBy.isEmpty
        ? incident.reviewedBy
        : draft.reviewedBy;

    final approvedBy = draft.approvedBy.isEmpty
        ? incident.approvedBy
        : draft.approvedBy;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: _signatureBox('Lead Investigator: ${incident.preparedBy}'),
        ),
        pw.SizedBox(width: 12),
        pw.Expanded(child: _signatureBox('Reviewed By: ${_value(reviewedBy)}')),
        pw.SizedBox(width: 12),
        pw.Expanded(child: _signatureBox('Approved By: ${_value(approvedBy)}')),
      ],
    );
  }

  static pw.Widget _signatureBox(String label) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 18),
        pw.Container(
          width: double.infinity,
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700)),
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static pw.Widget _recordCard({
    required String title,
    required List<List<String>> rows,
  }) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 5),
          ...rows
              .where((row) => row.length >= 2)
              .map((row) => _detailLine(row[0], _value(row[1]))),
        ],
      ),
    );
  }

  static pw.Widget _twoColumnTable(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.35),
        1: pw.FlexColumnWidth(3.65),
      },
      children: rows.map((row) {
        return pw.TableRow(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(6),
              color: PdfColors.grey200,
              child: pw.Text(
                row[0],
                style: pw.TextStyle(
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                _value(row[1]),
                style: const pw.TextStyle(fontSize: 8.5),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  static pw.Widget _textBlock(String text, {required String emptyText}) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(9),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Text(
        text.trim().isEmpty ? emptyText : text.trim(),
        style: const pw.TextStyle(fontSize: 9, lineSpacing: 2),
      ),
    );
  }

  static pw.Widget _emptyBox(String text) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
      ),
    );
  }

  static pw.Widget _labelledText(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: _detailLine(label, _value(value)),
    );
  }

  static pw.Widget _detailLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: '$label: ',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 8.5,
              ),
            ),
            pw.TextSpan(
              text: _value(value),
              style: const pw.TextStyle(fontSize: 8.5),
            ),
          ],
        ),
      ),
    );
  }

  static String _enumLabel(Enum value) {
    final raw = value.name;

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
    }

    final spaced = raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    return spaced.isEmpty
        ? ''
        : '${spaced[0].toUpperCase()}'
              '${spaced.substring(1)}';
  }

  static String _yesNo(bool value) {
    return value ? 'Yes' : 'No';
  }

  static String _value(String value) {
    return value.trim().isEmpty ? 'Not recorded' : value.trim();
  }

  static String _formatDateTime(DateTime value) {
    return '${_two(value.day)}/'
        '${_two(value.month)}/'
        '${value.year} '
        '${_two(value.hour)}:'
        '${_two(value.minute)}';
  }

  static String _formatDate(DateTime value) {
    return '${_two(value.day)}/'
        '${_two(value.month)}/'
        '${value.year}';
  }

  static String _two(int value) {
    return value.toString().padLeft(2, '0');
  }
}
