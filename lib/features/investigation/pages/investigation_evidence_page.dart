import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../services/storage_service.dart';
import 'package:flutter/material.dart';

import '../models/investigation_evidence.dart';
import '../services/investigation_draft_service.dart';

class InvestigationEvidencePage extends StatefulWidget {
  const InvestigationEvidencePage({super.key});

  @override
  State<InvestigationEvidencePage> createState() =>
      _InvestigationEvidencePageState();
}

class _InvestigationEvidencePageState extends State<InvestigationEvidencePage> {
  final titleController = TextEditingController();
  final sourceController = TextEditingController();
  final obtainedByController = TextEditingController();
  final storageLocationController = TextEditingController();
  final descriptionController = TextEditingController();
  final relevanceController = TextEditingController();

  InvestigationEvidenceType evidenceType = InvestigationEvidenceType.document;

  InvestigationEvidenceStatus evidenceStatus =
      InvestigationEvidenceStatus.unverified;

  bool integrityVerified = false;
  final ImagePicker _picker = ImagePicker();

  File? selectedEvidenceFile;
  Future<void> _pickEvidencePhoto(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      selectedEvidenceFile = File(picked.path);
      evidenceType = InvestigationEvidenceType.photograph;
    });
  }

  String _label(Object value) {
    final raw = value.toString().split('.').last;

    return raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
  }

  Future<void> _addEvidence() async {
    if (titleController.text.trim().isEmpty) {
      return;
    }

    final evidence = InvestigationDraftService.current.evidence;
    String savedFilePath = '';

    if (selectedEvidenceFile != null) {
      savedFilePath = await StorageService.saveImagePermanently(
        selectedEvidenceFile!,
      );
    }
    setState(() {
      evidence.add(
        InvestigationEvidence(
          evidenceId: 'EV-${(evidence.length + 1).toString().padLeft(3, '0')}',
          title: titleController.text.trim(),
          type: evidenceType,
          status: evidenceStatus,
          source: sourceController.text.trim(),
          obtainedAt: DateTime.now(),
          obtainedBy: obtainedByController.text.trim(),
          storageLocation: storageLocationController.text.trim(),
          integrityVerified: integrityVerified,
          description: descriptionController.text.trim(),
          relevance: relevanceController.text.trim(),
          filePath: savedFilePath,
        ),
      );

      titleController.clear();
      sourceController.clear();
      obtainedByController.clear();
      storageLocationController.clear();
      descriptionController.clear();
      relevanceController.clear();

      evidenceType = InvestigationEvidenceType.document;
      evidenceStatus = InvestigationEvidenceStatus.unverified;
      integrityVerified = false;
      selectedEvidenceFile = null;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    sourceController.dispose();
    obtainedByController.dispose();
    storageLocationController.dispose();
    descriptionController.dispose();
    relevanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final evidence = InvestigationDraftService.current.evidence;

    return Scaffold(
      appBar: AppBar(title: const Text('Evidence Register'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Evidence Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<InvestigationEvidenceType>(
            initialValue: evidenceType,
            decoration: const InputDecoration(
              labelText: 'Evidence Type',
              border: OutlineInputBorder(),
            ),
            items: InvestigationEvidenceType.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(_label(value)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => evidenceType = value);
              }
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<InvestigationEvidenceStatus>(
            initialValue: evidenceStatus,
            decoration: const InputDecoration(
              labelText: 'Evidence Status',
              border: OutlineInputBorder(),
            ),
            items: InvestigationEvidenceStatus.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(_label(value)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => evidenceStatus = value);
              }
            },
          ),

          const SizedBox(height: 12),

          TextField(
            controller: sourceController,
            decoration: const InputDecoration(
              labelText: 'Source',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: obtainedByController,
            decoration: const InputDecoration(
              labelText: 'Obtained By',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: storageLocationController,
            decoration: const InputDecoration(
              labelText: 'Storage Location',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: relevanceController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Relevance to Investigation',
              border: OutlineInputBorder(),
            ),
          ),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: integrityVerified,
            title: const Text('Evidence integrity verified'),
            onChanged: (value) {
              setState(() => integrityVerified = value ?? false);
            },
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickEvidencePhoto(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Take Photo'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickEvidencePhoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Gallery'),
                ),
              ),
            ],
          ),

          if (selectedEvidenceFile != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                selectedEvidenceFile!,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  selectedEvidenceFile = null;
                });
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove Photo'),
            ),
          ],

          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _addEvidence,
            icon: const Icon(Icons.add),
            label: const Text('Add Evidence'),
          ),

          const SizedBox(height: 20),

          ...evidence.map(
            (item) => Card(
              child: ListTile(
                leading: Icon(
                  item.filePath.isNotEmpty
                      ? Icons.photo_outlined
                      : Icons.folder_copy_outlined,
                ),
                title: Text('${item.evidenceId} - ${item.title}'),
                subtitle: Text(
                  '${_label(item.type)} | '
                  '${_label(item.status)}\n'
                  'Source: ${item.source}\n'
                  '${item.description}'
                  '${item.filePath.isNotEmpty ? '\n📎 Photo attached' : ''}',
                ),
                isThreeLine: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
