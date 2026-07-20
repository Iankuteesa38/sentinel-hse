import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({super.key});

  @override
  State<IncidentReportPage> createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final injuredPersonController = TextEditingController();
  final witnessController = TextEditingController();
  final immediateActionController = TextEditingController();

  final immediateCauseController = TextEditingController();
  final rootCauseController = TextEditingController();
  final unsafeActController = TextEditingController();
  final unsafeConditionController = TextEditingController();
  final correctiveActionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> incidentImages = [];

  String incidentType = 'Near Miss';
  String severity = 'Medium';
  String status = 'Open';

  String investigationSummary = '';
  Future<void> pickIncidentImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        incidentImages.add(File(image.path));
      });
    }
  }

  void generateInvestigationSummary() {
    final description = descriptionController.text.trim();
    final immediateCause = immediateCauseController.text.trim();
    final rootCause = rootCauseController.text.trim();
    final unsafeAct = unsafeActController.text.trim();
    final unsafeCondition = unsafeConditionController.text.trim();
    final correctiveAction = correctiveActionController.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the incident description first.'),
        ),
      );
      return;
    }

    setState(() {
      String riskLevel;

      String aiRootCause;
      String aiCorrectiveAction;
      String aiPreventiveAction;
      String lessonsLearned;
      String aiUnsafeCondition;
      if (severity == 'Critical' || severity == 'High') {
        riskLevel = 'HIGH';
      } else if (severity == 'Medium') {
        riskLevel = 'MEDIUM';
      } else {
        riskLevel = 'LOW';
      }
      final descriptionText = description.toLowerCase();

      if (descriptionText.contains('vehicle') ||
          descriptionText.contains('driver') ||
          descriptionText.contains('reverse') ||
          descriptionText.contains('pedestrian')) {
        aiRootCause =
            'Inadequate vehicle movement control, poor pedestrian segregation, or failure to use a trained banksman.';

        aiUnsafeCondition =
            'Vehicle and pedestrian routes were not adequately separated or controlled.';

        aiCorrectiveAction =
            'Stop similar vehicle movements, review the traffic management plan, retrain the driver, and use a trained banksman during reversing.';

        aiPreventiveAction =
            'Install clear pedestrian walkways, barriers, reversing controls, warning signs, and conduct regular driver competency assessments.';

        lessonsLearned =
            'Reversing operations must be properly planned, pedestrians must be segregated, and drivers must confirm the area is clear before moving.';
      } else if (descriptionText.contains('fall') ||
          descriptionText.contains('height') ||
          descriptionText.contains('scaffold') ||
          descriptionText.contains('ladder')) {
        aiRootCause =
            'Inadequate work-at-height planning, improper access equipment, or failure to maintain fall protection controls.';

        aiUnsafeCondition =
            'The work area may have lacked suitable guardrails, safe access, approved anchor points, or properly inspected equipment.';

        aiCorrectiveAction =
            'Stop the work, secure the area, inspect the access equipment, verify fall-protection systems, and brief the involved workers.';

        aiPreventiveAction =
            'Implement an approved work-at-height permit, inspect scaffolds and ladders, enforce 100% tie-off, and conduct regular competency checks.';

        lessonsLearned =
            'Work at height must be properly planned, supervised, and performed only with approved access and fall-protection systems.';
      } else if (descriptionText.contains('electric') ||
          descriptionText.contains('electrical') ||
          descriptionText.contains('shock') ||
          descriptionText.contains('live wire') ||
          descriptionText.contains('cable')) {
        aiRootCause =
            'Exposure to energized equipment, inadequate isolation, or failure to verify zero energy before work.';

        aiUnsafeCondition =
            'Live electrical parts were exposed or electrical isolation procedures were not fully implemented.';

        aiCorrectiveAction =
            'Stop the work immediately, isolate the electrical source, secure the area, and inspect all affected equipment before restarting work.';

        aiPreventiveAction =
            'Apply Lock Out Tag Out (LOTO), inspect electrical tools regularly, verify isolation before work, and ensure only authorized electricians perform electrical tasks.';

        lessonsLearned =
            'Electrical work must only be performed after proper isolation, testing, and authorization to prevent electric shock and arc flash incidents.';
      } else if (descriptionText.contains('fire') ||
          descriptionText.contains('flame') ||
          descriptionText.contains('burn') ||
          descriptionText.contains('smoke') ||
          descriptionText.contains('explosion')) {
        aiRootCause =
            'Presence of an ignition source, poor housekeeping, flammable materials, or inadequate fire prevention controls.';

        aiUnsafeCondition =
            'Flammable materials were exposed to heat or ignition sources, or fire protection systems were inadequate.';

        aiCorrectiveAction =
            'Raise the alarm, stop work immediately, evacuate personnel, isolate energy sources where safe, and extinguish the fire using the correct fire extinguisher if trained to do so.';

        aiPreventiveAction =
            'Maintain good housekeeping, control ignition sources, inspect fire extinguishers regularly, store flammable materials safely, and conduct routine fire drills.';

        lessonsLearned =
            'Fire incidents can be prevented through proper housekeeping, control of ignition sources, and strict compliance with fire safety procedures.';
      } else if (descriptionText.contains('confined') ||
          descriptionText.contains('tank') ||
          descriptionText.contains('vessel') ||
          descriptionText.contains('manhole') ||
          descriptionText.contains('oxygen') ||
          descriptionText.contains('gas')) {
        aiRootCause =
            'Failure to follow confined space entry procedures, inadequate atmospheric testing, or ineffective permit controls.';

        aiUnsafeCondition =
            'The confined space may have contained hazardous gases, oxygen deficiency, or inadequate ventilation.';

        aiCorrectiveAction =
            'Stop the work immediately, evacuate all personnel, isolate the confined space, perform atmospheric gas testing, and review the entry permit before restarting work.';

        aiPreventiveAction =
            'Ensure gas testing is completed before entry, maintain continuous atmospheric monitoring, assign a trained standby attendant, verify rescue equipment is available, and strictly follow the confined space permit system.';

        lessonsLearned =
            'Confined space work must never begin without gas testing, an approved entry permit, continuous monitoring, and an emergency rescue plan.';
      } else {
        aiRootCause =
            'Further investigation is required to identify the underlying management, procedural, or human-factor causes.';

        aiUnsafeCondition =
            'The unsafe condition requires further assessment based on the incident evidence.';

        aiCorrectiveAction =
            'Control the immediate hazard, brief the affected workforce, and assign corrective actions to responsible persons.';

        aiPreventiveAction =
            'Review the relevant procedure, strengthen supervision, and monitor the effectiveness of implemented controls.';

        lessonsLearned =
            'All incidents must be investigated promptly and lessons must be communicated to prevent recurrence.';
      }
      investigationSummary =
          '''
SENTINEL AI INCIDENT INVESTIGATION
AI Risk Level: $riskLevel
Incident Type: $incidentType
Severity: $severity
Location: ${locationController.text.trim().isEmpty ? 'Not provided' : locationController.text.trim()}

Incident Description:
$description
AI Suggested Root Cause:
$aiRootCause

AI Identified Unsafe Condition:
$aiUnsafeCondition

AI Recommended Corrective Action:
$aiCorrectiveAction

AI Recommended Preventive Action:
$aiPreventiveAction

Lessons Learned:
$lessonsLearned
Immediate Cause:
${immediateCause.isEmpty ? 'Further investigation required.' : immediateCause}

Root Cause:
${rootCause.isEmpty ? 'Root cause analysis is pending.' : rootCause}

Unsafe Act:
${unsafeAct.isEmpty ? 'No unsafe act recorded.' : unsafeAct}

Unsafe Condition:
${unsafeCondition.isEmpty ? 'No unsafe condition recorded.' : unsafeCondition}

Immediate Action Taken:
${immediateActionController.text.trim().isEmpty ? 'No immediate action recorded.' : immediateActionController.text.trim()}

Recommended Corrective Actions:
${correctiveAction.isEmpty ? 'Implement suitable corrective actions and verify closure.' : correctiveAction}

AI Recommendation:
•⁠  ⁠Secure the incident area.
•⁠  ⁠Preserve evidence and photographs.
•⁠  ⁠Interview the injured person and witnesses.
•⁠  ⁠Verify the immediate and root causes.
•⁠  ⁠Assign responsible persons and due dates.
•⁠  ⁠Conduct a follow-up inspection.
•⁠  ⁠Share lessons learned with the workforce.
''';
    });
  }

  Future<void> saveIncident() async {
    if (locationController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        immediateActionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete the location, description and immediate action.',
          ),
        ),
      );
      return;
    }

    if (investigationSummary.isEmpty) {
      generateInvestigationSummary();
    }
    final List<String> incidentPhotoPaths = [];

    for (final image in incidentImages) {
      final savedPath = await StorageService.saveImagePermanently(image);

      incidentPhotoPaths.add(savedPath);
    }

    final incidentPhotosText = incidentPhotoPaths.isEmpty
        ? 'No photo'
        : incidentPhotoPaths.join(' | ');
    final incidentData =
        '''
Location: ${locationController.text.trim()}
Incident Type: $incidentType
Severity: $severity
Description: ${descriptionController.text.trim()}
Injured Person: ${injuredPersonController.text.trim().isEmpty ? 'None' : injuredPersonController.text.trim()}
Witness: ${witnessController.text.trim().isEmpty ? 'None' : witnessController.text.trim()}
Immediate Action: ${immediateActionController.text.trim()}
Immediate Cause: ${immediateCauseController.text.trim().isEmpty ? 'Pending investigation' : immediateCauseController.text.trim()}
Root Cause: ${rootCauseController.text.trim().isEmpty ? 'Pending investigation' : rootCauseController.text.trim()}
Unsafe Act: ${unsafeActController.text.trim().isEmpty ? 'None recorded' : unsafeActController.text.trim()}
Unsafe Condition: ${unsafeConditionController.text.trim().isEmpty ? 'None recorded' : unsafeConditionController.text.trim()}
Corrective Actions: ${correctiveActionController.text.trim().isEmpty ? 'Pending assignment' : correctiveActionController.text.trim()}
Photos: $incidentPhotosText
Status: $status
Date: ${DateTime.now()}
''';

    await StorageService.saveIncident(incidentData);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Incident investigation saved successfully'),
      ),
    );

    locationController.clear();
    descriptionController.clear();
    injuredPersonController.clear();
    witnessController.clear();
    immediateActionController.clear();
    immediateCauseController.clear();
    rootCauseController.clear();
    unsafeActController.clear();
    unsafeConditionController.clear();
    correctiveActionController.clear();

    setState(() {
      incidentType = 'Near Miss';
      severity = 'Medium';
      status = 'Open';
      investigationSummary = '';
    });
  }

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    injuredPersonController.dispose();
    witnessController.dispose();
    immediateActionController.dispose();
    immediateCauseController.dispose();
    rootCauseController.dispose();
    unsafeActController.dispose();
    unsafeConditionController.dispose();
    correctiveActionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Incident Investigation')),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Incident Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: locationController,
            decoration: const InputDecoration(
              hintText: 'Enter incident location',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Incident Type',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<String>(
            initialValue: incidentType,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items:
                [
                      'Near Miss',
                      'First Aid',
                      'Medical Treatment',
                      'Lost Time Injury',
                      'Property Damage',
                      'Vehicle Accident',
                      'Environmental Incident',
                    ]
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                incidentType = value;
              });
            },
          ),

          const SizedBox(height: 20),

          const Text('Severity', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField<String>(
            initialValue: severity,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: ['Low', 'Medium', 'High', 'Critical']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                severity = value;
              });
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Incident Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Describe what happened',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Injured Person',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: injuredPersonController,
            decoration: const InputDecoration(
              hintText: 'Enter name or leave blank',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text('Witness', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: witnessController,
            decoration: const InputDecoration(
              hintText: 'Enter witness name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Immediate Action Taken',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: immediateActionController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'What was done immediately?',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Incident Investigation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          const Text(
            'Immediate Cause',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: immediateCauseController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Example: Worker slipped on wet surface',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Root Cause',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: rootCauseController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Example: Inadequate housekeeping inspection',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Unsafe Act',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: unsafeActController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Describe any unsafe behaviour',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Unsafe Condition',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: unsafeConditionController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Describe any unsafe workplace condition',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Corrective Actions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: correctiveActionController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter corrective and preventive actions',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Incident Evidence Photo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => pickIncidentImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => pickIncidentImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ),
            ],
          ),

          if (incidentImages.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: incidentImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          incidentImages[index],
                          height: 220,
                          width: 280,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                incidentImages.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 20),
          const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField<String>(
            initialValue: status,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: ['Open', 'Under Investigation', 'Closed']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                status = value;
              });
            },
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: generateInvestigationSummary,
              icon: const Icon(Icons.smart_toy),
              label: const Text('Generate AI Investigation Summary'),
            ),
          ),

          if (investigationSummary.isNotEmpty) ...[
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  investigationSummary,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: saveIncident,
              icon: const Icon(Icons.save),
              label: const Text('Save Incident Investigation'),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
