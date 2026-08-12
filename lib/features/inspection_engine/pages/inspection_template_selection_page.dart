import 'package:flutter/material.dart';

import '../services/inspection_engine_service.dart';
import 'inspection_checklist_page.dart';
import 'inspection_history_page.dart';

class InspectionTemplateSelectionPage extends StatelessWidget {
  const InspectionTemplateSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final templates = const InspectionEngineService().getAvailableTemplates();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Inspection History',
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InspectionHistoryPage(),
                ),
              );
            },
          ),
        ],
        title: const Text('Inspection Templates'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.assignment, color: Colors.blue),
              title: Text(template.title),
              subtitle: Text(template.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        InspectionChecklistPage(template: template),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
