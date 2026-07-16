String? handleHazardRecognition(String question) {
  if (question.contains('welding') || question.contains('hot work')) {
    return '''
AI HAZARD RECOGNITION

Activity:
Welding Operation

Hazards Identified:
•⁠  ⁠Fire
•⁠  ⁠Burns
•⁠  ⁠Electric shock
•⁠  ⁠Arc flash
•⁠  ⁠Welding fumes

Risk Level:
HIGH

Required PPE:
•⁠  ⁠Welding helmet
•⁠  ⁠Leather gloves
•⁠  ⁠Flame-resistant coveralls
•⁠  ⁠Safety boots

Required Permit:
•⁠  ⁠Hot Work Permit

Recommended Controls:
•⁠  ⁠Keep a suitable fire extinguisher nearby
•⁠  ⁠Assign a trained fire watcher
•⁠  ⁠Remove combustible materials
•⁠  ⁠Ensure adequate ventilation
•⁠  ⁠Inspect welding equipment before use
•⁠  ⁠Barricade the work area
''';
  }
  if (question.contains('excavation') ||
      question.contains('trench') ||
      question.contains('digging')) {
    return '''
AI HAZARD RECOGNITION

Activity:
Excavation Work

Hazards Identified:
•⁠  ⁠Trench collapse
•⁠  ⁠Underground services
•⁠  ⁠Falling materials
•⁠  ⁠Mobile equipment movement
•⁠  ⁠Unsafe access and egress
•⁠  ⁠Water accumulation

Risk Level:
EXTREME

Required PPE:
•⁠  ⁠Safety helmet
•⁠  ⁠Safety boots
•⁠  ⁠High-visibility vest
•⁠  ⁠Gloves
•⁠  ⁠Eye protection

Required Permit:
•⁠  ⁠Excavation Permit

Recommended Controls:
•⁠  ⁠Detect and mark underground services
•⁠  ⁠Provide shoring, shielding or safe sloping
•⁠  ⁠Keep spoil piles away from the edge
•⁠  ⁠Install barricades and warning signs
•⁠  ⁠Provide safe ladder access
•⁠  ⁠Inspect the excavation daily
•⁠  ⁠Assign a competent supervisor
''';
  }
  if (question.contains('lifting') ||
      question.contains('crane') ||
      question.contains('rigging') ||
      question.contains('suspended load')) {
    return '''
AI HAZARD RECOGNITION

Activity:
Lifting Operation

Hazards Identified:
•⁠  ⁠Dropped load
•⁠  ⁠Crane overturning
•⁠  ⁠Rigging failure
•⁠  ⁠Struck-by hazards
•⁠  ⁠Personnel entering the exclusion zone
•⁠  ⁠Poor communication

Risk Level:
EXTREME

Required PPE:
•⁠  ⁠Safety helmet
•⁠  ⁠Safety shoes
•⁠  ⁠High-visibility vest
•⁠  ⁠Gloves

Required Permit:
•⁠  ⁠Lifting Permit
•⁠  ⁠Approved Lifting Plan

Recommended Controls:
•⁠  ⁠Use certified cranes and lifting gear
•⁠  ⁠Assign trained riggers and banksmen
•⁠  ⁠Establish and barricade an exclusion zone
•⁠  ⁠Inspect slings, shackles and hooks before use
•⁠  ⁠Maintain clear communication
•⁠  ⁠Verify ground stability and crane setup
•⁠  ⁠Follow the approved lifting plan
''';
  }
  if (question.contains('electrical') ||
      question.contains('electrician') ||
      question.contains('live cable') ||
      question.contains('live wire') ||
      question.contains('electrical panel') ||
      question.contains('arc flash') ||
      question.contains('energized equipment') ||
      question.contains('energised equipment')) {
    return '''
AI HAZARD RECOGNITION

Activity:
Electrical Work

Hazards Identified:
•⁠  ⁠Electric shock
•⁠  ⁠Electrocution
•⁠  ⁠Arc flash
•⁠  ⁠Electrical burns
•⁠  ⁠Fire or explosion
•⁠  ⁠Contact with exposed live conductors

Risk Level:
EXTREME

Required PPE:
•⁠  ⁠Arc-rated clothing
•⁠  ⁠Insulated electrical gloves
•⁠  ⁠Safety helmet
•⁠  ⁠Arc-rated face shield
•⁠  ⁠Safety boots
•⁠  ⁠Eye protection

Required Permit:
•⁠  ⁠Electrical Work Permit
•⁠  ⁠Lock Out Tag Out authorization

Recommended Controls:
•⁠  ⁠Isolate the electrical supply before work
•⁠  ⁠Apply Lock Out Tag Out
•⁠  ⁠Test for dead before touching conductors
•⁠  ⁠Use voltage-rated insulated tools
•⁠  ⁠Allow only authorized electricians
•⁠  ⁠Inspect cables, panels and equipment
•⁠  ⁠Barricade and restrict the work area
•⁠  ⁠Maintain safe electrical approach distances
•⁠  ⁠Remove defective equipment from service
''';
  }
  if (question.contains('working at height') ||
      question.contains('work at height') ||
      question.contains('scaffold') ||
      question.contains('ladder') ||
      question.contains('roof work') ||
      question.contains('elevated work')) {
    return '''
AI HAZARD RECOGNITION

Activity:
Working at Height

Hazards Identified:
•⁠  ⁠Fall from height
•⁠  ⁠Falling objects
•⁠  ⁠Scaffold collapse
•⁠  ⁠Unsafe ladder use
•⁠  ⁠Fragile surfaces
•⁠  ⁠Loss of balance

Risk Level:
EXTREME

Required PPE:
•⁠  ⁠Full-body harness
•⁠  ⁠Shock-absorbing lanyard
•⁠  ⁠Safety helmet with chin strap
•⁠  ⁠Safety boots
•⁠  ⁠Gloves

Required Permit:
•⁠  ⁠Working at Height Permit

Recommended Controls:
•⁠  ⁠Inspect scaffolds before use
•⁠  ⁠Maintain 100% tie-off
•⁠  ⁠Install guardrails and toe boards
•⁠  ⁠Barricade the drop zone
•⁠  ⁠Secure all tools and materials
•⁠  ⁠Inspect ladders before use
•⁠  ⁠Ensure competent supervision
•⁠  ⁠Maintain a work-at-height rescue plan
''';
  }
  if (question.contains('confined space') ||
      question.contains('tank entry') ||
      question.contains('vessel entry') ||
      question.contains('manhole entry') ||
      question.contains('manhole')) {
    return '''
AI HAZARD RECOGNITION

Activity:
Confined Space Entry

Hazards Identified:
•⁠  ⁠Oxygen deficiency
•⁠  ⁠Toxic gases
•⁠  ⁠Flammable atmosphere
•⁠  ⁠Engulfment
•⁠  ⁠Limited access and egress
•⁠  ⁠Heat stress

Risk Level:
EXTREME

Required PPE:
•⁠  ⁠Safety helmet
•⁠  ⁠Chemical-resistant gloves
•⁠  ⁠Safety boots
•⁠  ⁠Personal gas detector
•⁠  ⁠Respiratory protection where required
•⁠  ⁠Full-body harness

Required Permit:
•⁠  ⁠Confined Space Entry Permit
•⁠  ⁠Gas Test Certificate

Recommended Controls:
•⁠  ⁠Conduct atmospheric gas testing
•⁠  ⁠Maintain continuous gas monitoring
•⁠  ⁠Provide mechanical ventilation
•⁠  ⁠Assign a trained standby person
•⁠  ⁠Prepare an emergency rescue plan
•⁠  ⁠Isolate all energy sources using LOTO
•⁠  ⁠Maintain reliable communication
•⁠  ⁠Control and record all entry and exit
''';
  }
  if (question.contains('chemical handling') ||
      question.contains('chemical') ||
      question.contains('paint mixing') ||
      question.contains('paint') ||
      question.contains('solvent') ||
      question.contains('thinner') ||
      question.contains('acid') ||
      question.contains('fuel transfer')) {
    return '''
AI HAZARD RECOGNITION

Activity:
Chemical Handling

Hazards Identified:
•⁠  ⁠Chemical burns
•⁠  ⁠Toxic vapours
•⁠  ⁠Skin and eye irritation
•⁠  ⁠Fire and explosion
•⁠  ⁠Environmental contamination
•⁠  ⁠Inhalation hazards

Risk Level:
HIGH

Required PPE:
•⁠  ⁠Chemical-resistant gloves
•⁠  ⁠Chemical goggles
•⁠  ⁠Face shield
•⁠  ⁠Chemical-resistant coveralls
•⁠  ⁠Safety boots
•⁠  ⁠Respiratory protection where required

Required Documents:
•⁠  ⁠Safety Data Sheet
•⁠  ⁠Chemical Handling Procedure

Recommended Controls:
•⁠  ⁠Review the Safety Data Sheet
•⁠  ⁠Ensure adequate ventilation
•⁠  ⁠Keep suitable spill kits available
•⁠  ⁠Store chemicals in approved containers
•⁠  ⁠Control ignition sources
•⁠  ⁠Label every container
•⁠  ⁠Use secondary containment
•⁠  ⁠Dispose of chemical waste safely
''';
  }
  if (question.contains('vehicle movement') ||
      question.contains('reversing vehicle') ||
      question.contains('forklift') ||
      question.contains('mobile plant') ||
      question.contains('heavy equipment') ||
      question.contains('traffic management')) {
    return '''
AI HAZARD RECOGNITION

Activity:
Vehicle and Mobile Plant Movement

Hazards Identified:
•⁠  ⁠Vehicle-pedestrian collision
•⁠  ⁠Reversing incidents
•⁠  ⁠Blind spots
•⁠  ⁠Speeding
•⁠  ⁠Equipment overturning
•⁠  ⁠Poor traffic segregation

Risk Level:
EXTREME

Required PPE:
•⁠  ⁠Safety helmet
•⁠  ⁠High-visibility vest
•⁠  ⁠Safety boots
•⁠  ⁠Gloves

Required Documents:
•⁠  ⁠Vehicle Movement Authorization
•⁠  ⁠Approved Traffic Management Plan

Recommended Controls:
•⁠  ⁠Separate pedestrians and vehicles
•⁠  ⁠Use trained banksmen for reversing
•⁠  ⁠Establish one-way routes where possible
•⁠  ⁠Enforce site speed limits
•⁠  ⁠Inspect vehicles before use
•⁠  ⁠Use flashing beacons and reversing alarms
•⁠  ⁠Maintain clear radio communication
•⁠  ⁠Barricade active vehicle routes
''';
  }
  return null;
}
