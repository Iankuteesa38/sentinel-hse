import 'dart:io';

import 'package:flutter/material.dart';

class ActionDetailsPage extends StatelessWidget {
  final String action;

  const ActionDetailsPage({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final lines = action
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final actionIndex = lines.indexWhere((line) => line.startsWith('Action:'));

    final hazardLines = actionIndex == -1
        ? List<String>.from(lines)
        : lines.sublist(0, actionIndex);

    final actionLines = actionIndex == -1
        ? <String>[]
        : lines.sublist(actionIndex);

    if (hazardLines.isNotEmpty && hazardLines.first.startsWith('Hazard:')) {
      hazardLines[0] = hazardLines.first.substring('Hazard:'.length).trim();
    }

    final hazardFields = <String, String>{};
    final hazardDescriptions = <String>[];

    for (final line in hazardLines) {
      final separatorIndex = line.indexOf(':');

      if (separatorIndex == -1) {
        hazardDescriptions.add(line);
        continue;
      }

      final title = line.substring(0, separatorIndex).trim();
      final value = line.substring(separatorIndex + 1).trim();

      hazardFields[title] = value;
    }

    final actionFields = <String, String>{};

    for (final line in actionLines) {
      final separatorIndex = line.indexOf(':');

      if (separatorIndex == -1) continue;

      final title = line.substring(0, separatorIndex).trim();
      final value = line.substring(separatorIndex + 1).trim();

      actionFields[title] = value;
    }

    final photoPath = hazardFields['Photo'];
    final imageFile =
        photoPath != null && photoPath.isNotEmpty && photoPath != 'No photo'
        ? File(photoPath)
        : null;
    final evidencePhotoPath = actionFields['Evidence Photo'];

    final evidenceImageFile =
        evidencePhotoPath != null &&
            evidencePhotoPath.isNotEmpty &&
            evidencePhotoPath != 'No photo'
        ? File(evidencePhotoPath)
        : null;
    final sourceFields = <String, String>{
      if (hazardFields['Project'] != null) 'Project': hazardFields['Project']!,
      if (hazardFields['Location'] != null)
        'Location': hazardFields['Location']!,
      if (hazardFields['Inspector'] != null)
        'Inspector': hazardFields['Inspector']!,
      if (hazardFields['Date'] != null)
        'Inspection Date': hazardFields['Date']!,
    };

    final checklistFields = <String, String>{
      if (hazardFields['Housekeeping'] != null)
        'Housekeeping': hazardFields['Housekeeping']!,
      if (hazardFields['PPE Compliance'] != null)
        'PPE Compliance': hazardFields['PPE Compliance']!,
      if (hazardFields['Fire Extinguishers'] != null)
        'Fire Extinguishers': hazardFields['Fire Extinguishers']!,
      if (hazardFields['Emergency Exit'] != null)
        'Emergency Exit': hazardFields['Emergency Exit']!,
      if (hazardFields['Working at Height'] != null)
        'Working at Height': hazardFields['Working at Height']!,
      if (hazardFields['Scaffolding'] != null)
        'Scaffolding': hazardFields['Scaffolding']!,
    };

    final status = actionFields['Status'] ?? 'Not specified';
    final priority = actionFields['Priority'] ?? 'Not specified';
    final dueDate = actionFields['Due Date'] ?? 'Not specified';

    return Scaffold(
      appBar: AppBar(title: const Text('Corrective Action Report')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CAPA Summary',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _detailRow('Status', status),
                  _detailRow('Priority', priority),
                  _detailRow('Due Date', dueDate),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (hazardDescriptions.isNotEmpty)
            _sectionCard(
              title: 'Hazard',
              icon: Icons.warning_amber_rounded,
              child: Text(
                hazardDescriptions.join('\n'),
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),

          if (sourceFields.isNotEmpty)
            _sectionCard(
              title: 'Source Inspection',
              icon: Icons.fact_check_outlined,
              child: Column(
                children: sourceFields.entries
                    .map((entry) => _detailRow(entry.key, entry.value))
                    .toList(),
              ),
            ),

          if (checklistFields.isNotEmpty)
            _sectionCard(
              title: 'Inspection Checklist',
              icon: Icons.checklist,
              child: Column(
                children: checklistFields.entries
                    .map(
                      (entry) =>
                          _detailRow(entry.key, _friendlyValue(entry.value)),
                    )
                    .toList(),
              ),
            ),

          if (imageFile != null && imageFile.existsSync())
            _sectionCard(
              title: 'Inspection Photo',
              icon: Icons.photo_outlined,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (evidenceImageFile != null && evidenceImageFile.existsSync())
            _sectionCard(
              title: 'Corrective Action Evidence',
              icon: Icons.verified_outlined,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  evidenceImageFile,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          _sectionCard(
            title: 'Action Required',
            icon: Icons.build_circle_outlined,
            child: Text(
              actionFields['Action'] ?? 'Not specified',
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),

          _sectionCard(
            title: 'Responsible Person',
            icon: Icons.person_outline,
            child: Text(
              actionFields['Responsible'] ?? 'Not specified',
              style: const TextStyle(fontSize: 16),
            ),
          ),

          _sectionCard(
            title: 'Record Information',
            icon: Icons.calendar_today_outlined,
            child: _detailRow(
              'Created',
              actionFields['Date'] ?? 'Not specified',
            ),
          ),
        ],
      ),
    );
  }

  static String _friendlyValue(String value) {
    if (value.toLowerCase() == 'true') return 'Yes';
    if (value.toLowerCase() == 'false') return 'No';

    return value;
  }

  static Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  static Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
              value.isEmpty ? 'Not specified' : value,
              style: const TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
