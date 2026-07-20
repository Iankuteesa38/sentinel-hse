import 'dart:io';
import 'package:flutter/material.dart';

import '../models/toolbox_talk_result.dart';
import '../../../services/storage_service.dart';

class ToolboxTalkReportPage extends StatelessWidget {
  final ToolboxTalkResult report;

  const ToolboxTalkReportPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final evidencePhotoPaths = report.evidencePhotoPath
        .split('|')
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
        .toList();

    final evidencePhotosFuture = Future.wait(
      evidencePhotoPaths.map((path) => StorageService.getInspectionImage(path)),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Toolbox Talk Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              report.topic,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(report.createdAt.toLocal().toString().split(' ').first),
            const SizedBox(height: 20),
            FutureBuilder<List<File?>>(
              future: evidencePhotosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final evidencePhotoFiles =
                    snapshot.data?.whereType<File>().toList() ?? [];

                if (evidencePhotoFiles.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Toolbox Talk Evidence Photos',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 230,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: evidencePhotoFiles.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      evidencePhotoFiles[index],
                                      height: 220,
                                      width: 280,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${index + 1}/${evidencePhotoFiles.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            _buildSection(title: 'Objective', items: [report.objective]),
            _buildSection(title: 'Key Hazards', items: report.keyHazards),
            _buildSection(
              title: 'Safety Precautions',
              items: report.safetyPrecautions,
            ),
            _buildSection(title: 'Required PPE', items: report.requiredPpe),
            _buildSection(
              title: 'Discussion Questions',
              items: report.discussionQuestions,
            ),
            _buildSection(
              title: 'Supervisor Message',
              items: [report.supervisorMessage],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<String> items}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• $item', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
