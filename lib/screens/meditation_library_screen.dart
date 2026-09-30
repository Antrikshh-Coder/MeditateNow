import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../models/meditation_session.dart';
import '../data/mock_data.dart';
import '../widgets/meditation_card.dart';

class MeditationLibraryScreen extends StatefulWidget {
  final Function(MeditationSession)? onSelectMeditation;
  final Function(MeditationSession)? onStartMeditation;

  const MeditationLibraryScreen({
    super.key,
    this.onSelectMeditation,
    this.onStartMeditation,
  });

  @override
  State<MeditationLibraryScreen> createState() => _MeditationLibraryScreenState();
}

class _MeditationLibraryScreenState extends State<MeditationLibraryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _filterFavoritesOnly = false;

  final List<String> _categories = const [
    'All',
    'Morning',
    'Stress Relief',
    'Focus',
    'Sleep',
    'Anxiety',
    'Self Love',
    'Relaxation',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = MockData.meditations.where((m) {
      final matchesQuery = _searchQuery.isEmpty ||
          m.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.instructor.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCat = _selectedCategory == 'All' || m.category == _selectedCategory;
      final matchesFav = !_filterFavoritesOnly || m.favorite;

      return matchesQuery && matchesCat && matchesFav;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Meditate',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              color: isDark ? AppColors.darkText : AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Find a practice for how you want to feel.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
            ),
          ),
          const SizedBox(height: AppSpacing.s20),

          // Search Field
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search meditations, topics, or instructors...',
              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: AppColors.sage),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r20),
                borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r20),
                borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Favorite Toggle Chip
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: Icon(
                      _filterFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: _filterFavoritesOnly ? AppColors.softPeach : AppColors.forestGreen,
                    ),
                    label: const Text('Favorites'),
                    selected: _filterFavoritesOnly,
                    onSelected: (val) => setState(() => _filterFavoritesOnly = val),
                  ),
                ),
                ..._categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),

          // Grid Results
          if (filtered.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 64),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_off, size: 54, color: AppColors.sage),
                    const SizedBox(height: 14),
                    Text(
                      'No saved practices found',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 22,
                        color: isDark ? AppColors.darkText : AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try another search or explore a category.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextSecondary : Colors.black54,
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
                mainAxisExtent: 295,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final session = filtered[idx];
                return MeditationCard(
                  session: session,
                  onTap: () => widget.onSelectMeditation?.call(session),
                  onStart: () => widget.onStartMeditation?.call(session),
                  onToggleFavorite: () {},
                );
              },
            ),
        ],
      ),
    );
  }
}
