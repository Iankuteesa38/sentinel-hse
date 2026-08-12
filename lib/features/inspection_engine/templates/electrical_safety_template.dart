import '../models/inspection_template.dart';

const electricalSafetyTemplate = InspectionTemplate(
  id: 'electrical_safety',
  title: 'Electrical Safety Compliance Checklist',
  client: 'ADNOC',
  category: 'Electrical Safety',
  description:
      'HSE-PSW-CP09 Electrical Safety Corporate Practice Compliance Checklist',
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
      requirement: 'Energy Isolation',
    ),
    InspectionTemplateItem(
      itemNumber: 4,
      section: 'Mandatory Certification/Documentation',
      requirement: 'Lockout/Tagout Program',
    ),
    InspectionTemplateItem(
      itemNumber: 5,
      section: 'Section 7.1 – Overview',
      requirement:
          'Ensuring awareness of the effects of electric current in the human body',
    ),
    InspectionTemplateItem(
      itemNumber: 6,
      section: 'Section 7.2 - Hazards Associated with Electricity',
      requirement:
          'Identification of all the potential hazards associated with electricity as mentioned in the Corporate Practice (i.e. Electrical Shock, Electrical Burns, Fire, Arc Explosion)',
    ),
    InspectionTemplateItem(
      itemNumber: 7,
      section: 'Section 7.3 - Risk Management Process',
      requirement:
          'Risk Assessment for the activity has been performed by Competent and authorized Person',
    ),
    InspectionTemplateItem(
      itemNumber: 8,
      section: 'Section 7.3 - Risk Management Process',
      requirement:
          'The electronic Work Management System (eWMS) is utilized for registration, approval, and tracking of electrical safety–related permits, isolations, and activities in accordance with CP requirements.',
    ),
    InspectionTemplateItem(
      itemNumber: 9,
      section: 'Section 7.3 - Risk Management Process',
      requirement:
          'Implementation of systematic approach for Hierarchy of Controls as per the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 10,
      section: 'Section 7.4.1 – Electrical Equipment Selection and Operation',
      requirement:
          'Ensuring proper selection and design of electrical equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 11,
      section: 'Section 7.4.1 – Electrical Equipment Selection and Operation',
      requirement:
          'Consideration of adverse environmental factors when working on equipment.',
    ),
    InspectionTemplateItem(
      itemNumber: 12,
      section: 'Section 7.4.1 – Electrical Equipment Selection and Operation',
      requirement:
          'Ensuring the use of Certified explosion-protected equipment in places where there could be potentially explosive atmospheres',
    ),
    InspectionTemplateItem(
      itemNumber: 13,
      section: 'Section 7.4.2 – Switchgears',
      requirement:
          'Ensuring the maintenance and operation of switchgear by Competent Person',
    ),
    InspectionTemplateItem(
      itemNumber: 14,
      section: 'Section 7.4.2 – Switchgears',
      requirement:
          'Ensuring strict adherence to manufacturer’s operation manual/instructions for each item of a switchgear and associated ancillary equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 15,
      section: 'Section 7.4.2 – Switchgears',
      requirement:
          'Implementation of periodic inspection for the signs of dampness/water getting in the switchgears',
    ),
    InspectionTemplateItem(
      itemNumber: 16,
      section: 'Section 7.4.2 – Switchgears',
      requirement:
          'Ensuring substation plant separated by fire-resisting barriers',
    ),
    InspectionTemplateItem(
      itemNumber: 17,
      section: 'Section 7.4.2 – Switchgears',
      requirement:
          'Ensuring Fire-extinguishing systems using extinguishing mediums such as fire suppressant gases are installed',
    ),
    InspectionTemplateItem(
      itemNumber: 18,
      section: 'Section 7.4.2 – Switchgears',
      requirement: 'Ensuring portable fire-extinguishers are provided',
    ),
    InspectionTemplateItem(
      itemNumber: 19,
      section: 'Section 7.4.3 – Switchboards and Distribution Boards',
      requirement:
          'Ensuring the Switchboards and distribution boards are kept free from materials that would cause an electrical hazard',
    ),
    InspectionTemplateItem(
      itemNumber: 20,
      section: 'Section 7.4.3 – Switchboards and Distribution Boards',
      requirement:
          'Ensuring the Switchboards and distribution boards are enclosed and guarded against unauthorized entry',
    ),
    InspectionTemplateItem(
      itemNumber: 21,
      section: 'Section 7.4.4 – Portable Electric Equipment',
      requirement:
          'Ensuring the portable electric equipment are properly inspected, maintained & certified',
    ),
    InspectionTemplateItem(
      itemNumber: 22,
      section: 'Section 7.4.5 – Mobile Generator Sets',
      requirement:
          'Ensuring the frame and neutral of mobile generator are connected to earth',
    ),
    InspectionTemplateItem(
      itemNumber: 23,
      section: 'Section 7.4.5 – Mobile Generator Sets',
      requirement:
          'Ensuring mobile generator sets are provided with over-current devices',
    ),
    InspectionTemplateItem(
      itemNumber: 24,
      section: 'Section 7.4.5 – Mobile Generator Sets',
      requirement:
          'Ensuring mobile generator sets with ratings of 50kVA and above are provided with earth fault protection devices',
    ),
    InspectionTemplateItem(
      itemNumber: 25,
      section: 'Section 7.4.5 – Mobile Generator Sets',
      requirement:
          'Ensuring mobile generators sets are provided with a means of isolating the generator supply from the distribution system',
    ),
    InspectionTemplateItem(
      itemNumber: 26,
      section: 'Section 7.4.6 – Welding',
      requirement: 'Ensuring electric welding machines are of DC type',
    ),
    InspectionTemplateItem(
      itemNumber: 27,
      section: 'Section 7.4.6 – Welding',
      requirement:
          'Ensuring written approval in case AC type welding machines are used',
    ),
    InspectionTemplateItem(
      itemNumber: 28,
      section: 'Section 7.4.6 – Welding',
      requirement:
          'Ensuring a return cable is always connected between the workpiece and the welding machine',
    ),
    InspectionTemplateItem(
      itemNumber: 29,
      section: 'Section 7.4.7 – Battery Rooms',
      requirement:
          'Ensuring conducting a formal risk assessment for work on battery system',
    ),
    InspectionTemplateItem(
      itemNumber: 30,
      section: 'Section 7.4.7 – Battery Rooms',
      requirement:
          'Ensuring accessibility to Authorized person for each battery room or battery enclosure',
    ),
    InspectionTemplateItem(
      itemNumber: 31,
      section: 'Section 7.4.7 – Battery Rooms',
      requirement:
          'Ensuring proper illuminations are provided for entering battery rooms',
    ),
    InspectionTemplateItem(
      itemNumber: 32,
      section: 'Section 7.4.7 – Battery Rooms',
      requirement:
          'Ensuring electrical hazard warnings signs are displayed indicating the shock hazard due to the battery voltage and the arc flash hazard due to prospective shorth circuit current at the Battery rooms',
    ),
    InspectionTemplateItem(
      itemNumber: 33,
      section: 'Section 7.4.7 – Battery Rooms',
      requirement:
          'Ensuring battery cell ventilation openings are unobstructed',
    ),
    InspectionTemplateItem(
      itemNumber: 34,
      section: 'Section 7.4.7 – Battery Rooms',
      requirement:
          'Batery room should be well ventilated with properly designed ventilation system, e.g exhaust fans',
    ),
    InspectionTemplateItem(
      itemNumber: 35,
      section: 'Section 7.4.7 – Battery Rooms',
      requirement:
          'Emergency eye wash shall be installed in the battery room, ensuring proper inspection and maintenance',
    ),
    InspectionTemplateItem(
      itemNumber: 36,
      section: 'Section 7.4.8 – Plugs and Sockets Outlets',
      requirement:
          'Implementation of the requirements set in BS EN 60309 & BS 1363 as applicable to the plugs and sockets outlet',
    ),
    InspectionTemplateItem(
      itemNumber: 37,
      section: 'Section 7.4.8 – Plugs and Sockets Outlets',
      requirement:
          'Ensuring use of three pin plugs with suitable fuse protection',
    ),
    InspectionTemplateItem(
      itemNumber: 38,
      section: 'Section 7.4.9 – Earthing & Bonding',
      requirement:
          'Implementation for de-energizing, isolating & earthing the electrical equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 39,
      section: 'Section 7.4.9 – Earthing & Bonding',
      requirement: 'Ensuring Earthing is carried out by a Competent person',
    ),
    InspectionTemplateItem(
      itemNumber: 40,
      section: 'Section 7.4.9 – Earthing & Bonding',
      requirement:
          'Ensuring earth notices are attached after closing the earth',
    ),
    InspectionTemplateItem(
      itemNumber: 41,
      section: 'Section 7.4.9 – Earthing & Bonding',
      requirement:
          'Ensuring the earth connection are achieved by bonding the object to earth with cable(s) clamped to the structure and having a minimum cross sectional area of 70 mm2',
    ),
    InspectionTemplateItem(
      itemNumber: 42,
      section: 'Section 7.4.9 – Earthing & Bonding',
      requirement:
          'Ensuring the resistance to earth is maximum of 10 Ω and preferably less than 4 Ω',
    ),
    InspectionTemplateItem(
      itemNumber: 43,
      section: 'Section 7.4.9 – Earthing & Bonding',
      requirement:
          'Ensuring the main bonding jumper and equipment bonding jumper are sized and selected correctly',
    ),
    InspectionTemplateItem(
      itemNumber: 44,
      section: 'Section 7.4.9 – Earthing & Bonding',
      requirement:
          'All tanks, vessels and process lines shall be properly grounded and bonded to prevent accumulation of static electricity. This involves connecting all conductive parts to the earth, creating a continuous path for electrical current.',
    ),
    InspectionTemplateItem(
      itemNumber: 45,
      section: 'Section 7.4.10 – Leads & Extension Cords',
      requirement:
          'Implementation of appropriate material for leads and extension cords (i.e. rubber insulated and sheathed with heavy duty neoprene)',
    ),
    InspectionTemplateItem(
      itemNumber: 46,
      section: 'Section 7.4.10 – Leads & Extension Cords',
      requirement: 'Homemade extension cords shall not be used',
    ),
    InspectionTemplateItem(
      itemNumber: 47,
      section: 'Section 7.4.11 – Fuses & Circuit Breakers',
      requirement:
          'Ensuring fuses are maintained free of breaks or cracks in fuse cases, ferrules and insulators',
    ),
    InspectionTemplateItem(
      itemNumber: 48,
      section: 'Section 7.4.11 – Fuses & Circuit Breakers',
      requirement:
          'Confirming the voltage rating on the fuse is equal to or greater than device’s operating voltage',
    ),
    InspectionTemplateItem(
      itemNumber: 49,
      section: 'Section 7.4.11 – Fuses & Circuit Breakers',
      requirement:
          'Ensuring circuit breakers that interrupt faults approaching their interrupting ratings are inspected and tested in accordance with manufacturer’s recommendations',
    ),
    InspectionTemplateItem(
      itemNumber: 50,
      section: 'Section 7.4.12 – Lightning Protection',
      requirement: 'Ensuring implementation proper lightning protection',
    ),
    InspectionTemplateItem(
      itemNumber: 51,
      section: 'Section 7.4.13 – Access Control',
      requirement:
          'Implementation of IP based Access Control System with documented authorization matrix in place for entering into restricted rooms and buildings',
    ),
    InspectionTemplateItem(
      itemNumber: 52,
      section: 'Section 7.4.13 – Access Control',
      requirement:
          'Ensuring availability of 1 Control door with entry/Exit card reader',
    ),
    InspectionTemplateItem(
      itemNumber: 53,
      section: 'Section 7.4.13 – Access Control',
      requirement:
          'Ensuring all the other doors in Substation are uncontrolled and equipped with a magnetic lock and push bar for Emergency Exit',
    ),
    InspectionTemplateItem(
      itemNumber: 54,
      section: 'Section 7.4.13 – Access Control',
      requirement:
          'System Logic for Emergency Exit applied as mandated in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 55,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement: 'Implementation of documented lockout/tagout program',
    ),
    InspectionTemplateItem(
      itemNumber: 56,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement:
          'Ensuring Locks/tags are installed only on circuit disconnecting means',
    ),
    InspectionTemplateItem(
      itemNumber: 57,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement: 'Use of unique locks and tags for easy identification',
    ),
    InspectionTemplateItem(
      itemNumber: 58,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement: 'Lock out device includes a lock – keyed or combination',
    ),
    InspectionTemplateItem(
      itemNumber: 59,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement:
          'Method of identification of the installer for the lockout device',
    ),
    InspectionTemplateItem(
      itemNumber: 60,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement:
          'Ensuring lockout devices are attached to prevent operation of the disconnecting means without resorting to undue force or the use of tools',
    ),
    InspectionTemplateItem(
      itemNumber: 61,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement:
          'Ensuring Tags contain a statement prohibiting unauthorized operation of the disconnecting means or removal of the tag',
    ),
    InspectionTemplateItem(
      itemNumber: 62,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement:
          'Prohibiting unauthorized operation/removal mentioned on the tag',
    ),
    InspectionTemplateItem(
      itemNumber: 63,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement:
          'Provision for securing locking keys (e.g. lockout boxes, padlock cupboards/lockout stations, key safes etc.)',
    ),
    InspectionTemplateItem(
      itemNumber: 64,
      section: 'Section 7.4.15 – Lockout Tagout',
      requirement:
          'Implementation of sequence for lockout/tagout procedures as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 65,
      section: 'Section 7.4.16 – Limits of Approach',
      requirement:
          'Arc Flash Hazard Analysis conducted and controls implemented',
    ),
    InspectionTemplateItem(
      itemNumber: 66,
      section: 'Section 7.4.16 – Limits of Approach',
      requirement:
          'Ensuring personnel never crosses the restricted approach boundary, where special shock protection techniques and equipment are required',
    ),
    InspectionTemplateItem(
      itemNumber: 67,
      section: 'Section 7.4.16 – Limits of Approach',
      requirement:
          'Ensuring each Group Company establishes arc flash protection procedure and implement',
    ),
    InspectionTemplateItem(
      itemNumber: 68,
      section: 'Section 7.4.16 – Limits of Approach',
      requirement:
          'Arc Flash labels posted for all High Voltage & Low Voltage Switchgears',
    ),
    InspectionTemplateItem(
      itemNumber: 69,
      section: 'Section 7.4.17 – PPE for Electrical Work',
      requirement:
          'Implementation for the use of all necessary PPE as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 70,
      section: 'Section 7.4.17 – PPE for Electrical Work',
      requirement:
          'Ensuring all electrical conductors are covered with insulating material',
    ),
    InspectionTemplateItem(
      itemNumber: 71,
      section: 'Section 7.5.1 – Authorization Levels',
      requirement:
          'Implementation of the minimum authorization levels as mentioned in the Corporate Practice (i.e. Competent Electrical Personnel for HV and LV Systems)',
    ),
    InspectionTemplateItem(
      itemNumber: 72,
      section: 'Section 7.5.1 – Authorization Levels',
      requirement:
          'Ensuring the Group Company have a proper documentation of the Authorization Levels and implement the same',
    ),
    InspectionTemplateItem(
      itemNumber: 73,
      section: 'Section 7.5.2 – Working Near Overhead Lines and Equipment',
      requirement:
          'Implementation of Overhead Line Policy as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 74,
      section: 'Section 7.5.2 – Working Near Overhead Lines and Equipment',
      requirement:
          'Ensuring personnel do not place themselves in close proximity to overhead lines',
    ),
    InspectionTemplateItem(
      itemNumber: 75,
      section: 'Section 7.5.2 – Working Near Overhead Lines and Equipment',
      requirement:
          'Ensuring warning signs are posted on cranes and similar equipment with a minimum clearance of 3m (10 ft)',
    ),
    InspectionTemplateItem(
      itemNumber: 76,
      section: 'Section 7.5.2 – Working Near Overhead Lines and Equipment',
      requirement:
          'Ensuring a spotter is designated when equipment is working near overhead lines and to direct the operator accordingly',
    ),
    InspectionTemplateItem(
      itemNumber: 77,
      section: 'Section 7.5.2 – Working Near Overhead Lines and Equipment',
      requirement:
          'Ensuring warning cones are used as visible indicators of 3m (10 ft) safety zone when working near overhead power lines',
    ),
    InspectionTemplateItem(
      itemNumber: 78,
      section: 'Section 7.5.2 – Working Near Overhead Lines and Equipment',
      requirement:
          'Implementation of “Look up and Live Flags” as mandated in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 79,
      section: 'Section 7.5.3 – Working on High Voltage',
      requirement:
          'Implementation of all safety aspects for working on High Voltage as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 80,
      section: 'Section 7.5.4 – Working in Potentially Flammable Atmosphere',
      requirement:
          'Use of intrinsically safe equipment while working in flammable atmosphere',
    ),
    InspectionTemplateItem(
      itemNumber: 81,
      section: 'Section 7.5.5 – Working on Low Voltage',
      requirement:
          'Implementation of all safety aspects for working on Low Voltage as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 82,
      section: 'Section 7.5.6 – Working on Live Electrical Lines',
      requirement:
          'Implementation of all safety aspects for working on Live Electrical Lines as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 83,
      section: 'Section 7.5.7 – Live Line Washing Practices',
      requirement:
          'Implementation of all safety aspects for Live Line Washing as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 84,
      section: 'Section 7.5.8 – Switching Power Systems',
      requirement:
          'Implementation of Switching programmes as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 85,
      section: 'Section 7.5.8 – Switching Power Systems',
      requirement:
          'Implementation of all safety aspects for High Voltage Switching as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 86,
      section: 'Section 7.5.8 – Switching Power Systems',
      requirement:
          'Implementation of all safety aspects for Low Voltage Switching as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 87,
      section: 'Section 7.5.9 – Working on Cathodic Protection',
      requirement:
          'Implementation of all safety aspects for Cathodic Protection as mentioned in the Corporate Practice',
    ),
    InspectionTemplateItem(
      itemNumber: 88,
      section:
          'Section 7.5.10 – Work with Portable (Hand-Held) Electrical Apparatus',
      requirement:
          'Ensuring Hand-held, tools and equipment shall be designed to operate at rated voltage of 110V (in the case of portable inspection hand lamps 24V',
    ),
    InspectionTemplateItem(
      itemNumber: 89,
      section:
          'Section 7.5.10 – Work with Portable (Hand-Held) Electrical Apparatus',
      requirement:
          'Use of only Class II or Class III portable electrical equipment for hand-held tools',
    ),
    InspectionTemplateItem(
      itemNumber: 90,
      section: 'Section 7.6 - Electrical Isolation (De-Energization)',
      requirement:
          'Isolating (de-energizing) all the electrical equipment from its power source during any work on electrical equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 91,
      section: 'Section 7.6 - Electrical Isolation (De-Energization)',
      requirement:
          'Implementation of isolation padlocks (lock out devices) to prevent de-isolation',
    ),
    InspectionTemplateItem(
      itemNumber: 92,
      section: 'Section 7.6 - Electrical Isolation (De-Energization)',
      requirement:
          'Caution notices (tagout tags) attached at all points of isolation from live sources of supply',
    ),
    InspectionTemplateItem(
      itemNumber: 93,
      section:
          'Section 7.7 - Electrical Equipment Maintenance, Inspection and Testing',
      requirement:
          'Implementation of Inspection, testing and maintenance programs',
    ),
    InspectionTemplateItem(
      itemNumber: 94,
      section: 'Section 7.8 - Disposal of Electrical Equipment',
      requirement: 'Implementation of safe electrical waste disposal',
    ),
    InspectionTemplateItem(
      itemNumber: 95,
      section: 'Section 7.9 - Hazard Communication',
      requirement:
          'Implementation of highly visible, clear graphic warning signs including Tag outs and notice signs',
    ),
    InspectionTemplateItem(
      itemNumber: 96,
      section: 'Section 7.10 - Emergency Response',
      requirement:
          'Implementation of all necessary emergency response arrangements',
    ),
    InspectionTemplateItem(
      itemNumber: 97,
      section: 'Section 7.10 - Emergency Response',
      requirement: 'Implementation of proper Rescue Plan',
    ),
    InspectionTemplateItem(
      itemNumber: 98,
      section: 'Section 7.11 - Training and Competency',
      requirement:
          'Trained and Competent Person used for all works on or near electrical equipment',
    ),
    InspectionTemplateItem(
      itemNumber: 99,
      section: 'Section 7.11 - Training and Competency',
      requirement:
          'Personnel utilizing the eWMS for electrical safety–related activities have received adequate training and competency verification specific to the eWMS platform.',
    ),
  ],
);
