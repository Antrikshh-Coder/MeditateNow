import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/meditation_session.dart';
import '../services/audio_service.dart';

class MeditationPlayerScreen extends StatefulWidget {
  final MeditationSession session;
  final VoidCallback onSessionCompleted;
  final VoidCallback onClose;

  const MeditationPlayerScreen({
    super.key,
    required this.session,
    required this.onSessionCompleted,
    required this.onClose,
  });

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen> with SingleTickerProviderStateMixin {
  final FlutterAudioService _audioService = FlutterAudioService();
  late AnimationController _animController;
  bool _hasTriggeredCompletion = false;

  @override
  void initState() {
    super.initState();
    _audioService.addListener(_onAudioChanged);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // If this session is not already playing in the global service, start it
    if (_audioService.currentId != widget.session.id || !_audioService.isPlaying) {
      _audioService.loadAndPlayAsset(
        assetPath: widget.session.audioAsset,
        title: widget.session.title,
        subtitle: '${widget.session.duration} min · ${widget.session.category}',
        id: widget.session.id,
        loop: true,
        targetDurationSeconds: widget.session.duration * 60,
      );
    }

    if (_audioService.isPlaying) {
      _animController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _audioService.removeListener(_onAudioChanged);
    _animController.dispose();
    super.dispose();
  }

  void _onAudioChanged() {
    if (!mounted) return;

    if (_audioService.isPlaying && !_animController.isAnimating) {
      _animController.repeat(reverse: true);
    } else if (!_audioService.isPlaying && _animController.isAnimating) {
      _animController.stop();
    }

    if (_audioService.status == PlaybackStatus.completed && !_hasTriggeredCompletion) {
      _hasTriggeredCompletion = true;
      widget.onSessionCompleted();
    }

    setState(() {});
  }

  void _togglePlayPause() {
    if (_audioService.isPlaying) {
      _audioService.pause();
    } else {
      _audioService.play();
    }
  }

  void _seekRelative(int seconds) {
    final current = _audioService.position;
    final total = _audioService.duration ?? Duration(minutes: widget.session.duration);
    final target = current + Duration(seconds: seconds);
    final clamped = target < Duration.zero ? Duration.zero : (target > total ? total : target);
    _audioService.seek(clamped);
  }

  String _formatTime(int totalSecs) {
    if (totalSecs < 0) totalSecs = 0;
    final m = totalSecs ~/ 60;
    final s = totalSecs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _audioService.isPlaying;
    final isLoading = _audioService.isLoading;
    return Scaffold(
      backgroundColor: const Color(0xFF131D17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.warmCream, size: 28),
          onPressed: widget.onClose,
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.session.favorite ? Icons.favorite : Icons.favorite_border,
              color: widget.session.favorite ? AppColors.softPeach : AppColors.warmCream,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32, vertical: AppSpacing.s16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Error banner if any
              if (_audioService.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _audioService.errorMessage!,
                          style: GoogleFonts.manrope(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

              // Animated Pulse Artwork
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  final scale = 0.95 + (_animController.value * 0.08);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.sage.withValues(alpha: 0.6),
                            AppColors.forestGreen.withValues(alpha: 0.8),
                            const Color(0xFF0F1A13),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.sage.withValues(alpha: 0.2),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(color: AppColors.warmCream)
                            : const Icon(Icons.spa, color: AppColors.warmCream, size: 64),
                      ),
                    ),
                  );
                },
              ),

              // Title & Instructor
              Column(
                children: [
                  Text(
                    widget.session.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 28,
                      color: AppColors.warmCream,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Guided by ${widget.session.instructor}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.sage,
                    ),
                  ),
                ],
              ),

              // Scrubber & Actual Progress Time with StreamBuilder
              StreamBuilder<Duration>(
                stream: _audioService.positionStream,
                builder: (context, snapshot) {
                  final pos = snapshot.data ?? _audioService.position;
                  final fallbackDuration = Duration(minutes: widget.session.duration);
                  final dur = (_audioService.duration != null && _audioService.duration!.inMilliseconds > 0)
                      ? _audioService.duration!
                      : fallbackDuration;

                  final totalSecs = dur.inSeconds > 0 ? dur.inSeconds : widget.session.duration * 60;
                  final elapsedSecs = pos.inSeconds;
                  final fraction = totalSecs > 0 ? (elapsedSecs / totalSecs).clamp(0.0, 1.0) : 0.0;

                  return Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                          activeTrackColor: AppColors.sage,
                          inactiveTrackColor: Colors.white12,
                          thumbColor: AppColors.warmCream,
                        ),
                        child: Slider(
                          value: fraction,
                          onChanged: (val) {
                            final targetMs = (val * dur.inMilliseconds).round();
                            _audioService.seek(Duration(milliseconds: targetMs));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTime(elapsedSecs),
                              style: GoogleFonts.manrope(fontSize: 12, color: Colors.white60),
                            ),
                            Text(
                              _formatTime(totalSecs),
                              style: GoogleFonts.manrope(fontSize: 12, color: Colors.white60),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Playback Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: Colors.white70, size: 28),
                    onPressed: () => _seekRelative(-10),
                  ),
                  const SizedBox(width: 24),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.sage,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sage.withValues(alpha: 0.35),
                          blurRadius: 18,
                        )
                      ],
                    ),
                    child: IconButton(
                      icon: isLoading
                          ? const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.forestGreen),
                            )
                          : Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: AppColors.forestGreen,
                              size: 34,
                            ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: Colors.white70, size: 28),
                    onPressed: () => _seekRelative(10),
                  ),
                ],
              ),

              // Volume Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.volume_down, color: Colors.white60, size: 18),
                  SizedBox(
                    width: 140,
                    child: Slider(
                      value: _audioService.volume,
                      min: 0.0,
                      max: 1.0,
                      activeColor: AppColors.sage,
                      inactiveColor: Colors.white12,
                      onChanged: (v) => _audioService.setVolume(v),
                    ),
                  ),
                  const Icon(Icons.volume_up, color: Colors.white60, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
