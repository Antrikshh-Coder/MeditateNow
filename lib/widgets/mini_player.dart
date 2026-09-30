import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../services/audio_service.dart';

class GlobalMiniPlayer extends StatefulWidget {
  final VoidCallback? onExpand;

  const GlobalMiniPlayer({super.key, this.onExpand});

  @override
  State<GlobalMiniPlayer> createState() => _GlobalMiniPlayerState();
}

class _GlobalMiniPlayerState extends State<GlobalMiniPlayer> {
  final FlutterAudioService _audioService = FlutterAudioService();

  @override
  void initState() {
    super.initState();
    _audioService.addListener(_onAudioChanged);
  }

  @override
  void dispose() {
    _audioService.removeListener(_onAudioChanged);
    super.dispose();
  }

  void _onAudioChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_audioService.currentTitle == null) {
      return const SizedBox.shrink();
    }

    final isPlaying = _audioService.isPlaying;

    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.forestGreen,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        boxShadow: AppShadows.playerGlow,
        border: Border.all(color: Colors.white12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Real-time position stream progress indicator
          StreamBuilder<Duration>(
            stream: _audioService.positionStream,
            builder: (context, snapshot) {
              final pos = snapshot.data ?? _audioService.position;
              final dur = _audioService.duration ?? const Duration(minutes: 10);
              final totalSecs = dur.inSeconds > 0 ? dur.inSeconds : 600;
              final fraction = (pos.inSeconds / totalSecs).clamp(0.0, 1.0);

              return LinearProgressIndicator(
                value: fraction,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sage),
                minHeight: 3,
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onExpand,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.sage.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: const Center(
                        child: Icon(Icons.spa, color: AppColors.warmCream, size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onExpand,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _audioService.currentTitle ?? 'Now Playing',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              color: AppColors.warmCream,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _audioService.currentSubtitle ?? 'MeditateNow',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.sage,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      color: AppColors.warmCream,
                      size: 36,
                    ),
                    tooltip: isPlaying ? 'Pause' : 'Play',
                    onPressed: () {
                      if (isPlaying) {
                        _audioService.pause();
                      } else {
                        _audioService.play();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white60, size: 20),
                    tooltip: 'Stop & Dismiss',
                    onPressed: () => _audioService.stop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
