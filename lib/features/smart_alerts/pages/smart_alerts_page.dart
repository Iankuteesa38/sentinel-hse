import 'package:flutter/material.dart';

import '../models/smart_alert.dart';
import '../services/smart_alert_service.dart';

class SmartAlertsPage extends StatefulWidget {
  const SmartAlertsPage({super.key});

  @override
  State<SmartAlertsPage> createState() => _SmartAlertsPageState();
}

class _SmartAlertsPageState extends State<SmartAlertsPage> {
  late Future<List<SmartAlert>> _alertsFuture;

  SmartAlertSeverity? _selectedSeverity;

  @override
  void initState() {
    super.initState();
    _alertsFuture = SmartAlertService.loadAlerts();
  }

  Future<void> _refresh() async {
    final future = SmartAlertService.loadAlerts();

    setState(() {
      _alertsFuture = future;
    });

    await future;
  }

  String _severityLabel(SmartAlertSeverity severity) {
    switch (severity) {
      case SmartAlertSeverity.critical:
        return 'Critical';

      case SmartAlertSeverity.high:
        return 'High';

      case SmartAlertSeverity.medium:
        return 'Medium';

      case SmartAlertSeverity.info:
        return 'Info';
    }
  }

  Color _severityColor(SmartAlertSeverity severity) {
    switch (severity) {
      case SmartAlertSeverity.critical:
        return Colors.red;

      case SmartAlertSeverity.high:
        return Colors.deepOrange;

      case SmartAlertSeverity.medium:
        return Colors.orange;

      case SmartAlertSeverity.info:
        return Colors.blue;
    }
  }

  IconData _sourceIcon(SmartAlertSource source) {
    switch (source) {
      case SmartAlertSource.inspectionCapa:
        return Icons.fact_check_outlined;

      case SmartAlertSource.investigationAction:
        return Icons.assignment_late_outlined;

      case SmartAlertSource.investigation:
        return Icons.manage_search_outlined;
      case SmartAlertSource.hazard:
        return Icons.warning_amber_outlined;
    }
  }

  String _sourceLabel(SmartAlertSource source) {
    switch (source) {
      case SmartAlertSource.inspectionCapa:
        return 'Inspection CAPA';

      case SmartAlertSource.investigationAction:
        return 'Investigation Action';

      case SmartAlertSource.investigation:
        return 'Investigation';
      case SmartAlertSource.hazard:
        return 'Hazard';
    }
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();

    final day = local.day.toString().padLeft(2, '0');

    final month = local.month.toString().padLeft(2, '0');

    return '$day/$month/${local.year}';
  }

  Widget _summaryCard({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(title),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Alerts Center'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<List<SmartAlert>>(
        future: _alertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load alerts.\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final alerts = snapshot.data ?? [];

          final criticalCount = alerts
              .where((alert) => alert.severity == SmartAlertSeverity.critical)
              .length;

          final highCount = alerts
              .where((alert) => alert.severity == SmartAlertSeverity.high)
              .length;

          final overdueCount = alerts.where((alert) => alert.overdue).length;

          final filteredAlerts = _selectedSeverity == null
              ? alerts
              : alerts
                    .where((alert) => alert.severity == _selectedSeverity)
                    .toList();

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = (constraints.maxWidth - 12) / 2;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: width,
                          child: _summaryCard(
                            title: 'Total Alerts',
                            value: alerts.length,
                            icon: Icons.notifications_active_outlined,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: _summaryCard(
                            title: 'Overdue',
                            value: overdueCount,
                            icon: Icons.alarm_outlined,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: _summaryCard(
                            title: 'Critical',
                            value: criticalCount,
                            icon: Icons.crisis_alert_outlined,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: _summaryCard(
                            title: 'High',
                            value: highCount,
                            icon: Icons.priority_high_outlined,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedSeverity == null,
                        onSelected: (_) {
                          setState(() {
                            _selectedSeverity = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ...SmartAlertSeverity.values.map((severity) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(_severityLabel(severity)),
                            selected: _selectedSeverity == severity,
                            onSelected: (_) {
                              setState(() {
                                _selectedSeverity = severity;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Active Alerts '
                  '(${filteredAlerts.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                if (filteredAlerts.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No active alerts found.')),
                    ),
                  )
                else
                  ...filteredAlerts.map((alert) {
                    final color = _severityColor(alert.severity);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(_sourceIcon(alert.source), color: color),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    alert.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _severityLabel(alert.severity),
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(alert.message),

                            const SizedBox(height: 10),

                            Text(
                              '${_sourceLabel(alert.source)}'
                              ' • ${alert.reference}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            if (alert.location.trim().isNotEmpty)
                              Text(
                                'Location: '
                                '${alert.location}',
                              ),

                            if (alert.responsiblePerson.trim().isNotEmpty)
                              Text(
                                'Responsible: '
                                '${alert.responsiblePerson}',
                              ),

                            Text('Status: ${alert.status}'),

                            if (alert.targetDate != null)
                              Text(
                                'Target Date: '
                                '${_formatDate(alert.targetDate!)}',
                              ),

                            if (alert.overdue) ...[
                              const SizedBox(height: 6),
                              Text(
                                'OVERDUE',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
