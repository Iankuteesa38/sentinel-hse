import '../models/inspection_template.dart';

const scaffoldingTemplate = InspectionTemplate(
  id: 'scaffolding',
  title: 'Scaffolding Compliance Checklist',
  client: 'ADNOC',
  category: 'Scaffolding',
  description:
      'HSE-PSW-CP15 Scaffolding Corporate Practice Compliance Checklist',
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
      section: 'Section 7.1 - Scaffolding',
      requirement: 'Checking of scaffolding Erection surface before erection',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'Section 7.2 - Scaffolding Structural Components and Dimension',
      requirement:
          'Ensuring availability and use all Structural Scaffolding components as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Section 7.2 - Scaffolding Structural Components and Dimension',
      requirement:
          'Ensure toe boards, brick guards, reveal pins, and sole boards are used as required and conform to CP15 Section 7.2.',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Section 7.4 – Selection of Scaffolding Type',
      requirement:
          'Assessment and selection with justification for required type of scaffolding by competent person',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Section 7.4 – Selection of Scaffolding Type',
      requirement:
          'Ensuring work to be carried out is taken into account while selection of scaffolding type',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Section 7.4 – Selection of Scaffolding Type',
      requirement:
          'Ensuring location and weather conditions are taken into account while selection of scaffolding type',
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Section 7.4 – Selection of Scaffolding Type',
      requirement:
          'Ensuring load bearing calculations and duration of work access are taken into account while selection of scaffolding type',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Section 7.4 – Selection of Scaffolding Type',
      requirement:
          'Ensuring inherent risk from working at height is taken into consideration while selection of scaffolding type',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Section 7.4 – Selection of Scaffolding Type',
      requirement:
          'Identification of scaffolding class and design in line with BS EN 12811 Standard (for loading criteria)',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Section 7.5 – Hazards Associated With Scaffolding',
      requirement:
          'Ensuring personnel involved are oriented with hazards associated with scaffolding',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring the risks from working at height is assessed and all personnel who are required to work at height are trained to identify risks and take the necessary precautions, before carrying out the work',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring practicable barricades are provided by keeping a clear distance from scaffolding structure',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring materials are shifted in mechanised manner with ropes, pulley and Bag etc.',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring there is no practice of keeping material inside the scaffolding pipe opening',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring no part of operational or pressurized process line is used as a support for scaffolding',
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring clearance is defined in planning stage and maintained during erection and use of scaffolding for overhead electrical lines and nearby process lines.',
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring the personnel are always wearing PPE at all times in work',
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring safety helmets with chinstraps are provided while working in scaffolding erection and dismantling',
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensure personnel wear full body harness during erection & dismantling of scaffolding and on scaffolding after erection if there is a risk of falling from height and falling objects on a case-by-case basis',
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring personnel wear Personal Floatation Device (PFD) while working, erection and dismantling over water',
    ),
    InspectionTemplateItem(
      itemNumber: 23,
      section: 'Section 7.6 – Control Measures',
      requirement:
          'Ensuring safe manual handling practices are followed by all personnel when required to manually handle scaffolding material and equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 24,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Ensuring rigorous Scaffolding Safety Management Plan (PDCA Approach) is in place for maintaining scaffolding in a safe and workable condition during constructions, routine maintenance jobs and turnarounds',
    ),
    InspectionTemplateItem(
      itemNumber: 25,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Defining task/load requirements, ground preparation, layout, scheduling, loading, access, tying arrangements and other requirements of the particular task in method statement',
    ),
    InspectionTemplateItem(
      itemNumber: 26,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Ensuring responsibilities are identified for individuals performing specific tasks and duties during erection of scaffolding',
    ),
    InspectionTemplateItem(
      itemNumber: 27,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Identification of appropriate engineering controls to reduce risk after risk assessment for specific tasks',
    ),
    InspectionTemplateItem(
      itemNumber: 28,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Appointment of competent person on behalf of Scaffolding contractor to survey (to consider risk on) the location where the scaffolding is to be erected before design or erection',
    ),
    InspectionTemplateItem(
      itemNumber: 29,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Establishment of a rescue plan as a part of planning process',
    ),
    InspectionTemplateItem(
      itemNumber: 30,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Ensuring proper communication of responsibilities and authority/resources given to individual performing key activities',
    ),
    InspectionTemplateItem(
      itemNumber: 31,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Ensuring personnel performing the task have the appropriate level of training/certification',
    ),
    InspectionTemplateItem(
      itemNumber: 32,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Ensuring proper maintenance of documentation such as PTW, Inspection records etc., in site',
    ),
    InspectionTemplateItem(
      itemNumber: 33,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Periodic inspection by the Competent Person to determine the scaffolding has been erected as designed and planned as per the established standards and to enable early corrective action to be taken',
    ),
    InspectionTemplateItem(
      itemNumber: 34,
      section: 'Section 7.7 – Scaffolding Safety Management',
      requirement:
          'Ensuring review of the completed work for the next task to be performed effectively',
    ),
    InspectionTemplateItem(
      itemNumber: 35,
      section: 'Section 7.8 – Inspection of Scaffolding Erection Site',
      requirement:
          'Inspection of erection site by Foreman Scaffolder and erection team personnel',
    ),
    InspectionTemplateItem(
      itemNumber: 36,
      section: 'Section 7.8 – Inspection of Scaffolding Erection Site',
      requirement:
          'Ensuring ground conditions are inspected for adequate support',
    ),
    InspectionTemplateItem(
      itemNumber: 37,
      section: 'Section 7.8 – Inspection of Scaffolding Erection Site',
      requirement:
          'Ensuring there is no Overhead obstructions, power cables and analyse protections required',
    ),
    InspectionTemplateItem(
      itemNumber: 38,
      section: 'Section 7.8 – Inspection of Scaffolding Erection Site',
      requirement:
          'Ensuring inspection includes adverse weather conditions and wind conditions into account',
    ),
    InspectionTemplateItem(
      itemNumber: 39,
      section: 'Section 7.8 – Inspection of Scaffolding Erection Site',
      requirement: 'Ensuring scaffoldings are not blocking escape routes',
    ),
    InspectionTemplateItem(
      itemNumber: 40,
      section: 'Section 7.8 – Inspection of Scaffolding Erection Site',
      requirement:
          'Ensuring inspection takes the requirement of fans over walkways to catch debris into account',
    ),
    InspectionTemplateItem(
      itemNumber: 41,
      section: 'Section 7.8 – Inspection of Scaffolding Erection Site',
      requirement:
          'Ensuring inspection takes the requirement of pedestrian and vehicle diversions into account',
    ),
    InspectionTemplateItem(
      itemNumber: 42,
      section: 'Section 7.8 – Inspection of Scaffolding Erection Site',
      requirement:
          'Inclusion of specific concerns or hazards in the Method Statement',
    ),
    InspectionTemplateItem(
      itemNumber: 43,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Load calculation for the design of Scaffolding performed by competent person',
    ),
    InspectionTemplateItem(
      itemNumber: 44,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Availability of approved written erection and dismantling procedure together with the scaffolding drawings and design calculations',
    ),
    InspectionTemplateItem(
      itemNumber: 45,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Ensuring scaffolding components manufactured by different manufacturers are not intermixed/modified, unless the components fit together without force and the structural integrity of scaffolding is maintained by the user',
    ),
    InspectionTemplateItem(
      itemNumber: 46,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Ensuring all scaffoldings are designed in accordance with the applicable BS EN Standards',
    ),
    InspectionTemplateItem(
      itemNumber: 47,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Ensuring the steel tube or fittings are not mixed with Aluminium tube',
    ),
    InspectionTemplateItem(
      itemNumber: 48,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Ensuring fire risk associated with using wooden scaffolding boards are addressed and managed',
    ),
    InspectionTemplateItem(
      itemNumber: 49,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Ensuring the metallic boards are not used where the boards are expected to be in the vicinity of contact with hot lines/surfaces',
    ),
    InspectionTemplateItem(
      itemNumber: 50,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Use of all metallic boards in accordance with manufacturer’s specifications',
    ),
    InspectionTemplateItem(
      itemNumber: 51,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Provision of ladder access for scaffolding platforms more than 600mm',
    ),
    InspectionTemplateItem(
      itemNumber: 52,
      section: 'Section 7.9 – Scaffolding Design',
      requirement:
          'Provision of access ladder turned inside the framing, and alternate sides of landing for scaffold over 8m high',
    ),
    InspectionTemplateItem(
      itemNumber: 53,
      section: 'Section 7.10 – Scaffolding Erection',
      requirement:
          'Ensuring Scaffolding components and equipment are inspected before use by a competent and experienced scaffolding inspector for any defects and damages',
    ),
    InspectionTemplateItem(
      itemNumber: 54,
      section: 'Section 7.10 – Scaffolding Erection',
      requirement:
          'Ensuring unserviceable items are clearly marked and removed from site to prevent their accidental use by others',
    ),
    InspectionTemplateItem(
      itemNumber: 55,
      section: 'Section 7.10 – Scaffolding Erection',
      requirement:
          'Display of valid PTW and Method statement at the location of erection of scaffolding',
    ),
    InspectionTemplateItem(
      itemNumber: 56,
      section: 'Section 7.10 – Scaffolding Erection',
      requirement:
          'Ensuring access to the incomplete scaffoldings are prevented by suitable physical means (e.g., barricades) to prevent access for unauthorized persons',
    ),
    InspectionTemplateItem(
      itemNumber: 57,
      section: 'Section 7.10 – Scaffolding Erection',
      requirement:
          'Ensuring warning signs identifying the areas or sections where access is not permitted are displayed at the access points to those areas',
    ),
    InspectionTemplateItem(
      itemNumber: 58,
      section: 'Section 7.10 – Scaffolding Erection',
      requirement: 'Ensuring personnel are equipped with proper PPEs',
    ),
    InspectionTemplateItem(
      itemNumber: 59,
      section: 'Section 7.10 – Scaffolding Erection',
      requirement:
          'Confirm scaffold is re-inspected after bad weather, modification, or periods of disuse',
    ),
    InspectionTemplateItem(
      itemNumber: 60,
      section: 'Section 7.10 – Scaffolding Erection',
      requirement:
          'Confirm scaffolding register is maintained on site including location, status, inspector, and date',
    ),
    InspectionTemplateItem(
      itemNumber: 61,
      section: 'Section 7.11 – Scaffolding Tagging and Visual Inspection',
      requirement:
          'Implementation of proper tagging mechanism at the prominent location with all the key details as mandated in the Corporate Practice (i.e. Scaffold No, Job Site, Date Erected, Erected by, Date of last inspection, Inspected by)',
    ),
    InspectionTemplateItem(
      itemNumber: 62,
      section: 'Section 7.11 – Scaffolding Tagging and Visual Inspection',
      requirement:
          'Fitting of Scafftag® holder at all access points to the scaffolding for easy visibility',
    ),
    InspectionTemplateItem(
      itemNumber: 63,
      section: 'Section 7.11 – Scaffolding Tagging and Visual Inspection',
      requirement:
          'Ensuring the Scafftag® holder used as soon as the scaffolding is built and remain on the structure until it is dismantled',
    ),
    InspectionTemplateItem(
      itemNumber: 64,
      section: 'Section 7.11 – Scaffolding Tagging and Visual Inspection',
      requirement:
          'Ensuring appropriate tag colours are used according to the requirement',
    ),
    InspectionTemplateItem(
      itemNumber: 65,
      section: 'Section 7.11 – Scaffolding Tagging and Visual Inspection',
      requirement: 'Ensuring the green tag is valid for one week',
    ),
    InspectionTemplateItem(
      itemNumber: 66,
      section: 'Section 7.11 – Scaffolding Tagging and Visual Inspection',
      requirement:
          'Ensuring the empty Scafftag® holder display “DO NOT USE SCAFFOLD” sign in absence of Green or Yellow tag',
    ),
    InspectionTemplateItem(
      itemNumber: 67,
      section: 'Section 7.11 – Scaffolding Tagging and Visual Inspection',
      requirement:
          'Ensuring regular visual inspection by competent person as mandated in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 68,
      section: 'Section 7.11 – Scaffolding Tagging and Visual Inspection',
      requirement:
          'Implementation of scaffolding handover process as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 69,
      section: 'Section 7.11 – Scaffolding Tagging and Visual Inspection',
      requirement:
          'Has a competent person carried out modification/alteration (If required) in an existing scaffolding and design calculations done accordingly to ensure that the new design is still adequate',
    ),
    InspectionTemplateItem(
      itemNumber: 70,
      section: 'Section 7.12 – Shared Scaffolding',
      requirement:
          'Implementation of all the necessary requirement for shared scaffolding as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 71,
      section: 'Section 7.13 –Scaffolding Dismantling',
      requirement:
          'Availability of dismantling plan before dismantling of scaffolding is planned',
    ),
    InspectionTemplateItem(
      itemNumber: 72,
      section: 'Section 7.13 –Scaffolding Dismantling',
      requirement:
          'Ensuring Scaffolding dismantling is carried out by a competent person and supervised for the type of scaffolding',
    ),
    InspectionTemplateItem(
      itemNumber: 73,
      section: 'Section 7.13 –Scaffolding Dismantling',
      requirement:
          'Ensuring clear and prominent warning signs are in place and access to the danger zone is prevented;',
    ),
    InspectionTemplateItem(
      itemNumber: 74,
      section: 'Section 7.14 - Training and Competency',
      requirement:
          'Trained and Competent Personnel used for the scaffolding activity',
    ),
    InspectionTemplateItem(
      itemNumber: 75,
      section: 'Section 7.14 - Training and Competency',
      requirement:
          'Ensuring the personnel in scaffolding have received basic awareness training and instruction in the safe use of the scaffolding',
    ),
    InspectionTemplateItem(
      itemNumber: 76,
      section: 'Section 7.14 - Training and Competency',
      requirement:
          'Ensuring the site supervisors are certified from an accredited 3rd party such as Construction Industry Training Board (CITB)/Construction Industry Scaffolders Record Scheme (CISRS) or equivalent and record of evidence of the same are kept',
    ),
  ],
);
