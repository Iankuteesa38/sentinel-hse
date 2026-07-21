import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final formattedDate = DateFormat(
      'dd MMM yyyy, HH:mm',
    ).format(createdAt.toLocal());

    return Scaffold(
      appBar: AppBar(title: const Text('Risk Assessment Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              report.task,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Generated: $formattedDate',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            if (report.entries.isNotEmpty) ...[
              _buildStructuredSummary(context),
              const SizedBox(height: 16),

              ...report.entries.asMap().entries.map(
                (item) => _buildRiskEntry(context, item.value, item.key + 1),
              ),

              if (report.requiredPpe.isNotEmpty)
                _buildSection('Required PPE', report.requiredPpe),

              if (report.requiredPermits.isNotEmpty)
                _buildSection('Required Permits', report.requiredPermits),

              if (report.emergencyResponse.isNotEmpty)
                _buildSection('Emergency Response', report.emergencyResponse),

              if (report.applicableStandards.isNotEmpty)
                _buildSection(
                  'Applicable Standards',
                  report.applicableStandards,
                ),
            ] else ...[
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
          ],
        ),
      ),
    );
  }

  Widget _buildStructuredSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.assignment_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Structured Risk Register',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('${report.entries.length} hazards assessed individually'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskEntry(
    BuildContext context,
    RiskAssessmentEntry entry,
    int number,
  ) {
    final initialColor = _riskColor(entry.initialRating);
    final residualColor = _riskColor(entry.residualRating);

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            color: Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 18, child: Text(number.toString())),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.hazard.trim().isEmpty
                        ? 'Hazard not specified'
                        : entry.hazard,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _riskChip(
                      'Initial: ${entry.initialRating.code}',
                      initialColor,
                    ),
                    _riskChip(
                      'Residual: ${entry.residualRating.code}',
                      residualColor,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildEntryList('Causes / Threats', entry.causes),
                _buildEntryText('Top Event', entry.topEvent),
                _buildEntryList('Consequences', entry.consequences),
                _buildEntryList('Persons at Risk', entry.personsAtRisk),
                _buildEntryList(
                  'Preventive Controls',
                  entry.preventiveControls,
                ),
                _buildEntryList(
                  'Mitigation / Recovery Measures',
                  entry.mitigationMeasures,
                ),
                _buildEntryList(
                  'Recommended Actions',
                  entry.recommendedActions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _riskChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.40)),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      visualDensity: VisualDensity.compact,
    );
  }

  Color _riskColor(RiskRating rating) {
    final likelihoodValue = switch (rating.likelihood.trim().toUpperCase()) {
      'A' => 1,
      'B' => 2,
      'C' => 3,
      'D' => 4,
      'E' => 5,
      _ => 0,
    };

    final score = rating.severity * likelihoodValue;

    if (score <= 0) {
      return Colors.grey;
    }

    if (score <= 4) {
      return Colors.green;
    }

    if (score <= 9) {
      return Colors.amber.shade800;
    }

    if (score <= 16) {
      return Colors.orange.shade800;
    }

    return Colors.red;
  }

  Widget _buildEntryList(String title, List<String> items) {
    final visibleItems = items.where((item) => item.trim().isNotEmpty).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),

          if (visibleItems.isEmpty)
            const Text('Not specified')
          else
            ...visibleItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text('• $item'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEntryText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value.trim().isEmpty ? 'Not specified' : value),
        ],
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

            if (items.isEmpty)
              const Text('Not specified')
            else
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
            Text(value.trim().isEmpty ? 'Not specified' : value),
          ],
        ),
      ),
    );
  }
}
