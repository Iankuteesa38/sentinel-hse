import 'dart:io';

import 'package:flutter/material.dart';
import '../models/inspection_record.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';

class HazardReportPage extends StatelessWidget {
  final InspectionRecord record;

  const HazardReportPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final imageFuture = record.imagePath.isEmpty
        ? Future<File?>.value(null)
        : StorageService.getInspectionImage(record.imagePath);

    return Scaffold(
      appBar: AppBar(title: const Text('Hazard Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<File?>(
              future: imageFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final recoveredImage = snapshot.data;

                if (recoveredImage == null) {
                  return const SizedBox.shrink();
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    recoveredImage,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildTextSection('Inspection ID', record.inspectionId),
            _buildTextSection(
              'Date',
              record.createdAt.toLocal().toString().split(' ').first,
            ),
            _buildTextSection('Inspector', record.inspector),
            _buildTextSection('Location', record.location),
            _buildTextSection('Risk Level', record.riskLevel),
            _buildTextSection('Status', record.status),
            _buildTextSection('AI Hazard Analysis', record.analysis),
            const SizedBox(height: 4),

            FutureBuilder<File?>(
              future: imageFuture,
              builder: (context, snapshot) {
                final hazardResult = record.hazardResult;
                final recoveredImage = snapshot.data;
                if (hazardResult == null) {
                  return ElevatedButton.icon(
                    onPressed: () async {
                      final hazardNumber =
                          int.tryParse(
                            record.inspectionId.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            ),
                          ) ??
                          record.createdAt.millisecondsSinceEpoch.remainder(
                            10000,
                          );

                      await PdfService.generateTextHazardReport(
                        hazardNumber: hazardNumber,
                        hazardData: record.analysis,
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate Professional PDF'),
                  );
                }

                return ElevatedButton.icon(
                  onPressed:
                      snapshot.connectionState == ConnectionState.waiting ||
                          recoveredImage == null
                      ? null
                      : () async {
                          await PdfService.generateAIHazardScannerReport(
                            inspectionId: record.inspectionId,
                            inspector: record.inspector,
                            location: record.location,
                            result: hazardResult,
                            imageFile: recoveredImage,
                          );
                        },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Generate Professional PDF'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value.isEmpty ? 'Not specified' : value,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
