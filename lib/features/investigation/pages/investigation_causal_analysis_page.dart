import 'package:flutter/material.dart';

import '../models/investigation_cause.dart';
import '../services/investigation_draft_service.dart';

class InvestigationCausalAnalysisPage extends StatefulWidget {
  const InvestigationCausalAnalysisPage({super.key});

  @override
  State<InvestigationCausalAnalysisPage> createState() =>
      _InvestigationCausalAnalysisPageState();
}

class _InvestigationCausalAnalysisPageState
    extends State<InvestigationCausalAnalysisPage> {
  final problemController = TextEditingController();

  final why1Controller = TextEditingController();
  final why2Controller = TextEditingController();
  final why3Controller = TextEditingController();
  final why4Controller = TextEditingController();
  final why5Controller = TextEditingController();

  final immediateCauseController = TextEditingController();
  final contributingFactorsController = TextEditingController();
  final underlyingCauseController = TextEditingController();
  final rootCauseController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final draft = InvestigationDraftService.current;

    problemController.text = draft.problemStatement;
    why1Controller.text = draft.why1;
    why2Controller.text = draft.why2;
    why3Controller.text = draft.why3;
    why4Controller.text = draft.why4;
    why5Controller.text = draft.why5;

    for (final cause in draft.causes) {
      switch (cause.causeType) {
        case InvestigationCauseType.immediateCause:
          immediateCauseController.text = cause.statement;
          break;

        case InvestigationCauseType.contributingFactor:
          contributingFactorsController.text = cause.statement;
          break;

        case InvestigationCauseType.underlyingCause:
          underlyingCauseController.text = cause.statement;
          break;

        case InvestigationCauseType.rootCause:
          rootCauseController.text = cause.statement;
          break;

        default:
          break;
      }
    }
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

  void _save() {
    final draft = InvestigationDraftService.current;

    draft.problemStatement = problemController.text.trim();
    draft.why1 = why1Controller.text.trim();
    draft.why2 = why2Controller.text.trim();
    draft.why3 = why3Controller.text.trim();
    draft.why4 = why4Controller.text.trim();
    draft.why5 = why5Controller.text.trim();

    draft.causes.removeWhere(
      (cause) =>
          cause.causeType == InvestigationCauseType.immediateCause ||
          cause.causeType == InvestigationCauseType.contributingFactor ||
          cause.causeType == InvestigationCauseType.underlyingCause ||
          cause.causeType == InvestigationCauseType.rootCause,
    );

    void addCause(String id, InvestigationCauseType type, String statement) {
      if (statement.trim().isEmpty) {
        return;
      }

      draft.causes.add(
        InvestigationCause(
          causeId: id,
          causeType: type,
          statement: statement.trim(),
          supportingEvidenceIds: const [],
          confidence: InvestigationConfidence.medium,
        ),
      );
    }

    addCause(
      'IC-01',
      InvestigationCauseType.immediateCause,
      immediateCauseController.text,
    );

    addCause(
      'CF-01',
      InvestigationCauseType.contributingFactor,
      contributingFactorsController.text,
    );

    addCause(
      'UC-01',
      InvestigationCauseType.underlyingCause,
      underlyingCauseController.text,
    );

    addCause(
      'RC-01',
      InvestigationCauseType.rootCause,
      rootCauseController.text,
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    problemController.dispose();
    why1Controller.dispose();
    why2Controller.dispose();
    why3Controller.dispose();
    why4Controller.dispose();
    why5Controller.dispose();
    immediateCauseController.dispose();
    contributingFactorsController.dispose();
    underlyingCauseController.dispose();
    rootCauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Causal Analysis'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '5-Why Analysis',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _field(problemController, 'Problem / Top Event'),
          _field(why1Controller, 'Why 1 - Why did the event occur?'),
          _field(why2Controller, 'Why 2'),
          _field(why3Controller, 'Why 3'),
          _field(why4Controller, 'Why 4'),
          _field(why5Controller, 'Why 5 - System / Organisational Cause'),

          const SizedBox(height: 12),

          const Text(
            'Cause Classification',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _field(immediateCauseController, 'Immediate Cause(s)'),
          _field(contributingFactorsController, 'Contributing Factors'),
          _field(underlyingCauseController, 'Underlying Cause(s)'),
          _field(rootCauseController, 'Root / Organisational Cause(s)'),

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
