import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'action_details_page.dart';

enum ActionHistoryFilter { all, open, closed, overdue }

class ActionHistoryPage extends StatefulWidget {
  final ActionHistoryFilter filter;

  const ActionHistoryPage({super.key, this.filter = ActionHistoryFilter.all});
  @override
  State<ActionHistoryPage> createState() => _ActionHistoryPageState();
}

class _ActionHistoryPageState extends State<ActionHistoryPage> {
  List<int> get filteredActionIndexes {
    final visibleActions = filteredActions;

    return actions
        .asMap()
        .entries
        .where((entry) => visibleActions.contains(entry.value))
        .map((entry) => entry.key)
        .toList();
  }

  List<String> actions = [];
  List<String> get filteredActions {
    final today = DateUtils.dateOnly(DateTime.now());

    return actions.where((action) {
      final text = action.toLowerCase();

      final isClosed =
          text.contains('status: closed') || text.contains('status: completed');

      switch (widget.filter) {
        case ActionHistoryFilter.open:
          return !isClosed;

        case ActionHistoryFilter.closed:
          return isClosed;

        case ActionHistoryFilter.overdue:
          if (isClosed || !action.contains('Due Date:')) {
            return false;
          }

          final dueDateText = action
              .split('Due Date:')[1]
              .split('\n')[0]
              .trim();

          final dueDate = DateTime.tryParse(dueDateText);

          return dueDate != null && DateUtils.dateOnly(dueDate).isBefore(today);

        case ActionHistoryFilter.all:
          return true;
      }
    }).toList();
  }

  int get openCapaCount {
    return actions.where((action) {
      final text = action.toLowerCase();
      return !text.contains('status: closed') &&
          !text.contains('status: completed');
    }).length;
  }

  int get closedCapaCount {
    return actions.where((action) {
      final text = action.toLowerCase();
      return text.contains('status: closed') ||
          text.contains('status: completed');
    }).length;
  }

  int get overdueCapaCount {
    int count = 0;
    final today = DateUtils.dateOnly(DateTime.now());

    for (final action in actions) {
      final text = action.toLowerCase();

      final isClosed =
          text.contains('status: closed') || text.contains('status: completed');

      if (isClosed || !action.contains('Due Date:')) {
        continue;
      }

      final dueDateText = action.split('Due Date:')[1].split('\n')[0].trim();

      final dueDate = DateTime.tryParse(dueDateText);

      if (dueDate != null) {
        final dueDay = DateUtils.dateOnly(dueDate);

        if (dueDay.isBefore(today)) {
          count++;
        }
      }
    }

    return count;
  }

  @override
  void initState() {
    super.initState();
    loadActions();
  }

  Future<void> loadActions() async {
    final savedActions = (await StorageService.getActions()).reversed.toList();

    setState(() {
      actions = savedActions;
    });
  }

  Future<void> closeAction(int index) async {
    final updatedActions = List<String>.from(actions);
    final currentAction = updatedActions[index];

    if (currentAction.toLowerCase().contains('status: closed') ||
        currentAction.toLowerCase().contains('status: completed')) {
      return;
    }

    if (currentAction.contains('Status: Open')) {
      updatedActions[index] = currentAction.replaceFirst(
        'Status: Open',
        'Status: Closed',
      );
    } else if (currentAction.contains('status: Open')) {
      updatedActions[index] = currentAction.replaceFirst(
        'status: Open',
        'status: Closed',
      );
    } else {
      updatedActions[index] = '$currentAction\nStatus: Closed';
    }

    await StorageService.saveActions(updatedActions);

    if (!mounted) return;

    setState(() {
      actions = updatedActions;
    });
  }

  Future<void> deleteAction(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete CAPA'),
          content: const Text(
            'Are you sure you want to permanently delete this CAPA record?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final updatedActions = List<String>.from(actions);
    updatedActions.removeAt(index);

    await StorageService.saveActions(updatedActions);

    if (!mounted) return;

    setState(() {
      actions = updatedActions;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('CAPA record deleted')));
  }

  Map<String, String> _parseActionFields(String action) {
    final fields = <String, String>{};

    for (final rawLine in action.split('\n')) {
      final line = rawLine.trim();
      final separatorIndex = line.indexOf(':');

      if (separatorIndex <= 0) {
        continue;
      }

      final key = line.substring(0, separatorIndex).trim();
      final value = line.substring(separatorIndex + 1).trim();

      if (value.isNotEmpty) {
        fields[key] = value;
      }
    }

    return fields;
  }

  String _formatActionDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not specified';
    }

    final parsedDate = DateTime.tryParse(value.trim());

    if (parsedDate == null) {
      return value.trim();
    }

    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${parsedDate.day.toString().padLeft(2, '0')} '
        '${months[parsedDate.month - 1]} '
        '${parsedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAPA Register'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await StorageService.clearActions();

              setState(() {
                actions.clear();
              });
            },
          ),
        ],
      ),
      body: actions.isEmpty
          ? const Center(child: Text('No CAPA records yet'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          title: 'Open',
                          value: openCapaCount,
                          color: Colors.orange,
                          icon: Icons.pending_actions,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summaryCard(
                          title: 'Closed',
                          value: closedCapaCount,
                          color: Colors.green,
                          icon: Icons.check_circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summaryCard(
                          title: 'Overdue',
                          value: overdueCapaCount,
                          color: Colors.red,
                          icon: Icons.alarm,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filteredActions.length,
                    itemBuilder: (context, index) {
                      final action = filteredActions[index];
                      final fields = _parseActionFields(action);

                      final actionRequired =
                          fields['Action'] ??
                          'Corrective action details not specified';

                      final priority = fields['Priority'] ?? 'Not specified';
                      final status = fields['Status'] ?? 'Open';
                      final dueDateText = fields['Due Date'];

                      final parsedDueDate = DateTime.tryParse(
                        dueDateText ?? '',
                      );

                      final isClosed =
                          status.toLowerCase() == 'closed' ||
                          status.toLowerCase() == 'completed';

                      final isOverdue =
                          !isClosed &&
                          parsedDueDate != null &&
                          DateUtils.dateOnly(
                            parsedDueDate,
                          ).isBefore(DateUtils.dateOnly(DateTime.now()));
                      final statusColor = isClosed
                          ? Colors.green
                          : isOverdue
                          ? Colors.red
                          : Colors.orange;

                      final priorityColor = priority.toLowerCase() == 'high'
                          ? Colors.red
                          : priority.toLowerCase() == 'medium'
                          ? Colors.orange
                          : Colors.green;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.assignment_turned_in),
                          title: Text('CAPA ${index + 1}'),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  actionRequired,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    Chip(
                                      label: Text(status),
                                      backgroundColor: statusColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      side: BorderSide(
                                        color: statusColor.withValues(
                                          alpha: 0.35,
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    Chip(
                                      label: Text('Priority: $priority'),
                                      backgroundColor: priorityColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      side: BorderSide(
                                        color: priorityColor.withValues(
                                          alpha: 0.35,
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                        color: priorityColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    if (isOverdue)
                                      const Chip(
                                        label: Text('Overdue'),
                                        labelStyle: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        backgroundColor: Color(0xFFFFEBEE),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Due: ${_formatActionDate(dueDateText)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ActionDetailsPage(action: action),
                              ),
                            );
                          },
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) async {
                              final originalIndex =
                                  filteredActionIndexes[index];

                              if (value == 'close') {
                                await closeAction(originalIndex);
                              } else if (value == 'delete') {
                                await deleteAction(originalIndex);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'close',
                                child: Row(
                                  children: [
                                    Icon(Icons.check),
                                    SizedBox(width: 10),
                                    Text('Close CAPA'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Delete CAPA',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _summaryCard({
    required String title,
    required int value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
