import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _debounceTimer?.cancel();
      if (!_isSearching) {
        _searchController.clear();
        _localSearchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final channelsAsync = ref.watch(
      channelsByCategoryProvider(selectedCategory),
    );
    final favorites = ref.watch(favoriteChannelIdsProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent: 150.0,
        slivers: [
          // Dynamic App Bar supporting search and categories
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 0,
            leading: const SizedBox.shrink(),
            titleSpacing: 16,
            toolbarHeight: 56,
            title: _isSearching
                ? Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0x1F000000), // Very dark glossy backdrop
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.fromBorderSide(
                        BorderSide(color: Color(0x14FFFFFF), width: 0.8),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (val) {
                        if (_debounceTimer?.isActive ?? false) {
                          _debounceTimer!.cancel();
                        }
                        _debounceTimer = Timer(
                          const Duration(milliseconds: 180),
                          () {
                            setState(() => _localSearchQuery = val);
                          },
                        );
                      },
                      style: const TextStyle(
                        color: GoPlayTheme.onSurface,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search channels by name, country...',
                        hintStyle: TextStyle(
                          color: GoPlayTheme.onSurfaceVariant.withAlpha(120),
                          fontSize: 14,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: GoPlayTheme.primary,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: GoPlayTheme.onSurfaceVariant,
                            size: 18,
                          ),
                          onPressed: () {
                            if (_searchController.text.isEmpty) {
                              _toggleSearch();
                            } else {
                              _searchController.clear();
                              _debounceTimer?.cancel();
                              setState(() => _localSearchQuery = '');
                            }
                          },
                        ),
                      ),
                    ),
                  )
                : Text(
                    'CHANNELS',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: GoPlayTheme.primary,
                      letterSpacing: 3,
                    ),
                  ),
            actions: _isSearching
                ? null
                : [
                    IconButton(
                      icon: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: _toggleSearch,
                    ),
                    const SizedBox(width: 8),
                  ],
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xCC0D0D12), // Glassy premium dark theme
                    border: Border(
                      bottom: BorderSide(
                        color: Color(
                          0x14FFFFFF,
                        ), // Translucent white border @ 8%
                        width: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _CategoryFilterBar(
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
              final query = _localSearchQuery.trim().toLowerCase();
              final filtered = query.isEmpty
                  ? channels
                  : channels.where((ch) {
                      final nameMatch = ch.name.toLowerCase().contains(query);
                      final countryMatch =
                          ch.country?.toLowerCase().contains(query) ?? false;
                      final languageMatch =
                          ch.language?.toLowerCase().contains(query) ?? false;
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
                          decoration: const BoxDecoration(
                            color: Color(0x0DFFFFFF),
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: Color(0x14FFFFFF), width: 0.8),
                            ),
                          ),
                          child: const Icon(
                            Icons.live_tv_outlined,
                            size: 32,
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
                            fontSize: 14,
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
                            style: const TextStyle(
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
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: GoPlayTheme.error,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Error loading channels',
                      style: TextStyle(color: GoPlayTheme.error),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$e',
                      style: const TextStyle(
                        color: GoPlayTheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => ref.invalidate(
                        channelsByCategoryProvider(selectedCategory),
                      ),
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
    BuildContext context,
  ) {
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
class _CategoryFilterBar extends ConsumerWidget {
  final VoidCallback onCategorySelected;

  const _CategoryFilterBar({required this.onCategorySelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final allChannelsAsync = ref.watch(channelsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Container(
      height: 48,
      color: Colors.transparent, // Let glassy background shine through
      alignment: Alignment.center,
      child: SizedBox(
        height: 42,
        child: categoriesAsync.when(
          data: (categories) {
            final allChannels = allChannelsAsync.when(
              data: (data) => data,
              loading: () => [],
              error: (err, stack) => [],
            );
            final catCounts = <String, int>{};
            for (final ch in allChannels) {
              final cat = ch.category ?? 'uncategorized';
              catCounts[cat] = (catCounts[cat] ?? 0) + 1;
            }

            // Filter out categories with 0 channels to avoid empty screens
            final activeCategories = categories
                .where((cat) => (catCounts[cat.id] ?? 0) > 0)
                .toList();

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
                    ref.read(selectedCategoryProvider.notifier).select('all');
                    onCategorySelected();
                  },
                ),
                ...activeCategories.map(
                  (cat) => _CategoryChip(
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
                  ),
                ),
              ],
            );
          },
          loading: () => const SizedBox(height: 42),
          error: (err, stack) => const SizedBox(height: 42),
        ),
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
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 8, bottom: 6, top: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? GoPlayTheme.primary.withAlpha(30)
              : const Color(0x0DFFFFFF), // Subtle translucent white
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.fromBorderSide(
            BorderSide(
              color: isSelected
                  ? GoPlayTheme.primary.withAlpha(120)
                  : const Color(0x14FFFFFF),
              width: 0.8,
            ),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: GoPlayTheme.primary.withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : GoPlayTheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected
                    ? GoPlayTheme.primary.withAlpha(60)
                    : const Color(0x1AFFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0x99FFFFFF),
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
      decoration: const BoxDecoration(
        color: Color(0x0DFFFFFF), // Subtle translucent white
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0x14FFFFFF), width: 0.8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0x1AFFFFFF),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0x1AFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 35,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0x1AFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
