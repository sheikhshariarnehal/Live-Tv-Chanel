import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// GoPlay design system.
///
/// A modern, minimal, professional dark theme (with a matching light theme)
/// built for Material 3. The dark theme is the primary experience — a true
/// near-black canvas, a single confident accent color, restrained borders,
/// and consistent elevation via tonal surfaces instead of shadows.
class GoPlayTheme {
  GoPlayTheme._();

  // ==========================================
  //               BRAND COLORS
  // ==========================================
  static const Color primary = Color(0xFF00ADB5); // Teal accent
  static const Color primaryDark = Color(0xFF008A91);
  static const Color primaryLight = Color(0xFF4DD8DE);
  static const Color secondary = Color(0xFF80CBC4);
  static const Color error = Color(0xFFFF453A);
  static const Color success = Color(0xFF32D74B);
  static const Color warning = Color(0xFFFFB020);
  static const Color liveBadge = Color(0xFFFF3B30);

  // ==========================================
  //             DARK MODE PALETTE
  // ==========================================
  // Neutral, near-black canvas with subtle tonal steps — no muddy color
  // cast, so the teal accent stays the only thing competing for attention.
  static const Color darkSurface = Color(0xFF0E0F11); // App background
  static const Color darkSurfaceContainerLow = Color(0xFF141519);
  static const Color darkSurfaceContainer = Color(0xFF1B1C20); // Cards
  static const Color darkSurfaceContainerHigh = Color(0xFF232428); // Elevated
  static const Color darkSurfaceContainerHighest = Color(0xFF2C2D31);
  static const Color darkOnSurface = Color(0xFFF5F5F7); // Primary text
  static const Color darkOnSurfaceVariant = Color(0xFF9A9CA8); // Secondary text
  static const Color darkOnSurfaceMuted = Color(0xFF6B6D78); // Tertiary text
  static const Color darkCardBorder = Color(0x1FFFFFFF); // Hairline border
  static const Color darkDivider = Color(0x14FFFFFF);
  static const Color darkPrimaryContainer = Color(0xFF00363A);
  static const Color darkOnPrimaryContainer = Color(0xFF7FE9EF);
  static const Color darkOnPrimary = Color(0xFF00282B);

  // ==========================================
  //             LIGHT MODE PALETTE
  // ==========================================
  static const Color lightSurface = Color(0xFFF8F9FA);
  static const Color lightSurfaceContainerLow = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFF3F4F6);
  static const Color lightSurfaceContainerHigh = Color(0xFFE9EAEC);
  static const Color lightSurfaceContainerHighest = Color(0xFFE0E1E4);
  static const Color lightOnSurface = Color(0xFF111417);
  static const Color lightOnSurfaceVariant = Color(0xFF4B4F58);
  static const Color lightOnSurfaceMuted = Color(0xFF7A7E87);
  static const Color lightCardBorder = Color(0x14000000);
  static const Color lightDivider = Color(0x0F000000);
  static const Color lightPrimaryContainer = Color(0xFFD4F4F5);
  static const Color lightOnPrimaryContainer = Color(0xFF00363A);

  // --- Legacy / compatibility aliases (kept so existing references don't break) ---
  static const Color surface = darkSurface;
  static const Color surfaceContainerLow = darkSurfaceContainerLow;
  static const Color surfaceContainer = darkSurfaceContainer;
  static const Color surfaceContainerHigh = darkSurfaceContainerHigh;
  static const Color surfaceContainerHighest = darkSurfaceContainerHighest;
  static const Color onSurface = darkOnSurface;
  static const Color onSurfaceVariant = darkOnSurfaceVariant;
  static const Color cardBorder = darkCardBorder;

  // ==========================================
  //                GRADIENTS
  // ==========================================
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC0E0F11), Color(0xFF0E0F11)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF232428), Color(0xFF1B1C20)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, primaryDark],
  );

  // ==========================================
  //               TEXT THEME
  // ==========================================
  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.4),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.4),
    );
  }

  // ==========================================
  //               DARK THEME
  // ==========================================
  static final ThemeData darkTheme = _buildDarkTheme();

  static ThemeData _buildDarkTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = _buildTextTheme(base.textTheme).apply(
      bodyColor: darkOnSurface,
      displayColor: darkOnSurface,
    );

    const colorScheme = ColorScheme.dark(
      primary: primary,
      onPrimary: darkOnPrimary,
      primaryContainer: darkPrimaryContainer,
      onPrimaryContainer: darkOnPrimaryContainer,
      secondary: secondary,
      onSecondary: Color(0xFF00332F),
      surface: darkSurface,
      surfaceContainerLowest: Color(0xFF08090A),
      surfaceContainerLow: darkSurfaceContainerLow,
      surfaceContainer: darkSurfaceContainer,
      surfaceContainerHigh: darkSurfaceContainerHigh,
      surfaceContainerHighest: darkSurfaceContainerHighest,
      onSurface: darkOnSurface,
      onSurfaceVariant: darkOnSurfaceVariant,
      error: error,
      onError: Colors.white,
      outline: darkCardBorder,
      outlineVariant: darkDivider,
      inverseSurface: darkOnSurface,
      onInverseSurface: darkSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkSurface,
      canvasColor: darkSurface,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      textTheme: textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium?.copyWith(color: darkOnSurfaceVariant),
        bodySmall: textTheme.bodySmall?.copyWith(color: darkOnSurfaceMuted),
      ),

      // --- System UI ---
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: darkOnSurface, size: 22),
        actionsIconTheme: const IconThemeData(color: darkOnSurfaceVariant, size: 22),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurfaceContainerLow,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        indicatorColor: primary.withAlpha(38),
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? darkOnSurface : darkOnSurfaceMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? primary : darkOnSurfaceMuted,
          );
        }),
        height: 64,
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: darkOnSurface,
        unselectedLabelColor: darkOnSurfaceMuted,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: darkDivider,
      ),

      // --- Surfaces ---
      cardTheme: CardThemeData(
        color: darkSurfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkCardBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceContainerHigh,
        selectedColor: primary.withAlpha(40),
        disabledColor: darkSurfaceContainer,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: darkOnSurface,
        ),
        secondaryLabelStyle: GoogleFonts.inter(fontSize: 13, color: primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: darkCardBorder, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: darkOnSurfaceVariant,
        textColor: darkOnSurface,
        tileColor: Colors.transparent,
        selectedTileColor: darkSurfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // --- Inputs ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkCardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkCardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        hintStyle: GoogleFonts.inter(color: darkOnSurfaceMuted),
        labelStyle: GoogleFonts.inter(color: darkOnSurfaceVariant),
        prefixIconColor: darkOnSurfaceVariant,
        suffixIconColor: darkOnSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // --- Buttons ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: darkOnPrimary,
          disabledBackgroundColor: darkSurfaceContainerHigh,
          disabledForegroundColor: darkOnSurfaceMuted,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: darkOnPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkOnSurface,
          side: const BorderSide(color: darkCardBorder, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: darkOnSurfaceVariant,
          highlightColor: primary.withAlpha(25),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: darkOnPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // --- Selection controls ---
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? Colors.white : darkOnSurfaceMuted),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? primary : darkSurfaceContainerHigh),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? primary : Colors.transparent),
        checkColor: const WidgetStatePropertyAll(darkOnPrimary),
        side: const BorderSide(color: darkOnSurfaceVariant, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? primary : darkOnSurfaceVariant),
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: darkSurfaceContainerHigh,
        thumbColor: primary,
        overlayColor: primary.withAlpha(30),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: darkSurfaceContainerHigh,
        circularTrackColor: darkSurfaceContainerHigh,
      ),

      // --- Overlays ---
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: darkOnSurface,
        ),
        contentTextStyle: GoogleFonts.inter(fontSize: 14, color: darkOnSurfaceVariant),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurfaceContainerHighest,
        contentTextStyle: GoogleFonts.inter(fontSize: 14, color: darkOnSurface),
        actionTextColor: primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: darkSurfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(fontSize: 12, color: darkOnSurface),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: darkSurfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontSize: 14, color: darkOnSurface),
      ),

      dialogBackgroundColor: darkSurfaceContainerHigh,
      splashColor: primary.withAlpha(20),
      highlightColor: Colors.transparent,
    );
  }

  // ==========================================
  //               LIGHT THEME
  // ==========================================
  static final ThemeData lightTheme = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = _buildTextTheme(base.textTheme).apply(
      bodyColor: lightOnSurface,
      displayColor: lightOnSurface,
    );

    const colorScheme = ColorScheme.light(
      primary: primaryDark,
      onPrimary: Colors.white,
      primaryContainer: lightPrimaryContainer,
      onPrimaryContainer: lightOnPrimaryContainer,
      secondary: Color(0xFF26A69A),
      onSecondary: Colors.white,
      surface: lightSurface,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: lightSurfaceContainerLow,
      surfaceContainer: lightSurfaceContainer,
      surfaceContainerHigh: lightSurfaceContainerHigh,
      surfaceContainerHighest: lightSurfaceContainerHighest,
      onSurface: lightOnSurface,
      onSurfaceVariant: lightOnSurfaceVariant,
      error: error,
      onError: Colors.white,
      outline: lightCardBorder,
      outlineVariant: lightDivider,
      inverseSurface: lightOnSurface,
      onInverseSurface: lightSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightSurface,
      canvasColor: lightSurface,
      splashFactory: InkRipple.splashFactory,
      textTheme: textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium?.copyWith(color: lightOnSurfaceVariant),
        bodySmall: textTheme.bodySmall?.copyWith(color: lightOnSurfaceMuted),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightOnSurface,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: lightOnSurface, size: 22),
        actionsIconTheme: const IconThemeData(color: lightOnSurfaceVariant, size: 22),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurfaceContainerLow,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        indicatorColor: primaryDark.withAlpha(30),
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? lightOnSurface : lightOnSurfaceMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? primaryDark : lightOnSurfaceMuted,
          );
        }),
        height: 64,
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: lightOnSurface,
        unselectedLabelColor: lightOnSurfaceMuted,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
        indicatorColor: primaryDark,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: lightDivider,
      ),

      cardTheme: CardThemeData(
        color: lightSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightCardBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      dividerTheme: const DividerThemeData(
        color: lightDivider,
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: lightSurfaceContainerHigh,
        selectedColor: primaryDark.withAlpha(35),
        disabledColor: lightSurfaceContainer,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: lightOnSurface,
        ),
        secondaryLabelStyle: GoogleFonts.inter(fontSize: 13, color: primaryDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: lightCardBorder, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: lightOnSurfaceVariant,
        textColor: lightOnSurface,
        tileColor: Colors.transparent,
        selectedTileColor: lightSurfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightCardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: lightCardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryDark, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        hintStyle: GoogleFonts.inter(color: lightOnSurfaceMuted),
        labelStyle: GoogleFonts.inter(color: lightOnSurfaceVariant),
        prefixIconColor: lightOnSurfaceVariant,
        suffixIconColor: lightOnSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          disabledBackgroundColor: lightSurfaceContainerHigh,
          disabledForegroundColor: lightOnSurfaceMuted,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightOnSurface,
          side: const BorderSide(color: lightCardBorder, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: lightOnSurfaceVariant,
          highlightColor: primaryDark.withAlpha(20),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? Colors.white : lightOnSurfaceMuted),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? primaryDark : lightSurfaceContainerHigh),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? primaryDark : Colors.transparent),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: const BorderSide(color: lightOnSurfaceVariant, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? primaryDark : lightOnSurfaceVariant),
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: primaryDark,
        inactiveTrackColor: lightSurfaceContainerHigh,
        thumbColor: primaryDark,
        overlayColor: primaryDark.withAlpha(25),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryDark,
        linearTrackColor: lightSurfaceContainerHigh,
        circularTrackColor: lightSurfaceContainerHigh,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: lightSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: lightOnSurface,
        ),
        contentTextStyle: GoogleFonts.inter(fontSize: 14, color: lightOnSurfaceVariant),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightOnSurface,
        contentTextStyle: GoogleFonts.inter(fontSize: 14, color: lightSurface),
        actionTextColor: primaryLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: lightOnSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(fontSize: 12, color: lightSurface),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: lightSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontSize: 14, color: lightOnSurface),
      ),

      dialogBackgroundColor: lightSurfaceContainerLow,
      splashColor: primaryDark.withAlpha(15),
      highlightColor: Colors.transparent,
    );
  }
}
