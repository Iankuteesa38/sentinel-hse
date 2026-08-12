import 'package:flutter/material.dart';

import 'new_investigation_page.dart';
import 'investigation_history_page.dart';

class InvestigationHomePage extends StatelessWidget {
  const InvestigationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Investigation'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Investigation Management',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('Create, analyse, track and close HSE investigations.'),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('New Investigation'),
              subtitle: const Text(
                'Start a new structured incident investigation',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewInvestigationPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Investigation History'),
              subtitle: const Text('Saved and completed investigations'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InvestigationHistoryPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.assignment_turned_in_outlined),
              title: Text('Open Investigation Actions'),
              subtitle: Text('Corrective actions and effectiveness reviews'),
            ),
          ),
        ],
      ),
    );
  }
}
