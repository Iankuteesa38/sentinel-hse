import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/inspection_record.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';

import 'action_page.dart';

class InspectionDetailsPage extends StatelessWidget {
  final InspectionRecord record;

  const InspectionDetailsPage({super.key, required this.record});
  Map<String, String> parseInspectionAnalysis(String analysis) {
    final values = <String, String>{};

    for (final rawLine in analysis.split('\n')) {
      final line = rawLine.trim();
      final separatorIndex = line.indexOf(':');

      if (separatorIndex <= 0) {
        continue;
      }

      final key = line.substring(0, separatorIndex).trim();
      final value = line.substring(separatorIndex + 1).trim();

      values[key] = value;
    }

    return values;
  }

  bool isChecklistPassed(
    Map<String, String> inspectionValues,
    String checklistName,
  ) {
    return inspectionValues[checklistName]?.toLowerCase() == 'true';
  }

  Widget buildChecklistRow(
    Map<String, String> inspectionValues,
    String checklistName,
  ) {
    final rawStatus =
        inspectionValues[checklistName]?.trim().toLowerCase() ?? '';

    final isCompliant = rawStatus == 'true' || rawStatus == 'compliant';

    final isNotApplicable =
        rawStatus == 'not applicable' ||
        rawStatus == 'n/a' ||
        rawStatus == 'na';

    final statusText = isCompliant
        ? 'Compliant'
        : isNotApplicable
        ? 'Not Applicable'
        : 'Non-Compliant';

    final statusColor = isCompliant
        ? Colors.green
        : isNotApplicable
        ? Colors.grey
        : Colors.red;

    final statusIcon = isCompliant
        ? Icons.check_circle
        : isNotApplicable
        ? Icons.remove_circle_outline
        : Icons.cancel;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              checklistName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<List<File>> loadInspectionImages() async {
    final recoveredImages = await Future.wait(
      record.imagePaths.map(
        (imagePath) => StorageService.getInspectionImage(imagePath),
      ),
    );

    return recoveredImages.whereType<File>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final inspectionValues = parseInspectionAnalysis(record.analysis);
    return Scaffold(
      appBar: AppBar(title: const Text('Inspection Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<File>>(
              future: loadInspectionImages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final recoveredImages = snapshot.data ?? [];

                if (recoveredImages.isEmpty) {
                  return Container(
                    width: double.infinity,
                    height: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text('Inspection photos unavailable'),
                  );
                }

                return SizedBox(
                  height: 270,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recoveredImages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              recoveredImages[index],
                              width: 320,
                              height: 260,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${index + 1}/${recoveredImages.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Text(
              record.inspectionId,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _detailRow(
              icon: Icons.person,
              label: 'Inspector',
              value: record.inspector,
            ),

            _detailRow(
              icon: Icons.location_on,
              label: 'Location',
              value: record.location,
            ),

            _detailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateFormat('dd MMMM yyyy, HH:mm').format(record.createdAt),
            ),

            _detailRow(
              icon: Icons.info_outline,
              label: 'Status',
              value: record.status,
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: record.riskLevel == 'Critical'
                    ? Colors.red
                    : record.riskLevel == 'High'
                    ? Colors.orange
                    : record.riskLevel == 'Medium'
                    ? Colors.amber
                    : Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Risk Level: ${record.riskLevel}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Inspection Checklist',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            buildChecklistRow(inspectionValues, 'Housekeeping'),
            buildChecklistRow(inspectionValues, 'PPE Compliance'),
            buildChecklistRow(inspectionValues, 'Fire Extinguishers'),
            buildChecklistRow(inspectionValues, 'Emergency Exit'),
            buildChecklistRow(inspectionValues, 'Working at Height'),
            buildChecklistRow(inspectionValues, 'Scaffolding'),
            buildChecklistRow(inspectionValues, 'Access and Egress'),
            buildChecklistRow(inspectionValues, 'Barricades and Signage'),
            buildChecklistRow(inspectionValues, 'Excavation Safety'),
            buildChecklistRow(inspectionValues, 'Lifting Operations'),
            buildChecklistRow(inspectionValues, 'Electrical Safety'),
            buildChecklistRow(inspectionValues, 'Hot Work'),
            buildChecklistRow(inspectionValues, 'Tools and Equipment'),
            buildChecklistRow(inspectionValues, 'First Aid Facilities'),
            buildChecklistRow(inspectionValues, 'Chemical Storage'),
            buildChecklistRow(inspectionValues, 'Environmental Controls'),
            buildChecklistRow(inspectionValues, 'Vehicle Movement'),
            buildChecklistRow(inspectionValues, 'Welfare Facilities'),

            const SizedBox(height: 24),

            FutureBuilder<List<File>>(
              future: loadInspectionImages(),
              builder: (context, snapshot) {
                final recoveredImages = snapshot.data ?? [];

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: recoveredImages.isEmpty
                        ? null
                        : () async {
                            await PdfService.generateHazardReport(
                              inspectionId: record.inspectionId,
                              inspector: record.inspector,
                              location: record.location,
                              analysis: record.analysis,
                              imageFiles: recoveredImages,
                            );
                          },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate PDF Report'),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ActionPage(initialHazard: record.analysis),
                    ),
                  );
                },
                icon: const Icon(Icons.assignment_add),
                label: const Text('Create Corrective Action'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text('$label: $value', style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
