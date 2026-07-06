import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final _searchQueryNotifier = ValueNotifier<String>('');
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _searchQueryNotifier.dispose();
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
        _searchQueryNotifier.value = '';
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
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    // Cache padding lookup — avoids full MediaQueryData allocation each frame
    final topPad = MediaQuery.paddingOf(context).top;
    final channelsAsync = ref.watch(
      channelsByCategoryProvider(selectedCategory),
    );
    final favorites = ref.watch(favoriteChannelIdsProvider);

    final titleStyle = GoogleFonts.orbitron(
      fontSize: 20,
      fontWeight: FontWeight.w300,
      color: theme.colorScheme.primary,
      letterSpacing: 3,
    );

    final appBarGlassDeco = BoxDecoration(
      color: theme.colorScheme.surface.withOpacity(0.8),
    );

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
                        const Duration(milliseconds: 150),
                        () => _searchQueryNotifier.value = val,
                      );
                    },
                    onClose: () {
                      if (_searchController.text.isEmpty) {
                        _toggleSearch();
                      } else {
                        _searchController.clear();
                        _debounceTimer?.cancel();
                        _searchQueryNotifier.value = '';
                      }
                    },
                  )
                : Text('CHANNELS', style: titleStyle),
            actions: _isSearching
                ? null
                : [
                    IconButton(
                      icon: Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.onSurface,
                        size: 22,
                      ),
                      onPressed: _toggleSearch,
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: theme.colorScheme.onSurface,
                        size: 22,
                      ),
                      color: theme.brightness == Brightness.dark
                          ? GoPlayTheme.darkSurfaceContainerHigh
                          : GoPlayTheme.lightSurfaceContainerHigh,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: theme.brightness == Brightness.dark
                              ? GoPlayTheme.darkCardBorder
                              : GoPlayTheme.lightCardBorder,
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
                              Icon(
                                Icons.settings_rounded,
                                color: theme.colorScheme.onSurface,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'App Settings',
                                style: GoogleFonts.inter(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
            // RepaintBoundary isolates the blur surface so it is not
            // re-rasterised whenever the list scrolls beneath it.
            flexibleSpace: RepaintBoundary(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14.0, sigmaY: 14.0),
                  child: DecoratedBox(
                    decoration: appBarGlassDeco,
                    child: const SizedBox.expand(),
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
              return _ResponsiveGrid(
                channels: channels,
                favorites: favorites,
                ref: ref,
                topPad: topPad,
                searchQueryNotifier: _searchQueryNotifier,
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

// ─── Search Field ──────────────────────────────────────────────
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08),
              width: 0.8,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08),
              width: 0.8,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.0,
            ),
          ),
        ),
      ),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          autofocus: true,
          onChanged: onChanged,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'Search channels by name, country...',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              fontSize: 14,
            ),
            isDense: true,
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: 18,
              ),
              onPressed: onClose,
            ),
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
class _ResponsiveGrid extends StatefulWidget {
  final List channels;
  final Set<String> favorites;
  final WidgetRef ref;
  final double topPad;
  final ValueNotifier<String> searchQueryNotifier;

  const _ResponsiveGrid({
    required this.channels,
    required this.favorites,
    required this.ref,
    required this.topPad,
    required this.searchQueryNotifier,
  });

  @override
  State<_ResponsiveGrid> createState() => _ResponsiveGridState();
}

class _ResponsiveGridState extends State<_ResponsiveGrid> {
  @override
  void initState() {
    super.initState();
    widget.searchQueryNotifier.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(_ResponsiveGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQueryNotifier != widget.searchQueryNotifier) {
      oldWidget.searchQueryNotifier.removeListener(_onSearchChanged);
      widget.searchQueryNotifier.addListener(_onSearchChanged);
    }
  }

  @override
  void dispose() {
    widget.searchQueryNotifier.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.searchQueryNotifier.value.trim().toLowerCase();
    final filtered = query.isEmpty
        ? widget.channels
        : widget.channels.where((ch) {
            return ch.name.toLowerCase().contains(query) ||
                (ch.country?.toLowerCase().contains(query) ?? false) ||
                (ch.language?.toLowerCase().contains(query) ?? false);
          }).toList();

    if (filtered.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(
          isSearch: query.isNotEmpty,
          onAction: () {
            if (query.isNotEmpty) {
              widget.searchQueryNotifier.value = '';
            } else {
              widget.ref.read(selectedCategoryProvider.notifier).select('all');
            }
          },
        ),
      );
    }

    final bottomPadding = MediaQuery.paddingOf(context).bottom + 80.0;
    return SliverPadding(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: bottomPadding,
      ),
      sliver: SliverGrid(
        gridDelegate: _ChannelsScreenState._gridDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final channel = filtered[index];
            return ChannelCard(
              key: ValueKey(channel.id),
              channel: channel,
              isFavorite: widget.favorites.contains(channel.id),
              onFavoriteTap: () => widget.ref
                  .read(favoriteChannelIdsProvider.notifier)
                  .toggle(channel.id),
            );
          },
          childCount: filtered.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
        ),
      ),
    );
  }
}

// ─── Category Chip ────────────────────────────────────────────
class _CategoryChip extends StatefulWidget {
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

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    final selectedDeco = BoxDecoration(
      color: primaryColor.withOpacity(0.12),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      border: Border.fromBorderSide(
        BorderSide(color: primaryColor.withOpacity(0.47), width: 0.8),
      ),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.16),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );

    final unselectedDeco = BoxDecoration(
      color: _isHovered
          ? (isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08))
          : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04)),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      border: Border.fromBorderSide(
        BorderSide(
          color: _isHovered
              ? (isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.15))
              : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06)),
          width: 0.8,
        ),
      ),
    );

    final countSelectedDeco = BoxDecoration(
      color: primaryColor.withOpacity(0.24),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );

    final countUnselectedDeco = BoxDecoration(
      color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(right: 8, bottom: 6, top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: widget.isSelected ? selectedDeco : unselectedDeco,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected
                      ? primaryColor
                      : theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: widget.isSelected
                    ? countSelectedDeco
                    : countUnselectedDeco,
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    color: widget.isSelected
                        ? primaryColor
                        : theme.colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
