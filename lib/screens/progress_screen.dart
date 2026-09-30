import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/user_progress.dart';
import '../data/mock_data.dart';

class ProgressScreen extends StatelessWidget {
  final UserProgress progress;

  const ProgressScreen({
    super.key,
    this.progress = const UserProgress(
      currentStreak: 3,
      longestStreak: 5,
      totalSessions: 8,
      totalMinutes: 74,
      completedDates: const [],
    ),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final achievements = MockData.achievements;
    final recentSessions = MockData.meditations.take(3).toList();

    final weekDays = [
      {'day': 'Mon', 'active': true},
      {'day': 'Tue', 'active': true},
      {'day': 'Wed', 'active': true},
      {'day': 'Thu', 'active': true},
      {'day': 'Fri', 'active': false},
      {'day': 'Sat', 'active': false},
      {'day': 'Sun', 'active': false},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Your Wellness Journey',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Gentle consistency over rigid perfection. Celebrate every moment of presence.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),

          // Key Metrics Responsive Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              mainAxisExtent: 110,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final metrics = [
                {
                  'title': 'Current Streak',
                  'value': '${progress.currentStreak} days',
                  'icon': Icons.local_fire_department,
                  'color': AppColors.warmAmber,
                },
                {
                  'title': 'Mindful Minutes',
                  'value': '${progress.totalMinutes} min',
                  'icon': Icons.hourglass_bottom,
                  'color': AppColors.sage,
                },
                {
                  'title': 'Total Sessions',
                  'value': '${progress.totalSessions}',
                  'icon': Icons.spa,
                  'color': AppColors.softTeal,
                },
                {
                  'title': 'Longest Streak',
                  'value': '${progress.longestStreak} days',
                  'icon': Icons.military_tech,
                  'color': AppColors.mutedLavender,
                },
              ];
              final item = metrics[index];
              return _MetricCard(
                title: item['title'] as String,
                value: item['value'] as String,
                icon: item['icon'] as IconData,
                iconColor: item['color'] as Color,
              );
            },
          ),
          const SizedBox(height: AppSpacing.s32),

          // Weekly Activity Rhythm
          Text(
            'Weekly Rhythm',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 22,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Container(
            padding: const EdgeInsets.all(AppSpacing.s20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.map((item) {
                final day = item['day'] as String;
                final active = item['active'] as bool;
                return Column(
                  children: [
                    Text(
                      day,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.forestGreen
                            : (isDark ? AppColors.darkSurfaceVariant : AppColors.offWhite),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: active
                            ? const Icon(Icons.check, size: 18, color: AppColors.warmCream)
                            : Text(
                                '—',
                                style: TextStyle(
                                  color: isDark ? Colors.white30 : Colors.black26,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.s32),

          // Recent Sessions Section
          Text(
            'Recent Practices',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 22,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
            ),
            child: Column(
              children: recentSessions.map((session) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.sage.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    child: const Icon(Icons.spa, color: AppColors.sage, size: 20),
                  ),
                  title: Text(
                    session.title,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.forestGreen,
                    ),
                  ),
                  subtitle: Text(
                    '${session.duration} min · Guided by ${session.instructor}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.forestGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      'Completed',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.sage,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.s32),

          // Achievements Badges
          Text(
            'Achievements',
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
              maxCrossAxisExtent: 340,
              mainAxisExtent: 100,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final ach = achievements[index];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.s16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: ach.unlocked
                            ? AppColors.sage.withValues(alpha: 0.2)
                            : (isDark ? AppColors.darkSurfaceVariant : AppColors.offWhite),
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: Icon(
                        ach.unlocked ? Icons.emoji_events : Icons.lock_outline,
                        color: ach.unlocked ? AppColors.forestGreen : Colors.grey,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ach.title,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkText : AppColors.forestGreen,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ach.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
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

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 24,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
        ],
      ),
    );
  }
}
