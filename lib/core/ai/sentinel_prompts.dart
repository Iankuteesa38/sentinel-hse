class SentinelPrompts {
  SentinelPrompts._();

  static String riskAssessmentPrompt({required String taskDescription}) {
    return '''
You are a Senior HSE Engineer with extensive experience in oil & gas, construction, transportation, and industrial safety.

Generate a professional risk assessment based on the following task.

Task:
$taskDescription

Return ONLY valid JSON.

Required structure:

{
  "task": "",
  "hazards": [],
  "personsAtRisk": [],
  "existingControls": [],
  "additionalControls": [],
  "initialRisk": "",
  "residualRisk": "",
  "requiredPpe": [],
  "requiredPermits": [],
  "emergencyResponse": [],
  "applicableStandards": []
}

Requirements:

- Use professional HSE terminology.
- Base recommendations on ISO 45001 best practices.
- Recommend realistic control measures.
- Be concise and practical.
- Do not include explanations outside the JSON.
''';
  }

  static String jsaPrompt({required String taskDescription}) {
    return '''
You are a Senior HSE Engineer with extensive experience in oil and gas, construction, transportation, and industrial safety.

Generate a professional Job Safety Analysis based on the following task.

Task:
$taskDescription

Return ONLY valid JSON.

Required structure:

{
  "task": "",
  "steps": [
    {
      "jobStep": "",
      "hazards": [],
      "controlMeasures": [],
      "requiredPpe": [],
      "responsiblePerson": ""
    }
  ],
  "permits": [],
  "emergencyRequirements": [],
  "applicableStandards": []
}

Requirements:

- Break the task into realistic sequential job steps.
- Identify practical hazards for each step.
- Recommend suitable control measures using the hierarchy of controls.
- Specify appropriate PPE for each step.
- Assign a realistic responsible person.
- Include relevant permits, emergency requirements, and standards.
- Use professional HSE terminology.
- Base recommendations on ISO 45001 best practices.
- Be concise and practical.
- Do not include explanations outside the JSON.
''';
  }

  static String toolboxTalkPrompt({required String topic}) {
    return '''
Create a professional toolbox talk for this topic:

$topic

Return valid JSON only using this structure:

{
  "topic": "",
  "objective": "",
  "keyHazards": [],
  "safetyPrecautions": [],
  "requiredPpe": [],
  "discussionQuestions": [],
  "supervisorMessage": ""
}
''';
  }
}
