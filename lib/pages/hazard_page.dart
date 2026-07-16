import 'package:flutter/material.dart';
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

  String category = "Slip / Trip";
  String riskLevel = "Medium";
  String status = "Open";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hazard Report"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: locationController),

          const SizedBox(height: 20),

          const Text("Hazard Category", style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: category,
            items: ["Slip / Trip", "Electrical", "Fire", "PPE", "Working at Height", "Housekeeping"]
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              setState(() {
                category = value!;
              });
            },
          ),

          const SizedBox(height: 20),

          const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: descriptionController,
            maxLines: 4,
          ),

          const SizedBox(height: 20),

          const Text("Risk Level", style: TextStyle(fontWeight: FontWeight.bold)),
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

          const Text("Reported By", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: reportedByController),

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
  String hazard =
      "Location: ${locationController.text}\n"
      "Category: $category\n"
      "Description: ${descriptionController.text}\n"
      "Risk Level: $riskLevel\n"
      "Reported By: ${reportedByController.text}\n"
      "Status: $status";

  await StorageService.saveHazard(hazard);
if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("✅ Hazard Report Saved"),
    ),
  );
},
            child: const Text("Save Hazard"),
          ),
        ],
      ),
    );
  }
}