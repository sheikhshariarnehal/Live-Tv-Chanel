import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(channelsProvider);
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: GoPlayTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: GoPlayTheme.onSurface),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: (value) => setState(() => _query = value),
                      style: const TextStyle(
                          color: GoPlayTheme.onSurface, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search channels, teams, sports...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded,
                                    color: GoPlayTheme.onSurfaceVariant),
                                onPressed: () {
                                  _controller.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Results
            Expanded(
              child: _query.isEmpty
                  ? _EmptySearchState()
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_rounded,
              size: 60, color: GoPlayTheme.onSurfaceVariant.withAlpha(80)),
          const SizedBox(height: 12),
          const Text(
            'Search for channels, teams, or sports',
            style: TextStyle(color: GoPlayTheme.onSurfaceVariant),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'CHANNELS (${filtered.length})',
                    style: const TextStyle(
                      color: GoPlayTheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                ...filtered.map((ch) => ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: GoPlayTheme.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            ch.name.substring(0, ch.name.length >= 2 ? 2 : 1).toUpperCase(),
                            style: TextStyle(
                              color: GoPlayTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        ch.name,
                        style: const TextStyle(color: GoPlayTheme.onSurface),
                      ),
                      subtitle: Text(
                        '${ch.category ?? ''} • ${ch.country ?? ''}',
                        style: const TextStyle(
                          color: GoPlayTheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      trailing: ch.isLive
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: GoPlayTheme.liveBadge.withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: GoPlayTheme.liveBadge,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : null,
                      contentPadding: EdgeInsets.zero,
                      onTap: () => context.push('/player/${ch.id}'),
                    )),
                const SizedBox(height: 16),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: GoPlayTheme.primary),
          ),
          error: (_, __) => const SizedBox.shrink(),
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
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'EVENTS (${filtered.length})',
                    style: const TextStyle(
                      color: GoPlayTheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                ...filtered.map((event) => ListTile(
                      leading: TeamFlagWidget(
                        flag: event.homeTeam.flag,
                        size: 24,
                      ),
                      title: Text(
                        '${event.homeTeam.name} vs ${event.awayTeam.name}',
                        style: const TextStyle(color: GoPlayTheme.onSurface),
                      ),
                      subtitle: Text(
                        '${event.league} • ${event.sport}',
                        style: const TextStyle(
                          color: GoPlayTheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      trailing: event.isLive
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: GoPlayTheme.liveBadge.withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: GoPlayTheme.liveBadge,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : null,
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        if (event.channels.isNotEmpty) {
                          context.push('/player/${event.channels.first}');
                        }
                      },
                    )),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
