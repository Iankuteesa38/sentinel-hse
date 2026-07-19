import 'dart:io';

import 'package:flutter/material.dart';

import '../models/inspection_record.dart';

class HazardReportPage extends StatelessWidget {
  final InspectionRecord record;

  const HazardReportPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final imageFile = File(record.imagePath);

    return Scaffold(
      appBar: AppBar(title: const Text('Hazard Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (record.imagePath.isNotEmpty && imageFile.existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(imageFile, height: 220, fit: BoxFit.cover),
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
