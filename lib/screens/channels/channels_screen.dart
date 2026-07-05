import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/cards/channel_card.dart';

// ─── Pre-cached styles — allocated once, never again ─────────
final TextStyle _titleStyle = GoogleFonts.orbitron(
  fontSize: 20,
  fontWeight: FontWeight.w300,
  color: GoPlayTheme.primary,
  letterSpacing: 3,
);

// ─── Pre-cached appbar glass decoration ──────────────────────
const BoxDecoration _appBarGlass = BoxDecoration(
  color: Color(0xCC17181C),
  border: Border(bottom: BorderSide(color: GoPlayTheme.cardBorder, width: 0.8)),
);

// ─── Pre-cached search field decoration ──────────────────────
const BoxDecoration _searchBoxDecoration = BoxDecoration(
  color: Color(0x1F000000),
  borderRadius: BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
);

// ─── Pre-cached search text style ────────────────────────────
const TextStyle _searchTextStyle = TextStyle(
  color: GoPlayTheme.onSurface,
  fontSize: 14,
);

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

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    // Cache padding lookup — avoids full MediaQueryData allocation each frame
    final topPad = MediaQuery.paddingOf(context).top;
    final channelsAsync = ref.watch(
      channelsByCategoryProvider(selectedCategory),
    );
    final favorites = ref.watch(favoriteChannelIdsProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent: 200.0,
        slivers: [
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
                ? _SearchField(
                    controller: _searchController,
                    onChanged: (val) {
                      if (_debounceTimer?.isActive ?? false) {
                        _debounceTimer!.cancel();
                      }
                      _debounceTimer = Timer(
                        const Duration(milliseconds: 180),
                        () => setState(() => _localSearchQuery = val),
                      );
                    },
                    onClose: () {
                      if (_searchController.text.isEmpty) {
                        _toggleSearch();
                      } else {
                        _searchController.clear();
                        _debounceTimer?.cancel();
                        setState(() => _localSearchQuery = '');
                      }
                    },
                  )
                : Text('CHANNELS', style: _titleStyle),
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
            // RepaintBoundary isolates the blur surface so it is not
            // re-rasterised whenever the list scrolls beneath it.
            flexibleSpace: RepaintBoundary(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14.0, sigmaY: 14.0),
                  child: const DecoratedBox(
                    decoration: _appBarGlass,
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _CategoryFilterBar(onCategorySelected: _scrollToTop),
            ),
          ),

          // Channel Grid
          channelsAsync.when(
            data: (channels) {
              final query = _localSearchQuery.trim().toLowerCase();
              final filtered = query.isEmpty
                  ? channels
                  : channels.where((ch) {
                      return ch.name.toLowerCase().contains(query) ||
                          (ch.country?.toLowerCase().contains(query) ??
                              false) ||
                          (ch.language?.toLowerCase().contains(query) ?? false);
                    }).toList();

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(
                    isSearch: _localSearchQuery.isNotEmpty,
                    onAction: () {
                      if (_localSearchQuery.isNotEmpty) {
                        _searchController.clear();
                        setState(() => _localSearchQuery = '');
                      } else {
                        ref
                            .read(selectedCategoryProvider.notifier)
                            .select('all');
                      }
                    },
                  ),
                );
              }

              return _ResponsiveGrid(
                channels: filtered,
                favorites: favorites,
                ref: ref,
                topPad: topPad,
              );
            },
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: _gridDelegate(context),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => const _ShimmerCard(),
                  childCount: 12,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                ),
              ),
            ),
            error: (e, s) => SliverFillRemaining(
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

  // Static — never changes at runtime so no need to recreate.
  static SliverGridDelegateWithFixedCrossAxisCount _gridDelegate(
    BuildContext context,
  ) {
    final width = MediaQuery.sizeOf(context).width;
    final int cols;
    if (width >= 1200) {
      cols = 6;
    } else if (width >= 900) {
      cols = 5;
    } else if (width >= 600) {
      cols = 4;
    } else {
      cols = 3;
    }
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: cols,
      childAspectRatio: 1.0,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    );
  }
}

// ─── Search Field — extracted so parent does not rebuild it ──
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: _searchBoxDecoration,
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: onChanged,
        style: _searchTextStyle,
        decoration: InputDecoration(
          hintText: 'Search channels by name, country...',
          hintStyle: const TextStyle(
            color: GoPlayTheme.onSurfaceVariant,
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
            onPressed: onClose,
          ),
        ),
      ),
    );
  }
}

// ─── Empty State — extracted stateless widget ─────────────────
class _EmptyState extends StatelessWidget {
  final bool isSearch;
  final VoidCallback onAction;

  const _EmptyState({required this.isSearch, required this.onAction});

  static const _iconDecoration = BoxDecoration(
    color: Color(0x0DFFFFFF),
    shape: BoxShape.circle,
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x14FFFFFF), width: 0.8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: _iconDecoration,
            child: const Icon(
              Icons.live_tv_outlined,
              size: 32,
              color: GoPlayTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isSearch
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
            onPressed: onAction,
            child: Text(
              isSearch ? 'Clear Search' : 'View all channels',
              style: const TextStyle(
                color: GoPlayTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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

    return SizedBox(
      height: 48,
      child: categoriesAsync.when(
        data: (categories) {
          final allChannels = allChannelsAsync.maybeWhen(
            data: (data) => data,
            orElse: () => const [],
          );

          // Build count map once per provider change — not per chip build.
          final catCounts = <String, int>{};
          for (final ch in allChannels) {
            final cat = ch.category ?? 'uncategorized';
            catCounts[cat] = (catCounts[cat] ?? 0) + 1;
          }

          final activeCategories = categories
              .where((cat) => (catCounts[cat.id] ?? 0) > 0)
              .toList();

          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _CategoryChip(
                label: 'All',
                count: allChannels.length,
                isSelected: selectedCategory == 'all',
                onTap: () {
                  ref.read(selectedCategoryProvider.notifier).select('all');
                  onCategorySelected();
                },
              ),
              for (final cat in activeCategories)
                _CategoryChip(
                  label: cat.name,
                  count: catCounts[cat.id] ?? 0,
                  isSelected: selectedCategory == cat.id,
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).select(cat.id);
                    onCategorySelected();
                  },
                ),
            ],
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (e, s) => const SizedBox.shrink(),
      ),
    );
  }
}

// ─── Responsive Grid ──────────────────────────────────────────
class _ResponsiveGrid extends StatelessWidget {
  final List channels;
  final Set<String> favorites;
  final WidgetRef ref;
  final double topPad;

  const _ResponsiveGrid({
    required this.channels,
    required this.favorites,
    required this.ref,
    required this.topPad,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverGrid(
        gridDelegate: _ChannelsScreenState._gridDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final channel = channels[index];
            return ChannelCard(
              key: ValueKey(channel.id),
              channel: channel,
              isFavorite: favorites.contains(channel.id),
              onFavoriteTap: () => ref
                  .read(favoriteChannelIdsProvider.notifier)
                  .toggle(channel.id),
            );
          },
          childCount: channels.length,
          // Large catalogs: let the sliver recycle elements freely.
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
        ),
      ),
    );
  }
}

// ─── Category Chip ────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  // Pre-allocated decorations — zero per-frame cost.
  static const _unselectedDeco = BoxDecoration(
    color: Color(0x0DFFFFFF),
    borderRadius: BorderRadius.all(Radius.circular(20)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x14FFFFFF), width: 0.8),
    ),
  );

  static const _selectedDeco = BoxDecoration(
    color: Color(0x1E00E676), // primary @ ~12%
    borderRadius: BorderRadius.all(Radius.circular(20)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x7800E676), width: 0.8), // primary @ ~47%
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x2800E676), // primary @ ~16%
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  static const _countSelectedDeco = BoxDecoration(
    color: Color(0x3C00E676), // primary @ ~24%
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  static const _countUnselectedDeco = BoxDecoration(
    color: Color(0x1AFFFFFF),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 8, bottom: 6, top: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: isSelected ? _selectedDeco : _unselectedDeco,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            // Plain Container — AnimatedContainer here caused a second
            // layout-pass per chip on every selection change.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: isSelected
                  ? _countSelectedDeco
                  : _countUnselectedDeco,
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

// ─── Shimmer Loading Card — fully const ───────────────────────
class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  static const _cardDeco = BoxDecoration(
    color: Color(0x0DFFFFFF),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x14FFFFFF), width: 0.8),
    ),
  );

  static const _circleDeco = BoxDecoration(
    color: Color(0x1AFFFFFF),
    shape: BoxShape.circle,
  );

  static const _barDeco = BoxDecoration(
    color: Color(0x1AFFFFFF),
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _cardDeco,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: DecoratedBox(decoration: _circleDeco),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 56,
            height: 10,
            child: DecoratedBox(decoration: _barDeco),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: 32,
            height: 8,
            child: DecoratedBox(decoration: _barDeco),
          ),
        ],
      ),
    );
  }
}
