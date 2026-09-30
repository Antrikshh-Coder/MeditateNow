import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for MeditateNow following Scandinavian minimalism and Material 3
class AppColors {
  // Brand Palette
  static const Color forestGreen = Color(0xFF163022);
  static const Color forestGreenLight = Color(0xFF244633);
  static const Color sage = Color(0xFF8CA98E);
  static const Color sageLight = Color(0xFFEDF2EE);
  static const Color softTeal = Color(0xFF4A7C72);
  
  // Backgrounds & Surfaces
  static const Color warmCream = Color(0xFFFAF8F5);
  static const Color offWhite = Color(0xFFF4EFEB);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderSubtle = Color(0xFFECEFEA);
  
  // Accents
  static const Color mutedLavender = Color(0xFF9B95B3);
  static const Color softPeach = Color(0xFFE8B89E);
  static const Color warmAmber = Color(0xFFC4673A);
  
  // Dark Theme Colors
  static const Color darkCharcoal = Color(0xFF121614);
  static const Color darkSurface = Color(0xFF1B231F);
  static const Color darkSurfaceVariant = Color(0xFF25322A);
  static const Color darkBorder = Color(0xFF2C3932);
  static const Color darkText = Color(0xFFFAF8F5);
  static const Color darkTextSecondary = Color(0xFFA3B899);
}

class AppSpacing {
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s64 = 64.0;
}

class AppRadius {
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;
  static const double full = 999.0;
}

class AppShadows {
  static List<BoxShadow> get cardLight => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get playerGlow => [
    BoxShadow(
      color: AppColors.forestGreen.withValues(alpha: 0.18),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppTypography {
  static TextTheme textTheme(Color textColor, Color headlineColor) {
    return TextTheme(
      displayLarge: GoogleFonts.dmSerifDisplay(
        fontSize: 48,
        fontWeight: FontWeight.normal,
        color: headlineColor,
        height: 1.15,
      ),
      displayMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 36,
        fontWeight: FontWeight.normal,
        color: headlineColor,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.dmSerifDisplay(
        fontSize: 28,
        fontWeight: FontWeight.normal,
        color: headlineColor,
      ),
      headlineMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 24,
        fontWeight: FontWeight.normal,
        color: headlineColor,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor.withValues(alpha: 0.8),
        height: 1.45,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor.withValues(alpha: 0.65),
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.warmCream,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.forestGreen,
        onPrimary: AppColors.warmCream,
        secondary: AppColors.sage,
        onSecondary: AppColors.forestGreen,
        tertiary: AppColors.softTeal,
        onTertiary: Colors.white,
        error: Color(0xFFBA1A1A),
        onError: Colors.white,
        surface: AppColors.surfaceWhite,
        onSurface: AppColors.forestGreen,
        surfaceContainerHighest: AppColors.offWhite,
        outline: AppColors.borderSubtle,
      ),
      textTheme: AppTypography.textTheme(const Color(0xFF1F2421), AppColors.forestGreen),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r24),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.offWhite,
        selectedColor: AppColors.forestGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
        side: BorderSide.none,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.warmCream,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.forestGreen),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkCharcoal,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.sage,
        onPrimary: AppColors.darkCharcoal,
        secondary: AppColors.softTeal,
        onSecondary: AppColors.darkText,
        tertiary: AppColors.mutedLavender,
        onTertiary: Colors.white,
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkText,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        outline: AppColors.darkBorder,
      ),
      textTheme: AppTypography.textTheme(AppColors.darkText, AppColors.darkText),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r24),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        selectedColor: AppColors.sage,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
        side: BorderSide.none,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkCharcoal,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkText),
      ),
    );
  }
}
