import 'package:flutter/material.dart';

import '../models/toolbox_talk_result.dart';

class ToolboxTalkReportPage extends StatelessWidget {
  final ToolboxTalkResult report;

  const ToolboxTalkReportPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toolbox Talk Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              report.topic,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(report.createdAt.toLocal().toString().split(' ').first),
            const SizedBox(height: 20),
            _buildSection(title: 'Objective', items: [report.objective]),
            _buildSection(title: 'Key Hazards', items: report.keyHazards),
            _buildSection(
              title: 'Safety Precautions',
              items: report.safetyPrecautions,
            ),
            _buildSection(title: 'Required PPE', items: report.requiredPpe),
            _buildSection(
              title: 'Discussion Questions',
              items: report.discussionQuestions,
            ),
            _buildSection(
              title: 'Supervisor Message',
              items: [report.supervisorMessage],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<String> items}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• $item', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
