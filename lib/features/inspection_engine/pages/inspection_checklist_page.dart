import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../models/inspection_finding.dart';
import '../models/inspection_template.dart';
import 'capa_dashboard_page.dart';
import '../models/inspection_report_data.dart';
import '../services/inspection_history_service.dart';
import 'inspection_report_preview_page.dart';

class InspectionChecklistPage extends StatefulWidget {
  final InspectionTemplate template;

  const InspectionChecklistPage({super.key, required this.template});
  @override
  State<InspectionChecklistPage> createState() =>
      _InspectionChecklistPageState();
}

class _InspectionChecklistPageState extends State<InspectionChecklistPage> {
  final Map<int, String> answers = {};
  final Map<int, TextEditingController> commentControllers = {};
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _inspectorNameController =
      TextEditingController();
  final TextEditingController _inspectorIdController = TextEditingController();

  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _driverIdController = TextEditingController();

  final TextEditingController _vehiclePlateController = TextEditingController();
  final TextEditingController _vehicleFleetNumberController =
      TextEditingController();
  final TextEditingController _vehicleMakeModelController =
      TextEditingController();
  final TextEditingController _odometerController = TextEditingController();
  final TextEditingController _campNameController = TextEditingController();
  final TextEditingController _contractorNameController =
      TextEditingController();
  final TextEditingController _contractAdministratorController =
      TextEditingController();
  final TextEditingController _groupCompanyController = TextEditingController();
  final TextEditingController _assetFunctionController =
      TextEditingController();
  final TextEditingController _campRepresentativeController =
      TextEditingController();

  final TextEditingController _liftingGroupCompanyController =
      TextEditingController();

  final TextEditingController _liftingContractorLocationController =
      TextEditingController();
  final List<InspectionFinding> findings = [];
  final Map<int, List<File>> findingPhotos = {};
  final ImagePicker _picker = ImagePicker();
  bool get _isGeneralComplianceTemplate =>
      widget.template.id != 'adnoc_vaai_vehicle' &&
      widget.template.id != 'camp_welfare' &&
      widget.template.id != 'lifting_hoisting';
  void _updateFinding({
    required int itemNumber,
    required String requirement,
    required String answer,
  }) {
    findings.removeWhere((finding) => finding.itemNumber == itemNumber);

    final isNonCompliant = widget.template.id == 'camp_welfare'
        ? answer == 'Needs Improvement' || answer == 'Unacceptable'
        : answer == 'No';

    if (isNonCompliant) {
      findings.add(
        InspectionFinding(
          itemNumber: itemNumber,
          requirement: requirement,
          finding: 'Non-compliance identified',
          riskLevel: widget.template.id == 'camp_welfare'
              ? _getWelfareRiskRanking(answer)
              : _getRiskLevel(requirement),
          correctiveAction: _getCorrectiveAction(requirement),
          responsiblePerson: _getResponsiblePerson(requirement),
          targetDate: widget.template.id == 'camp_welfare'
              ? _getWelfareTargetDate(answer)
              : _getTargetDate(requirement),
        ),
      );
    }
  }

  DateTime _getWelfareTargetDate(String rating) {
    switch (rating) {
      case 'Unacceptable':
        return DateTime.now().add(const Duration(days: 1));
      case 'Needs Improvement':
        return DateTime.now().add(const Duration(days: 3));
      case 'Fair':
        return DateTime.now().add(const Duration(days: 7));
      default:
        return DateTime.now().add(const Duration(days: 14));
    }
  }

  double _getWelfareMarks(String rating) {
    switch (rating) {
      case 'Very Good':
        return 100;
      case 'Good':
        return 80;
      case 'Fair':
        return 60;
      case 'Needs Improvement':
        return 20;
      case 'Unacceptable':
        return 10;
      default:
        return 0;
    }
  }

  String _getWelfareRiskRanking(String rating) {
    switch (rating) {
      case 'Very Good':
        return 'Fully Compliant';
      case 'Good':
        return 'Low';
      case 'Fair':
        return 'Medium';
      case 'Needs Improvement':
        return 'High/Medium';
      case 'Unacceptable':
        return 'High';
      default:
        return '';
    }
  }

  String _getRiskLevel(String requirement) {
    final text = requirement.toLowerCase();
    if (widget.template.id == 'lifting_hoisting') {
      if (text.contains('permit to work') ||
          text.contains('pre-requisite') ||
          text.contains('prerequisite') ||
          text.contains('job safety analysis') ||
          text.contains('lifting plan') ||
          text.contains('risk assessment') ||
          text.contains('safe working load') ||
          text.contains('swl') ||
          text.contains('load chart') ||
          text.contains('rated capacity') ||
          text.contains('working radius') ||
          text.contains('wind speed') ||
          text.contains('anemometer') ||
          text.contains('thunderstorm') ||
          text.contains('severe rainfall') ||
          text.contains('personnel lifting') ||
          text.contains('lifting of personnel') ||
          text.contains('personnel carrier') ||
          text.contains('emergency') ||
          text.contains('rescue plan') ||
          text.contains('crane operator') ||
          text.contains('rigger') ||
          text.contains('slinger') ||
          text.contains('banksman') ||
          text.contains('signaller')) {
        return 'High';
      }

      if (text.contains('certificate') ||
          text.contains('certification') ||
          text.contains('inspection') ||
          text.contains('colour code') ||
          text.contains('color code') ||
          text.contains('communication') ||
          text.contains('hand signals') ||
          text.contains('method statement') ||
          text.contains('maintenance') ||
          text.contains('proof load') ||
          text.contains('thorough examination') ||
          text.contains('lifting accessory') ||
          text.contains('wire rope') ||
          text.contains('sling') ||
          text.contains('rigging')) {
        return 'Medium';
      }

      return 'Low';
    }
    if (widget.template.id == 'camp_welfare') {
      if (text.contains('fire') ||
          text.contains('emergency') ||
          text.contains('ambulance') ||
          text.contains('medevac') ||
          text.contains('electrical') ||
          text.contains('generator') ||
          text.contains('fuel') ||
          text.contains('chemical') ||
          text.contains('flammable') ||
          text.contains('sewage') ||
          text.contains('potable water') ||
          text.contains('food safety') ||
          text.contains('contaminated')) {
        return 'High';
      }

      if (text.contains('toilet') ||
          text.contains('shower') ||
          text.contains('ablution') ||
          text.contains('laundry') ||
          text.contains('pest') ||
          text.contains('housekeeping') ||
          text.contains('ventilation') ||
          text.contains('illumination') ||
          text.contains('waste') ||
          text.contains('first aid')) {
        return 'Medium';
      }

      return 'Low';
    }
    if (_isGeneralComplianceTemplate) {
      if (text.contains('permit to work') ||
          text.contains('job safety analysis') ||
          text.contains('jsa') ||
          text.contains('risk assessment') ||
          text.contains('isolation') ||
          text.contains('lockout') ||
          text.contains('tagout') ||
          text.contains('confined space') ||
          text.contains('atmospheric testing') ||
          text.contains('gas test') ||
          text.contains('fall arrest') ||
          text.contains('full body harness') ||
          text.contains('rescue') ||
          text.contains('emergency') ||
          text.contains('fire') ||
          text.contains('explosion') ||
          text.contains('flammable') ||
          text.contains('toxic') ||
          text.contains('shoring') ||
          text.contains('collapse')) {
        return 'High';
      }

      if (text.contains('certificate') ||
          text.contains('certification') ||
          text.contains('inspection') ||
          text.contains('training') ||
          text.contains('competent') ||
          text.contains('competency') ||
          text.contains('ppe') ||
          text.contains('barricade') ||
          text.contains('signage') ||
          text.contains('ventilation') ||
          text.contains('maintenance') ||
          text.contains('monitoring') ||
          text.contains('communication')) {
        return 'Medium';
      }

      return 'Low';
    }
    // VAAI vehicle inspection logic
    if (text.contains('brake') ||
        text.contains('tyre') ||
        text.contains('tire') ||
        text.contains('seat belt') ||
        text.contains('fire extinguisher') ||
        text.contains('steering')) {
      return 'High';
    }

    if (text.contains('light') ||
        text.contains('mirror') ||
        text.contains('horn') ||
        text.contains('wiper')) {
      return 'Medium';
    }

    return 'Low';
  }

  String _getCorrectiveAction(String requirement) {
    final text = requirement.toLowerCase();
    if (widget.template.id == 'lifting_hoisting') {
      if (text.contains('permit to work') ||
          text.contains('pre-requisite') ||
          text.contains('prerequisite') ||
          text.contains('job safety analysis') ||
          text.contains('method statement') ||
          text.contains('lifting plan') ||
          text.contains('risk assessment')) {
        return 'Stop the lifting activity until the required lifting documentation, risk assessment and approvals are completed and verified.';
      }

      if (text.contains('certificate') ||
          text.contains('certification') ||
          text.contains('inspection') ||
          text.contains('colour code') ||
          text.contains('color code') ||
          text.contains('proof load') ||
          text.contains('thorough examination')) {
        return 'Remove the lifting equipment or accessory from service until valid inspection and certification requirements are verified.';
      }

      if (text.contains('safe working load') ||
          text.contains('swl') ||
          text.contains('load chart') ||
          text.contains('rated capacity') ||
          text.contains('working radius')) {
        return 'Verify the lifting equipment capacity, SWL, load chart and lifting radius before the lifting operation continues.';
      }

      if (text.contains('wind speed') ||
          text.contains('anemometer') ||
          text.contains('thunderstorm') ||
          text.contains('severe rainfall')) {
        return 'Suspend the lifting operation until weather conditions are within approved limits and monitoring equipment is verified.';
      }

      if (text.contains('banksman') ||
          text.contains('signaller') ||
          text.contains('rigger') ||
          text.contains('slinger') ||
          text.contains('crane operator') ||
          text.contains('appointed person')) {
        return 'Ensure only trained, competent and authorized lifting personnel are assigned before the lifting operation proceeds.';
      }

      return 'Stop the lifting operation and correct the identified lifting and hoisting non-compliance before work resumes.';
    }
    if (widget.template.id == 'camp_welfare') {
      if (text.contains('break time') ||
          text.contains('rest, food and prayer') ||
          text.contains('prayer') ||
          text.contains('midday break') ||
          text.contains('work rotation') ||
          text.contains('time off') ||
          text.contains('leave')) {
        return 'Ensure workers are provided adequate rest, meal and prayer breaks, leave and time-off arrangements in accordance with applicable requirements and approved work schedules.';
      }

      if (text.contains('food safety') ||
          text.contains('kitchen') ||
          text.contains('catering') ||
          text.contains('haccp') ||
          text.contains('food handling') ||
          text.contains('contaminated') ||
          text.contains('expired food')) {
        return 'Correct the identified food safety deficiency and verify compliance with applicable food hygiene requirements.';
      }

      if (text.contains('toilet') ||
          text.contains('shower') ||
          text.contains('ablution') ||
          text.contains('sanitary')) {
        return 'Rectify the identified sanitary facility deficiency and restore the facility to an acceptable hygienic and functional condition.';
      }

      if (text.contains('food') || text.contains('kitchen')) {
        return 'Correct the identified food safety deficiency and verify compliance with applicable food hygiene requirements.';
      }

      if (text.contains('water')) {
        return 'Correct the identified water safety or supply deficiency and verify that required standards are met.';
      }

      if (text.contains('electrical') || text.contains('generator')) {
        return 'Rectify the identified electrical or generator safety deficiency and verify safe operation.';
      }

      if (text.contains('waste') || text.contains('sewage')) {
        return 'Correct the identified waste or sewage management deficiency and implement appropriate controls.';
      }

      if (text.contains('first aid') ||
          text.contains('medical') ||
          text.contains('health')) {
        return 'Correct the identified medical, first aid or health welfare deficiency and verify implementation.';
      }

      return 'Correct the identified welfare non-compliance and provide evidence of satisfactory close-out.';
    }
    if (_isGeneralComplianceTemplate) {
      if (text.contains('permit to work') ||
          text.contains('job safety analysis') ||
          text.contains('jsa') ||
          text.contains('risk assessment') ||
          text.contains('isolation') ||
          text.contains('lockout') ||
          text.contains('tagout') ||
          text.contains('confined space') ||
          text.contains('gas test') ||
          text.contains('fall arrest') ||
          text.contains('rescue') ||
          text.contains('emergency')) {
        return 'Stop or hold the affected activity until the required safety control, authorization and supporting documentation are implemented and verified.';
      }

      if (text.contains('certificate') ||
          text.contains('certification') ||
          text.contains('inspection') ||
          text.contains('maintenance')) {
        return 'Rectify the identified deficiency and verify the required inspection, certification or maintenance requirements before continued use.';
      }

      if (text.contains('training') ||
          text.contains('competent') ||
          text.contains('competency')) {
        return 'Ensure appropriately trained, competent and authorized personnel are assigned before the activity proceeds.';
      }

      return 'Correct the identified ${widget.template.category} non-compliance, implement the required control and verify effective close-out.';
    }
    // VAAI vehicle inspection logic
    if (text.contains('brake')) {
      return 'Inspect and repair the braking system before vehicle use.';
    }

    if (text.contains('tyre') || text.contains('tire')) {
      return 'Replace the defective tyre before vehicle operation.';
    }

    if (text.contains('seat belt')) {
      return 'Repair or replace the damaged seat belt immediately.';
    }

    if (text.contains('fire extinguisher')) {
      return 'Provide a valid and serviceable fire extinguisher.';
    }

    if (text.contains('light')) {
      return 'Repair or replace the defective vehicle light.';
    }

    if (text.contains('mirror')) {
      return 'Repair or replace the damaged mirror.';
    }

    if (text.contains('horn')) {
      return 'Repair the horn and confirm proper operation.';
    }

    if (text.contains('wiper')) {
      return 'Repair or replace the defective windscreen wiper.';
    }

    return 'Correct the identified non-compliance before vehicle use.';
  }

  String _getResponsiblePerson(String requirement) {
    final text = requirement.toLowerCase();

    if (widget.template.id == 'lifting_hoisting') {
      if (text.contains('permit to work') ||
          text.contains('job safety analysis') ||
          text.contains('method statement') ||
          text.contains('lifting plan') ||
          text.contains('risk assessed') ||
          text.contains('risk assessment')) {
        return 'Appointed Person / Lifting Supervisor';
      }

      if (text.contains('certificate') ||
          text.contains('certification') ||
          text.contains('colour code') ||
          text.contains('color code') ||
          text.contains('thorough examination') ||
          text.contains('proof load') ||
          text.contains('third party')) {
        return 'Lifting Equipment Inspector / TPIA';
      }

      if (text.contains('safe working load') ||
          text.contains('swl') ||
          text.contains('load chart') ||
          text.contains('rated capacity') ||
          text.contains('working radius')) {
        return 'Appointed Person / Crane Operator';
      }

      if (text.contains('anemometer') ||
          text.contains('wind speed') ||
          text.contains('severe rainfall') ||
          text.contains('thunderstorm')) {
        return 'Appointed Person / Lifting Supervisor';
      }

      if (text.contains('banksman') ||
          text.contains('signaller') ||
          text.contains('rigger') ||
          text.contains('slinger') ||
          text.contains('crane operator') ||
          text.contains('appointed person') ||
          text.contains('competent person') ||
          text.contains('competency')) {
        return 'Appointed Person / Lifting Supervisor';
      }

      if (text.contains('radio communication') ||
          text.contains('communication') ||
          text.contains('hand signals') ||
          text.contains('blind lift')) {
        return 'Lifting Supervisor / Banksman';
      }

      if (text.contains('lifting accessory') ||
          text.contains('sling') ||
          text.contains('wire rope') ||
          text.contains('hook') ||
          text.contains('rigging')) {
        return 'Rigger / Lifting Supervisor';
      }

      if (text.contains('personnel lifting') ||
          text.contains('person being lifted') ||
          text.contains('personnel carrier') ||
          text.contains('lifting of personnel')) {
        return 'Appointed Person / HSE Officer';
      }

      if (text.contains('emergency') ||
          text.contains('rescue plan') ||
          text.contains('tool box talk') ||
          text.contains('toolbox talk')) {
        return 'Appointed Person / HSE Officer';
      }

      if (text.contains('maintenance') ||
          text.contains('repair') ||
          text.contains('equipment integrity')) {
        return 'Lifting Equipment Maintenance Supervisor';
      }

      return 'Appointed Person / Lifting Supervisor';
    }

    if (widget.template.id == 'camp_welfare') {
      if (text.contains('break time') ||
          text.contains('rest, food and prayer') ||
          text.contains('prayer') ||
          text.contains('midday break') ||
          text.contains('work rotation') ||
          text.contains('time off') ||
          text.contains('leave')) {
        return 'Contractor Management / Operations Supervisor';
      }

      if (text.contains('food safety') ||
          text.contains('kitchen') ||
          text.contains('catering') ||
          text.contains('haccp') ||
          text.contains('food handling') ||
          text.contains('contaminated') ||
          text.contains('expired food')) {
        return 'Catering / Camp Supervisor';
      }

      if (text.contains('electrical') ||
          text.contains('generator') ||
          text.contains('maintenance') ||
          text.contains('fitting')) {
        return 'Camp Maintenance Supervisor';
      }

      if (text.contains('fire') ||
          text.contains('emergency') ||
          text.contains('first aid') ||
          text.contains('medical') ||
          text.contains('health')) {
        return 'HSE Officer';
      }

      if (text.contains('waste') ||
          text.contains('sewage') ||
          text.contains('pest') ||
          text.contains('sanitary') ||
          text.contains('toilet') ||
          text.contains('shower') ||
          text.contains('ablution')) {
        return 'Camp Supervisor';
      }

      return 'Contractor / Camp Management';
    }
    if (_isGeneralComplianceTemplate) {
      switch (widget.template.id) {
        case 'jsa':
          return 'Performing Authority / HSE Officer';

        case 'confined_space_entry':
          return 'Performing Authority / HSE Officer';

        case 'scaffolding':
          return 'Scaffolding Supervisor / HSE Officer';

        case 'electrical_safety':
          return 'Electrical Supervisor / HSE Officer';

        case 'compressed_gas_cylinders':
          return 'Area Supervisor / HSE Officer';

        case 'excavation':
          return 'Civil Supervisor / HSE Officer';

        case 'abrasive_blasting_spray_painting':
          return 'Blasting / Painting Supervisor / HSE Officer';

        case 'working_at_height':
          return 'Work Supervisor / HSE Officer';

        case 'land_transportation_safety':
          return 'Transport Supervisor / Road Safety Coordinator';

        default:
          return 'Area Supervisor / HSE Officer';
      }
    }
    // VAAI vehicle inspection logic
    if (text.contains('brake') ||
        text.contains('tyre') ||
        text.contains('tire') ||
        text.contains('steering') ||
        text.contains('light') ||
        text.contains('horn') ||
        text.contains('wiper') ||
        text.contains('mirror') ||
        text.contains('seat belt')) {
      return 'Workshop Supervisor';
    }

    if (text.contains('fire extinguisher') ||
        text.contains('first aid') ||
        text.contains('emergency')) {
      return 'HSE Officer';
    }

    return 'Fleet Supervisor';
  }

  DateTime _getTargetDate(String requirement) {
    final riskLevel = _getRiskLevel(requirement);

    if (riskLevel == 'High') {
      return DateTime.now().add(const Duration(days: 1));
    }

    if (riskLevel == 'Medium') {
      return DateTime.now().add(const Duration(days: 3));
    }

    return DateTime.now().add(const Duration(days: 7));
  }

  Widget _buildDetailsField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildInspectionDetailsCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(Icons.assignment_ind_outlined),
        title: const Text(
          'Inspection Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.template.id == 'camp_welfare'
              ? 'Location, auditor and camp details'
              : widget.template.id == 'lifting_hoisting'
              ? 'Location, completed by and lifting inspection details'
              : widget.template.id == 'adnoc_vaai_vehicle'
              ? 'Location, inspector, driver and vehicle'
              : 'Location, inspector and compliance details',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inspection Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildDetailsField(
                  controller: _locationController,
                  label: 'Inspection Location',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Inspector Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildDetailsField(
                  controller: _inspectorNameController,
                  label: 'Inspector Name',
                ),
                _buildDetailsField(
                  controller: _inspectorIdController,
                  label: 'Inspector Employee ID',
                ),
                const SizedBox(height: 8),
                if (widget.template.id == 'camp_welfare') ...[
                  const Text(
                    'Camp / Welfare Audit Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _buildDetailsField(
                    controller: _campNameController,
                    label: 'Camp Name',
                  ),
                  _buildDetailsField(
                    controller: _contractorNameController,
                    label: 'Contractor Name',
                  ),
                  _buildDetailsField(
                    controller: _contractAdministratorController,
                    label: 'Contract Administrator',
                  ),
                  _buildDetailsField(
                    controller: _groupCompanyController,
                    label: 'Group Company',
                  ),
                  _buildDetailsField(
                    controller: _assetFunctionController,
                    label: 'Asset / Function',
                  ),
                  _buildDetailsField(
                    controller: _campRepresentativeController,
                    label: 'Camp Representative',
                  ),
                ] else if (widget.template.id == 'lifting_hoisting') ...[
                  const Text(
                    'Lifting & Hoisting Inspection Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _buildDetailsField(
                    controller: _liftingGroupCompanyController,
                    label: 'Group Company',
                  ),
                  _buildDetailsField(
                    controller: _liftingContractorLocationController,
                    label: 'Contractor Location (if applicable)',
                  ),
                ] else if (widget.template.id == 'adnoc_vaai_vehicle') ...[
                  const Text(
                    'Driver Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _buildDetailsField(
                    controller: _driverNameController,
                    label: 'Driver Name',
                  ),
                  _buildDetailsField(
                    controller: _driverIdController,
                    label: 'Driver Employee ID',
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Vehicle Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _buildDetailsField(
                    controller: _vehiclePlateController,
                    label: 'Vehicle Plate Number',
                  ),
                  _buildDetailsField(
                    controller: _vehicleFleetNumberController,
                    label: 'Vehicle Fleet Number',
                  ),
                  _buildDetailsField(
                    controller: _vehicleMakeModelController,
                    label: 'Vehicle Make / Model',
                  ),
                  _buildDetailsField(
                    controller: _odometerController,
                    label: 'Odometer Reading',
                  ),
                ] else ...[
                  const Text(
                    'Compliance Check Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _buildDetailsField(
                    controller: _liftingGroupCompanyController,
                    label: 'Group Company',
                  ),
                  _buildDetailsField(
                    controller: _liftingContractorLocationController,
                    label: 'Contractor Location (if applicable)',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFindingPhoto(int itemNumber, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    setState(() {
      findingPhotos.putIfAbsent(itemNumber, () => []);
      findingPhotos[itemNumber]!.add(File(pickedFile.path));
    });
  }

  void _showPhotoSourcePicker(int itemNumber) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickFindingPhoto(itemNumber, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickFindingPhoto(itemNumber, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFindingPhotos(int itemNumber) {
    final photos = findingPhotos[itemNumber] ?? [];

    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(photos.length, (index) {
        final photo = photos[index];

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                photo,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    findingPhotos[itemNumber]!.removeAt(index);

                    if (findingPhotos[itemNumber]!.isEmpty) {
                      findingPhotos.remove(itemNumber);
                    }
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _submitInspection() {
    final missingDetails = <String>[];

    void requireDetail(TextEditingController controller, String label) {
      if (controller.text.trim().isEmpty) {
        missingDetails.add(label);
      }
    }

    requireDetail(_locationController, 'Inspection location');
    requireDetail(_inspectorNameController, 'Inspector name');
    requireDetail(_inspectorIdController, 'Inspector ID');

    if (widget.template.id == 'camp_welfare') {
      requireDetail(_campNameController, 'Camp name');
      requireDetail(_contractorNameController, 'Contractor name');
      requireDetail(_contractAdministratorController, 'Contract administrator');
      requireDetail(_groupCompanyController, 'Group company');
      requireDetail(_assetFunctionController, 'Asset / Function');
      requireDetail(_campRepresentativeController, 'Camp representative');
    } else if (widget.template.id == 'lifting_hoisting') {
      requireDetail(_liftingGroupCompanyController, 'Group company');
      requireDetail(
        _liftingContractorLocationController,
        'Contractor location',
      );
    } else if (widget.template.id == 'adnoc_vaai_vehicle') {
      requireDetail(_driverNameController, 'Driver name');
      requireDetail(_driverIdController, 'Driver ID');
      requireDetail(_vehiclePlateController, 'Vehicle plate number');
      requireDetail(_vehicleFleetNumberController, 'Vehicle fleet number');
      requireDetail(_vehicleMakeModelController, 'Vehicle make/model');
      requireDetail(_odometerController, 'Odometer reading');
    } else {
      requireDetail(_liftingGroupCompanyController, 'Group company');
    }

    if (missingDetails.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Complete required details: ${missingDetails.join(', ')}',
          ),
        ),
      );
      return;
    }
    final unansweredItems = widget.template.items.where((item) {
      return !answers.containsKey(item.itemNumber);
    }).toList();

    if (unansweredItems.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please answer all checklist items. '
            '${unansweredItems.length} remaining.',
          ),
        ),
      );
      return;
    }

    final findingsWithoutComments = widget.template.items.where((item) {
      final answer = answers[item.itemNumber];
      final comment = commentControllers[item.itemNumber]?.text.trim() ?? '';

      return answer == 'No' && comment.isEmpty;
    }).toList();

    if (findingsWithoutComments.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Add comments for all No responses. '
            '${findingsWithoutComments.length} remaining.',
          ),
        ),
      );
      return;
    }

    final yesCount = answers.values.where((answer) => answer == 'Yes').length;
    final noCount = answers.values.where((answer) => answer == 'No').length;
    final naCount = answers.values.where((answer) => answer == 'N/A').length;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Submit Inspection'),
          content: Text(
            'Yes: $yesCount\n'
            'No: $noCount\n'
            'N/A: $naCount\n'
            'CAPA findings: ${findings.length}\n\n'
            'Confirm submission?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final reportItems = widget.template.items.map((item) {
                  final answer = answers[item.itemNumber] ?? '';
                  final isCampWelfare = widget.template.id == 'camp_welfare';

                  final marks = isCampWelfare ? _getWelfareMarks(answer) : 0.0;

                  final riskRanking = isCampWelfare
                      ? _getWelfareRiskRanking(answer)
                      : '';

                  final weightedScore = isCampWelfare && answer != 'N/A'
                      ? item.weight * marks
                      : 0.0;

                  return InspectionReportItem(
                    itemNumber: item.itemNumber,
                    section: item.section,
                    requirement: item.requirement,
                    answer: answer,
                    comment:
                        commentControllers[item.itemNumber]?.text.trim() ?? '',
                    performanceRating: isCampWelfare ? answer : '',
                    revisedRiskRanking: riskRanking,
                    marks: marks,
                    weight: item.weight,
                    weightedScore: weightedScore,
                  );
                }).toList();
                final reportFindingPhotos = <int, List<Uint8List>>{};

                for (final entry in findingPhotos.entries) {
                  reportFindingPhotos[entry.key] = await Future.wait(
                    entry.value.map((photo) => photo.readAsBytes()),
                  );
                }

                if (!mounted || !dialogContext.mounted) return;
                final reportData = InspectionReportData(
                  reportReference: InspectionHistoryService.generateReference(
                    templateId: widget.template.id,
                  ),
                  inspectionTitle: widget.template.title,
                  inspectionLocation: _locationController.text.trim(),
                  inspectorName: _inspectorNameController.text.trim(),
                  inspectorEmployeeId: _inspectorIdController.text.trim(),
                  driverName: _driverNameController.text.trim(),
                  driverEmployeeId: _driverIdController.text.trim(),
                  vehiclePlateNumber: _vehiclePlateController.text.trim(),
                  vehicleFleetNumber: _vehicleFleetNumberController.text.trim(),
                  vehicleMakeModel: _vehicleMakeModelController.text.trim(),
                  odometerReading: _odometerController.text.trim(),
                  campName: _campNameController.text.trim(),
                  contractorName: _contractorNameController.text.trim(),
                  contractAdministrator: _contractAdministratorController.text
                      .trim(),
                  groupCompany: _groupCompanyController.text.trim(),
                  assetFunction: _assetFunctionController.text.trim(),
                  campRepresentative: _campRepresentativeController.text.trim(),
                  liftingGroupCompany: _liftingGroupCompanyController.text
                      .trim(),
                  liftingContractorLocation:
                      _liftingContractorLocationController.text.trim(),
                  submittedAt: DateTime.now(),
                  items: reportItems,
                  findings: List<InspectionFinding>.from(findings),
                  findingPhotos: reportFindingPhotos,
                );
                await InspectionHistoryService.saveReport(reportData);

                if (!mounted || !dialogContext.mounted) {
                  return;
                }
                Navigator.pop(dialogContext);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        InspectionReportPreviewPage(reportData: reportData),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    for (final controller in commentControllers.values) {
      controller.dispose();
    }

    _locationController.dispose();
    _inspectorNameController.dispose();
    _inspectorIdController.dispose();
    _driverNameController.dispose();
    _driverIdController.dispose();
    _vehiclePlateController.dispose();
    _vehicleFleetNumberController.dispose();
    _vehicleMakeModelController.dispose();
    _odometerController.dispose();
    findingPhotos.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template.title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Open CAPA Dashboard',
            icon: const Icon(Icons.assignment_turned_in_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CapaDashboardPage(findings: findings),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (findings.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange.shade100,
              child: Text(
                'Findings generated: ${findings.length}\n'
                'Latest risk: ${findings.last.riskLevel}\n'
                'Responsible: ${findings.last.responsiblePerson}\n'
                'CAPA: ${findings.last.correctiveAction}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.template.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildInspectionDetailsCard();
                }

                final item = widget.template.items[index - 1];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(item.itemNumber.toString()),
                    ),
                    title: Text(item.requirement),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.section),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children:
                              (widget.template.id == 'camp_welfare'
                                      ? [
                                          'Very Good',
                                          'Good',
                                          'Fair',
                                          'Needs Improvement',
                                          'Unacceptable',
                                          'N/A',
                                        ]
                                      : ['Yes', 'No', 'N/A'])
                                  .map((answer) {
                                    return ChoiceChip(
                                      label: Text(answer),
                                      selected:
                                          answers[item.itemNumber] == answer,
                                      onSelected: (_) {
                                        setState(() {
                                          answers[item.itemNumber] = answer;

                                          _updateFinding(
                                            itemNumber: item.itemNumber,
                                            requirement: item.requirement,
                                            answer: answer,
                                          );
                                        });
                                      },
                                    );
                                  })
                                  .toList(),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: commentControllers.putIfAbsent(
                            item.itemNumber,
                            () => TextEditingController(),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Comments / Defects Found',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        if (answers[item.itemNumber] == 'No') ...[
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _showPhotoSourcePicker(item.itemNumber),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Add Finding Photo'),
                          ),
                          const SizedBox(height: 8),
                          _buildFindingPhotos(item.itemNumber),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _submitInspection,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Submit Inspection'),
          ),
        ),
      ),
    );
  }
}
