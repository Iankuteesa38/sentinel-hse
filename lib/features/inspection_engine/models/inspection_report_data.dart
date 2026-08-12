import 'dart:typed_data';

import 'inspection_finding.dart';

class InspectionReportItem {
  final int itemNumber;
  final String section;
  final String requirement;
  final String answer;
  final String comment;

  final String performanceRating;
  final String revisedRiskRanking;
  final double marks;
  final double weight;
  final double weightedScore;

  const InspectionReportItem({
    required this.itemNumber,
    required this.section,
    required this.requirement,
    required this.answer,
    required this.comment,
    this.performanceRating = '',
    this.revisedRiskRanking = '',
    this.marks = 0,
    this.weight = 1.0,
    this.weightedScore = 0,
  });
}

class InspectionReportData {
  final String reportReference;
  final String inspectionTitle;
  final String inspectionLocation;

  final String inspectorName;
  final String inspectorEmployeeId;

  final String driverName;
  final String driverEmployeeId;

  final String vehiclePlateNumber;
  final String vehicleFleetNumber;
  final String vehicleMakeModel;
  final String odometerReading;
  final String campName;
  final String contractorName;
  final String contractAdministrator;
  final String groupCompany;
  final String assetFunction;
  final String campRepresentative;
  final String liftingGroupCompany;
  final String liftingContractorLocation;
  final DateTime submittedAt;
  final List<InspectionReportItem> items;
  final List<InspectionFinding> findings;
  final Map<int, List<Uint8List>> findingPhotos;

  InspectionReportData({
    required this.reportReference,
    required this.inspectionTitle,
    required this.inspectionLocation,
    required this.inspectorName,
    required this.inspectorEmployeeId,
    required this.driverName,
    required this.driverEmployeeId,
    required this.vehiclePlateNumber,
    required this.vehicleFleetNumber,
    required this.vehicleMakeModel,
    required this.odometerReading,
    this.campName = '',
    this.contractorName = '',
    this.contractAdministrator = '',
    this.groupCompany = '',
    this.assetFunction = '',
    this.campRepresentative = '',
    this.liftingGroupCompany = '',
    this.liftingContractorLocation = '',
    required this.submittedAt,
    required List<InspectionReportItem> items,
    required List<InspectionFinding> findings,
    required Map<int, List<Uint8List>> findingPhotos,
  }) : items = List<InspectionReportItem>.unmodifiable(items),
       findings = List<InspectionFinding>.unmodifiable(findings),
       findingPhotos = Map<int, List<Uint8List>>.unmodifiable(
         findingPhotos.map(
           (itemNumber, photos) =>
               MapEntry(itemNumber, List<Uint8List>.unmodifiable(photos)),
         ),
       );

  int get yesCount {
    return items.where((item) => item.answer == 'Yes').length;
  }

  int get noCount {
    return items.where((item) => item.answer == 'No').length;
  }

  int get naCount {
    return items.where((item) => item.answer == 'N/A').length;
  }

  double get compliancePercentage {
    final applicableItems = yesCount + noCount;

    if (applicableItems == 0) {
      return 100;
    }

    return (yesCount / applicableItems) * 100;
  }

  double get welfareTotalWeight {
    return items
        .where((item) => item.performanceRating != 'N/A')
        .fold(0.0, (sum, item) => sum + item.weight);
  }

  double get welfareWeightedScore {
    return items
        .where((item) => item.performanceRating != 'N/A')
        .fold(0.0, (sum, item) => sum + item.weightedScore);
  }

  double get welfareAuditPercentage {
    if (welfareTotalWeight == 0) {
      return 0;
    }

    return welfareWeightedScore / welfareTotalWeight;
  }

  String get welfareRagRating {
    final score = welfareAuditPercentage;

    if (score >= 80) {
      return 'Green';
    }

    if (score >= 61) {
      return 'Yellow';
    }

    if (score >= 51) {
      return 'Amber';
    }

    return 'Red';
  }

  Map<String, double> get welfareSectionScores {
    final Map<String, List<InspectionReportItem>> grouped = {};

    for (final item in items) {
      if (item.performanceRating == 'N/A') {
        continue;
      }

      grouped.putIfAbsent(item.section, () => []);
      grouped[item.section]!.add(item);
    }

    final Map<String, double> scores = {};

    for (final entry in grouped.entries) {
      final sectionItems = entry.value;

      final totalWeight = sectionItems.fold<double>(
        0.0,
        (sum, item) => sum + item.weight,
      );

      final weightedScore = sectionItems.fold<double>(
        0.0,
        (sum, item) => sum + item.weightedScore,
      );

      scores[entry.key] = totalWeight == 0 ? 0 : weightedScore / totalWeight;
    }

    return scores;
  }
}
