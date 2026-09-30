import '../models/user_progress.dart';

class StreakService {
  /// Evaluates session completion against consecutive calendar days
  static UserProgress recordSessionCompleted({
    required UserProgress currentProgress,
    required int sessionMinutes,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

    int newStreak = currentProgress.currentStreak;
    final completedDates = List<String>.from(currentProgress.completedDates);

    // Rule: Multiple sessions on the same calendar day do not increment streak again
    if (!completedDates.contains(todayStr)) {
      if (currentProgress.lastSessionDate == yesterdayStr) {
        // Practiced yesterday: streak increases
        newStreak += 1;
      } else if (currentProgress.lastSessionDate == todayStr) {
        // Practiced earlier today
      } else {
        // Missed one or more days: reset to 1
        newStreak = 1;
      }
      completedDates.add(todayStr);
    }

    final newLongestStreak = newStreak > currentProgress.longestStreak ? newStreak : currentProgress.longestStreak;
    final newTotalSessions = currentProgress.totalSessions + 1;
    final newTotalMinutes = currentProgress.totalMinutes + sessionMinutes;

    return UserProgress(
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      totalSessions: newTotalSessions,
      totalMinutes: newTotalMinutes,
      completedDates: completedDates,
      lastSessionDate: todayStr,
    );
  }

  /// Calculates whether streak is still active today or if yesterday was maintained
  static bool isStreakActiveToday(UserProgress progress) {
    if (progress.lastSessionDate == null) return false;
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return progress.lastSessionDate == todayStr;
  }
}
