import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

class ResponsiveShell extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<Widget> screens;
  final Widget? miniPlayer;

  const ResponsiveShell({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.screens,
    this.miniPlayer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1200;
        final isTablet = constraints.maxWidth >= 700 && !isDesktop;

        if (isDesktop) {
          // Desktop: 240px Fixed Sidebar + Max 1400px Centered Content Area
          return Scaffold(
            body: Row(
              children: [
                // 240px Fixed Sidebar
                Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    border: Border(
                      right: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      // Header Logo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.forestGreen,
                                borderRadius: BorderRadius.circular(AppRadius.r12),
                                boxShadow: AppShadows.cardLight,
                              ),
                              child: const Center(
                                child: Icon(Icons.spa, color: AppColors.warmCream, size: 22),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MeditateNow',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    letterSpacing: -0.3,
                                    color: isDark ? AppColors.darkText : AppColors.forestGreen,
                                  ),
                                ),
                                Text(
                                  'Find your calm',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.sage,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Nav Items
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          children: [
                            _SidebarItem(
                              icon: Icons.spa_outlined,
                              selectedIcon: Icons.spa,
                              label: 'Home',
                              isSelected: selectedIndex == 0,
                              onTap: () => onDestinationSelected(0),
                            ),
                            const SizedBox(height: 4),
                            _SidebarItem(
                              icon: Icons.self_improvement_outlined,
                              selectedIcon: Icons.self_improvement,
                              label: 'Meditate',
                              isSelected: selectedIndex == 1,
                              onTap: () => onDestinationSelected(1),
                            ),
                            const SizedBox(height: 4),
                            _SidebarItem(
                              icon: Icons.nightlight_round_outlined,
                              selectedIcon: Icons.nightlight_round,
                              label: 'Sleep',
                              isSelected: selectedIndex == 2,
                              onTap: () => onDestinationSelected(2),
                            ),
                            const SizedBox(height: 4),
                            _SidebarItem(
                              icon: Icons.air_outlined,
                              selectedIcon: Icons.air,
                              label: 'Breathe',
                              isSelected: selectedIndex == 3,
                              onTap: () => onDestinationSelected(3),
                            ),
                            const SizedBox(height: 4),
                            _SidebarItem(
                              icon: Icons.insights_outlined,
                              selectedIcon: Icons.insights,
                              label: 'Progress',
                              isSelected: selectedIndex == 4,
                              onTap: () => onDestinationSelected(4),
                            ),
                          ],
                        ),
                      ),

                      // Footer brand hint
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.sage,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Daily Presence',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF8BA090),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Workspace Centered (Max 1400px)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1400),
                            child: IndexedStack(
                              index: selectedIndex,
                              children: screens,
                            ),
                          ),
                        ),
                      ),
                      if (miniPlayer != null)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1400),
                            child: miniPlayer!,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (isTablet) {
          // Tablet: Compact Rail + Adaptive Content
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: NavigationRailLabelType.selected,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: const Center(
                        child: Icon(Icons.spa, color: AppColors.warmCream, size: 20),
                      ),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.spa_outlined),
                      selectedIcon: Icon(Icons.spa),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.self_improvement_outlined),
                      selectedIcon: Icon(Icons.self_improvement),
                      label: Text('Meditate'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.nightlight_round_outlined),
                      selectedIcon: Icon(Icons.nightlight_round),
                      label: Text('Sleep'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.air_outlined),
                      selectedIcon: Icon(Icons.air),
                      label: Text('Breathe'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insights_outlined),
                      selectedIcon: Icon(Icons.insights),
                      label: Text('Progress'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: selectedIndex,
                          children: screens,
                        ),
                      ),
                      if (miniPlayer != null) miniPlayer!,
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // Mobile: Material 3 NavigationBar Bottom Bar
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: screens,
                  ),
                ),
                if (miniPlayer != null) miniPlayer!,
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.spa_outlined),
                  selectedIcon: Icon(Icons.spa),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.self_improvement_outlined),
                  selectedIcon: Icon(Icons.self_improvement),
                  label: 'Meditate',
                ),
                NavigationDestination(
                  icon: Icon(Icons.nightlight_round_outlined),
                  selectedIcon: Icon(Icons.nightlight_round),
                  label: 'Sleep',
                ),
                NavigationDestination(
                  icon: Icon(Icons.air_outlined),
                  selectedIcon: Icon(Icons.air),
                  label: 'Breathe',
                ),
                NavigationDestination(
                  icon: Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights),
                  label: 'Progress',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.forestGreenLight : AppColors.forestGreen)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? AppColors.warmCream
                    : (isDark ? AppColors.darkTextSecondary : const Color(0xFF586B5F)),
                size: 22,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.warmCream
                      : (isDark ? AppColors.darkText : const Color(0xFF1F2421)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
