import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';

class ProgressService {
  static const String _keyProgress = 'meditatenow_progress';
  static const String _keyFavorites = 'meditatenow_favorites';

  Future<UserProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyProgress);
    if (jsonStr != null) {
      try {
        return UserProgress.fromJson(jsonDecode(jsonStr));
      } catch (_) {}
    }
    return UserProgress.initial();
  }

  Future<UserProgress> recordSession({required int minutes}) async {
    final prefs = await SharedPreferences.getInstance();
    final progress = await loadProgress();

    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

    int newStreak = progress.currentStreak;
    final completedDates = List<String>.from(progress.completedDates);

    if (!completedDates.contains(todayStr)) {
      if (progress.lastSessionDate == yesterdayStr) {
        newStreak += 1;
      } else if (progress.lastSessionDate == todayStr) {
        // Same day: preserve current streak
      } else {
        // Streak reset or fresh start
        newStreak = 1;
      }
      completedDates.add(todayStr);
    }

    final updated = UserProgress(
      currentStreak: newStreak,
      longestStreak: newStreak > progress.longestStreak ? newStreak : progress.longestStreak,
      totalSessions: progress.totalSessions + 1,
      totalMinutes: progress.totalMinutes + minutes,
      completedDates: completedDates,
      lastSessionDate: todayStr,
    );

    await prefs.setString(_keyProgress, jsonEncode(updated.toJson()));
    return updated;
  }

  Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorites) ?? ['morning-stillness', 'rain'];
  }

  Future<List<String>> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_keyFavorites) ?? [];
    if (favs.contains(id)) {
      favs.remove(id);
    } else {
      favs.add(id);
    }
    await prefs.setStringList(_keyFavorites, favs);
    return favs;
  }
}
