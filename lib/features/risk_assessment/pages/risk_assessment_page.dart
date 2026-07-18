import 'package:flutter/material.dart';

import '../models/risk_assessment_result.dart';
import '../services/risk_assessment_service.dart';
import '../widgets/risk_assessment_card.dart';

class RiskAssessmentPage extends StatefulWidget {
  const RiskAssessmentPage({super.key});

  @override
  State<RiskAssessmentPage> createState() => _RiskAssessmentPageState();
}

class _RiskAssessmentPageState extends State<RiskAssessmentPage> {
  final TextEditingController taskController = TextEditingController();

  RiskAssessmentResult? assessment;
  bool isLoading = false;

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  Widget _bulletList(List<String> items) {
    if (items.isEmpty) {
      return const Text('• Not specified', style: TextStyle(fontSize: 16));
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

  Color _riskColor(String riskLevel) {
    final level = riskLevel.toLowerCase();

    if (level.contains('low')) {
      return Colors.green;
    }

    if (level.contains('medium')) {
      return Colors.amber.shade700;
    }

    if (level.contains('high')) {
      return Colors.orange;
    }

    if (level.contains('critical') || level.contains('extreme')) {
      return Colors.red;
    }

    return Colors.grey;
  }

  Widget _riskBadge(String riskLevel) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _riskColor(riskLevel),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          riskLevel.isEmpty ? 'NOT SPECIFIED' : riskLevel.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Future<void> _generateRiskAssessment() async {
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
      assessment = null;
    });

    try {
      final result = await RiskAssessmentService.generateRiskAssessment(
        taskDescription: taskDescription,
      );

      if (!mounted) return;

      setState(() {
        assessment = result;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to generate risk assessment: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = assessment;

    return Scaffold(
      appBar: AppBar(title: const Text('AI Risk Assessment')),
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
                  hintText: 'Example: Excavation for underground utilities',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _generateRiskAssessment,
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
                label: Text(
                  isLoading ? 'Generating...' : 'Generate Risk Assessment',
                ),
              ),
              if (result != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'AI Risk Assessment Result',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Task',
                  icon: Icons.assignment_outlined,
                  backgroundColor: Colors.blue.shade50,
                  child: Text(
                    result.task,
                    style: const TextStyle(fontSize: 16, height: 1.35),
                  ),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Hazards',
                  icon: Icons.warning_amber_rounded,
                  backgroundColor: Colors.amber.shade50,
                  child: _bulletList(result.hazards),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Persons at Risk',
                  icon: Icons.groups_outlined,
                  backgroundColor: Colors.blueGrey.shade50,
                  child: _bulletList(result.personsAtRisk),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Existing Controls',
                  icon: Icons.shield_outlined,
                  backgroundColor: Colors.green.shade50,
                  child: _bulletList(result.existingControls),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Additional Controls',
                  icon: Icons.add_task_outlined,
                  backgroundColor: Colors.orange.shade50,
                  child: _bulletList(result.additionalControls),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Initial Risk',
                  icon: Icons.trending_up,
                  backgroundColor: Colors.red.shade50,
                  child: _riskBadge(result.initialRisk),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Residual Risk',
                  icon: Icons.trending_down,
                  backgroundColor: Colors.green.shade50,
                  child: _riskBadge(result.residualRisk),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Required PPE',
                  icon: Icons.health_and_safety_outlined,
                  backgroundColor: Colors.indigo.shade50,
                  child: _bulletList(result.requiredPpe),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Required Permits',
                  icon: Icons.description_outlined,
                  backgroundColor: Colors.purple.shade50,
                  child: _bulletList(result.requiredPermits),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Emergency Response',
                  icon: Icons.emergency_outlined,
                  backgroundColor: Colors.red.shade50,
                  child: _bulletList(result.emergencyResponse),
                ),
                const SizedBox(height: 16),

                RiskAssessmentCard(
                  title: 'Applicable Standards',
                  icon: Icons.menu_book_outlined,
                  backgroundColor: Colors.teal.shade50,
                  child: _bulletList(result.applicableStandards),
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
