import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/branding_settings.dart';

class BrandingService {
  BrandingService._();

  static const String _companyKey = 'branding_company_name';

  static const String _projectKey = 'branding_project_site';

  static const String _clientKey = 'branding_client_name';

  static const String _logoKey = 'branding_logo_path';

  static const String _primaryColorKey = 'branding_primary_color';

  static Future<BrandingSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    final storedCompany = prefs.getString(_companyKey) ?? '';

    final legacyCompany = prefs.getString('company') ?? '';

    return BrandingSettings(
      companyName: storedCompany.isNotEmpty ? storedCompany : legacyCompany,
      projectSiteName: prefs.getString(_projectKey) ?? '',
      clientName: prefs.getString(_clientKey) ?? '',
      logoPath: prefs.getString(_logoKey) ?? '',
      primaryColorValue:
          prefs.getInt(_primaryColorKey) ??
          BrandingSettings.defaultPrimaryColorValue,
    );
  }

  static Future<void> save(BrandingSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_companyKey, settings.companyName);

    await prefs.setString(_projectKey, settings.projectSiteName);

    await prefs.setString(_clientKey, settings.clientName);

    await prefs.setString(_logoKey, settings.logoPath);

    await prefs.setInt(_primaryColorKey, settings.primaryColorValue);

    await prefs.setString('company', settings.companyName);
  }

  static Future<String> saveLogo(File sourceFile) async {
    final directory = await getApplicationDocumentsDirectory();

    final extension = sourceFile.path.split('.').last.toLowerCase();

    final safeExtension = extension.isEmpty ? 'jpg' : extension;

    final destination = File(
      '${directory.path}/'
      'sentinel_brand_logo.$safeExtension',
    );

    if (await destination.exists()) {
      await destination.delete();
    }

    final copied = await sourceFile.copy(destination.path);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_logoKey, copied.path);

    return copied.path;
  }

  static Future<File?> getLogoFile(String storedPath) async {
    if (storedPath.trim().isEmpty) {
      return null;
    }

    final original = File(storedPath);

    if (await original.exists()) {
      return original;
    }

    final directory = await getApplicationDocumentsDirectory();

    final fileName = storedPath.split('/').last;

    final recovered = File('${directory.path}/$fileName');

    if (await recovered.exists()) {
      return recovered;
    }

    return null;
  }

  static Future<void> removeLogo() async {
    final settings = await load();

    if (settings.logoPath.isNotEmpty) {
      final file = await getLogoFile(settings.logoPath);

      if (file != null && await file.exists()) {
        await file.delete();
      }
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_logoKey);
  }
}
