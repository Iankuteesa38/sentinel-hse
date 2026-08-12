import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/inspection_record.dart';
import '../services/storage_service.dart';

class HazardLifecyclePage extends StatefulWidget {
  final InspectionRecord record;

  const HazardLifecyclePage({super.key, required this.record});

  @override
  State<HazardLifecyclePage> createState() => _HazardLifecyclePageState();
}

class _HazardLifecyclePageState extends State<HazardLifecyclePage> {
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _responsiblePersonController;

  late final TextEditingController _closedByController;

  late final TextEditingController _closureCommentController;

  late String _status;
  DateTime? _targetDate;

  late List<String> _closureEvidencePaths;

  static const List<String> _statuses = [
    'Open',
    'In Progress',
    'Controlled',
    'Closed',
  ];

  @override
  void initState() {
    super.initState();

    _status = _statuses.contains(widget.record.status)
        ? widget.record.status
        : 'Open';

    _targetDate = widget.record.targetDate;

    _responsiblePersonController = TextEditingController(
      text: widget.record.responsiblePerson,
    );

    _closedByController = TextEditingController(text: widget.record.closedBy);

    _closureCommentController = TextEditingController(
      text: widget.record.closureComment,
    );

    _closureEvidencePaths = List<String>.from(
      widget.record.closureEvidencePaths,
    );
  }

  @override
  void dispose() {
    _responsiblePersonController.dispose();
    _closedByController.dispose();
    _closureCommentController.dispose();

    super.dispose();
  }

  bool get _isOverdue {
    if (_status == 'Closed' || _targetDate == null) {
      return false;
    }

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final target = DateTime(
      _targetDate!.year,
      _targetDate!.month,
      _targetDate!.day,
    );

    return target.isBefore(today);
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();

    final day = local.day.toString().padLeft(2, '0');

    final month = local.month.toString().padLeft(2, '0');

    return '$day/$month/${local.year}';
  }

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 10),
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _targetDate = selected;
    });
  }

  Future<void> _addEvidence(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);

    if (picked == null) {
      return;
    }

    final savedPath = await StorageService.saveImagePermanently(
      File(picked.path),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _closureEvidencePaths.add(savedPath);
    });
  }

  Future<void> _showEvidenceOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take Close-Out Photo'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _addEvidence(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _addEvidence(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final responsible = _responsiblePersonController.text.trim();

    if (responsible.isEmpty) {
      _message('Responsible Person is required.');
      return;
    }

    if (_targetDate == null) {
      _message('Target Date is required.');
      return;
    }

    final closing = _status == 'Closed';

    if (closing && _closedByController.text.trim().isEmpty) {
      _message('Closed By is required before closing the hazard.');
      return;
    }

    if (closing && _closureCommentController.text.trim().isEmpty) {
      _message('Closure Comment is required before closing the hazard.');
      return;
    }

    if (closing && _closureEvidencePaths.isEmpty) {
      _message('At least one close-out evidence photo is required.');
      return;
    }

    final updated = widget.record.copyWith(
      status: _status,
      responsiblePerson: responsible,
      targetDate: _targetDate,
      closedBy: closing ? _closedByController.text.trim() : '',
      closureComment: closing ? _closureCommentController.text.trim() : '',
      closedAt: closing ? widget.record.closedAt ?? DateTime.now() : null,
      closureEvidencePaths: closing ? _closureEvidencePaths : <String>[],
      clearClosedAt: !closing,
    );

    await StorageService.updateHazardRecord(updated);

    if (!mounted) {
      return;
    }

    Navigator.pop(context, true);
  }

  void _message(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Hazard Lifecycle'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.record.inspectionId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _detail(
                    'Location',
                    widget.record.location.isEmpty
                        ? 'Not recorded'
                        : widget.record.location,
                  ),
                  _detail('Risk', widget.record.riskLevel),
                  _detail('Created', _formatDate(widget.record.createdAt)),
                  if (_isOverdue)
                    const Chip(
                      avatar: Icon(Icons.alarm, color: Colors.red),
                      label: Text(
                        'OVERDUE',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(
              labelText: 'Hazard Status',
              border: OutlineInputBorder(),
            ),
            items: _statuses
                .map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _status = value;
              });
            },
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _responsiblePersonController,
            decoration: const InputDecoration(
              labelText: 'Responsible Person',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: _pickTargetDate,
            icon: const Icon(Icons.event_outlined),
            label: Text(
              _targetDate == null
                  ? 'Select Target Date'
                  : 'Target Date: '
                        '${_formatDate(_targetDate!)}',
            ),
          ),

          if (_status == 'Closed') ...[
            const SizedBox(height: 20),

            const Text(
              'Hazard Close-Out',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _closedByController,
              decoration: const InputDecoration(
                labelText: 'Closed By',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _closureCommentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Closure Comment',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _showEvidenceOptions,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(
                _closureEvidencePaths.isEmpty
                    ? 'Add Close-Out Evidence'
                    : 'Add More Evidence '
                          '(${_closureEvidencePaths.length})',
              ),
            ),

            if (_closureEvidencePaths.isNotEmpty) ...[
              const SizedBox(height: 12),

              FutureBuilder<List<File?>>(
                future: Future.wait(
                  _closureEvidencePaths.map(StorageService.getInspectionImage),
                ),
                builder: (context, snapshot) {
                  final files = snapshot.data ?? <File?>[];

                  return SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _closureEvidencePaths.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final file = index < files.length ? files[index] : null;

                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 180,
                                height: 140,
                                color: Colors.grey.shade200,
                                child: file == null
                                    ? const Icon(
                                        Icons.image_not_supported_outlined,
                                      )
                                    : Image.file(file, fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton.filled(
                                onPressed: () {
                                  setState(() {
                                    _closureEvidencePaths.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.close, size: 18),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Hazard Lifecycle'),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
