import 'package:flutter/material.dart';
import 'inspection_history_page.dart';
import 'hazard_history_page.dart';
import 'incident_history_page.dart';

class PDFReportsPage extends StatelessWidget {
  const PDFReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Reports"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.assignment, color: Colors.blue),
              title: const Text("Inspection Report"),
              subtitle: const Text("Select an inspection to generate its PDF"),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InspectionHistoryPage(),
                    ),
                  );
                },
                child: const Text("Select"),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.orange),
              title: const Text("Hazard Report"),
              subtitle: const Text("Select a hazard record to review"),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HazardHistoryPage(),
                    ),
                  );
                },
                child: const Text("Generate"),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text("Corrective Action Report"),
              subtitle: const Text("Generate Action PDF"),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Action PDF coming next...")),
                  );
                },
                child: const Text("Generate"),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.smart_toy, color: Colors.deepPurple),
              title: const Text("AI Incident Investigation"),
              subtitle: const Text("Generate AI Investigation PDF"),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IncidentHistoryPage(),
                    ),
                  );
                },
                child: const Text("Generate"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
