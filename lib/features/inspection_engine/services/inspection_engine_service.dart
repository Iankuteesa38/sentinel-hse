import '../models/inspection_template.dart';
import '../templates/adnoc_vaai_vehicle_template.dart';
import '../templates/camp_welfare_template.dart';
import '../templates/lifting_hoisting_template.dart';
import '../templates/jsa_template.dart';
import '../templates/confined_space_entry_template.dart';
import '../templates/scaffolding_template.dart';
import '../templates/electrical_safety_template.dart';
import '../templates/compressed_gas_cylinders_template.dart';
import '../templates/excavation_template.dart';
import '../templates/abrasive_blasting_spray_painting_template.dart';
import '../templates/working_at_height_template.dart';
import '../templates/land_transportation_safety_template.dart';

class InspectionEngineService {
  const InspectionEngineService();

  List<InspectionTemplate> getAvailableTemplates() {
    return const [
      adnocVaaiVehicleTemplate,
      campWelfareTemplate,
      liftingHoistingTemplate,
      jsaTemplate,
      confinedSpaceEntryTemplate,
      scaffoldingTemplate,
      electricalSafetyTemplate,
      compressedGasCylindersTemplate,
      excavationTemplate,
      abrasiveBlastingSprayPaintingTemplate,
      workingAtHeightTemplate,
      landTransportationSafetyTemplate,
    ];
  }

  InspectionTemplate? findTemplateById(String id) {
    try {
      return getAvailableTemplates().firstWhere(
        (template) => template.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}
