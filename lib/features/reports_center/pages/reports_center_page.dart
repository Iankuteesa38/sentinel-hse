import 'package:flutter/material.dart';

import '../models/report_item.dart';
import '../services/reports_center_service.dart';
import '../../toolbox_talk/pages/toolbox_talk_report_page.dart';
import '../../toolbox_talk/storage/toolbox_talk_storage_service.dart';
import '../../jsa/pages/jsa_report_page.dart';
import '../../risk_assessment/pages/risk_assessment_report_page.dart';
import '../../../pages/hazard_report_page.dart';
import '../../../services/storage_service.dart';
import '../../risk_assessment/storage/risk_assessment_storage_service.dart';
import '../../jsa/storage/jsa_storage_service.dart';

class ReportsCenterPage extends StatefulWidget {
  const ReportsCenterPage({super.key});

  @override
  State<ReportsCenterPage> createState() => _ReportsCenterPageState();
}

class _ReportsCenterPageState extends State<ReportsCenterPage> {
  late Future<List<ReportItem>> _reports;
  String _searchQuery = '';
  ReportType? _selectedType;
  @override
  void initState() {
    super.initState();
    _reports = ReportsCenterService.getAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports Center')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search reports...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedType == null,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Toolbox Talks'),
                  selected: _selectedType == ReportType.toolboxTalk,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = ReportType.toolboxTalk;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('JSA'),
                  selected: _selectedType == ReportType.jsa,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = ReportType.jsa;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Risk Assessments'),
                  selected: _selectedType == ReportType.riskAssessment,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = ReportType.riskAssessment;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Hazards'),
                  selected: _selectedType == ReportType.hazard,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = ReportType.hazard;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: FutureBuilder<List<ReportItem>>(
              future: _reports,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reports = snapshot.data ?? [];
                final filteredReports = reports.where((report) {
                  final query = _searchQuery.toLowerCase();

                  final matchesSearch =
                      report.title.toLowerCase().contains(query) ||
                      report.subtitle.toLowerCase().contains(query);

                  final matchesType =
                      _selectedType == null || report.type == _selectedType;

                  return matchesSearch && matchesType;
                }).toList();
                if (reports.isEmpty) {
                  return const Center(child: Text('No reports available.'));
                }

                return ListView.builder(
                  itemCount: filteredReports.length,
                  itemBuilder: (context, index) {
                    final report = filteredReports[index];

                    return ListTile(
                      leading: Icon(_icon(report.type)),
                      title: Text(report.title),
                      subtitle: Text(report.subtitle),
                      trailing: Text(
                        report.createdAt.toLocal().toString().split(' ').first,
                      ),
                      onTap: () async {
                        if (report.type == ReportType.toolboxTalk) {
                          final toolboxTalks =
                              await ToolboxTalkStorageService.getReports();

                          final matchingReports = toolboxTalks.where(
                            (item) =>
                                item.createdAt.toIso8601String() == report.id,
                          );

                          if (matchingReports.isEmpty || !context.mounted) {
                            return;
                          }

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ToolboxTalkReportPage(
                                report: matchingReports.first,
                              ),
                            ),
                          );
                        } else if (report.type == ReportType.jsa) {
                          final jsaReports =
                              await JsaStorageService.getReports();

                          final matchingReports = jsaReports.where(
                            (item) =>
                                item.createdAt.toIso8601String() == report.id,
                          );

                          if (matchingReports.isEmpty || !context.mounted) {
                            return;
                          }

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JsaReportPage(
                                report: matchingReports.first.result,
                                createdAt: matchingReports.first.createdAt,
                              ),
                            ),
                          );
                        } else if (report.type == ReportType.riskAssessment) {
                          final riskAssessments =
                              await RiskAssessmentStorageService.getReports();

                          final matchingReports = riskAssessments.where(
                            (item) =>
                                item.createdAt.toIso8601String() == report.id,
                          );

                          if (matchingReports.isEmpty || !context.mounted) {
                            return;
                          }

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RiskAssessmentReportPage(
                                report: matchingReports.first.result,
                                createdAt: matchingReports.first.createdAt,
                              ),
                            ),
                          );
                        } else if (report.type == ReportType.hazard) {
                          final hazardRecords =
                              await StorageService.getHazardRecords();

                          final matchingRecords = hazardRecords.where(
                            (item) => item.inspectionId == report.id,
                          );

                          if (matchingRecords.isEmpty || !context.mounted) {
                            return;
                          }

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HazardReportPage(
                                record: matchingRecords.first,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _icon(ReportType type) {
    switch (type) {
      case ReportType.toolboxTalk:
        return Icons.record_voice_over;

      case ReportType.jsa:
        return Icons.fact_check;

      case ReportType.riskAssessment:
        return Icons.assignment;

      case ReportType.hazard:
        return Icons.warning;

      case ReportType.inspection:
        return Icons.checklist;

      case ReportType.incident:
        return Icons.report_problem;
    }
  }
}
