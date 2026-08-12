import '../models/inspection_template.dart';

const jsaTemplate = InspectionTemplate(
  id: 'jsa',
  title: 'Job Safety Analysis (JSA) Compliance Checklist',
  client: 'ADNOC',
  category: 'Job Safety Analysis',
  description:
      'HSE-PSW-CP03 Job Safety Analysis (JSA) Corporate Practice Compliance Checklist',
  responseType: InspectionResponseType.yesNoNa,
  items: [
    InspectionTemplateItem(
      itemNumber: 1,
      section: 'Section 1 – Administration',
      requirement:
          'The “Work Categorization Chart” is readily available to assist in determining permit type and level of JSA required.',
    ),
    InspectionTemplateItem(
      itemNumber: 2,
      section: 'Section 1 – Administration',
      requirement:
          'JSA is conducted identifying possible hazards and precautions necessary to reduce the level of risk to ALARP.',
    ),
    InspectionTemplateItem(
      itemNumber: 3,
      section: 'Section 1 – Administration',
      requirement:
          'SHCF is fully completed, signed and attached to the Permit.',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'Section 1 – Administration',
      requirement:
          'PA shall identify all the hazards and controls on the SHCF.',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Section 1 – Administration',
      requirement:
          'The “Implemented” signature is available on all required controls before PI signs the Permit.',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Section 1 – Administration',
      requirement:
          'The SHCF and HMF is fully completed, signed and attached to the Critical/ Hot Work Permits.',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Section 1 – Administration',
      requirement:
          'The major work steps listed on the HMF with applicable hazards and required controls applicable to each work step.',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Section 1 – Administration',
      requirement:
          'When using a formal risk assessment, all hazards and threats identified. And the risks of identified hazards assessed for Worst-Case Scenarios using the ADNOC RAM.',
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Section 1 – Administration',
      requirement:
          'All Critical and Hot Work permits approved by Asset Approval Authority (AAA) on the Permit to Work.',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Section 1 – Administration',
      requirement:
          'All General permits approved by Area Authority (AA) with a signature on the Permit to Work.',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Section 1 – Administration',
      requirement:
          'Asset Owner Rep approves new or enhanced/ changed JSA/ Formal Risk Assessments.',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Section 1 – Administration',
      requirement: 'JSA selected and referenced on the associated Permit.',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Section 1 – Administration',
      requirement: 'JSA Review Cycle is maintained',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Section 1 – Administration',
      requirement:
          'Formal Risk Assessment Team Composition is adequate as per CP03',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Section 1 – Administration',
      requirement:
          'Use of Hierarchy of Controls demonstrated when selecting controls',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Section 1 – Administration',
      requirement:
          'The electronic Work Management System (eWMS) is utilized for registration, referencing, and tracking of JSAs in accordance with CP requirements.',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Section 1 – Administration',
      requirement:
          'Personnel responsible for preparing, reviewing, and utilizing JSAs in the eWMS have received adequate training and competency verification specific to the eWMS platform.',
    ),
  ],
);
