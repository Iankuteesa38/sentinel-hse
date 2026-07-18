class ToolboxTalkResult {
  final String topic;
  final String objective;
  final List<String> keyHazards;
  final List<String> safetyPrecautions;
  final List<String> requiredPpe;
  final List<String> discussionQuestions;
  final String supervisorMessage;

  const ToolboxTalkResult({
    required this.topic,
    required this.objective,
    required this.keyHazards,
    required this.safetyPrecautions,
    required this.requiredPpe,
    required this.discussionQuestions,
    required this.supervisorMessage,
  });

  factory ToolboxTalkResult.fromJson(Map<String, dynamic> json) {
    return ToolboxTalkResult(
      topic: json['topic']?.toString() ?? '',
      objective: json['objective']?.toString() ?? '',
      keyHazards: List<String>.from(json['keyHazards'] ?? const []),
      safetyPrecautions: List<String>.from(
        json['safetyPrecautions'] ?? const [],
      ),
      requiredPpe: List<String>.from(json['requiredPpe'] ?? const []),
      discussionQuestions: List<String>.from(
        json['discussionQuestions'] ?? const [],
      ),
      supervisorMessage: json['supervisorMessage']?.toString() ?? '',
    );
  }
}
