import 'package:flutter/material.dart';

import '../models/risk_assessment_result.dart';

class RiskAssessmentReportPage extends StatelessWidget {
  final RiskAssessmentResult report;
  final DateTime createdAt;

  const RiskAssessmentReportPage({
    super.key,
    required this.report,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk Assessment Report')),
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
            _buildSection('Hazards', report.hazards),
            _buildSection('Persons at Risk', report.personsAtRisk),
            _buildSection('Existing Controls', report.existingControls),
            _buildSection('Additional Controls', report.additionalControls),
            _buildTextSection('Initial Risk', report.initialRisk),
            _buildTextSection('Residual Risk', report.residualRisk),
            _buildSection('Required PPE', report.requiredPpe),
            _buildSection('Required Permits', report.requiredPermits),
            _buildSection('Emergency Response', report.emergencyResponse),
            _buildSection('Applicable Standards', report.applicableStandards),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
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
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $item'),
              ),
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
            Text(value),
          ],
        ),
      ),
    );
  }
}
