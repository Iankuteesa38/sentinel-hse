import '../models/inspection_template.dart';

const excavationTemplate = InspectionTemplate(
  id: 'excavation',
  title: 'Excavation Compliance Checklist',
  client: 'ADNOC',
  category: 'Excavation',
  description:
      'HSE-PSW-CP14 Excavation Corporate Practice Compliance Checklist',
  responseType: InspectionResponseType.yesNoNa,
  items: [
    InspectionTemplateItem(
      itemNumber: 1,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Permit to Work (PTW)',
    ),
    InspectionTemplateItem(
      itemNumber: 2,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Job Safety Analysis',
    ),
    InspectionTemplateItem(
      itemNumber: 3,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Area Authority (AA) Approval',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Excavation Certificate',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Authorized Civil Personnel involvement',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Section 7.1 - Excavation',
      requirement:
          'Identification, thorough examination and marking of presence of electrical cables, underground services and overhead wires till required length and width by competent person using Cable Avoidance Tool (CAT)',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Section 7.1 - Excavation',
      requirement:
          'Ensuring initial planning is done by considering the above by competent person',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Section 7.1 - Excavation',
      requirement:
          'Ensuring documented Work Management System (WMS) includes prior excavation risk assessment and applicable control measures',
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Section 7.1 - Excavation',
      requirement: 'Ensuring PTW and Excavation Certificate are in place',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Section 7.1 - Excavation',
      requirement:
          'Ensuring that all personnel been properly briefed and instructed as to the work to be carried out and by what means',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Section 7.1 - Excavation',
      requirement:
          'Ensuring that there is an Evacuation Plan in place and have all personnel been briefed and instructed on the emergency evacuation procedures',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Section 7.1 - Excavation',
      requirement:
          'Ensuring that all tools, equipment and machinery to be used in the excavation have a valid test certificate where appropriate, confirming it is fit for use',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Section 7.1 - Excavation',
      requirement:
          'Ensuring there is an adequate working space for the proposed plant and equipment to be used',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Section 7.1 - Excavation',
      requirement:
          'Ensuring the required equipment are made ready before start of work',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Section 7.3 – Risk Management Process',
      requirement:
          'Ensuring identification of all hazards pertaining to type of excavation prior to execution',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Section 7.3 – Risk Management Process',
      requirement:
          'Ensuring Risk assessment been done and control methods are in place for Local site conditions, including access, ground slope, adjacent buildings and structures, water courses (including underground) and trees',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Section 7.3 – Risk Management Process',
      requirement:
          'Ensuring Risk assessment been done and control methods are in place for identified Depth of the excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: 'Section 7.3 – Risk Management Process',
      requirement:
          'Ensuring Risk assessment been done and control methods are in place for site specific Soil properties, including variable soil types, stability, shear strength, cohesion, presence of ground water and the effect of exposure to the elements',
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: 'Section 7.3 – Risk Management Process',
      requirement:
          'Ensuring Risk assessment been done and control methods are in place for all proximity of live services to the excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: 'Section 7.3 – Risk Management Process',
      requirement:
          'Ensuring Risk assessment been done and control methods are in place for the possibility of unauthorised access to the work area',
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: 'Section 7.3 – Risk Management Process',
      requirement:
          'Ensuring Risk assessment been done and control methods are in place for the need to enter/work in the excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: 'Section 7.3 – Risk Management Process',
      requirement:
          'Ensuring Risk assessment been done and control methods are in place for Local weather conditions',
    ),
    InspectionTemplateItem(
      itemNumber: 23,
      section: 'Section 7.3 – Risk Management Process',
      requirement:
          'Ensuring Risk assessment been done and control methods are in place for the length of time the excavation or trench will be open',
    ),
    InspectionTemplateItem(
      itemNumber: 24,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring the adequate requirements for usage of excavation equipment are satisfied',
    ),
    InspectionTemplateItem(
      itemNumber: 25,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring only Mobile Equipment operators, who have an authorized driving license and have been confirmed competent are allowed to operate earthmoving equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 26,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring Mobile Equipment Operator and Banksmen are appropriately trained and competent',
    ),
    InspectionTemplateItem(
      itemNumber: 27,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring proper communication between banksman and Mobile equipment operator is established before work commences',
    ),
    InspectionTemplateItem(
      itemNumber: 28,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring equipment inspections are done on a regular basis and all hired equipment are included in the process',
    ),
    InspectionTemplateItem(
      itemNumber: 29,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring all the activities are supervised by competent person',
    ),
    InspectionTemplateItem(
      itemNumber: 30,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring excavation equipment shall always be guided by banks man/flag man who are aware of the movement and operation of heavy equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 31,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring Powered mobile plant operating near ground personnel or other powered mobile plant are equipped with warning devices (for example reversing alarm and a revolving light).',
    ),
    InspectionTemplateItem(
      itemNumber: 32,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring excavation equipment operators and ground workers are made familiar with the blind spots of particular items of plant being used',
    ),
    InspectionTemplateItem(
      itemNumber: 33,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring construction and materials used for crossing points are approved by competent engineer',
    ),
    InspectionTemplateItem(
      itemNumber: 34,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring cross ways are in required dimensions for easy men and material movement',
    ),
    InspectionTemplateItem(
      itemNumber: 35,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring proper implementation of Gas Testing Program as a part of Method Statement/PTW',
    ),
    InspectionTemplateItem(
      itemNumber: 36,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring Mobile plant operators and ground workers are provided with and required to wear high-visibility clothing',
    ),
    InspectionTemplateItem(
      itemNumber: 37,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring work always carried out is with necessary precautions',
    ),
    InspectionTemplateItem(
      itemNumber: 38,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring Site survey is conducted to identify the presence of underground service and overhead power lines while planning',
    ),
    InspectionTemplateItem(
      itemNumber: 39,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Battery-operated headlamps used where trailing cables pose hazard',
    ),
    InspectionTemplateItem(
      itemNumber: 40,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Warning lights/signs installed around excavation in public areas during night operations',
    ),
    InspectionTemplateItem(
      itemNumber: 41,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring sufficient lighting i.e. Minimum 200 Lux and warning arrangements are provided for safe working',
    ),
    InspectionTemplateItem(
      itemNumber: 42,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring Mechanical excavators weren’t used when the presence of underground pipes, cables (electrical and telecommunications), vessels, or structures are known or expected within 3 meters (10 feet) of the excavation.',
    ),
    InspectionTemplateItem(
      itemNumber: 43,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring mechanical excavation were undertaken up to a distance of 1m from pipe-work / structures only after risks being adequately assessed',
    ),
    InspectionTemplateItem(
      itemNumber: 44,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring using machinery for excavation within 3 meters from live hydrocarbon facility / foundations or electrical cable are considered as Critical Work Activity and the same are approved as per ADNOC Permit to Work Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 45,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring lighting arrangements are made considering different scenarios of emergency events',
    ),
    InspectionTemplateItem(
      itemNumber: 46,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring the personnel are always wearing PPE at all times in work as per the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 47,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring access to unauthorised persons are prevented by suitable physical means (e.g., Rigid barricades, Guard Rails)',
    ),
    InspectionTemplateItem(
      itemNumber: 48,
      section: 'Section 7.4 – Control Measures',
      requirement: 'Ensuring proper access to working personnel',
    ),
    InspectionTemplateItem(
      itemNumber: 49,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring that crossing excavations are only permitted at predetermined points',
    ),
    InspectionTemplateItem(
      itemNumber: 50,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Any gangway, bridge or crossing point provided that are suitable for the intended task and its construction and materials used are approved by a competent engineer',
    ),
    InspectionTemplateItem(
      itemNumber: 51,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring Gangways are fitted with guard-rails and toe-boards',
    ),
    InspectionTemplateItem(
      itemNumber: 52,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring Gangways are least 0.46 m wide for personnel access and 0.6 m wide for personnel and materials access',
    ),
    InspectionTemplateItem(
      itemNumber: 53,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring ladders, steps, ramps or other safe means of egress for workers are provided when working in trench excavation deeper than 1.2 m, as a specific requirement for trench excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 54,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring means of egress are located at every 7.62 meters (25 feet) to cater during emergency, as a specific requirement for Trench Excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 55,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring no materials are stacked between suitable barrier and edge of excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 56,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring required access and egress ways considering an event of emergency as well, are provided and approved by competent engineer',
    ),
    InspectionTemplateItem(
      itemNumber: 57,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring excavation is suitably guarded to restrict access by personnel not associated with the excavation activities',
    ),
    InspectionTemplateItem(
      itemNumber: 58,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring barriers and stop blocks are erected at a minimum of 1 metres distance from the excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 59,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring physical Demarcation is provided of the excavation edge if excavation is more than 1.8m deep',
    ),
    InspectionTemplateItem(
      itemNumber: 60,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring that the edges of an excavation are marked with hazard warning lights, especially where they are close to public thoroughfares',
    ),
    InspectionTemplateItem(
      itemNumber: 61,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring permit from Traffic Police approval is in place and appropriate barricades and warning notices are erected, when work is carried out on the roads outside ADNOC jurisdiction',
    ),
    InspectionTemplateItem(
      itemNumber: 62,
      section: 'Section 7.4 – Control Measures',
      requirement:
          'Ensuring all access to the excavation are confined to proper paths, wherever barriers are set back from edge of Excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 63,
      section: 'Section 7.5 – Excavation Methods',
      requirement:
          'Ensuring careful consideration is given to health and safety issues when planning the work where the excavation involves anything other than shallow trenching and small quantities of material',
    ),
    InspectionTemplateItem(
      itemNumber: 64,
      section: 'Section 7.5 – Excavation Methods',
      requirement:
          'Ensuring that the personnel who proposes to excavate a trench at least 1.2m deep, have minimized the risk to any person arising from the collapse of the trench by ensuring that all sides of the trench are adequately supported',
    ),
    InspectionTemplateItem(
      itemNumber: 65,
      section: 'Section 7.5 – Excavation Methods',
      requirement:
          'Ensuring where a person enters a trench and there is a risk of engulfment, required control measures are implemented regardless of the depth of the trench',
    ),
    InspectionTemplateItem(
      itemNumber: 66,
      section: 'Section 7.5 – Excavation Methods',
      requirement:
          'Ensuring design took construction methods that may be used to construct the tunnel so that a safe design for construction purposes is achieved is taken into consideration',
    ),
    InspectionTemplateItem(
      itemNumber: 67,
      section: 'Section 7.5 – Excavation Methods',
      requirement:
          'Ensuring access to shaft openings is controlled by using a secure cover that is lockable and accessible only by a designated person',
    ),
    InspectionTemplateItem(
      itemNumber: 68,
      section: 'Section 7.5 – Excavation Methods',
      requirement:
          'Ensuring design and construction advice is obtained from a competent person (for example an engineer) before excavation and installation',
    ),
    InspectionTemplateItem(
      itemNumber: 69,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Continuous monitoring of space left between barricade / mobile operation vehicle and edge of excavation for protection against falling and dislodging of materials',
    ),
    InspectionTemplateItem(
      itemNumber: 70,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring a clear space at least 1 meter (3.28 feet) wide is maintained on all sides from the excavation to the barriers',
    ),
    InspectionTemplateItem(
      itemNumber: 71,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring excavations are not undermining the scaffold footings, buried services or the foundations of nearby buildings or walls',
    ),
    InspectionTemplateItem(
      itemNumber: 72,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring excavating equipment are not parked close to the sides of excavations',
    ),
    InspectionTemplateItem(
      itemNumber: 73,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'It is ensured that wherever extra loads are operated, the sides of excavation are sheet-piled, shored, and braced as necessary to resist the extra pressure due to such loads',
    ),
    InspectionTemplateItem(
      itemNumber: 74,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring when mobile equipment is utilized or allowed adjacent to excavations, substantial stop logs, or barricades are installed to prevent the equipment falling into the excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 75,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring fixed warning lights are used to mark the limits of the work',
    ),
    InspectionTemplateItem(
      itemNumber: 76,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring required protective systems are determined by the relevant risk assessment, when excavation is more than 1.2 m (4 feet) deep, considered confined space: apply CP08/PTW requirements',
    ),
    InspectionTemplateItem(
      itemNumber: 77,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring appropriate physical protection (e.g. Benching, Sloping) for different types of excavation are in place',
    ),
    InspectionTemplateItem(
      itemNumber: 78,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring Maximum allowable slopes for excavations less than 6.09 m (20 ft) based on soil type and angle to the horizontal are determined according to the Corporate Practice to make excavation safe',
    ),
    InspectionTemplateItem(
      itemNumber: 79,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring that the authorized civil personnel from ADNOC Group or Contractors approved all heading or tunnel that exceeds 2 metres in height or width',
    ),
    InspectionTemplateItem(
      itemNumber: 80,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Slopes for battering determined by soil type as per Table 7.5.1 (e.g., 1:1 for Type B)',
    ),
    InspectionTemplateItem(
      itemNumber: 81,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring that the authorized civil personnel from ADNOC Group or Contractors approved all heading that is to be cut into rock',
    ),
    InspectionTemplateItem(
      itemNumber: 82,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring the specific personnel involved in Chemical grouting or cleaning up chemical spills wearing required PPE at all times as per Safety Data Sheet additional to regular practice',
    ),
    InspectionTemplateItem(
      itemNumber: 83,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring pilot trenches are dug in order to locate all underground services.',
    ),
    InspectionTemplateItem(
      itemNumber: 84,
      section: 'Section 7.6 – Preventing Collapse',
      requirement:
          'Ensuring Pilot trenches are always dug using hand tools only in maximum depth steps of 1.2 meters (4 feet), relative to the adjacent ground level',
    ),
    InspectionTemplateItem(
      itemNumber: 85,
      section: 'Section 7.7 – Dewatering',
      requirement:
          'Ensuring suitable dewatering techniques are implemented to prevent water ingress',
    ),
    InspectionTemplateItem(
      itemNumber: 86,
      section: 'Section 7.7 – Dewatering',
      requirement:
          'Construction of required number of trenches to cope up with maximum rainfall expected',
    ),
    InspectionTemplateItem(
      itemNumber: 87,
      section: 'Section 7.7 – Dewatering',
      requirement:
          'Ensuring emergency provisions for dewatering are in place in the event of unexpected rainfall',
    ),
    InspectionTemplateItem(
      itemNumber: 88,
      section: 'Section 7.7 – Dewatering',
      requirement: 'Ensuring Ground De-watering Program is implemented',
    ),
    InspectionTemplateItem(
      itemNumber: 89,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Ensuring continuous supervision is available by competent person at the start of each shift before work begins',
    ),
    InspectionTemplateItem(
      itemNumber: 90,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Ensuring continuous supervision is available by competent person After any event likely to have affected the strength or stability of the excavation',
    ),
    InspectionTemplateItem(
      itemNumber: 91,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Ensuring continuous supervision is available by competent person after any accidental fall of rock, earth or other material',
    ),
    InspectionTemplateItem(
      itemNumber: 92,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Ensuring continuous supervision is available by competent person after every Rainstorm',
    ),
    InspectionTemplateItem(
      itemNumber: 93,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Ensuring continuous supervision is available by competent person after any other events that may increase hazards e.g. windstorm',
    ),
    InspectionTemplateItem(
      itemNumber: 94,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Ensuring continuous supervision is available by competent person during occurrences of fissures, tension cracks, sloughing, undercutting, water seepage, bulging at',
    ),
    InspectionTemplateItem(
      itemNumber: 95,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Ensuring continuous supervision is available by competent person When there is a change in the size, location, or placement of the spoil pile',
    ),
    InspectionTemplateItem(
      itemNumber: 96,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Ensuring continuous supervision is available by competent person When there is any indication of change or movement in adjacent structures',
    ),
    InspectionTemplateItem(
      itemNumber: 97,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Ensuring work is stopped in the event of unsafe environment',
    ),
    InspectionTemplateItem(
      itemNumber: 98,
      section: 'Section 7.8 – Inspection and Supervision',
      requirement:
          'Recurrent inspection of Multi Department personnel to check if underground services are undamaged',
    ),
    InspectionTemplateItem(
      itemNumber: 99,
      section: 'Section 7.9 – Disposal of Spoil & Backfill',
      requirement:
          'Ensuring stop boards / blocks for vehicle approaching excavation edge are fitted no less than 1 meter',
    ),
    InspectionTemplateItem(
      itemNumber: 100,
      section: 'Section 7.10 – Emergency Rescue Equipment',
      requirement:
          'Ensuring the required emergency rescue equipment are provided as required depending on nature of work (e.g. Tunnelling, shoring)',
    ),
    InspectionTemplateItem(
      itemNumber: 101,
      section: 'Section 7.10 – Emergency Rescue Equipment',
      requirement:
          'Ensuring proper training for working personnel has been provided before kick start of work',
    ),
    InspectionTemplateItem(
      itemNumber: 102,
      section: 'Section 7.10 – Emergency Rescue Equipment',
      requirement: 'Lifelines provided for deep or confined excavations',
    ),
    InspectionTemplateItem(
      itemNumber: 103,
      section: 'Section 7.10 – Emergency Rescue Equipment',
      requirement:
          'Evacuation drills conducted regularly for confined or deep excavations',
    ),
    InspectionTemplateItem(
      itemNumber: 104,
      section: 'Section 7.10 – Emergency Rescue Equipment',
      requirement: 'Ensuring Proper Respirator Program has been instituted',
    ),
  ],
);
