import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/inspection_record.dart';
import '../services/storage_service.dart';
import 'inspection_details_page.dart';

class InspectionHistoryPage extends StatefulWidget {
  const InspectionHistoryPage({super.key});

  @override
  State<InspectionHistoryPage> createState() => _InspectionHistoryPageState();
}

class _InspectionHistoryPageState extends State<InspectionHistoryPage> {
  List<InspectionRecord> inspections = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInspections();
  }

  Future<void> loadInspections() async {
    await StorageService.migrateLegacyHazardRecords();
    final savedInspections = await StorageService.getInspectionRecords();

    if (!mounted) return;

    setState(() {
      inspections = savedInspections;
      isLoading = false;
    });
  }

  Future<void> deleteInspection(InspectionRecord record) async {
    await StorageService.deleteInspectionRecord(record.inspectionId);

    if (!mounted) return;

    setState(() {
      inspections.removeWhere(
        (item) => item.inspectionId == record.inspectionId,
      );
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Inspection deleted')));
  }

  Future<void> confirmDelete(InspectionRecord record) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete inspection?'),
          content: Text('Delete ${record.inspectionId} permanently?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await deleteInspection(record);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inspection History')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : inspections.isEmpty
          ? const Center(
              child: Text(
                'No inspection records yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: loadInspections,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: inspections.length,
                itemBuilder: (context, index) {
                  final record = inspections[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InspectionDetailsPage(record: record),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (record.imagePath.isNotEmpty &&
                                File(record.imagePath).existsSync())
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(record.imagePath),
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              record.inspectionId,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('Inspector: ${record.inspector}'),
                            Text('Location: ${record.location}'),
                            Text(
                              'Date: ${DateFormat('dd MMM yyyy, HH:mm').format(record.createdAt)}',
                            ),
                            Text('Status: ${record.status}'),
                            const SizedBox(height: 12),
                            Text(
                              record.analysis,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => confirmDelete(record),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
