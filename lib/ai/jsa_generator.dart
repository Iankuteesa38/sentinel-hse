class JsaReport {
  final String activity;
  final List<String> jobSteps;
  final List<String> hazards;
  final List<String> controlMeasures;
  final List<String> requiredPpe;
  final List<String> requiredPermits;
  final List<String> emergencyResponse;
  final String responsiblePerson;
  final String reviewRequirement;

  const JsaReport({
    required this.activity,
    required this.jobSteps,
    required this.hazards,
    required this.controlMeasures,
    required this.requiredPpe,
    required this.requiredPermits,
    required this.emergencyResponse,
    required this.responsiblePerson,
    required this.reviewRequirement,
  });

  String get formattedText {
    return '''
SENTINEL AI JOB SAFETY ANALYSIS

Activity:
$activity

Job Steps:
${_formatItems(jobSteps)}

Hazards:
${_formatItems(hazards)}

Control Measures:
${_formatItems(controlMeasures)}

Required PPE:
${_formatItems(requiredPpe)}

Required Permits:
${_formatItems(requiredPermits)}

Emergency Response:
${_formatItems(emergencyResponse)}

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

JsaReport buildPipeWeldingJsa() {
  return const JsaReport(
    activity: 'Pipe Welding',
    jobSteps: [
      'Prepare the work area',
      'Inspect welding equipment',
      'Obtain required permits',
      'Set up welding leads and earth connection',
      'Perform welding',
      'Inspect completed weld',
      'Clean and close the work area',
    ],
    hazards: [
      'Fire and explosion',
      'Burns',
      'Electric shock',
      'Arc radiation',
      'Welding fumes',
      'Trips from welding cables',
    ],
    controlMeasures: [
      'Obtain an approved Hot Work Permit',
      'Remove combustible materials',
      'Assign a trained fire watcher',
      'Inspect welding machines, leads and earth clamps',
      'Ensure adequate ventilation',
      'Barricade the work area',
      'Keep suitable fire extinguishers nearby',
      'Maintain good housekeeping',
    ],
    requiredPpe: [
      'Welding helmet',
      'Safety glasses',
      'Leather gloves',
      'Flame-resistant coveralls',
      'Safety boots',
      'Respiratory protection where required',
    ],
    requiredPermits: ['Hot Work Permit'],
    emergencyResponse: [
      'Raise the alarm',
      'Stop welding immediately',
      'Isolate the power supply',
      'Use the correct fire extinguisher if trained',
      'Contact the emergency response team',
    ],
    responsiblePerson: 'Welding Supervisor',
    reviewRequirement:
        'Review before work begins and whenever conditions change.',
  );
}

JsaReport buildWorkingAtHeightJsa() {
  return const JsaReport(
    activity: 'Working at Height',
    jobSteps: [
      'Inspect the work area',
      'Confirm permit and rescue plan',
      'Inspect access equipment',
      'Inspect harnesses and lanyards',
      'Install barricades below',
      'Perform the work',
      'Remove tools and close the area',
    ],
    hazards: [
      'Fall from height',
      'Falling objects',
      'Scaffold or ladder failure',
      'Unsafe anchor points',
      'Slips and trips',
      'Suspension trauma',
    ],
    controlMeasures: [
      'Obtain an approved Working at Height Permit',
      'Use inspected scaffolds and ladders',
      'Maintain 100% tie-off',
      'Use approved anchor points',
      'Install guardrails and toe boards',
      'Secure tools and materials',
      'Barricade the drop zone',
      'Maintain competent supervision',
      'Keep a rescue plan available',
    ],
    requiredPpe: [
      'Full-body harness',
      'Shock-absorbing lanyard',
      'Helmet with chin strap',
      'Safety boots',
      'Gloves',
    ],
    requiredPermits: ['Working at Height Permit'],
    emergencyResponse: [
      'Stop work immediately',
      'Raise the alarm',
      'Activate the rescue plan',
      'Provide first aid',
      'Contact emergency services where required',
    ],
    responsiblePerson: 'Work at Height Supervisor',
    reviewRequirement:
        'Review before work starts and whenever access, weather or work conditions change.',
  );
}

JsaReport buildConfinedSpaceJsa() {
  return const JsaReport(
    activity: 'Confined Space Entry',
    jobSteps: [
      'Inspect and identify the confined space',
      'Confirm isolation and Lock Out Tag Out',
      'Obtain the entry permit',
      'Conduct atmospheric gas testing',
      'Install ventilation and communication',
      'Brief the entry team and rescue team',
      'Enter and perform the work',
      'Close the permit and secure the area',
    ],
    hazards: [
      'Oxygen deficiency',
      'Toxic gases',
      'Flammable atmosphere',
      'Engulfment',
      'Restricted access and egress',
      'Heat stress',
      'Unexpected energy release',
    ],
    controlMeasures: [
      'Obtain an approved Confined Space Entry Permit',
      'Isolate all energy sources using Lock Out Tag Out',
      'Test the atmosphere before entry',
      'Maintain continuous gas monitoring',
      'Provide mechanical ventilation',
      'Assign a trained standby attendant',
      'Maintain reliable communication',
      'Keep rescue equipment and a rescue team ready',
      'Record all entry and exit',
    ],
    requiredPpe: [
      'Safety helmet',
      'Safety boots',
      'Chemical-resistant gloves where required',
      'Personal gas detector',
      'Full-body harness',
      'Respiratory protection where required',
    ],
    requiredPermits: [
      'Confined Space Entry Permit',
      'Gas Test Certificate',
      'Isolation Certificate where applicable',
    ],
    emergencyResponse: [
      'Raise the alarm immediately',
      'Do not enter for rescue without authorization',
      'Activate the confined-space rescue plan',
      'Use trained rescuers and suitable equipment',
      'Provide first aid and contact emergency services',
    ],
    responsiblePerson: 'Confined Space Supervisor',
    reviewRequirement:
        'Review before every entry and whenever atmospheric or work conditions change.',
  );
}

String? handleJsaGenerator(String question) {
  if (!question.contains('jsa') && !question.contains('job safety analysis')) {
    return null;
  }

  if (question.contains('welding') || question.contains('pipe welding')) {
    return buildPipeWeldingJsa().formattedText;
  }

  if (question.contains('working at height') ||
      question.contains('work at height') ||
      question.contains('scaffold') ||
      question.contains('ladder')) {
    return buildWorkingAtHeightJsa().formattedText;
  }
  if (question.contains('confined space') ||
      question.contains('tank entry') ||
      question.contains('vessel entry') ||
      question.contains('manhole entry')) {
    return buildConfinedSpaceJsa().formattedText;
  }
  if (question.contains('excavation') ||
      question.contains('trench') ||
      question.contains('digging')) {
    return buildExcavationJsa().formattedText;
  }
  if (question.contains('lifting') ||
      question.contains('crane') ||
      question.contains('rigging') ||
      question.contains('suspended load')) {
    return buildLiftingJsa().formattedText;
  }
  if (question.contains('electrical') ||
      question.contains('electrician') ||
      question.contains('live wire') ||
      question.contains('arc flash')) {
    return buildElectricalWorkJsa().formattedText;
  }
  if (question.contains('chemical') ||
      question.contains('paint') ||
      question.contains('solvent') ||
      question.contains('acid') ||
      question.contains('fuel transfer')) {
    return buildChemicalHandlingJsa().formattedText;
  }
  if (question.contains('vehicle movement') ||
      question.contains('forklift') ||
      question.contains('mobile plant') ||
      question.contains('traffic management') ||
      question.contains('reversing vehicle')) {
    return buildVehicleMovementJsa().formattedText;
  }
  return '''
SENTINEL AI JSA GENERATOR

Please include the activity.

Examples:
•⁠  ⁠JSA for pipe welding
•⁠  ⁠JSA for working at height
''';
}

JsaReport buildExcavationJsa() {
  return const JsaReport(
    activity: 'Excavation Work',
    jobSteps: [
      'Survey and inspect the work area',
      'Identify underground services',
      'Obtain the excavation permit',
      'Mark and barricade the excavation area',
      'Excavate using approved equipment',
      'Provide shoring, shielding or safe sloping',
      'Provide safe access and egress',
      'Inspect and close the excavation safely',
    ],
    hazards: [
      'Trench collapse',
      'Underground services',
      'Falling materials',
      'Mobile equipment movement',
      'Unsafe access and egress',
      'Water accumulation',
      'Unstable soil',
    ],
    controlMeasures: [
      'Obtain an approved Excavation Permit',
      'Detect and mark underground services',
      'Provide shoring, shielding or safe sloping',
      'Keep spoil piles away from the edge',
      'Install barricades and warning signs',
      'Provide safe ladder access',
      'Inspect the excavation daily',
      'Stop work after adverse weather until reinspection',
      'Assign a competent excavation supervisor',
    ],
    requiredPpe: [
      'Safety helmet',
      'Safety boots',
      'High-visibility vest',
      'Gloves',
      'Eye protection',
    ],
    requiredPermits: ['Excavation Permit', 'Underground-Service Clearance'],
    emergencyResponse: [
      'Stop work immediately',
      'Evacuate the excavation',
      'Raise the alarm',
      'Activate the rescue plan',
      'Contact emergency services where required',
    ],
    responsiblePerson: 'Excavation Supervisor',
    reviewRequirement:
        'Review before excavation begins and after weather, soil or service conditions change.',
  );
}

JsaReport buildLiftingJsa() {
  return const JsaReport(
    activity: 'Lifting Operation',
    jobSteps: [
      'Inspect the lifting area',
      'Confirm the approved lifting plan',
      'Inspect the crane and lifting gear',
      'Brief the lifting team',
      'Establish the exclusion zone',
      'Rig and test-lift the load',
      'Lift and position the load',
      'Remove rigging and close the area',
    ],
    hazards: [
      'Dropped load',
      'Crane overturning',
      'Rigging failure',
      'Struck-by incident',
      'Poor communication',
      'Personnel entering the exclusion zone',
      'Unstable ground conditions',
    ],
    controlMeasures: [
      'Use an approved lifting plan',
      'Use certified crane and lifting gear',
      'Assign competent operators, riggers and banksmen',
      'Inspect slings, shackles and hooks before use',
      'Establish and barricade the exclusion zone',
      'Verify ground stability and crane setup',
      'Maintain clear communication',
      'Perform a test lift',
      'Stop work during unsafe weather',
    ],
    requiredPpe: [
      'Safety helmet',
      'Safety boots',
      'High-visibility vest',
      'Gloves',
    ],
    requiredPermits: ['Lifting Permit', 'Approved Lifting Plan'],
    emergencyResponse: [
      'Stop the lifting operation',
      'Lower the load safely where possible',
      'Raise the alarm',
      'Secure the exclusion zone',
      'Activate emergency response where required',
    ],
    responsiblePerson: 'Lifting Supervisor',
    reviewRequirement:
        'Review before every lift and whenever the load, equipment, ground or weather conditions change.',
  );
}

JsaReport buildElectricalWorkJsa() {
  return const JsaReport(
    activity: 'Electrical Work',

    jobSteps: [
      'Review the electrical work permit',
      'Identify the electrical source',
      'Apply Lock Out Tag Out',
      'Test for dead',
      'Perform the electrical work',
      'Inspect and test the installation',
      'Restore power safely',
    ],

    hazards: [
      'Electric shock',
      'Arc flash',
      'Electrical burns',
      'Fire',
      'Explosion',
      'Unexpected energization',
    ],

    controlMeasures: [
      'Use an approved Electrical Work Permit',
      'Apply Lock Out Tag Out',
      'Test for dead',
      'Use insulated tools',
      'Allow only authorized electricians',
      'Barricade the work area',
      'Inspect cables and equipment',
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

    emergencyResponse: [
      'Stop work immediately',
      'Isolate the electrical supply',
      'Raise the alarm',
      'Provide first aid',
      'Call emergency services',
    ],

    responsiblePerson: 'Electrical Supervisor',

    reviewRequirement: 'Review before every electrical work activity.',
  );
}

JsaReport buildChemicalHandlingJsa() {
  return const JsaReport(
    activity: 'Chemical Handling',

    jobSteps: [
      'Review the Safety Data Sheet',
      'Inspect chemical containers',
      'Wear required PPE',
      'Transfer and use chemicals safely',
      'Store chemicals correctly',
      'Dispose of waste safely',
    ],

    hazards: [
      'Chemical burns',
      'Toxic vapours',
      'Skin and eye irritation',
      'Fire and explosion',
      'Environmental contamination',
      'Inhalation hazards',
    ],

    controlMeasures: [
      'Review the Safety Data Sheet',
      'Use suitable spill kits',
      'Ensure adequate ventilation',
      'Store chemicals correctly',
      'Use secondary containment',
      'Control ignition sources',
      'Label all containers',
      'Dispose of chemical waste correctly',
    ],

    requiredPpe: [
      'Chemical-resistant gloves',
      'Chemical goggles',
      'Face shield',
      'Chemical-resistant coveralls',
      'Safety boots',
      'Respiratory protection where required',
    ],

    requiredPermits: ['Chemical Handling Permit'],

    emergencyResponse: [
      'Raise the alarm',
      'Use the emergency shower or eyewash station',
      'Contain the spill if safe',
      'Notify the emergency response team',
      'Seek medical attention where required',
    ],

    responsiblePerson: 'Chemical Supervisor',

    reviewRequirement: 'Review before every chemical handling activity.',
  );
}

JsaReport buildVehicleMovementJsa() {
  return const JsaReport(
    activity: 'Vehicle and Mobile Plant Movement',

    jobSteps: [
      'Inspect the vehicle',
      'Conduct pre-start checks',
      'Review the traffic management plan',
      'Travel to the work area',
      'Carry out the assigned movement',
      'Park and secure the vehicle',
    ],

    hazards: [
      'Vehicle-pedestrian collision',
      'Reversing incidents',
      'Blind spots',
      'Speeding',
      'Equipment overturning',
      'Poor traffic segregation',
    ],

    controlMeasures: [
      'Follow the Traffic Management Plan',
      'Use trained banksmen when reversing',
      'Observe site speed limits',
      'Separate pedestrians and vehicles',
      'Inspect the vehicle before use',
      'Use reversing alarms and flashing beacons',
      'Maintain clear communication',
      'Do not use mobile phones while driving',
    ],

    requiredPpe: [
      'Safety helmet',
      'High-visibility vest',
      'Safety boots',
      'Gloves',
    ],

    requiredPermits: ['Vehicle Movement Authorization'],

    emergencyResponse: [
      'Stop the vehicle safely',
      'Raise the alarm',
      'Provide first aid if required',
      'Notify emergency services',
      'Secure the area',
    ],

    responsiblePerson: 'Transport Supervisor',

    reviewRequirement: 'Review before every vehicle movement activity.',
  );
}
