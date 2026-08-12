import '../models/inspection_template.dart';

const workingAtHeightTemplate = InspectionTemplate(
  id: 'working_at_height',
  title: 'Working at Height Compliance Checklist',
  client: 'ADNOC',
  category: 'Working at Height',
  description:
      'HSE-PSW-CP20 Working at Height Corporate Practice Compliance Checklist',
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
      requirement: 'Medical Fitness Certificate',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'Mandatory Certification/Documentation',
      requirement: 'MEWP’s Operator Certification',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring proper planning & Risk Assessment for all works at height with the involvement of Performing Authority is performed',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Section 7.2 – Planning',
      requirement:
          'Identification of all potential hazards associated with Working at Height and appropriate control measures defined during the mandated Job Safety Analysis (JSA)',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring the necessary protection measures to personnel from potential falls of tools or materials or from use of mechanical platforms during the activity.',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Section 7.2 – Planning',
      requirement:
          'Wherever possible area shall be barricaded around the activity',
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Section 7.2 – Planning',
      requirement:
          'Diversion of pedestrian walkways away from any overhead activities',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring provision of walkway with overhead protection is made',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring all tools and materials required for work are carried in tool bag, either a shoulder bag, or a scaffolder belt',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring use of debris netting to prevent materials from falling',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Section 7.2 – Planning',
      requirement:
          'Implementation of systematic approach for Hierarchy of Controls (i.e. Avoid, Prevent & Minimize) as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Section 7.2 – Planning',
      requirement:
          'Implementation of appropriate control measure (i.e. Engineering Controls, Administrative Controls and PPE) as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Section 7.2 – Planning',
      requirement:
          'Selection and use of PPE for the activity as per ADNOC Personal Protective Equipment Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Section 7.2 – Planning',
      requirement:
          'Selection of personnel required for working at height is as per their ability to perform work.',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Section 7.2 – Planning',
      requirement:
          'Selection of personnel for working at height as per ADNOC Group Medical Fitness Guidelines',
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring exclusions of personnel who are physically unfit (i.e. suffering from vertigo and acrophobia; unable to undertake climbing activities; suffering from dizziness; physical shape or weight affecting operations)',
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring proper selection of equipment for the specific activity',
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring safe method for the easy movement & access around the work area',
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring review is carried out to find out the requirement of working platforms, walkways and stairways',
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: 'Section 7.2 – Planning',
      requirement: 'Ensuring installation and use of fall arrest systems',
    ),
    InspectionTemplateItem(
      itemNumber: 23,
      section: 'Section 7.2 – Planning',
      requirement:
          'Implementation of safe access and egress for working on roofs as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 24,
      section: 'Section 7.2 – Planning',
      requirement:
          'Ensuring proper guarding of holes and openings prior to the start of the activity',
    ),
    InspectionTemplateItem(
      itemNumber: 25,
      section: 'Section 7.2 – Planning',
      requirement:
          'Adequate safety signs nearby or onto covered/protected holes',
    ),
    InspectionTemplateItem(
      itemNumber: 26,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring review of activities requiring working at height and possibility of fall elimination',
    ),
    InspectionTemplateItem(
      itemNumber: 27,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring suspension of working at height, when the wind speed reaches or gusts higher than 38 km/hr or 20.5 knots',
    ),
    InspectionTemplateItem(
      itemNumber: 28,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring of review of the work based on risk assessment considering the current and anticipated wind speed, weather conditions, altitude of work being undertaken',
    ),
    InspectionTemplateItem(
      itemNumber: 29,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Implementation of protective approach to be taken to prevent the fall through improvement at worksite (i.e. installation of stairs, guardrails, barriers, and travel restriction systems)',
    ),
    InspectionTemplateItem(
      itemNumber: 30,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring proper covering and periodic checks of all floor openings to prevent fall of person /material through the opening',
    ),
    InspectionTemplateItem(
      itemNumber: 31,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring scaffolding to be designed, erected and maintained as per the requirement provided in ADNOC Scaffolding Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 32,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring platform has sufficient strength and rigidity of working platform for the intended use',
    ),
    InspectionTemplateItem(
      itemNumber: 33,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring supervision of scaffold erecting activity and tagged after completion',
    ),
    InspectionTemplateItem(
      itemNumber: 34,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring sufficient dimensions of scaffolding to permit free passage of persons and safe use of equipment and materials;',
    ),
    InspectionTemplateItem(
      itemNumber: 35,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement: 'Ensuring the working platform is at least 600mm wide',
    ),
    InspectionTemplateItem(
      itemNumber: 36,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring well maintained working platform to prevent slips or pries and provision of safeguards (i.e. guardrails, toe boards, handholds and footholds)',
    ),
    InspectionTemplateItem(
      itemNumber: 37,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring competent operators use the equipment as per ADNOC Lifting Operations Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 38,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring the training of operators to the specific type of equipment of MEWPs in accordance with the International Powered Access Federation-Powered Access License (PAL) or equivalent',
    ),
    InspectionTemplateItem(
      itemNumber: 39,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring examination of MEWP after six month intervals or major repair whichever is earlier, by authorized person.',
    ),
    InspectionTemplateItem(
      itemNumber: 40,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuing Prominently display of Safe Working Load (SWL) on the MEWP',
    ),
    InspectionTemplateItem(
      itemNumber: 41,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Provision of safety harness by personnel working from MEWP, and securely connected to a suitable anchor point on the platform',
    ),
    InspectionTemplateItem(
      itemNumber: 42,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Testation and certification of man basket of Suspended Work Platforms (SWP) by third party after every six (6) months',
    ),
    InspectionTemplateItem(
      itemNumber: 43,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Provision of Guardrails on the edge of working platforms, walkways, stairways, ramps or landings and perimeters of buildings & skylights etc.',
    ),
    InspectionTemplateItem(
      itemNumber: 44,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Provision of Toe boards at least 150mm high and run continuously along the edge where guardrail protection is provided',
    ),
    InspectionTemplateItem(
      itemNumber: 45,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Performing and Implementation of risk assessment of guardrail system, in case fall potential of less than 1.8 meters. If required, as a minimum a single guardrail of 950mm from the walking/working level is provided',
    ),
    InspectionTemplateItem(
      itemNumber: 46,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Mid-rail is fitted to all edges where a risk of falling 1.8 meters or more',
    ),
    InspectionTemplateItem(
      itemNumber: 47,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'The gap between any guardrail and mid-rail or toe board and mid-rail does not exceed 470mm',
    ),
    InspectionTemplateItem(
      itemNumber: 48,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ladders are set up on a level area on firm footing and the base shall be located a distance from the wall approximately a quarter of the vertical height of the ladder',
    ),
    InspectionTemplateItem(
      itemNumber: 49,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Anyone working on ladders always maintain three points of contact',
    ),
    InspectionTemplateItem(
      itemNumber: 50,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'If a ladder is more than 3 meters in length, it is securely fixed (e.g. ladder lashing) or if impracticable, a person is stationed at the base of the ladder to prevent the ladder from slipping or falling',
    ),
    InspectionTemplateItem(
      itemNumber: 51,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Wooden ladders are not used in any hydrocarbon handling/storing area, except where it is needed to safely perform electrical work, under controlled conditions',
    ),
    InspectionTemplateItem(
      itemNumber: 52,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Prohibition of use of Aluminium ladders in areas classified as hazardous zones due to the possibility of Thermite reaction which may cause fire/explosion hazard',
    ),
    InspectionTemplateItem(
      itemNumber: 53,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Fiberglass ladders are used when an electrical conductivity hazard has been identified',
    ),
    InspectionTemplateItem(
      itemNumber: 54,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'A two (2) person team transport ladders that are greater than 2m in height',
    ),
    InspectionTemplateItem(
      itemNumber: 55,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Chains or ropes are used where required on stepladders to prevent overspreading',
    ),
    InspectionTemplateItem(
      itemNumber: 56,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'An extension or straight ladder used to access an elevated surface extends at least 3 feet above the point of support',
    ),
    InspectionTemplateItem(
      itemNumber: 57,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring fall restraint systems shall have the capacity to withstand at least 3,000 pounds of force or twice the maximum expected force that is needed to restrain the worker from exposure to the fall hazard',
    ),
    InspectionTemplateItem(
      itemNumber: 58,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Inspection of personal suspension equipment by competent person before usage',
    ),
    InspectionTemplateItem(
      itemNumber: 59,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring use of personal suspension equipment by personnel who have received specific training and formally demonstrated their competence',
    ),
    InspectionTemplateItem(
      itemNumber: 60,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring workers in a boatswain’s chair shall wear a full body harness connected to a separate fall arrest system',
    ),
    InspectionTemplateItem(
      itemNumber: 61,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Selection of the most appropriate fall arresting equipment (i.e. harnesses, lanyards, shock absorbers, fall arresters, lifelines, anchorages, and safety nets), its installation and correct use',
    ),
    InspectionTemplateItem(
      itemNumber: 62,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring usage of appropriate fall arresting equipment (i.e. Safety Nets, Lanyards, Full-Body Harness, Anchorage Points, Horizontal, Vertical Lifelines and Self-Retracting Lifelines) , where fall prevention measures are not reasonably practicable to implement;',
    ),
    InspectionTemplateItem(
      itemNumber: 63,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Safety net types and mesh size are conforming to requirements of the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 64,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Safety nets extend outwards from the outermost projection of the work surface as specified in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 65,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Conduction of drop-test at the job site after initial installation of safety net, before being used as per the requirements mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 66,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Maximum size of each safety net mesh opening does not exceed 230cm2 nor be longer than 150mm on any side, and the opening, measured centre-to-centre of mesh ropes or webbing, is not longer than 150mm',
    ),
    InspectionTemplateItem(
      itemNumber: 67,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring lanyard shall be long enough to allow full reach to the work',
    ),
    InspectionTemplateItem(
      itemNumber: 68,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuing lanyards shall be anchored to a structural member which shall withstand the impact of the fall, and not allow the free fall more than 1.8 meters, nor allow contact with any lower level',
    ),
    InspectionTemplateItem(
      itemNumber: 69,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Availability of additional lanyards to use as replacements in the event that defective lanyards are taken out of use.',
    ),
    InspectionTemplateItem(
      itemNumber: 70,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Selection of suitable and appropriate full body harness to withstand the weight of personnel wearing it including the weight of tools to be carried',
    ),
    InspectionTemplateItem(
      itemNumber: 71,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring the full body harness shall be equipped with shoulder straps and leg straps, a sub-pelvic assembly, adjustable buckles or fasteners, and one or more D-rings',
    ),
    InspectionTemplateItem(
      itemNumber: 72,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Selection of full body harness to ensure suitability for intent use',
    ),
    InspectionTemplateItem(
      itemNumber: 73,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Selection of suitable harness (i.e. has Suspension Trauma safety straps, comfortable, provides adequate support, be able to catch fall and not complex to put on or adjust)',
    ),
    InspectionTemplateItem(
      itemNumber: 74,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Establishment of anchorage points to provide personnel free movement without the need to repeatedly unclip the harness',
    ),
    InspectionTemplateItem(
      itemNumber: 75,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring anchor strength requirements as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 76,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Installation and use of horizontal lifelines as per manufacturer’s recommendation',
    ),
    InspectionTemplateItem(
      itemNumber: 77,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Consideration of SRL for use when working in areas such as roofs, scaffolds, tanks, towers, vessels, and manholes',
    ),
    InspectionTemplateItem(
      itemNumber: 78,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring self-retracting lifelines are used by only one person at a time',
    ),
    InspectionTemplateItem(
      itemNumber: 79,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring removal of fall protection system from service immediately after subjected to fall arresting forces',
    ),
    InspectionTemplateItem(
      itemNumber: 80,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Consideration of measurement for assessing the fall hazards and controls prior to the start of working at height activity',
    ),
    InspectionTemplateItem(
      itemNumber: 81,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring the calculation of total fall clearance distance before a decision is made to use a Personal Fall Arrest System (PFAS)',
    ),
    InspectionTemplateItem(
      itemNumber: 82,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring free fall distance shall be 1.8m or less to prevent the worker from contacting a lower level or ground',
    ),
    InspectionTemplateItem(
      itemNumber: 83,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Ensuring deceleration distance shall be not greater than 3.5 feet to arrest the fall',
    ),
    InspectionTemplateItem(
      itemNumber: 84,
      section: 'Section 7.3 – Consideration for Working At Height',
      requirement:
          'Evaluation the swing fall hazard at the edges where a worker might fall before beginning work on an elevated level',
    ),
    InspectionTemplateItem(
      itemNumber: 85,
      section: 'Section 7.4 – Specific Activity',
      requirement:
          'Requirements with regards to working on roof as specified in the Corporate Practice are met',
    ),
    InspectionTemplateItem(
      itemNumber: 86,
      section: 'Section 7.4 – Specific Activity',
      requirement:
          'Requirements with regards to rope access as specified in the Corporate Practice are met',
    ),
    InspectionTemplateItem(
      itemNumber: 87,
      section: 'Section 7.4 – Specific Activity',
      requirement:
          'Requirements with regards to working over water/over side as specified in the Corporate Practice are met',
    ),
    InspectionTemplateItem(
      itemNumber: 88,
      section: 'Section 7.5 – Emergency Management',
      requirement:
          'A written Emergency Response Plan including rescue is established, taking into consideration rescue operation key points as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 89,
      section: 'Section 7.5 – Emergency Management',
      requirement:
          'Emergency response equipment is kept on site and made readily available and accessible (identified based on the risk assessment);',
    ),
    InspectionTemplateItem(
      itemNumber: 90,
      section: 'Section 7.5 – Emergency Management',
      requirement:
          'Personnel at work shall be provided with information on emergency plan including: Who to approach or call in the event of an emergency; Procedures to follow in event of emergencies, including those persons suspended in safety harness during fall arrest; and Assembly points (if relevant).',
    ),
    InspectionTemplateItem(
      itemNumber: 91,
      section: 'Section 7.5 – Emergency Management',
      requirement: 'First aid provisions are available',
    ),
    InspectionTemplateItem(
      itemNumber: 92,
      section: 'Section 7.5 – Emergency Management',
      requirement:
          'A person after is immediately rescued after an arrested fall to prevent the onset of potential injuries such as suspension trauma',
    ),
    InspectionTemplateItem(
      itemNumber: 93,
      section: 'Section 7.6 – Training and Competency',
      requirement:
          'Ensuring all personnel involved in working at height acquire the understanding, knowledge and skill necessary for the safe performance of all duties',
    ),
    InspectionTemplateItem(
      itemNumber: 94,
      section: 'Section 7.6 – Training and Competency',
      requirement:
          'Ensuring personnel are aware of procedures for removal of fall protection devices from service for repair or replacement',
    ),
    InspectionTemplateItem(
      itemNumber: 95,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring properly inspection and maintenance of all the equipment used during working at height compliance with this Corporate Practice and as per manufacturer’s recommendation',
    ),
    InspectionTemplateItem(
      itemNumber: 96,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring thorough visual inspection and checks on equipment before every usage is carried out',
    ),
    InspectionTemplateItem(
      itemNumber: 97,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring preventive maintenance schedule is in place and carried out',
    ),
    InspectionTemplateItem(
      itemNumber: 98,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring record keeping (such as for damages, flaws detected, any preventive maintenance, repairs or replacements done). is done',
    ),
    InspectionTemplateItem(
      itemNumber: 99,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring Fall protection Equipment inspection interval is not exceeded 6 months',
    ),
    InspectionTemplateItem(
      itemNumber: 100,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring all Fall arrest System equipment found defective during inspection and maintenance are segregated, tagged with a cautionary “Out of Service Tag” and discarded',
    ),
    InspectionTemplateItem(
      itemNumber: 101,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring inspections of harnesses and lanyards are conducted every 6 months by a trained and competent person',
    ),
    InspectionTemplateItem(
      itemNumber: 102,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring anchorages are inspected and certified before use after initial installation, and inspected every 12 months by a qualified rigger, scaffolder or specialist installer',
    ),
    InspectionTemplateItem(
      itemNumber: 103,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring inspection of fall arrest devices are conducted every 3 months by a trained and competent person',
    ),
    InspectionTemplateItem(
      itemNumber: 104,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring inspection of horizontal life lines, vertical life lines used with fall arrest devices and horizontal or vertical rails are undertaken every 12 months',
    ),
    InspectionTemplateItem(
      itemNumber: 105,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring fall arrest devices are fully serviced if they have been in storage for longer than 12 months',
    ),
    InspectionTemplateItem(
      itemNumber: 106,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring that fall arrest equipment is stored and transported in such conditions which avoid dampness, heat and stress on components',
    ),
    InspectionTemplateItem(
      itemNumber: 107,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement: 'Ensuring ladder pre-use daily checks are done',
    ),
    InspectionTemplateItem(
      itemNumber: 108,
      section: 'Section 7.7 Inspection and Maintenance',
      requirement:
          'Ensuring up-to-date record of the detailed visual inspection carried out regularly by a Competent person, which is done in accordance to manufacturer’s recommendation',
    ),
  ],
);
