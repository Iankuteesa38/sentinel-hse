import 'package:flutter/material.dart';

import '../models/investigation_evidence.dart';
import '../models/investigation_timeline_event.dart';
import '../services/investigation_draft_service.dart';

class InvestigationTimelinePage extends StatefulWidget {
  const InvestigationTimelinePage({super.key});

  @override
  State<InvestigationTimelinePage> createState() =>
      _InvestigationTimelinePageState();
}

class _InvestigationTimelinePageState extends State<InvestigationTimelinePage> {
  final eventController = TextEditingController();
  final sourceController = TextEditingController();
  final significanceController = TextEditingController();

  final Set<String> selectedEvidenceIds = {};

  DateTime eventDateTime = DateTime.now();

  InvestigationEvidenceStatus evidenceStatus =
      InvestigationEvidenceStatus.confirmed;

  String _label(Object value) {
    final raw = value.toString().split('.').last;

    return raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
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
              title: const Text('Select Evidence'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: evidence.map((item) {
                    final selected = working.contains(item.evidenceId);

                    return CheckboxListTile(
                      value: selected,
                      title: Text('${item.evidenceId} - ${item.title}'),
                      subtitle: Text(
                        '${_label(item.type)} | '
                        '${_label(item.status)}',
                      ),
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

  void _addEvent() {
    if (eventController.text.trim().isEmpty) {
      return;
    }

    final events = InvestigationDraftService.current.timelineEvents;

    setState(() {
      events.add(
        InvestigationTimelineEvent(
          eventId: 'TL-${(events.length + 1).toString().padLeft(3, '0')}',
          eventDateTime: eventDateTime,
          eventDescription: eventController.text.trim(),
          evidenceIds: selectedEvidenceIds.toList()..sort(),
          evidenceStatus: evidenceStatus,
          source: sourceController.text.trim(),
          significance: significanceController.text.trim(),
        ),
      );

      eventController.clear();
      sourceController.clear();
      significanceController.clear();

      selectedEvidenceIds.clear();
      eventDateTime = DateTime.now();
      evidenceStatus = InvestigationEvidenceStatus.confirmed;
    });
  }

  void _deleteEvent(int index) {
    setState(() {
      InvestigationDraftService.current.timelineEvents.removeAt(index);
    });
  }

  @override
  void dispose() {
    eventController.dispose();
    sourceController.dispose();
    significanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = InvestigationDraftService.current.timelineEvents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chronology / Timeline'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: eventController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Event / Sequence',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: sourceController,
            decoration: const InputDecoration(
              labelText: 'Source',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

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

          TextField(
            controller: significanceController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Significance',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<InvestigationEvidenceStatus>(
            initialValue: evidenceStatus,
            decoration: const InputDecoration(
              labelText: 'Evidence Status',
              border: OutlineInputBorder(),
            ),
            items: InvestigationEvidenceStatus.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(_label(value)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => evidenceStatus = value);
              }
            },
          ),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: _addEvent,
            icon: const Icon(Icons.add),
            label: const Text('Add Timeline Event'),
          ),

          const SizedBox(height: 20),

          ...List.generate(events.length, (index) {
            final event = events[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.timeline),
                      title: Text(
                        '${event.eventId} - '
                        '${event.eventDescription}',
                      ),
                      subtitle: Text(
                        'Source: ${event.source}\n'
                        'Status: ${_label(event.evidenceStatus)}\n'
                        'Evidence: '
                        '${event.evidenceIds.isEmpty ? 'None linked' : event.evidenceIds.join(', ')}',
                      ),
                      isThreeLine: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _deleteEvent(index),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete Timeline Event'),
                      ),
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
