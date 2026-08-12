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
import '../../inspection_engine/pages/inspection_report_preview_page.dart';
import '../../inspection_engine/services/inspection_history_service.dart';
import '../../investigation/pages/investigation_pdf_preview_page.dart';
import '../../investigation/services/investigation_history_service.dart';

class ReportsCenterPage extends StatefulWidget {
  const ReportsCenterPage({super.key});

  @override
  State<ReportsCenterPage> createState() => _ReportsCenterPageState();
}

class _ReportsCenterPageState extends State<ReportsCenterPage> {
  late Future<List<ReportItem>> _reports;
  String _searchQuery = '';
  ReportType? _selectedType;
  String _selectedCapaStatus = 'All';
  String _selectedScoreRange = 'All';
  String _selectedDateRange = 'All';
  DateTimeRange? _customDateRange;
  @override
  void initState() {
    super.initState();
    _reports = ReportsCenterService.getAllReports();
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();

    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _customDateRange,
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _customDateRange = selected;
      _selectedDateRange = 'Custom';
    });
  }

  bool _matchesDateFilter(DateTime value) {
    final localDate = value.toLocal();

    final date = DateTime(localDate.year, localDate.month, localDate.day);

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    switch (_selectedDateRange) {
      case 'Today':
        return date == today;

      case 'Last 7 Days':
        final start = today.subtract(const Duration(days: 6));

        return !date.isBefore(start) && !date.isAfter(today);

      case 'This Month':
        return date.year == today.year && date.month == today.month;

      case 'Custom':
        final range = _customDateRange;

        if (range == null) {
          return true;
        }

        final start = DateTime(
          range.start.year,
          range.start.month,
          range.start.day,
        );

        final end = DateTime(range.end.year, range.end.month, range.end.day);

        return !date.isBefore(start) && !date.isAfter(end);

      default:
        return true;
    }
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
                      _selectedCapaStatus = 'All';
                      _selectedScoreRange = 'All';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Inspections'),
                  selected: _selectedType == ReportType.inspection,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = ReportType.inspection;
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
                      _selectedCapaStatus = 'All';
                      _selectedScoreRange = 'All';
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
                      _selectedCapaStatus = 'All';
                      _selectedScoreRange = 'All';
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
                      _selectedCapaStatus = 'All';
                      _selectedScoreRange = 'All';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Investigations'),
                  selected: _selectedType == ReportType.incident,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = ReportType.incident;
                      _selectedCapaStatus = 'All';
                      _selectedScoreRange = 'All';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Hazards'),
                  selected: _selectedType == ReportType.hazard,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = ReportType.hazard;
                      _selectedCapaStatus = 'All';
                      _selectedScoreRange = 'All';
                    });
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All Dates'),
                  selected: _selectedDateRange == 'All',
                  onSelected: (_) {
                    setState(() {
                      _selectedDateRange = 'All';
                      _customDateRange = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Today'),
                  selected: _selectedDateRange == 'Today',
                  onSelected: (_) {
                    setState(() {
                      _selectedDateRange = 'Today';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Last 7 Days'),
                  selected: _selectedDateRange == 'Last 7 Days',
                  onSelected: (_) {
                    setState(() {
                      _selectedDateRange = 'Last 7 Days';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('This Month'),
                  selected: _selectedDateRange == 'This Month',
                  onSelected: (_) {
                    setState(() {
                      _selectedDateRange = 'This Month';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Custom'),
                  selected: _selectedDateRange == 'Custom',
                  onSelected: (_) {
                    _pickCustomDateRange();
                  },
                ),
              ],
            ),
          ),
          if (_selectedType == ReportType.inspection)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All CAPAs'),
                    selected: _selectedCapaStatus == 'All',
                    onSelected: (_) {
                      setState(() {
                        _selectedCapaStatus = 'All';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Open'),
                    selected: _selectedCapaStatus == 'Open',
                    onSelected: (_) {
                      setState(() {
                        _selectedCapaStatus = 'Open';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('In Progress'),
                    selected: _selectedCapaStatus == 'In Progress',
                    onSelected: (_) {
                      setState(() {
                        _selectedCapaStatus = 'In Progress';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Closed'),
                    selected: _selectedCapaStatus == 'Closed',
                    onSelected: (_) {
                      setState(() {
                        _selectedCapaStatus = 'Closed';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('No CAPA'),
                    selected: _selectedCapaStatus == 'No CAPA',
                    onSelected: (_) {
                      setState(() {
                        _selectedCapaStatus = 'No CAPA';
                      });
                    },
                  ),
                ],
              ),
            ),
          if (_selectedType == ReportType.inspection)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Scores'),
                    selected: _selectedScoreRange == 'All',
                    onSelected: (_) {
                      setState(() {
                        _selectedScoreRange = 'All';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('≥90%'),
                    selected: _selectedScoreRange == '90+',
                    onSelected: (_) {
                      setState(() {
                        _selectedScoreRange = '90+';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('70–89%'),
                    selected: _selectedScoreRange == '70-89',
                    onSelected: (_) {
                      setState(() {
                        _selectedScoreRange = '70-89';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('<70%'),
                    selected: _selectedScoreRange == 'Below70',
                    onSelected: (_) {
                      setState(() {
                        _selectedScoreRange = 'Below70';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('N/A'),
                    selected: _selectedScoreRange == 'NA',
                    onSelected: (_) {
                      setState(() {
                        _selectedScoreRange = 'NA';
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

                  bool matchesCapaStatus = true;

                  if (_selectedType == ReportType.inspection) {
                    switch (_selectedCapaStatus) {
                      case 'Open':
                        matchesCapaStatus = report.openCapaCount > 0;
                        break;

                      case 'In Progress':
                        matchesCapaStatus = report.inProgressCapaCount > 0;
                        break;

                      case 'Closed':
                        matchesCapaStatus = report.closedCapaCount > 0;
                        break;

                      case 'No CAPA':
                        matchesCapaStatus = report.capaCount == 0;
                        break;

                      default:
                        matchesCapaStatus = true;
                    }
                  }
                  bool matchesScoreRange = true;

                  if (_selectedType == ReportType.inspection) {
                    final score = report.compliancePercentage;

                    switch (_selectedScoreRange) {
                      case '90+':
                        matchesScoreRange = score != null && score >= 90;
                        break;

                      case '70-89':
                        matchesScoreRange =
                            score != null && score >= 70 && score < 90;
                        break;

                      case 'Below70':
                        matchesScoreRange = score != null && score < 70;
                        break;

                      case 'NA':
                        matchesScoreRange = score == null;
                        break;

                      default:
                        matchesScoreRange = true;
                    }
                  }
                  final matchesDate = _matchesDateFilter(report.createdAt);
                  return matchesSearch &&
                      matchesType &&
                      matchesCapaStatus &&
                      matchesScoreRange &&
                      matchesDate;
                }).toList();
                final inspectionReports = filteredReports
                    .where((report) => report.type == ReportType.inspection)
                    .toList();

                final openCapaCount = inspectionReports.fold<int>(
                  0,
                  (total, report) => total + report.openCapaCount,
                );

                final closedCapaCount = inspectionReports.fold<int>(
                  0,
                  (total, report) => total + report.closedCapaCount,
                );

                final scoredInspections = inspectionReports
                    .where((report) => report.compliancePercentage != null)
                    .toList();

                final averageScore = scoredInspections.isEmpty
                    ? null
                    : scoredInspections
                              .map((report) => report.compliancePercentage!)
                              .reduce((a, b) => a + b) /
                          scoredInspections.length;
                if (reports.isEmpty) {
                  return const Center(child: Text('No reports available.'));
                }

                return ListView.builder(
                  itemCount: filteredReports.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Management Summary',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    Chip(
                                      avatar: const Icon(
                                        Icons.description_outlined,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Reports: ${filteredReports.length}',
                                      ),
                                    ),
                                    Chip(
                                      avatar: const Icon(
                                        Icons.checklist_outlined,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Inspections: ${inspectionReports.length}',
                                      ),
                                    ),
                                    Chip(
                                      avatar: const Icon(
                                        Icons.pending_actions_outlined,
                                        size: 18,
                                      ),
                                      label: Text('Open CAPAs: $openCapaCount'),
                                    ),
                                    Chip(
                                      avatar: const Icon(
                                        Icons.task_alt_outlined,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Closed CAPAs: $closedCapaCount',
                                      ),
                                    ),
                                    Chip(
                                      avatar: const Icon(
                                        Icons.analytics_outlined,
                                        size: 18,
                                      ),
                                      label: Text(
                                        averageScore == null
                                            ? 'Avg Score: N/A'
                                            : 'Avg Score: ${averageScore.toStringAsFixed(1)}%',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    final report = filteredReports[index - 1];

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
                        } else if (report.type == ReportType.inspection) {
                          final inspectionReports =
                              await InspectionHistoryService.loadReports();

                          final matchingReports = inspectionReports.where(
                            (item) => item.reportReference == report.id,
                          );

                          if (matchingReports.isEmpty || !context.mounted) {
                            return;
                          }

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InspectionReportPreviewPage(
                                reportData: matchingReports.first,
                              ),
                            ),
                          );
                        } else if (report.type == ReportType.incident) {
                          final investigationDrafts =
                              await InvestigationHistoryService.loadDrafts();

                          final matchingDrafts = investigationDrafts.where(
                            (draft) =>
                                draft
                                    .investigationCase
                                    .investigationReference ==
                                report.id,
                          );

                          if (matchingDrafts.isEmpty || !context.mounted) {
                            return;
                          }

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InvestigationPdfPreviewPage(
                                draft: matchingDrafts.first,
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
