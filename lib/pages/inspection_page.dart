import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import '../models/inspection_record.dart';

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
  File? _inspectionImage;
  bool housekeeping = false;
  bool ppe = false;
  bool fire = false;
  bool emergencyExit = false;
  bool workingAtHeight = false;
  bool scaffolding = false;
  bool accessEgress = false;
  bool barricadesSignage = false;
  bool excavationSafety = false;
  bool liftingOperations = false;
  bool electricalSafety = false;
  bool hotWork = false;
  bool toolsEquipment = false;
  bool firstAidFacilities = false;
  bool chemicalStorage = false;
  bool environmentalControls = false;
  bool vehicleMovement = false;
  bool welfareFacilities = false;
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _inspectionImage = File(image.path);
      });
    }
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
Housekeeping: $housekeeping
PPE Compliance: $ppe
Fire Extinguishers: $fire
Emergency Exit: $emergencyExit
Working at Height: $workingAtHeight
Scaffolding: $scaffolding
Access and Egress: $accessEgress
Barricades and Signage: $barricadesSignage
Excavation Safety: $excavationSafety
Lifting Operations: $liftingOperations
Electrical Safety: $electricalSafety
Hot Work: $hotWork
Tools and Equipment: $toolsEquipment
First Aid Facilities: $firstAidFacilities
Chemical Storage: $chemicalStorage
Environmental Controls: $environmentalControls
Vehicle Movement: $vehicleMovement
Welfare Facilities: $welfareFacilities
Photo: ${_inspectionImage?.path ?? "No photo"}
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Site Inspection")),
      body: ListView(
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

          CheckboxListTile(
            title: const Text("Housekeeping"),
            value: housekeeping,
            onChanged: (value) {
              setState(() {
                housekeeping = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("PPE Compliance"),
            value: ppe,
            onChanged: (value) {
              setState(() {
                ppe = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Fire Extinguishers"),
            value: fire,
            onChanged: (value) {
              setState(() {
                fire = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Emergency Exit"),
            value: emergencyExit,
            onChanged: (value) {
              setState(() {
                emergencyExit = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Working at Height"),
            value: workingAtHeight,
            onChanged: (value) {
              setState(() {
                workingAtHeight = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Scaffolding"),
            value: scaffolding,
            onChanged: (value) {
              setState(() {
                scaffolding = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Access and Egress"),
            value: accessEgress,
            onChanged: (value) {
              setState(() {
                accessEgress = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Barricades and Signage"),
            value: barricadesSignage,
            onChanged: (value) {
              setState(() {
                barricadesSignage = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Excavation Safety"),
            value: excavationSafety,
            onChanged: (value) {
              setState(() {
                excavationSafety = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Lifting Operations"),
            value: liftingOperations,
            onChanged: (value) {
              setState(() {
                liftingOperations = value ?? false;
              });
            },
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            title: const Text("Electrical Safety"),
            value: electricalSafety,
            onChanged: (value) {
              setState(() {
                electricalSafety = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Hot Work"),
            value: hotWork,
            onChanged: (value) {
              setState(() {
                hotWork = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Tools and Equipment"),
            value: toolsEquipment,
            onChanged: (value) {
              setState(() {
                toolsEquipment = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("First Aid Facilities"),
            value: firstAidFacilities,
            onChanged: (value) {
              setState(() {
                firstAidFacilities = value ?? false;
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
          const SizedBox(height: 12),
          CheckboxListTile(
            title: const Text("Chemical Storage"),
            value: chemicalStorage,
            onChanged: (value) {
              setState(() {
                chemicalStorage = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Environmental Controls"),
            value: environmentalControls,
            onChanged: (value) {
              setState(() {
                environmentalControls = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Vehicle Movement"),
            value: vehicleMovement,
            onChanged: (value) {
              setState(() {
                vehicleMovement = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            title: const Text("Welfare Facilities"),
            value: welfareFacilities,
            onChanged: (value) {
              setState(() {
                welfareFacilities = value ?? false;
              });
            },
          ),
          if (_inspectionImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _inspectionImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () async {
              String photoPath = "No photo";

              if (_inspectionImage != null) {
                photoPath = await StorageService.saveImagePermanently(
                  _inspectionImage!,
                );
              }

              final now = DateTime.now();

              final inspectionData = _generateInspectionData().replaceAll(
                _inspectionImage?.path ?? "No photo",
                photoPath,
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
                imagePath: photoPath == 'No photo' ? '' : photoPath,
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
