import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';

class HazardHistoryPage extends StatefulWidget {
  const HazardHistoryPage({super.key});

  @override
  State<HazardHistoryPage> createState() => _HazardHistoryPageState();
}

class _HazardHistoryPageState extends State<HazardHistoryPage> {
  List<String> hazards = [];

  @override
  void initState() {
    super.initState();
    loadHazards();
  }

  Future<void> loadHazards() async {
    final savedHazards = await StorageService.getHazards();

    setState(() {
      hazards = savedHazards;
    });
  }

  Future<void> closeHazard(int index) async {
    final updatedHazards = List<String>.from(hazards);
    final currentHazard = updatedHazards[index];

    if (currentHazard.toLowerCase().contains('status: closed')) {
      return;
    }

    if (currentHazard.contains('Status: Open')) {
      updatedHazards[index] = currentHazard.replaceFirst(
        'Status: Open',
        'Status: Closed',
      );
    } else if (currentHazard.contains('status: Open')) {
      updatedHazards[index] = currentHazard.replaceFirst(
        'status: Open',
        'status: Closed',
      );
    } else {
      updatedHazards[index] = '$currentHazard\nStatus: Closed';
    }

    await StorageService.saveHazards(updatedHazards);

    if (!mounted) return;

    setState(() {
      hazards = updatedHazards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hazard History")),
      body: hazards.isEmpty
          ? const Center(child: Text("No hazards yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hazards.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber),
                    title: Text("Hazard ${index + 1}"),
                    subtitle: Text(hazards[index]),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) async {
                        if (value == 'pdf') {
                          await PdfService.generateTextHazardReport(
                            hazardNumber: index + 1,
                            hazardData: hazards[index],
                          );
                        } else if (value == 'close') {
                          await closeHazard(index);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'pdf',
                          child: Row(
                            children: [
                              Icon(Icons.picture_as_pdf),
                              SizedBox(width: 10),
                              Text('Generate PDF'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'close',
                          child: Row(
                            children: [
                              Icon(Icons.check),
                              SizedBox(width: 10),
                              Text('Close Hazard'),
                            ],
                          ),
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
