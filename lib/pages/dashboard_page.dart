import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
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
import '../features/inspection_engine/pages/inspection_template_selection_page.dart';
import '../features/risk_assessment/pages/risk_assessment_page.dart';
import '../features/jsa/pages/jsa_page.dart';
import '../features/toolbox_talk/pages/toolbox_talk_page.dart';
import '../features/reports_center/pages/reports_center_page.dart';
import '../features/reports_center/models/report_item.dart';
import '../features/reports_center/services/reports_center_service.dart';
import '../features/monthly_hse/pages/monthly_hse_report_page.dart';
import '../features/branding/models/branding_settings.dart';
import '../features/branding/services/branding_service.dart';
import '../features/smart_alerts/pages/smart_alerts_page.dart';
import 'settings_page.dart';
import '../features/investigation/pages/investigation_home_page.dart';
import '../features/team/pages/team_members_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int safetyScore = 98;
  int totalHazards = 0;
  int hazardLifecycleTotal = 0;
  int hazardLifecycleClosed = 0;
  int totalIncidents = 0;
  int totalInspections = 0;
  int closedActions = 0;
  int openActions = 0;
  int highRiskInspections = 0;
  int overdueActions = 0;
  int daysWithoutLTI = 0;
  DateTime? lastLTIDate;
  double trir = 0.18;
  int nearMisses = 0;
  double inspectionScore = 91;
  double complianceRate = 98;
  String safetyForecast = 'Low Risk';
  List<int> weeklySafetyScores = List.filled(7, 0);
  @override
  void initState() {
    super.initState();
    loadDashboardData();
    _loadUserName();
    _loadBranding();
    _loadLastLTIDate();
  }

  Future<void> loadDashboardData() async {
    final incidents = await StorageService.getIncidents();
    final actions = await StorageService.getActions();

    final inspectionRecords = await StorageService.getInspectionRecords();
    final unifiedReports = await ReportsCenterService.getAllReports();

    final unifiedInspections = unifiedReports
        .where((report) => report.type == ReportType.inspection)
        .toList();

    final unifiedInvestigations = unifiedReports
        .where((report) => report.type == ReportType.incident)
        .toList();

    final unifiedHazards = unifiedReports
        .where((report) => report.type == ReportType.hazard)
        .toList();

    final scoredInspections = unifiedInspections
        .where((report) => report.compliancePercentage != null)
        .toList();

    final double? unifiedInspectionScore = scoredInspections.isEmpty
        ? null
        : scoredInspections
                  .map((report) => report.compliancePercentage!)
                  .reduce((a, b) => a + b) /
              scoredInspections.length;

    final unifiedOpenCapa = unifiedInspections.fold<int>(
      0,
      (total, report) => total + report.openCapaCount,
    );

    final unifiedInProgressCapa = unifiedInspections.fold<int>(
      0,
      (total, report) => total + report.inProgressCapaCount,
    );

    final unifiedClosedCapa = unifiedInspections.fold<int>(
      0,
      (total, report) => total + report.closedCapaCount,
    );
    final openIncidents = incidents.where((incident) {
      return !incident.toLowerCase().contains('status: closed');
    }).toList();
    final nearMissRecords = incidents.where((incident) {
      return incident.toLowerCase().contains('type: near miss');
    }).toList();
    int overdue = 0;

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
        final today = DateUtils.dateOnly(DateTime.now());
        final dueDay = DateUtils.dateOnly(dueDate);

        if (dueDay.isBefore(today)) {
          overdue++;
        }
      }
    }
    final highRiskRecords = inspectionRecords.where((record) {
      final risk = record.riskLevel.toLowerCase();

      return risk == 'high' || risk == 'critical';
    }).toList();
    final today = DateUtils.dateOnly(DateTime.now());
    final calculatedWeeklyScores = <int>[];

    for (int daysAgo = 6; daysAgo >= 0; daysAgo--) {
      final targetDate = today.subtract(Duration(days: daysAgo));

      final dailyRecords = inspectionRecords.where((record) {
        final recordDate = DateUtils.dateOnly(record.createdAt);
        return recordDate == targetDate;
      }).toList();

      if (dailyRecords.isEmpty) {
        calculatedWeeklyScores.add(0);
      } else {
        final totalScore = dailyRecords.fold<double>(0, (sum, record) {
          final risk = record.riskLevel.toLowerCase();

          if (risk == 'low') return sum + 95;
          if (risk == 'medium') return sum + 80;
          if (risk == 'high') return sum + 60;
          if (risk == 'critical') return sum + 40;

          return sum + 75;
        });

        calculatedWeeklyScores.add((totalScore / dailyRecords.length).round());
      }
    }

    final hazardLifecycleRecords = await StorageService.getHazardRecords();

    final closedHazardLifecycleRecords = hazardLifecycleRecords
        .where((record) => record.isClosed)
        .length;

    if (!mounted) return;

    setState(() {
      totalHazards = unifiedHazards.length;
      hazardLifecycleTotal = hazardLifecycleRecords.length;

      hazardLifecycleClosed = closedHazardLifecycleRecords;
      totalIncidents = unifiedInvestigations.length;
      nearMisses = nearMissRecords.length;
      if (openIncidents.length >= 5 || nearMissRecords.length >= 3) {
        safetyForecast = 'High Risk';
      } else if (openIncidents.length >= 2 || nearMissRecords.isNotEmpty) {
        safetyForecast = 'Medium Risk';
      } else {
        safetyForecast = 'Low Risk';
      }
      totalInspections = unifiedInspections.length;

      closedActions = unifiedClosedCapa;

      openActions = unifiedOpenCapa + unifiedInProgressCapa;

      inspectionScore = unifiedInspectionScore ?? 0;
      complianceRate = unifiedInspectionScore ?? 0;
      highRiskInspections = highRiskRecords.length;
      overdueActions = overdue;
      weeklySafetyScores = calculatedWeeklyScores;
      safetyScore = 100 - (totalHazards * 2) - (totalIncidents * 5);
      safetyScore = safetyScore.clamp(0, 100);
    });
  }

  int get liveTotalActionsCount => closedActions + openActions;

  double get liveCapaCompletionRate {
    if (liveTotalActionsCount == 0) {
      return 0;
    }

    return closedActions / liveTotalActionsCount;
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

    if (liveCapaCompletionRate < 0.75 && liveTotalActionsCount > 0) {
      return 'CAPA completion is below 75%. Follow up with responsible persons '
          'and confirm target dates.';
    }

    return 'Safety performance is stable. Continue inspections, workforce '
        'engagement, and proactive hazard reporting.';
  }

  double get hazardControlRate {
    if (hazardLifecycleTotal == 0) {
      return 0;
    }

    return hazardLifecycleClosed / hazardLifecycleTotal;
  }

  String get executiveSummary {
    final capaPercent = (liveCapaCompletionRate * 100).round();

    if (safetyScore < 60) {
      return 'Critical safety performance. Immediate leadership intervention, '
          'site-wide inspection, and action closure review are required.';
    }

    if (totalIncidents > 0) {
      return '$totalIncidents investigation(s) are recorded in Sentinel HSE. '
          'CAPA completion is $capaPercent%. Continue investigation follow-up '
          'and corrective action closure as required.';
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

  Future<void> openInspection(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InspectionTemplateSelectionPage(),
      ),
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

  Future<void> openActionHistory(
    BuildContext context,
    ActionHistoryFilter filter,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActionHistoryPage(filter: filter),
      ),
    );

    await loadDashboardData();
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

  String userName = 'User';
  String jobTitle = '';
  String company = '';
  String projectSite = '';
  String clientName = '';

  BrandingSettings branding = BrandingSettings.defaults();

  File? brandingLogo;
  Future<void> _loadLastLTIDate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastLTIDate');

    if (savedDate == null || savedDate.isEmpty) {
      return;
    }

    final parsedDate = DateTime.tryParse(savedDate);

    if (parsedDate == null || !mounted) {
      return;
    }

    final today = DateTime.now();
    final startDate = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
    );
    final currentDate = DateTime(today.year, today.month, today.day);

    setState(() {
      lastLTIDate = parsedDate;
      daysWithoutLTI = currentDate.difference(startDate).inDays;
    });
  }

  Future<void> _loadBranding() async {
    final loadedBranding = await BrandingService.load();

    final loadedLogo = await BrandingService.getLogoFile(
      loadedBranding.logoPath,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      branding = loadedBranding;
      brandingLogo = loadedLogo;

      company = loadedBranding.companyName;
      projectSite = loadedBranding.projectSiteName;
      clientName = loadedBranding.clientName;
    });
  }

  Future<void> _loadUserName() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('full_name, job_title')
          .eq('id', user.id)
          .maybeSingle();

      if (profile != null && mounted) {
        final cloudName = profile['full_name']?.toString().trim() ?? '';
        final cloudJobTitle = profile['job_title']?.toString().trim() ?? '';

        if (cloudName.isNotEmpty) {
          setState(() {
            userName = cloudName;
            jobTitle = cloudJobTitle;
          });

          return;
        }
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('userName');
    final savedJobTitle = prefs.getString('jobTitle');

    if (savedName != null && savedName.isNotEmpty && mounted) {
      setState(() {
        userName = savedName;
        jobTitle = savedJobTitle ?? '';
      });
    } else if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNameDialog();
      });
    }
  }

  Future<void> _showNameDialog() async {
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Welcome to Sentinel HSE'),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();

                if (name.isEmpty) {
                  return;
                }

                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('userName', name);

                if (!mounted) return;

                setState(() {
                  userName = name;
                });

                if (!context.mounted) return;

                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        title: const Text('Sentinel HSE'),
        centerTitle: true,
        backgroundColor: Color(branding.primaryColorValue),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );

              await _loadUserName();
              await _loadBranding();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting()},\n$userName 🤠',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (jobTitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  jobTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (company.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  company,
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ],
              if (brandingLogo != null) ...[
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 180,
                      maxHeight: 90,
                    ),
                    child: Image.file(brandingLogo!, fit: BoxFit.contain),
                  ),
                ),
              ],

              if (projectSite.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Project / Site: $projectSite',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],

              if (clientName.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Client: $clientName',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
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
                          '${(liveCapaCompletionRate * 100).round()}%',
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
                      value: liveCapaCompletionRate,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$closedActions of $liveTotalActionsCount corrective actions completed',
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
                      value: liveCapaCompletionRate,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 16),

                    _performanceBar(
                      label: 'Hazard Closure',
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
                      title: 'Investigations',
                      value: totalIncidents.toString(),
                      icon: Icons.manage_search,
                      color: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InvestigationHomePage(),
                          ),
                        );
                      },
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
                      onTap: () => openActionHistory(
                        context,
                        ActionHistoryFilter.closed,
                      ),
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
                      onTap: () =>
                          openActionHistory(context, ActionHistoryFilter.open),
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
                      onTap: () => openActionHistory(
                        context,
                        ActionHistoryFilter.overdue,
                      ),
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
                    () => openActionHistory(context, ActionHistoryFilter.all),
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
                    'AI Risk Assessment',
                    Icons.assignment_turned_in_outlined,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RiskAssessmentPage(),
                      ),
                    ),
                  ),
                  moduleCard(
                    context,
                    'AI JSA',
                    Icons.fact_check_outlined,
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JsaPage()),
                    ),
                  ),
                  moduleCard(
                    context,
                    'AI Toolbox Talk',
                    Icons.record_voice_over_outlined,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ToolboxTalkPage(),
                      ),
                    ),
                  ),
                  moduleCard(
                    context,
                    'Reports',
                    Icons.folder_copy_outlined,
                    Colors.red,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportsCenterPage(),
                        ),
                      );
                    },
                  ),
                  moduleCard(
                    context,
                    'Monthly HSE',
                    Icons.calendar_month_outlined,
                    Colors.indigo,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MonthlyHseReportPage(),
                        ),
                      );
                    },
                  ),
                  moduleCard(
                    context,
                    'Smart Alerts',
                    Icons.notifications_active_outlined,
                    Colors.deepOrange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SmartAlertsPage(),
                        ),
                      );
                    },
                  ),
                  moduleCard(
                    context,
                    'Team Members',
                    Icons.groups_outlined,
                    Colors.teal,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeamMembersPage(),
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
