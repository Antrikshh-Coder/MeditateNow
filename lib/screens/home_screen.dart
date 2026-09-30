import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/meditation_session.dart';
import '../models/user_progress.dart';
import '../data/mock_data.dart';
import '../widgets/meditation_card.dart';

class HomeScreen extends StatelessWidget {
  final UserProgress progress;
  final Function(MeditationSession) onSelectMeditation;
  final Function(MeditationSession) onStartMeditation;
  final VoidCallback onQuickBreathe;
  final VoidCallback onQuickSleep;
  final VoidCallback? onOpenSettings;

  const HomeScreen({
    super.key,
    this.progress = const UserProgress(
      currentStreak: 3,
      longestStreak: 5,
      totalSessions: 8,
      totalMinutes: 74,
      completedDates: const [],
    ),
    required this.onSelectMeditation,
    required this.onStartMeditation,
    required this.onQuickBreathe,
    required this.onQuickSleep,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final featured = MockData.meditations.first;
    final recommended = MockData.meditations.skip(1).take(3).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good morning'
        : (now.hour < 17 ? 'Good afternoon' : 'Good evening');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Streak Top Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, Antriksh',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 32,
                      color: isDark ? AppColors.darkText : AppColors.forestGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Take a few minutes for yourself today.',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
                    ),
                  ),
                ],
              ),
              // Settings & Streak Badge
              Row(
                children: [
                  if (onOpenSettings != null)
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: AppColors.sage, size: 24),
                      onPressed: onOpenSettings,
                      tooltip: 'Settings',
                    ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.warmAmber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(color: AppColors.warmAmber.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department, color: AppColors.warmAmber, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '${progress.currentStreak} Day Streak',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warmAmber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),

          // HERO: "YOUR MOMENT OF CALM" WITH ARTWORK BLEND
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.r32),
              boxShadow: AppShadows.playerGlow,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Background Artwork Image
                Positioned.fill(
                  child: Image.asset(
                    featured.artwork,
                    fit: BoxFit.cover,
                  ),
                ),
                // Organic Forest Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.forestGreen.withValues(alpha: 0.94),
                          const Color(0xFF1E382A).withValues(alpha: 0.90),
                          const Color(0xFF102016).withValues(alpha: 0.96),
                        ],
                      ),
                    ),
                  ),
                ),

                // Hero Content Padding
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.sage.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                              border: Border.all(color: AppColors.sage.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              'YOUR MOMENT OF CALM',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: AppColors.sage,
                              ),
                            ),
                          ),
                          Text(
                            '${featured.duration} min · ${featured.difficulty}',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warmCream.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s20),
                      Text(
                        featured.title,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 36,
                          color: AppColors.warmCream,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"${featured.description}"',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: AppColors.warmCream.withValues(alpha: 0.85),
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s24),

                      // Metrics Pill Strip inside Hero
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _HeroMetricPill(
                            icon: Icons.local_fire_department,
                            iconColor: AppColors.warmAmber,
                            label: '${progress.currentStreak} Streak',
                          ),
                          _HeroMetricPill(
                            icon: Icons.spa,
                            iconColor: AppColors.sage,
                            label: '${progress.totalSessions} Sessions',
                          ),
                          _HeroMetricPill(
                            icon: Icons.hourglass_bottom,
                            iconColor: AppColors.softTeal,
                            label: '${progress.totalMinutes} Mins Mindful',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s24),

                      // CTA Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sage,
                          foregroundColor: AppColors.forestGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                          ),
                        ),
                        onPressed: () => onStartMeditation(featured),
                        icon: const Icon(Icons.play_arrow, size: 22),
                        label: Text(
                          'Begin Session (${featured.duration} min)',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s32),

          // QUICK PRACTICES
          Text(
            'Quick Practices',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 22,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            children: [
              Expanded(
                child: _QuickPracticeItem(
                  icon: Icons.air,
                  title: 'Breathe',
                  duration: '2 min',
                  onTap: onQuickBreathe,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: _QuickPracticeItem(
                  icon: Icons.nightlight_round,
                  title: 'Sleep',
                  duration: '15 min',
                  onTap: onQuickSleep,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: _QuickPracticeItem(
                  icon: Icons.spa,
                  title: 'Meditate',
                  duration: '5 min',
                  onTap: () => onStartMeditation(featured),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s32),

          // RECOMMENDED FOR YOU
          Text(
            'Recommended For You',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 22,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 360,
              mainAxisExtent: 295,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: recommended.length,
            itemBuilder: (context, idx) {
              final session = recommended[idx];
              return MeditationCard(
                session: session,
                onTap: () => onSelectMeditation(session),
                onStart: () => onStartMeditation(session),
                onToggleFavorite: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroMetricPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _HeroMetricPill({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.warmCream,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickPracticeItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String duration;
  final VoidCallback onTap;

  const _QuickPracticeItem({
    required this.icon,
    required this.title,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r20),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r20),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
          boxShadow: AppShadows.cardLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.sage.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(icon, color: AppColors.sage, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.forestGreen,
              ),
            ),
            Text(
              duration,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
