import '../models/inspection_template.dart';

const compressedGasCylindersTemplate = InspectionTemplate(
  id: 'compressed_gas_cylinders',
  title: 'Compressed Gas Cylinders Compliance Checklist',
  client: 'ADNOC',
  category: 'Compressed Gas Cylinders',
  description:
      'HSE-PSW-CP07 Compressed Gas Cylinders Corporate Practice Compliance Checklist',
  responseType: InspectionResponseType.yesNoNa,
  items: [
    InspectionTemplateItem(
      itemNumber: 1,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Valid test Certificate for the cylinders',
    ),
    InspectionTemplateItem(
      itemNumber: 2,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Analysis Certificate attached to the cylinders',
    ),
    InspectionTemplateItem(
      itemNumber: 3,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Hydro Test Certificate for the Cylinders',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Safety Device Certificate for the cylinders',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Safety Data Sheet (SDS)',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Section 7.1 – General',
      requirement:
          'Ensuring Compressed Gas Cylinders handled by trained and competent person',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Section 7.1 – General',
      requirement:
          'Personnel responsible for handling, transporting, and managing Compressed Gas Cylinders within the eWMS have received adequate training and competency verification specific to the eWMS platform.',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Section 7.1 – General',
      requirement:
          'Confirming trained drivers used for safe transportation of cylinders and measures to be taken in case of emergency',
    ),
    // The source checklist contains an unnumbered Section 7.2 Types of Gases row. Numbered checklist items are preserved as 1-102.
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Section 7.3 – Hazards Associated with Compressed Gas Cylinders',
      requirement:
          'Identification of all the potential hazards associated with Compressed Gas Cylinders as mentioned in the Corporate Practice (i.e. Oxidizing Hazards, Fire and Explosion, Asphyxiation, Toxic, Corrosive, Pressure)',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Risk Assessment for the activity has been performed by Competent Person',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'The electronic Work Management System (eWMS) is utilized for registering, tracking, and controlling activities related to Compressed Gas Cylinders in accordance with CP requirements.',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Implementation of systematic approach for Hierarchy of Controls as per the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Implementation of control measures against gases with specific hazard classes (i.e. Corrosive Gases, Cryogenic Liquids or Gases, Toxic Gases, Flammable Gases)',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring that equipment and lines are checked daily for damage and leaks',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring that diaphragm gauge are used with corrosive gases',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Conducting inspection of regulators to check for damage and flush them with dry air or nitrogen, after its removal',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring that valves, equipment and containers are designed for the intended product and services',
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring inspection of containers for loss of insulating vacuum',
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring that all cryogenic systems are equipped with pressure relief devices to prevent pressure build up',
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring that flammable gases except for protected fuel gases are not used near ignition sources',
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring availability of portable fire extinguishers which are compatible with the apparatus and the materials in use for fire emergencies',
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring usage of spark proof tools when working with or on a flammable compressed gas cylinder or system',
    ),
    InspectionTemplateItem(
      itemNumber: 23,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring design and construction of manifold system by competent personnel who are thoroughly familiar with the requirements for piping of flammable gases',
    ),
    InspectionTemplateItem(
      itemNumber: 24,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Ensuring completion of consultation with the gas supplier before installation of manifolds',
    ),
    InspectionTemplateItem(
      itemNumber: 25,
      section: 'Section 7.4 – Risk Management Process',
      requirement:
          'Maintenance and regular review of the control measures that are implemented to protect health and safety to ensure their effectiveness specially when there are change in the workplace',
    ),
    InspectionTemplateItem(
      itemNumber: 26,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of all necessary arrangements for the safe handling of compressed gas cylinders as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 27,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Fitting of Flashback devices at both the regulator and torch end of the oxygen / fuel gas systems',
    ),
    InspectionTemplateItem(
      itemNumber: 28,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement: 'Identification of clear and legible marking on cylinders',
    ),
    InspectionTemplateItem(
      itemNumber: 29,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of requirements/international standards for the procurement of compressed gas cylinders as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 30,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of requirements/international standards for the procurement of compressed gas cylinders accessories as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 31,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring any gas cylinders procurement order has an approved specification for container as well as Safety Data Sheet (SDS) for the content',
    ),
    InspectionTemplateItem(
      itemNumber: 32,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Confirming that all gas cylinders has a valid test certificate indicating the cylinder has been tested and has adequate validity time left for inspection and testing;',
    ),
    InspectionTemplateItem(
      itemNumber: 33,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring all necessary Checks, Documents and Inspection for all compressed gas cylinders received from supplier',
    ),
    InspectionTemplateItem(
      itemNumber: 34,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Confirming proper tagging of each cylinder with the necessary information as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 35,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Accepting compressed gas cylinders on receipt at site based on its physical condition (i.e. corrosion, pitting, dents or other signs of physical damage).',
    ),
    InspectionTemplateItem(
      itemNumber: 36,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of all necessary transportation arrangements as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 37,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Availability and functioning of 2kg fire extinguisher (DCP or CO2 type) on all vehicles transporting compressed gas cylinders',
    ),
    InspectionTemplateItem(
      itemNumber: 38,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of necessary precautions for cylinders heavier than 20kg as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 39,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of labels on the cylinders in line with BS EN 1089-3 for identifying its content and providing basic safety information of the hazards associated with the product.',
    ),
    InspectionTemplateItem(
      itemNumber: 40,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Application of Color Code to the shoulder or curved part of the cylinders based on the properties of the content in accordance with the hazard of the gas filled as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 41,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Confirming Piping, regulators and other equipment be gas-tight to prevent leakage',
    ),
    InspectionTemplateItem(
      itemNumber: 42,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Conducting test for leakage and pressure rating of the cylinders when connected to a manifold',
    ),
    InspectionTemplateItem(
      itemNumber: 43,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Conducting leak test of the cylinder connection when first installed by the use of compatible leak test material (e.g. liquid, foam, etc.) or an appropriate leak-detection instrument',
    ),
    InspectionTemplateItem(
      itemNumber: 44,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Inspection and testing of hoses prior to use as per manufacturer recommendation.',
    ),
    InspectionTemplateItem(
      itemNumber: 45,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Conducting of two (02) level of inspection for the hoses as mentioned in the Corporate Practice (i.e. Level 1 and Level 2)',
    ),
    InspectionTemplateItem(
      itemNumber: 46,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that cylinders containing compressed gas are transported in properly constructed racks or baskets in which the cylinders are vertical and securely fastened by chain or similar means',
    ),
    InspectionTemplateItem(
      itemNumber: 47,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring transportation of compressed gas cylinders in open vehicles or containers',
    ),
    InspectionTemplateItem(
      itemNumber: 48,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that compressed gas cylinders are not transported by aircrafts and helicopters in any normal situation',
    ),
    InspectionTemplateItem(
      itemNumber: 49,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that compressed gas cylinders when transported via marine vessel are kept in racks or baskets in a vertical position and securely fastened by chain or straps',
    ),
    InspectionTemplateItem(
      itemNumber: 50,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that cylinders containing toxic gases are not transported in a vehicle without a separate driver cab and load compartment',
    ),
    InspectionTemplateItem(
      itemNumber: 51,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that empty compressed gas cylinders, except acetylene are stored and transported in a horizontal position',
    ),
    InspectionTemplateItem(
      itemNumber: 52,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring extreme caution is exercised to avoid knocking or jarring of acetylene cylinders',
    ),
    InspectionTemplateItem(
      itemNumber: 53,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that leaked or exposed to fire compressed gas cylinder are not shipped. Consultation with supplier is carried out for advices under such circumstances',
    ),
    InspectionTemplateItem(
      itemNumber: 54,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that different gases in bulk transport racks are not intermixed and are kept clear of flammable materials',
    ),
    InspectionTemplateItem(
      itemNumber: 55,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that compressed gas cylinders heavier than 20 kg are only lifted using a cradle in which a compressed gas cylinder is protected and secured',
    ),
    InspectionTemplateItem(
      itemNumber: 56,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that compressed gas cylinders heavier than 20 kg are not lifted using ropes, chains or slings unless the cylinder was manufactured with lifting lugs',
    ),
    InspectionTemplateItem(
      itemNumber: 57,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that large, compressed gas cylinders are transported using a wheeled hand trolley or other proper vehicle',
    ),
    InspectionTemplateItem(
      itemNumber: 58,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that compressed gas cylinders are not tipped, dragged, slide, rolled or dropped',
    ),
    InspectionTemplateItem(
      itemNumber: 59,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring prohibition of hitching a compressed gas cylinder to the back of a vehicle',
    ),
    InspectionTemplateItem(
      itemNumber: 60,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that compressed gas cylinders are disconnected and removed of gauges, valves are closed and capped before transportation',
    ),
    InspectionTemplateItem(
      itemNumber: 61,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring maintenance of transport racks for cylinders in a good condition',
    ),
    InspectionTemplateItem(
      itemNumber: 62,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of Color Codes of hoses cover in line with BS EN ISO 3821 to identify the gas for which the hoses to be used.',
    ),
    InspectionTemplateItem(
      itemNumber: 63,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Identification of Inspection/Replacement date of the regulator on the side of the regulator body',
    ),
    InspectionTemplateItem(
      itemNumber: 64,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement: 'Ensuring periodic inspection of the regulators',
    ),
    InspectionTemplateItem(
      itemNumber: 65,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring pressure regulators are provided with the safety features such as provision of a filtered supply of gas at a constant delivery pressure, safety diaphragms that burst before the bonnet is blown off and pressure gauges with safety backs that deflect the venting gas',
    ),
    InspectionTemplateItem(
      itemNumber: 66,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that cylinder valves are closed, and the regulator is relieved of gas pressure before a regulator is removed',
    ),
    InspectionTemplateItem(
      itemNumber: 67,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that valves and fittings are kept scrupulously clean to avoid leaks and possible gas build-up',
    ),
    InspectionTemplateItem(
      itemNumber: 68,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that valves without hand wheels are provided with keys and those keys are designed for the specific valve in use and are kept on the valve while the cylinder is in use',
    ),
    InspectionTemplateItem(
      itemNumber: 69,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that for valves with hand wheels; spanners, wrenches, hammers or other tools are not used for opening and closing of the valves',
    ),
    InspectionTemplateItem(
      itemNumber: 70,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that gas cylinders are not attached directly to a process in which it can be contaminated by the backflow of other process materials',
    ),
    InspectionTemplateItem(
      itemNumber: 71,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Confirming regular check and maintenance of non-return valves and/or traps to ensure proper operation',
    ),
    InspectionTemplateItem(
      itemNumber: 72,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement: 'Implementation for the use of all necessary PPE/RPE',
    ),
    InspectionTemplateItem(
      itemNumber: 73,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of all necessary arrangements for the storage of compressed gas cylinders as mentioned in the Corporate Practice (i.e. Safe Distance, Fire Resistance wall)',
    ),
    InspectionTemplateItem(
      itemNumber: 74,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that compressed gas cylinders are not stored in an enclosed space or the place of where the humidity is high e.g., a vessel hold',
    ),
    InspectionTemplateItem(
      itemNumber: 75,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that compressed gas cylinders are not placed where they may become part of an electrical circuit or a grounding path',
    ),
    InspectionTemplateItem(
      itemNumber: 76,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that the storage areas for compressed gas cylinders are cool dry, well ventilated and equipped with compartments or diving walls of 1.5 m (5 feet) high having a fire resistance of 30 minutes',
    ),
    InspectionTemplateItem(
      itemNumber: 77,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Confirming the Storage of oxygen cylinder and fuel gas cylinder separately',
    ),
    InspectionTemplateItem(
      itemNumber: 78,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of Safe Distance within two cylinders (i.e. 6.1m)',
    ),
    InspectionTemplateItem(
      itemNumber: 79,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that dry chemical fire extinguishers are placed at easily accessible locations inside and outside the storage area',
    ),
    InspectionTemplateItem(
      itemNumber: 80,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that compressed gas cylinders containing gases heavier than air are not stored near drain openings, excavation or other confined space',
    ),
    InspectionTemplateItem(
      itemNumber: 81,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Identification and segregation of full and empty cylinders into separate designated areas',
    ),
    InspectionTemplateItem(
      itemNumber: 82,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that cylinders are not made to stand on a collapsible or corroded materials or surface which may cause deterioration of the cylinder bases',
    ),
    InspectionTemplateItem(
      itemNumber: 83,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of all necessary requirements for the storage of gas cylinders based on hazard class',
    ),
    InspectionTemplateItem(
      itemNumber: 84,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Conducting an additional risk assessment to determine the minimum recommended separation distances when hazardous materials are stored in bulk close to a gas store',
    ),
    InspectionTemplateItem(
      itemNumber: 85,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that adequate signage are provided having warning and safety information on the hazardous products for individual gas cylinders stores',
    ),
    InspectionTemplateItem(
      itemNumber: 86,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring all signage are in English language. Use bilingual/multilingual signs of required',
    ),
    InspectionTemplateItem(
      itemNumber: 87,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that signs and pictograms are clearly visible from all angles of approach preferably sited with the centre of the sign at the average eye level (between 1.5 and 1.7 m above the ground)',
    ),
    InspectionTemplateItem(
      itemNumber: 88,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that the store is provided with ventilation opening with a minimum area of 10% of the ground area where natural ventilation is used',
    ),
    InspectionTemplateItem(
      itemNumber: 89,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Confirming that a minimum of two permanent openings are provided having the inlet and outlet openings positioned diametrically across the store at high and low levels',
    ),
    InspectionTemplateItem(
      itemNumber: 90,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Confirming that the ventilation opening is discharged to a safe place in the open air',
    ),
    InspectionTemplateItem(
      itemNumber: 91,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that forced ventilation system is connected to a suitable visual and audible alarm systems to provide a warning in the event that the ventilation is not functioning correctly',
    ),
    InspectionTemplateItem(
      itemNumber: 92,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Confirming that cylinders, fittings, regulators and pipework are regularly inspected and tested',
    ),
    InspectionTemplateItem(
      itemNumber: 93,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Ensuring that the record of inspection and testing are kept and maintained',
    ),
    InspectionTemplateItem(
      itemNumber: 94,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Conducting hydrostatic test of cylinders with valid tag at a frequency specified in the Corporate Practice which is line with BS EN 1968 by a qualified testing facility.',
    ),
    InspectionTemplateItem(
      itemNumber: 95,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Implementation of all necessary arrangements for the disposal of compressed gas cylinders',
    ),
    InspectionTemplateItem(
      itemNumber: 96,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Color Coding of Gas Cylinders Shoulder per BS EN 1089-3 and Table 7.5.2 is applied and verified.',
    ),
    InspectionTemplateItem(
      itemNumber: 97,
      section:
          'Section 7.5 – Safe Handling Requirements of Compressed Gas Cylinders',
      requirement:
          'Residual pressure maintained in cylinders to prevent backflow contamination.',
    ),
    InspectionTemplateItem(
      itemNumber: 98,
      section: 'Section 7.6 – Emergency Response',
      requirement:
          'Implementation of all necessary emergency response arrangements',
    ),
    InspectionTemplateItem(
      itemNumber: 99,
      section: 'Section 7.6 – Emergency Response',
      requirement: 'Availability of Emergency Response Plan',
    ),
    InspectionTemplateItem(
      itemNumber: 100,
      section: 'Section 7.6 – Emergency Response',
      requirement: 'Availability of First aid at all times',
    ),
    InspectionTemplateItem(
      itemNumber: 101,
      section: 'Section 7.6 – Emergency Response',
      requirement:
          'Availability of contact details external emergency services',
    ),
    InspectionTemplateItem(
      itemNumber: 102,
      section: 'Section 7.6 – Emergency Response',
      requirement:
          'After Action Review (AAR) conducted after compressed gas incidents and near-misses to capture lessons learned.',
    ),
  ],
);
