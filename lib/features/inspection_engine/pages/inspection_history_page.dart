import 'package:flutter/material.dart';

import '../models/inspection_report_data.dart';
import '../services/inspection_history_service.dart';
import 'inspection_report_preview_page.dart';
import 'capa_dashboard_page.dart';

class InspectionHistoryPage extends StatefulWidget {
  const InspectionHistoryPage({super.key});

  @override
  State<InspectionHistoryPage> createState() => _InspectionHistoryPageState();
}

class _InspectionHistoryPageState extends State<InspectionHistoryPage> {
  late Future<List<InspectionReportData>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    _reportsFuture = InspectionHistoryService.loadReports();
  }

  Future<void> _refreshReports() async {
    setState(() {
      _loadReports();
    });

    await _reportsFuture;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} $hour:$minute';
  }

  Color _getComplianceColor(double percentage) {
    if (percentage >= 90) {
      return Colors.green;
    }

    if (percentage >= 70) {
      return Colors.orange;
    }

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection History'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<InspectionReportData>>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load inspection history',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _loadReports();
                        });
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshReports,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Icon(Icons.history_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No submitted inspections yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshReports,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                final complianceColor = _getComplianceColor(
                  report.compliancePercentage,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InspectionReportPreviewPage(reportData: report),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(Icons.fact_check_outlined),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  report.inspectionTitle,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Reference: '
                            '${report.reportReference}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Date: '
                            '${_formatDate(report.submittedAt)}',
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Location: '
                            '${report.inspectionLocation}',
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Vehicle: '
                            '${report.vehiclePlateNumber} • '
                            '${report.vehicleMakeModel}',
                          ),
                          const SizedBox(height: 5),
                          Text('Driver: ${report.driverName}'),
                          const Divider(height: 22),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(label: Text('Yes: ${report.yesCount}')),
                              Chip(label: Text('No: ${report.noCount}')),
                              Chip(label: Text('N/A: ${report.naCount}')),
                              Chip(
                                label: Text(
                                  'CAPAs: '
                                  '${report.findings.length}',
                                ),
                              ),
                              Chip(
                                label: Text(
                                  '${report.compliancePercentage.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    color: complianceColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (report.findings.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CapaDashboardPage(
                                        findings: report.findings,
                                        reportData: report,
                                      ),
                                    ),
                                  );

                                  if (!mounted) {
                                    return;
                                  }

                                  await _refreshReports();
                                },
                                icon: const Icon(
                                  Icons.assignment_turned_in_outlined,
                                ),
                                label: const Text('Manage CAPA'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
