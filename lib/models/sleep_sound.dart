class SleepSound {
  final String id;
  final String title;
  final String description;
  final String audioAsset;
  final String artwork;
  final String category;
  final bool favorite;

  const SleepSound({
    required this.id,
    required this.title,
    required this.description,
    required this.audioAsset,
    required this.artwork,
    this.category = 'Nature',
    this.favorite = false,
  });

  SleepSound copyWith({
    String? id,
    String? title,
    String? description,
    String? audioAsset,
    String? artwork,
    String? category,
    bool? favorite,
  }) {
    return SleepSound(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      audioAsset: audioAsset ?? this.audioAsset,
      artwork: artwork ?? this.artwork,
      category: category ?? this.category,
      favorite: favorite ?? this.favorite,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'audioAsset': audioAsset,
    'artwork': artwork,
    'category': category,
    'favorite': favorite,
  };

  factory SleepSound.fromJson(Map<String, dynamic> json) => SleepSound(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    audioAsset: json['audioAsset'] as String,
    artwork: json['artwork'] as String,
    category: json['category'] as String? ?? 'Nature',
    favorite: json['favorite'] as bool? ?? false,
  );
}
