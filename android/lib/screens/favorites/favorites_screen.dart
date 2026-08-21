import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../providers/app_providers.dart';
import '../../widgets/cards/channel_card.dart';

const double _kGridSpacing = 8.0;
const double _kGridEdgeInset = 10.0;

/// Dedicated full-page screen displaying user's favorited channels.
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearch() => setState(() => _isSearching = true);

  void _closeSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value.trim().toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoriteChannelsProvider);

    return PopScope(
      canPop: !_isSearching,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _isSearching) _closeSearch();
      },
      child: Scaffold(
        backgroundColor: GoPlayTheme.darkSurface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: GoPlayTheme.darkSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: _isSearching
              ? null
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
          titleSpacing: _isSearching ? 16 : 0,
          title: _isSearching
              ? SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                    cursorColor: GoPlayTheme.primary,
                    style: GoPlayType.body.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: GoPlayTheme.surfaceContainerHigh,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      hintText: 'Search favorites…',
                      hintStyle: GoPlayType.body.copyWith(
                        color: GoPlayTheme.onSurfaceVariant,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: GoPlayTheme.cardBorder,
                          width: 0.8,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: GoPlayTheme.cardBorder,
                          width: 0.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: GoPlayTheme.primary,
                          width: 1.2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: GoPlayTheme.onSurfaceVariant,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(
                          Icons.close_rounded,
                          color: GoPlayTheme.onSurfaceVariant,
                          size: 18,
                        ),
                        onPressed: _closeSearch,
                      ),
                    ),
                  ),
                )
              : Row(
                  children: [
                    const Icon(
                      Icons.bookmark_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Favorites',
                      style: TextStyle(
                        fontFamily: GoPlayType.family,
                        fontSize: GoPlayType.lg,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    favoritesAsync.maybeWhen(
                      data: (channels) => channels.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: GoPlayTheme.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${channels.length}',
                                style: const TextStyle(
                                  fontFamily: GoPlayType.family,
                                  fontSize: GoPlayType.xs,
                                  fontWeight: FontWeight.w700,
                                  color: GoPlayTheme.primary,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ],
                ),
          actions: _isSearching
              ? null
              : [
                  favoritesAsync.maybeWhen(
                    data: (channels) => channels.isNotEmpty
                        ? IconButton(
                            tooltip: 'Search favorites',
                            icon: const Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: _openSearch,
                          )
                        : const SizedBox.shrink(),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8),
                ],
        ),
        body: favoritesAsync.when(
          data: (channels) {
            if (channels.isEmpty) {
              return _buildEmptyState(context);
            }

            final filtered = _searchQuery.isEmpty
                ? channels
                : channels
                    .where((ch) => ch.searchIndex.contains(_searchQuery))
                    .toList();

            if (filtered.isEmpty) {
              return _buildNoSearchResults(context);
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: _kGridEdgeInset,
                    right: _kGridEdgeInset,
                    top: _kGridEdgeInset,
                    bottom: MediaQuery.paddingOf(context).bottom + 24,
                  ),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final gridDelegate = _buildGridDelegate(
                        context,
                        constraints.crossAxisExtent,
                      );
                      return SliverGrid(
                        gridDelegate: gridDelegate,
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ChannelCard(
                            key: ValueKey(filtered[index].id),
                            channel: filtered[index],
                          ),
                          childCount: filtered.length,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: true,
                          addSemanticIndexes: false,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: GoPlayTheme.primary),
          ),
          error: (err, _) => Center(
            child: Text(
              'Error loading favorites: $err',
              style: const TextStyle(color: GoPlayTheme.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: GoPlayTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_outline_rounded,
                size: 56,
                color: GoPlayTheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Favorite Channels Yet',
              style: TextStyle(
                fontFamily: GoPlayType.family,
                fontSize: GoPlayType.lg,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Long press any channel in the Channels tab to save it to your favorites.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: GoPlayType.family,
                fontSize: GoPlayType.sm,
                color: GoPlayTheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/channels'),
              icon: const Icon(Icons.smart_display_rounded, size: 18),
              label: const Text('EXPLORE CHANNELS'),
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
    );
  }

  Widget _buildNoSearchResults(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: GoPlayTheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            const Text(
              'No matching favorites',
              style: TextStyle(
                fontFamily: GoPlayType.family,
                fontSize: GoPlayType.base,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'No channels in your favorites match "$_searchQuery".',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: GoPlayType.family,
                fontSize: GoPlayType.sm,
                color: GoPlayTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Text('Clear search'),
            ),
          ],
        ),
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _buildGridDelegate(
    BuildContext context,
    double crossAxisExtent,
  ) {
    final int cols;
    if (crossAxisExtent >= 1180) {
      cols = 6;
    } else if (crossAxisExtent >= 880) {
      cols = 5;
    } else if (crossAxisExtent >= 580) {
      cols = 4;
    } else {
      cols = 3;
    }

    final tileWidth = (crossAxisExtent - _kGridSpacing * (cols - 1)) / cols;
    final tileHeight = math.max(tileWidth, ChannelCard.measureHeight(context));

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: cols,
      childAspectRatio: tileWidth <= 0 ? 1.0 : tileWidth / tileHeight,
      crossAxisSpacing: _kGridSpacing,
      mainAxisSpacing: _kGridSpacing,
    );
  }
}
