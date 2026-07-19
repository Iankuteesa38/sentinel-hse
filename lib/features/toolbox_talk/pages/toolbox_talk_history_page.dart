import 'package:flutter/material.dart';

import '../models/toolbox_talk_result.dart';
import '../storage/toolbox_talk_storage_service.dart';

class ToolboxTalkHistoryPage extends StatefulWidget {
  const ToolboxTalkHistoryPage({super.key});

  @override
  State<ToolboxTalkHistoryPage> createState() => _ToolboxTalkHistoryPageState();
}

class _ToolboxTalkHistoryPageState extends State<ToolboxTalkHistoryPage> {
  late Future<List<ToolboxTalkResult>> _reports;

  @override
  void initState() {
    super.initState();
    _reports = ToolboxTalkStorageService.getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toolbox Talk History')),
      body: FutureBuilder<List<ToolboxTalkResult>>(
        future: _reports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return const Center(child: Text('No Toolbox Talks generated yet.'));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return ListTile(
                leading: const Icon(Icons.record_voice_over),
                title: Text(report.topic),
                subtitle: Text(report.objective),
              );
            },
          );
        },
      ),
    );
  }
}
