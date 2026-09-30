class BreathingExercise {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int inhale; // seconds
  final int hold1; // seconds
  final int exhale; // seconds
  final int hold2; // seconds
  final int defaultCycles;
  final List<String> benefits;

  const BreathingExercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.inhale,
    required this.hold1,
    required this.exhale,
    required this.hold2,
    this.defaultCycles = 4,
    this.benefits = const [],
  });

  int get totalCycleSeconds => inhale + hold1 + exhale + hold2;
}
