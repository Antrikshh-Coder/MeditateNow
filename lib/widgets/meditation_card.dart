import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/meditation_session.dart';

class MeditationCard extends StatelessWidget {
  final MeditationSession session;
  final VoidCallback onTap;
  final VoidCallback onStart;
  final VoidCallback onToggleFavorite;

  const MeditationCard({
    super.key,
    required this.session,
    required this.onTap,
    required this.onStart,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
          width: 1,
        ),
        boxShadow: AppShadows.cardLight,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork Image Stack (165px height)
            SizedBox(
              height: 165,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    session.artwork,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.forestGreen,
                        child: const Center(
                          child: Icon(Icons.spa, color: AppColors.sage, size: 48),
                        ),
                      );
                    },
                  ),
                  // Dark Gradient Overlay Scrim
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),

                  // Top Header: Category badge & Favorite Button
                  Positioned(
                    top: 12,
                    left: 14,
                    right: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            session.category.toUpperCase(),
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onToggleFavorite,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              session.favorite ? Icons.favorite : Icons.favorite_border,
                              color: session.favorite ? AppColors.softPeach : Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Artwork Overlay: Duration & Play Button
                  Positioned(
                    bottom: 12,
                    left: 14,
                    right: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.schedule, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${session.duration} min · ${session.difficulty}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: onStart,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: AppColors.sage,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow, color: AppColors.forestGreen, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Card Body Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 18,
                        color: isDark ? AppColors.darkText : AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Guided by ${session.instructor}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      session.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
