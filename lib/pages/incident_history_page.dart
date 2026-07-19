import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';
import 'ai_assistant_page.dart';
import 'incident_details_page.dart';

class IncidentHistoryPage extends StatefulWidget {
  const IncidentHistoryPage({super.key});

  @override
  State<IncidentHistoryPage> createState() => _IncidentHistoryPageState();
}

class _IncidentHistoryPageState extends State<IncidentHistoryPage> {
  List<String> incidents = [];

  @override
  void initState() {
    super.initState();
    loadIncidents();
  }

  Future<void> loadIncidents() async {
    final savedIncidents = await StorageService.getIncidents();

    setState(() {
      incidents = savedIncidents;
    });
  }

  Future<void> closeIncident(int index) async {
    final updatedIncidents = List<String>.from(incidents);
    final currentIncident = updatedIncidents[index];

    if (currentIncident.toLowerCase().contains('status: closed')) {
      return;
    }

    final statusPattern = RegExp(
      r'^Status:\s*.*$',
      caseSensitive: false,
      multiLine: true,
    );

    if (statusPattern.hasMatch(currentIncident)) {
      updatedIncidents[index] = currentIncident.replaceFirst(
        statusPattern,
        'Status: Closed',
      );
    } else {
      updatedIncidents[index] = '$currentIncident\nStatus: Closed';
    }

    await StorageService.saveIncidents(updatedIncidents);

    if (!mounted) return;

    setState(() {
      incidents = updatedIncidents;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Incident closed successfully')),
    );
  }

  Future<void> deleteIncident(int index) async {
    final updatedIncidents = List<String>.from(incidents);

    if (index < 0 || index >= updatedIncidents.length) {
      return;
    }

    updatedIncidents.removeAt(index);

    await StorageService.saveIncidents(updatedIncidents);

    if (!mounted) return;

    setState(() {
      incidents = updatedIncidents;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Incident deleted successfully')),
    );
  }

  Future<void> confirmDeleteIncident(int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete incident?'),
          content: const Text(
            'This incident report will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await deleteIncident(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Incident History")),
      body: incidents.isEmpty
          ? const Center(child: Text("No incidents yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.report_problem),
                    title: Text("Incident ${index + 1}"),
                    subtitle: Text(incidents[index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IncidentDetailsPage(incident: incidents[index]),
                        ),
                      );
                    },
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'pdf') {
                          final incidentText = incidents[index];

                          String extractValue(List<String> labels) {
                            for (final label in labels) {
                              final pattern = RegExp(
                                '$label\\s*[:=]\\s*([^,}\\n]+)',
                                caseSensitive: false,
                              );

                              final match = pattern.firstMatch(incidentText);

                              if (match != null) {
                                return match.group(1)?.trim() ?? 'Not provided';
                              }
                            }

                            return 'Not provided';
                          }

                          final incidentType = extractValue([
                            'Incident Type',
                            'type',
                          ]);

                          final severity = extractValue(['Severity']);

                          final location = extractValue(['Location']);

                          String riskLevel;

                          if (severity.toLowerCase() == 'critical' ||
                              severity.toLowerCase() == 'high') {
                            riskLevel = 'HIGH';
                          } else if (severity.toLowerCase() == 'medium') {
                            riskLevel = 'MEDIUM';
                          } else {
                            riskLevel = 'LOW';
                          }

                          await PdfService.generateAIInvestigationReport(
                            incidentType: incidentType,
                            severity: severity,
                            riskLevel: riskLevel,
                            location: location,
                            investigationSummary: incidentText,
                          );
                        } else if (value == 'ai') {
                          final incidentText = incidents[index];

                          String extractValue(List<String> labels) {
                            for (final label in labels) {
                              final pattern = RegExp(
                                '$label\\s*[:=]\\s*([^,}\\n]+)',
                                caseSensitive: false,
                              );

                              final match = pattern.firstMatch(incidentText);

                              if (match != null) {
                                return match.group(1)?.trim() ?? 'Not provided';
                              }
                            }

                            return 'Not provided';
                          }

                          final incidentType = extractValue([
                            'Incident Type',
                            'type',
                          ]);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AIAssistantPage(
                                safetyScore: 0,
                                totalHazards: 0,
                                openActions: 0,
                                closedActions: 0,
                                highRiskInspections: 0,
                                overdueActions: 0,
                                projectStatus: 'Analyze $incidentType incident',
                              ),
                            ),
                          );
                        } else if (value == 'close') {
                          await closeIncident(index);
                        } else if (value == 'delete') {
                          await confirmDeleteIncident(index);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'pdf',
                          child: Text('Generate PDF'),
                        ),
                        const PopupMenuItem(
                          value: 'ai',
                          child: Text('🧠 AI Analyze'),
                        ),
                        const PopupMenuItem(
                          value: 'close',
                          child: Text('Close Incident'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Incident'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
