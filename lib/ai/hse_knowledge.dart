String? handleHseKnowledge(String question) {
  if (question.contains('risk assessment')) {
    return '''
RISK ASSESSMENT

A risk assessment identifies hazards, evaluates their likelihood and
consequences, determines the level of risk, and establishes suitable
control measures before work begins.

A suitable assessment should include:

•⁠  ⁠Activity or task
•⁠  ⁠Hazards
•⁠  ⁠Persons exposed
•⁠  ⁠Existing controls
•⁠  ⁠Initial risk rating
•⁠  ⁠Additional controls
•⁠  ⁠Residual risk rating
•⁠  ⁠Responsible person
•⁠  ⁠Review date
''';
  }

  if (question == 'jsa' ||
      question.contains('job safety analysis') ||
      question.contains('job hazard analysis')) {
    return '''
JOB SAFETY ANALYSIS

A Job Safety Analysis breaks a task into logical steps, identifies the
hazards associated with each step, and specifies the controls required
to perform the work safely.

A suitable JSA should include:

•⁠  ⁠Task steps
•⁠  ⁠Hazards for every step
•⁠  ⁠Control measures
•⁠  ⁠Required PPE
•⁠  ⁠Required permits
•⁠  ⁠Responsible persons
•⁠  ⁠Emergency arrangements
•⁠  ⁠Workforce briefing and acknowledgment
''';
  }

  if (question == 'ppe' ||
      question.contains('personal protective equipment') ||
      question.contains('required ppe') ||
      question.contains('ppe requirements')) {
    return '''
COMMON PERSONAL PROTECTIVE EQUIPMENT

•⁠  ⁠Safety helmet
•⁠  ⁠Safety shoes
•⁠  ⁠Gloves
•⁠  ⁠Safety glasses
•⁠  ⁠Coveralls
•⁠  ⁠High-visibility vest
•⁠  ⁠Hearing protection
•⁠  ⁠Respiratory protection where required

PPE must be selected according to the task hazards and must not replace
more effective engineering or administrative controls.
''';
  }

  if (question.contains('fire extinguisher') ||
      question.contains('types of extinguisher') ||
      question.contains('extinguisher types')) {
    return '''
COMMON FIRE EXTINGUISHERS

•⁠  ⁠Water
•⁠  ⁠Foam
•⁠  ⁠Carbon dioxide
•⁠  ⁠Dry powder
•⁠  ⁠Wet chemical

The extinguisher must be selected according to the fire classification.
Personnel should attempt firefighting only when trained, the alarm has
been raised, and a safe escape route remains available.
''';
  }

  if (question.contains('confined space requirements') ||
      question.contains('confined-space entry requirements') ||
      question.contains('confined-space entry') ||
      question.contains('entry permit')) {
    return '''
CONFINED-SPACE ENTRY REQUIREMENTS

•⁠  ⁠Approved entry permit
•⁠  ⁠Atmospheric gas testing
•⁠  ⁠Continuous atmospheric monitoring
•⁠  ⁠Mechanical ventilation where required
•⁠  ⁠Trained standby attendant
•⁠  ⁠Reliable communication
•⁠  ⁠Isolation and Lock Out Tag Out
•⁠  ⁠Rescue plan and suitable rescue equipment
•⁠  ⁠Controlled entry and exit
''';
  }

  if (question.contains('working at height requirements') ||
      question.contains('work at height requirements') ||
      question.contains('working at height ppe')) {
    return '''
WORKING AT HEIGHT REQUIREMENTS

•⁠  ⁠Approved work-at-height permit
•⁠  ⁠Inspected access equipment
•⁠  ⁠Full-body harness
•⁠  ⁠Suitable lanyard or fall-arrest device
•⁠  ⁠Approved anchor point
•⁠  ⁠Safety helmet with chin strap
•⁠  ⁠Guardrails and toe boards where applicable
•⁠  ⁠Barricading below the work area
•⁠  ⁠Rescue plan
•⁠  ⁠Competent supervision
''';
  }

  return null;
}
