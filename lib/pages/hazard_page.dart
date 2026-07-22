import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';

class HazardPage extends StatefulWidget {
  const HazardPage({super.key});

  @override
  State<HazardPage> createState() => _HazardPageState();
}

class _HazardPageState extends State<HazardPage> {
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final reportedByController = TextEditingController();
  final responsiblePersonController = TextEditingController();
  final targetDateController = TextEditingController();
  final immediateControlsController = TextEditingController();
  final correctiveActionController = TextEditingController();
  final preventiveActionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> hazardImages = [];
  String category = "Slip / Trip";
  String riskLevel = "Medium";
  String status = "Open";
  Future<void> pickHazardImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        hazardImages.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hazard Report")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: locationController),

          const SizedBox(height: 20),

          const Text(
            "Hazard Category",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: category,
            items:
                [
                      "Slip / Trip",
                      "Housekeeping",
                      "Electrical",
                      "Fire",
                      "PPE",
                      "Working at Height",
                      "Scaffolding",
                      "Confined Space",
                      "Excavation",
                      "Lifting Operations",
                      "Dropped Objects",
                      "Vehicle / Traffic",
                      "Machinery / Equipment",
                      "Hot Work / Welding",
                      "Chemical Exposure",
                      "Gas / Toxic Release",
                      "Manual Handling",
                      "Noise / Vibration",
                      "Heat Stress",
                      "Pressure Systems",
                      "Structural / Collapse",
                      "Environmental",
                      "Biological",
                      "Ergonomic",
                      "Other",
                    ]
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                category = value!;
              });
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(controller: descriptionController, maxLines: 4),

          const SizedBox(height: 20),

          const Text(
            "Risk Level",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: riskLevel,
            items: ["Low", "Medium", "High", "Extreme"]
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              setState(() {
                riskLevel = value!;
              });
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "Reported By",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: reportedByController,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 20),

          const Text(
            "Risk Owner / Responsible Person",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: responsiblePersonController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: "Enter responsible person",
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Target Completion Date",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: targetDateController,
            readOnly: true,
            decoration: const InputDecoration(
              hintText: "Select target date",
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              );

              if (selectedDate != null) {
                targetDateController.text = selectedDate
                    .toIso8601String()
                    .split('T')
                    .first;
              }
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "Immediate Controls / Containment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: immediateControlsController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Enter immediate temporary controls",
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Corrective Action",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: correctiveActionController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Enter permanent corrective action",
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Preventive Action",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: preventiveActionController,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },
            decoration: const InputDecoration(
              hintText: "Enter controls to prevent recurrence",
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Hazard Photo",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => pickHazardImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Take Photo"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => pickHazardImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Gallery"),
                ),
              ),
            ],
          ),

          if (hazardImages.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: hazardImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          hazardImages[index],
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
                                hazardImages.removeAt(index);
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
          const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: status,
            items: ["Open", "Closed"]
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              setState(() {
                status = value!;
              });
            },
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () async {
              final List<String> hazardPhotoPaths = [];

              for (final image in hazardImages) {
                final savedPath = await StorageService.saveImagePermanently(
                  image,
                );

                hazardPhotoPaths.add(savedPath);
              }

              final hazardPhotosText = hazardPhotoPaths.isEmpty
                  ? 'No photo'
                  : hazardPhotoPaths.join(' | ');
              String hazard =
                  "Location: ${locationController.text.trim()}\n"
                  "Category: $category\n"
                  "Description: ${descriptionController.text.trim()}\n"
                  "Risk Level: $riskLevel\n"
                  "Persons Exposed: To be confirmed by the responsible supervisor.\n"
                  "Responsible Person: ${responsiblePersonController.text.trim()}\n"
                  "Target Date: ${targetDateController.text.trim()}\n"
                  "Immediate Controls: ${immediateControlsController.text.trim()}\n"
                  "Corrective Action: ${correctiveActionController.text.trim()}\n"
                  "Preventive Action: ${preventiveActionController.text.trim()}\n"
                  "Photos: $hazardPhotosText\n"
                  "Reported By: ${reportedByController.text.trim()}\n"
                  "Status: $status";

              await StorageService.saveHazard(hazard);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Hazard Report Saved")),
              );
            },
            child: const Text("Save Hazard"),
          ),
        ],
      ),
    );
  }
}
