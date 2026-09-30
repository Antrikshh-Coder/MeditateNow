class MeditationSession {
  final String id;
  final String title;
  final String description;
  final String category;
  final int duration; // in minutes
  final String difficulty;
  final String artwork;
  final String instructor;
  final double rating;
  final bool favorite;
  final bool completed;
  final List<String> benefits;
  final String audioAsset;

  const MeditationSession({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.artwork,
    required this.instructor,
    this.rating = 4.9,
    this.favorite = false,
    this.completed = false,
    this.benefits = const [],
    required this.audioAsset,
  });

  MeditationSession copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? duration,
    String? difficulty,
    String? artwork,
    String? instructor,
    double? rating,
    bool? favorite,
    bool? completed,
    List<String>? benefits,
    String? audioAsset,
  }) {
    return MeditationSession(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      artwork: artwork ?? this.artwork,
      instructor: instructor ?? this.instructor,
      rating: rating ?? this.rating,
      favorite: favorite ?? this.favorite,
      completed: completed ?? this.completed,
      benefits: benefits ?? this.benefits,
      audioAsset: audioAsset ?? this.audioAsset,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'duration': duration,
    'difficulty': difficulty,
    'artwork': artwork,
    'instructor': instructor,
    'rating': rating,
    'favorite': favorite,
    'completed': completed,
    'benefits': benefits,
    'audioAsset': audioAsset,
  };

  factory MeditationSession.fromJson(Map<String, dynamic> json) => MeditationSession(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: json['category'] as String,
    duration: json['duration'] as int,
    difficulty: json['difficulty'] as String,
    artwork: json['artwork'] as String,
    instructor: json['instructor'] as String,
    rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
    favorite: json['favorite'] as bool? ?? false,
    completed: json['completed'] as bool? ?? false,
    benefits: (json['benefits'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    audioAsset: json['audioAsset'] as String? ?? 'assets/audio/meditation.mp3',
  );
}
