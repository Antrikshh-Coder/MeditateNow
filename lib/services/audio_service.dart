import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

enum PlaybackStatus { initial, loading, playing, paused, completed, error }

class FlutterAudioService extends ChangeNotifier {
  static final FlutterAudioService _instance = FlutterAudioService._internal();
  factory FlutterAudioService() => _instance;
  FlutterAudioService._internal() {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();

  PlaybackStatus _status = PlaybackStatus.initial;
  String? _currentId;
  String? _currentTitle;
  String? _currentSubtitle;
  String? _currentAsset;
  String? _errorMessage;
  bool _isLooping = false;

  int? _targetDurationSeconds;
  Duration _virtualPosition = Duration.zero;
  Timer? _virtualPositionTimer;
  final StreamController<Duration> _virtualPositionController = StreamController<Duration>.broadcast();

  Timer? _sleepTimer;
  int? _sleepTimerSecondsRemaining;
  int? _sleepTimerTotalMinutes;

  PlaybackStatus get status => _status;
  bool get isPlaying => _status == PlaybackStatus.playing;
  bool get isPaused => _status == PlaybackStatus.paused;
  bool get isLoading => _status == PlaybackStatus.loading;
  String? get currentId => _currentId;
  String? get currentTitle => _currentTitle;
  String? get currentSubtitle => _currentSubtitle;
  String? get currentAsset => _currentAsset;
  String? get errorMessage => _errorMessage;
  bool get isLooping => _isLooping;

  int? get sleepTimerSecondsRemaining => _sleepTimerSecondsRemaining;
  int? get sleepTimerTotalMinutes => _sleepTimerTotalMinutes;

  Stream<Duration> get positionStream =>
      _targetDurationSeconds != null ? _virtualPositionController.stream : _player.positionStream;

  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Duration get position =>
      _targetDurationSeconds != null ? _virtualPosition : _player.position;

  Duration? get duration {
    if (_targetDurationSeconds != null) {
      return Duration(seconds: _targetDurationSeconds!);
    }
    return _player.duration;
  }

  double get volume => _player.volume;

  void _init() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_targetDurationSeconds == null) {
          _status = PlaybackStatus.completed;
          notifyListeners();
        }
      } else if (state.playing) {
        _status = PlaybackStatus.playing;
        notifyListeners();
      } else {
        if (_status != PlaybackStatus.loading && _status != PlaybackStatus.initial) {
          _status = PlaybackStatus.paused;
          notifyListeners();
        }
      }
    });

    _player.positionStream.listen((pos) {
      if (_targetDurationSeconds == null) {
        notifyListeners();
      }
    });

    _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace st) {
      if (kDebugMode) {
        print('Audio playback stream error: $e');
      }
      _status = PlaybackStatus.error;
      _errorMessage = 'Playback error: $e';
      notifyListeners();
    });
  }

  void _startVirtualTimer() {
    _virtualPositionTimer?.cancel();
    if (_targetDurationSeconds == null) return;

    _virtualPositionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_status == PlaybackStatus.playing) {
        final nextSec = _virtualPosition.inSeconds + 1;
        if (nextSec >= _targetDurationSeconds!) {
          _virtualPosition = Duration(seconds: _targetDurationSeconds!);
          if (!_virtualPositionController.isClosed) {
            _virtualPositionController.add(_virtualPosition);
          }
          timer.cancel();
          _virtualPositionTimer = null;
          _player.stop();
          _status = PlaybackStatus.completed;
          notifyListeners();
        } else {
          _virtualPosition = Duration(seconds: nextSec);
          if (!_virtualPositionController.isClosed) {
            _virtualPositionController.add(_virtualPosition);
          }
          notifyListeners();
        }
      }
    });
  }

  Future<void> loadAndPlayAsset({
    required String assetPath,
    required String title,
    String? subtitle,
    String? id,
    bool loop = false,
    int? targetDurationSeconds,
  }) async {
    try {
      _virtualPositionTimer?.cancel();
      _virtualPosition = Duration.zero;
      _targetDurationSeconds = targetDurationSeconds;

      _currentId = id;
      _currentTitle = title;
      _currentSubtitle = subtitle;
      _currentAsset = assetPath;
      _isLooping = loop || (targetDurationSeconds != null);
      _status = PlaybackStatus.loading;
      _errorMessage = null;
      notifyListeners();

      // Ensure proper loop mode for sleep sounds vs guided tracks
      await _player.setLoopMode((loop || targetDurationSeconds != null) ? LoopMode.one : LoopMode.off);

      // Load asset with automatic format fallback (.wav <-> .mp3)
      try {
        await _player.setAsset(assetPath);
      } catch (e) {
        final fallbackPath = assetPath.endsWith('.mp3')
            ? assetPath.replaceAll('.mp3', '.wav')
            : assetPath.replaceAll('.wav', '.mp3');
        try {
          await _player.setAsset(fallbackPath);
          _currentAsset = fallbackPath;
        } catch (e2) {
          rethrow;
        }
      }

      // Play audio
      await _player.play();
      _status = PlaybackStatus.playing;
      if (_targetDurationSeconds != null) {
        if (!_virtualPositionController.isClosed) {
          _virtualPositionController.add(_virtualPosition);
        }
        _startVirtualTimer();
      }
      notifyListeners();
    } catch (e) {
      _status = PlaybackStatus.error;
      _errorMessage = 'Unable to play $title. Please check audio file in $assetPath.';
      if (kDebugMode) {
        print('Audio loading error for $assetPath: $e');
      }
      notifyListeners();
    }
  }

  Future<void> play() async {
    try {
      await _player.play();
      _status = PlaybackStatus.playing;
      _startVirtualTimer();
      notifyListeners();
    } catch (e) {
      _status = PlaybackStatus.error;
      _errorMessage = 'Failed to resume audio playback.';
      notifyListeners();
    }
  }

  Future<void> pause() async {
    try {
      _virtualPositionTimer?.cancel();
      await _player.pause();
      _status = PlaybackStatus.paused;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Pause error: $e');
    }
  }

  Future<void> stop() async {
    try {
      _virtualPositionTimer?.cancel();
      await _player.stop();
      _status = PlaybackStatus.initial;
      _currentTitle = null;
      _currentSubtitle = null;
      _currentId = null;
      _currentAsset = null;
      _targetDurationSeconds = null;
      _virtualPosition = Duration.zero;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Stop error: $e');
    }
  }

  Future<void> seek(Duration targetPosition) async {
    try {
      if (_targetDurationSeconds != null) {
        final clampedSecs = targetPosition.inSeconds.clamp(0, _targetDurationSeconds!);
        _virtualPosition = Duration(seconds: clampedSecs);
        if (!_virtualPositionController.isClosed) {
          _virtualPositionController.add(_virtualPosition);
        }
        
        final assetDurationMs = _player.duration?.inMilliseconds ?? 10000;
        if (assetDurationMs > 0) {
          final sampleSeekMs = (targetPosition.inMilliseconds) % assetDurationMs;
          await _player.seek(Duration(milliseconds: sampleSeekMs));
        }
        notifyListeners();
      } else {
        await _player.seek(targetPosition);
      }
    } catch (e) {
      if (kDebugMode) print('Seek error: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Set volume error: $e');
    }
  }

  void setSleepTimer(int minutes, {VoidCallback? onFinished}) {
    cancelSleepTimer();
    _sleepTimerTotalMinutes = minutes;
    _sleepTimerSecondsRemaining = minutes * 60;
    notifyListeners();

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sleepTimerSecondsRemaining == null || _sleepTimerSecondsRemaining! <= 1) {
        timer.cancel();
        _sleepTimer = null;
        _sleepTimerSecondsRemaining = null;
        _sleepTimerTotalMinutes = null;
        stop();
        if (onFinished != null) {
          onFinished();
        }
        notifyListeners();
      } else {
        _sleepTimerSecondsRemaining = _sleepTimerSecondsRemaining! - 1;
        notifyListeners();
      }
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepTimerSecondsRemaining = null;
    _sleepTimerTotalMinutes = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _virtualPositionTimer?.cancel();
    _virtualPositionController.close();
    _player.dispose();
    super.dispose();
  }
}


