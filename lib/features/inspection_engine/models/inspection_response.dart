enum InspectionAnswer { yes, no, na }

class InspectionResponse {
  final int itemNumber;
  final InspectionAnswer answer;
  final String remarks;
  final List<String> photoPaths;
  final bool findingCreated;

  const InspectionResponse({
    required this.itemNumber,
    required this.answer,
    this.remarks = '',
    this.photoPaths = const [],
    this.findingCreated = false,
  });
}
