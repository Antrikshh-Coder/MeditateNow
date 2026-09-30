import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'models/meditation_session.dart';
import 'repositories/meditation_repository.dart';
import 'repositories/progress_repository.dart';
import 'screens/home_screen.dart';
import 'screens/meditation_library_screen.dart';
import 'screens/meditation_detail_screen.dart';
import 'screens/meditation_player_screen.dart';
import 'screens/sleep_screen.dart';
import 'screens/breathing_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/responsive_shell.dart';
import 'widgets/mini_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MeditateNowApp());
}

class MeditateNowApp extends StatefulWidget {
  const MeditateNowApp({super.key});

  @override
  State<MeditateNowApp> createState() => _MeditateNowAppState();
}

class _MeditateNowAppState extends State<MeditateNowApp> {
  ThemeMode _themeMode = ThemeMode.light;
  final MeditationRepository _meditationRepo = MeditationRepository();
  final ProgressRepository _progressRepo = ProgressRepository();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _meditationRepo.init();
    await _progressRepo.init();
    setState(() {});
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeditateNow - Find your calm',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: MainAppContainer(
        meditationRepo: _meditationRepo,
        progressRepo: _progressRepo,
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
    );
  }
}

class MainAppContainer extends StatefulWidget {
  final MeditationRepository meditationRepo;
  final ProgressRepository progressRepo;
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeModeChanged;

  const MainAppContainer({
    super.key,
    required this.meditationRepo,
    required this.progressRepo,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<MainAppContainer> createState() => _MainAppContainerState();
}

class _MainAppContainerState extends State<MainAppContainer> {
  int _selectedIndex = 0;
  MeditationSession? _activePlayerSession;
  bool _isPlayerOpen = false;

  void _openDetail(MeditationSession session) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MeditationDetailScreen(
          session: session,
          onStartSession: () {
            Navigator.of(context).pop();
            _startPlayer(session);
          },
          onToggleFavorite: () async {
            await widget.meditationRepo.toggleFavorite(session.id);
            setState(() {});
          },
        ),
      ),
    );
  }

  void _startPlayer(MeditationSession session) async {
    setState(() {
      _activePlayerSession = session;
      _isPlayerOpen = true;
    });

    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => MeditationPlayerScreen(
          session: session,
          onSessionCompleted: () async {
            await widget.progressRepo.recordCompletedSession(minutes: session.duration);
            setState(() {});
          },
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );

    if (mounted) {
      setState(() {
        _isPlayerOpen = false;
      });
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          currentThemeMode: widget.themeMode,
          onThemeModeChanged: widget.onThemeModeChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        progress: widget.progressRepo.progress,
        onSelectMeditation: _openDetail,
        onStartMeditation: _startPlayer,
        onQuickBreathe: () => setState(() => _selectedIndex = 3),
        onQuickSleep: () => setState(() => _selectedIndex = 2),
        onOpenSettings: _openSettings,
      ),
      MeditationLibraryScreen(
        onSelectMeditation: _openDetail,
        onStartMeditation: _startPlayer,
      ),
      const SleepScreen(),
      BreathingScreen(
        onSessionCompleted: () async {
          await widget.progressRepo.recordCompletedSession(minutes: 2);
          setState(() {});
        },
      ),
      ProgressScreen(progress: widget.progressRepo.progress),
    ];

    return ResponsiveShell(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
      screens: screens,
      miniPlayer: !_isPlayerOpen
          ? GlobalMiniPlayer(
              onExpand: () {
                if (_activePlayerSession != null) {
                  _startPlayer(_activePlayerSession!);
                }
              },
            )
          : null,
    );
  }
}
