// dart:ui import removed â€” BackdropFilter/ImageFilter no longer used.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/event.dart';

import '../../widgets/cards/event_list_tile.dart';
import '../../widgets/section_header.dart';
import '../../widgets/live_badge.dart';
import '../../widgets/team_flag.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/countdown_timer.dart';



class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the appSyncProvider to check initialization state
    final syncState = ref.watch(appSyncProvider);
    final cache = ref.watch(cacheServiceProvider);
    final localChannels = cache.getLocalChannels();

    // If local cache is empty, we must show loading/error states for the initial sync.
    if (localChannels.isEmpty) {
      return syncState.when(
        data: (_) => _buildMainContent(context, ref),
        loading: () => const Scaffold(
          backgroundColor: GoPlayTheme.surface,
          body: Center(
            child: CircularProgressIndicator(
              color: GoPlayTheme.primary,
            ),
          ),
        ),
        error: (error, stack) => Scaffold(
          backgroundColor: GoPlayTheme.surface,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 64,
                    color: GoPlayTheme.error,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CONNECTION ERROR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    error.toString().replaceAll('Exception: ', ''),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurfaceVariant,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Refresh the sync provider to trigger a reload
                      ref.invalidate(appSyncProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text('RETRY CONNECTION'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GoPlayTheme.primary,
                      foregroundColor: const Color(0xFF003300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return _buildMainContent(context, ref);
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    final baseTitleStyle = Theme.of(context).appBarTheme.titleTextStyle ?? const TextStyle();
    final titleCollapsed = baseTitleStyle.copyWith(
      fontSize: 20,
      color: Colors.white,
    );
    final titleExpanded = baseTitleStyle.copyWith(
      fontSize: 26,
      color: Colors.white,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing Dark-Themed App Bar
          SliverAppBar(
            expandedHeight: 108.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final double appBarHeight = constraints.biggest.height;
                final double statusBarHeight = MediaQuery.paddingOf(
                  context,
                ).top;
                const double expandedHeight = 108.0;
                final double minHeight = kToolbarHeight + statusBarHeight;
                final double maxHeight = expandedHeight + statusBarHeight;

                final double collapseRatio =
                    ((maxHeight - appBarHeight) / (maxHeight - minHeight))
                        .clamp(0.0, 1.0);

                final Color themeSurface = Theme.of(context).colorScheme.surface;
                
                // Color matches the theme surface dynamically. 
                // Fully opaque (100% opacity) since BackdropFilter is removed.
                final Color headerBgColor = themeSurface;

                final Widget headerContent = Container(
                  color: headerBgColor,
                  child: Padding(
                    padding: EdgeInsets.only(top: statusBarHeight),
                    child: Stack(
                      children: [
                        // Title â€” snaps between two pre-cached const styles,
                        // eliminating per-frame TextStyle allocation via copyWith().
                        Positioned(
                          left: 16,
                          top: 0,
                          height: kToolbarHeight,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'GOPLAY',
                              style: collapseRatio > 0.5
                                  ? titleCollapsed
                                  : titleExpanded,
                            ),
                          ),
                        ),

                        // Search Icon on top-right, fading in on scroll
                        // Search icon â€” only painted when visible (avoids saveLayer)
                        if (collapseRatio >= 0.5)
                          Positioned(
                            right: 48,
                            top: 0,
                            height: kToolbarHeight,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () => context.push('/search'),
                              ),
                            ),
                          ),

                        // 3-dot Menu Icon on far top-right, always visible
                        Positioned(
                          right: 8,
                          top: 0,
                          height: kToolbarHeight,
                          child: Center(
                            child: PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                color: Colors.white,
                              ),
                              color: GoPlayTheme.surfaceContainerHigh,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: GoPlayTheme.cardBorder,
                                  width: 0.5,
                                ),
                              ),
                              onSelected: (value) {
                                if (value == 'settings') {
                                  context.push('/settings');
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<String>(
                                  value: 'settings',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.settings_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'App Settings',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Search text field below, fading/sliding out on scroll
                        // Search field â€” skip entire subtree when collapsed (avoids saveLayer + Theme.copyWith)
                        if (collapseRatio < 0.67)
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 8 * (1.0 - collapseRatio),
                            height: 44,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: GoPlayTheme.surfaceContainer,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                              child: TextField(
                                readOnly: true,
                                onTap: () => context.push('/search'),
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search channels, events...',
                                  hintStyle: GoogleFonts.inter(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );

                // No BackdropFilter â€” eliminated GPU blur costing ~5-8ms/frame.
                // The semi-opaque headerBgColor provides a similar frosted-glass
                // appearance without the raster-thread cost.
                return headerContent;
              },
            ),
          ),

          // Hero Banner
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _HeroBanner()),
          ),

          // Trending Channels
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Channels',
              actionLabel: 'See All',
              onAction: () => context.go('/channels'),
            ),
          ),
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _TrendingChannels()),
          ),

          // Today's Schedule
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Today's Schedule",
              actionLabel: 'See All',
              onAction: () => context.go('/upcoming'),
            ),
          ),
          const _TodaySchedule(),

          // Recently Watched
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _RecentlyWatched()),
          ),

          // Announcements
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _AnnouncementsSection()),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// â”€â”€â”€ Hero Banner â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _HeroBanner extends ConsumerStatefulWidget {
  const _HeroBanner();

  @override
  ConsumerState<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends ConsumerState<_HeroBanner> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuredAsync = ref.watch(featuredEventsProvider);

    return featuredAsync.when(
      data: (events) {
        if (events.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentPage.value = index;
                },
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _HeroBannerCard(event: event);
                },
              ),
            ),
            if (events.length > 1) ...[
              const SizedBox(height: 8),
              ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, currentPage, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(events.length, (index) {
                      final bool active = currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          color: active
                              ? GoPlayTheme.primary
                              : const Color(0x5000ADB5),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ],
        );
      },
      loading: () => const _HeroBannerSkeleton(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

/// Individual hero banner card
class _HeroBannerCard extends ConsumerStatefulWidget {
  final SportEvent event;
  const _HeroBannerCard({required this.event});

  @override
  ConsumerState<_HeroBannerCard> createState() => _HeroBannerCardState();
}

class _HeroBannerCardState extends ConsumerState<_HeroBannerCard> {
  // Tracks whether the countdown has finished for this card.
  // Once true, the CTA flips from countdown â†’ WATCH without waiting
  // for a network refresh.
  bool _countdownDone = false;

  static const _cardRadius = BorderRadius.all(Radius.circular(20));
  static const _cardDecoration = BoxDecoration(
    borderRadius: _cardRadius,
    border: Border.fromBorderSide(
      BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x1F000000),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  void _onCountdownFinished() {
    // Flip the button to WATCH immediately without waiting for a network refresh.
    if (mounted) setState(() => _countdownDone = true);
    // Also trigger a background sync so isLive updates for other consumers.
    ref.read(syncServiceProvider).sync();
    ref.invalidate(eventsProvider);
  }

  String _formatKickoff(DateTime time) {
    final t = time.toLocal();
    final h = t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final displayHour = h % 12 == 0 ? 12 : h % 12;
    final timeStr = '$displayHour:$m $period';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final eventDay = DateTime(t.year, t.month, t.day);

    if (eventDay == today) return 'TODAY, $timeStr';
    if (eventDay == tomorrow) return 'TOMORROW, $timeStr';

    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return '${months[t.month - 1]} ${t.day}, $timeStr';
  }

  bool get _canWatch =>
      widget.event.isLive || _countdownDone;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    // ── Type 2: Spotlight / Cover Style ──────────────────────────
    if (event.heroType == 2) {
      return _buildSpotlightCard(context, event);
    }

    // ── Type 1: Matchup Style (default, existing layout) ────────

    return GestureDetector(
      onTap: () {
        if (!_canWatch) return; // Disable tap while still upcoming
        if (event.channels.isNotEmpty) {
          context.push(
            '/player/${event.channels.first}',
            extra: {'eventChannels': event.channels, 'forceFullscreen': true},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No channels available for this event.'),
              backgroundColor: GoPlayTheme.error,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
        child: DecoratedBox(
          decoration: _cardDecoration,
          child: ClipRRect(
            borderRadius: _cardRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Cached Banner Image
                if (event.banner != null && event.banner!.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: event.banner!,
                    fit: BoxFit.cover,
                    memCacheWidth: 800,
                    fadeInDuration: const Duration(milliseconds: 200),
                    placeholder: (context, url) => const ColoredBox(
                      color: GoPlayTheme.surfaceContainerHigh,
                    ),
                    errorWidget: (context, url, error) => const ColoredBox(
                      color: GoPlayTheme.surfaceContainerHigh,
                    ),
                  ),

                // 2. Cinematic Gradient Overlay (No heavy BackdropFilter)
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x40000000),
                        Colors.transparent,
                        Color(0x50000000),
                      ],
                    ),
                  ),
                ),

                // 3. Floating Top Badges (League & Status)
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // League Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0x20FFFFFF), width: 0.5),
                        ),
                        child: Text(
                          event.league.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      // Live / Upcoming Badge
                      if (event.isLive || _countdownDone)
                        const LiveBadge(fontSize: 9)
                      else
                        const _UpcomingBadge(),
                    ],
                  ),
                ),

                // 4. Bottom Detail Row
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 68,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xE61F2026),
                      border: Border(
                        top: BorderSide(
                          color: Color(0x24FFFFFF),
                          width: 0.8,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 6, bottom: 8),
                    child: Row(
                      children: [
                        // Left Column: Matchup & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Matchup Title
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      event.homeTeam.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (event.homeTeam.flag != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: ClipOval(
                                          child: TeamFlagWidget(
                                            flag: event.homeTeam.flag,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                    child: Text(
                                      'vs',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xB3FFFFFF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      event.awayTeam.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (event.awayTeam.flag != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: ClipOval(
                                          child: TeamFlagWidget(
                                            flag: event.awayTeam.flag,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              // Subtitle: LIVE NOW or Kickoff time
                              if (event.isLive || _countdownDone)
                                Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        color: GoPlayTheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'LIVE NOW',
                                      style: GoogleFonts.inter(
                                        color: GoPlayTheme.primary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      color: Color(0x80FFFFFF),
                                      size: 10,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      _formatKickoff(event.startTime),
                                      style: GoogleFonts.inter(
                                        color: const Color(0x80FFFFFF),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Right Side: CTA Button
                        // â€” Live / countdown done â†’ teal WATCH button
                        // â€” Upcoming â†’ dark pill showing live countdown inside
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _canWatch
                              ? _WatchButton(key: const ValueKey('watch'))
                              : _CountdownButton(
                                  key: const ValueKey('countdown'),
                                  startTime: event.startTime,
                                  onFinished: _onCountdownFinished,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Type 2: Spotlight / Cover Style ────────────────────────────
  Widget _buildSpotlightCard(BuildContext context, SportEvent event) {
    final displayTitle = event.customTitle?.isNotEmpty == true
        ? event.customTitle!
        : event.league;

    return GestureDetector(
      onTap: () {
        if (!_canWatch) return;
        if (event.channels.isNotEmpty) {
          context.push(
            '/player/${event.channels.first}',
            extra: {'eventChannels': event.channels, 'forceFullscreen': true},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No channels available for this event.'),
              backgroundColor: GoPlayTheme.error,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
        child: DecoratedBox(
          decoration: _cardDecoration,
          child: ClipRRect(
            borderRadius: _cardRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Full-bleed Cover Image
                if (event.banner != null && event.banner!.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: event.banner!,
                    fit: BoxFit.cover,
                    memCacheWidth: 800,
                    fadeInDuration: const Duration(milliseconds: 200),
                    placeholder: (context, url) => const ColoredBox(
                      color: GoPlayTheme.surfaceContainerHigh,
                    ),
                    errorWidget: (context, url, error) => const ColoredBox(
                      color: GoPlayTheme.surfaceContainerHigh,
                    ),
                  ),

                // 2. Cinematic Gradient — heavier top/bottom for title legibility
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.45, 1.0],
                      colors: [
                        Color(0xCC000000), // Darker top for title legibility
                        Color(0x20000000),
                        Color(0x80000000), // Darker bottom for button visibility
                      ],
                    ),
                  ),
                ),

                // 3. Top Section: Title & Status Badge
                Positioned(
                  top: 14,
                  left: 14,
                  right: 14,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Spotlight Title at the top-left
                      Expanded(
                        child: Text(
                          displayTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Status Badge at top-right
                      if (event.isLive || _countdownDone)
                        const LiveBadge(fontSize: 9)
                      else
                        const _UpcomingBadge(),
                    ],
                  ),
                ),

                // 4. Bottom Section: Centered CTA Action Button
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _canWatch
                          ? _WatchNowButton(key: const ValueKey('watch_now'))
                          : _CountdownButton(
                              key: const ValueKey('countdown'),
                              startTime: event.startTime,
                              onFinished: _onCountdownFinished,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ─── Watch Now CTA Button (Centered spotlight style) ──────────
class _WatchNowButton extends StatelessWidget {
  const _WatchNowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: GoPlayTheme.primary,
        borderRadius: BorderRadius.circular(17), // pill shape
        boxShadow: const [
          BoxShadow(
            color: Color(0x3000ADB5),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.play_arrow_rounded, color: Color(0xFF17181C), size: 14),
          const SizedBox(width: 5),
          Text(
            'WATCH NOW',
            style: GoogleFonts.inter(
              color: const Color(0xFF17181C),
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Watch CTA Button ─────────────────────────────────────────
class _WatchButton extends StatelessWidget {
  const _WatchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: GoPlayTheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2000ADB5),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_arrow_rounded, color: Color(0xFF17181C), size: 14),
          const SizedBox(width: 4),
          Text(
            'WATCH',
            style: GoogleFonts.inter(
              color: const Color(0xFF17181C),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Countdown CTA Button ————————————————————————————————————
// Shows a compact live countdown inside the button.
// Isolated RepaintBoundary keeps per-second repaints cheap.
class _CountdownButton extends StatelessWidget {
  final DateTime startTime;
  final VoidCallback onFinished;

  const _CountdownButton({
    super.key,
    required this.startTime,
    required this.onFinished,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2D31),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: GoPlayTheme.primary.withValues(alpha: 0.35),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_outlined,
              size: 11,
              color: GoPlayTheme.primary.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 4),
            CountdownTimerWidget(
              startTime: startTime,
              onTimerFinished: onFinished,
              style: GoogleFonts.inter(
                color: GoPlayTheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// â”€â”€â”€ Today's Schedule â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _TodaySchedule extends ConsumerWidget {
  const _TodaySchedule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(todayEventsProvider);

    return eventsAsync.when(
      data: (todayEvents) {
        if (todayEvents.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'No events scheduled for today',
                style: TextStyle(color: GoPlayTheme.onSurfaceVariant),
              ),
            ),
          );
        }

        return SliverList.builder(
          itemCount: todayEvents.length,
          itemBuilder: (context, index) {
            final event = todayEvents[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RepaintBoundary(
                child: EventListTile(
                  event: event,
                  onTap: () {
                    if (event.channels.isNotEmpty) {
                      context.push(
                        '/player/${event.channels.first}',
                        extra: {
                          'eventChannels': event.channels,
                          'forceFullscreen': true,
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No channels available for this event.'),
                          backgroundColor: GoPlayTheme.error,
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (err, stack) => const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}

// â”€â”€â”€ Trending Channels â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _TrendingChannels extends ConsumerWidget {
  const _TrendingChannels();

  static const _nameStyle = TextStyle(
    color: GoPlayTheme.onSurface,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingChannelsProvider);

    return trendingAsync.when(
      data: (channels) {
        if (channels.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: channels.length,
            addAutomaticKeepAlives: false,
            itemBuilder: (context, index) {
              final ch = channels[index];
              return _ChannelItem(
                channel: ch,
                nameStyle: _nameStyle,
                showBorder: true,
                onTap: () => context.push('/player/${ch.id}'),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 90),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

// â”€â”€â”€ Recently Watched â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _RecentlyWatched extends ConsumerWidget {
  const _RecentlyWatched();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(watchHistoryProvider);

    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SectionHeader(title: 'Recently Watched'),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: history.length,
            addAutomaticKeepAlives: false,
            itemBuilder: (context, index) {
              final ch = history[index];
              return _ChannelItem(
                channel: ch,
                nameStyle: _historyNameStyle,
                showBorder: false,
                onTap: () => context.push('/player/${ch.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€ Announcements â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AnnouncementsSection extends ConsumerWidget {
  const _AnnouncementsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return announcementsAsync.when(
      data: (announcements) {
        if (announcements.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            const SectionHeader(title: 'Announcements'),
            for (final a in announcements) _AnnouncementTile(announcement: a),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}



// â”€â”€â”€ Cached style â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const TextStyle _historyNameStyle = TextStyle(
  color: GoPlayTheme.onSurface,
  fontSize: 10,
);

// â”€â”€â”€ _HeroBannerSkeleton â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _HeroBannerSkeleton extends StatelessWidget {
  const _HeroBannerSkeleton();

  static const _decoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainer,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        height: 200,
        child: DecoratedBox(
          decoration: _decoration,
          child: Center(
            child: CircularProgressIndicator(color: GoPlayTheme.primary),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ _UpcomingBadge â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _UpcomingBadge extends StatelessWidget {
  const _UpcomingBadge();

  static const _decoration = BoxDecoration(
    color: Color(0x1E00ADB5),
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x5000ADB5), width: 0.5),
    ),
  );

  static const _dotDecoration = BoxDecoration(
    color: GoPlayTheme.primary,
    shape: BoxShape.circle,
  );

  static const _labelStyle = TextStyle(
    color: GoPlayTheme.primary,
    fontSize: 9,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
  );

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: _decoration,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 5,
              height: 5,
              child: DecoratedBox(decoration: _dotDecoration),
            ),
            SizedBox(width: 5),
            Text('UPCOMING', style: _labelStyle),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ _ChannelItem â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _ChannelItem extends StatelessWidget {
  final dynamic channel;
  final TextStyle nameStyle;
  final bool showBorder;
  final VoidCallback onTap;

  const _ChannelItem({
    required this.channel,
    required this.nameStyle,
    required this.showBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 75,
          child: Column(
            children: [
              ChannelAvatar(channel: channel, showBorder: showBorder),
              const SizedBox(height: 6),
              Text(
                channel.name as String,
                style: nameStyle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ _AnnouncementTile â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AnnouncementTile extends StatelessWidget {
  final dynamic announcement;

  const _AnnouncementTile({required this.announcement});

  static const _warningDecoration = BoxDecoration(
    color: Color(0x14FFC107),
    borderRadius: BorderRadius.all(Radius.circular(16)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x33FFC107), width: 0.8),
    ),
  );

  static const _infoDecoration = BoxDecoration(
    color: Color(0x0AFFFFFF),
    borderRadius: BorderRadius.all(Radius.circular(16)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x14FFFFFF), width: 0.8),
    ),
  );

  static const _titleStyle = TextStyle(
    color: GoPlayTheme.onSurface,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const _bodyStyle = TextStyle(
    color: GoPlayTheme.onSurfaceVariant,
    fontSize: 11,
  );

  @override
  Widget build(BuildContext context) {
    final bool isWarning = announcement.type == 'warning';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DecoratedBox(
        decoration: isWarning ? _warningDecoration : _infoDecoration,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                isWarning
                    ? Icons.warning_amber_rounded
                    : Icons.info_outline_rounded,
                color: isWarning ? Colors.amber : GoPlayTheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(announcement.title as String, style: _titleStyle),
                    const SizedBox(height: 2),
                    Text(announcement.body as String, style: _bodyStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
