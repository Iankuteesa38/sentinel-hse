import 'package:flutter/material.dart';

import '../models/jsa_result.dart';
import '../services/jsa_service.dart';
import '../services/jsa_pdf_service.dart';
import '../widgets/jsa_card.dart';

class JsaPage extends StatefulWidget {
  const JsaPage({super.key});

  @override
  State<JsaPage> createState() => _JsaPageState();
}

class _JsaPageState extends State<JsaPage> {
  final TextEditingController taskController = TextEditingController();

  JsaResult? result;
  bool isLoading = false;

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  Widget _bulletList(List<String> items) {
    if (items.isEmpty) {
      return const Text(
        '• Not specified',
        style: TextStyle(fontSize: 16, height: 1.35),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '• $item',
                style: const TextStyle(fontSize: 16, height: 1.35),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _generateJsa() async {
    final taskDescription = taskController.text.trim();

    if (taskDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task description.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      result = null;
    });

    try {
      final generatedResult = await JsaService.generateJsa(
        taskDescription: taskDescription,
      );

      if (!mounted) return;

      setState(() {
        result = generatedResult;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to generate JSA: $error')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildStepCard(JsaStep step, int index) {
    return JsaCard(
      title: 'Job Step ${index + 1}',
      icon: Icons.format_list_numbered,
      backgroundColor: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.jobStep.isEmpty ? 'Not specified' : step.jobStep,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Hazards',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _bulletList(step.hazards),

          const SizedBox(height: 16),
          const Text(
            'Control Measures',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _bulletList(step.controlMeasures),

          const SizedBox(height: 16),
          const Text(
            'Required PPE',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _bulletList(step.requiredPpe),

          const SizedBox(height: 16),
          const Text(
            'Responsible Person',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            step.responsiblePerson.isEmpty
                ? 'Not specified'
                : step.responsiblePerson,
            style: const TextStyle(fontSize: 16, height: 1.35),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jsaResult = result;

    return Scaffold(
      appBar: AppBar(title: const Text('AI JSA Generator')),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: taskController,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                  hintText: 'Example: Installation of steel structure',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: isLoading ? null : _generateJsa,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(isLoading ? 'Generating...' : 'Generate JSA'),
              ),

              if (jsaResult != null) ...[
                ElevatedButton.icon(
                  onPressed: () async {
                    await JsaPdfService.generateReport(result: jsaResult);
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Generate PDF'),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Job Safety Analysis',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                JsaCard(
                  title: 'Task',
                  icon: Icons.assignment_outlined,
                  backgroundColor: Colors.indigo.shade50,
                  child: Text(
                    jsaResult.task.isEmpty ? 'Not specified' : jsaResult.task,
                    style: const TextStyle(fontSize: 16, height: 1.35),
                  ),
                ),
                const SizedBox(height: 16),

                ...jsaResult.steps.asMap().entries.expand(
                  (entry) => [
                    _buildStepCard(entry.value, entry.key),
                    const SizedBox(height: 16),
                  ],
                ),

                JsaCard(
                  title: 'Required Permits',
                  icon: Icons.description_outlined,
                  backgroundColor: Colors.purple.shade50,
                  child: _bulletList(jsaResult.permits),
                ),
                const SizedBox(height: 16),

                JsaCard(
                  title: 'Emergency Requirements',
                  icon: Icons.emergency_outlined,
                  backgroundColor: Colors.red.shade50,
                  child: _bulletList(jsaResult.emergencyRequirements),
                ),
                const SizedBox(height: 16),

                JsaCard(
                  title: 'Applicable Standards',
                  icon: Icons.menu_book_outlined,
                  backgroundColor: Colors.teal.shade50,
                  child: _bulletList(jsaResult.applicableStandards),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
