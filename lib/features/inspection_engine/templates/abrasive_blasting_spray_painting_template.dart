import '../models/inspection_template.dart';

const abrasiveBlastingSprayPaintingTemplate = InspectionTemplate(
  id: 'abrasive_blasting_spray_painting',
  title: 'Abrasive Blasting & Spray Painting Compliance Checklist',
  client: 'ADNOC',
  category: 'Abrasive Blasting & Spray Painting',
  description:
      'HSE-PSW-CP16 Abrasive Blasting & Spray Painting Corporate Practice Compliance Checklist',
  responseType: InspectionResponseType.yesNoNa,
  items: [
    InspectionTemplateItem(
      itemNumber: 1,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Permit to Work',
    ),
    InspectionTemplateItem(
      itemNumber: 2,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Job Safety Analysis',
    ),
    InspectionTemplateItem(
      itemNumber: 3,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Training Course Certification of Performing Personnel',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'Section 7.2 – Risk Management Process',
      requirement:
          'Identification of all potential hazards associated with the activity',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Section 7.2 – Risk Management Process',
      requirement:
          'Risk Assessment for the activity has been performed by Competent Person',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Section 7.2 – Risk Management Process',
      requirement:
          'Implementation of systematic approach for Hierarchy of Controls as per the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring while using less Hazardous Abrasive Material method the concentration of impurities are checked by referring to SDS, before using the abrasive blasting mediums',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring metallic abrasives are not used while employing less Hazardous Abrasive Material method',
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring less Hazardous Surface Area Preparation Method is employed wherever applicable',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement: 'Ensuring blast chambers are used for controlling noise',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring relocation of blasting procedure i.e. separate rooms away from the work area is executed',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring noisy equipment are enclosed - blast cabinets, air compressors, and grit pots are located in soundproof enclosures',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring silencers are installed on intake and exhaust systems',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring sound transmission barriers around compressors are installed',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring personal hearing protectors such as ear plugs, ear canal caps, earmuffs, and hearing protective helmet are used',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring a cool, well-ventilated area is provided where workers can take rest breaks or carry out other tasks',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement: 'Ensuring work is scheduled at cooler times',
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement: 'Ensuring cool drinking water is readily available',
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring vibration isolating handles incorporated into blasting nozzles and/or supports to reduce the pressure of the hand to control the nozzle',
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Job rotation among performing personnel is in practice',
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement: 'Ensuring appropriate PPEs are used in process',
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Blasting Cabinets have a sealed window so that the operator can view the object being cleaned',
    ),
    InspectionTemplateItem(
      itemNumber: 23,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Blasting Cabinets are fitted with a dust extraction/collection system which has a sufficient air change rate to increase visibility',
    ),
    InspectionTemplateItem(
      itemNumber: 24,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement: 'Ensuring blast cabinets have a dust tight light fixture',
    ),
    InspectionTemplateItem(
      itemNumber: 25,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring an doors are interlocked to eliminate the possibility of the machine being operated while the door is open',
    ),
    InspectionTemplateItem(
      itemNumber: 26,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring easily accessible operating controls and interlocked doors to prevent the machinery being operated while the door is open (in case of Automated Blasting Chambers) are provided in blasting chambers',
    ),
    InspectionTemplateItem(
      itemNumber: 27,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Windows or inspection ports which are fixed in a metal sash and constructed of toughened safety glass, laminated safety glass or safety wired glass in blasting chambers',
    ),
    InspectionTemplateItem(
      itemNumber: 28,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring an emergency exit is located at the furthermost position from the main entrance that is signposted and backlit so that it is visible if the power is cut',
    ),
    InspectionTemplateItem(
      itemNumber: 29,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring a ventilation system kept in continuous operation whenever blasting is being done and for at least 5 minutes after blasting has finished',
    ),
    InspectionTemplateItem(
      itemNumber: 30,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring the air dilution and exhaust ventilation flow indices are determined and calculated in line with the requirements stated in American Conference of Governmental Industrial Hygienists (ACGIH) Industrial Ventilation Manual',
    ),
    InspectionTemplateItem(
      itemNumber: 31,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring illumination within every blasting chamber is not be less than twenty foot-candles (approximately 215 lux) measured in a horizontal plane at three feet above the floor',
    ),
    InspectionTemplateItem(
      itemNumber: 32,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring as minimum the Ventilation requirements for Blasting Cabinets and Chambers should be as recommended in ACGIH Industrial Ventilation Manual having the following details Minimum of 20 air changes per minute Minimum of 2.5 m/s inward velocity at all the openings Minimum of 20 m/s duct velocity',
    ),
    InspectionTemplateItem(
      itemNumber: 33,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring temporary enclosures are only used when the object or structure to be blasted is unable to be transported or too large for a blasting chamber',
    ),
    InspectionTemplateItem(
      itemNumber: 34,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring possible warning signs and barricading are provided to excluded the area where dust levels exceeds the exposure standards',
    ),
    InspectionTemplateItem(
      itemNumber: 35,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Dust extraction/collection systems fitted in temporary enclosures',
    ),
    InspectionTemplateItem(
      itemNumber: 36,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Containment screens are made of tear-resistant materials (for example, woven polypropylene fabric or rubber) for high abrasion areas inside the enclosure',
    ),
    InspectionTemplateItem(
      itemNumber: 37,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring size of the exclusion zone is determined after assessing the risk to all unprotected people and prevailing wind conditions',
    ),
    InspectionTemplateItem(
      itemNumber: 38,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring exclusion zone is established and maintained to exclude workers and other persons who are not wearing RPE',
    ),
    InspectionTemplateItem(
      itemNumber: 39,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Warning signs are located and are clearly visible before entering the area.',
    ),
    InspectionTemplateItem(
      itemNumber: 40,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring all valves are of a rating equivalent to that of the pressure vessel and correctly attached in Air compressors and blast pots',
    ),
    InspectionTemplateItem(
      itemNumber: 41,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring a calibrated/certified safety relief valve is fitted on the compressor or air supply system and regularly checked',
    ),
    InspectionTemplateItem(
      itemNumber: 42,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Pressure Vessels, are inspected annually to determine their validity by a competent person',
    ),
    InspectionTemplateItem(
      itemNumber: 43,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring that the competent person, who prepares inspection report is licensed by Labour Directorate of UAE',
    ),
    InspectionTemplateItem(
      itemNumber: 44,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring working pressure never exceeded rated working pressure as this may lead to explosion',
    ),
    InspectionTemplateItem(
      itemNumber: 45,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring muffler is attached to blast pots to minimize the noise from escaping air when the machine is depressurized',
    ),
    InspectionTemplateItem(
      itemNumber: 46,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring a Drip tray under compressor is provided (where required)',
    ),
    InspectionTemplateItem(
      itemNumber: 47,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Planned inspection and routine maintenance is carried out by a competent person as per manufacturer’s recommendation',
    ),
    InspectionTemplateItem(
      itemNumber: 48,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring an efficient means of discharging of static electrical charge from the blast nozzle and the object being blasted is provided, while dry blasting',
    ),
    InspectionTemplateItem(
      itemNumber: 49,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring the nozzle lining and threads are checked for wear and damage before operation',
    ),
    InspectionTemplateItem(
      itemNumber: 50,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring abrasive blasting equipment is fitted with an automatic cut-off device (dead man control switch)',
    ),
    InspectionTemplateItem(
      itemNumber: 51,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring Deadman controls (especially the lever) is inspected and tested several times each working day',
    ),
    InspectionTemplateItem(
      itemNumber: 52,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring hoses are constructed with anti-static rubber linings or fitted with an earth wire or similar mechanism to prevent electric shock',
    ),
    InspectionTemplateItem(
      itemNumber: 53,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring that the hose from the pot to the blast nozzle are kept as straight as possible to avoid rapid wear at edges',
    ),
    InspectionTemplateItem(
      itemNumber: 54,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring that the Hoses, hose whips and couplings are inspected, tested and maintained in accordance with the manufacturer’s recommendation',
    ),
    InspectionTemplateItem(
      itemNumber: 55,
      section: 'Section 7.3 – Control Measures for Abrasive Blasting Activity',
      requirement:
          'Ensuring proper means of recycling of blast materials is practiced',
    ),
    InspectionTemplateItem(
      itemNumber: 56,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring Spray booths are fitted with an exhaust capture system and a ventilation system that includes a filter for removing airborne contaminants',
    ),
    InspectionTemplateItem(
      itemNumber: 57,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring Spray booths have ventilation systems capable of producing a minimum air movement',
    ),
    InspectionTemplateItem(
      itemNumber: 58,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring Spray booths are inspected at regular intervals and maintained according to manufacturer’s recommendation',
    ),
    InspectionTemplateItem(
      itemNumber: 59,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring a pre-purge cycle to remove any residue contaminants and also operated a minimum of a 5 minute post-purge period following spraying in spray booths',
    ),
    InspectionTemplateItem(
      itemNumber: 60,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that the building or structure is of open construction or a mechanical exhaust system is used while spray painting activity is going on',
    ),
    InspectionTemplateItem(
      itemNumber: 61,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that exclusion zone have at least six metres horizontal and two metres vertical clearance above and below the place where the paint is being applied',
    ),
    InspectionTemplateItem(
      itemNumber: 62,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring the following purposes for ventilation system is achieved Draw overspray away from the personnel Control flammable and hazardous vapors Collect vapors, droplets and solid particles Filter or wash the air before it is discharged',
    ),
    InspectionTemplateItem(
      itemNumber: 63,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Regular gas monitoring of spray booth in order to ensure the flammable concentration does not exceed 25% of the LEL',
    ),
    InspectionTemplateItem(
      itemNumber: 64,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Air borne monitoring of vapors/solvents arising from spray painting process by Competent Person',
    ),
    InspectionTemplateItem(
      itemNumber: 65,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Consideration of minimum air requirement for Spray Booth (Small booths & large booths) as mandated in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 66,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Proper barricading including horizontal and vertical clearance for spray painting outside the spray booths',
    ),
    InspectionTemplateItem(
      itemNumber: 67,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that mechanical exhaust ventilation is provided to maintain concentration at all parts in safe level',
    ),
    InspectionTemplateItem(
      itemNumber: 68,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that discharge point is situated in a safe place away from any building, work area or source of ignition',
    ),
    InspectionTemplateItem(
      itemNumber: 69,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that the vapors from spraying accumulated at floor level is extracted properly',
    ),
    InspectionTemplateItem(
      itemNumber: 70,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring continuous gas monitoring with periodic check is in place',
    ),
    InspectionTemplateItem(
      itemNumber: 71,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Maintenance and inspection of all spray painting equipment by a Competent person as per the manufacturer’s recommendation',
    ),
    InspectionTemplateItem(
      itemNumber: 72,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that the areas in which spray painting is carried out, is separated from other parts of the same building by compartment walls and floors having fire resistance of not less than 2 hours',
    ),
    InspectionTemplateItem(
      itemNumber: 73,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring spray painting booths have built in vapor extraction system',
    ),
    InspectionTemplateItem(
      itemNumber: 74,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring all the fitting used in the vicinity of the activity are suitable for hazardous area and in line with ADNOC Control of Temporary Equipment in Classified Hazardous Areas Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 75,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring Over-speed shut down valves and Spark arrestor are fitted in Diesel Operating Equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 76,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement: 'Ensuring suitable fire extinguishers are provided',
    ),
    InspectionTemplateItem(
      itemNumber: 77,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that flammable chemicals, mixtures or materials are stored in in well-ventilated storage areas',
    ),
    InspectionTemplateItem(
      itemNumber: 78,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that warning signs are shown in storage cabinets and outside storage areas',
    ),
    InspectionTemplateItem(
      itemNumber: 79,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that a dedicated mixing area for paints is located in a separate, fire-resistant and well-ventilated room',
    ),
    InspectionTemplateItem(
      itemNumber: 80,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring that an absorbent material is readily available to soak up spillages',
    ),
    InspectionTemplateItem(
      itemNumber: 81,
      section: 'Section 7.4 – Control Measures for Spray Painting Activity',
      requirement:
          'Ensuring waste material/spillage resulting from all related activities are disposed, in accordance with requirements of ADNOC Waste Management Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 82,
      section: 'Section 7.5 – Working on Live Systems',
      requirement:
          'Ensuring that the abrasive blasting and painting is immediately stopped for operator access to the facility or when the wind direction is unfavourable',
    ),
    InspectionTemplateItem(
      itemNumber: 83,
      section: 'Section 7.5 – Working on Live Systems',
      requirement:
          'Ensuring that there are no spark producing operations on going',
    ),
    InspectionTemplateItem(
      itemNumber: 84,
      section: 'Section 7.5 – Working on Live Systems',
      requirement:
          'Ensuring that the personnel can quickly and easily reach to a safe zone',
    ),
    InspectionTemplateItem(
      itemNumber: 85,
      section: 'Section 7.6 – Personal & Respiratory Protective Equipment',
      requirement:
          'Ensuring use of all the PPE/RPE for the activity as mandated in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 86,
      section: 'Section 7.6 – Personal & Respiratory Protective Equipment',
      requirement:
          'Ensuring the following PPEs are used in Abrasive blasting activity Blast Suits including approved to BS EN ISO 14877 Blasting Hood Ear Plugs Ear Muffs Safety Glasses with side shields Safety Footwear Coveralls',
    ),
    InspectionTemplateItem(
      itemNumber: 87,
      section: 'Section 7.6 – Personal & Respiratory Protective Equipment',
      requirement:
          'Ensuring the following PPEs are used in Spray Painting activity Disposable Coveralls Paint Sprayer’s Mask Ear Defenders Safety Footwear Chemical Resistant Gloves, e.g. nitrile - Single-use gloves are preferred, which shall be discarded every time they are taken off',
    ),
    InspectionTemplateItem(
      itemNumber: 88,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Proper handling, transportation and lifting of abrasive materials in FIBCs as mandated in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 89,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Proper storage of blasting materials as mandated in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 90,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Ensuring that storage area for paints, coatings and their associated solvents are situated in a control area, away from active work areas',
    ),
    InspectionTemplateItem(
      itemNumber: 91,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Ensuring that Stores are of fire resistant construction and conform to the guidance for handling and storage as laid down in the NFPA-30',
    ),
    InspectionTemplateItem(
      itemNumber: 92,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Ensuring that an Automatic fire detection system is installed in flammable liquid storage linked to audible alarms',
    ),
    InspectionTemplateItem(
      itemNumber: 93,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Ensuring that all paint storage facilities/activity are classified as hazardous area and all the fitting are in line with ADNOC Control of Temporary Equipment in Classified Hazardous Areas Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 94,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Ensuring that paint is stored in accordance with manufacturer’s recommendation and any stipulations set out in SDS and Incompatible volatile substances are segregated',
    ),
    InspectionTemplateItem(
      itemNumber: 95,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Ensuring that the store is ventilated and kept protected from the direct sun light or any other heat source to prevent a build-up of temperature within the store',
    ),
    InspectionTemplateItem(
      itemNumber: 96,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Ensuring that open containers of paint, or other substances are not stored in paint stores',
    ),
    InspectionTemplateItem(
      itemNumber: 97,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Ensuring that partially used containers of paint or thinners remaining unused at the end of the day are resealed, cleaned and returned to the store',
    ),
    InspectionTemplateItem(
      itemNumber: 98,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Ensuring that the dispensing or decanting of material from one container to another are not take place within the store but in the open air away from hazardous areas of operation',
    ),
    InspectionTemplateItem(
      itemNumber: 99,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'In the event of spillage procedures are available to effect the clean-up and prevent environmental hazards',
    ),
    InspectionTemplateItem(
      itemNumber: 100,
      section: 'Section 7.7 – Handling and Storage',
      requirement:
          'Paint mixing to be done in separate fire-resistant and ventilated room',
    ),
    InspectionTemplateItem(
      itemNumber: 101,
      section: 'Section 7.7 – Handling and Storage',
      requirement: 'Proper segregation of compatible and incompatible paints',
    ),
    InspectionTemplateItem(
      itemNumber: 102,
      section: 'Section 7.8 – Training & Competence',
      requirement:
          'Confirming the Blasters and Spray Painters have undergone a formal training course in a recognized institute/organization (i.e. Offshore Petroleum Industry Training Organization (OPITO) or equivalent).',
    ),
    InspectionTemplateItem(
      itemNumber: 103,
      section: 'Section 7.8 – Training & Competence',
      requirement: 'Appropriate competency records maintained at the site.',
    ),
  ],
);
