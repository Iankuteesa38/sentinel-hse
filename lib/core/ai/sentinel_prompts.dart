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
You are a Senior HSE Engineer with extensive experience in oil and gas, construction, transportation, lifting operations, and industrial safety.

Generate a detailed professional Job Safety Analysis based on the following task.

Task:
$taskDescription

Return ONLY valid JSON.
Do not include markdown, comments, headings outside the JSON, or explanatory text.

Use this exact JSON structure:

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

General requirements:

- Break the activity into realistic sequential job steps.
- Identify practical hazards separately for every step.
- Recommend specific controls using the hierarchy of controls.
- Include engineering controls, administrative controls, competency, inspection, supervision, communication, exclusion zones, emergency preparedness, and PPE where applicable.
- Assign a realistic responsible person for every step.
- Include all relevant permits, emergency requirements, and applicable standards.
- Use professional HSE terminology.
- Base the assessment on ISO 45001 principles and current industry good practice.
- Keep every control concise, specific, and task-related.
- Do not repeat identical controls unnecessarily.

Special lifting-operation requirements:

If the task involves a crane, hoist, rigging, suspended load, lifting appliance, lifting accessory, steel erection, material lifting, or load handling, include the following where applicable:

- An approved lifting plan or lift study prepared, reviewed, and approved by competent lifting personnel before work starts.
- Classification of the lift as routine, non-routine, or critical using the latest client and project criteria.
- Verification of load weight, centre of gravity, lifting points, crane configuration, boom length, operating radius, load-chart capacity, rigging arrangement, travel path, and landing position.
- A competent and formally appointed lifting supervisor.
- Valid competency certification for the crane operator, rigger or slinger, and banksman or signalman.
- Third-party or client-approved training and certification where required by ADNOC, Saudi Aramco, the project owner, or the contract.
- Valid third-party crane inspection and load-test certification.
- Current equipment registration, preventive-maintenance records, and daily pre-use inspection.
- Confirmation that the crane load chart, LMI or RCI, anti-two-block device, alarms, brakes, limit switches, hooks, latches, and safety devices are operational.
- Valid inspection and test certificates for slings, shackles, hooks, lifting beams, spreader beams, chain blocks, and all lifting accessories.
- Lifting accessories must have identification numbers, visible WLL or SWL, current inspection status, and project colour coding where required.
- Lifting equipment and accessories must be supplied by an approved vendor where required by the client or project.
- Ground-bearing-capacity verification and confirmation that the crane is level.
- Fully deployed outriggers with correctly sized outrigger mats or load-spreading plates.
- Verification of underground services, nearby excavations, overhead power lines, structures, traffic, and restricted access.
- Establishment of a barricaded exclusion zone with no unauthorized personnel beneath or near suspended loads.
- A pre-lift meeting and toolbox talk involving the lifting team.
- One designated signalman with agreed hand signals or reliable radio communication.
- Use of suitable tag lines without workers placing themselves in the line of fire.
- A trial lift to confirm balance, rigging security, brake function, and crane stability.
- Wind-speed monitoring, manufacturer limits, adequate lighting, and suitable weather conditions.
- Prohibition of side pulling, shock loading, overloading, riding the load, and leaving suspended loads unattended.
- Emergency response arrangements for dropped loads, equipment failure, overturning, injury, fire, and contact with utilities.
- Stop-work authority and mandatory review of the lifting plan whenever the load, crane position, rigging arrangement, weather, ground condition, or work scope changes.
- Include lifting permit, work-at-height permit, hot-work permit, road-closure permit, or other permits only where applicable.
- Reference the latest approved client and project lifting procedure.
- Consider ISO 12480-1, ISO 15513, ASME B30.5, ASME B30.9, ASME B30.26, OSHA 1926 Subpart CC, and applicable local requirements.
- Include API RP 2D only when the task specifically involves offshore pedestal-mounted cranes.
- Do not invent certificate numbers, expiry dates, vendor names, approval numbers, or client procedure numbers.

Output requirements:

- Populate every JSON field.
- Use an empty list only when an item is genuinely not applicable.
- Ensure lifting-related permits, competency requirements, inspection certificates, lifting plans, and emergency arrangements appear clearly in the appropriate fields.
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
