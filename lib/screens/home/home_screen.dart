// dart:ui import removed â€” BackdropFilter/ImageFilter no longer used.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/event.dart';
import '../../models/channel.dart';
import '../../models/announcement.dart';

import '../../widgets/cards/event_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/live_badge.dart';
import '../../widgets/team_flag.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/countdown_timer.dart';
import '../../widgets/tv_focus_wrapper.dart';

// ─── Static const text styles (Inter bundled locally) ────────────────────
const _kInterLeagueBadge = TextStyle(
  fontFamily: 'Inter',
  color: Colors.white,
  fontSize: 9,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.5,
);

const _kInterTeamName = TextStyle(
  fontFamily: 'Inter',
  color: Colors.white,
  fontSize: 13,
  fontWeight: FontWeight.bold,
);

const _kInterVs = TextStyle(
  fontFamily: 'Inter',
  color: Color(0xB3FFFFFF),
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

const _kInterLiveNow = TextStyle(
  fontFamily: 'Inter',
  color: GoPlayTheme.primary,
  fontSize: 9,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.5,
);

const _kInterKickoff = TextStyle(
  fontFamily: 'Inter',
  color: Color(0x80FFFFFF),
  fontSize: 9,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.5,
);

const _kInterWatch = TextStyle(
  fontFamily: 'Inter',
  color: Color(0xFF17181C),
  fontSize: 10,
  fontWeight: FontWeight.w900,
  letterSpacing: 0.5,
);

const _kInterCountdown = TextStyle(
  fontFamily: 'Inter',
  color: GoPlayTheme.primary,
  fontSize: 10,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.2,
);

const _kInterSearchHint = TextStyle(
  fontFamily: 'Inter',
  color: Color(0x99FFFFFF),
  fontSize: 14,
);

const _kInterMenuLabel = TextStyle(
  fontFamily: 'Inter',
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

const _kInterChipSelected = TextStyle(
  fontFamily: 'Inter',
  color: Color(0xFF0F0F0F),
  fontSize: 13,
  fontWeight: FontWeight.w700,
);

const _kInterChipUnselected = TextStyle(
  fontFamily: 'Inter',
  color: Colors.white,
  fontSize: 13,
  fontWeight: FontWeight.w500,
);

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
                    style: const TextStyle(
                      color: GoPlayTheme.onSurfaceVariant,
                      fontSize: 14,
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
    return Material(
      color: GoPlayTheme.surface,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        cacheExtent: 600.0,
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
                final Color headerBgColor = themeSurface;

                final Widget headerContent = Container(
                  color: headerBgColor,
                  child: Padding(
                    padding: EdgeInsets.only(top: statusBarHeight),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 16,
                          top: 0,
                          height: kToolbarHeight,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'GOPLAY',
                              style: TextStyle(
                                fontSize: collapseRatio > 0.5 ? 20 : 26,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

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
                                        const Text(
                                          'App Settings',
                                          style: _kInterMenuLabel,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

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
                                    const Text(
                                      'Search channels, events...',
                                      style: _kInterSearchHint,
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

// ─── Hero Banner ──────────────────────────────────────────────────────────────
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
    if (mounted) setState(() => _countdownDone = true);
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

                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0x20FFFFFF), width: 0.5),
                        ),
                        child: Text(
                          event.league.toUpperCase(),
                          style: _kInterLeagueBadge,
                        ),
                      ),
                      if (event.isLive || _countdownDone)
                        const LiveBadge(fontSize: 9)
                      else
                        const _UpcomingBadge(),
                    ],
                  ),
                ),

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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      event.homeTeam.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: _kInterTeamName,
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
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                                    child: Text(
                                      'vs',
                                      style: _kInterVs,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      event.awayTeam.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: _kInterTeamName,
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
                                    const Text(
                                      'LIVE NOW',
                                      style: _kInterLiveNow,
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
                                      style: _kInterKickoff,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _canWatch
                              ? const _WatchButton(key: ValueKey('watch'))
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

// ─── Watch CTA Button ────────────────────────────────────────────────────────
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
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow_rounded, color: Color(0xFF17181C), size: 14),
          SizedBox(width: 4),
          Text(
            'WATCH',
            style: _kInterWatch,
          ),
        ],
      ),
    );
  }
}

// ─── Countdown CTA Button ───────────────────────────────────────────────────
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
              style: _kInterCountdown,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Minimal Sport Category Filter Chips ─────────────────────────────────────────
class _SportCategoryFilterChips extends ConsumerWidget {
  const _SportCategoryFilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportsAsync = ref.watch(sortedSportCategoriesProvider);
    final selectedSport = ref.watch(selectedSportFilterProvider);

    return sportsAsync.when(
      data: (sportsList) {
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
                      style: isSelected ? _kInterChipSelected : _kInterChipUnselected,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const _ChipsSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _TodaySchedule extends ConsumerWidget {
  const _TodaySchedule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSport = ref.watch(selectedSportFilterProvider);
    final eventsAsync = ref.watch(filteredTodayEventsProvider(selectedSport));

    return eventsAsync.when(
      data: (todayEvents) {
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
      loading: () => const _ScheduleSkeleton(),
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
      loading: () => const _TrendingChannelsSkeleton(),
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
  final Channel channel;
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
                  channel.name,
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
  final Announcement announcement;

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
                    Text(announcement.title, style: _titleStyle),
                    const SizedBox(height: 2),
                    Text(announcement.body, style: _bodyStyle),
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

// ─── Skeleton Loaders ─────────────────────────────────────────────────────────

/// Placeholder row of 5 grey circles matching real channel avatar size.
class _TrendingChannelsSkeleton extends StatelessWidget {
  const _TrendingChannelsSkeleton();

  static const _circleDecoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainerHigh,
    shape: BoxShape.circle,
  );

  static const _barDecoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainerHigh,
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: SizedBox(
                width: 72,
                child: Column(
                  children: [
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: DecoratedBox(decoration: _circleDecoration),
                    ),
                    SizedBox(height: 6),
                    SizedBox(
                      width: 48,
                      height: 10,
                      child: DecoratedBox(decoration: _barDecoration),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Placeholder row of 4 grey pill-shaped chips.
class _ChipsSkeleton extends StatelessWidget {
  const _ChipsSkeleton();

  static const _chipDecoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainerHigh,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          const SizedBox(width: 16),
          for (int i = 0; i < 4; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            SizedBox(
              width: i == 0 ? 42 : 70,
              height: 32,
              child: const DecoratedBox(decoration: _chipDecoration),
            ),
          ],
        ],
      ),
    );
  }
}

/// 3 grey placeholder cards matching event card height (100px).
class _ScheduleSkeleton extends StatelessWidget {
  const _ScheduleSkeleton();

  static const _cardDecoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainerHigh,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList.builder(
      itemExtent: 100.0,
      itemCount: 3,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: DecoratedBox(decoration: _cardDecoration),
          ),
        );
      },
    );
  }
}
