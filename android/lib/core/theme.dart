import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoPlayTheme {
  GoPlayTheme._();

  // Brand Colors
  static const Color primary = Color(0xFF00E676);
  static const Color primaryDark = Color(0xFF00C853);
  static const Color surface = Color(0xFF17181C); // Carbon Black
  static const Color surfaceContainerLow = Color(0xFF18181B); // Graphite
  static const Color surfaceContainer = Color(0xFF222326); // Base Card/Container
  static const Color surfaceContainerHigh = Color(0xFF2C2D31); // Elevated Container
  static const Color surfaceContainerHighest = Color(0xFF35373C); // Highly Elevated
  static const Color onSurface = Color(0xFFF3F4F6); // Premium Off-White
  static const Color onSurfaceVariant = Color(0xFF71768E); // Alabaster Grey
  static const Color error = Color(0xFFFF453A); // iOS System Red
  static const Color liveBadge = Color(0xFFFF3B30); // iOS Live Badge Red
  static const Color cardBorder = Color(0x2671768E); // Alabaster Grey @ ~15% opacity

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC17181C), Color(0xFF17181C)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C2D31), Color(0xFF222326)],
  );

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: onSurface,
          letterSpacing: -0.5,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: onSurface),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: onSurfaceVariant),
        bodySmall: textTheme.bodySmall?.copyWith(color: onSurfaceVariant),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        labelSmall: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primary,
        primaryContainer: Color(0xFF003D1A),
        secondary: Color(0xFF80CBC4),
        surface: surface,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        error: error,
        onPrimary: Color(0xFF003300),
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: cardBorder,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: primary,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceContainer,
        indicatorColor: primary.withAlpha(30),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const WidgetStatePropertyAll(
          IconThemeData(size: 22),
        ),
        height: 65,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainerHigh,
        selectedColor: primary.withAlpha(40),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(color: cardBorder, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: cardBorder, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.0),
        ),
        hintStyle: TextStyle(color: onSurfaceVariant.withAlpha(150)),
        prefixIconColor: onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF003300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
