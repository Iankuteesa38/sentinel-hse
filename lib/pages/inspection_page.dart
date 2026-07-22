import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import '../models/inspection_record.dart';

enum InspectionStatus { compliant, nonCompliant, notApplicable }

class InspectionPage extends StatefulWidget {
  const InspectionPage({super.key});

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController inspectorController = TextEditingController();
  final Map<String, TextEditingController> _commentControllers = {
    'Housekeeping': TextEditingController(),
    'PPE Compliance': TextEditingController(),
    'Fire Extinguishers': TextEditingController(),
    'Emergency Exit': TextEditingController(),
    'Working at Height': TextEditingController(),
    'Scaffolding': TextEditingController(),
    'Access and Egress': TextEditingController(),
    'Barricades and Signage': TextEditingController(),
    'Excavation Safety': TextEditingController(),
    'Lifting Operations': TextEditingController(),
    'Electrical Safety': TextEditingController(),
    'Hot Work': TextEditingController(),
    'Tools and Equipment': TextEditingController(),
    'First Aid Facilities': TextEditingController(),
    'Chemical Storage': TextEditingController(),
    'Environmental Controls': TextEditingController(),
    'Vehicle Movement': TextEditingController(),
    'Welfare Facilities': TextEditingController(),
  };
  final List<File> _inspectionImages = [];
  InspectionStatus housekeeping = InspectionStatus.notApplicable;
  InspectionStatus ppe = InspectionStatus.notApplicable;
  InspectionStatus fire = InspectionStatus.notApplicable;
  InspectionStatus emergencyExit = InspectionStatus.notApplicable;
  InspectionStatus workingAtHeight = InspectionStatus.notApplicable;
  InspectionStatus scaffolding = InspectionStatus.notApplicable;
  InspectionStatus accessEgress = InspectionStatus.notApplicable;
  InspectionStatus barricadesSignage = InspectionStatus.notApplicable;
  InspectionStatus excavationSafety = InspectionStatus.notApplicable;
  InspectionStatus liftingOperations = InspectionStatus.notApplicable;
  InspectionStatus electricalSafety = InspectionStatus.notApplicable;
  InspectionStatus hotWork = InspectionStatus.notApplicable;
  InspectionStatus toolsEquipment = InspectionStatus.notApplicable;
  InspectionStatus firstAidFacilities = InspectionStatus.notApplicable;
  InspectionStatus chemicalStorage = InspectionStatus.notApplicable;
  InspectionStatus environmentalControls = InspectionStatus.notApplicable;
  InspectionStatus vehicleMovement = InspectionStatus.notApplicable;
  InspectionStatus welfareFacilities = InspectionStatus.notApplicable;
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _inspectionImages.add(File(image.path));
      });
    }
  }

  Widget _buildInspectionStatusSelector({
    required String title,
    required InspectionStatus value,
    required ValueChanged<InspectionStatus> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Compliant'),
                  selected: value == InspectionStatus.compliant,
                  onSelected: (_) {
                    onChanged(InspectionStatus.compliant);
                  },
                ),
                ChoiceChip(
                  label: const Text('Non-Compliant'),
                  selected: value == InspectionStatus.nonCompliant,
                  onSelected: (_) {
                    onChanged(InspectionStatus.nonCompliant);
                  },
                ),
                ChoiceChip(
                  label: const Text('Not Applicable'),
                  selected: value == InspectionStatus.notApplicable,
                  onSelected: (_) {
                    onChanged(InspectionStatus.notApplicable);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentControllers[title],
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Comment / Observation',
                hintText: 'Enter inspection findings or remarks',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _inspectionStatusText(InspectionStatus status) {
    switch (status) {
      case InspectionStatus.compliant:
        return 'Compliant';

      case InspectionStatus.nonCompliant:
        return 'Non-Compliant';

      case InspectionStatus.notApplicable:
        return 'Not Applicable';
    }
  }

  String _inspectionComment(String item) {
    final comment = _commentControllers[item]?.text.trim() ?? '';

    if (comment.isEmpty) {
      return 'No comment';
    }

    return comment.replaceAll('\n', ' ');
  }

  String _generateInspectionData() {
    final project = projectController.text.trim().isEmpty
        ? 'Not specified'
        : projectController.text.trim();

    final location = locationController.text.trim().isEmpty
        ? 'Not specified'
        : locationController.text.trim();

    final inspector = inspectorController.text.trim().isEmpty
        ? 'Not specified'
        : inspectorController.text.trim();

    return '''
Project: $project
Location: $location
Inspector: $inspector
Date: ${DateTime.now()}
Housekeeping: ${_inspectionStatusText(housekeeping)}
Housekeeping Comment: ${_inspectionComment('Housekeeping')}
PPE Compliance: ${_inspectionStatusText(ppe)}
PPE Compliance Comment: ${_inspectionComment('PPE Compliance')}
Fire Extinguishers: ${_inspectionStatusText(fire)}
Fire Extinguishers Comment: ${_inspectionComment('Fire Extinguishers')}
Emergency Exit: ${_inspectionStatusText(emergencyExit)}
Emergency Exit Comment: ${_inspectionComment('Emergency Exit')}
Working at Height: ${_inspectionStatusText(workingAtHeight)}
Working at Height Comment: ${_inspectionComment('Working at Height')}
Scaffolding: ${_inspectionStatusText(scaffolding)}
Scaffolding Comment: ${_inspectionComment('Scaffolding')}
Access and Egress: ${_inspectionStatusText(accessEgress)}
Access and Egress Comment: ${_inspectionComment('Access and Egress')}
Barricades and Signage: ${_inspectionStatusText(barricadesSignage)}
Barricades and Signage Comment: ${_inspectionComment('Barricades and Signage')}
Excavation Safety: ${_inspectionStatusText(excavationSafety)}
Excavation Safety Comment: ${_inspectionComment('Excavation Safety')}
Lifting Operations: ${_inspectionStatusText(liftingOperations)}
Lifting Operations Comment: ${_inspectionComment('Lifting Operations')}
Electrical Safety: ${_inspectionStatusText(electricalSafety)}
Electrical Safety Comment: ${_inspectionComment('Electrical Safety')}
Hot Work: ${_inspectionStatusText(hotWork)}
Hot Work Comment: ${_inspectionComment('Hot Work')}
Tools and Equipment: ${_inspectionStatusText(toolsEquipment)}
Tools and Equipment Comment: ${_inspectionComment('Tools and Equipment')}
First Aid Facilities: ${_inspectionStatusText(firstAidFacilities)}
First Aid Facilities Comment: ${_inspectionComment('First Aid Facilities')}
Chemical Storage: ${_inspectionStatusText(chemicalStorage)}
Chemical Storage Comment: ${_inspectionComment('Chemical Storage')}
Environmental Controls: ${_inspectionStatusText(environmentalControls)}
Environmental Controls Comment: ${_inspectionComment('Environmental Controls')}
Vehicle Movement: ${_inspectionStatusText(vehicleMovement)}
Vehicle Movement Comment: ${_inspectionComment('Vehicle Movement')}
Welfare Facilities: ${_inspectionStatusText(welfareFacilities)}
Welfare Facilities Comment: ${_inspectionComment('Welfare Facilities')}
Photos: ${_inspectionImages.isEmpty ? "No photo" : _inspectionImages.map((image) => image.path).join(" | ")}
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Site Inspection")),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Project", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: projectController),
          const SizedBox(height: 20),

          const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: locationController),
          const SizedBox(height: 20),

          const Text(
            "Inspector",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(controller: inspectorController),
          const SizedBox(height: 30),

          const Text(
            "Inspection Checklist",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          _buildInspectionStatusSelector(
            title: 'Housekeeping',
            value: housekeeping,
            onChanged: (value) {
              setState(() {
                housekeeping = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'PPE Compliance',
            value: ppe,
            onChanged: (value) {
              setState(() {
                ppe = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Fire Extinguishers',
            value: fire,
            onChanged: (value) {
              setState(() {
                fire = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Emergency Exit',
            value: emergencyExit,
            onChanged: (value) {
              setState(() {
                emergencyExit = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Working at Height',
            value: workingAtHeight,
            onChanged: (value) {
              setState(() {
                workingAtHeight = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Scaffolding',
            value: scaffolding,
            onChanged: (value) {
              setState(() {
                scaffolding = value;
              });
            },
          ),
          _buildInspectionStatusSelector(
            title: 'Access and Egress',
            value: accessEgress,
            onChanged: (value) {
              setState(() {
                accessEgress = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Barricades and Signage',
            value: barricadesSignage,
            onChanged: (value) {
              setState(() {
                barricadesSignage = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Excavation Safety',
            value: excavationSafety,
            onChanged: (value) {
              setState(() {
                excavationSafety = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Lifting Operations',
            value: liftingOperations,
            onChanged: (value) {
              setState(() {
                liftingOperations = value;
              });
            },
          ),
          _buildInspectionStatusSelector(
            title: 'Electrical Safety',
            value: electricalSafety,
            onChanged: (value) {
              setState(() {
                electricalSafety = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Hot Work',
            value: hotWork,
            onChanged: (value) {
              setState(() {
                hotWork = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Tools and Equipment',
            value: toolsEquipment,
            onChanged: (value) {
              setState(() {
                toolsEquipment = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'First Aid Facilities',
            value: firstAidFacilities,
            onChanged: (value) {
              setState(() {
                firstAidFacilities = value;
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Gallery"),
                ),
              ),
            ],
          ),
          _buildInspectionStatusSelector(
            title: 'Chemical Storage',
            value: chemicalStorage,
            onChanged: (value) {
              setState(() {
                chemicalStorage = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Environmental Controls',
            value: environmentalControls,
            onChanged: (value) {
              setState(() {
                environmentalControls = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Vehicle Movement',
            value: vehicleMovement,
            onChanged: (value) {
              setState(() {
                vehicleMovement = value;
              });
            },
          ),

          _buildInspectionStatusSelector(
            title: 'Welfare Facilities',
            value: welfareFacilities,
            onChanged: (value) {
              setState(() {
                welfareFacilities = value;
              });
            },
          ),
          if (_inspectionImages.isNotEmpty)
            SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _inspectionImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _inspectionImages[index],
                          height: 200,
                          width: 260,
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
                                _inspectionImages.removeAt(index);
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
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () async {
              final List<String> photoPaths = [];

              for (final image in _inspectionImages) {
                final savedPath = await StorageService.saveImagePermanently(
                  image,
                );

                photoPaths.add(savedPath);
              }

              final originalPhotoPaths = _inspectionImages.isEmpty
                  ? 'No photo'
                  : _inspectionImages.map((image) => image.path).join(' | ');

              final savedPhotoPaths = photoPaths.isEmpty
                  ? 'No photo'
                  : photoPaths.join(' | ');

              final now = DateTime.now();

              final inspectionData = _generateInspectionData().replaceAll(
                originalPhotoPaths,
                savedPhotoPaths,
              );

              await StorageService.saveInspection(inspectionData);

              final inspectionRecord = InspectionRecord(
                inspectionId: 'INS-${now.millisecondsSinceEpoch}',
                inspector: inspectorController.text.trim().isEmpty
                    ? 'Not specified'
                    : inspectorController.text.trim(),
                location: locationController.text.trim().isEmpty
                    ? 'Not specified'
                    : locationController.text.trim(),
                analysis: inspectionData,
                imagePaths: photoPaths,
                createdAt: now,
                status: 'Open',
                riskLevel: 'Not assessed',
              );

              await StorageService.saveInspectionRecord(inspectionRecord);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("✅ Inspection submitted successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Submit Inspection"),
          ),
        ],
      ),
    );
  }
}
