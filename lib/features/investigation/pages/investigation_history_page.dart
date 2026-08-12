import 'package:flutter/material.dart';

import '../models/investigation_draft.dart';
import '../services/investigation_draft_service.dart';
import '../services/investigation_history_service.dart';
import 'investigation_case_summary_page.dart';

class InvestigationHistoryPage extends StatefulWidget {
  const InvestigationHistoryPage({super.key});

  @override
  State<InvestigationHistoryPage> createState() =>
      _InvestigationHistoryPageState();
}

class _InvestigationHistoryPageState extends State<InvestigationHistoryPage> {
  late Future<List<InvestigationDraft>> _future;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _future = InvestigationHistoryService.loadDrafts();
  }

  Future<void> _delete(InvestigationDraft draft) async {
    await InvestigationHistoryService.deleteDraft(
      draft.investigationCase.investigationReference,
    );

    setState(_refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigation History'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<InvestigationDraft>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final drafts = snapshot.data ?? [];

          if (drafts.isEmpty) {
            return const Center(child: Text('No saved investigations yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: drafts.length,
            itemBuilder: (context, index) {
              final draft = drafts[index];
              final incident = draft.investigationCase;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.manage_search),
                  title: Text(incident.incidentTitle),
                  subtitle: Text(
                    '${incident.investigationReference}\n'
                    '${incident.location}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _delete(draft),
                  ),
                  onTap: () async {
                    InvestigationDraftService.resume(draft);

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvestigationCaseSummaryPage(
                          investigation: incident,
                        ),
                      ),
                    );

                    if (mounted) {
                      setState(_refresh);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
