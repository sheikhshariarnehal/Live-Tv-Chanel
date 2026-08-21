import 'package:flutter/material.dart';

/// GoPlay typography tokens.
///
/// This is the single source of truth for every piece of text in the app.
/// Widgets should either read `Theme.of(context).textTheme` (which is built
/// from [textTheme] below) or reference one of the named roles here.
///
/// Three rules hold this together:
///
///  1. **One family, bundled.** Inter ships in `assets/fonts/` and is declared
///     in `pubspec.yaml`. Nothing is fetched at runtime, so first launch on a
///     cold/offline device renders in Inter rather than falling back to Roboto.
///  2. **On-scale sizes only.** Pick a step from the [xs]..[xxl] ladder. Never
///     hand-pick a one-off size, and never go below [minSize] — below 11sp text
///     stops being legible on a phone, and the app clamps text scaling at 1.0
///     so the user cannot rescue it.
///  3. **Tracking follows size.** Large text tightens (negative letter-spacing),
///     small text opens up (positive). The crossover is [lg]. Applying negative
///     tracking to small heavy text closes the counters and is what makes
///     digits collide.
class GoPlayType {
  GoPlayType._();

  /// Bundled family name. Must match the `family:` key in `pubspec.yaml`.
  static const String family = 'Inter';

  // ==========================================
  //                SIZE SCALE
  // ==========================================
  // Seven steps. Every size used by a widget must be one of these.

  /// 11sp — the legibility floor. Badges, nav labels, dense metadata.
  static const double xs = 11;

  /// 12sp — labels, chips, captions.
  static const double sm = 12;

  /// 14sp — default body and the workhorse label size.
  static const double base = 14;

  /// 16sp — emphasised body, section titles, list-tile titles.
  static const double md = 16;

  /// 20sp — app bar titles, dialog titles, collapsed hero titles.
  static const double lg = 20;

  /// 24sp — screen-defining headings, expanded collapsing app bar titles.
  static const double xl = 24;

  /// 32sp — the wordmark and the largest status callouts.
  static const double xxl = 32;

  /// Nothing in the app may set a `fontSize` below this.
  static const double minSize = xs;

  /// Sizes at or above this may use negative letter-spacing.
  static const double tightTrackingThreshold = lg;

  // ==========================================
  //               LINE HEIGHTS
  // ==========================================

  /// Single-line badges and numerals that must not add vertical space.
  static const double leadingFlat = 1.1;

  /// Two-line names inside fixed-height cards.
  static const double leadingSnug = 1.2;

  /// Titles.
  static const double leadingTitle = 1.3;

  /// Reading text. Every paragraph in the app should use this.
  static const double leadingBody = 1.4;

  // ==========================================
  //                 TRACKING
  // ==========================================

  /// Tracked-uppercase metadata. The fixtures-board voice.
  static const double trackingMeta = 0.8;

  /// Wide tracking for uppercase callouts (status headlines, not section titles).
  static const double trackingWide = 1.5;

  /// The wordmark only.
  static const double trackingWordmark = 2.0;

  // ==========================================
  //                  ROLES
  // ==========================================

  /// The wordmark / largest moment.
  static const TextStyle display = TextStyle(
    fontFamily: family,
    fontSize: xxl,
    fontWeight: FontWeight.w800,
    height: 1.12,
    letterSpacing: -0.8,
  );

  /// Screen-defining headings and status callouts.
  static const TextStyle headline = TextStyle(
    fontFamily: family,
    fontSize: xl,
    fontWeight: FontWeight.w800,
    height: leadingTitle,
    letterSpacing: -0.4,
  );

  /// App bar titles, dialog titles.
  static const TextStyle title = TextStyle(
    fontFamily: family,
    fontSize: lg,
    fontWeight: FontWeight.w700,
    height: leadingTitle,
    letterSpacing: -0.2,
  );

  /// Card titles, list-tile titles, section titles.
  static const TextStyle subtitle = TextStyle(
    fontFamily: family,
    fontSize: md,
    fontWeight: FontWeight.w600,
    height: leadingSnug,
  );

  /// Reading text. Descriptions, announcement bodies, release notes.
  static const TextStyle body = TextStyle(
    fontFamily: family,
    fontSize: base,
    fontWeight: FontWeight.w400,
    height: leadingBody,
  );

  /// Secondary reading text.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: family,
    fontSize: sm,
    fontWeight: FontWeight.w400,
    height: leadingBody,
  );

  /// Buttons, nav labels, chips. The workhorse role.
  static const TextStyle label = TextStyle(
    fontFamily: family,
    fontSize: base,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  /// Dense labels — chips, tabs, compact rows.
  static const TextStyle labelSmall = TextStyle(
    fontFamily: family,
    fontSize: sm,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.2,
  );

  // ---- The Tracked-Uppercase Label Rule ----

  /// Loud status badges: LIVE, quality, league. Always `toUpperCase()`.
  ///
  /// Sits at the [xs] floor rather than the 8–10sp the app used to use — at
  /// 8sp this text was decorative, not readable.
  ///
  /// This is the *only* remaining uppercase voice in the app. It covers short
  /// metadata tokens — LIVE, UPCOMING, HD, a league name — where the uppercase
  /// reads as a status stamp. Anything long enough to be a sentence or a
  /// heading is set in normal case; see [sectionTitle].
  static const TextStyle meta = TextStyle(
    fontFamily: family,
    fontSize: xs,
    fontWeight: FontWeight.w800,
    height: leadingFlat,
    letterSpacing: trackingMeta,
  );

  /// Section titles — "Trending Channels", "Today's Schedule".
  ///
  /// Normal case, no tracking, [lg]. This replaces the tracked-uppercase
  /// treatment `DESIGN.md` originally specified. Uppercasing every section
  /// title made the screen read as all-shouting: with the loud [meta] badges
  /// already competing for attention, the headings had no quieter register to
  /// fall back to. Sentence case at [lg] gives the screen an actual top of
  /// hierarchy, and keeps the uppercase voice meaningful by reserving it for
  /// the short status tokens in [meta].
  ///
  /// Tracking is deliberately 0. Positive tracking on a 20sp heading spreads
  /// the words far enough apart that they stop reading as a single phrase.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: family,
    fontSize: lg,
    fontWeight: FontWeight.w500,
    height: leadingTitle,
    letterSpacing: 0,
  );

  /// The quiet action link that sits opposite a [sectionTitle] — "See all".
  ///
  /// Medium, not semibold: the link is a way out of the section, never the
  /// reason to look at it.
  static const TextStyle sectionAction = TextStyle(
    fontFamily: family,
    fontSize: base,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0,
  );

  // ---- Brand ----

  /// The GoPlay wordmark. Shared by the splash screen and the Home app bar so
  /// the same brand moment is set identically in both places.
  static const TextStyle wordmark = TextStyle(
    fontFamily: family,
    fontSize: xxl,
    fontWeight: FontWeight.w800,
    height: leadingFlat,
    letterSpacing: trackingWordmark,
  );

  /// The wordmark's supporting line: "LIVE SPORTS STREAMING".
  static const TextStyle tagline = TextStyle(
    fontFamily: family,
    fontSize: xs,
    fontWeight: FontWeight.w600,
    height: leadingFlat,
    letterSpacing: 4.0,
  );

  // ==========================================
  //                 HELPERS
  // ==========================================

  /// Build an Inter style without going through the full role set.
  ///
  /// Prefer a named role above. Use this only for theme plumbing and for
  /// genuinely one-off cases such as animated font sizes.
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }

  /// The full Material 3 text theme, in Inter, with GoPlay's weights,
  /// tracking and line heights baked in.
  ///
  /// Sizes stay on the Material type scale so they honour the system font
  /// setting. Colours are applied by the caller via [TextTheme.apply].
  static TextTheme textTheme() {
    return const TextTheme(
      // --- Display ---
      displayLarge: TextStyle(
        fontFamily: family,
        fontSize: 57,
        fontWeight: FontWeight.w800,
        height: 1.12,
        letterSpacing: -1.0,
      ),
      displayMedium: TextStyle(
        fontFamily: family,
        fontSize: 45,
        fontWeight: FontWeight.w800,
        height: 1.16,
        letterSpacing: -0.8,
      ),
      displaySmall: TextStyle(
        fontFamily: family,
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.22,
        letterSpacing: -0.5,
      ),

      // --- Headline ---
      headlineLarge: TextStyle(
        fontFamily: family,
        fontSize: xxl,
        fontWeight: FontWeight.w800,
        height: 1.25,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontFamily: family,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.29,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        fontFamily: family,
        fontSize: xl,
        fontWeight: FontWeight.w700,
        height: 1.33,
        letterSpacing: -0.2,
      ),

      // --- Title ---
      titleLarge: TextStyle(
        fontFamily: family,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.27,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        fontFamily: family,
        fontSize: md,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontFamily: family,
        fontSize: base,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
      ),

      // --- Body ---
      bodyLarge: TextStyle(
        fontFamily: family,
        fontSize: md,
        fontWeight: FontWeight.w400,
        height: leadingBody,
      ),
      bodyMedium: TextStyle(
        fontFamily: family,
        fontSize: base,
        fontWeight: FontWeight.w400,
        height: leadingBody,
      ),
      bodySmall: TextStyle(
        fontFamily: family,
        fontSize: sm,
        fontWeight: FontWeight.w400,
        height: leadingBody,
        letterSpacing: 0.1,
      ),

      // --- Label ---
      labelLarge: TextStyle(
        fontFamily: family,
        fontSize: base,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontFamily: family,
        fontSize: sm,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0.3,
      ),
      labelSmall: TextStyle(
        fontFamily: family,
        fontSize: xs,
        fontWeight: FontWeight.w600,
        height: 1.27,
        letterSpacing: 0.5,
      ),
    );
  }
}
