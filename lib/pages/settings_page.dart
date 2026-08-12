import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/branding/models/branding_settings.dart';
import '../features/branding/services/branding_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _jobTitleController = TextEditingController();

  final TextEditingController _companyController = TextEditingController();

  final TextEditingController _projectController = TextEditingController();

  final TextEditingController _clientController = TextEditingController();

  DateTime? _lastLTIDate;

  String _logoPath = '';

  int _selectedPrimaryColor = BrandingSettings.defaultPrimaryColorValue;

  bool _loading = true;

  static const List<int> _brandColors = [
    0xFF2196F3,
    0xFF1565C0,
    0xFF3949AB,
    0xFF00897B,
    0xFF43A047,
    0xFFF57C00,
    0xFFE53935,
    0xFF7E57C2,
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final branding = await BrandingService.load();

    _nameController.text = prefs.getString('userName') ?? '';

    _jobTitleController.text = prefs.getString('jobTitle') ?? '';

    _companyController.text = branding.companyName;

    _projectController.text = branding.projectSiteName;

    _clientController.text = branding.clientName;

    _logoPath = branding.logoPath;

    _selectedPrimaryColor = branding.primaryColorValue;

    final savedDate = prefs.getString('lastLTIDate');

    if (savedDate != null && savedDate.isNotEmpty) {
      _lastLTIDate = DateTime.tryParse(savedDate);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _selectLastLTIDate() async {
    FocusScope.of(context).unfocus();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _lastLTIDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _lastLTIDate = selectedDate;
    });
  }

  Future<void> _pickLogo() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (picked == null) {
      return;
    }

    final savedPath = await BrandingService.saveLogo(File(picked.path));

    if (!mounted) {
      return;
    }

    setState(() {
      _logoPath = savedPath;
    });
  }

  Future<void> _removeLogo() async {
    await BrandingService.removeLogo();

    if (!mounted) {
      return;
    }

    setState(() {
      _logoPath = '';
    });
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _message('Your name is required.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('userName', name);

    await prefs.setString('jobTitle', _jobTitleController.text.trim());

    if (_lastLTIDate != null) {
      await prefs.setString('lastLTIDate', _lastLTIDate!.toIso8601String());
    }

    _message('Profile saved successfully.');
  }

  Future<void> _saveBranding() async {
    final companyName = _companyController.text.trim();

    if (companyName.isEmpty) {
      _message('Company / Organisation name is required.');
      return;
    }

    final settings = BrandingSettings(
      companyName: companyName,
      projectSiteName: _projectController.text.trim(),
      clientName: _clientController.text.trim(),
      logoPath: _logoPath,
      primaryColorValue: _selectedPrimaryColor,
    );

    await BrandingService.save(settings);

    _message('Company branding saved successfully.');
  }

  Future<void> _requestAccountDeletion() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete My Account'),
          content: const Text(
            'This will submit a request to permanently delete your Sentinel HSE account and associated personal data. '
            'Some HSE records may need to be retained by your organization for legal, safety, or compliance purposes.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Request Deletion'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      _message('No signed-in account found.');
      return;
    }

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'request-account-deletion',
        headers: {'Authorization': 'Bearer ${session.accessToken}'},
      );

      final data = response.data;

      if (data is Map && data['success'] == true) {
        _message(
          data['alreadyRequested'] == true
              ? 'Your account deletion request is already pending.'
              : 'Account deletion request submitted successfully.',
        );

        return;
      }

      _message('Unable to submit account deletion request.');
    } catch (error) {
      _message('Unable to submit account deletion request: $error');
    }
  }

  void _message(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime value) {
    return '${value.day}/'
        '${value.month}/'
        '${value.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _projectController.dispose();
    _clientController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Your name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: _jobTitleController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Job title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                  ),

                  const SizedBox(height: 18),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_month),
                    title: const Text('Last LTI Date'),
                    subtitle: Text(
                      _lastLTIDate == null
                          ? 'Not selected'
                          : _formatDate(_lastLTIDate!),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _selectLastLTIDate,
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save Profile'),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Divider(),

                  const SizedBox(height: 18),

                  const Text(
                    'Company Branding',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Configure the organisation identity used by Sentinel HSE.',
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 18),

                  FutureBuilder<File?>(
                    future: BrandingService.getLogoFile(_logoPath),
                    builder: (context, snapshot) {
                      final logo = snapshot.data;

                      return Center(
                        child: Column(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: logo == null
                                  ? const Icon(
                                      Icons.business_outlined,
                                      size: 52,
                                      color: Colors.grey,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(17),
                                      child: Image.file(
                                        logo,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                            ),

                            const SizedBox(height: 10),

                            Wrap(
                              spacing: 8,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _pickLogo,
                                  icon: const Icon(Icons.image_outlined),
                                  label: const Text('Choose Logo'),
                                ),
                                if (_logoPath.isNotEmpty)
                                  OutlinedButton.icon(
                                    onPressed: _removeLogo,
                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text('Remove'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),

                  TextField(
                    controller: _companyController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Company / Organisation',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: _projectController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Project / Site',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: _clientController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Client',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.handshake),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Primary Brand Color',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _brandColors.map((colorValue) {
                      final selected = colorValue == _selectedPrimaryColor;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPrimaryColor = colorValue;
                          });
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Color(colorValue),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: selected
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveBranding,
                      icon: const Icon(Icons.branding_watermark_outlined),
                      label: const Text('Save Company Branding'),
                    ),
                  ),
                  const SizedBox(height: 30),

                  const Divider(),

                  const SizedBox(height: 18),

                  const Text(
                    'Account & Privacy',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Manage your Sentinel HSE account and personal data.',
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _requestAccountDeletion,
                      icon: const Icon(Icons.delete_forever_outlined),
                      label: const Text('Delete My Account'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
