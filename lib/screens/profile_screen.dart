import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/app_user.dart';
import '../data/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser user;
  final VoidCallback onOpenSettings;

  const ProfileScreen({
    super.key,
    this.user = const AppUser(
      id: '01',
      name: 'Antriksh',
      email: '2024.antrikshs@isu.ac.in',
      avatarUrl: '',
      currentStreak: 3,
      totalSessions: 8,
      totalMinutes: 74,
    ),
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final achievements = MockData.achievements;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.s24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.forestGreen,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0] : 'A',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 32,
                      color: AppColors.warmCream,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 24,
                          color: isDark ? AppColors.darkText : AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${user.currentStreak} day streak · ${user.totalMinutes} mindful min',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.sage,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: onOpenSettings,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s32),

          // Achievements Section
          Text(
            'Achievements',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 22,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final ach = achievements[idx];
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
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ach.title,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkText : AppColors.forestGreen,
                            ),
                          ),
                          Text(
                            ach.description,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (ach.unlocked)
                      const Icon(Icons.check_circle, color: AppColors.sage, size: 20)
                    else
                      Text(
                        '${(ach.progressPercent * 100).toInt()}%',
                        style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey),
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
