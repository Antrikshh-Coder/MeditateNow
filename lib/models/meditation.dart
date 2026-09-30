class MeditationSession {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int duration; // in minutes
  final String category;
  final String difficulty;
  final String soundscape;
  final List<String> benefits;
  final List<SessionStep> structure;

  const MeditationSession({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.duration,
    required this.category,
    required this.difficulty,
    required this.soundscape,
    required this.benefits,
    required this.structure,
  });
}

class SessionStep {
  final String step;
  final String title;
  final String desc;

  const SessionStep({
    required this.step,
    required this.title,
    required this.desc,
  });
}
