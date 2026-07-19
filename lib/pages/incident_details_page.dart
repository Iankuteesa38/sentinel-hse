import 'dart:io';

import 'package:flutter/material.dart';

class IncidentDetailsPage extends StatelessWidget {
  final String incident;

  const IncidentDetailsPage({super.key, required this.incident});

  static const List<String> _knownFields = [
    'Location',
    'Incident Type',
    'Severity',
    'Description',
    'Injured Person',
    'Witness',
    'Immediate Action',
    'Immediate Cause',
    'Root Cause',
    'Unsafe Act',
    'Unsafe Condition',
    'Corrective Actions',
    'Investigation Summary',
    'Photo',
    'Status',
    'Date',
  ];

  @override
  Widget build(BuildContext context) {
    final report = _parseReport(incident);

    final location = _value(report['Location']);
    final incidentType = _value(report['Incident Type']);
    final severity = _lastValue(report['Severity']) ?? 'Not specified';
    final description = _value(report['Description']);
    final injuredPerson = _value(report['Injured Person']);
    final witness = _value(report['Witness']);
    final immediateAction = _value(report['Immediate Action']);
    final immediateCause = _value(report['Immediate Cause']);
    final rootCause = _value(report['Root Cause']);
    final unsafeAct = _value(report['Unsafe Act']);
    final unsafeCondition = _value(report['Unsafe Condition']);
    final correctiveActions = _value(report['Corrective Actions']);
    final investigationSummary = _value(report['Investigation Summary']);
    final status = _lastValue(report['Status']) ?? 'Open';
    final date = _lastValue(report['Date']);

    final photoPath = _lastValue(report['Photo']);

    final photoFile =
        photoPath != null && photoPath.isNotEmpty && photoPath != 'No photo'
        ? File(photoPath)
        : null;

    final hasPhoto = photoFile?.existsSync() ?? false;

    final severityColor = _severityColor(severity);
    final statusColor = _statusColor(status);

    return Scaffold(
      appBar: AppBar(title: const Text('Incident Investigation')),
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
                const Row(
                  children: [
                    Icon(Icons.report_problem_outlined, size: 36),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Incident Investigation Report',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _statusChip('Severity: $severity', severityColor),
                    _statusChip('Status: $status', statusColor),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (hasPhoto)
            _sectionCard(
              title: 'Incident Evidence',
              icon: Icons.photo_camera_outlined,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  photoFile!,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          _sectionCard(
            title: 'Incident Information',
            icon: Icons.info_outline,
            child: Column(
              children: [
                _detailRow('Incident Type', incidentType),
                _detailRow('Location', location),
                _detailRow('Date', date ?? 'Not provided'),
              ],
            ),
          ),

          _sectionCard(
            title: 'Incident Description',
            icon: Icons.description_outlined,
            child: _bodyText(description),
          ),

          _sectionCard(
            title: 'Persons Involved',
            icon: Icons.groups_outlined,
            child: Column(
              children: [
                _detailRow('Injured Person', injuredPerson),
                _detailRow('Witness', witness),
              ],
            ),
          ),

          _sectionCard(
            title: 'Immediate Response',
            icon: Icons.emergency_outlined,
            child: _bodyText(immediateAction),
          ),

          _sectionCard(
            title: 'Investigation Findings',
            icon: Icons.manage_search,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _findingSection('Immediate Cause', immediateCause),
                _findingSection('Root Cause', rootCause),
                _findingSection('Unsafe Act', unsafeAct),
                _findingSection('Unsafe Condition', unsafeCondition),
              ],
            ),
          ),

          _sectionCard(
            title: 'Corrective and Preventive Actions',
            icon: Icons.task_alt_outlined,
            child: _bodyText(correctiveActions),
          ),

          if (_hasValue(investigationSummary))
            _sectionCard(
              title: 'AI Investigation Summary',
              icon: Icons.smart_toy_outlined,
              child: _bodyText(investigationSummary),
            ),

          _sectionCard(
            title: 'Report Status',
            icon: Icons.flag_outlined,
            child: Column(
              children: [
                _detailRow('Status', status),
                _detailRow('Severity', severity),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Map<String, List<String>> _parseReport(String rawReport) {
    final report = <String, List<String>>{};
    String? currentField;

    for (final rawLine in rawReport.split('\n')) {
      final line = rawLine.trim();

      if (line.isEmpty) continue;

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

  static String _value(List<String>? values) {
    if (values == null || values.isEmpty) {
      return 'Not provided';
    }

    final cleanedValues = values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    if (cleanedValues.isEmpty) {
      return 'Not provided';
    }

    return cleanedValues.join('\n');
  }

  static String? _lastValue(List<String>? values) {
    if (values == null || values.isEmpty) return null;

    final cleanedValues = values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    if (cleanedValues.isEmpty) return null;

    return cleanedValues.last;
  }

  static bool _hasValue(String value) {
    return value.isNotEmpty && value.toLowerCase() != 'not provided';
  }

  static Color _severityColor(String severity) {
    switch (severity.toLowerCase()) {
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

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return Colors.green;
      case 'under investigation':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  static Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            width: 125,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              _hasValue(value) ? value : 'Not provided',
              style: const TextStyle(fontSize: 15.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _findingSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _bodyText(value),
        ],
      ),
    );
  }

  static Widget _bodyText(String value) {
    return Text(
      _hasValue(value) ? value : 'Not provided',
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }
}
