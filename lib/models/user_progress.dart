class UserProgress {
  final int currentStreak;
  final int longestStreak;
  final int totalSessions;
  final int totalMinutes;
  final List<String> completedDates;
  final String? lastSessionDate;

  const UserProgress({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalSessions,
    required this.totalMinutes,
    required this.completedDates,
    this.lastSessionDate,
  });

  factory UserProgress.initial() {
    return UserProgress(
      currentStreak: 3,
      longestStreak: 5,
      totalSessions: 8,
      totalMinutes: 74,
      completedDates: [],
      lastSessionDate: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'totalSessions': totalSessions,
    'totalMinutes': totalMinutes,
    'completedDates': completedDates,
    'lastSessionDate': lastSessionDate,
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
    currentStreak: json['currentStreak'] as int? ?? 0,
    longestStreak: json['longestStreak'] as int? ?? 0,
    totalSessions: json['totalSessions'] as int? ?? 0,
    totalMinutes: json['totalMinutes'] as int? ?? 0,
    completedDates: (json['completedDates'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    lastSessionDate: json['lastSessionDate'] as String?,
  );
}
