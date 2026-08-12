import '../models/inspection_template.dart';

const campWelfareTemplate = InspectionTemplate(
  id: 'camp_welfare',
  title: 'Contractor Welfare Management Audit',
  client: 'ADNOC',
  category: 'Camp & Welfare',
  description:
      'ADNOC Food & Water Safety and Contractor Welfare Management Audit',
  responseType: InspectionResponseType.yesNoNa,
  items: [
    InspectionTemplateItem(
      itemNumber: 1,
      section: '1. WELFARE PLAN',
      requirement:
          'Welfare Management Plan developed and implemented. A focal point for the Contractor\'s welfare management is assigned.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 2,
      section: '1. WELFARE PLAN',
      requirement:
          'Company management is demonstrating visible leadership in driving welfare programs. Company management is engaged with / aware of the welfare issues faced by individual employees.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 3,
      section: '1. WELFARE PLAN',
      requirement:
          'Welfare Committee have representation of workers from different ethnic groups (Wise-man) and all workers provided awareness about the Welfare provisions and programs.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: '1. WELFARE PLAN',
      requirement:
          'Wise-man concept is being implemented and connection is established with management and welfare committees. Chosen wise-man is one who the workers can trust to raise their concerns, including personal issues, which will be raised in a timely manner to the management by the same wise-man. Worker grievances and suggestions are appropriately addressed and resolved.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: '1. WELFARE PLAN',
      requirement:
          'Monthly welfare committees meeting are conducted and Minutes of Meeting (MoM) displayed. New developments or changes are effectively communicated.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: '1. WELFARE PLAN',
      requirement:
          'Records of Welfare Inspection Reports (monthly) and Welfare Audit Reports (quarterly) are available. Welfare Action Tracking Register to track the status of close-out actions are available. Record of Minutes of meeting of Contractor Welfare Committee for previous month is available and actions are timely closed.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: '1. WELFARE PLAN',
      requirement:
          'Facility maintains records of the number, identity, assigned locations and personal provisions (Furniture, Beds, etc) of camp occupants.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: '2. WAGE SYSTEM',
      requirement:
          'Is UAE Ministry of Labor approved Wage Protection System (WPS) utilized  by the contractor to pay their  Personnel monthly salary, applicable allowances and entitlements no later than the time specified in the UAE Labor law.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: '2. WAGE SYSTEM',
      requirement: 'Are employees provided a copy of their Labor Contract.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: '2. WAGE SYSTEM',
      requirement:
          'Are all workers receiving their due minimum basic salaries, overtime, allowances & other entitlements including transit accommodation & travel tickets, as detailed in the Contract on time.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: '2. WAGE SYSTEM',
      requirement:
          'Are all workers provided with details of deductions by CONTRACTOR from their monthly salary or allowances strictly in accordance with U.A.E. Labor Law.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: '2. WAGE SYSTEM',
      requirement:
          'Are all workers provided with leaves (annual leave and sick leave), work rotation and time off as per their entitlement and in line with UAE Labor Law.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: '2. WAGE SYSTEM',
      requirement:
          'Are workers provided with break times between duty time for rest, food and prayer, applicable summer midday break rule, etc.',
      weight: 0.03,
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: '2. WAGE SYSTEM',
      requirement:
          'Are workers provided with adequate arrangements for remitting money abroad? Adequate transportation facilities are provided at least on a monthly basis or as and when required.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: '3. RECREATION FACILITIES',
      requirement:
          'Are Recreation & Sports facilities for workers in camp provided in line with UAE Labor Law and ADNOC Corporate Practice?',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: '3. RECREATION FACILITIES',
      requirement:
          'Floor space, seating arrangements and surrounding areas like walls, windows, doors clean and area free of slip/trip hazards.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: '3. RECREATION FACILITIES',
      requirement:
          'Are facilities and equipment provided adequate, clean and maintained in good condition (e.g. TV for major ethnic groups, free Wi-Fi, pool table, and Physical fitness exercise equipment).',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: '4. LAYOUT/APPROVALS/FIRE FIGHTING/EMERGENCY RESPONSE /GENERAL',
      requirement: 'Valid Civil Defense certificate for camp is available.',
      weight: 0.025,
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: '4. LAYOUT/APPROVALS/FIRE FIGHTING/EMERGENCY RESPONSE /GENERAL',
      requirement:
          'Appropriate Firefighting arrangements as per Civil Defense requirement are available, maintained, tested periodically, are in good working condition and certified (Fire detection/alarm system / fire protection systems, etc.).',
      weight: 0.025,
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: '4. LAYOUT/APPROVALS/FIRE FIGHTING/EMERGENCY RESPONSE /GENERAL',
      requirement:
          'Emergency Response plan is in place, drill / exercises and awareness training conducted periodically.  Fire wardens are trained and appointed. Public address system available.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: '4. LAYOUT/APPROVALS/FIRE FIGHTING/EMERGENCY RESPONSE /GENERAL',
      requirement:
          'Evacuation routes and assembly points posted with signs in prominent locations.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: '4. LAYOUT/APPROVALS/FIRE FIGHTING/EMERGENCY RESPONSE /GENERAL',
      requirement:
          'Paved pathways and designated Parking bays are provided and kept clear throughout the facility. Common area and pathway illumination is adequately maintained.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 23,
      section: '4. LAYOUT/APPROVALS/FIRE FIGHTING/EMERGENCY RESPONSE /GENERAL',
      requirement:
          'Pedestrian access maintained to avoid interface with moving machinery and at bus boarding/offloading areas. Vehicle speed limit signs are displayed.',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 24,
      section: '4. LAYOUT/APPROVALS/FIRE FIGHTING/EMERGENCY RESPONSE /GENERAL',
      requirement:
          'Are all chemicals, flammables and detergents stored appropriately as per latest SDS and managed appropriately.',
      weight: 0.015,
    ),
    InspectionTemplateItem(
      itemNumber: 25,
      section: '4. LAYOUT/APPROVALS/FIRE FIGHTING/EMERGENCY RESPONSE /GENERAL',
      requirement:
          'Suitable security measures are in place for controlling entrance to and exit from the camp and ensuring Facility rules are followed.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 26,
      section: '4. LAYOUT/APPROVALS/FIRE FIGHTING/EMERGENCY RESPONSE /GENERAL',
      requirement:
          'Camp/Accommodation Rules are displayed in the languages spoken and understood by the occupants. Emergency contact number is posted in each room of accommodation camps.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 27,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Accommodation is well maintained with regular housekeeping and cleanliness. Located in a quiet area, away from potential chemical, physical, biological hazards and protected against pests and adverse weather conditions.',
      weight: 0.023,
    ),
    InspectionTemplateItem(
      itemNumber: 28,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Accommodation consists of adequate Ablution blocks, Toilets, Washing / Shower facilities, Kitchen, Food and beverages, Dining facilities, Recreational facilities to its personnel in line with ADNOC Welfare Corporate Practice requirements and UAE Labor law.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 29,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Each worker is provided adequate space of not less than 3m² exceeding the ADNOC Corporate Practice requirements and UAE Cabinet decision No. 13 (2009) and Ministerial Decree (212) of 2014 with provisions of proper beds, blankets, bed linen, pillows, pillow covers, curtains, etc.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 30,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Accommodation units have provisions of adequate illumination, ventilation, air conditioning and noise control from high noise sources (e.g., Power Generators, etc).',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 31,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Each worker provided with adequate storage (side table and lockable closet, shoe rack, cloth hanger, bed curtain and window curtain)',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 32,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Potable water provided to workers is from approved sources (municipal supply/ licensed supplier or produced in-house by approved process) meeting the minimum Department of Energy (DOE) and legal requirements. Sufficient locations of clean and cool drinking water dispensers are available and maintained.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 33,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Are laboratory tests conducted for potable water periodically and conforms to ADNOC/DOE requirements.',
      weight: 0.012,
    ),
    InspectionTemplateItem(
      itemNumber: 34,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Are accommodation units and surrounding maintained pest free with regular pest control regime and schedules.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 35,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Provisions of Barber shops and Grocery shops [Grocery to be restricted only for ready to use items] are provided in remote and offshore Accommodation/Camp locations.',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 36,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'Others (General Observations such as: Provide landlines/phones/ intercoms in accommodation units to activate emergencies).',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 37,
      section: '5. ACCOMMODATION AREA',
      requirement:
          'No cooking appliances, food and prohibited appliances (e.g. electric coil heater are found in the accommodation units).',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 38,
      section: '6. SANITARY FACILITIES/ABLUTIONS/ LAUNDRY',
      requirement:
          'Ablution blocks, toilet and showers comply with standards and requirements.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 39,
      section: '6. SANITARY FACILITIES/ABLUTIONS/ LAUNDRY',
      requirement:
          'Hot and cold water supplied to all wash basins and showers?',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 40,
      section: '6. SANITARY FACILITIES/ABLUTIONS/ LAUNDRY',
      requirement:
          'Ratio of facilities is appropriate to the number of occupants (i.e. at least one basin with hot and cold water supply for every six people; and a water closet (not a urinal) and a bath / shower for every eight people).',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 41,
      section: '6. SANITARY FACILITIES/ABLUTIONS/ LAUNDRY',
      requirement:
          'All fittings are appropriate and functioning properly (e.g. no broken doors /shower curtains, windows, plugs, sockets, switches, WC, urinal, basins, showerheads and hose etc.).',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 42,
      section: '6. SANITARY FACILITIES/ABLUTIONS/ LAUNDRY',
      requirement:
          'Proper doors, locks and cloth hanging facilities are available.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 43,
      section: '6. SANITARY FACILITIES/ABLUTIONS/ LAUNDRY',
      requirement:
          'Ablution blocks, toilets and shower facilities are accessible at all times and comply with the maximum travel distance from the farthest accommodation unit.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 44,
      section: '6. SANITARY FACILITIES/ABLUTIONS/ LAUNDRY',
      requirement:
          'Drainage and sewage handling facilities are adequate, with maintenance arrangements in place without leakages and flooding.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 45,
      section: '6. SANITARY FACILITIES/ABLUTIONS/ LAUNDRY',
      requirement:
          'All areas are clean, disinfected and free of slip/trip hazards. Adequate illumination and ventilation is available.',
      weight: 0.012,
    ),
    InspectionTemplateItem(
      itemNumber: 46,
      section: '6. SANITARY FACILITIES/ABLUTIONS/ LAUNDRY',
      requirement:
          'Contractor at his own expense provides laundry services to its personnel for coveralls/uniforms and personal clothes. Scheduled laundry services available for workers. Are issued quantity of coveralls adequate?',
      weight: 0.011,
    ),
    InspectionTemplateItem(
      itemNumber: 47,
      section:
          '7. FOOD HANDLING AREA (STORAGE, PREPARATION & SERVING) AND FOOD SAFETY',
      requirement:
          'Are Catering, food services and food transportation having valid approval from ADAFSA (Abu Dhabi Agriculture & Food Control Authority) or the respective Emirate Municipality’s Food Control Section as applicable). Are all Food handling staff have qualifications of Essential Food Safety Training (ADAFSA)/Level 2 Award in Food Safety, HACCP Awareness?',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 48,
      section:
          '7. FOOD HANDLING AREA (STORAGE, PREPARATION & SERVING) AND FOOD SAFETY',
      requirement:
          'Does Contractor at his own cost provides food to his employees avoiding back charges to his employees and ADNOC Group? There shall be no food encashment as part of the workers’ salaries in order to ensure food is consumed by workers.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 49,
      section:
          '7. FOOD HANDLING AREA (STORAGE, PREPARATION & SERVING) AND FOOD SAFETY',
      requirement:
          'Site specific Food Safety Management (HACCP) plan in place, implemented. Inspection and audits are regularly conducted and records maintained.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 50,
      section:
          '7. FOOD HANDLING AREA (STORAGE, PREPARATION & SERVING) AND FOOD SAFETY',
      requirement:
          'No contaminated, rotten, food with fungus, or expired food are stored within the premises. Date codes and stock rotation is followed.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 51,
      section:
          '7. FOOD HANDLING AREA (STORAGE, PREPARATION & SERVING) AND FOOD SAFETY',
      requirement:
          'Kitchen is well maintained with proper food storage facilities, production, washing and dining/mess halls: adequate in space; temperatures controlled (with means to monitor temperature).',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 52,
      section:
          '7. FOOD HANDLING AREA (STORAGE, PREPARATION & SERVING) AND FOOD SAFETY',
      requirement:
          'Are all incidents related to food reported, thoroughly investigated and action taken. Suggestions and complaints are recorded, investigated and actioned.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 53,
      section:
          '7. FOOD HANDLING AREA (STORAGE, PREPARATION & SERVING) AND FOOD SAFETY',
      requirement:
          'Food Safety Management System (FSMS) based on Hazard Analysis Critical Control Points (HACCP) is developed, implemented, validated, verified, and maintained.',
      weight: 0.02,
    ),
    InspectionTemplateItem(
      itemNumber: 54,
      section:
          '7. FOOD HANDLING AREA (STORAGE, PREPARATION & SERVING) AND FOOD SAFETY',
      requirement:
          'Are food and water safety inspections/audits conducted in reference to HSE-OH-CP09 Corporate Practice requirements and documents are being maintained.',
      weight: 0.01,
    ),
    InspectionTemplateItem(
      itemNumber: 55,
      section: '8. DIESEL GENERATOR, ELECTRICAL INSTALLATIONS & FITTINGS',
      requirement:
          'Diesel Generator area are properly maintained (preferably silent generator, earthing, bonding, firefighting equipment, secondary containment, battery condition, main panel, local panel, accessibility, exhaust  and exhaust pipe, signage & general housekeeping). Power supply to all camp facilities is provided 24 hours a day.',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 56,
      section: '8. DIESEL GENERATOR, ELECTRICAL INSTALLATIONS & FITTINGS',
      requirement:
          'Fuel storage areas are maintained as per Civil Defense requirement (secondary containment, earthing & bonding, signage, firefighting equipment etc.).',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 57,
      section: '8. DIESEL GENERATOR, ELECTRICAL INSTALLATIONS & FITTINGS',
      requirement:
          'Are all electrical installations and fittings inspected and maintained in safe working condition with service logs.',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 58,
      section: '8. DIESEL GENERATOR, ELECTRICAL INSTALLATIONS & FITTINGS',
      requirement:
          'Cables, TV wires and Pipes are laid, organized and routed appropriately without obstructions in the facilities.',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 59,
      section: '9. ENVIRONMENT & WASTE MANAGEMENT',
      requirement:
          'Is Waste management plan is developed and implemented. Sufficient bins for waste collection are provided.',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 60,
      section: '9. ENVIRONMENT & WASTE MANAGEMENT',
      requirement:
          'Are all wastes classified (hazardous / non-hazardous), segregated, stored, handled and regularly disposed through approved agencies?',
      weight: 0.005,
    ),
    InspectionTemplateItem(
      itemNumber: 61,
      section: '9. ENVIRONMENT & WASTE MANAGEMENT',
      requirement:
          'Collected waste, awaiting disposal, is kept away and stored in designated areas, protected from animals, free from any health risks.',
      weight: 0.004,
    ),
    InspectionTemplateItem(
      itemNumber: 62,
      section: '9. ENVIRONMENT & WASTE MANAGEMENT',
      requirement:
          'Sewage Treatment Plant (STP) if available is in good working condition meeting the prescribed parameters. Effluents are periodically tested, documented and performance monitored.',
      weight: 0.003,
    ),
    InspectionTemplateItem(
      itemNumber: 63,
      section: '9. ENVIRONMENT & WASTE MANAGEMENT',
      requirement:
          'Non-potable water outlets (e.g. ground water, irrigation water not used for washing or bathing) are clearly marked and identified.',
      weight: 0.003,
    ),
    InspectionTemplateItem(
      itemNumber: 64,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Adequately trained/certified First aiders are appointed (names and contact numbers are prominently displayed). Provision of First aid services are in place and accessible 24/7.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 65,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Clinic is fully equipped and DOH licensed (as applicable) to serve the contractor\'s workforce. Are the facilities fully compliant with laws and regulations of UAE and contractual requirements?   Means of transportation (e.g. Ambulance, Company Transport) and Driver provided as per the contractual requirement.\n\nAuditors should specifically  evaluate the following:\nNurse & Physician availability: If number of workers in one place or within an area the radius of which is twenty kilometres, is exceeding fifty workers and less than two hundred.\nTraining & Competency: Training on common worksite hazards prior to starting work and evidence of relevant qualification or proof of training regarding common occupational safety and health hazards and risks.\nOnsite Ambulance:  Response time shall be within 10 minutes to anywhere on the site. \nIf the ambulance response time is greater than 15 minutes for a work site that have high hazard activities, then the worksite shall have appropriate medical staff (Emergency medical technician/ paramedic or ambulance nurse) onsite with current immediate life support and Basic trauma life support training to ensure that the response time of 10 minutes or less”.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 66,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Are first aider and the nurse competent to apply first aid techniques, e.g. CPR; or use first aid kit, e.g. AED kit; Are the Training certificates and AED\'s calibration certificates valid?\n\nAuditors should specifically  evaluate the following:\na) Adequacy of  first aiders (considering the Population at Risk and type of activity), \nb) First aiders receive the adequate level of first aid training as per regulatory requirements (Level 1/Level 2)\nc) Level of Training is in accordance with the scope of the services, functions and needs of the employer, environment and associated potential hazards and risks\nd) Limit their first aid treatment within the scope of their training level;\ne) Keep documentation of cases treated in accordance with requirements of their employer and those of the governing or regulating body and relevant legislation.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 67,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'MEDEVAC drills are conducted including Non Work Related Fatality scenarios. First-aiders’ skills to perform during emergencies through frequent MEDEVAC drills both at site and accommodation camps are assessed. Actions from the drills are captured and closed out and verified.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 68,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Medical emergency preparedness (Plan) is evaluated and medical emergency exercise (Drills) to evaluate the adequacy of response are conducted. Copy of Drills /Exercises are documented and approved at appropriate management levels. All such documents are readily available for review and/or verification.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 69,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Sick bay / Quarantine ward is maintained to isolate the personnel having communicable illness by camp (E.g.: Chicken pox).',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 70,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'All Occupational Medical Assessments (Pre-employment, Periodic medical, Fitness to Work and Return to work fitness etc.)  are undertaken in accordance with ADNOC Group Medical Fitness Guidelines for Contractors , documented and readily available for verification as required.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 71,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Health campaigns are organized and delivered to workers in different languages, including on mental wellness, cardiovascular diseases, diabetes etc. Awareness is provided for all employees by camp medical staff on self - medication, including herbal medicine, stress and fatigue management.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 72,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Diseases Notification (system)  is in place in accordance with Sector Regulatory and HSE requirements. Process is established for reporting and timely interventions for any abnormal behaviours at worksite and camps, which may potentially lead to suicide or Non work related fatality. Reporting is done in accordance with relevant HSE Corporate Practice/requirements.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 73,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Psychosocial aspects and mental health counselling services are available for all employees.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 74,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Trainings for HSE Induction, Tool Box Talks, Permit to Work, Emergency Response and Evacuation, Heat Stress are provided and documented.',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 75,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Are all workers provided with Health insurance in accordance with applicable by Law?',
      weight: 0.008,
    ),
    InspectionTemplateItem(
      itemNumber: 76,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Contractor Employees are informed / provided access to Wellness and other related services including life coaches, nutritionists, dieticians, fitness coaches,  Legal & Financial Services (e.g. via EAP Programs - Downloadable).',
      weight: 0.003,
    ),
    InspectionTemplateItem(
      itemNumber: 77,
      section:
          '10. FIRST AID/ HEALTH INSURANCE/ MEDICAL EXAMINATION & SERVICES',
      requirement:
          'Contractor Management has an updated list of employees with chronic illnesses / conditions (e.g. diabetes, cardiovascular diseases, asthma, haemolytic diseases, kidney diseases, liver diseases etc.). There is follow up process for the employees with chronic illnesses / conditions.',
      weight: 0.004,
    ),
  ],
);
