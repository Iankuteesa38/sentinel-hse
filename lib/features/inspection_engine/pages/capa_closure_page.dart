import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/inspection_finding.dart';

class CapaClosureResult {
  final String closedBy;
  final String closureComment;
  final DateTime closedAt;
  final List<Uint8List> closureEvidence;

  const CapaClosureResult({
    required this.closedBy,
    required this.closureComment,
    required this.closedAt,
    required this.closureEvidence,
  });
}

class CapaClosurePage extends StatefulWidget {
  final InspectionFinding finding;

  const CapaClosurePage({super.key, required this.finding});

  @override
  State<CapaClosurePage> createState() => _CapaClosurePageState();
}

class _CapaClosurePageState extends State<CapaClosurePage> {
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _closedByController;
  late final TextEditingController _closureCommentController;
  late List<Uint8List> _evidence;

  @override
  void initState() {
    super.initState();

    _closedByController = TextEditingController(text: widget.finding.closedBy);
    _closureCommentController = TextEditingController(
      text: widget.finding.closureComment,
    );
    _evidence = List<Uint8List>.from(widget.finding.closureEvidence);
  }

  @override
  void dispose() {
    _closedByController.dispose();
    _closureCommentController.dispose();
    super.dispose();
  }

  Future<void> _addEvidence(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile == null) {
      return;
    }

    final bytes = await pickedFile.readAsBytes();

    if (!mounted) {
      return;
    }

    setState(() {
      _evidence.add(bytes);
    });
  }

  void _removeEvidence(int index) {
    setState(() {
      _evidence.removeAt(index);
    });
  }

  void _submitClosure() {
    final closedBy = _closedByController.text.trim();
    final closureComment = _closureCommentController.text.trim();

    if (closedBy.isEmpty || closureComment.isEmpty || _evidence.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Closed By, Closure Comment and at least one evidence photo are required.',
          ),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      CapaClosureResult(
        closedBy: closedBy,
        closureComment: closureComment,
        closedAt: DateTime.now(),
        closureEvidence: List<Uint8List>.from(_evidence),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final finding = widget.finding;

    return Scaffold(
      appBar: AppBar(title: const Text('Close CAPA'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item ${finding.itemNumber}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      finding.requirement,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Text('Finding: ${finding.finding}'),
                    const SizedBox(height: 6),
                    Text('Risk: ${finding.riskLevel}'),
                    const SizedBox(height: 6),
                    Text('CAPA: ${finding.correctiveAction}'),
                    const SizedBox(height: 6),
                    Text('Responsible: ${finding.responsiblePerson}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _closedByController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Closed By',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _closureCommentController,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Closure Comment',
                hintText:
                    'Describe the corrective action completed and how it was verified.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Close-out Evidence',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _addEvidence(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Camera'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _addEvidence(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            if (_evidence.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_evidence.length, (index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _evidence[index],
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton.filled(
                          visualDensity: VisualDensity.compact,
                          iconSize: 16,
                          onPressed: () => _removeEvidence(index),
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _submitClosure,
              icon: const Icon(Icons.task_alt),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Confirm CAPA Closure'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
