import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';

class ActionPage extends StatefulWidget {
  final String? initialHazard;
  final String? inspectionId;

  const ActionPage({super.key, this.initialHazard, this.inspectionId});

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  final hazardController = TextEditingController();
  final actionController = TextEditingController();
  final responsibleController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> evidenceImages = [];
  String priority = "Medium";
  String status = "Open";
  DateTime? dueDate;
  @override
  void initState() {
    super.initState();

    if (widget.initialHazard != null) {
      hazardController.text = widget.initialHazard!;
    }
  }

  Future<void> pickEvidenceImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        evidenceImages.add(File(image.path));
      });
    }
  }

  Future<void> selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (pickedDate != null) {
      setState(() {
        dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Corrective Action")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.inspectionId != null) ...[
            Text(
              'Inspection ID: ${widget.inspectionId}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
          ],
          const Text("Hazard", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: hazardController,
            minLines: 5,
            maxLines: 12,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Action Required",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: actionController,
            minLines: 5,
            maxLines: 12,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Responsible Person",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(controller: responsibleController),
          const SizedBox(height: 20),
          const Text(
            "Corrective Action Evidence",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => pickEvidenceImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Take Photo"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => pickEvidenceImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Gallery"),
                ),
              ),
            ],
          ),

          if (evidenceImages.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: evidenceImages.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          evidenceImages[index],
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              evidenceImages.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 20),
          const Text("Due Date", style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          InkWell(
            onTap: selectDueDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                dueDate == null
                    ? 'Select due date'
                    : '${dueDate!.day.toString().padLeft(2, '0')}/'
                          '${dueDate!.month.toString().padLeft(2, '0')}/'
                          '${dueDate!.year}',
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text("Priority", style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: priority,
            items: ["Low", "Medium", "High"].map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: (value) {
              setState(() {
                priority = value!;
              });
            },
          ),

          const SizedBox(height: 20),

          const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: status,
            items: ["Open", "Closed"].map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: (value) {
              setState(() {
                status = value!;
              });
            },
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () async {
              if (hazardController.text.trim().isEmpty ||
                  actionController.text.trim().isEmpty ||
                  responsibleController.text.trim().isEmpty ||
                  dueDate == null ||
                  evidenceImages.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please complete all fields, select a due date and add an evidence photo.',
                    ),
                  ),
                );
                return;
              }
              final evidencePhotoPaths = <String>[];

              for (final evidenceImage in evidenceImages) {
                final savedPath = await StorageService.saveImagePermanently(
                  evidenceImage,
                );

                evidencePhotoPaths.add(savedPath);
              }
              String actionData =
                  '''
Hazard: ${hazardController.text}
Action: ${actionController.text}
Responsible: ${responsibleController.text}
Priority: $priority
Status: $status
Due Date: ${dueDate?.toString().split(' ')[0] ?? "Not Set"}
Evidence Photos: ${evidencePhotoPaths.join('|')}
Date: ${DateTime.now()}
''';

              await StorageService.saveAction(actionData);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Corrective Action Saved")),
              );

              hazardController.clear();
              actionController.clear();
              responsibleController.clear();
              setState(() {
                dueDate = null;
              });
            },
            child: const Text("Save Action"),
          ),
        ],
      ),
    );
  }
}
