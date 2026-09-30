import '../data/mock_data.dart';
import '../models/user_progress.dart';
import '../models/achievement.dart';
import '../models/app_user.dart';
import '../services/storage_service.dart';
import '../services/streak_service.dart';

class ProgressRepository {
  UserProgress _progress = UserProgress.initial();
  List<Achievement> _achievements = List.from(MockData.achievements);
  AppUser _user = AppUser.initial();

  UserProgress get progress => _progress;
  List<Achievement> get achievements => List.unmodifiable(_achievements);
  AppUser get user => _user;

  Future<void> init() async {
    _progress = await StorageService.loadProgress();
    _evaluateAchievements();
    _updateUserMetrics();
  }

  Future<void> recordCompletedSession({required int minutes}) async {
    _progress = StreakService.recordSessionCompleted(
      currentProgress: _progress,
      sessionMinutes: minutes,
    );
    await StorageService.saveProgress(_progress);
    _evaluateAchievements();
    _updateUserMetrics();
  }

  void _evaluateAchievements() {
    _achievements = _achievements.map((a) {
      if (a.unlocked) return a;
      
      int currentVal = 0;
      if (a.id == 'first-session') currentVal = _progress.totalSessions;
      if (a.id == '7-day-calm') currentVal = _progress.currentStreak;
      if (a.id == 'early-bird') currentVal = 3;
      if (a.id == 'mindful-explorer') currentVal = 4;
      if (a.id == 'deep-relaxer') currentVal = _progress.totalMinutes;

      final percent = (currentVal / a.requiredValue).clamp(0.0, 1.0);
      final unlocked = currentVal >= a.requiredValue;

      return a.copyWith(
        progressPercent: percent,
        unlocked: unlocked,
      );
    }).toList();
  }

  void _updateUserMetrics() {
    _user = AppUser(
      id: _user.id,
      name: _user.name,
      email: _user.email,
      avatarUrl: _user.avatarUrl,
      currentStreak: _progress.currentStreak,
      totalSessions: _progress.totalSessions,
      totalMinutes: _progress.totalMinutes,
    );
  }

  Future<void> resetProgress() async {
    _progress = UserProgress.initial();
    await StorageService.saveProgress(_progress);
    _evaluateAchievements();
    _updateUserMetrics();
  }
}
