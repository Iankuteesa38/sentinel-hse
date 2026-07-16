String? handleToolboxTalk(String question) {
  final isToolboxRequest =
      question.contains('toolbox') ||
      question.contains('tool box') ||
      question.contains('tbt');

  if (!isToolboxRequest) {
    return null;
  }

  if (question.contains('working at height') ||
      question.contains('work at height') ||
      question.contains('scaffold') ||
      question.contains('ladder')) {
    return '''
TOOLBOX TALK

Topic:
Working at Height

Hazards:
•⁠  ⁠Falling from height
•⁠  ⁠Falling objects
•⁠  ⁠Scaffold or ladder failure
•⁠  ⁠Slips and trips
•⁠  ⁠Suspension trauma after a fall

Required PPE:
•⁠  ⁠Full-body harness
•⁠  ⁠Suitable lanyard or fall-arrest device
•⁠  ⁠Helmet with chin strap
•⁠  ⁠Safety shoes
•⁠  ⁠Gloves

Control Measures:
•⁠  ⁠Inspect access and fall-protection equipment before use.
•⁠  ⁠Use only approved anchor points.
•⁠  ⁠Maintain 100% tie-off where required.
•⁠  ⁠Install guardrails and toe boards.
•⁠  ⁠Secure all tools and materials.
•⁠  ⁠Barricade the area below.
•⁠  ⁠Stop work during unsafe weather.
•⁠  ⁠Maintain effective supervision.

Emergency Response:
•⁠  ⁠Stop work immediately.
•⁠  ⁠Raise the alarm.
•⁠  ⁠Inform the supervisor.
•⁠  ⁠Activate the work-at-height rescue plan.
•⁠  ⁠Do not rely only on emergency services for suspended-worker rescue.
''';
  }

  return '''
TOOLBOX TALK REQUEST

Please include the toolbox-talk topic.

Examples:
•⁠  ⁠Toolbox talk for working at height
•⁠  ⁠Toolbox talk for lifting operations
•⁠  ⁠Toolbox talk for excavation
•⁠  ⁠Toolbox talk for confined-space entry
''';
}
