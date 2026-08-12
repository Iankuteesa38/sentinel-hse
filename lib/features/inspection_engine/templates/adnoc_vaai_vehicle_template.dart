import '../models/inspection_template.dart';

const adnocVaaiVehicleTemplate = InspectionTemplate(
  id: 'adnoc_vaai_vehicle',
  title: 'ADNOC VAAI Vehicle Spot Check',
  client: 'ADNOC',
  category: 'Vehicle Inspection',
  description: 'Vehicle Acceptance and Assurance Inspection (VAAI)',
  responseType: InspectionResponseType.yesNoNa,
  items: [
    InspectionTemplateItem(
      itemNumber: 1,
      section: 'Documents',
      requirement: 'Valid Vehicle Registration & Security Pass',
    ),
    InspectionTemplateItem(
      itemNumber: 2,
      section: 'Documents',
      requirement:
          'Valid Defensive Driving Training for the type of Vehicle / ADSD',
    ),
    InspectionTemplateItem(
      itemNumber: 3,
      section: 'IVMS',
      requirement: 'Valid IVMS RFID (where applicable)',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'IVMS',
      requirement: 'Online Operational IVMS',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Vehicle Documentation',
      requirement: 'Daily vehicle checklist',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Vehicle Condition',
      requirement: 'Vehicle body/windscreen has no signs of damage',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Safety Equipment',
      requirement: 'Seatbelt',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Vehicle Condition',
      requirement: 'Tire general condition',
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Vehicle Condition',
      requirement: 'Spare tire available',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Vehicle Condition',
      requirement: 'Vehicle lights functioning correctly',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Vehicle Condition',
      requirement: 'Mirrors',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Passenger Comfort',
      requirement:
          'Air-conditioning functioning and serviceable to all passengers where applicable',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Emergency Equipment',
      requirement: 'First aid kit',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Emergency Equipment',
      requirement: 'Fire extinguisher',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Vehicle Safety Equipment',
      requirement: 'Spark arrestor (where applicable)',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Vehicle Safety Equipment',
      requirement:
          'Automatic Air Intake Shut Off Valve (ASOV) where applicable',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Housekeeping',
      requirement: 'Cleanliness and housekeeping',
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: 'Vehicle Equipment',
      requirement: 'Vehicle toolkits with jack',
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: 'Off-Road Safety',
      requirement:
          'Roll Over Protection Structure (ROPS) for off-road operations',
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: 'Off-Road Safety',
      requirement: 'Desert Survival Kit for off-road operations',
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: 'Off-Road Safety',
      requirement:
          'Non-conductive flexible flagpole, minimum 3 metres high, for off-road operations',
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: 'Other Defects',
      requirement: 'Any other defect identified',
    ),
  ],
);
