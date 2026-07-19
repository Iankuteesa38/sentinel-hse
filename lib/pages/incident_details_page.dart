import 'package:flutter/material.dart';

class IncidentDetailsPage extends StatelessWidget {
  final String incident;

  const IncidentDetailsPage({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    final lines = incident
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Incident Report')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final line = lines[index];
          final separatorIndex = line.indexOf(':');

          if (separatorIndex == -1) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                line,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            );
          }

          final title = line.substring(0, separatorIndex).trim();
          final value = line.substring(separatorIndex + 1).trim();

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value.isEmpty ? 'Not provided' : value,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
