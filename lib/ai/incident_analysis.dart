String? handleIncidentAnalysis(String question) {
final isIncidentRequest =
      question.contains('incident') ||
      question.contains('accident') ||
      question.contains('analyze') ||
      question.contains('analyse') ||
      question.contains('analysis') ||
      question.contains('injury') ||
      question.contains('injured') ||
      question.contains('fatality') ||
      question.contains('near miss') ||
      question.contains('fell') ||
      question.contains('fall from') ||
      question.contains('collapse') ||
      question.contains('cave-in') ||
      question.contains('spill') ||
      question.contains('leak') ||
      question.contains('electric shock') ||
      question.contains('electrocution') ||
      question.contains('arc flash');

  if (!isIncidentRequest) {
    return null;
  }

  if (question.contains('vehicle') ||
      question.contains('collision') ||
      question.contains('driver')) {
    return '''
SENTINEL AI VEHICLE INCIDENT ANALYSIS

Risk Score:
97 / 100

Risk Level:
EXTREME

Likelihood:
Almost Certain

Consequence:
Catastrophic

Priority:
STOP WORK IMMEDIATELY

AI Recommendation:
Investigate immediately, secure the scene, assist affected persons, review IVMS records, inspect the vehicle, interview the driver, and implement corrective actions before operations resume.

Likely Root Causes:
•⁠  ⁠Driver inattention
•⁠  ⁠Unsafe speed or poor lane discipline
•⁠  ⁠Inadequate journey management
•⁠  ⁠Fatigue or distraction

Immediate Corrective Actions:
•⁠  ⁠Secure the accident scene.
•⁠  ⁠Assist injured persons.
•⁠  ⁠Inform the control room and police where required.
•⁠  ⁠Suspend the involved driver pending investigation.
•⁠  ⁠Review IVMS and vehicle records.

Preventive Actions:
•⁠  ⁠Conduct defensive-driving refresher training.
•⁠  ⁠Strengthen journey-management controls.
•⁠  ⁠Monitor speeding and harsh-driving violations.
•⁠  ⁠Carry out regular road-safety inspections.

Lessons Learned:
Vehicle movements require proper planning, supervision, and strict compliance with defensive-driving rules.
''';
  }

  if (question.contains('fire') ||
      question.contains('flame') ||
      question.contains('burn') ||
      question.contains('smoke')) {
    return '''
SENTINEL AI FIRE INCIDENT ANALYSIS

Risk Score:
96 / 100

Risk Level:
EXTREME

Likelihood:
Likely

Consequence:
Catastrophic

Priority:
Immediate Action Required

AI Recommendation:
Raise the alarm, isolate energy sources where safe, evacuate personnel, account for everyone at the assembly point, notify emergency services, and restart only after the root cause is investigated and controls are verified.

Likely Root Causes:
•⁠  ⁠Electrical short circuit
•⁠  ⁠Hot work without permit
•⁠  ⁠Flammable materials nearby
•⁠  ⁠Fuel or gas leak
•⁠  ⁠Poor housekeeping

Immediate Corrective Actions:
•⁠  ⁠Raise the alarm.
•⁠  ⁠Stop all work.
•⁠  ⁠Evacuate personnel.
•⁠  ⁠Isolate power or fuel sources where safe.
•⁠  ⁠Notify the emergency response team.

Preventive Actions:
•⁠  ⁠Inspect electrical systems.
•⁠  ⁠Follow Hot Work Permit procedures.
•⁠  ⁠Store flammable materials correctly.
•⁠  ⁠Maintain good housekeeping.
•⁠  ⁠Conduct regular fire drills.

Lessons Learned:
Effective ignition control, good housekeeping, and emergency preparedness are essential for preventing and controlling fire incidents.
''';
  }

  if (question.contains('fall') ||
      question.contains('height') ||
      question.contains('scaffold') ||
      question.contains('ladder')) {
    return '''
SENTINEL AI WORKING AT HEIGHT INCIDENT ANALYSIS

Risk Score:
85 / 100

Risk Level:
HIGH

Likelihood:
Likely

Consequence:
Major

Priority:
Immediate Action Required

AI Recommendation:
Stop work immediately, rescue and assist the affected person, secure and barricade the area, inspect access and fall-protection equipment, replace defective equipment, and resume only after competent-person approval.

Likely Root Causes:
•⁠  ⁠Inadequate work-at-height planning
•⁠  ⁠Unsafe scaffold or ladder
•⁠  ⁠Missing edge protection
•⁠  ⁠Failure to maintain 100% tie-off

Immediate Corrective Actions:
•⁠  ⁠Stop the work immediately.
•⁠  ⁠Rescue and assist the affected person.
•⁠  ⁠Secure and barricade the area.
•⁠  ⁠Inspect access equipment and fall-protection systems.
•⁠  ⁠Preserve evidence for investigation.

Preventive Actions:
•⁠  ⁠Use inspected scaffolds and ladders.
•⁠  ⁠Provide approved anchor points.
•⁠  ⁠Enforce full-body harness and 100% tie-off.
•⁠  ⁠Maintain a work-at-height rescue plan.
•⁠  ⁠Strengthen supervision.

Lessons Learned:
Work at height must be properly planned and performed only with approved access and fall-protection systems.
''';
  }

  if (question.contains('confined space') ||
      question.contains('gas exposure') ||
      question.contains('oxygen deficiency') ||
      question.contains('toxic gas')) {
    return '''
SENTINEL AI CONFINED SPACE INCIDENT ANALYSIS

Risk Score:
95 / 100

Risk Level:
EXTREME

Likelihood:
Likely

Consequence:
Catastrophic

Priority:
STOP WORK IMMEDIATELY

AI Recommendation:
Evacuate the space, isolate and barricade the area, conduct atmospheric testing, provide ventilation, activate the rescue plan where required, and review the entry permit before restarting.

Likely Root Causes:
•⁠  ⁠Inadequate atmospheric testing
•⁠  ⁠Poor ventilation
•⁠  ⁠Failure of permit controls
•⁠  ⁠Insufficient rescue preparedness

Immediate Corrective Actions:
•⁠  ⁠Evacuate the confined space.
•⁠  ⁠Isolate and barricade the area.
•⁠  ⁠Perform atmospheric testing.
•⁠  ⁠Provide mechanical ventilation.
•⁠  ⁠Activate the rescue plan where required.

Preventive Actions:
•⁠  ⁠Maintain continuous gas monitoring.
•⁠  ⁠Assign a trained standby person.
•⁠  ⁠Verify communication and rescue equipment.
•⁠  ⁠Strictly control confined-space permits.
•⁠  ⁠Conduct competency training.

Lessons Learned:
Confined-space entry must never begin without testing, ventilation, supervision, communication, and a rescue plan.
''';
  }

  if (question.contains('excavation') ||
      question.contains('trench') ||
      question.contains('cave-in') ||
      question.contains('collapse')) {
    return '''
SENTINEL AI EXCAVATION INCIDENT ANALYSIS

Risk Score:
92 / 100

Risk Level:
EXTREME

Likelihood:
Likely

Consequence:
Catastrophic

Priority:
STOP WORK IMMEDIATELY

AI Recommendation:
Stop excavation work, evacuate personnel from the trench, barricade the area, inspect for instability, verify shoring or sloping, confirm underground-service clearance, and resume only after competent-person approval.

Likely Root Causes:
•⁠  ⁠Unsupported excavation walls
•⁠  ⁠Inadequate sloping or shoring
•⁠  ⁠Spoil piles too close to the edge
•⁠  ⁠Underground services not identified
•⁠  ⁠Poor access and egress
•⁠  ⁠Water accumulation or unstable soil

Immediate Corrective Actions:
•⁠  ⁠Stop excavation work immediately.
•⁠  ⁠Evacuate personnel from the trench.
•⁠  ⁠Barricade and secure the area.
•⁠  ⁠Inspect the excavation for instability.
•⁠  ⁠Provide approved shoring, shielding, or sloping.
•⁠  ⁠Confirm underground-service clearance.

Preventive Actions:
•⁠  ⁠Obtain an approved excavation permit.
•⁠  ⁠Conduct underground-service detection.
•⁠  ⁠Inspect excavations daily and after adverse weather.
•⁠  ⁠Keep spoil piles and equipment away from the edge.
•⁠  ⁠Provide safe access points.
•⁠  ⁠Assign a competent excavation supervisor.

Lessons Learned:
Excavation work must be planned, inspected, and protected against collapse before personnel are allowed to enter.
''';
  }

  if (question.contains('lifting') ||
      question.contains('crane') ||
      question.contains('rigging') ||
      question.contains('suspended load')) {
    return '''
SENTINEL AI LIFTING INCIDENT ANALYSIS

Risk Score:
94 / 100

Risk Level:
EXTREME

Likelihood:
Likely

Consequence:
Catastrophic

Priority:
STOP WORK IMMEDIATELY

AI Recommendation:
Stop the lifting operation, lower the load safely, secure the exclusion zone, inspect lifting equipment and rigging gear, verify certification and the lifting plan, and resume only after approval by the lifting supervisor.

Likely Root Causes:
•⁠  ⁠Overloaded crane
•⁠  ⁠Defective lifting equipment
•⁠  ⁠Improper rigging
•⁠  ⁠Poor communication
•⁠  ⁠Failure to follow the lifting plan
•⁠  ⁠Unauthorized personnel in the lifting zone

Immediate Corrective Actions:
•⁠  ⁠Stop the lifting operation.
•⁠  ⁠Lower the load safely.
•⁠  ⁠Secure the exclusion zone.
•⁠  ⁠Inspect all lifting equipment.
•⁠  ⁠Remove defective gear from service.
•⁠  ⁠Report the incident immediately.

Preventive Actions:
•⁠  ⁠Use certified cranes and lifting gear.
•⁠  ⁠Conduct pre-use inspections.
•⁠  ⁠Follow an approved lifting plan.
•⁠  ⁠Assign trained riggers and banksmen.
•⁠  ⁠Maintain effective communication.
•⁠  ⁠Supervise all critical lifts.

Lessons Learned:
Lifting operations must be properly planned, supervised, and executed using certified equipment and competent personnel.
''';
  }

  if (question.contains('electrical') ||
      question.contains('electric shock') ||
      question.contains('electrocution') ||
      question.contains('live wire') ||
      question.contains('arc flash')) {
    return '''
SENTINEL AI ELECTRICAL INCIDENT ANALYSIS

Risk Score:
95 / 100

Risk Level:
EXTREME

Likelihood:
Likely

Consequence:
Catastrophic

Priority:
STOP WORK IMMEDIATELY

AI Recommendation:
Stop work, isolate the electrical supply, apply Lock Out Tag Out, prevent access, provide emergency assistance without touching an energized casualty, inspect equipment and cables, and resume only after authorization.

Likely Root Causes:
•⁠  ⁠Failure to isolate the electrical supply
•⁠  ⁠Inadequate Lock Out Tag Out controls
•⁠  ⁠Damaged cables or equipment
•⁠  ⁠Contact with exposed live conductors
•⁠  ⁠Unauthorized electrical work
•⁠  ⁠Failure to test for dead

Immediate Corrective Actions:
•⁠  ⁠Stop work immediately.
•⁠  ⁠Isolate the electrical source.
•⁠  ⁠Apply Lock Out Tag Out.
•⁠  ⁠Barricade the affected area.
•⁠  ⁠Call emergency services where required.
•⁠  ⁠Inspect all affected electrical equipment.

Preventive Actions:
•⁠  ⁠Allow only authorized electricians.
•⁠  ⁠Test for dead before starting work.
•⁠  ⁠Inspect cables, tools, and panels regularly.
•⁠  ⁠Use insulated tools and suitable PPE.
•⁠  ⁠Maintain effective Lock Out Tag Out procedures.
•⁠  ⁠Conduct electrical safety training.

Lessons Learned:
Electrical work must never begin until the system is isolated, locked, tagged, tested, and confirmed safe.
''';
  }

  if (question.contains('dropped') ||
      question.contains('dropped object') ||
      question.contains('drop') ||
      question.contains('falling object') ||
      question.contains('object fell') ||
      question.contains('tool fell') ||
      question.contains('material fell')) {
    return '''
SENTINEL AI DROPPED OBJECT INCIDENT ANALYSIS

Risk Score:
90 / 100

Risk Level:
EXTREME

Likelihood:
Likely

Consequence:
Major

Priority:
STOP WORK IMMEDIATELY

AI Recommendation:
Stop work, secure and barricade the drop zone, assist affected persons, inspect the work area above, identify the source, verify tool tethering and material storage, and resume only after the area is declared safe.

Likely Root Causes:
•⁠  ⁠Tools or materials were not secured
•⁠  ⁠Inadequate toe boards or edge protection
•⁠  ⁠Poor housekeeping at height
•⁠  ⁠Failure to use tool lanyards
•⁠  ⁠Materials stored too close to an edge
•⁠  ⁠Personnel entered an uncontrolled drop zone

Immediate Corrective Actions:
•⁠  ⁠Stop work immediately.
•⁠  ⁠Barricade the drop zone.
•⁠  ⁠Assist any injured person.
•⁠  ⁠Inspect the work area above.
•⁠  ⁠Remove unsecured materials.
•⁠  ⁠Preserve evidence for investigation.

Preventive Actions:
•⁠  ⁠Use tool lanyards and approved tethering systems.
•⁠  ⁠Install toe boards and edge protection.
•⁠  ⁠Store materials away from edges.
•⁠  ⁠Maintain exclusion zones below overhead work.
•⁠  ⁠Conduct dropped-object inspections.
•⁠  ⁠Brief workers before overhead activities.

Lessons Learned:
All tools and materials used at height must be secured, and effective exclusion zones must be maintained below overhead work.
''';
  }

  if (question.contains('chemical spill') ||
      question.contains('chemical leak') ||
      question.contains('hazardous substance') ||
      question.contains('oil spill') ||
      question.contains('gas leak')) {
    return '''
SENTINEL AI CHEMICAL SPILL INCIDENT ANALYSIS

Risk Score:
93 / 100

Risk Level:
EXTREME

Likelihood:
Likely

Consequence:
Catastrophic

Priority:
STOP WORK IMMEDIATELY

AI Recommendation:
Stop work, raise the alarm, isolate the area, prevent contact, identify the chemical using the SDS, use suitable PPE, stop the leak only if safe, contain the spill, protect drains and soil, and notify emergency and environmental teams.

Likely Root Causes:
•⁠  ⁠Damaged chemical container or pipeline
•⁠  ⁠Poor storage or handling
•⁠  ⁠Failure of valves, hoses, or fittings
•⁠  ⁠Inadequate inspection and maintenance
•⁠  ⁠Incorrect transfer procedure
•⁠  ⁠Lack of secondary containment

Immediate Corrective Actions:
•⁠  ⁠Stop work and raise the alarm.
•⁠  ⁠Isolate and barricade the affected area.
•⁠  ⁠Identify the substance using the SDS.
•⁠  ⁠Wear suitable chemical-resistant PPE.
•⁠  ⁠Stop the source only if safe.
•⁠  ⁠Contain the spill using approved spill kits.
•⁠  ⁠Protect drains, soil, and watercourses.
•⁠  ⁠Notify emergency and environmental personnel.

Preventive Actions:
•⁠  ⁠Store chemicals in approved containers.
•⁠  ⁠Provide suitable secondary containment.
•⁠  ⁠Inspect tanks, hoses, valves, and fittings regularly.
•⁠  ⁠Train personnel in chemical handling and spill response.
•⁠  ⁠Maintain accessible spill kits and SDS documents.
•⁠  ⁠Conduct emergency spill-response drills.

Lessons Learned:
Chemical incidents require immediate isolation, correct PPE, effective containment, environmental protection, and prompt emergency notification.
''';
  }

  return '''
SENTINEL AI INCIDENT ANALYSIS

Risk Level:
MEDIUM

Likely Root Causes:
•⁠  ⁠Inadequate hazard control
•⁠  ⁠Unsafe behaviour or condition
•⁠  ⁠Weak supervision
•⁠  ⁠Failure to follow the approved procedure

Immediate Corrective Actions:
•⁠  ⁠Stop the activity.
•⁠  ⁠Secure the area.
•⁠  ⁠Assist affected persons.
•⁠  ⁠Notify responsible personnel.
•⁠  ⁠Begin a formal investigation.

Preventive Actions:
•⁠  ⁠Review the risk assessment and procedure.
•⁠  ⁠Retrain the workforce.
•⁠  ⁠Strengthen supervision.
•⁠  ⁠Assign and track corrective actions.
•⁠  ⁠Verify effectiveness before closure.

Lessons Learned:
All incidents must be reported promptly, investigated thoroughly, and communicated to prevent recurrence.
''';
}
