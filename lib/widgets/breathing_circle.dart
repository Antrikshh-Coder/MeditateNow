import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

enum BreathingPhaseType { inhale, holdIn, exhale, holdOut, ready }

class BreathingCircle extends StatelessWidget {
  final BreathingPhaseType phase;
  final int countdownSeconds;
  final Animation<double> scaleAnimation;
  final int currentCycle;
  final int totalCycles;

  const BreathingCircle({
    super.key,
    required this.phase,
    required this.countdownSeconds,
    required this.scaleAnimation,
    required this.currentCycle,
    required this.totalCycles,
  });

  String get _phaseLabel {
    switch (phase) {
      case BreathingPhaseType.inhale: return 'INHALE';
      case BreathingPhaseType.holdIn: return 'HOLD';
      case BreathingPhaseType.exhale: return 'EXHALE';
      case BreathingPhaseType.holdOut: return 'HOLD';
      case BreathingPhaseType.ready: return 'READY';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 700;
        final baseSize = isDesktop ? 270.0 : 210.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cycle Metadata Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.sage.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                'CYCLE $currentCycle OF $totalCycles',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.sage,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // Animated Expanding / Contracting Visualizer Circle
            AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: scaleAnimation.value,
                  child: Container(
                    width: baseSize,
                    height: baseSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.sage.withValues(alpha: 0.85),
                          AppColors.softTeal.withValues(alpha: 0.4),
                          AppColors.forestGreen.withValues(alpha: 0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sage.withValues(alpha: 0.3),
                          blurRadius: 36 * scaleAnimation.value,
                          spreadRadius: 8 * scaleAnimation.value,
                        )
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _phaseLabel,
                            style: GoogleFonts.manrope(
                              fontSize: isDesktop ? 20 : 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 4,
                              color: AppColors.warmCream,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$countdownSeconds',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: isDesktop ? 54 : 46,
                              fontWeight: FontWeight.normal,
                              color: AppColors.warmCream,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'SECONDS',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppColors.warmCream.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
