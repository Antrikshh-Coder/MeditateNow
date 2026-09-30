class AppUser {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final int currentStreak;
  final int totalSessions;
  final int totalMinutes;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.currentStreak,
    required this.totalSessions,
    required this.totalMinutes,
  });

  factory AppUser.initial() => const AppUser(
    id: 'user-001',
    name: 'Antriksh',
    email: '2024.antrikshs@isu.ac.in',
    avatarUrl: 'assets/images/avatar.png',
    currentStreak: 3,
    totalSessions: 8,
    totalMinutes: 74,
  );

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    int? currentStreak,
    int? totalSessions,
    int? totalMinutes,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentStreak: currentStreak ?? this.currentStreak,
      totalSessions: totalSessions ?? this.totalSessions,
      totalMinutes: totalMinutes ?? this.totalMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'currentStreak': currentStreak,
    'totalSessions': totalSessions,
    'totalMinutes': totalMinutes,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String? ?? 'user-001',
    name: json['name'] as String? ?? 'Antriksh',
    email: json['email'] as String? ?? '',
    avatarUrl: json['avatarUrl'] as String? ?? '',
    currentStreak: json['currentStreak'] as int? ?? 0,
    totalSessions: json['totalSessions'] as int? ?? 0,
    totalMinutes: json['totalMinutes'] as int? ?? 0,
  );
}
