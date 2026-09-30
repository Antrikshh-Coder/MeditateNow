import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/sleep_sound.dart';
import '../data/mock_data.dart';
import '../services/audio_service.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final FlutterAudioService _audioService = FlutterAudioService();
  final List<SleepSound> _sounds = MockData.sleepSounds;

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
    if (mounted) {
      setState(() {});
    }
  }

  void _togglePlaySound(SleepSound sound) {
    if (_audioService.currentId == sound.id) {
      if (_audioService.isPlaying) {
        _audioService.pause();
      } else {
        _audioService.play();
      }
    } else {
      _audioService.loadAndPlayAsset(
        assetPath: sound.audioAsset,
        title: sound.title,
        subtitle: 'Sleep Soundscape · Ambient',
        id: sound.id,
        loop: true,
      );
    }
  }

  void _setSleepTimer(int minutes) {
    if (_audioService.sleepTimerTotalMinutes == minutes) {
      _audioService.cancelSleepTimer();
    } else {
      _audioService.setSleepTimer(minutes);
    }
  }

  String _formatTimer(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remainingSeconds = _audioService.sleepTimerSecondsRemaining;
    final activeTimerMinutes = _audioService.sleepTimerTotalMinutes;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sleep Header
          Text(
            'Sleep Better Tonight',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Gentle ambient soundscapes to quiet conscious thought and ease transition into restorative rest.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),

          // SLEEP TIMER BAR
          Container(
            padding: const EdgeInsets.all(AppSpacing.s20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFF1B232E),
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.white10,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: AppColors.mutedLavender, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Sleep Fade Timer',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (remainingSeconds != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.sage.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          'Active: ${_formatTimer(remainingSeconds)}',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.sage,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [10, 20, 30, 45, 60].map((mins) {
                    final isSelected = activeTimerMinutes == mins;
                    return ChoiceChip(
                      label: Text('$mins min'),
                      selected: isSelected,
                      selectedColor: AppColors.sage,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      labelStyle: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.forestGreen : Colors.white70,
                      ),
                      onSelected: (_) => _setSleepTimer(mins),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s32),

          // Error Banner if Any
          if (_audioService.errorMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.s16),
              padding: const EdgeInsets.all(AppSpacing.s12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.r12),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _audioService.errorMessage!,
                      style: GoogleFonts.manrope(fontSize: 12, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),

          // SOUNDSCAPES RESPONSIVE GRID (3 cols Desktop, 2 Tablet, 1 Mobile)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 380,
              mainAxisExtent: 220,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _sounds.length,
            itemBuilder: (context, idx) {
              final sound = _sounds[idx];
              final isThisActive = _audioService.currentId == sound.id;
              final isThisPlaying = isThisActive && _audioService.isPlaying;

              return Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r24),
                  border: Border.all(
                    color: isThisActive
                        ? AppColors.sage
                        : (isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                    width: isThisActive ? 2 : 1,
                  ),
                  boxShadow: AppShadows.cardLight,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Artwork Top (110px)
                    SizedBox(
                      height: 110,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            sound.artwork,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF1B232E),
                                child: const Center(
                                  child: Icon(Icons.nightlight_round, color: AppColors.mutedLavender, size: 36),
                                ),
                              );
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.2),
                                  Colors.black.withValues(alpha: 0.6),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 14,
                            right: 14,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  sound.title,
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.nightlight, color: Colors.white70, size: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Card Bottom Body
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.s12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sound.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: isDark ? Colors.white60 : Colors.black54,
                                height: 1.3,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isThisPlaying
                                      ? AppColors.forestGreen
                                      : (isDark ? AppColors.darkSurfaceVariant : AppColors.offWhite),
                                  foregroundColor: isThisPlaying
                                      ? AppColors.warmCream
                                      : (isDark ? AppColors.sage : AppColors.forestGreen),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.r12),
                                  ),
                                ),
                                onPressed: () => _togglePlaySound(sound),
                                icon: Icon(isThisPlaying ? Icons.pause : Icons.play_arrow, size: 16),
                                label: Text(
                                  isThisPlaying ? 'Pause Ambient' : 'Play Soundscape',
                                  style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
