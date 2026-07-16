import 'package:flutter/material.dart';

import '../ai/ai_router.dart';
import '../ai/project_summary.dart';

class AIAssistantPage extends StatefulWidget {
  final int safetyScore;
  final int totalHazards;
  final int openActions;
  final int closedActions;
  final int highRiskInspections;
  final int overdueActions;
  final String projectStatus;

  const AIAssistantPage({
    super.key,
    required this.safetyScore,
    required this.totalHazards,
    required this.openActions,
    required this.closedActions,
    required this.highRiskInspections,
    required this.overdueActions,
    required this.projectStatus,
  });

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController questionController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<Map<String, String>> messages = [];

  late String response;

  @override
  void initState() {
    super.initState();

    response = projectSafetySummary;

    messages.add({'role': 'assistant', 'text': response});
  }

  String get projectSafetySummary {
    return buildProjectSafetySummary(
      safetyScore: widget.safetyScore,
      totalHazards: widget.totalHazards,
      openActions: widget.openActions,
      closedActions: widget.closedActions,
      highRiskInspections: widget.highRiskInspections,
      overdueActions: widget.overdueActions,
      projectStatus: widget.projectStatus,
    );
  }

  void askQuestion() {
    final originalQuestion = questionController.text.trim();

    if (originalQuestion.isEmpty) {
      const emptyResponse = 'Please enter an HSE question.';

      setState(() {
        response = emptyResponse;

        messages.add({'role': 'assistant', 'text': emptyResponse});
      });

      _scrollToBottom();
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final normalizedQuestion = originalQuestion.toLowerCase();

    final generatedResponse = routeAiQuestion(
      question: normalizedQuestion,
      projectSummary: projectSafetySummary,
    );

    setState(() {
      messages.add({'role': 'user', 'text': originalQuestion});

      response = generatedResponse;

      messages.add({'role': 'assistant', 'text': generatedResponse});

      questionController.clear();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    questionController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Safety Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'Ask an HSE question',
                hintText: 'Example: Show project safety summary',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: askQuestion,
                icon: const Icon(Icons.smart_toy),
                label: const Text('Ask Sentinel AI'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message['role'] == 'user';

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 320),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
