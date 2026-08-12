import 'package:flutter/material.dart';
import '../models/inspection_finding.dart';
import '../models/inspection_report_data.dart';
import '../services/inspection_history_service.dart';
import 'capa_closure_page.dart';

class CapaDashboardPage extends StatefulWidget {
  final List<InspectionFinding> findings;
  final InspectionReportData? reportData;

  const CapaDashboardPage({super.key, required this.findings, this.reportData});

  @override
  State<CapaDashboardPage> createState() => _CapaDashboardPageState();
}

class _CapaDashboardPageState extends State<CapaDashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'All';
  String _riskFilter = 'All';

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Closed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Future<void> _openClosurePage(InspectionFinding finding) async {
    final result = await Navigator.push<CapaClosureResult>(
      context,
      MaterialPageRoute(
        builder: (context) => CapaClosurePage(finding: finding),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      finding.closedBy = result.closedBy;
      finding.closureComment = result.closureComment;
      finding.closedAt = result.closedAt;
      finding.closureEvidence = List.of(result.closureEvidence);
      finding.status = 'Closed';
    });
    await _saveCapaChanges();
  }

  Future<void> _saveCapaChanges() async {
    final report = widget.reportData;

    if (report == null) {
      return;
    }

    await InspectionHistoryService.saveReport(report);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  bool _isOverdue(InspectionFinding finding) {
    final today = DateTime.now();

    final currentDate = DateTime(today.year, today.month, today.day);

    final targetDate = DateTime(
      finding.targetDate.year,
      finding.targetDate.month,
      finding.targetDate.day,
    );

    return finding.status != 'Closed' && targetDate.isBefore(currentDate);
  }

  List<InspectionFinding> get _filteredFindings {
    final searchText = _searchController.text.trim().toLowerCase();

    return widget.findings.where((finding) {
      final matchesSearch =
          searchText.isEmpty ||
          finding.requirement.toLowerCase().contains(searchText) ||
          finding.finding.toLowerCase().contains(searchText) ||
          finding.correctiveAction.toLowerCase().contains(searchText) ||
          finding.responsiblePerson.toLowerCase().contains(searchText);

      final matchesStatus =
          _statusFilter == 'All' || finding.status == _statusFilter;

      final matchesRisk =
          _riskFilter == 'All' || finding.riskLevel == _riskFilter;

      return matchesSearch && matchesStatus && matchesRisk;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFindings = _filteredFindings;

    return Scaffold(
      appBar: AppBar(title: const Text('CAPA Dashboard'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Search CAPA findings',
                hintText: 'Brake, tyre, workshop...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Open', 'In Progress', 'Closed'].map((status) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: _statusFilter == status,
                    onSelected: (_) {
                      setState(() {
                        _statusFilter = status;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                const Text(
                  'Risk filter:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _riskFilter,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text('All risk levels'),
                      ),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                      DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _riskFilter = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Showing ${filteredFindings.length} of '
                '${widget.findings.length} findings',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: widget.findings.isEmpty
                ? const Center(
                    child: Text(
                      'No CAPA findings generated',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : filteredFindings.isEmpty
                ? const Center(
                    child: Text(
                      'No findings match the selected filters',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFindings.length,
                    itemBuilder: (context, index) {
                      final finding = filteredFindings[index];
                      final riskColor = _getRiskColor(finding.riskLevel);
                      final statusColor = _getStatusColor(finding.status);
                      final isOverdue = _isOverdue(finding);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: riskColor,
                                    child: Text(
                                      finding.itemNumber.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      finding.requirement,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: riskColor.withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Risk: ${finding.riskLevel}',
                                      style: TextStyle(
                                        color: riskColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isOverdue)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withAlpha(30),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'OVERDUE',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text('Finding: ${finding.finding}'),
                              const SizedBox(height: 6),
                              Text('CAPA: ${finding.correctiveAction}'),
                              const SizedBox(height: 6),
                              Text(
                                'Responsible: '
                                '${finding.responsiblePerson}',
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Target date: '
                                '${_formatDate(finding.targetDate)}',
                              ),
                              const Divider(height: 24),

                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  DropdownButton<String>(
                                    value: finding.status,
                                    underline: const SizedBox.shrink(),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Open',
                                        child: Text('Open'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'In Progress',
                                        child: Text('In Progress'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Closed',
                                        enabled: false,
                                        child: Text('Closed'),
                                      ),
                                    ],
                                    onChanged: finding.status == 'Closed'
                                        ? null
                                        : (value) async {
                                            if (value == null ||
                                                value == finding.status) {
                                              return;
                                            }

                                            setState(() {
                                              finding.status = value;
                                            });

                                            await _saveCapaChanges();
                                          },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              if (finding.status != 'Closed')
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: () {
                                      _openClosurePage(finding);
                                    },
                                    icon: const Icon(Icons.task_alt),
                                    label: const Text('Close CAPA'),
                                  ),
                                )
                              else ...[
                                Text(
                                  'Closed by: ${finding.closedBy}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (finding.closedAt != null)
                                  Text(
                                    'Closed date: ${_formatDate(finding.closedAt!)}',
                                  ),
                                Text(
                                  'Closure comment: ${finding.closureComment}',
                                ),
                              ],
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
}
