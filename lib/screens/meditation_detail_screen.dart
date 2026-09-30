import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/meditation_session.dart';

class MeditationDetailScreen extends StatelessWidget {
  final MeditationSession session;
  final VoidCallback onStartSession;
  final VoidCallback onToggleFavorite;

  const MeditationDetailScreen({
    super.key,
    required this.session,
    required this.onStartSession,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(session.title, style: GoogleFonts.dmSerifDisplay()),
        actions: [
          IconButton(
            icon: Icon(
              session.favorite ? Icons.favorite : Icons.favorite_border,
              color: session.favorite ? AppColors.softPeach : null,
            ),
            onPressed: onToggleFavorite,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;

          if (isWide) {
            // Desktop 2-column Layout
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.s32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Artwork (Controlled Width max 420px)
                      SizedBox(
                        width: 400,
                        child: Column(
                          children: [
                            Container(
                              height: 380,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppRadius.r32),
                                boxShadow: AppShadows.cardLight,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    session.artwork,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(color: AppColors.forestGreen);
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.4),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.forestGreen,
                                  foregroundColor: AppColors.warmCream,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.r16),
                                  ),
                                ),
                                onPressed: onStartSession,
                                icon: const Icon(Icons.play_arrow, size: 24),
                                label: Text(
                                  'Start Session (${session.duration} min)',
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s40),

                      // Right Column: Details & Benefits
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Chip(label: Text(session.category.toUpperCase())),
                                const SizedBox(width: 8),
                                Chip(label: Text('${session.duration} min')),
                                const SizedBox(width: 8),
                                Chip(label: Text(session.difficulty)),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s16),
                            Text(
                              session.title,
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 36,
                                color: isDark ? AppColors.darkText : AppColors.forestGreen,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  '${session.rating}',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark ? AppColors.darkText : AppColors.forestGreen,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Guided by ${session.instructor}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    color: AppColors.sage,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s24),
                            Text(
                              session.description,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                height: 1.6,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s32),
                            Text(
                              'Key Benefits of This Practice',
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 24,
                                color: isDark ? AppColors.darkText : AppColors.forestGreen,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s16),
                            ...session.benefits.map((benefit) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle, color: AppColors.sage, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      benefit,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        height: 1.4,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // Mobile Single-column Layout
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      session.artwork,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: AppColors.forestGreen);
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Row(
                    children: [
                      Chip(label: Text(session.category.toUpperCase())),
                      const SizedBox(width: 8),
                      Chip(label: Text('${session.duration} min')),
                      const SizedBox(width: 8),
                      Chip(label: Text(session.difficulty)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    session.title,
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 28,
                      color: isDark ? AppColors.darkText : AppColors.forestGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Guided by ${session.instructor} · Rating: ${session.rating} ★',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.sage,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  Text(
                    session.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Text(
                    'Benefits of this practice',
                    style: GoogleFonts.dmSerifDisplay(fontSize: 20),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  ...session.benefits.map((benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, color: AppColors.sage, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            benefit,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: AppSpacing.s32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.forestGreen,
                        foregroundColor: AppColors.warmCream,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                      ),
                      onPressed: onStartSession,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(
                        'Start Session (${session.duration} min)',
                        style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
