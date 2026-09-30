import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';

class StorageService {
  static const String _keyProgress = 'meditatenow_user_progress';
  static const String _keyFavorites = 'meditatenow_favorites';
  static const String _keyThemeMode = 'meditatenow_theme_mode';

  static Future<UserProgress> loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyProgress);
      if (raw != null) {
        return UserProgress.fromJson(jsonDecode(raw));
      }
    } catch (_) {}
    return UserProgress.initial();
  }

  static Future<void> saveProgress(UserProgress progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyProgress, jsonEncode(progress.toJson()));
    } catch (_) {}
  }

  static Future<List<String>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_keyFavorites) ?? ['morning-stillness', 'rain'];
    } catch (_) {
      return ['morning-stillness', 'rain'];
    }
  }

  static Future<void> saveFavorites(List<String> favs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyFavorites, favs);
    } catch (_) {}
  }

  static Future<String> loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyThemeMode) ?? 'light';
    } catch (_) {
      return 'light';
    }
  }

  static Future<void> saveThemeMode(String mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyThemeMode, mode);
    } catch (_) {}
  }
}
