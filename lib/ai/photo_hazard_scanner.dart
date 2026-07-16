class PhotoHazardScanner {
  static String analyze(String imageDescription) {
    final description = imageDescription.toLowerCase();
    final hazards = <String>[];

    if (description.contains('helmet') ||
        description.contains('ppe') ||
        description.contains('worker')) {
      hazards.add('Possible PPE hazard detected.');
    }

    if (description.contains('welding') || description.contains('hot work')) {
      hazards.add('Hot work and fire hazard detected.');
    }

    if (description.contains('confined space')) {
      hazards.add('Confined space hazard detected.');
    }

    if (description.contains('height') ||
        description.contains('scaffold') ||
        description.contains('ladder')) {
      hazards.add('Working at height hazard detected.');
    }

    if (hazards.isEmpty) {
      return 'No obvious hazard detected.';
    }

    return hazards.join('\n');
  }
}
