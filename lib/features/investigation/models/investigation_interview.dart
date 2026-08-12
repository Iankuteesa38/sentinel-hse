enum InterviewStatementType {
  directObservation,
  opinion,
  assumption,
  hearsay,
  technicalExplanation,
}

class InvestigationInterview {
  final String interviewId;

  final String personName;
  final String role;
  final String company;

  final DateTime interviewDate;

  final List<String> interviewers;

  final String statementSummary;
  final String directObservations;
  final String assumptionsOrHearsay;

  final String contradictions;
  final String corroboratingEvidence;

  final String followUpRequired;
  final bool signedStatementAvailable;

  const InvestigationInterview({
    required this.interviewId,
    required this.personName,
    required this.role,
    required this.company,
    required this.interviewDate,
    required this.interviewers,
    required this.statementSummary,
    required this.directObservations,
    required this.assumptionsOrHearsay,
    required this.contradictions,
    required this.corroboratingEvidence,
    required this.followUpRequired,
    required this.signedStatementAvailable,
  });
}
