import 'package:flutter/material.dart';

import '../../reports_center/models/report_item.dart';
import '../../reports_center/services/reports_center_service.dart';
import '../models/monthly_hse_report_data.dart';
import 'monthly_hse_pdf_preview_page.dart';

class MonthlyHseReportPage extends StatefulWidget {
  const MonthlyHseReportPage({super.key});

  @override
  State<MonthlyHseReportPage> createState() => _MonthlyHseReportPageState();
}

class _MonthlyHseReportPageState extends State<MonthlyHseReportPage> {
  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late Future<List<ReportItem>> _reportsFuture;

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _reportsFuture = ReportsCenterService.getAllReports();
  }

  Future<void> _refresh() async {
    final future = ReportsCenterService.getAllReports();

    setState(() {
      _reportsFuture = future;
    });

    await future;
  }

  List<int> _availableYears(List<ReportItem> reports) {
    final years = reports
        .map((report) => report.createdAt.toLocal().year)
        .toSet();

    years.add(DateTime.now().year);
    years.add(_selectedYear);

    final result = years.toList()..sort((a, b) => b.compareTo(a));

    return result;
  }

  String _typeLabel(ReportType type) {
    switch (type) {
      case ReportType.inspection:
        return 'Inspection';
      case ReportType.incident:
        return 'Investigation';
      case ReportType.hazard:
        return 'Hazard';
      case ReportType.jsa:
        return 'JSA';
      case ReportType.riskAssessment:
        return 'Risk Assessment';
      case ReportType.toolboxTalk:
        return 'Toolbox Talk';
    }
  }

  String _formatDate(DateTime value) {
    final date = value.toLocal();

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _breakdownRow(String title, int count, IconData icon) {
    return ListTile(
      dense: true,
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        '$count',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly HSE Report'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<ReportItem>>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load Monthly HSE data.\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final allReports = snapshot.data ?? [];

          final years = _availableYears(allReports);

          final data = MonthlyHseReportData.fromReports(
            year: _selectedYear,
            month: _selectedMonth,
            allReports: allReports,
          );

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reporting Period',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _selectedMonth,
                                decoration: const InputDecoration(
                                  labelText: 'Month',
                                  border: OutlineInputBorder(),
                                ),
                                items: List.generate(
                                  12,
                                  (index) => DropdownMenuItem(
                                    value: index + 1,
                                    child: Text(_months[index]),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }

                                  setState(() {
                                    _selectedMonth = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _selectedYear,
                                decoration: const InputDecoration(
                                  labelText: 'Year',
                                  border: OutlineInputBorder(),
                                ),
                                items: years
                                    .map(
                                      (year) => DropdownMenuItem(
                                        value: year,
                                        child: Text('$year'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }

                                  setState(() {
                                    _selectedYear = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.periodLabel,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF generation coming soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: Text('Generate ${data.periodLabel} HSE PDF'),
                  ),
                ),

                const SizedBox(height: 12),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MonthlyHsePdfPreviewPage(data: data),
                        ),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: Text('Generate ${data.periodLabel} HSE PDF'),
                  ),
                ),

                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = (constraints.maxWidth - 12) / 2;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: width,
                          child: _metricCard(
                            title: 'Total Reports',
                            value: '${data.totalReports}',
                            icon: Icons.description_outlined,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: _metricCard(
                            title: 'Inspections',
                            value: '${data.inspectionCount}',
                            icon: Icons.checklist_outlined,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: _metricCard(
                            title: 'Investigations',
                            value: '${data.investigationCount}',
                            icon: Icons.manage_search_outlined,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: _metricCard(
                            title: 'Average Inspection Score',
                            value: data.averageInspectionScore == null
                                ? 'N/A'
                                : '${data.averageInspectionScore!.toStringAsFixed(1)}%',
                            icon: Icons.analytics_outlined,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: _metricCard(
                            title: 'Open CAPAs',
                            value: '${data.openCapaCount}',
                            icon: Icons.pending_actions_outlined,
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: _metricCard(
                            title: 'Closed CAPAs',
                            value: '${data.closedCapaCount}',
                            icon: Icons.task_alt_outlined,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 18),

                const Text(
                  'HSE Activity Breakdown',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Card(
                  child: Column(
                    children: [
                      _breakdownRow(
                        'Inspections',
                        data.inspectionCount,
                        Icons.checklist_outlined,
                      ),
                      const Divider(height: 1),
                      _breakdownRow(
                        'Incident Investigations',
                        data.investigationCount,
                        Icons.manage_search_outlined,
                      ),
                      const Divider(height: 1),
                      _breakdownRow(
                        'Hazard Reports',
                        data.hazardCount,
                        Icons.warning_amber_outlined,
                      ),
                      const Divider(height: 1),
                      _breakdownRow(
                        'JSA',
                        data.jsaCount,
                        Icons.assignment_outlined,
                      ),
                      const Divider(height: 1),
                      _breakdownRow(
                        'Risk Assessments',
                        data.riskAssessmentCount,
                        Icons.health_and_safety_outlined,
                      ),
                      const Divider(height: 1),
                      _breakdownRow(
                        'Toolbox Talks',
                        data.toolboxTalkCount,
                        Icons.record_voice_over_outlined,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'CAPA Performance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Card(
                  child: Column(
                    children: [
                      _breakdownRow(
                        'Total CAPAs',
                        data.totalCapaCount,
                        Icons.assignment_late_outlined,
                      ),
                      const Divider(height: 1),
                      _breakdownRow(
                        'Open',
                        data.openCapaCount,
                        Icons.pending_actions_outlined,
                      ),
                      const Divider(height: 1),
                      _breakdownRow(
                        'In Progress',
                        data.inProgressCapaCount,
                        Icons.autorenew_outlined,
                      ),
                      const Divider(height: 1),
                      _breakdownRow(
                        'Closed',
                        data.closedCapaCount,
                        Icons.task_alt_outlined,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'Monthly Records (${data.totalReports})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                if (data.reports.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No HSE records found for the selected month.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  ...data.reports.map(
                    (report) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: Text(report.title),
                        subtitle: Text(
                          '${_typeLabel(report.type)}'
                          ' • '
                          '${_formatDate(report.createdAt)}',
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
