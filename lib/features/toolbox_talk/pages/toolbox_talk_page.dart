import 'package:flutter/material.dart';

import '../models/toolbox_talk_result.dart';
import '../services/toolbox_talk_service.dart';
import '../services/toolbox_talk_pdf_service.dart';
import '../storage/toolbox_talk_storage_service.dart';

class ToolboxTalkPage extends StatefulWidget {
  const ToolboxTalkPage({super.key});

  @override
  State<ToolboxTalkPage> createState() => _ToolboxTalkPageState();
}

class _ToolboxTalkPageState extends State<ToolboxTalkPage> {
  final TextEditingController _topicController = TextEditingController();
  final ToolboxTalkService _service = const ToolboxTalkService();

  ToolboxTalkResult? _result;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _generateToolboxTalk() async {
    final topic = _topicController.text.trim();
    FocusScope.of(context).unfocus();
    if (topic.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a toolbox talk topic.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await _service.generateToolboxTalk(topic: topic);

      if (!mounted) return;

      setState(() {
        _result = result;
      });
      await ToolboxTalkStorageService.saveReport(result);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Unable to generate toolbox talk.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required IconData icon,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Toolbox Talk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _topicController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Toolbox Talk Topic',
                hintText: 'Example: Working at height',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _generateToolboxTalk,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Toolbox Talk'),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            if (_result != null) ...[
              Text(
                _result!.topic,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              _buildSection(
                title: 'Objective',
                items: [_result!.objective],
                icon: Icons.flag_outlined,
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () async {
                  await ToolboxTalkPdfService.generateReport(result: _result!);
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate PDF'),
              ),
              _buildSection(
                title: 'Key Hazards',
                items: _result!.keyHazards,
                icon: Icons.warning_amber_outlined,
              ),

              _buildSection(
                title: 'Safety Precautions',
                items: _result!.safetyPrecautions,
                icon: Icons.health_and_safety_outlined,
              ),

              _buildSection(
                title: 'Required PPE',
                items: _result!.requiredPpe,
                icon: Icons.engineering_outlined,
              ),

              _buildSection(
                title: 'Discussion Questions',
                items: _result!.discussionQuestions,
                icon: Icons.question_answer_outlined,
              ),

              _buildSection(
                title: 'Supervisor Message',
                items: [_result!.supervisorMessage],
                icon: Icons.record_voice_over_outlined,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
