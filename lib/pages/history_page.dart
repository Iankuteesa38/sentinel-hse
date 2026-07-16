import 'dart:io';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> inspections = [];

  @override
  void initState() {
    super.initState();
    _loadInspections();
  }

  Future<void> _loadInspections() async {
    final savedInspections = await StorageService.getInspections();

    setState(() {
      inspections = savedInspections;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await StorageService.clearInspections();

              setState(() {
                inspections.clear();
              });
            },
          ),
        ],
      ),
      body: inspections.isEmpty
          ? const Center(
              child: Text(
                "No inspections yet",
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: inspections.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.assignment),
                    title: Text("Inspection ${index + 1}"),
subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
  inspections[index].split("Photo:").first,
),
    const SizedBox(height: 10),
    if (inspections[index].contains("Photo:"))
      Builder(
        builder: (context) {
          final photoPath =
              inspections[index].split("Photo:").last.trim();

          if (File(photoPath).existsSync()) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(photoPath),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }

          return const Text("Photo not found");
        },
      ),
  ],
),                  ),
                );
              },
            ),
    );
  }
}