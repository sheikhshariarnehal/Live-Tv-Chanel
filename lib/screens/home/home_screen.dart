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

import '../../widgets/cards/event_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/live_badge.dart';
import '../../widgets/team_flag.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/countdown_timer.dart';
import '../../widgets/tv_focus_wrapper.dart';



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
        loading: () => const Material(
          color: GoPlayTheme.surface,
          child: Center(
            child: CircularProgressIndicator(
              color: GoPlayTheme.primary,
            ),
          ),
        ),
        error: (error, stack) => Material(
          color: GoPlayTheme.surface,
          child: Center(
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

    return Material(
      color: GoPlayTheme.surface,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        cacheExtent: 250.0,
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
                            child: Focus(
                              canRequestFocus: false,
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
                        ),

                        // Search text field below, fading/sliding out on scroll
                        // Search field â€” skip entire subtree when collapsed (avoids saveLayer + Theme.copyWith)
                        if (collapseRatio < 0.67)
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 8 * (1.0 - collapseRatio),
                            height: 44,
                            child: TvFocusable(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => context.push('/search'),
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: GoPlayTheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    width: 0.8,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search_rounded,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Search channels, events...',
                                      style: GoogleFonts.inter(
                                        color: Colors.white.withValues(alpha: 0.6),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: RepaintBoundary(child: _SportCategoryFilterChips()),
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
                  return _HeroBannerCard(
                    event: event,
                    autoFocus: index == 0,
                  );
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
                      return Container(
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
  final bool autoFocus;
  const _HeroBannerCard({
    required this.event,
    this.autoFocus = false,
  });

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

  bool get _canWatch => widget.event.isLive || _countdownDone;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    void handleTap() {
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
    }

    return TvFocusable(
      autoFocus: widget.autoFocus,
      borderRadius: BorderRadius.circular(20),
      onTap: handleTap,
      child: GestureDetector(
        onTap: handleTap,
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
                    memCacheWidth: 400,
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
    ),
    );
  }
}

// â”€â”€â”€ Watch CTA Button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

// â”€â”€â”€ Countdown CTA Button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
// ─── Minimal Sport Category Filter Chips ───────────────────────────────────────
class _SportCategoryFilterChips extends ConsumerWidget {
  const _SportCategoryFilterChips();

  static const List<String> _popularSportsPriority = [
    'Cricket',
    'Football',
    'Motorsports',
    'Motorsport',
    'Formula 1',
    'Tennis',
    'Golf',
    'Volleyball',
    'Basketball',
    'Boxing',
    'Baseball',
    'Rugby',
    'American Football',
    'Cycling',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final selectedSport = ref.watch(selectedSportFilterProvider);

    return eventsAsync.when(
      data: (events) {
        // Dynamically extract unique categories present in database events
        final rawSports = events
            .map((e) => e.sport.trim())
            .where((s) => s.isNotEmpty)
            .toSet();

        int getPriority(String sport) {
          final lower = sport.toLowerCase();
          for (int i = 0; i < _popularSportsPriority.length; i++) {
            if (_popularSportsPriority[i].toLowerCase() == lower) {
              return i;
            }
          }
          return 999;
        }

        final sortedSports = rawSports.toList()
          ..sort((a, b) {
            final pA = getPriority(a);
            final pB = getPriority(b);
            if (pA != pB) return pA.compareTo(pB);
            return a.compareTo(b);
          });

        final sportsList = ['All', ...sortedSports];

        return SizedBox(
          height: 32,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            itemCount: sportsList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final sport = sportsList[index];
              final isSelected = selectedSport.toLowerCase() == sport.toLowerCase();

              return TvFocusable(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  ref.read(selectedSportFilterProvider.notifier).select(sport);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : GoPlayTheme.darkSurfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      sport,
                      style: GoogleFonts.inter(
                        color: isSelected
                            ? const Color(0xFF0F0F0F)
                            : Colors.white,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _TodaySchedule extends ConsumerWidget {
  const _TodaySchedule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(todayEventsProvider);
    final selectedSport = ref.watch(selectedSportFilterProvider);

    return eventsAsync.when(
      data: (allEvents) {
        final todayEvents = selectedSport.toLowerCase() == 'all'
            ? allEvents
            : allEvents
                .where((e) => e.sport.toLowerCase() == selectedSport.toLowerCase())
                .toList();

        if (todayEvents.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'No events scheduled for this category today',
                style: TextStyle(color: GoPlayTheme.onSurfaceVariant),
              ),
            ),
          );
        }

        final isDesktopOrTv = MediaQuery.of(context).size.width >= 800;

        void handleTap(SportEvent event) {
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
        }

        if (isDesktopOrTv) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 100,
                crossAxisSpacing: 8,
                mainAxisSpacing: 0,
              ),
              itemCount: todayEvents.length,
              itemBuilder: (context, index) {
                final event = todayEvents[index];
                return EventCard(
                  key: ValueKey(event.id),
                  event: event,
                  onTap: () => handleTap(event),
                );
              },
            ),
          );
        }

        return SliverFixedExtentList.builder(
          itemExtent: 100.0,
          itemCount: todayEvents.length,
          itemBuilder: (context, index) {
            final event = todayEvents[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EventCard(
                key: ValueKey(event.id),
                event: event,
                onTap: () => handleTap(event),
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
            addRepaintBoundaries: false,
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
            addRepaintBoundaries: false,
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
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TvFocusable(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            width: 72,
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
