import '../models/inspection_template.dart';

const liftingHoistingTemplate = InspectionTemplate(
  id: 'lifting_hoisting',
  title: 'Lifting and Hoisting Operations Compliance Checklist',
  client: 'ADNOC',
  category: 'Lifting & Hoisting',
  description:
      'HSE-PSW-CP19 Lifting and Hoisting Operations Corporate Practice Compliance Checklist',
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
      requirement: 'Method Statement',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Completion of Pre-requisite check list',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Medical Fitness Certificate',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Operation Manual for Lifting equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Load Chart',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Wire Ropes Certificates',
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Mandatory Certification/Documentation',
      requirement:
          'Certified Transportation frames (Bundled Tubular lifting – Special Lifting Operation)',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring consideration is given to the type of equipment that is required to carry out lifting operation safely',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring an appointed person has been consulted during the selection process and the decision on the type of crane that shall be used based on Weight of load, frequency and duration of the work; the working environment; mobility of the crane and Lifting radius',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring Safe Working Load (SWL) is clearly marking on lifting accessory',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring Safe Working Load (SWL) rated capacity indicator with audible alarm is present in lifting appliances which have capacity of 1 tonne or more as applicable',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring an Anemometer is present at maximum height in lifting area and daily check is made',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring hand held anemometers are present as secondary means in lifting location',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring documentation of agreed means of communication in the lifting plan and is followed by all those who are involved in lifting operations',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring banksman is present and his hand signals (Refer to Appendix 1) are in visible range to lifting equipment operator in absence of radio communication',
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring radio communication is established in tower cranes with more than 35 meters height between Operator and banksman',
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring planning of all laydown, storage and lifting areas with no blind zones which will eventually minimize the need for blind lifts',
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Ensuring availability of at least two persons (Banksman and Rigger) having visual contact with the load and each other and having radio contact with the lifting appliance operator',
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'Valid Medical Fitness Certificate for crane operators and riggers',
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: 'Section 7.1 – General Requirements',
      requirement:
          'OEM operation and maintenance manuals available for lifting equipment and accessories',
    ),
    InspectionTemplateItem(
      itemNumber: 23,
      section: 'Section 7.2.1 – General',
      requirement:
          'Ensuring that the asset owner identifies or be informed of the need for a lifting and hoisting operation',
    ),
    InspectionTemplateItem(
      itemNumber: 24,
      section: 'Section 7.2.1 – General',
      requirement:
          'The electronic Work Management System (eWMS) is utilized for registration, approval, and tracking of lifting and hoisting operations in accordance with CP requirements.',
    ),
    InspectionTemplateItem(
      itemNumber: 25,
      section: 'Section 7.2.1 – General',
      requirement:
          'Personnel utilizing the eWMS for lifting and hoisting operations have received adequate training and competency verification specific to the eWMS platform.',
    ),
    InspectionTemplateItem(
      itemNumber: 26,
      section: 'Section 7.2.1 – General',
      requirement:
          'Ensuring asset owner has Appointed Person (AP) to Plan, supervise the lifting and hoisting operation',
    ),
    InspectionTemplateItem(
      itemNumber: 27,
      section: 'Section 7.2.1 – General',
      requirement:
          'Ensuring every lifting and hoisting operation is risk assessed and suitable measures are put in place by the AP before the work begins as a part of “Lifting Plan”',
    ),
    InspectionTemplateItem(
      itemNumber: 28,
      section: 'Section 7.2.1 – General',
      requirement:
          'Ensuring reassessment of hazards is done if Changes to personnel, site layout or work environment should take place',
    ),
    InspectionTemplateItem(
      itemNumber: 29,
      section: 'Section 7.2.2 – Lifting Operation Process',
      requirement:
          'Ensuring a Lifting Plan and Pre-Lift/Pre-use Checklist is completed and approved prior to all lifts to assure that lifting operations are executed safely by competent personnel',
    ),
    InspectionTemplateItem(
      itemNumber: 30,
      section: 'Section 7.2.3 – Categorizing the Lifting Operation',
      requirement:
          'Ensuring categorization of lifting operations is done as per the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 31,
      section: 'Section 7.2.4 – Method Statement',
      requirement:
          'Ensuring a method statement is prepared, detailing the planning of the Lifting Operation including the risk assessment and given to all involved in the operation',
    ),
    InspectionTemplateItem(
      itemNumber: 32,
      section: 'Section 7.2.4 – Method Statement',
      requirement:
          'Ensuring preparation of method statement for overload testing of fixed and mobile appliances as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 33,
      section: 'Section 7.2.4 – Method Statement',
      requirement:
          'Ensuring that the lifting operations always under the control of Appointed Person and has been given authority to stop the work in case of unsatisfactory conditions',
    ),
    InspectionTemplateItem(
      itemNumber: 34,
      section: 'Section 7.2.4 – Method Statement',
      requirement:
          'Ensuring that the method statement includes each and everyone’s roles and responsibility',
    ),
    InspectionTemplateItem(
      itemNumber: 35,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Ensuring that the onshore crane lifting operations are stopped if the wind speed exceeds 20 knots (10 m/sec.) while material lifting and 15 knots (7 m/sec.) while Personnel Lifting to be measured with a calibrated hand held anemometer at a similar level to that to which the carrier will be lifted or as per the Crane Manufacturer’s Wind Speed Limit whichever is the lesser unless specially authorised for special operation under official Risk assessment and categorisation under Complex lift without exceeding OEM limits',
    ),
    InspectionTemplateItem(
      itemNumber: 36,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Ensuring that the offshore crane lifting operations are stopped if the wind speed exceeds 25 knots (12 m/sec.) / Significant Wave Height (SWH) is 5ft. (1.5m) while material lifting and 20 knots (10 m/sec.)/ Significant Wave Height (SWH) is 2m while Personnel Lifting whichever is lesser unless specially authorised for special operation under official Risk assessment and categorisation under Complex lift without exceeding OEM limits',
    ),
    InspectionTemplateItem(
      itemNumber: 37,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Ensuring that the lifting operations are not carried out in case of Severe rainfall and thunderstorm',
    ),
    InspectionTemplateItem(
      itemNumber: 38,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Ensuring that lifting operation is carried out during daylight hours or with provision of adequate lightings and searchlights (Minimum 100 lux as per IES Standard)',
    ),
    InspectionTemplateItem(
      itemNumber: 39,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Ensuring that possible failure conditions are considered when setting up a crane on engineered surfaces such as concrete paving, concrete ground floor slabs or suspended slab.',
    ),
    InspectionTemplateItem(
      itemNumber: 40,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Have the competent personnel and stakeholders been contacted to ensure that there are no potential problems at the location where the crane will be working',
    ),
    InspectionTemplateItem(
      itemNumber: 41,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Ensuring verification of the crane\'s working radius by measurement is checked against the approved lifting plan and recorded at site, before a non-routine lifting commences',
    ),
    InspectionTemplateItem(
      itemNumber: 42,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Are the principles of Human Performance (HP) consistently followed and communicated by leadership, creating conditions that enable people to work safely, learn from mistakes, and prevent incidents by focusing on both human behaviour and the systems in which they operate?',
    ),
    InspectionTemplateItem(
      itemNumber: 43,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Do leaders promote learning over blame and encourage open reporting?',
    ),
    InspectionTemplateItem(
      itemNumber: 44,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Are error-likely situations identified, and are corrective actions focused on systems?',
    ),
    InspectionTemplateItem(
      itemNumber: 45,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Are confidential reporting channels active, with associated investigations considering context/system factors?',
    ),
    InspectionTemplateItem(
      itemNumber: 46,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Is HP included in inductions, refreshers, and leadership training, with competence verified?',
    ),
    InspectionTemplateItem(
      itemNumber: 47,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement:
          'Are lessons from successes/failures shared, and are improvements (e.g., shift planning, design changes) implemented?',
    ),
    InspectionTemplateItem(
      itemNumber: 48,
      section: 'Section 7.2.5 – Risk Assessment',
      requirement: 'Do employees feel safe to speak up, and raise complains?',
    ),
    InspectionTemplateItem(
      itemNumber: 49,
      section: 'Section 7.2.6 – Preparing a Lifting Plan',
      requirement:
          'Ensuring that in Non-Routine Complicated & Complex Lift, Crane Position in Plan & Elevation and Rigging Plan before and after Lift and clearly marked to scale in drawing as identified in Risk Assessment',
    ),
    InspectionTemplateItem(
      itemNumber: 50,
      section: 'Section 7.2.6 – Preparing a Lifting Plan',
      requirement:
          'Ensuring that all load information: Net weight, Gross Weight, Load integrity, Centre of Gravity, Stability, the Lift suspension points, Dimensions of Load, Height of Lift and Maximum Radius are aware by personnel before working',
    ),
    InspectionTemplateItem(
      itemNumber: 51,
      section: 'Section 7.2.7 – Authorize the Lifting Plan',
      requirement:
          'Ensuring all types of lifting plans are reviewed and approved by a competent person – Single Point Authority (SPA) and lifting operations are performed by following the lifting plan authorization by SPA and endorsed by Asset Owner',
    ),
    InspectionTemplateItem(
      itemNumber: 52,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensuring that Prior to starting any Routine or Non-Routine Lift, a pre-job safety meeting/ tool box talk is conducted to assess the Lifting Plan and to familiarize personnel with the risks identified',
    ),
    InspectionTemplateItem(
      itemNumber: 53,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensuring that prior to all Lifts (Routine Lifts and Non-Routine Lifts) the Appointed Person has verified that the answers to the ‘Ten questions for a safe lift’ are all addressed',
    ),
    InspectionTemplateItem(
      itemNumber: 54,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensuring that the routine and Non-Routine Simple lifting operations are undertaken by a minimum of at least three competent people: Crane Operator, Banksman/Flagman and Rigger/Slinger',
    ),
    InspectionTemplateItem(
      itemNumber: 55,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensuring that the complicated and Complex lifting operations are undertaken by a minimum of at least four competent people: Appointed Person, Crane Operator, Banksman/ Flagman and Rigger/ Slinger',
    ),
    InspectionTemplateItem(
      itemNumber: 56,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensuring that the equipment is being used for its intended purpose within design limits',
    ),
    InspectionTemplateItem(
      itemNumber: 57,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensuring that the equipment has the relevant current colour code and certification',
    ),
    InspectionTemplateItem(
      itemNumber: 58,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensuring that the pre-use inspection is performed on the equipment as per the check lists in Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 59,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensuring that the whenever a lift deviates from the plan or any complication arises, the lifting operation is stopped and made safe immediately',
    ),
    InspectionTemplateItem(
      itemNumber: 60,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensure that Tool box talk is held to make sure that all personnel involved in the lifting operation fully understand the Lifting Plan. Prior to all lifts (Routine Lifts and Non-Routine Lifts)',
    ),
    InspectionTemplateItem(
      itemNumber: 61,
      section: 'Section 7.3 – Execute The Lifting And Hoisting Operation',
      requirement:
          'Ensure that Appointed Person has verified the crew for the answers to “Ten Question of Safe Lift” in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 62,
      section:
          'Section 7.4.1 – Non-Standard Stationary Equipment Lifting Points in the Plant',
      requirement:
          'Ensuring that the structural Engineer has reviewed the drawings to confirm the suitability of the lifting points and any modifications if required',
    ),
    InspectionTemplateItem(
      itemNumber: 63,
      section:
          'Section 7.4.1 – Non-Standard Stationary Equipment Lifting Points in the Plant',
      requirement:
          'Ensuring that the Site Structural Inspector has physically checked the Lifting Points and confirmed the current condition is acceptable',
    ),
    InspectionTemplateItem(
      itemNumber: 64,
      section:
          'Section 7.4.1 – Non-Standard Stationary Equipment Lifting Points in the Plant',
      requirement:
          'Ensuring that the Non-Destructive Testing (NDT) is carried out in all Lifting points',
    ),
    InspectionTemplateItem(
      itemNumber: 65,
      section:
          'Section 7.4.1 – Non-Standard Stationary Equipment Lifting Points in the Plant',
      requirement:
          'Ensuring that the ADNOC Group approved Third Party using approved Lifting Equipment Inspector reviewed NDT reports and related drawings before proceeding with thorough examination and corresponding details are clearly mentioned in the certificate',
    ),
    InspectionTemplateItem(
      itemNumber: 66,
      section:
          'Section 7.4.2 – Crawler Crane Set-up Onboard of Floating Vessel/Barge',
      requirement:
          'Ensuring that the Crawler Cranes are not allowed to work on-board Barges/Vessels unless fitted on Construction or Pipe Lay Barges subject to a Risk Assessment by all Stakeholders',
    ),
    InspectionTemplateItem(
      itemNumber: 67,
      section:
          'Section 7.4.2 – Crawler Crane Set-up Onboard of Floating Vessel/Barge',
      requirement:
          'Ensuring Mobile Cranes (with outriggers) are never used on floating barges / cargo barges / vessels',
    ),
    InspectionTemplateItem(
      itemNumber: 68,
      section:
          'Section 7.4.2 – Crawler Crane Set-up Onboard of Floating Vessel/Barge',
      requirement:
          'Ensuring Crane’s Manufacture approval for such lifting operations',
    ),
    InspectionTemplateItem(
      itemNumber: 69,
      section:
          'Section 7.4.2 – Crawler Crane Set-up Onboard of Floating Vessel/Barge',
      requirement:
          'Ensuring Pick and Carry is prohibited on-board Floating vessel unless approved by the Crane Manufacture and Vessel/Barge Classification society',
    ),
    InspectionTemplateItem(
      itemNumber: 70,
      section: 'Section 7.4.3 – Dynamic Lifting Operations',
      requirement:
          'Competent ADNOC Group approved crane operator ensures correct selection and setting of the appropriate Sea State on the Rated Capacity Indicator (RCI) to alleviate Dynamic Loading effect (DLE)',
    ),
    InspectionTemplateItem(
      itemNumber: 71,
      section: 'Section 7.4.4 – Loading/Unloading of Supply Vessels',
      requirement:
          'Ensuring that the Vessel Master liaise with the Logistics Service Provider to ensure that the vessel is loaded correctly and in accordance with ADNOC specific requirements for the safe and correct loading of his vessel',
    ),
    InspectionTemplateItem(
      itemNumber: 72,
      section: 'Section 7.4.4 – Loading/Unloading of Supply Vessels',
      requirement:
          'Ensuring vessel deck crew makes a final visual check to ensure the lift is safe prior to the hook being attached to the load for discharge offshore',
    ),
    InspectionTemplateItem(
      itemNumber: 73,
      section: 'Section 7.4.4 – Loading/Unloading of Supply Vessels',
      requirement:
          'Ensuring a practice of Logistics Service Provider or materials coordinator providing the vessel with a copy of the loading list complete with all relevant Dangerous Goods information for each installation to be visited and an accurate manifest',
    ),
    InspectionTemplateItem(
      itemNumber: 74,
      section: 'Section 7.4.4 – Loading/Unloading of Supply Vessels',
      requirement:
          'Ensuring documents are received in sufficient time to permit proper stowage of the cargo for the route envisaged',
    ),
    InspectionTemplateItem(
      itemNumber: 75,
      section: 'Section 7.4.5 - Tubulars',
      requirement:
          'Ensuring Individual and Bundled tubular lift are always slung with two slings, each of them same length and of the same SWL',
    ),
    InspectionTemplateItem(
      itemNumber: 76,
      section: 'Section 7.4.5 - Tubulars',
      requirement:
          'Ensuring the SWL of each sling is equal to or greater than the Gross Weight of the load',
    ),
    InspectionTemplateItem(
      itemNumber: 77,
      section: 'Section 7.4.5 - Tubulars',
      requirement:
          'Ensuring Slings are placed at equal distance (approximately 25%) from the ends of the load with the internal angle at the hook not greater than 90 and double wrapped and choked around the tubular',
    ),
    InspectionTemplateItem(
      itemNumber: 78,
      section: 'Section 7.4.5 - Tubulars',
      requirement:
          'Ensuring excessive long tubular lifts have a tag line attached and subjected to a risk assessment',
    ),
    InspectionTemplateItem(
      itemNumber: 79,
      section: 'Section 7.4.5 - Tubulars',
      requirement:
          'Ensuring all tubulars are correctly orientated on the trailers and when loading on vessels',
    ),
    InspectionTemplateItem(
      itemNumber: 80,
      section: 'Section 7.4.5 - Tubulars',
      requirement:
          'Ensuring bedding rope is placed at appropriate positions on the vessels intended loading area at equal distance approximately 25% from the ends of the intended stow prior to loading individual tubular cargo',
    ),
    InspectionTemplateItem(
      itemNumber: 81,
      section: 'Section 7.4.5 - Tubulars',
      requirement:
          'Ensuring only tubulars of the same diameter are stowed together and have similar length while vessel loading',
    ),
    InspectionTemplateItem(
      itemNumber: 82,
      section: 'Section 7.4.6 – Portable Gas Equipment/Tanks/Cylinders/Racks',
      requirement:
          'Ensuring suitable cylinder types are used and portable gas equipment is checked prior to shipment for equipment integrity',
    ),
    InspectionTemplateItem(
      itemNumber: 83,
      section: 'Section 7.4.6 – Portable Gas Equipment/Tanks/Cylinders/Racks',
      requirement:
          'Ensuring specific requirements are met for Gas Quads/Packs/Multiple Element Gas Containers (MEGCs) and Lift Frames',
    ),
    InspectionTemplateItem(
      itemNumber: 84,
      section: 'Section 7.4.7 – Special Cargo',
      requirement:
          'Ensuring, while planning the shipment of special cargo, logistics personnel are involved at the earliest opportunity',
    ),
    InspectionTemplateItem(
      itemNumber: 85,
      section: 'Section 7.4.7 – Special Cargo',
      requirement:
          'Ensuring all parties, including vessel Master are involved in assessment of lifting dynamics',
    ),
    InspectionTemplateItem(
      itemNumber: 86,
      section: 'Section 7.4.7 – Special Cargo',
      requirement:
          'Ensuring fragile nature and the high value items are transported in a specially designed lifting frame/ module and labelled for identification',
    ),
    InspectionTemplateItem(
      itemNumber: 87,
      section: 'Section 7.4.8 – Tote Tanks',
      requirement:
          'Ensuring precautions are taken while lifting tanks with liquids that may cause load instability due to free surface effect on centre of gravity',
    ),
    InspectionTemplateItem(
      itemNumber: 88,
      section: 'Section 7.4.8 – Tote Tanks',
      requirement:
          'Ensuring Liquid Chemicals Tote Tanks estimated with 1 t Safe Working Load (SWL) are lifted by Pallet Forks with minimum 2 t WLL (2 times SWL)',
    ),
    InspectionTemplateItem(
      itemNumber: 89,
      section: 'Section 7.4.9 – Lifting by Wooden Crates',
      requirement:
          'Ensure crates are compliant with BS 1133/BS EN ISO 780, used once only, and labelled.',
    ),
    InspectionTemplateItem(
      itemNumber: 90,
      section: 'Section 7.4.10 – Handling, Transportation and Lifting of FIBC',
      requirement:
          'Ensuring documents related to each shipment of FIBC are verified before any lift and confirmed that FIBCs are marked with a unique identification number, batch number, SWL, and have a valid certificate from the manufacturer',
    ),
    InspectionTemplateItem(
      itemNumber: 91,
      section: 'Section 7.4.10 – Handling, Transportation and Lifting of FIBC',
      requirement:
          'Ensuring that all FIBC stored more than 6 months are verified by the Competent Person and used only if shelf life is more than 6 months',
    ),
    InspectionTemplateItem(
      itemNumber: 92,
      section: 'Section 7.4.10 – Handling, Transportation and Lifting of FIBC',
      requirement:
          'Ensuring Inspection of the crane hooks, bars or forklift arms are done before lifting to ensure that they have rounded edges with a radius greater than the diameter or thickness of the suspension of the FIBCs and/or protected by wrapping (the radius shall be minimum of 5 mm)',
    ),
    InspectionTemplateItem(
      itemNumber: 93,
      section: 'Section 7.4.10 – Handling, Transportation and Lifting of FIBC',
      requirement:
          'Ensuring FIBCs are lifted as per the manufacturer’s instructions; ADNOC procedure and International Standards by using all lift loops, sleeves individually subject to Task Risk Assessment to ensure that the integrity of the FIBC is maintained',
    ),
    InspectionTemplateItem(
      itemNumber: 94,
      section: 'Section 7.4.10 – Handling, Transportation and Lifting of FIBC',
      requirement:
          'Ensuring forklift truck is used with rated capacity sufficient to move the FIBCs from one location to another',
    ),
    InspectionTemplateItem(
      itemNumber: 95,
      section: 'Section 7.4.10 – Handling, Transportation and Lifting of FIBC',
      requirement:
          'Ensuring FIBCs are properly stacked in upright position (Maximum two rows in height) and stable in nature',
    ),
    InspectionTemplateItem(
      itemNumber: 96,
      section: 'Section 7.4.10 – Handling, Transportation and Lifting of FIBC',
      requirement:
          'Ensuring the FIBCs are stored in a safe, clean facility or warehouse which will protect them from UV rays of sunlight, moisture and inclement weather',
    ),
    InspectionTemplateItem(
      itemNumber: 97,
      section: 'Section 7.4.10 – Handling, Transportation and Lifting of FIBC',
      requirement:
          'Ensuring any device used to handle FIBCs is designed for FIBCs and adhere to approved handling methods and appropriate for discharge',
    ),
    InspectionTemplateItem(
      itemNumber: 98,
      section: 'Section 7.4.11 – Lifting Load by Scaffolding Lifting Frame',
      requirement:
          'Ensuring Hoists, winches and other lifting appliances are mounted on scaffolding only if the scaffold framework’s effective static load is not less than two times the safe working load of the lifting appliance and tied back to reduce vibration and whip',
    ),
    InspectionTemplateItem(
      itemNumber: 99,
      section: 'Section 7.4.11 – Lifting Load by Scaffolding Lifting Frame',
      requirement:
          'Ensuring Lifting frame capacity 2000 kg and below imposed load on scaffolding structure is inspected by scaffolding inspector and load tested by scaffolding supervisor, before performing the load test (load test procedure is identified prior)',
    ),
    InspectionTemplateItem(
      itemNumber: 100,
      section: 'Section 7.4.11 – Lifting Load by Scaffolding Lifting Frame',
      requirement:
          'Ensuring Lifting frame capacity above 2000 kg and below 4000 kg imposed load on scaffolding structure is inspected by scaffolding inspector, load tested by scaffolding supervisor, before performing the load test (load test procedure is identified prior), TPIA Representative and issuance of inspection certificate',
    ),
    InspectionTemplateItem(
      itemNumber: 101,
      section: 'Section 7.4.11 – Lifting Load by Scaffolding Lifting Frame',
      requirement:
          'Ensuring Lifting frame capacity above 4000 kg: is designed and approved by Structural Engineer',
    ),
    InspectionTemplateItem(
      itemNumber: 102,
      section:
          'Section 7.4.12 – Skidding Operations Using Skates & Ground Trolleys',
      requirement:
          'Ensuring Company Structural Engineer is consulted and/or Structural Inspector verifies the suitability of the deck/ground, suitability of existing structure for operations using Skates and Ground trolleys',
    ),
    InspectionTemplateItem(
      itemNumber: 103,
      section:
          'Section 7.4.12 – Skidding Operations Using Skates & Ground Trolleys',
      requirement:
          'Ensuring all pulling equipment including accessories are inspected and certified by an ADNOC Group approved Lifting Equipment Inspector working in approved TPIA in UAE',
    ),
    InspectionTemplateItem(
      itemNumber: 104,
      section:
          'Section 7.4.12 – Skidding Operations Using Skates & Ground Trolleys',
      requirement:
          'Ensuring that the skates and ground trolleys are marked with a unique identification number/ Asset Number; SWL, colour code and have valid certificate of inspection from an ADNOC approved Third Party Company using approved Lifting Equipment Inspector',
    ),
    InspectionTemplateItem(
      itemNumber: 105,
      section: 'Section 7.4.13 – Helicopter Lifting',
      requirement:
          'Ensure CAP 426 guidelines followed, full risk assessment conducted, and briefing done.',
    ),
    InspectionTemplateItem(
      itemNumber: 106,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring detailed Lifting Operation Plan is created, reviewed and approved by designated site authorities on every occurrence and prior to the personnel lifting operation proceeding',
    ),
    InspectionTemplateItem(
      itemNumber: 107,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring all personnel involved in the Lifting personnel operation, are fully aware of Emergency Procedures and Rescue Plan which will form an integral part of the JSA',
    ),
    InspectionTemplateItem(
      itemNumber: 108,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring that personnel lift is conducted only where there is line of sight (full visibility) between the equipment operator and signaller (Banks man), and between the signaller (Banks man) and the person being lifted',
    ),
    InspectionTemplateItem(
      itemNumber: 109,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring personnel transferred by lifting are not permitted in hours of darkness unless specifically approved by the Asset Owner and supported by risk assessment and assessment of alternatives',
    ),
    InspectionTemplateItem(
      itemNumber: 110,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring establishment of communication between those being lifted and those performing the lift. Establish radio communication and maintain it between the person (s) being lifted, the lifting appliance operator and signaller',
    ),
    InspectionTemplateItem(
      itemNumber: 111,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring that in the case of blind lifts, the lifting appliance operator has eye contact with the signaller, who in turn have eye contact with the personnel being lifted',
    ),
    InspectionTemplateItem(
      itemNumber: 112,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring necessary PPEs are worn e.g., during operations involving the lifting of personnel over the sea, a life vest or survival suit shall be worn',
    ),
    InspectionTemplateItem(
      itemNumber: 113,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring the lifting appliance’s maximum allowable SWL is at least twice the weight of the Personnel Carrier with its maximum load',
    ),
    InspectionTemplateItem(
      itemNumber: 114,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring the lifting accessories used for personnel lifting has a minimum factor of safety 10:1',
    ),
    InspectionTemplateItem(
      itemNumber: 115,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensuring Man Over Board (MOB) is on standby in accordance with requirements that apply for work over sea',
    ),
    InspectionTemplateItem(
      itemNumber: 116,
      section: 'Section 7.5 – Lifting Of Personnel Requirements',
      requirement:
          'Ensure HMPE ropes are used only where allowed (e.g., ADNOC Offshore mooring winches, screen winches, engineered slings) and comply with DNVGL OS-E303.',
    ),
    InspectionTemplateItem(
      itemNumber: 117,
      section: 'Section 7.6 – Lessons Learned',
      requirement:
          'Ensuring Divisions/Contractor monitor both operational and equipment integrity through an anomaly register, any unplanned event is recorded and tracked through the remedial process within the register',
    ),
    InspectionTemplateItem(
      itemNumber: 118,
      section: 'Section 7.6 – Lessons Learned',
      requirement:
          'Ensuring Periodic review of all routine lifting plans, risk assessments and maintenance procedures for all fixed lifting equipment are conducted to confirm that they are still applicable',
    ),
    InspectionTemplateItem(
      itemNumber: 119,
      section: 'Section 7.6 – Lessons Learned',
      requirement:
          'Ensuring an anomaly register is used as a tool to assess the adequacy of these documents',
    ),
    InspectionTemplateItem(
      itemNumber: 120,
      section: 'Section 7.6 – Lessons Learned',
      requirement:
          'Ensuring that any changes to routine lifting plans, risk assessments and maintenance procedures by the contractor goes through an approval process as prescribed by the Corporate Practice to the formal implementation of the changes',
    ),
    InspectionTemplateItem(
      itemNumber: 121,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that the scope, methods and standards of the operations, maintenance and inspection are specified for all types of equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 122,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring pre-certification in-house inspection for lifting equipment is done by the concerned Site Maintenance Team prior to Third Party Lifting Equipment Inspection and certification',
    ),
    InspectionTemplateItem(
      itemNumber: 123,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring all maintenance and inspection activities performed on lifting equipment either, routine or non-routine, are initiated, planned and tracked according to the guidelines/ requirements of ADNOC Group',
    ),
    InspectionTemplateItem(
      itemNumber: 124,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring certificates, reports and results from maintenance and inspections are updated in applicable records',
    ),
    InspectionTemplateItem(
      itemNumber: 125,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Respective Site authorities ensure that the approved Contractor is applying Planned Maintenance, inspection and remedial activities for all applicable lifting equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 126,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that when the equipment is deemed to be satisfactory for use, a certificate is issued with an expiry date and when equipment is not satisfactory, a defect report with recommendations is issued',
    ),
    InspectionTemplateItem(
      itemNumber: 127,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that a Third Party Lifting Equipment Inspector carries out the mandatory 6 monthly/ annual inspections and functional/performance testing including 48/60 months thorough examination/ proof load testing',
    ),
    InspectionTemplateItem(
      itemNumber: 128,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that Portable lifting equipment including CCU’s, loose gears and portable lifting appliances under 6-months inspection are marked using a colour code system as per ADNOC Group requirements',
    ),
    InspectionTemplateItem(
      itemNumber: 129,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that the inspection program is aligned with the legislative requirements for 6 monthly/12 monthly and 48/60 months inspections',
    ),
    InspectionTemplateItem(
      itemNumber: 130,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that Lifting Equipment undergoes detailed/ thorough examination at least every 12 months, and at least every 6 months for equipment used to lift people',
    ),
    InspectionTemplateItem(
      itemNumber: 131,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that a working test of all mandatory safety devices is carried out',
    ),
    InspectionTemplateItem(
      itemNumber: 132,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring Proof load test is performed when the lifting appliance is new, after installation, after any alteration or major repair, after accident and at intervals set out in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 133,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that a practice of Third Party Lifting Equipment Inspector to apply NDT techniques to assess the integrity of components and will advise the maintenance team and/or site authority for the required load bearing parts of the lifting equipment that need NDT and recommend NDT technique',
    ),
    InspectionTemplateItem(
      itemNumber: 134,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that Inspection period of any lifting equipment are not extended, as it is governed by statutory requirements, however limited endorsement is given to a Lifting Equipment following a Thorough Examination by TPIA',
    ),
    InspectionTemplateItem(
      itemNumber: 135,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that a condition assessment is carried out before lifespan completion (25 years) of Pedestal cranes and mobile cranes in order to determine the extension of life span by Crane’s Manufacturer’s or Local Authorized Dealer only prior to renewal of the annual Mobile Crane License',
    ),
    InspectionTemplateItem(
      itemNumber: 136,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Ensuring that a condition assessment is carried out before lifespan completion (20 years) of Tower cranes and Forklift in order to determine the extension of life span',
    ),
    InspectionTemplateItem(
      itemNumber: 137,
      section: 'Section 7.7 Maintenance and Inspection',
      requirement:
          'Confirm condition assessment is done prior to lifespan expiry — 25 yrs (mobile/pedestal), 20 yrs (tower/forklift)',
    ),
    InspectionTemplateItem(
      itemNumber: 138,
      section: 'Section 7.8 Colour Coding',
      requirement:
          'Ensuring colour coding system for visual identification to indicate that, the lifting accessories/ lifted equipment used has undergone its mandatory 6 monthly examination (Twice Yearly) is in practice',
    ),
    InspectionTemplateItem(
      itemNumber: 139,
      section: 'Section 7.8 Colour Coding',
      requirement:
          'Ensuring current colour is clearly and prominently displayed at each facility and installation on boards',
    ),
    InspectionTemplateItem(
      itemNumber: 140,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Lifting Technical Authority has minimum qualification, experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.1)',
    ),
    InspectionTemplateItem(
      itemNumber: 141,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Single point Authority has minimum qualification, experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.2)',
    ),
    InspectionTemplateItem(
      itemNumber: 142,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Appointed Person has minimum qualification , experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.3)',
    ),
    InspectionTemplateItem(
      itemNumber: 143,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Crane Operator has minimum qualification, experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.4)',
    ),
    InspectionTemplateItem(
      itemNumber: 144,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Lifting Equipment Operator has minimum qualification, experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.5)',
    ),
    InspectionTemplateItem(
      itemNumber: 145,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Rigger/Slinger has minimum qualification, experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.6)',
    ),
    InspectionTemplateItem(
      itemNumber: 146,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring that a rigger performs lift categories only for the lift category for which he has been assessed (Table 7.9.1)',
    ),
    InspectionTemplateItem(
      itemNumber: 147,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Banks Man/ Signaller has minimum qualification, experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.7)',
    ),
    InspectionTemplateItem(
      itemNumber: 148,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Lifting Equipment Maintenance Personnel has minimum qualification, experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.8)',
    ),
    InspectionTemplateItem(
      itemNumber: 149,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Third Party Lifting Equipment Engineers And Inspectors has minimum qualification, experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.9)',
    ),
    InspectionTemplateItem(
      itemNumber: 150,
      section: 'Section 7.9 Competency',
      requirement:
          'Ensuring Lifting Equipment Personnel Tutors And Accessors has minimum qualification, experience, knowledge & skills mentioned in the Corporate Practice (Section 7.9.10)',
    ),
    InspectionTemplateItem(
      itemNumber: 151,
      section: 'Section 7.10 Documentation',
      requirement:
          'Ensuring all critical records are stored, maintained and updated as part of the ADNOC Group HSE Management System process',
    ),
    InspectionTemplateItem(
      itemNumber: 152,
      section: 'Section 7.10 Documentation',
      requirement:
          'Ensuring other information deemed necessary for lifecycle integrity management are also retained in accordance with the Critical Records Policy',
    ),
    InspectionTemplateItem(
      itemNumber: 153,
      section: 'Section 7.10 Documentation',
      requirement:
          'Ensuring all lifting equipment are tagged and where appropriate assigned a unique identifier (Asset Number) and the tags are entered into the Master Equipment List (MEL)',
    ),
    InspectionTemplateItem(
      itemNumber: 154,
      section: 'Section 7.10 Documentation',
      requirement:
          'Ensuring Prior to demobilization from the site after performing examination and testing of lifting equipment, the Third party inspector provides a preliminary written report with statement of fitness for satisfactory equipment and / or defect report for equipment found unsafe with comments and recommendations',
    ),
  ],
);
