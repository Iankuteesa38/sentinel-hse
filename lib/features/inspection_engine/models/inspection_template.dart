enum InspectionResponseType { yesNoNa, compliantNonCompliantNa, passFailNa }

class InspectionTemplate {
  final String id;
  final String title;
  final String client;
  final String category;
  final String description;
  final InspectionResponseType responseType;
  final List<InspectionTemplateItem> items;

  const InspectionTemplate({
    required this.id,
    required this.title,
    required this.client,
    required this.category,
    required this.description,
    required this.responseType,
    required this.items,
  });
}

class InspectionTemplateItem {
  final int itemNumber;
  final String section;
  final String requirement;
  final double weight;
  final bool photoAllowed;
  final bool remarksRequiredWhenFailed;

  const InspectionTemplateItem({
    required this.itemNumber,
    required this.section,
    required this.requirement,
    this.weight = 1.0,
    this.photoAllowed = true,
    this.remarksRequiredWhenFailed = true,
  });
}
