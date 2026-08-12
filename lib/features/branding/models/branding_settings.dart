class BrandingSettings {
  final String companyName;
  final String projectSiteName;
  final String clientName;
  final String logoPath;
  final int primaryColorValue;

  const BrandingSettings({
    required this.companyName,
    required this.projectSiteName,
    required this.clientName,
    required this.logoPath,
    required this.primaryColorValue,
  });

  static const int defaultPrimaryColorValue = 0xFF2196F3;

  factory BrandingSettings.defaults() {
    return const BrandingSettings(
      companyName: '',
      projectSiteName: '',
      clientName: '',
      logoPath: '',
      primaryColorValue: defaultPrimaryColorValue,
    );
  }

  BrandingSettings copyWith({
    String? companyName,
    String? projectSiteName,
    String? clientName,
    String? logoPath,
    int? primaryColorValue,
  }) {
    return BrandingSettings(
      companyName: companyName ?? this.companyName,
      projectSiteName: projectSiteName ?? this.projectSiteName,
      clientName: clientName ?? this.clientName,
      logoPath: logoPath ?? this.logoPath,
      primaryColorValue: primaryColorValue ?? this.primaryColorValue,
    );
  }
}
