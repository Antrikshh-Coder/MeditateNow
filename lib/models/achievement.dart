class Achievement {
  final String id;
  final String title;
  final String description;
  final int requiredValue;
  final bool unlocked;
  final double progressPercent; // 0.0 to 1.0
  final String iconName;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredValue,
    this.unlocked = false,
    this.progressPercent = 0.0,
    required this.iconName,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    int? requiredValue,
    bool? unlocked,
    double? progressPercent,
    String? iconName,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      requiredValue: requiredValue ?? this.requiredValue,
      unlocked: unlocked ?? this.unlocked,
      progressPercent: progressPercent ?? this.progressPercent,
      iconName: iconName ?? this.iconName,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'requiredValue': requiredValue,
    'unlocked': unlocked,
    'progressPercent': progressPercent,
    'iconName': iconName,
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    requiredValue: json['requiredValue'] as int,
    unlocked: json['unlocked'] as bool? ?? false,
    progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0.0,
    iconName: json['iconName'] as String,
  );
}
