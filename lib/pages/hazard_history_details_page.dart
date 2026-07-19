import 'dart:io';
import 'package:flutter/material.dart';

class HazardHistoryDetailsPage extends StatelessWidget {
  final String hazard;
  final int hazardNumber;

  const HazardHistoryDetailsPage({
    super.key,
    required this.hazard,
    required this.hazardNumber,
  });

  static const List<String> _knownFields = [
    'Inspection ID',
    'Date',
    'Time',
    'Inspector',
    'Location',
    'Hazard Category',
    'Hazards Found',
    'Likelihood',
    'Severity',
    'Risk Level',
    'Photo',
    'Immediate Actions',
    'Corrective Actions',
    'Preventive Actions',
    'Required PPE',
    'Required Permits',
    'Applicable Standards',
    'AI Confidence Score',
    'Status',
  ];

  @override
  Widget build(BuildContext context) {
    final report = _parseReport(hazard);

    final inspectionId = _lastValue(report['Inspection ID']);
    final date = _lastValue(report['Date']);
    final time = _lastValue(report['Time']);
    final inspector = _lastValue(report['Inspector']);
    final location = _lastValue(report['Location']);
    final category = _lastValue(report['Hazard Category']);
    final likelihood = _lastValue(report['Likelihood']);
    final severity = _lastValue(report['Severity']);
    final riskLevel = _lastValue(report['Risk Level']);
    final confidence = _lastValue(report['AI Confidence Score']);
    final status = _lastValue(report['Status']) ?? 'Open';
    final photoPath = _lastValue(report['Photo']);

    final photoFile =
        photoPath != null && photoPath.isNotEmpty && photoPath != 'No photo'
        ? File(photoPath)
        : null;
    final hazardsFound = _items(report['Hazards Found']);
    final immediateActions = _items(report['Immediate Actions']);
    final correctiveActions = _items(report['Corrective Actions']);
    final preventiveActions = _items(report['Preventive Actions']);
    final requiredPpe = _items(report['Required PPE']);
    final requiredPermits = _items(report['Required Permits']);
    final applicableStandards = _items(report['Applicable Standards']);

    final riskColor = _riskColor(riskLevel);
    final statusColor = status.toLowerCase() == 'closed'
        ? Colors.green
        : Colors.orange;

    return Scaffold(
      appBar: AppBar(title: const Text('Hazard Report')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 34),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Hazard Report $hazardNumber',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (inspectionId != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    inspectionId,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (riskLevel != null)
                      _statusChip('Risk: $riskLevel', riskColor),
                    _statusChip('Status: $status', statusColor),
                    if (confidence != null)
                      _statusChip('AI Confidence: $confidence', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _sectionCard(
            title: 'Report Information',
            icon: Icons.description_outlined,
            child: Column(
              children: [
                if (date != null) _detailRow('Date', date),
                if (time != null) _detailRow('Time', time),
                if (inspector != null) _detailRow('Inspector', inspector),
                if (location != null) _detailRow('Location', location),
                if (category != null) _detailRow('Hazard Category', category),
              ],
            ),
          ),

          if (hazardsFound.isNotEmpty)
            if (photoFile != null && photoFile.existsSync())
              _sectionCard(
                title: 'Hazard Photo',
                icon: Icons.photo_outlined,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    photoFile,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          _sectionCard(
            title: 'Hazards Identified',
            icon: Icons.report_problem_outlined,
            child: _bulletList(hazardsFound),
          ),

          if (likelihood != null || severity != null || riskLevel != null)
            _sectionCard(
              title: 'Risk Assessment',
              icon: Icons.analytics_outlined,
              child: Column(
                children: [
                  if (likelihood != null) _detailRow('Likelihood', likelihood),
                  if (severity != null) _detailRow('Severity', severity),
                  if (riskLevel != null) _detailRow('Risk Level', riskLevel),
                ],
              ),
            ),

          if (immediateActions.isNotEmpty ||
              correctiveActions.isNotEmpty ||
              preventiveActions.isNotEmpty)
            _sectionCard(
              title: 'Action Plan',
              icon: Icons.task_alt_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (immediateActions.isNotEmpty)
                    _actionSection('Immediate Actions', immediateActions),
                  if (correctiveActions.isNotEmpty)
                    _actionSection('Corrective Actions', correctiveActions),
                  if (preventiveActions.isNotEmpty)
                    _actionSection('Preventive Actions', preventiveActions),
                ],
              ),
            ),

          if (requiredPpe.isNotEmpty)
            _sectionCard(
              title: 'Required PPE',
              icon: Icons.health_and_safety_outlined,
              child: _bulletList(requiredPpe),
            ),

          if (requiredPermits.isNotEmpty)
            _sectionCard(
              title: 'Required Permits',
              icon: Icons.assignment_outlined,
              child: _bulletList(requiredPermits),
            ),

          if (applicableStandards.isNotEmpty)
            _sectionCard(
              title: 'Applicable Standards',
              icon: Icons.menu_book_outlined,
              child: _bulletList(applicableStandards),
            ),
        ],
      ),
    );
  }

  static Map<String, List<String>> _parseReport(String rawReport) {
    final report = <String, List<String>>{};
    String? currentField;

    final lines = rawReport.split('\n');

    for (final rawLine in lines) {
      final line = rawLine.trim();

      if (line.isEmpty || line.toLowerCase() == 'ai hazard analysis') {
        continue;
      }

      String? matchedField;
      String inlineValue = '';

      for (final field in _knownFields) {
        final lowerLine = line.toLowerCase();
        final lowerField = field.toLowerCase();

        if (lowerLine == lowerField || lowerLine == '$lowerField:') {
          matchedField = field;
          break;
        }

        if (lowerLine.startsWith('$lowerField:')) {
          matchedField = field;
          inlineValue = line.substring(field.length + 1).trim();
          break;
        }
      }

      if (matchedField != null) {
        currentField = matchedField;
        report.putIfAbsent(currentField, () => []);

        if (inlineValue.isNotEmpty) {
          report[currentField]!.add(inlineValue);
        }

        continue;
      }

      if (currentField != null) {
        report[currentField]!.add(line);
      }
    }

    return report;
  }

  static List<String> _items(List<String>? rawItems) {
    if (rawItems == null) return [];

    return rawItems
        .map((item) => item.replaceFirst(RegExp(r'^[•\-\–]\s*'), '').trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static String? _lastValue(List<String>? values) {
    final cleanedValues = _items(values);

    if (cleanedValues.isEmpty) return null;

    return cleanedValues.last;
  }

  static Color _riskColor(String? riskLevel) {
    switch (riskLevel?.toLowerCase()) {
      case 'critical':
        return Colors.red.shade900;
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  static Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  static Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _bulletList(List<String> items) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Icon(Icons.circle, size: 7),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15.5, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  static Widget _actionSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _bulletList(items),
        ],
      ),
    );
  }
}
