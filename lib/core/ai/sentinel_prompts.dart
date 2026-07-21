class SentinelPrompts {
  SentinelPrompts._();

  static String riskAssessmentPrompt({required String taskDescription}) {
    return '''
You are a Senior HSE Engineer with extensive experience in oil and gas, construction, transportation, infrastructure, and industrial safety.

Prepare a detailed professional task risk assessment for:

Task:
$taskDescription

Return ONLY valid JSON.
Do not use markdown, comments, headings outside the JSON, or explanatory text.

Use this exact JSON structure:

{
  "task": "",
  "entries": [
    {
      "hazard": "",
      "causes": [],
      "topEvent": "",
      "consequences": [],
      "personsAtRisk": [],
      "preventiveControls": [],
      "mitigationMeasures": [],
      "initialRating": {
        "severity": 1,
        "likelihood": "A",
        "rating": "1A"
      },
      "residualRating": {
        "severity": 1,
        "likelihood": "A",
        "rating": "1A"
      },
      "recommendedActions": []
    }
  ],
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

Risk-rating rules:

- Severity must be an integer from 1 to 5.
- Likelihood must be one letter from A to E.
- A = Rare.
- B = Unlikely.
- C = Possible.
- D = Likely.
- E = Almost Certain.
- Rating must combine severity and likelihood, for example 4D.
- Residual risk must realistically reflect the effect of the proposed controls.
- Residual risk should normally be lower than the initial risk.

Assessment requirements:

- Create between 6 and 12 distinct hazard entries.
- Assess each hazard separately.
- Identify credible causes or threats for every hazard.
- State a clear top event for every hazard.
- Identify realistic consequences and persons at risk.
- Separate preventive controls from mitigation or recovery measures.
- Include practical recommended actions for further improvement.
- Apply the hierarchy of controls wherever reasonably practicable.
- Include engineering controls, administrative controls, supervision, competency, inspection, emergency preparedness, and PPE where relevant.
- Use professional HSE terminology.
- Keep each control measure concise and specific.
- Do not repeat identical controls unnecessarily.
- Include task-specific permits, PPE, emergency arrangements, and applicable standards.
- Base the assessment on ISO 45001 principles and relevant industry good practice.
- The legacy summary fields must summarize the detailed entries for compatibility with existing Sentinel HSE reports.
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
