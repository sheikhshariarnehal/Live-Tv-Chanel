import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/cards/channel_card.dart';

class ChannelsScreen extends ConsumerStatefulWidget {
  const ChannelsScreen({super.key});

  @override
  ConsumerState<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends ConsumerState<ChannelsScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String _localSearchQuery = '';
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _localSearchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final channelsAsync = ref.watch(channelsByCategoryProvider(selectedCategory));
    final favorites = ref.watch(favoriteChannelIdsProvider);
    final allChannelsAsync = ref.watch(channelsProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Dynamic App Bar supporting search and categories
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 110,
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (val) {
                        setState(() => _localSearchQuery = val);
                      },
                      style: const TextStyle(
                        color: GoPlayTheme.onSurface,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search channels by name, country...',
                        hintStyle: TextStyle(
                          color: GoPlayTheme.onSurfaceVariant.withAlpha(120),
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: GoPlayTheme.primary,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: GoPlayTheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            if (_searchController.text.isEmpty) {
                              _toggleSearch();
                            } else {
                              _searchController.clear();
                              setState(() => _localSearchQuery = '');
                            }
                          },
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        const Text('Channels'),
                        const SizedBox(width: 8),
                        // Channel count badge
                        allChannelsAsync.when(
                          data: (channels) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: GoPlayTheme.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${channels.length}',
                              style: TextStyle(
                                color: GoPlayTheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
            ),
            actions: [
              if (!_isSearching)
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: _toggleSearch,
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _CategoryFilterBar(
                categoriesAsync: categoriesAsync,
                allChannelsAsync: allChannelsAsync,
                selectedCategory: selectedCategory,
                ref: ref,
                onCategorySelected: () {
                  // Scroll to top when changing category
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ),

          // Channel Grid
          channelsAsync.when(
            data: (channels) {
              // Apply search filter locally for instant performance
              final filtered = _localSearchQuery.isEmpty
                  ? channels
                  : channels.where((ch) {
                      final nameMatch = ch.name
                          .toLowerCase()
                          .contains(_localSearchQuery.toLowerCase());
                      final countryMatch = ch.country
                              ?.toLowerCase()
                              .contains(_localSearchQuery.toLowerCase()) ??
                          false;
                      final languageMatch = ch.language
                              ?.toLowerCase()
                              .contains(_localSearchQuery.toLowerCase()) ??
                          false;
                      return nameMatch || countryMatch || languageMatch;
                    }).toList();

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: GoPlayTheme.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.live_tv_outlined,
                            size: 36,
                            color: GoPlayTheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _localSearchQuery.isNotEmpty
                              ? 'No channels match your search'
                              : 'No channels in this category',
                          style: const TextStyle(
                            color: GoPlayTheme.onSurfaceVariant,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            if (_localSearchQuery.isNotEmpty) {
                              _searchController.clear();
                              setState(() => _localSearchQuery = '');
                            } else {
                              ref
                                  .read(selectedCategoryProvider.notifier)
                                  .select('all');
                            }
                          },
                          child: Text(
                            _localSearchQuery.isNotEmpty
                                ? 'Clear Search'
                                : 'View all channels',
                            style: TextStyle(
                              color: GoPlayTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return _ResponsiveGrid(
                channels: filtered,
                favorites: favorites,
                ref: ref,
              );
            },
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverGrid(
                gridDelegate: _getGridDelegate(context),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _ShimmerCard(),
                  childCount: 12,
                ),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48, color: GoPlayTheme.error),
                    const SizedBox(height: 8),
                    Text('Error loading channels',
                        style: TextStyle(color: GoPlayTheme.error)),
                    const SizedBox(height: 4),
                    Text('$e',
                        style: TextStyle(
                            color: GoPlayTheme.onSurfaceVariant, fontSize: 12)),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => ref.invalidate(
                          channelsByCategoryProvider(selectedCategory)),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static SliverGridDelegateWithFixedCrossAxisCount _getGridDelegate(
      BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double ratio;

    if (width >= 1200) {
      crossAxisCount = 6;
      ratio = 1.15;
    } else if (width >= 900) {
      crossAxisCount = 5;
      ratio = 1.12;
    } else if (width >= 600) {
      crossAxisCount = 4;
      ratio = 1.08;
    } else if (width >= 400) {
      crossAxisCount = 3;
      ratio = 1.05;
    } else {
      // Mobile - 2 columns
      crossAxisCount = 2;
      ratio = 1.15;
    }

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: ratio,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    );
  }
}

// ─── Category Filter Bar ──────────────────────────────────────
class _CategoryFilterBar extends StatelessWidget {
  final AsyncValue categoriesAsync;
  final AsyncValue allChannelsAsync;
  final String selectedCategory;
  final WidgetRef ref;
  final VoidCallback onCategorySelected;

  const _CategoryFilterBar({
    required this.categoriesAsync,
    required this.allChannelsAsync,
    required this.selectedCategory,
    required this.ref,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: categoriesAsync.when(
        data: (categories) {
          final allChannels = allChannelsAsync.when(
            data: (data) => data as List,
            loading: () => [],
            error: (_, __) => [],
          );
          final catCounts = <String, int>{};
          for (final ch in allChannels) {
            final cat = ch.category ?? 'uncategorized';
            catCounts[cat] = (catCounts[cat] ?? 0) + 1;
          }

          // Filter out categories with 0 channels to avoid empty screens
          final activeCategories =
              categories.where((cat) => (catCounts[cat.id] ?? 0) > 0).toList();

          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _CategoryChip(
                label: 'All',
                icon: '📺',
                count: allChannels.length,
                isSelected: selectedCategory == 'all',
                onTap: () {
                  ref
                      .read(selectedCategoryProvider.notifier)
                      .select('all');
                  onCategorySelected();
                },
              ),
              ...activeCategories.map((cat) => _CategoryChip(
                    label: cat.name,
                    icon: cat.icon ?? '📁',
                    count: catCounts[cat.id] ?? 0,
                    isSelected: selectedCategory == cat.id,
                    onTap: () {
                      ref
                          .read(selectedCategoryProvider.notifier)
                          .select(cat.id);
                      onCategorySelected();
                    },
                  )),
            ],
          );
        },
        loading: () => const SizedBox(height: 42),
        error: (_, __) => const SizedBox(height: 42),
      ),
    );
  }
}

// ─── Responsive Grid ──────────────────────────────────────────
class _ResponsiveGrid extends StatelessWidget {
  final List channels;
  final Set<String> favorites;
  final WidgetRef ref;

  const _ResponsiveGrid({
    required this.channels,
    required this.favorites,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid(
        gridDelegate: _ChannelsScreenState._getGridDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final channel = channels[index];
            return ChannelCard(
              channel: channel,
              isFavorite: favorites.contains(channel.id),
              onFavoriteTap: () {
                ref
                    .read(favoriteChannelIdsProvider.notifier)
                    .toggle(channel.id);
              },
            );
          },
          childCount: channels.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    );
  }
}

// ─── Category Chip ────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final String label;
  final String icon;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? GoPlayTheme.primary.withAlpha(25)
              : GoPlayTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? GoPlayTheme.primary : GoPlayTheme.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? GoPlayTheme.primary : GoPlayTheme.onSurface,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? GoPlayTheme.primary.withAlpha(30)
                    : GoPlayTheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected
                      ? GoPlayTheme.primary
                      : GoPlayTheme.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shimmer Loading Card ─────────────────────────────────────
class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: GoPlayTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GoPlayTheme.cardBorder, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: GoPlayTheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 60,
              height: 12,
              decoration: BoxDecoration(
                color: GoPlayTheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 35,
              height: 10,
              decoration: BoxDecoration(
                color: GoPlayTheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
