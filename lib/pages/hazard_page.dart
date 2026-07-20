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
          TextField(controller: reportedByController),

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
                  "Location: ${locationController.text}\n"
                  "Category: $category\n"
                  "Description: ${descriptionController.text}\n"
                  "Risk Level: $riskLevel\n"
                  "Photos: $hazardPhotosText\n"
                  "Reported By: ${reportedByController.text}\n"
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
