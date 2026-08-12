import 'package:flutter/material.dart';

import '../models/inspection_record.dart';
import '../services/storage_service.dart';
import 'hazard_lifecycle_page.dart';
import 'hazard_report_page.dart';

class HazardHistoryPage extends StatefulWidget {
  const HazardHistoryPage({super.key});

  @override
  State<HazardHistoryPage> createState() => _HazardHistoryPageState();
}

class _HazardHistoryPageState extends State<HazardHistoryPage> {
  List<InspectionRecord> _records = [];

  String _selectedStatus = 'All';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await StorageService.migrateLegacyHazardRecords();
    await StorageService.migrateLegacyTextHazards();

    final records = await StorageService.getHazardRecords();

    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (!mounted) {
      return;
    }

    setState(() {
      _records = records;
      _loading = false;
    });
  }

  List<InspectionRecord> get _filteredRecords {
    switch (_selectedStatus) {
      case 'Open':
        return _records.where((record) => record.status == 'Open').toList();

      case 'In Progress':
        return _records
            .where((record) => record.status == 'In Progress')
            .toList();

      case 'Controlled':
        return _records
            .where((record) => record.status == 'Controlled')
            .toList();

      case 'Closed':
        return _records.where((record) => record.isClosed).toList();

      case 'Overdue':
        return _records.where((record) => record.isOverdue).toList();

      default:
        return _records;
    }
  }

  int _statusCount(String status) {
    return _records.where((record) => record.status == status).length;
  }

  Future<void> _manageLifecycle(InspectionRecord record) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => HazardLifecyclePage(record: record)),
    );

    if (changed == true) {
      await _load();
    }
  }

  Future<void> _openReport(InspectionRecord record) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HazardReportPage(record: record)),
    );
  }

  Future<void> _delete(InspectionRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Hazard'),
          content: Text(
            'Permanently delete '
            '${record.inspectionId}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await StorageService.deleteHazardRecord(record.inspectionId);

    await _load();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Closed':
        return Colors.green;

      case 'Controlled':
        return Colors.blue;

      case 'In Progress':
        return Colors.orange;

      default:
        return Colors.deepOrange;
    }
  }

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'critical':
        return Colors.red;

      case 'high':
        return Colors.deepOrange;

      case 'medium':
        return Colors.orange;

      case 'low':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();

    final day = local.day.toString().padLeft(2, '0');

    final month = local.month.toString().padLeft(2, '0');

    return '$day/$month/${local.year}';
  }

  Widget _summaryCard(String label, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              '$value',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRecords;

    final closedCount = _records.where((record) => record.isClosed).length;

    final overdueCount = _records.where((record) => record.isOverdue).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazard History'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
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
                            child: _summaryCard('Total', _records.length),
                          ),
                          SizedBox(
                            width: width,
                            child: _summaryCard('Open', _statusCount('Open')),
                          ),
                          SizedBox(
                            width: width,
                            child: _summaryCard('Closed', closedCount),
                          ),
                          SizedBox(
                            width: width,
                            child: _summaryCard('Overdue', overdueCount),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                            'All',
                            'Open',
                            'In Progress',
                            'Controlled',
                            'Closed',
                            'Overdue',
                          ].map((status) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(status),
                                selected: _selectedStatus == status,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedStatus = status;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Hazards (${filtered.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (filtered.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text('No hazards found for this filter.'),
                        ),
                      ),
                    )
                  else
                    ...filtered.map(
                      (record) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () => _openReport(record),
                          leading: Icon(
                            Icons.warning_amber_rounded,
                            color: _riskColor(record.riskLevel),
                          ),
                          title: Text(
                            record.location.trim().isEmpty
                                ? record.inspectionId
                                : record.location,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(record.inspectionId),
                              Text(
                                'Risk: '
                                '${record.riskLevel}',
                              ),
                              Text(
                                'Status: '
                                '${record.status}',
                                style: TextStyle(
                                  color: _statusColor(record.status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Responsible: '
                                '${record.responsiblePerson.trim().isEmpty ? 'Not assigned' : record.responsiblePerson}',
                              ),
                              if (record.targetDate != null)
                                Text(
                                  'Target: '
                                  '${_formatDate(record.targetDate!)}',
                                ),
                              if (record.isOverdue)
                                const Text(
                                  'OVERDUE',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'manage') {
                                await _manageLifecycle(record);
                              } else if (value == 'report') {
                                await _openReport(record);
                              } else if (value == 'delete') {
                                await _delete(record);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'manage',
                                child: Text('Manage Lifecycle'),
                              ),
                              PopupMenuItem(
                                value: 'report',
                                child: Text('Open Full Report'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(
                                  'Delete Hazard',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
