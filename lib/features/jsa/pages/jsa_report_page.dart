import 'package:flutter/material.dart';

import '../models/jsa_result.dart';

class JsaReportPage extends StatelessWidget {
  final JsaResult report;
  final DateTime createdAt;

  const JsaReportPage({
    super.key,
    required this.report,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSA Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              report.task,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(createdAt.toLocal().toString().split(' ').first),
            const SizedBox(height: 20),

            ...report.steps.map(
              (step) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.jobStep,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildList('Hazards', step.hazards),
                      _buildList('Control Measures', step.controlMeasures),
                      _buildList('Required PPE', step.requiredPpe),
                      Text('Responsible Person: ${step.responsiblePerson}'),
                    ],
                  ),
                ),
              ),
            ),

            _buildSection('Permits', report.permits),
            _buildSection(
              'Emergency Requirements',
              report.emergencyRequirements,
            ),
            _buildSection('Applicable Standards', report.applicableStandards),
          ],
        ),
      ),
    );
  }

  Widget _buildList(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• $item'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildList(title, items),
      ),
    );
  }
}
