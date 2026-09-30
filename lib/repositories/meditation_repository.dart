import '../data/mock_data.dart';
import '../models/meditation_session.dart';
import '../models/sleep_sound.dart';
import '../models/breathing_exercise.dart';
import '../services/storage_service.dart';

class MeditationRepository {
  List<MeditationSession> _meditations = List.from(MockData.meditations);
  List<SleepSound> _sleepSounds = List.from(MockData.sleepSounds);
  final List<BreathingExercise> _breathingExercises = List.from(MockData.breathingExercises);
  List<String> _favoriteIds = [];

  Future<void> init() async {
    _favoriteIds = await StorageService.loadFavorites();
    _syncFavorites();
  }

  void _syncFavorites() {
    _meditations = _meditations.map((m) {
      return m.copyWith(favorite: _favoriteIds.contains(m.id));
    }).toList();

    _sleepSounds = _sleepSounds.map((s) {
      return s.copyWith(favorite: _favoriteIds.contains(s.id));
    }).toList();
  }

  List<MeditationSession> getAllMeditations() => List.unmodifiable(_meditations);

  List<MeditationSession> getMeditationsByCategory(String category) {
    if (category == 'All') return getAllMeditations();
    return _meditations.where((m) => m.category == category).toList();
  }

  List<MeditationSession> searchMeditations(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAllMeditations();
    return _meditations.where((m) =>
      m.title.toLowerCase().contains(q) ||
      m.description.toLowerCase().contains(q) ||
      m.instructor.toLowerCase().contains(q)
    ).toList();
  }

  List<MeditationSession> getFavoriteMeditations() {
    return _meditations.where((m) => m.favorite).toList();
  }

  List<SleepSound> getAllSleepSounds() => List.unmodifiable(_sleepSounds);

  List<SleepSound> getFavoriteSleepSounds() {
    return _sleepSounds.where((s) => s.favorite).toList();
  }

  List<BreathingExercise> getAllBreathingExercises() => List.unmodifiable(_breathingExercises);

  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    await StorageService.saveFavorites(_favoriteIds);
    _syncFavorites();
  }
}
