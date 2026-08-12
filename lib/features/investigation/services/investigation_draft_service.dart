import '../models/investigation_case.dart';
import '../models/investigation_draft.dart';

class InvestigationDraftService {
  static InvestigationDraft? _currentDraft;

  static InvestigationDraft start(InvestigationCase investigationCase) {
    _currentDraft = InvestigationDraft(investigationCase: investigationCase);

    return _currentDraft!;
  }

  static InvestigationDraft resume(InvestigationDraft draft) {
    _currentDraft = draft;
    return draft;
  }

  static InvestigationDraft? get currentOrNull {
    return _currentDraft;
  }

  static InvestigationDraft get current {
    final draft = _currentDraft;

    if (draft == null) {
      throw StateError('No active investigation draft is available.');
    }

    return draft;
  }

  static void clear() {
    _currentDraft = null;
  }
}
