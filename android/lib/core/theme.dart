import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoPlayTheme {
  GoPlayTheme._();

  // --- Brand Colors ---
  static const Color primary = Color(0xFF00ADB5);
  static const Color primaryDark = Color(0xFF008A91);
  static const Color error = Color(0xFFFF453A); // iOS System Red
  static const Color liveBadge = Color(0xFFFF3B30); // iOS Live Badge Red
  
  // --- Dark Mode Colors ---
  static const Color darkSurface = Color(0xFF17181C); // Carbon Black
  static const Color darkSurfaceContainerLow = Color(0xFF18181B); // Graphite
  static const Color darkSurfaceContainer = Color(0xFF222326); // Base Card/Container
  static const Color darkSurfaceContainerHigh = Color(0xFF2C2D31); // Elevated
  static const Color darkOnSurface = Color(0xFFF3F4F6); // Premium Off-White
  static const Color darkOnSurfaceVariant = Color(0xFF71768E); // Alabaster Grey
  static const Color darkCardBorder = Color(0x2671768E); 

  // --- Light Mode Colors (Newly Added) ---
  static const Color lightSurface = Color(0xFFF8F9FA); 
  static const Color lightSurfaceContainerLow = Color(0xFFFFFFFF); 
  static const Color lightSurfaceContainer = Color(0xFFF3F4F6); 
  static const Color lightSurfaceContainerHigh = Color(0xFFE5E7EB); 
  static const Color lightOnSurface = Color(0xFF111827); 
  static const Color lightOnSurfaceVariant = Color(0xFF4B5563); 
  static const Color lightCardBorder = Color(0x1A000000); 

  // --- Legacy / Compatibility Colors (to prevent breaking other files referencing static colors) ---
  static const Color surface = darkSurface;
  static const Color surfaceContainerLow = darkSurfaceContainerLow;
  static const Color surfaceContainer = darkSurfaceContainer;
  static const Color surfaceContainerHigh = darkSurfaceContainerHigh;
  static const Color surfaceContainerHighest = Color(0xFF35373C);
  static const Color onSurface = darkOnSurface;
  static const Color onSurfaceVariant = darkOnSurfaceVariant;
  static const Color cardBorder = darkCardBorder;

  // --- Gradients ---
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

  // --- Base Text Theme ---
  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }

  // ==========================================
  //               DARK THEME
  // ==========================================
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    final textTheme = _buildTextTheme(base.textTheme).apply(
      bodyColor: darkOnSurface,
      displayColor: darkOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkSurface,
      textTheme: textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium?.copyWith(color: darkOnSurfaceVariant),
        bodySmall: textTheme.bodySmall?.copyWith(color: darkOnSurfaceVariant),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primary,
        primaryContainer: Color(0xFF003D1A),
        secondary: Color(0xFF80CBC4),
        surface: darkSurface,
        surfaceContainerLow: darkSurfaceContainerLow,
        surfaceContainer: darkSurfaceContainer,
        surfaceContainerHigh: darkSurfaceContainerHigh,
        error: error,
        onPrimary: Color(0xFF003300),
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnSurfaceVariant,
        outline: darkCardBorder,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: primary,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: darkOnSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurfaceContainer,
        indicatorColor: primary.withAlpha(30),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        iconTheme: const WidgetStatePropertyAll(IconThemeData(size: 22)),
        height: 65,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceContainerHigh,
        selectedColor: primary.withAlpha(40),
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(color: darkCardBorder, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      cardTheme: CardThemeData(
        color: darkSurfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkCardBorder, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkCardBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkCardBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.0),
        ),
        hintStyle: TextStyle(color: darkOnSurfaceVariant.withAlpha(150)),
        prefixIconColor: darkOnSurfaceVariant,
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

  // ==========================================
  //               LIGHT THEME
  // ==========================================
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    final textTheme = _buildTextTheme(base.textTheme).apply(
      bodyColor: lightOnSurface,
      displayColor: lightOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightSurface,
      textTheme: textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium?.copyWith(color: lightOnSurfaceVariant),
        bodySmall: textTheme.bodySmall?.copyWith(color: lightOnSurfaceVariant),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryDark,
        primaryContainer: Color(0xFFB9F6CA),
        secondary: Color(0xFF26A69A),
        surface: lightSurface,
        surfaceContainerLow: lightSurfaceContainerLow,
        surfaceContainer: lightSurfaceContainer,
        surfaceContainerHigh: lightSurfaceContainerHigh,
        error: error,
        onPrimary: Colors.white,
        onSurface: lightOnSurface,
        onSurfaceVariant: lightOnSurfaceVariant,
        outline: lightCardBorder,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: primaryDark,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: lightOnSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurfaceContainer,
        indicatorColor: primary.withAlpha(40),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        iconTheme: const WidgetStatePropertyAll(IconThemeData(size: 22)),
        height: 65,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurfaceContainerHigh,
        selectedColor: primary.withAlpha(50),
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(color: lightCardBorder, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      cardTheme: CardThemeData(
        color: lightSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightCardBorder, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightCardBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightCardBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryDark, width: 1.0),
        ),
        hintStyle: TextStyle(color: lightOnSurfaceVariant.withAlpha(150)),
        prefixIconColor: lightOnSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
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
