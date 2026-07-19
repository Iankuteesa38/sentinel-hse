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
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

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

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.camera_alt),
            label: const Text("Add Inspection Photo"),
          ),
          const SizedBox(height: 12),

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
