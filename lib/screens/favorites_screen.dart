import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/meditation_session.dart';
import '../data/mock_data.dart';
import '../widgets/meditation_card.dart';

class FavoritesScreen extends StatelessWidget {
  final Function(MeditationSession)? onSelectMeditation;
  final Function(MeditationSession)? onStartMeditation;

  const FavoritesScreen({
    super.key,
    this.onSelectMeditation,
    this.onStartMeditation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteMeditations = MockData.meditations.where((m) => m.favorite).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Favorites',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your personal collection of restorative practices and tranquil soundscapes.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),

          if (favoriteMeditations.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 64),
                child: Column(
                  children: [
                    const Icon(Icons.favorite_border, size: 48, color: AppColors.softPeach),
                    const SizedBox(height: 16),
                    Text(
                      'Your calm collection is empty.',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 22,
                        color: isDark ? AppColors.darkText : AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save your favorite sessions with the heart icon to access them quickly here.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 360,
                mainAxisExtent: 280,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favoriteMeditations.length,
              itemBuilder: (context, idx) {
                final session = favoriteMeditations[idx];
                return MeditationCard(
                  session: session,
                  onTap: () => onSelectMeditation?.call(session),
                  onStart: () => onStartMeditation?.call(session),
                  onToggleFavorite: () {},
                );
              },
            ),
        ],
      ),
    );
  }
}
