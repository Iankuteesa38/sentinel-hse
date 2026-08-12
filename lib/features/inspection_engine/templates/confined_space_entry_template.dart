import '../models/inspection_template.dart';

const confinedSpaceEntryTemplate = InspectionTemplate(
  id: 'confined_space_entry',
  title: 'Confined Space Entry (CSE) Compliance Checklist',
  client: 'ADNOC',
  category: 'Confined Space Entry',
  description:
      'HSE-PSW-CP08 Confined Space Entry (CSE) Corporate Practice Compliance Checklist',
  responseType: InspectionResponseType.yesNoNa,
  items: [
    InspectionTemplateItem(
      itemNumber: 1,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Confined Space Entry Certificate',
    ),
    InspectionTemplateItem(
      itemNumber: 2,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Permit to Work',
    ),
    InspectionTemplateItem(
      itemNumber: 3,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Job Safety Analysis',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Entry/Exit Register',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Section 7.1 - Overview',
      requirement: 'Implementation of criteria defining Confined Space',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Section 7.1 - Overview',
      requirement:
          'Ability to determine whether an area is a Confined Space (based on criteria and examples provided in the Corporate Practice)',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Section 7.3 - Confined Space Entry Process',
      requirement:
          'Implementation of Confined Space Entry Process as per the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Section 7.4 - Risk Management Process',
      requirement:
          'Identification of direct and indirect hazards within Confined Space',
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Section 7.4 - Risk Management Process',
      requirement:
          'Risk Assessment for the Confined Space has been performed by Competent Person',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Section 7.4 - Risk Management Process',
      requirement:
          'The electronic Work Management System (eWMS) is utilized for registration, approval, and tracking of Confined Space Entry activities and certificates in accordance with CP requirements.',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Section 7.4 - Risk Management Process',
      requirement:
          'Implementation of systematic approach for Hierarchy of Controls as per the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Implementation of ADNOC Permit to Work and Job Safety Analysis Corporate Practice before Confined Space Entry',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Checking of all the listed conditions prior to making a decision to allow Confined Space Entry (i.e. Continuous Gas Monitoring, Ventilation, Illumination, Rescue Plan etc.)',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Implementation of criteria and permitted limits for Confined Space Entry with and without Breathing Apparatus as per the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Implementation of the time limit and number of individuals allowed to work in Confined Space',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Implementation of adequate ventilation (natural or mechanical) in the Confined Space by the Competent Person',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Verification of air changes per hour (ACPH) achieved during ventilation',
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Sources of static electricity excluded if there is a risk to flammable or explosive atmosphere into the Confined Space',
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Portable tools and lighting used in the Confined Space as per the Corporate practice (i.e. Zone Certification, Voltage etc.)',
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: 'Section 7.5 - Control Measures',
      requirement: 'Adequate illumination inside the Confined Space (200 lux)',
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: 'Section 7.5 - Control Measures',
      requirement: 'Unobstructed Access and Egress for the Confined Space',
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Verification of entry opening dimensions ≥575mm x 575mm for safe entry/exit',
    ),
    InspectionTemplateItem(
      itemNumber: 23,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Checking of potential presence for Pyrophoric substances and NORMS in Vessels/equipment where CSE is planned',
    ),
    InspectionTemplateItem(
      itemNumber: 24,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Implementation of Working at Height controls inside Confined Spaces as per the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 25,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Assessing and controlling the high risk associated in Inert Gas Confined Space Entry',
    ),
    InspectionTemplateItem(
      itemNumber: 26,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Use of SCBA and PPE when performing work in inert gas atmosphere',
    ),
    InspectionTemplateItem(
      itemNumber: 27,
      section: 'Section 7.5 - Control Measures',
      requirement:
          'Implementation of positive isolation prior to Confined Space Entry',
    ),
    InspectionTemplateItem(
      itemNumber: 28,
      section: 'Section 7.6 - Atmospheric Testing for Confined Spaces',
      requirement:
          'Performing the atmospheric testing by an approved, trained and certified Authorized Gas Tester (AGT)',
    ),
    InspectionTemplateItem(
      itemNumber: 29,
      section: 'Section 7.6 - Atmospheric Testing for Confined Spaces',
      requirement:
          'Implementation of pre entry testing procedure before Confined Space Entry by the AGT',
    ),
    InspectionTemplateItem(
      itemNumber: 30,
      section: 'Section 7.6 - Atmospheric Testing for Confined Spaces',
      requirement:
          'Implementation and documentation for the sequence of atmospheric testing by the AGT',
    ),
    InspectionTemplateItem(
      itemNumber: 31,
      section: 'Section 7.6 - Atmospheric Testing for Confined Spaces',
      requirement:
          'Implementation of gas testing at different depths by the AGT',
    ),
    InspectionTemplateItem(
      itemNumber: 32,
      section: 'Section 7.6 - Atmospheric Testing for Confined Spaces',
      requirement:
          'Continuous atmospheric monitoring within the Confined Space',
    ),
    InspectionTemplateItem(
      itemNumber: 33,
      section: 'Section 7.7 - Purging',
      requirement:
          'Implementation of the purging process as per the Corporate Practice in case of the presence of hazardous contaminants',
    ),
    InspectionTemplateItem(
      itemNumber: 34,
      section:
          'Section 7.8 - Use of Direct Reading Portable Gas Monitors (DRPGM)',
      requirement:
          'Conducting the bump test for DRPGM before each day of use of the gas monitors',
    ),
    InspectionTemplateItem(
      itemNumber: 35,
      section:
          'Section 7.8 - Use of Direct Reading Portable Gas Monitors (DRPGM)',
      requirement:
          'Checking the calibration status for DRPGM before every use of the gas monitors',
    ),
    InspectionTemplateItem(
      itemNumber: 36,
      section: 'Section 7.9 - PPE and RPE',
      requirement: 'Implementation for the use of all necessary PPE and RPE',
    ),
    InspectionTemplateItem(
      itemNumber: 37,
      section: 'Section 7.10 - Preparation and Issuing of Permit to Work',
      requirement:
          'Prepare and Issue the Permit to Work prior to Confined Space activity',
    ),
    InspectionTemplateItem(
      itemNumber: 38,
      section: 'Section 7.10 - Preparation and Issuing of Permit to Work',
      requirement:
          'Implementation of all the procedures as per the issued Permit to Work',
    ),
    InspectionTemplateItem(
      itemNumber: 39,
      section: 'Section 7.10 - Preparation and Issuing of Permit to Work',
      requirement:
          'Presence of CSE Observer at all times outside the Confined Space during the activity being performed',
    ),
    InspectionTemplateItem(
      itemNumber: 40,
      section: 'Section 7.10 - Preparation and Issuing of Permit to Work',
      requirement:
          'Constant communication with Confined Space Authorized Entrants by the CSE Observer',
    ),
    InspectionTemplateItem(
      itemNumber: 41,
      section: 'Section 7.10 - Preparation and Issuing of Permit to Work',
      requirement:
          'Check for signage and barricading of Confined Spaces during work',
    ),
    InspectionTemplateItem(
      itemNumber: 42,
      section: 'Section 7.10 - Preparation and Issuing of Permit to Work',
      requirement:
          'Regular monitoring the activity by the Permit Issuer and conditions/controls required as mentioned in the Permit to Work',
    ),
    InspectionTemplateItem(
      itemNumber: 43,
      section: 'Section 7.11 - Emergency and Rescue Requirements',
      requirement:
          'Implementation of all necessary emergency response arrangements',
    ),
    InspectionTemplateItem(
      itemNumber: 44,
      section: 'Section 7.11 - Emergency and Rescue Requirements',
      requirement:
          'Decision for the presence of the Rescue Team during the Confined Space activity based on the risk assessment',
    ),
    InspectionTemplateItem(
      itemNumber: 45,
      section: 'Section 7.11 - Emergency and Rescue Requirements',
      requirement:
          'Implementation of proper Rescue Plan for the Confined Space',
    ),
    InspectionTemplateItem(
      itemNumber: 46,
      section: 'Section 7.12 - Training and Competence',
      requirement:
          'Trained and Competent Person used for the Confined Space activity',
    ),
    InspectionTemplateItem(
      itemNumber: 47,
      section: 'Section 7.12 - Training and Competence',
      requirement:
          'Personnel utilizing the eWMS for Confined Space Entry activities have received adequate training and competency verification specific to the eWMS platform.',
    ),
  ],
);
