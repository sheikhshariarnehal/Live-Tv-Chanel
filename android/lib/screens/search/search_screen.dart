import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/channel.dart';
import '../../models/event.dart';
import '../../widgets/team_flag.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuery(String queryText) {
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
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: GoPlayTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Highly polished, glossy iOS-like search bar
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
              decoration: BoxDecoration(
                color: GoPlayTheme.surface.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(
                    color: GoPlayTheme.cardBorder.withOpacity(0.15),
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
                              color: Colors.white.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.25),
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
                          onChanged: (value) => setState(() => _query = value),
                          cursorColor: Colors.white,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search channels, teams, sports...',
                            hintStyle: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            isDense: true,
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Colors.white70,
                              size: 20,
                            ),
                            suffixIcon: _query.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      _controller.clear();
                                      setState(() => _query = '');
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
                      channelsAsync: channelsAsync,
                      eventsAsync: eventsAsync,
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
      '⚽ Football',
      '🏏 Cricket',
      '🔥 Live',
      '🍿 Movies',
      '📺 Sports',
      '🌐 News'
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      physics: const BouncingScrollPhysics(),
      children: [
        // Section: Popular Tags
        Text(
          'POPULAR SEARCHES',
          style: GoogleFonts.inter(
            color: GoPlayTheme.onSurfaceVariant.withOpacity(0.5),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: popularTags.map((tag) {
            // Extract core keyword for searching
            final queryText = tag.substring(2);
            return GestureDetector(
              onTap: () => onTagSelect(queryText),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: GoPlayTheme.surfaceContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.04),
                    width: 1,
                  ),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.inter(
                    color: GoPlayTheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 36),

        // Section: Recommendations
        Text(
          'RECOMMENDED CHANNELS',
          style: GoogleFonts.inter(
            color: GoPlayTheme.onSurfaceVariant.withOpacity(0.5),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
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
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurfaceVariant,
                      fontSize: 13,
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
          color: GoPlayTheme.surfaceContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.04),
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
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: ch.logo != null && ch.logo!.isNotEmpty
                    ? Image.network(
                        ch.logo!,
                        fit: BoxFit.cover,
                        cacheWidth: 88,
                        cacheHeight: 88,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                            ch.name.substring(0, ch.name.length >= 2 ? 2 : 1).toUpperCase(),
                            style: const TextStyle(
                              color: GoPlayTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          ch.name.substring(0, ch.name.length >= 2 ? 2 : 1).toUpperCase(),
                          style: const TextStyle(
                            color: GoPlayTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
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
                    ch.name,
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ch.category ?? 'General'} • ${ch.country ?? 'Global'}',
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (ch.isLive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: GoPlayTheme.liveBadge.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: GoPlayTheme.liveBadge.withOpacity(0.3),
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
                      style: GoogleFonts.inter(
                        color: GoPlayTheme.liveBadge,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
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

class _SearchResults extends StatelessWidget {
  final String query;
  final AsyncValue<List<Channel>> channelsAsync;
  final AsyncValue<List<SportEvent>> eventsAsync;

  const _SearchResults({
    required this.query,
    required this.channelsAsync,
    required this.eventsAsync,
  });

  @override
  Widget build(BuildContext context) {
    final lowerQuery = query.toLowerCase();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        // Channel results
        channelsAsync.when(
          data: (channels) {
            final filtered = channels.where((ch) {
              return ch.name.toLowerCase().contains(lowerQuery) ||
                  (ch.category?.toLowerCase().contains(lowerQuery) ?? false) ||
                  (ch.country?.toLowerCase().contains(lowerQuery) ?? false) ||
                  (ch.language?.toLowerCase().contains(lowerQuery) ?? false);
            }).toList();

            if (filtered.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'CHANNELS',
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurfaceVariant.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                ...filtered.map((ch) => buildChannelResultCard(context, ch)),
                const SizedBox(height: 20),
              ],
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

        // Event results
        eventsAsync.when(
          data: (events) {
            final filtered = events.where((e) {
              return e.league.toLowerCase().contains(lowerQuery) ||
                  e.sport.toLowerCase().contains(lowerQuery) ||
                  e.homeTeam.name.toLowerCase().contains(lowerQuery) ||
                  e.awayTeam.name.toLowerCase().contains(lowerQuery);
            }).toList();

            if (filtered.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'LIVE EVENTS',
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurfaceVariant.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                ...filtered.map((event) => buildEventResultCard(context, event)),
                const SizedBox(height: 20),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (err, stack) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget buildChannelResultCard(BuildContext context, Channel ch) {
    return GestureDetector(
      onTap: () => context.push('/player/${ch.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: GoPlayTheme.surfaceContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.04),
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
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: ch.logo != null && ch.logo!.isNotEmpty
                    ? Image.network(
                        ch.logo!,
                        fit: BoxFit.cover,
                        cacheWidth: 88,
                        cacheHeight: 88,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                            ch.name.substring(0, ch.name.length >= 2 ? 2 : 1).toUpperCase(),
                            style: const TextStyle(
                              color: GoPlayTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          ch.name.substring(0, ch.name.length >= 2 ? 2 : 1).toUpperCase(),
                          style: const TextStyle(
                            color: GoPlayTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
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
                    ch.name,
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ch.category ?? 'General'} • ${ch.country ?? 'Global'}',
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (ch.isLive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: GoPlayTheme.liveBadge.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: GoPlayTheme.liveBadge.withOpacity(0.3),
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
                      style: GoogleFonts.inter(
                        color: GoPlayTheme.liveBadge,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildEventResultCard(BuildContext context, SportEvent event) {
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
          color: GoPlayTheme.surfaceContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.04),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GoPlayTheme.surfaceContainerHigh.withOpacity(0.6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                  width: 1,
                ),
              ),
              child: TeamFlagWidget(
                flag: event.homeTeam.flag,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event.homeTeam.name} vs ${event.awayTeam.name}',
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${event.league} • ${event.sport}',
                    style: GoogleFonts.inter(
                      color: GoPlayTheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (event.isLive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: GoPlayTheme.liveBadge.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: GoPlayTheme.liveBadge.withOpacity(0.3),
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
                      style: GoogleFonts.inter(
                        color: GoPlayTheme.liveBadge,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
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
