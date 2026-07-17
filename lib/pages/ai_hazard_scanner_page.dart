import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import '../services/ai_hazard_service.dart';
import '../services/pdf_service.dart';
import '../models/inspection_record.dart';
import '../models/hazard_analysis_result.dart';

class AIHazardScannerPage extends StatefulWidget {
  const AIHazardScannerPage({super.key});

  @override
  State<AIHazardScannerPage> createState() => _AIHazardScannerPageState();
}

class _AIHazardScannerPageState extends State<AIHazardScannerPage> {
  String inspector = "Ian Kuteesa";
  String location = "ADNOC Buhasa";
  String result = "No image analyzed yet.";
  String rawAnalysis = "";
  HazardAnalysisResult? structuredResult;
  File? selectedImage;
  String? currentInspectionId;
  final ImagePicker picker = ImagePicker();
  String generateInspectionId() {
    final now = DateTime.now();
    final inspectionId = "HSE-${now.year}-${now.millisecondsSinceEpoch}";
    currentInspectionId = inspectionId;
    return inspectionId;
  }

  String extractRiskLevel(String analysis) {
    final match = RegExp(
      r'Risk\s*Level\s*:\s*(Critical|High|Medium|Low)',
      caseSensitive: false,
    ).firstMatch(analysis);

    if (match == null) return 'Unknown';

    final level = match.group(1)!.toLowerCase();

    return '${level[0].toUpperCase()}${level.substring(1)}';
  }

  Future<void> takePhoto() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> choosePhoto() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> analyzeImage() async {
    if (selectedImage == null) {
      setState(() {
        result = 'Please take a photo or choose one from the gallery first.';
      });
      return;
    }

    setState(() {
      result = 'Analyzing image...';
    });

    final combinedResponse = await AIHazardService.analyzeImageCombined(
      selectedImage!,
    );

    final analysis = combinedResponse.analysis;
    final structuredAnalysis = combinedResponse.structuredAnalysis;
    structuredResult = structuredAnalysis;
    debugPrint(structuredAnalysis?.riskLevel);
    if (structuredAnalysis != null) {
      debugPrint("Structured AI received successfully");
    } else {
      debugPrint("Structured AI not available");
    }
    rawAnalysis = analysis;

    if (!mounted) return;

    final now = DateTime.now();
    final inspectionId = generateInspectionId();

    setState(() {
      result =
          '''
Inspection ID: $inspectionId

Date: ${now.day}/${now.month}/${now.year}
Time: ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}

Inspector:
$inspector

Location:
$location

AI Hazard Analysis

$analysis

Status:
Open
''';
    });
    if (!analysis.startsWith('Unable to analyze') &&
        !analysis.startsWith('Analysis failed')) {
      final savedImagePath = await StorageService.saveImagePermanently(
        selectedImage!,
      );

      final record = InspectionRecord(
        inspectionId: inspectionId,
        createdAt: now,
        inspector: inspector,
        location: location,
        analysis: analysis,
        imagePath: savedImagePath,
        status: 'Open',
        riskLevel: extractRiskLevel(analysis),
      );

      await StorageService.saveInspectionRecord(record);
      await StorageService.saveHazard(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Hazard Scanner")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            selectedImage == null
                ? const Icon(Icons.camera_alt, size: 90)
                : Image.file(selectedImage!, height: 220, fit: BoxFit.cover),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: takePhoto,
              child: const Text("Take Photo"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: choosePhoto,
              child: const Text("Choose from Gallery"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: analyzeImage,
              child: const Text("Analyze Image"),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed:
                  selectedImage == null ||
                      currentInspectionId == null ||
                      structuredResult == null
                  ? null
                  : () async {
                      await PdfService.generateHazardReport(
                        inspectionId: currentInspectionId!,
                        inspector: inspector,
                        location: location,
                        analysis: rawAnalysis,
                        imageFile: selectedImage!,
                      );
                    },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generate PDF Report'),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (structuredResult != null)
                          Card(
                            elevation: 2,
                            color: Colors.orange.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Risk Level: ${structuredResult!.riskLevel}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'AI Confidence: '
                                          '${structuredResult!.confidenceScore}%',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (structuredResult != null) const SizedBox(height: 8),

                        if (structuredResult != null)
                          Text(
                            'Hazard Category: ${structuredResult!.hazardCategory}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (structuredResult != null)
                          const SizedBox(height: 16),
                        if (structuredResult == null)
                          Text(result, style: const TextStyle(fontSize: 16)),
                        if (structuredResult != null) const SizedBox(height: 8),

                        if (structuredResult != null)
                          Text(
                            'Likelihood: ${structuredResult!.likelihood}  •  '
                            'Severity: ${structuredResult!.severity}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (structuredResult != null)
                          const SizedBox(height: 12),

                        if (structuredResult != null)
                          Text(
                            'Required PPE:\n'
                            '${structuredResult!.requiredPpe.isEmpty ? '• Not applicable' : structuredResult!.requiredPpe.map((item) => '• $item').join('\n')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (structuredResult != null)
                          const SizedBox(height: 12),

                        if (structuredResult != null)
                          Text(
                            'Required Permits:\n'
                            '${structuredResult!.requiredPermits.isEmpty ? '• Not applicable' : structuredResult!.requiredPermits.map((item) => '• $item').join('\n')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (structuredResult != null)
                          const SizedBox(height: 12),

                        if (structuredResult != null)
                          Text(
                            'Applicable Standards:\n'
                            '${structuredResult!.applicableStandards.isEmpty ? '• Not applicable' : structuredResult!.applicableStandards.map((item) => '• $item').join('\n')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (structuredResult != null)
                          const SizedBox(height: 12),

                        if (structuredResult != null)
                          Text(
                            'Immediate Actions:\n'
                            '${structuredResult!.immediateActions.isEmpty ? '• Not applicable' : structuredResult!.immediateActions.map((item) => '• $item').join('\n')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (structuredResult != null)
                          const SizedBox(height: 12),

                        if (structuredResult != null)
                          Text(
                            'Corrective Actions:\n'
                            '${structuredResult!.correctiveActions.isEmpty ? '• Not applicable' : structuredResult!.correctiveActions.map((item) => '• $item').join('\n')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (structuredResult != null)
                          const SizedBox(height: 12),

                        if (structuredResult != null)
                          Text(
                            'Preventive Actions:\n'
                            '${structuredResult!.preventiveActions.isEmpty ? '• Not applicable' : structuredResult!.preventiveActions.map((item) => '• $item').join('\n')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (structuredResult != null)
                          const SizedBox(height: 12),

                        if (structuredResult != null)
                          Text(
                            'Hazards Found:\n'
                            '${structuredResult!.hazards.isEmpty ? '• No visible hazards identified' : structuredResult!.hazards.map((item) => '• $item').join('\n')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
