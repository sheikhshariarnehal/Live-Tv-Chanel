import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../providers/app_providers.dart';
import '../../models/channel.dart';
import '../../models/event.dart';
import '../../widgets/team_flag.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  bool _showCloseButton = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final showClose = _controller.text.isNotEmpty;
    if (showClose != _showCloseButton) {
      setState(() {
        _showCloseButton = showClose;
      });
    }
  }

  void _setQuery(String queryText) {
    _debounce?.cancel();
    setState(() {
      _query = queryText;
      _controller.text = queryText;
      // Place cursor at the end of the text
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: queryText.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(channelsProvider);

    return Scaffold(
      backgroundColor: GoPlayTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Highly polished, glossy iOS-like search bar
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
              decoration: BoxDecoration(
                color: GoPlayTheme.surface.withValues(alpha: 0.8),
                border: Border(
                  bottom: BorderSide(
                    color: GoPlayTheme.cardBorder.withValues(alpha: 0.15),
                    width: 0.8,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: GoPlayTheme.onSurface,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: const Color(0xFF222326),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      child: SizedBox(
                        height: 44,
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          onChanged: (value) {
                            if (_debounce?.isActive ?? false) _debounce!.cancel();
                            _debounce = Timer(const Duration(milliseconds: 250), () {
                              setState(() {
                                _query = value;
                              });
                            });
                          },
                          cursorColor: GoPlayTheme.onSurface,
                          style: GoPlayType.body.copyWith(
                            color: GoPlayTheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search channels, teams, sports...',
                            hintStyle: GoPlayType.body.copyWith(
                              color: GoPlayTheme.onSurfaceMuted,
                            ),
                            isDense: true,
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Colors.white70,
                              size: 20,
                            ),
                            suffixIcon: _showCloseButton
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      _controller.clear();
                                      _debounce?.cancel();
                                      setState(() {
                                        _query = '';
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Results / Empty State
            Expanded(
              child: _query.isEmpty
                  ? _EmptySearchState(
                      channelsAsync: channelsAsync,
                      onTagSelect: _setQuery,
                    )
                  : _SearchResults(
                      query: _query,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final AsyncValue<List<Channel>> channelsAsync;
  final Function(String) onTagSelect;

  const _EmptySearchState({
    required this.channelsAsync,
    required this.onTagSelect,
  });

  @override
  Widget build(BuildContext context) {
    final popularTags = [
      (label: '⚽ Football', query: 'Football'),
      (label: '🏏 Cricket', query: 'Cricket'),
      (label: '🔥 Live', query: 'Live'),
      (label: '🍿 Movies', query: 'Movies'),
      (label: '📺 Sports', query: 'Sports'),
      (label: '🌐 News', query: 'News'),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      physics: const BouncingScrollPhysics(),
      children: [
        // Section: Popular Tags
        Text(
          'POPULAR SEARCHES',
          style: GoPlayType.meta.copyWith(
            color: GoPlayTheme.onSurfaceMuted,
            letterSpacing: GoPlayType.trackingWide,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: popularTags.map((tag) {
            return GestureDetector(
              onTap: () => onTagSelect(tag.query),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: GoPlayTheme.surfaceContainerHigh.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Text(
                  tag.label,
                  style: GoPlayType.label.copyWith(color: GoPlayTheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 36),

        // Section: Recommendations
        Text(
          'RECOMMENDED CHANNELS',
          style: GoPlayType.meta.copyWith(
            color: GoPlayTheme.onSurfaceMuted,
            letterSpacing: GoPlayType.trackingWide,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        channelsAsync.when(
          data: (channels) {
            final liveList = channels.where((ch) => ch.isLive).take(4).toList();
            if (liveList.isEmpty) {
              final fallbacks = channels.take(4).toList();
              if (fallbacks.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'No channels available right now.',
                    style: GoPlayType.body.copyWith(
                      color: GoPlayTheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return Column(
                children: fallbacks.map((ch) => buildRecommendationCard(context, ch)).toList(),
              );
            }
            return Column(
              children: liveList.map((ch) => buildRecommendationCard(context, ch)).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(color: GoPlayTheme.primary),
            ),
          ),
          error: (err, stack) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget buildRecommendationCard(BuildContext context, Channel ch) {
    return GestureDetector(
      onTap: () => context.push('/player/${ch.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: GoPlayTheme.surfaceContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.04),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: GoPlayTheme.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: ch.logo != null && ch.logo!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: ch.logo!,
                      fit: BoxFit.cover,
                      memCacheWidth: 88,
                      memCacheHeight: 88,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                        child: Text(
                          ch.initials,
                          style: GoPlayType.labelSmall.copyWith(
                            color: GoPlayTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          ch.initials,
                          style: GoPlayType.labelSmall.copyWith(
                            color: GoPlayTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        ch.initials,
                        style: GoPlayType.labelSmall.copyWith(
                          color: GoPlayTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ch.displayName,
                    style: GoPlayType.label.copyWith(color: GoPlayTheme.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ch.category ?? 'General'} â€¢ ${ch.country ?? 'Global'}',
                    style: GoPlayType.bodySmall.copyWith(color: GoPlayTheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (ch.isLive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: GoPlayTheme.liveBadge.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: GoPlayTheme.liveBadge.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: GoPlayTheme.liveBadge,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'LIVE',
                      style: GoPlayType.meta.copyWith(color: GoPlayTheme.liveBadge),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Constants â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const int _kPageSize = 50;

class _SearchResults extends ConsumerStatefulWidget {
  final String query;

  const _SearchResults({required this.query});

  @override
  ConsumerState<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<_SearchResults> {
  int _channelLimit = _kPageSize;
  int _eventLimit = _kPageSize;

  // Reset page limits whenever the search query changes so stale
  // paged state from a previous search never bleeds into the new one.
  @override
  void didUpdateWidget(_SearchResults old) {
    super.didUpdateWidget(old);
    if (old.query != widget.query) {
      _channelLimit = _kPageSize;
      _eventLimit = _kPageSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(filteredChannelsProvider(widget.query));
    final eventsAsync = ref.watch(filteredEventsProvider(widget.query));

    // Handle loading states
    if (channelsAsync.isLoading || eventsAsync.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: GoPlayTheme.primary),
      );
    }

    // Handle error states
    if (channelsAsync.hasError || eventsAsync.hasError) {
      return Center(
        child: Text(
          'An error occurred while searching.',
          textAlign: TextAlign.center,
          style: GoPlayType.body.copyWith(color: GoPlayTheme.error),
        ),
      );
    }

    final allChannels = channelsAsync.value ?? const [];
    final allEvents = eventsAsync.value ?? const [];

    final showChannels = allChannels.isNotEmpty;
    final showEvents = allEvents.isNotEmpty;
    final showNoResults = !showChannels && !showEvents;

    if (showNoResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: GoPlayTheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'No results found for "${widget.query}"',
                textAlign: TextAlign.center,
                style: GoPlayType.subtitle.copyWith(
                  color: GoPlayTheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                // The query is user-entered and unbounded.
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // Clamp visible slices to current limits
    final visibleChannels = allChannels.take(_channelLimit).toList();
    final visibleEvents = allEvents.take(_eventLimit).toList();
    final hasMoreChannels = allChannels.length > _channelLimit;
    final hasMoreEvents = allEvents.length > _eventLimit;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // â”€â”€ Channels Section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        if (showChannels) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Text(
                    'CHANNELS',
                    style: GoPlayType.meta.copyWith(
                      color: GoPlayTheme.onSurfaceMuted,
                      letterSpacing: GoPlayType.trackingWide,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${allChannels.length}',
                    style: GoPlayType.inter(
                      color: GoPlayTheme.onSurfaceMuted,
                      fontSize: GoPlayType.xs,
                      fontWeight: FontWeight.w600,
                      height: GoPlayType.leadingSnug,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildChannelCard(context, visibleChannels[index]),
                childCount: visibleChannels.length,
              ),
            ),
          ),
          // Load-more button for channels
          if (hasMoreChannels)
            SliverToBoxAdapter(
              child: _LoadMoreButton(
                remaining: allChannels.length - _channelLimit,
                onTap: () => setState(() => _channelLimit += _kPageSize),
              ),
            ),
        ],

        // Spacing between sections
        if (showChannels && showEvents)
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // â”€â”€ Events Section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        if (showEvents) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Text(
                    'LIVE EVENTS',
                    style: GoPlayType.meta.copyWith(
                      color: GoPlayTheme.onSurfaceMuted,
                      letterSpacing: GoPlayType.trackingWide,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${allEvents.length}',
                    style: GoPlayType.inter(
                      color: GoPlayTheme.onSurfaceMuted,
                      fontSize: GoPlayType.xs,
                      fontWeight: FontWeight.w600,
                      height: GoPlayType.leadingSnug,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildEventCard(context, visibleEvents[index]),
                childCount: visibleEvents.length,
              ),
            ),
          ),
          // Load-more button for events
          if (hasMoreEvents)
            SliverToBoxAdapter(
              child: _LoadMoreButton(
                remaining: allEvents.length - _eventLimit,
                onTap: () => setState(() => _eventLimit += _kPageSize),
              ),
            ),
        ],

        // Bottom spacing
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildChannelCard(BuildContext context, Channel ch) {
    return GestureDetector(
      onTap: () => context.push('/player/${ch.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: GoPlayTheme.surfaceContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.04),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            _ChannelAvatar(ch: ch),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ch.displayName,
                    style: GoPlayType.label.copyWith(color: GoPlayTheme.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ch.category ?? 'General'} â€¢ ${ch.country ?? 'Global'}',
                    style: GoPlayType.bodySmall.copyWith(color: GoPlayTheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (ch.isLive) const _LiveBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, SportEvent event) {
    return GestureDetector(
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: GoPlayTheme.surfaceContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.04),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GoPlayTheme.surfaceContainerHigh.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
              child: TeamFlagWidget(flag: event.homeTeam.flag, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event.homeTeam.name} vs ${event.awayTeam.name}',
                    style: GoPlayType.label.copyWith(color: GoPlayTheme.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${event.league} â€¢ ${event.sport}',
                    style: GoPlayType.bodySmall.copyWith(color: GoPlayTheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (event.isLive) const _LiveBadge(),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Shared micro-widgets (extracted to avoid repeated allocations) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

/// Circular channel logo with text-initials fallback.
class _ChannelAvatar extends StatelessWidget {
  final Channel ch;
  const _ChannelAvatar({required this.ch});

  String get _initials =>
      ch.initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: GoPlayTheme.surfaceContainerHigh,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: ch.logo != null && ch.logo!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: ch.logo!,
              fit: BoxFit.cover,
              memCacheWidth: 88,
              memCacheHeight: 88,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Center(
                child: Text(
                  _initials,
                  style: GoPlayType.labelSmall.copyWith(
                    color: GoPlayTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Text(
                  _initials,
                  style: GoPlayType.labelSmall.copyWith(
                    color: GoPlayTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                _initials,
                style: GoPlayType.labelSmall.copyWith(
                  color: GoPlayTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }
}

/// LIVE pill badge â€” const constructor so Flutter reuses the same element.
class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: GoPlayTheme.liveBadge.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: GoPlayTheme.liveBadge.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: GoPlayTheme.liveBadge,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'LIVE',
            style: GoPlayType.meta.copyWith(color: GoPlayTheme.liveBadge),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

/// "Load X more" tappable row shown below a capped section.
class _LoadMoreButton extends StatelessWidget {
  final int remaining;
  final VoidCallback onTap;

  const _LoadMoreButton({required this.remaining, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = remaining > _kPageSize
        ? 'Show $_kPageSize more  ($remaining remaining)'
        : 'Show all $remaining remaining';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: GoPlayTheme.surfaceContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.expand_more_rounded,
                color: GoPlayTheme.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoPlayType.label.copyWith(color: GoPlayTheme.primary),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
