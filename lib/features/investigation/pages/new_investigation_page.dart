import 'package:flutter/material.dart';

import '../models/investigation_case.dart';
import '../services/investigation_draft_service.dart';
import 'investigation_case_summary_page.dart';

class NewInvestigationPage extends StatefulWidget {
  const NewInvestigationPage({super.key});

  @override
  State<NewInvestigationPage> createState() => _NewInvestigationPageState();
}

class _NewInvestigationPageState extends State<NewInvestigationPage> {
  final _formKey = GlobalKey<FormState>();

  final _incidentTitleController = TextEditingController();
  final _locationController = TextEditingController();
  final _projectController = TextEditingController();
  final _companyController = TextEditingController();
  final _contractorController = TextEditingController();
  final _preparedByController = TextEditingController();

  InvestigationReportStatus _reportStatus =
      InvestigationReportStatus.preliminary;

  InvestigationLevel _investigationLevel = InvestigationLevel.level2Formal;

  IncidentCategory _incidentCategory = IncidentCategory.motorVehicle;

  IncidentSeverity _actualSeverity = IncidentSeverity.minor;

  IncidentSeverity _potentialSeverity = IncidentSeverity.serious;

  bool _highPotential = false;

  DateTime _incidentDateTime = DateTime.now();
  DateTime _reportedDateTime = DateTime.now();

  @override
  void dispose() {
    _incidentTitleController.dispose();
    _locationController.dispose();
    _projectController.dispose();
    _companyController.dispose();
    _contractorController.dispose();
    _preparedByController.dispose();
    super.dispose();
  }

  String _generateReference() {
    final now = DateTime.now();

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return 'SEN-INV-'
        '${now.year}'
        '${twoDigits(now.month)}'
        '${twoDigits(now.day)}-'
        '${twoDigits(now.hour)}'
        '${twoDigits(now.minute)}'
        '${twoDigits(now.second)}';
  }

  String _labelFromEnum(Object value) {
    final raw = value.toString().split('.').last;

    return raw
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .replaceAll('level1', 'Level 1 - ')
        .replaceAll('level2', 'Level 2 - ')
        .replaceAll('level3', 'Level 3 - ')
        .replaceAll('finalReport', 'Final')
        .replaceAllMapped(
          RegExp(r'^.'),
          (match) => match.group(0)!.toUpperCase(),
        );
  }

  Future<void> _pickIncidentDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _incidentDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date == null || !mounted) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_incidentDateTime),
    );

    if (time == null) {
      return;
    }

    setState(() {
      _incidentDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _pickReportedDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _reportedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date == null || !mounted) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reportedDateTime),
    );

    if (time == null) {
      return;
    }

    setState(() {
      _reportedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _formatDateTime(DateTime value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');

    return '${twoDigits(value.day)}/'
        '${twoDigits(value.month)}/'
        '${value.year} '
        '${twoDigits(value.hour)}:'
        '${twoDigits(value.minute)}';
  }

  void _continueInvestigation() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final investigation = InvestigationCase(
      investigationReference: _generateReference(),
      incidentTitle: _incidentTitleController.text.trim(),
      reportStatus: _reportStatus,
      investigationLevel: _investigationLevel,
      incidentCategory: _incidentCategory,
      actualSeverity: _actualSeverity,
      potentialSeverity: _potentialSeverity,
      highPotential: _highPotential,
      incidentDateTime: _incidentDateTime,
      reportedDateTime: _reportedDateTime,
      location: _locationController.text.trim(),
      project: _projectController.text.trim(),
      company: _companyController.text.trim(),
      contractor: _contractorController.text.trim(),
      preparedBy: _preparedByController.text.trim(),
    );
    InvestigationDraftService.start(investigation);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InvestigationCaseSummaryPage(investigation: investigation),
      ),
    );
  }

  Widget _requiredField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _optionalField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Investigation'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Incident Identification',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _requiredField(
              controller: _incidentTitleController,
              label: 'Incident Title',
            ),
            _requiredField(
              controller: _locationController,
              label: 'Incident Location',
            ),
            _requiredField(
              controller: _projectController,
              label: 'Project / Business Unit',
            ),
            _requiredField(controller: _companyController, label: 'Company'),
            _optionalField(
              controller: _contractorController,
              label: 'Contractor',
            ),
            _requiredField(
              controller: _preparedByController,
              label: 'Lead Investigator / Prepared By',
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<IncidentCategory>(
              initialValue: _incidentCategory,
              decoration: const InputDecoration(
                labelText: 'Incident Category',
                border: OutlineInputBorder(),
              ),
              items: IncidentCategory.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(_labelFromEnum(value)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _incidentCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<InvestigationLevel>(
              initialValue: _investigationLevel,
              decoration: const InputDecoration(
                labelText: 'Investigation Level',
                border: OutlineInputBorder(),
              ),
              items: InvestigationLevel.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(_labelFromEnum(value)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _investigationLevel = value;
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<InvestigationReportStatus>(
              initialValue: _reportStatus,
              decoration: const InputDecoration(
                labelText: 'Report Status',
                border: OutlineInputBorder(),
              ),
              items: InvestigationReportStatus.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(_labelFromEnum(value)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _reportStatus = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            const Text(
              'Severity Classification',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<IncidentSeverity>(
              initialValue: _actualSeverity,
              decoration: const InputDecoration(
                labelText: 'Actual Severity',
                border: OutlineInputBorder(),
              ),
              items: IncidentSeverity.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(_labelFromEnum(value)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _actualSeverity = value;
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<IncidentSeverity>(
              initialValue: _potentialSeverity,
              decoration: const InputDecoration(
                labelText: 'Potential Severity',
                border: OutlineInputBorder(),
              ),
              items: IncidentSeverity.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(_labelFromEnum(value)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _potentialSeverity = value;
                  });
                }
              },
            ),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('High Potential Incident'),
              subtitle: const Text(
                'Could the event reasonably have resulted in a much more serious outcome?',
              ),
              value: _highPotential,
              onChanged: (value) {
                setState(() {
                  _highPotential = value;
                });
              },
            ),

            const SizedBox(height: 18),

            const Text(
              'Date & Time',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Incident Date & Time'),
              subtitle: Text(_formatDateTime(_incidentDateTime)),
              trailing: const Icon(Icons.calendar_month_outlined),
              onTap: _pickIncidentDateTime,
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reported Date & Time'),
              subtitle: Text(_formatDateTime(_reportedDateTime)),
              trailing: const Icon(Icons.calendar_month_outlined),
              onTap: _pickReportedDateTime,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _continueInvestigation,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue Investigation'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
