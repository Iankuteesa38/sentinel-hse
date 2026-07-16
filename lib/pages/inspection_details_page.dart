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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inspection Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<File?>(
              future: StorageService.getInspectionImage(record.imagePath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final recoveredImage = snapshot.data;

                if (recoveredImage != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      recoveredImage,
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  );
                }

                return Container(
                  width: double.infinity,
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text('Inspection photo unavailable'),
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
              'AI Hazard Analysis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  record.analysis,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 24),

            FutureBuilder<File?>(
              future: StorageService.getInspectionImage(record.imagePath),
              builder: (context, snapshot) {
                final recoveredImage = snapshot.data;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: recoveredImage == null
                        ? null
                        : () async {
                            await PdfService.generateHazardReport(
                              inspectionId: record.inspectionId,
                              inspector: record.inspector,
                              location: record.location,
                              analysis: record.analysis,
                              imageFile: recoveredImage,
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
