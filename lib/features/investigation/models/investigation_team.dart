class InvestigationTeamMember {
  final String name;
  final String role;
  final String company;
  final String investigationResponsibility;

  final bool independentFromIncident;
  final bool conflictOfInterestDeclared;

  const InvestigationTeamMember({
    required this.name,
    required this.role,
    required this.company,
    required this.investigationResponsibility,
    required this.independentFromIncident,
    required this.conflictOfInterestDeclared,
  });
}

class InvestigationTermsOfReference {
  final String investigationScope;
  final String objectives;
  final String exclusions;

  final DateTime investigationStartDate;
  final DateTime requiredCompletionDate;

  final String investigationAuthority;
  final String technicalSpecialistsRequired;

  const InvestigationTermsOfReference({
    required this.investigationScope,
    required this.objectives,
    required this.exclusions,
    required this.investigationStartDate,
    required this.requiredCompletionDate,
    required this.investigationAuthority,
    required this.technicalSpecialistsRequired,
  });
}
