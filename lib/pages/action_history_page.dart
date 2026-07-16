import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ActionHistoryPage extends StatefulWidget {
  const ActionHistoryPage({super.key});

  @override
  State<ActionHistoryPage> createState() => _ActionHistoryPageState();
}

class _ActionHistoryPageState extends State<ActionHistoryPage> {
  List<String> actions = [];
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
                    itemCount: actions.length,
                    itemBuilder: (context, index) {
                      final action = actions[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.assignment_turned_in),
                          title: Text('CAPA ${index + 1}'),
                          subtitle: Text(action),
                          trailing: IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => closeAction(index),
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
