enum RiskLevel { low, medium, high, extreme }

class RiskRating {
  final int likelihood;
  final int consequence;
  final int score;
  final RiskLevel level;

  const RiskRating({
    required this.likelihood,
    required this.consequence,
    required this.score,
    required this.level,
  });

  String get levelLabel {
    switch (level) {
      case RiskLevel.low:
        return 'LOW';
      case RiskLevel.medium:
        return 'MEDIUM';
      case RiskLevel.high:
        return 'HIGH';
      case RiskLevel.extreme:
        return 'EXTREME';
    }
  }
}

RiskRating calculateRiskRating({
  required int likelihood,
  required int consequence,
}) {
  if (likelihood < 1 || likelihood > 5) {
    throw ArgumentError.value(
      likelihood,
      'likelihood',
      'Likelihood must be between 1 and 5.',
    );
  }

  if (consequence < 1 || consequence > 5) {
    throw ArgumentError.value(
      consequence,
      'consequence',
      'Consequence must be between 1 and 5.',
    );
  }

  final score = likelihood * consequence;

  final RiskLevel level;

  if (score <= 4) {
    level = RiskLevel.low;
  } else if (score <= 9) {
    level = RiskLevel.medium;
  } else if (score <= 16) {
    level = RiskLevel.high;
  } else {
    level = RiskLevel.extreme;
  }

  return RiskRating(
    likelihood: likelihood,
    consequence: consequence,
    score: score,
    level: level,
  );
}

String likelihoodLabel(int likelihood) {
  switch (likelihood) {
    case 1:
      return 'Rare';
    case 2:
      return 'Unlikely';
    case 3:
      return 'Possible';
    case 4:
      return 'Likely';
    case 5:
      return 'Almost Certain';
    default:
      throw ArgumentError.value(
        likelihood,
        'likelihood',
        'Likelihood must be between 1 and 5.',
      );
  }
}

String consequenceLabel(int consequence) {
  switch (consequence) {
    case 1:
      return 'Insignificant';
    case 2:
      return 'Minor';
    case 3:
      return 'Moderate';
    case 4:
      return 'Major';
    case 5:
      return 'Catastrophic';
    default:
      throw ArgumentError.value(
        consequence,
        'consequence',
        'Consequence must be between 1 and 5.',
      );
  }
}

class RiskAssessmentReport {
  final String activity;
  final List<String> hazards;
  final List<String> personsExposed;
  final List<String> existingControls;
  final List<String> additionalControls;
  final List<String> requiredPpe;
  final List<String> requiredPermits;
  final List<String> emergencyArrangements;
  final List<String> environmentalControls;
  final RiskRating initialRisk;
  final RiskRating residualRisk;
  final String responsiblePerson;
  final String reviewRequirement;

  const RiskAssessmentReport({
    required this.activity,
    required this.hazards,
    required this.personsExposed,
    required this.existingControls,
    required this.additionalControls,
    required this.requiredPpe,
    required this.requiredPermits,
    required this.emergencyArrangements,
    required this.environmentalControls,
    required this.initialRisk,
    required this.residualRisk,
    required this.responsiblePerson,
    required this.reviewRequirement,
  });

  String get formattedText {
    return '''
SENTINEL AI RISK ASSESSMENT

Activity:
$activity

Persons Exposed:
${_formatItems(personsExposed)}

Hazards Identified:
${_formatItems(hazards)}

INITIAL RISK

Likelihood:
${initialRisk.likelihood} - ${likelihoodLabel(initialRisk.likelihood)}

Consequence:
${initialRisk.consequence} - ${consequenceLabel(initialRisk.consequence)}

Risk Score:
${initialRisk.score} / 25

Risk Level:
${initialRisk.levelLabel}

Existing Controls:
${_formatItems(existingControls)}

Additional Control Measures:
${_formatItems(additionalControls)}

Required PPE:
${_formatItems(requiredPpe)}

Required Permits and Documents:
${_formatItems(requiredPermits)}

Emergency Arrangements:
${_formatItems(emergencyArrangements)}

Environmental Controls:
${_formatItems(environmentalControls)}

RESIDUAL RISK

Likelihood:
${residualRisk.likelihood} - ${likelihoodLabel(residualRisk.likelihood)}

Consequence:
${residualRisk.consequence} - ${consequenceLabel(residualRisk.consequence)}

Risk Score:
${residualRisk.score} / 25

Risk Level:
${residualRisk.levelLabel}

Responsible Person:
$responsiblePerson

Review Requirement:
$reviewRequirement
''';
  }
}

String _formatItems(List<String> items) {
  if (items.isEmpty) {
    return '• Not specified';
  }

  return items.map((item) => '• $item').join('\n');
}

RiskAssessmentReport buildWeldingRiskAssessment() {
  final initialRisk = calculateRiskRating(likelihood: 4, consequence: 5);

  final residualRisk = calculateRiskRating(likelihood: 2, consequence: 3);

  return RiskAssessmentReport(
    activity: 'Welding Operation',

    hazards: ['Fire', 'Burns', 'Electric shock', 'Arc flash', 'Welding fumes'],

    personsExposed: ['Welder', 'Fire watcher', 'Nearby workers'],

    existingControls: [
      'Approved Hot Work Permit',
      'Qualified welder',
      'Fire extinguisher available',
    ],

    additionalControls: [
      'Assign fire watcher',
      'Barricade work area',
      'Continuous supervision',
    ],

    requiredPpe: [
      'Welding helmet',
      'Leather gloves',
      'Flame-resistant coveralls',
      'Safety boots',
    ],

    requiredPermits: ['Hot Work Permit'],

    emergencyArrangements: [
      'Raise alarm',
      'Emergency response team',
      'Fire extinguisher',
    ],

    environmentalControls: [
      'Control sparks',
      'Protect nearby combustible materials',
    ],

    initialRisk: initialRisk,
    residualRisk: residualRisk,

    responsiblePerson: 'Site Supervisor',

    reviewRequirement: 'Review before every welding activity.',
  );
}

String? handleRiskAssessment(String question) {
  if (question.contains('risk assessment') && question.contains('welding')) {
    return buildWeldingRiskAssessment().formattedText;
  }
  if (question.contains('risk assessment') &&
      (question.contains('working at height') ||
          question.contains('work at height') ||
          question.contains('scaffold') ||
          question.contains('ladder'))) {
    return buildWorkingAtHeightRiskAssessment().formattedText;
  }
  if (question.contains('risk assessment') &&
      question.contains('confined space')) {
    return buildConfinedSpaceRiskAssessment().formattedText;
  }
  if (question.contains('risk assessment') &&
      (question.contains('excavation') ||
          question.contains('trench') ||
          question.contains('digging'))) {
    return buildExcavationRiskAssessment().formattedText;
  }
  if (question.contains('risk assessment') &&
      (question.contains('lifting') ||
          question.contains('crane') ||
          question.contains('rigging') ||
          question.contains('suspended load'))) {
    return buildLiftingRiskAssessment().formattedText;
  }
  if (question.contains('risk assessment') &&
      (question.contains('electrical') ||
          question.contains('electrician') ||
          question.contains('live wire') ||
          question.contains('arc flash'))) {
    return buildElectricalRiskAssessment().formattedText;
  }
  if (question.contains('risk assessment') &&
      (question.contains('chemical') ||
          question.contains('paint') ||
          question.contains('solvent') ||
          question.contains('acid') ||
          question.contains('fuel transfer'))) {
    return buildChemicalHandlingRiskAssessment().formattedText;
  }
  if (question.contains('risk assessment') &&
      (question.contains('vehicle movement') ||
          question.contains('forklift') ||
          question.contains('mobile plant') ||
          question.contains('traffic management') ||
          question.contains('reversing vehicle'))) {
    return buildVehicleMovementRiskAssessment().formattedText;
  }
  return null;
}

RiskAssessmentReport buildWorkingAtHeightRiskAssessment() {
  final initialRisk = calculateRiskRating(likelihood: 4, consequence: 5);

  final residualRisk = calculateRiskRating(likelihood: 2, consequence: 3);

  return RiskAssessmentReport(
    activity: 'Working at Height',

    hazards: [
      'Fall from height',
      'Falling objects',
      'Scaffold collapse',
      'Unsafe ladder use',
    ],

    personsExposed: ['Workers', 'Supervisor', 'Nearby personnel'],

    existingControls: [
      'Approved Work at Height Permit',
      'Certified scaffold',
      'Competent supervisor',
    ],

    additionalControls: [
      '100% tie-off',
      'Daily scaffold inspection',
      'Barricade drop zone',
    ],

    requiredPpe: [
      'Full-body harness',
      'Shock-absorbing lanyard',
      'Helmet with chin strap',
      'Safety boots',
    ],

    requiredPermits: ['Working at Height Permit'],

    emergencyArrangements: ['Rescue plan', 'Emergency response team'],

    environmentalControls: ['Stop work during unsafe weather'],

    initialRisk: initialRisk,
    residualRisk: residualRisk,

    responsiblePerson: 'Site Supervisor',

    reviewRequirement: 'Review before every work-at-height activity.',
  );
}

RiskAssessmentReport buildConfinedSpaceRiskAssessment() {
  final initialRisk = calculateRiskRating(likelihood: 5, consequence: 5);

  final residualRisk = calculateRiskRating(likelihood: 2, consequence: 3);

  return RiskAssessmentReport(
    activity: 'Confined Space Entry',

    hazards: [
      'Oxygen deficiency',
      'Toxic gases',
      'Flammable atmosphere',
      'Engulfment',
      'Restricted access',
    ],

    personsExposed: ['Entrant', 'Standby person', 'Supervisor'],

    existingControls: [
      'Approved Entry Permit',
      'Gas Test Certificate',
      'Standby attendant',
    ],

    additionalControls: [
      'Continuous gas monitoring',
      'Mechanical ventilation',
      'Emergency rescue team on standby',
    ],

    requiredPpe: [
      'Safety helmet',
      'Gas detector',
      'Full-body harness',
      'Safety boots',
      'Respiratory protection where required',
    ],

    requiredPermits: ['Confined Space Entry Permit', 'Gas Test Certificate'],

    emergencyArrangements: [
      'Emergency rescue plan',
      'Rescue equipment available',
      'Reliable communication',
    ],

    environmentalControls: ['Safe atmospheric ventilation'],

    initialRisk: initialRisk,
    residualRisk: residualRisk,

    responsiblePerson: 'Confined Space Supervisor',

    reviewRequirement: 'Review before every confined-space entry.',
  );
}

RiskAssessmentReport buildExcavationRiskAssessment() {
  final initialRisk = calculateRiskRating(likelihood: 4, consequence: 5);

  final residualRisk = calculateRiskRating(likelihood: 2, consequence: 3);

  return RiskAssessmentReport(
    activity: 'Excavation Work',
    hazards: [
      'Trench collapse',
      'Underground services',
      'Falling materials',
      'Mobile equipment movement',
      'Unsafe access and egress',
      'Water accumulation',
    ],
    personsExposed: [
      'Workers inside excavation',
      'Excavator operator',
      'Banksman',
      'Nearby personnel',
    ],
    existingControls: [
      'Approved Excavation Permit',
      'Underground-service clearance',
      'Competent supervision',
    ],
    additionalControls: [
      'Provide shoring, shielding or safe sloping',
      'Keep spoil piles away from the edge',
      'Install barricades and warning signs',
      'Provide safe ladder access',
      'Inspect excavation daily',
    ],
    requiredPpe: [
      'Safety helmet',
      'Safety boots',
      'High-visibility vest',
      'Gloves',
      'Eye protection',
    ],
    requiredPermits: ['Excavation Permit', 'Underground-service clearance'],
    emergencyArrangements: [
      'Emergency rescue plan',
      'Stop work and evacuate during collapse warning signs',
      'Emergency contact arrangements',
    ],
    environmentalControls: [
      'Control water accumulation',
      'Protect nearby drains and soil',
    ],
    initialRisk: initialRisk,
    residualRisk: residualRisk,
    responsiblePerson: 'Excavation Supervisor',
    reviewRequirement:
        'Review before excavation starts and after weather or ground changes.',
  );
}

RiskAssessmentReport buildLiftingRiskAssessment() {
  final initialRisk = calculateRiskRating(likelihood: 4, consequence: 5);

  final residualRisk = calculateRiskRating(likelihood: 2, consequence: 3);

  return RiskAssessmentReport(
    activity: 'Lifting Operation',
    hazards: [
      'Dropped load',
      'Crane overturning',
      'Rigging failure',
      'Struck-by incident',
      'Personnel entering the exclusion zone',
      'Poor communication',
    ],
    personsExposed: [
      'Crane operator',
      'Riggers',
      'Banksman',
      'Nearby personnel',
    ],
    existingControls: [
      'Approved lifting plan',
      'Certified crane and lifting gear',
      'Competent lifting team',
    ],
    additionalControls: [
      'Barricade the exclusion zone',
      'Inspect slings, shackles and hooks before use',
      'Verify ground stability',
      'Use clear radio and hand-signal communication',
      'Stop work during unsafe weather',
    ],
    requiredPpe: [
      'Safety helmet',
      'Safety boots',
      'High-visibility vest',
      'Gloves',
    ],
    requiredPermits: ['Lifting Permit', 'Approved Lifting Plan'],
    emergencyArrangements: [
      'Stop lifting immediately',
      'Lower the load safely',
      'Activate emergency response where required',
    ],
    environmentalControls: ['Prevent damage to nearby structures and services'],
    initialRisk: initialRisk,
    residualRisk: residualRisk,
    responsiblePerson: 'Lifting Supervisor',
    reviewRequirement:
        'Review before every lifting operation and whenever conditions change.',
  );
}

RiskAssessmentReport buildElectricalRiskAssessment() {
  final initialRisk = calculateRiskRating(likelihood: 5, consequence: 5);

  final residualRisk = calculateRiskRating(likelihood: 2, consequence: 3);

  return RiskAssessmentReport(
    activity: 'Electrical Work',

    hazards: [
      'Electric shock',
      'Arc flash',
      'Electrical burns',
      'Fire',
      'Explosion',
      'Contact with exposed live conductors',
    ],

    personsExposed: ['Electrician', 'Supervisor', 'Nearby workers'],

    existingControls: [
      'Approved Electrical Work Permit',
      'Lock Out Tag Out',
      'Authorized electrician',
    ],

    additionalControls: [
      'Test for dead before work',
      'Use insulated tools',
      'Inspect cables and panels',
      'Barricade the work area',
      'Maintain safe approach distances',
    ],

    requiredPpe: [
      'Arc-rated clothing',
      'Insulated gloves',
      'Arc-rated face shield',
      'Safety helmet',
      'Safety boots',
    ],

    requiredPermits: ['Electrical Work Permit', 'Lock Out Tag Out'],

    emergencyArrangements: [
      'Emergency electrical isolation',
      'First aider available',
      'Emergency services notification',
    ],

    environmentalControls: ['Prevent damage to nearby electrical systems'],

    initialRisk: initialRisk,
    residualRisk: residualRisk,

    responsiblePerson: 'Electrical Supervisor',

    reviewRequirement: 'Review before every electrical work activity.',
  );
}

RiskAssessmentReport buildChemicalHandlingRiskAssessment() {
  final initialRisk = calculateRiskRating(likelihood: 4, consequence: 5);

  final residualRisk = calculateRiskRating(likelihood: 2, consequence: 3);

  return RiskAssessmentReport(
    activity: 'Chemical Handling',

    hazards: [
      'Chemical burns',
      'Toxic vapours',
      'Skin and eye irritation',
      'Fire and explosion',
      'Environmental contamination',
      'Inhalation hazards',
    ],

    personsExposed: ['Operators', 'Supervisor', 'Nearby workers'],

    existingControls: [
      'Approved chemical handling procedure',
      'Safety Data Sheet available',
      'Proper chemical storage',
    ],

    additionalControls: [
      'Use spill kits',
      'Ensure adequate ventilation',
      'Label all containers',
      'Use secondary containment',
      'Keep ignition sources away',
    ],

    requiredPpe: [
      'Chemical-resistant gloves',
      'Chemical goggles',
      'Face shield',
      'Chemical-resistant coveralls',
      'Safety boots',
      'Respiratory protection where required',
    ],

    requiredPermits: ['Chemical Handling Permit', 'Safety Data Sheet'],

    emergencyArrangements: [
      'Emergency shower',
      'Eyewash station',
      'Chemical spill response',
    ],

    environmentalControls: [
      'Protect drains and soil',
      'Dispose of chemical waste safely',
    ],

    initialRisk: initialRisk,
    residualRisk: residualRisk,

    responsiblePerson: 'Chemical Supervisor',

    reviewRequirement: 'Review before every chemical handling activity.',
  );
}

RiskAssessmentReport buildVehicleMovementRiskAssessment() {
  final initialRisk = calculateRiskRating(likelihood: 4, consequence: 5);

  final residualRisk = calculateRiskRating(likelihood: 2, consequence: 2);

  return RiskAssessmentReport(
    activity: 'Vehicle and Mobile Plant Movement',

    hazards: [
      'Vehicle-pedestrian collision',
      'Reversing incidents',
      'Blind spots',
      'Speeding',
      'Equipment overturning',
      'Poor traffic segregation',
    ],

    personsExposed: ['Drivers', 'Banksmen', 'Pedestrians', 'Nearby workers'],

    existingControls: [
      'Traffic Management Plan',
      'Vehicle inspections',
      'Authorized drivers',
    ],

    additionalControls: [
      'Use trained banksmen',
      'Separate pedestrians and vehicles',
      'Maintain speed limits',
      'Inspect reversing alarms',
      'Maintain one-way routes where possible',
    ],

    requiredPpe: [
      'Safety helmet',
      'High-visibility vest',
      'Safety boots',
      'Gloves',
    ],

    requiredPermits: ['Vehicle Movement Authorization'],

    emergencyArrangements: [
      'Emergency response team',
      'First aid arrangements',
      'Vehicle recovery plan',
    ],

    environmentalControls: [
      'Prevent fuel spills',
      'Protect surrounding infrastructure',
    ],

    initialRisk: initialRisk,
    residualRisk: residualRisk,

    responsiblePerson: 'Transport Supervisor',

    reviewRequirement: 'Review before every vehicle movement activity.',
  );
}
