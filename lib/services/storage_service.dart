import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/inspection_record.dart';

class StorageService {
  static const String inspectionKey = 'inspection_history';

  static Future<String> saveImagePermanently(File image) async {
    final directory = await getApplicationDocumentsDirectory();

    final imageName = 'inspection_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final savedImage = await image.copy('${directory.path}/$imageName');

    return savedImage.path;
  }

  static Future<File?> getInspectionImage(String storedPath) async {
    if (storedPath.isEmpty) return null;

    // First try the original saved path.
    final originalFile = File(storedPath);

    if (await originalFile.exists()) {
      return originalFile;
    }

    // If the iOS app-container path changed,
    // find the same filename in the current Documents folder.
    final directory = await getApplicationDocumentsDirectory();
    final fileName = storedPath.split('/').last;

    final currentFile = File('${directory.path}/$fileName');

    if (await currentFile.exists()) {
      return currentFile;
    }

    return null;
  }

  static Future<void> saveInspection(String inspection) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> inspections = prefs.getStringList(inspectionKey) ?? [];

    inspections.add(inspection);

    await prefs.setStringList(inspectionKey, inspections);
  }

  static Future<List<String>> getInspections() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(inspectionKey) ?? [];
  }

  static Future<void> clearInspections() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(inspectionKey);
  }

  static const String actionKey = 'corrective_actions';

  static Future<void> saveAction(String action) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> actions = prefs.getStringList(actionKey) ?? [];

    actions.add(action);

    await prefs.setStringList(actionKey, actions);
  }

  static Future<List<String>> getActions() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(actionKey) ?? [];
  }

  static Future<void> saveActions(List<String> actions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(actionKey, actions);
  }

  static Future<void> clearActions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(actionKey);
  }

  static const String hazardKey = 'hazard_reports';

  static Future<void> saveHazard(String hazard) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> hazards = prefs.getStringList(hazardKey) ?? [];

    hazards.add(hazard);

    await prefs.setStringList(hazardKey, hazards);
  }

  static Future<List<String>> getHazards() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(hazardKey) ?? [];
  }

  static Future<void> saveHazards(List<String> hazards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(hazardKey, hazards);
  }

  static Future<void> clearHazards() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(hazardKey);
  }

  static const String incidentKey = 'incident_reports';

  static Future<void> saveIncident(String incident) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> incidents = prefs.getStringList(incidentKey) ?? [];

    incidents.add(incident);

    await prefs.setStringList(incidentKey, incidents);
  }

  static Future<List<String>> getIncidents() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(incidentKey) ?? [];
  }

  static Future<void> saveIncidents(List<String> incidents) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(incidentKey, incidents);
  }

  static Future<void> clearIncidents() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(incidentKey);
  }

  static const String _inspectionRecordsKey = 'inspection_records';
  static const String _hazardRecordsKey = 'hazard_records';
  static Future<void> saveHazardRecord(InspectionRecord record) async {
    final prefs = await SharedPreferences.getInstance();

    final records = await getHazardRecords();
    records.insert(0, record);

    final encodedRecords = records
        .map((item) => jsonEncode(item.toJson()))
        .toList();

    await prefs.setStringList(_hazardRecordsKey, encodedRecords);
  }

  static Future<List<InspectionRecord>> getHazardRecords() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedRecords = prefs.getStringList(_hazardRecordsKey) ?? [];

    return encodedRecords.map((item) {
      final decoded = jsonDecode(item) as Map<String, dynamic>;

      return InspectionRecord.fromJson(decoded);
    }).toList();
  }

  static Future<void> migrateLegacyHazardRecords() async {
    final prefs = await SharedPreferences.getInstance();

    final inspectionRecords = await getInspectionRecords();
    final hazardRecords = await getHazardRecords();

    final legacyHazards = inspectionRecords
        .where((record) => record.inspectionId.startsWith('HSE-'))
        .toList();

    for (final record in legacyHazards) {
      final alreadyExists = hazardRecords.any(
        (item) => item.inspectionId == record.inspectionId,
      );

      if (!alreadyExists) {
        hazardRecords.add(record);
      }
    }

    inspectionRecords.removeWhere(
      (record) => record.inspectionId.startsWith('HSE-'),
    );

    await prefs.setStringList(
      _hazardRecordsKey,
      hazardRecords.map((item) => jsonEncode(item.toJson())).toList(),
    );

    await prefs.setStringList(
      _inspectionRecordsKey,
      inspectionRecords.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }

  static Future<void> saveInspectionRecord(InspectionRecord record) async {
    final prefs = await SharedPreferences.getInstance();

    final records = await getInspectionRecords();
    records.insert(0, record);

    final encodedRecords = records
        .map((item) => jsonEncode(item.toJson()))
        .toList();

    await prefs.setStringList(_inspectionRecordsKey, encodedRecords);
  }

  static Future<List<InspectionRecord>> getInspectionRecords() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedRecords = prefs.getStringList(_inspectionRecordsKey) ?? [];

    return encodedRecords.map((item) {
      final decoded = jsonDecode(item) as Map<String, dynamic>;

      return InspectionRecord.fromJson(decoded);
    }).toList();
  }

  static Future<void> deleteInspectionRecord(String inspectionId) async {
    final prefs = await SharedPreferences.getInstance();

    final records = await getInspectionRecords();

    records.removeWhere((record) => record.inspectionId == inspectionId);

    final encodedRecords = records
        .map((item) => jsonEncode(item.toJson()))
        .toList();

    await prefs.setStringList(_inspectionRecordsKey, encodedRecords);
  }
}
