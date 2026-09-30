import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeModeChanged;

  const SettingsScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _notificationsEnabled = true;
  bool _autoplayEnabled = false;
  int _defaultDuration = 10;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.dmSerifDisplay()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title & Subtitle
                Text(
                  'Preferences & Customization',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 32,
                    color: isDark ? AppColors.darkText : AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Personalize your visual theme, session defaults, and audio feedback.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF5E7A63),
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),

                // SECTION 1: APPEARANCE & THEME CARDS
                _buildSectionHeader('Appearance', isDark),
                const SizedBox(height: AppSpacing.s12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 600;
                    final cardWidth = isWide ? (constraints.maxWidth - 32) / 3 : double.infinity;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _ThemeCard(
                          width: cardWidth,
                          title: 'Light Theme',
                          subtitle: 'Clean, warm cream visual aesthetic',
                          icon: Icons.wb_sunny_outlined,
                          isSelected: widget.currentThemeMode == ThemeMode.light,
                          previewColor: AppColors.warmCream,
                          accentColor: AppColors.forestGreen,
                          onTap: () => widget.onThemeModeChanged(ThemeMode.light),
                        ),
                        _ThemeCard(
                          width: cardWidth,
                          title: 'Dark Theme',
                          subtitle: 'Deep charcoal for night relaxation',
                          icon: Icons.nightlight_outlined,
                          isSelected: widget.currentThemeMode == ThemeMode.dark,
                          previewColor: AppColors.darkCharcoal,
                          accentColor: AppColors.sage,
                          onTap: () => widget.onThemeModeChanged(ThemeMode.dark),
                        ),
                        _ThemeCard(
                          width: cardWidth,
                          title: 'System Default',
                          subtitle: 'Syncs automatically with your OS',
                          icon: Icons.desktop_windows_outlined,
                          isSelected: widget.currentThemeMode == ThemeMode.system,
                          previewColor: isDark ? AppColors.darkCharcoal : AppColors.warmCream,
                          accentColor: AppColors.softTeal,
                          onTap: () => widget.onThemeModeChanged(ThemeMode.system),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.s32),

                // SECTION 2: AUDIO & SENSORY PREFERENCES
                _buildSectionHeader('Sensory & Notifications', isDark),
                const SizedBox(height: AppSpacing.s12),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.r24),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
                    ),
                    boxShadow: AppShadows.cardLight,
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.sage.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                          child: const Icon(Icons.volume_up_outlined, color: AppColors.sage, size: 20),
                        ),
                        title: Text(
                          'Sound Effects',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.forestGreen,
                          ),
                        ),
                        subtitle: Text(
                          'Play soft ambient bell chimes on breathing phase transitions',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        value: _soundEnabled,
                        activeTrackColor: AppColors.sage,
                        onChanged: (v) => setState(() => _soundEnabled = v),
                      ),
                      Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                      SwitchListTile(
                        secondary: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.sage.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                          child: const Icon(Icons.vibration, color: AppColors.sage, size: 20),
                        ),
                        title: Text(
                          'Haptic Feedback',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.forestGreen,
                          ),
                        ),
                        subtitle: Text(
                          'Gentle subtle pulse vibrations during mindfulness cues',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        value: _hapticEnabled,
                        activeTrackColor: AppColors.sage,
                        onChanged: (v) => setState(() => _hapticEnabled = v),
                      ),
                      Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                      SwitchListTile(
                        secondary: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.sage.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                          child: const Icon(Icons.notifications_active_outlined, color: AppColors.sage, size: 20),
                        ),
                        title: Text(
                          'Daily Mindfulness Reminder',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.forestGreen,
                          ),
                        ),
                        subtitle: Text(
                          'Receive a gentle daily prompt to take a moment for yourself',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        value: _notificationsEnabled,
                        activeTrackColor: AppColors.sage,
                        onChanged: (v) => setState(() => _notificationsEnabled = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),

                // SECTION 3: MEDITATION DEFAULTS
                _buildSectionHeader('Session Defaults', isDark),
                const SizedBox(height: AppSpacing.s12),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.r24),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
                    ),
                    boxShadow: AppShadows.cardLight,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.sage.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(AppRadius.r12),
                                ),
                                child: const Icon(Icons.timer_outlined, color: AppColors.sage, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Default Session Duration',
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkText : AppColors.forestGreen,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.sage.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              '$_defaultDuration min',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.sage,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.sage,
                          thumbColor: AppColors.forestGreen,
                        ),
                        child: Slider(
                          value: _defaultDuration.toDouble(),
                          min: 5,
                          max: 30,
                          divisions: 5,
                          onChanged: (v) => setState(() => _defaultDuration = v.toInt()),
                        ),
                      ),
                      Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Autoplay Audio Tracks',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.forestGreen,
                          ),
                        ),
                        subtitle: Text(
                          'Automatically start playback when opening a session',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        value: _autoplayEnabled,
                        activeTrackColor: AppColors.sage,
                        onChanged: (v) => setState(() => _autoplayEnabled = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),

                // SECTION 4: ABOUT & SYSTEM STATUS
                _buildSectionHeader('System & About', isDark),
                const SizedBox(height: AppSpacing.s12),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.r24),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
                    ),
                    boxShadow: AppShadows.cardLight,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.forestGreen,
                          borderRadius: BorderRadius.circular(AppRadius.r16),
                        ),
                        child: const Center(
                          child: Icon(Icons.spa, color: AppColors.warmCream, size: 28),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MeditateNow Web Edition',
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 20,
                                color: isDark ? AppColors.darkText : AppColors.forestGreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Version 1.0.0 · Commercial Production Build',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.sage,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Crafted with Material 3 design tokens, Scandinavian minimalist typography, local audio synthesis, and offline-first state persistence.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                height: 1.4,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.dmSerifDisplay(
        fontSize: 22,
        color: isDark ? AppColors.darkText : AppColors.forestGreen,
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final double width;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Color previewColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.width,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.previewColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r20),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r20),
          border: Border.all(
            color: isSelected
                ? AppColors.sage
                : (isDark ? AppColors.darkBorder : AppColors.borderSubtle),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: AppShadows.cardLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: previewColor,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    border: Border.all(color: AppColors.sage.withValues(alpha: 0.3)),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.sage,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: AppColors.forestGreen, size: 14),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.forestGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: isDark ? Colors.white60 : Colors.black54,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
