import 'package:flutter/material.dart';
import 'inspection_page.dart';
import 'history_page.dart';
import 'action_page.dart';
import 'action_history_page.dart';
import 'ai_assistant_page.dart';
import 'hazard_page.dart';
import 'hazard_history_page.dart';
import 'incident_report_page.dart';
import 'incident_history_page.dart';
import 'ai_hazard_scanner_page.dart';
import '../services/storage_service.dart';
import 'inspection_history_page.dart';
import 'pdf_reports_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int safetyScore = 98;
  int totalHazards = 0;
  int totalIncidents = 0;
  int totalInspections = 0;
  int closedActions = 0;
  int openActions = 0;
  int highRiskInspections = 0;
  int overdueActions = 0;
  int daysWithoutLTI = 186;
  double trir = 0.18;
  int nearMisses = 0;
  double inspectionScore = 91;
  double complianceRate = 98;
  String safetyForecast = 'Low Risk';
  final List<int> weeklySafetyScores = [82, 86, 84, 89, 91, 88, 93];
  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final hazards = await StorageService.getHazards();
    final incidents = await StorageService.getIncidents();
    final actions = await StorageService.getActions();

    final inspectionRecords = await StorageService.getInspectionRecords();
    final openHazards = hazards.where((hazard) {
      return !hazard.toLowerCase().contains('status: closed');
    }).toList();
    final openIncidents = incidents.where((incident) {
      return !incident.toLowerCase().contains('status: closed');
    }).toList();
    final nearMissRecords = incidents.where((incident) {
      return incident.toLowerCase().contains('type: near miss');
    }).toList();
    int completedActions = 0;
    int activeActions = 0;
    int overdue = 0;
    for (final action in actions) {
      final text = action.toLowerCase();

      if (text.contains('status: closed') ||
          text.contains('status: completed')) {
        completedActions++;
      } else {
        activeActions++;

        if (action.contains('Due Date:')) {
          final dueDateText = action
              .split('Due Date:')[1]
              .split('\n')[0]
              .trim();

          final dueDate = DateTime.tryParse(dueDateText);

          if (dueDate != null) {
            final today = DateUtils.dateOnly(DateTime.now());
            final dueDay = DateUtils.dateOnly(dueDate);

            if (dueDay.isBefore(today)) {
              overdue++;
            }
          }
        }
      }
    }
    final highRiskRecords = inspectionRecords.where((record) {
      final risk = record.riskLevel.toLowerCase();

      return risk == 'high' || risk == 'critical';
    }).toList();
    if (!mounted) return;

    setState(() {
      totalHazards = openHazards.length;
      totalIncidents = openIncidents.length;
      nearMisses = nearMissRecords.length;
      if (openIncidents.length >= 5 || nearMissRecords.length >= 3) {
        safetyForecast = 'High Risk';
      } else if (openIncidents.length >= 2 || nearMissRecords.isNotEmpty) {
        safetyForecast = 'Medium Risk';
      } else {
        safetyForecast = 'Low Risk';
      }
      totalInspections = inspectionRecords.length;
      closedActions = completedActions;
      openActions = activeActions;
      highRiskInspections = highRiskRecords.length;
      overdueActions = overdue;
      safetyScore = 100 - (totalHazards * 2) - (totalIncidents * 5);
      safetyScore = safetyScore.clamp(0, 100);
    });
  }

  String get safetyAlertMessage {
    if (overdueActions > 0) {
      return '🚨 $overdueActions corrective action(s) are overdue. Immediate follow-up is required.';
    }

    if (highRiskInspections > 0) {
      return '⚠️ $highRiskInspections high-risk inspection(s) require priority attention.';
    }

    if (openActions > 0) {
      return '🟠 $openActions corrective action(s) are still open.';
    }

    return '✅ Excellent! There are no urgent safety actions today.';
  }

  String get managementRecommendation {
    if (overdueActions > 0) {
      return 'Immediate management attention is required for '
          '$overdueActions overdue corrective action(s).';
    }

    if (totalIncidents > 0) {
      return 'Review the $totalIncidents open incident(s), confirm root causes, '
          'and assign corrective actions.';
    }

    if (highRiskInspections > 0) {
      return 'Prioritize the closure of $highRiskInspections high-risk '
          'inspection finding(s).';
    }

    if (totalHazards >= 10) {
      return 'Open hazards are high. Conduct a focused site inspection and '
          'assign responsible persons.';
    }

    if (capaCompletionRate < 0.75 && totalActionsCount > 0) {
      return 'CAPA completion is below 75%. Follow up with responsible persons '
          'and confirm target dates.';
    }

    return 'Safety performance is stable. Continue inspections, workforce '
        'engagement, and proactive hazard reporting.';
  }

  double get hazardControlRate {
    final total = totalHazards + closedActions;

    if (total == 0) {
      return 0;
    }

    return closedActions / total;
  }

  String get executiveSummary {
    final capaPercent = (capaCompletionRate * 100).round();

    if (safetyScore < 60) {
      return 'Critical safety performance. Immediate leadership intervention, '
          'site-wide inspection, and action closure review are required.';
    }

    if (totalIncidents > 0) {
      return 'There are $totalIncidents open incident(s). CAPA completion is '
          '$capaPercent%. Incident investigation and action assignment should '
          'remain the management priority.';
    }

    if (totalHazards >= 10) {
      return '$totalHazards open hazards are currently recorded. CAPA completion '
          'is $capaPercent%. Increase field inspections and accelerate closure.';
    }

    return 'Safety performance is stable. CAPA completion is $capaPercent%. '
        'Continue proactive inspections and workforce engagement.';
  }

  String get projectStatus {
    if (safetyScore >= 90) {
      return 'Safe and controlled';
    } else if (safetyScore >= 75) {
      return 'Attention required';
    } else if (safetyScore >= 60) {
      return 'High risk';
    } else {
      return 'Critical risk';
    }
  }

  Color get scoreCardColor {
    if (safetyScore >= 90) {
      return Colors.blue;
    } else if (safetyScore >= 75) {
      return Colors.orange;
    } else if (safetyScore >= 60) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  int get totalActionsCount {
    return openActions + closedActions;
  }

  double get capaCompletionRate {
    if (totalActionsCount == 0) {
      return 0;
    }

    return closedActions / totalActionsCount;
  }

  Future<void> openInspection(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InspectionPage()),
    );

    await loadDashboardData();
  }

  void openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryPage()),
    );
  }

  Future<void> openActionPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ActionPage()),
    );

    await loadDashboardData();
  }

  Future<void> openHazardPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HazardPage()),
    );

    await loadDashboardData();
  }

  void openInspectionHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InspectionHistoryPage()),
    );
  }

  void openActionHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ActionHistoryPage()),
    );
  }

  void openAIAssistant(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIAssistantPage(
          safetyScore: safetyScore,
          totalHazards: totalHazards,
          openActions: openActions,
          closedActions: closedActions,
          highRiskInspections: highRiskInspections,
          overdueActions: overdueActions,
          projectStatus: projectStatus,
        ),
      ),
    );
  }

  Future<void> openHazardHistory(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HazardHistoryPage()),
    );

    await loadDashboardData();
  }

  Future<void> openIncidentReportPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IncidentReportPage()),
    );

    await loadDashboardData();
  }

  Future<void> openIncidentHistoryPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IncidentHistoryPage()),
    );

    await loadDashboardData();
  }

  Future<void> openAIHazardScanner(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AIHazardScannerPage()),
    );

    await loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        title: const Text('Sentinel HSE'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Evening, Ian 🤠',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'AI Powered Safety Management',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: scoreCardColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 55,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Safety Score',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    Text(
                      '$safetyScore%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Project status: $projectStatus',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CAPA Completion',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(capaCompletionRate * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: capaCompletionRate,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$closedActions of $totalActionsCount corrective actions completed',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.analytics, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          'Management Insight',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      managementRecommendation,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: safetyForecast == 'High Risk'
                      ? Colors.red.shade50
                      : safetyForecast == 'Medium Risk'
                      ? Colors.orange.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: safetyForecast == 'High Risk'
                        ? Colors.red
                        : safetyForecast == 'Medium Risk'
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: safetyForecast == 'High Risk'
                          ? Colors.red
                          : safetyForecast == 'Medium Risk'
                          ? Colors.orange
                          : Colors.green,
                      child: Icon(
                        safetyForecast == 'High Risk'
                            ? Icons.dangerous
                            : safetyForecast == 'Medium Risk'
                            ? Icons.warning_amber
                            : Icons.shield,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Safety Forecast',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            safetyForecast,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: safetyForecast == 'High Risk'
                                  ? Colors.red
                                  : safetyForecast == 'Medium Risk'
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            safetyForecast == 'High Risk'
                                ? 'Immediate management intervention is required.'
                                : safetyForecast == 'Medium Risk'
                                ? 'Increase monitoring and close open actions.'
                                : 'Current safety performance is stable.',
                            style: const TextStyle(fontSize: 14, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.insights, color: Colors.indigo),
                        SizedBox(width: 10),
                        Text(
                          'Executive Analytics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.15,
                      children: [
                        _kpiCard(
                          title: 'TRIR',
                          value: trir.toStringAsFixed(2),
                          icon: Icons.monitor_heart,
                          color: Colors.blue,
                        ),
                        _kpiCard(
                          title: 'Near Misses',
                          value: nearMisses.toString(),
                          icon: Icons.visibility,
                          color: Colors.orange,
                        ),
                        _kpiCard(
                          title: 'Inspection Score',
                          value: '${inspectionScore.round()}%',
                          icon: Icons.fact_check,
                          color: Colors.green,
                        ),
                        _kpiCard(
                          title: 'Compliance',
                          value: '${complianceRate.round()}%',
                          icon: Icons.verified,
                          color: Colors.indigo,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    _performanceBar(
                      label: 'CAPA Completion',
                      value: capaCompletionRate,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 16),

                    _performanceBar(
                      label: 'Hazard Control',
                      value: hazardControlRate,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        executiveSummary,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Days Without LTI',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$daysWithoutLTI Days',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text(
                            'Lost Time Injury Free',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.show_chart, color: Colors.teal),
                        SizedBox(width: 10),
                        Text(
                          '7-Day Safety Trend',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(height: 180, child: _buildSafetyTrend()),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: 'Hazards',
                      value: totalHazards.toString(),
                      icon: Icons.warning_amber,
                      color: Colors.orange,
                      onTap: () => openHazardHistory(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      title: 'Incidents',
                      value: totalIncidents.toString(),
                      icon: Icons.report_problem,
                      color: Colors.red,
                      onTap: () => openIncidentHistoryPage(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: 'Inspections',
                      value: totalInspections.toString(),
                      icon: Icons.assignment,
                      color: Colors.blue,
                      onTap: () => openInspectionHistory(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      title: 'Closed Actions',
                      value: closedActions.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                      onTap: () => openActionHistory(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: 'Open Actions',
                      value: openActions.toString(),
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                      onTap: () => openActionHistory(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      title: 'High Risk',
                      value: highRiskInspections.toString(),
                      icon: Icons.priority_high,
                      color: Colors.red,
                      onTap: () => openInspectionHistory(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: 'Overdue Actions',
                      value: overdueActions.toString(),
                      icon: Icons.alarm,
                      color: Colors.red,
                      onTap: () => openActionHistory(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox()),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: overdueActions > 0
                      ? Colors.red.shade50
                      : highRiskInspections > 0
                      ? Colors.orange.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: overdueActions > 0
                        ? Colors.red
                        : highRiskInspections > 0
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Safety Alert',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      safetyAlertMessage,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'HSE Modules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
                children: [
                  moduleCard(
                    context,
                    'Inspections',
                    Icons.assignment,
                    Colors.blue,
                    () => openInspection(context),
                  ),
                  moduleCard(
                    context,
                    'Hazards',
                    Icons.warning_amber,
                    Colors.orange,
                    () => openHazardPage(context),
                  ),
                  moduleCard(
                    context,
                    'Incidents',
                    Icons.report_problem,
                    Colors.red,
                    () => openIncidentReportPage(context),
                  ),
                  moduleCard(
                    context,
                    'History',
                    Icons.history,
                    Colors.purple,
                    () => openActionHistory(context),
                  ),
                  moduleCard(
                    context,
                    'AI Assistant',
                    Icons.smart_toy,
                    Colors.green,
                    () => openAIAssistant(context),
                  ),
                  moduleCard(
                    context,
                    'AI Hazard Scanner',
                    Icons.camera_alt,
                    Colors.teal,
                    () => openAIHazardScanner(context),
                  ),
                  moduleCard(
                    context,
                    'PDF Reports',
                    Icons.picture_as_pdf,
                    Colors.red,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PDFReportsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget moduleCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 34),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _performanceBar({
    required String label,
    required double value,
    required Color color,
  }) {
    final percentage = (value * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              '$percentage%',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          minHeight: 9,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.grey.shade200,
          color: color,
        ),
      ],
    );
  }

  Widget _kpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTrend() {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(weeklySafetyScores.length, (index) {
        final score = weeklySafetyScores[index];

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$score',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: score * 1.25,
                  decoration: BoxDecoration(
                    color: score >= 90
                        ? Colors.green
                        : score >= 80
                        ? Colors.orange
                        : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dayLabels[index],
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
