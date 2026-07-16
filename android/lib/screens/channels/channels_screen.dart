import 'dart:async';
// dart:ui import removed — BackdropFilter/ImageFilter no longer used.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/cards/channel_card.dart';
import '../../models/category.dart';
import '../../models/channel.dart';

class ChannelsScreen extends ConsumerStatefulWidget {
  const ChannelsScreen({super.key});

  @override
  ConsumerState<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends ConsumerState<ChannelsScreen> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  final _searchQueryNotifier = ValueNotifier<String>('');
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  TabController? _tabController;

  @override
  void dispose() {
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    _tabController?.dispose();
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
    final activeCatsAsync = ref.watch(activeCategoriesWithCountsProvider);

    final titleStyle = theme.appBarTheme.titleTextStyle ?? const TextStyle();

    const appBarGlassDeco = BoxDecoration(
      color: GoPlayTheme.surfaceContainer,
    );

    // Sync selectedCategoryProvider changes back to the TabController
    ref.listen<String>(selectedCategoryProvider, (prev, next) {
      final activeCatsVal = ref.read(activeCategoriesWithCountsProvider).value;
      if (activeCatsVal != null && _tabController != null) {
        final categoryIds = ['all', ...activeCatsVal.map((e) => e.$1.id)];
        final index = categoryIds.indexOf(next);
        if (index != -1 && index != _tabController!.index) {
          _tabController!.animateTo(index);
        }
      }
    });

    return activeCatsAsync.when(
      data: (activeCats) {
        final categoryIds = ['all', ...activeCats.map((e) => e.$1.id)];
        final totalCount = activeCats.fold<int>(0, (sum, e) => sum + e.$2);

        // Dynamic TabController initialization
        if (_tabController == null || _tabController!.length != categoryIds.length) {
          _tabController?.dispose();
          _tabController = TabController(
            length: categoryIds.length,
            vsync: this,
          );

          final initialIndex = categoryIds.indexOf(selectedCategory);
          if (initialIndex != -1) {
            _tabController!.index = initialIndex;
          }

          _tabController!.addListener(() {
            if (!_tabController!.indexIsChanging) {
              final newCatId = categoryIds[_tabController!.index];
              ref.read(selectedCategoryProvider.notifier).select(newCatId);
            }
          });
        }

        return Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  floating: false,
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
                      : Text('Channels', style: titleStyle),
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
                                      style: TextStyle(
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
                  flexibleSpace: DecoratedBox(
                    decoration: appBarGlassDeco,
                    child: const SizedBox.expand(),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverHeaderDelegate(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border(
                          bottom: BorderSide(
                            color: theme.brightness == Brightness.dark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.08),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: _CategoryFilterBar(
                        tabController: _tabController!,
                        activeCatsWithCounts: activeCats,
                        totalCount: totalCount,
                        selectedCategory: selectedCategory,
                        onTabReSelected: _scrollToTop,
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: TabBarView(
                    controller: _tabController,
                    children: categoryIds.map((catId) {
                      return _CategoryPageContent(
                        key: ValueKey(catId),
                        categoryId: catId,
                        searchQueryNotifier: _searchQueryNotifier,
                        tabController: _tabController!,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text('Channels', style: titleStyle),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: _gridDelegate(context),
          itemCount: 12,
          itemBuilder: (ctx, i) => const _ShimmerCard(),
        ),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(
          title: Text('Channels', style: titleStyle),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: GoPlayTheme.error,
              ),
              const SizedBox(height: 8),
              Text(
                'Error loading categories: $e',
                style: const TextStyle(color: GoPlayTheme.error),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  // Pre-computed borders — avoids expensive theme.copyWith() on every build.
  static const _borderRadius = BorderRadius.all(Radius.circular(12));
  static const _borderSide = BorderSide(color: Color(0x14FFFFFF), width: 0.8);
  static const _focusBorderSide = BorderSide(color: Color(0x40FFFFFF), width: 1.0);
  static final _border = OutlineInputBorder(borderRadius: _borderRadius, borderSide: _borderSide);
  static final _focusBorder = OutlineInputBorder(borderRadius: _borderRadius, borderSide: _focusBorderSide);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: onChanged,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF222326),
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          hintText: 'Search channels by name, country...',
          hintStyle: const TextStyle(color: Color(0x99FFFFFF), fontSize: 14),
          isDense: true,
          border: _border,
          enabledBorder: _border,
          focusedBorder: _focusBorder,
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70, size: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
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
          const SizedBox(
            width: 80,
            height: 80,
            child: DecoratedBox(
              decoration: _iconDecoration,
              child: Icon(
                Icons.live_tv_outlined,
                size: 32,
                color: GoPlayTheme.onSurfaceVariant,
              ),
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
class _CategoryFilterBar extends StatefulWidget {
  final TabController tabController;
  final List<(Category, int)> activeCatsWithCounts;
  final int totalCount;
  final String selectedCategory;
  final VoidCallback? onTabReSelected;

  const _CategoryFilterBar({
    required this.tabController,
    required this.activeCatsWithCounts,
    required this.totalCount,
    required this.selectedCategory,
    this.onTabReSelected,
  });

  @override
  State<_CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<_CategoryFilterBar> {
  BoxDecoration? _countSelectedDeco;
  BoxDecoration? _countUnselectedDeco;
  TextStyle? _countSelectedTextStyle;
  TextStyle? _countUnselectedTextStyle;
  Color? _primaryColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    _primaryColor = primaryColor;

    _countSelectedDeco = BoxDecoration(
      color: primaryColor,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );

    _countUnselectedDeco = BoxDecoration(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );

    _countSelectedTextStyle = TextStyle(
      color: theme.colorScheme.onPrimary,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    );

    _countUnselectedTextStyle = TextStyle(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
      fontSize: 11,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabs = <Widget>[];

    // 1. "All" tab
    final isAllSelected = widget.selectedCategory == 'all';
    tabs.add(
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('All'),
            const SizedBox(width: 6),
            DecoratedBox(
              decoration: isAllSelected ? _countSelectedDeco! : _countUnselectedDeco!,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                child: Text(
                  '${widget.totalCount}',
                  style: isAllSelected ? _countSelectedTextStyle : _countUnselectedTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // 2. Category tabs
    for (final item in widget.activeCatsWithCounts) {
      final cat = item.$1;
      final count = item.$2;
      final isSelected = widget.selectedCategory == cat.id;

      tabs.add(
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cat.iconUrl != null && cat.iconUrl!.isNotEmpty) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CachedNetworkImage(
                    imageUrl: cat.iconUrl!,
                    width: 16,
                    height: 16,
                    fit: BoxFit.cover,
                    memCacheWidth: 48,
                    memCacheHeight: 48,
                    fadeInDuration: const Duration(milliseconds: 100),
                    imageBuilder: (context, imageProvider) => DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const SizedBox(
                      width: 16,
                      height: 16,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.category_outlined,
                      size: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(cat.name),
              const SizedBox(width: 6),
              DecoratedBox(
                decoration: isSelected ? _countSelectedDeco! : _countUnselectedDeco!,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  child: Text(
                    '$count',
                    style: isSelected ? _countSelectedTextStyle : _countUnselectedTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return TabBar(
      controller: widget.tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      physics: const BouncingScrollPhysics(),
      dividerColor: Colors.transparent,
      onTap: (index) {
        if (index == widget.tabController.index) {
          widget.onTabReSelected?.call();
        }
      },
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: _primaryColor ?? theme.colorScheme.primary, width: 3.0),
        borderRadius: const BorderRadius.all(Radius.circular(1.5)),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: const EdgeInsets.only(bottom: 2),
      labelColor: _primaryColor ?? theme.colorScheme.primary,
      unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(left: 4),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) {
          return theme.colorScheme.onSurface.withValues(alpha: 0.04);
        }
        if (states.contains(WidgetState.focused) || states.contains(WidgetState.pressed)) {
          return theme.colorScheme.primary.withValues(alpha: 0.08);
        }
        return null;
      }),
      tabs: tabs,
    );
  }
}

// ─── Responsive Grid ──────────────────────────────────────────
class _ResponsiveGrid extends StatefulWidget {
  final List<Channel> channels;
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
  // Memoized filtered list — only recomputed when query or channels change.
  List<Channel>? _filtered;
  String _lastQuery = '';
  List<Channel>? _lastChannels;

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
    // Channels list reference changed — invalidate memoized result.
    if (oldWidget.channels != widget.channels) {
      _filtered = null;
      _lastChannels = null;
    }
  }

  @override
  void dispose() {
    widget.searchQueryNotifier.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) setState(() => _filtered = null); // invalidate cache, rebuild
  }

  List<Channel> _computeFiltered() {
    final query = widget.searchQueryNotifier.value.trim().toLowerCase();
    // Use memoized result if inputs haven't changed.
    if (_filtered != null &&
        _lastQuery == query &&
        _lastChannels == widget.channels) {
      return _filtered!;
    }
    _lastQuery = query;
    _lastChannels = widget.channels;
    _filtered = query.isEmpty
        ? widget.channels
        : widget.channels.where((ch) {
            return ch.name.toLowerCase().contains(query) ||
                (ch.country?.toLowerCase().contains(query) ?? false) ||
                (ch.language?.toLowerCase().contains(query) ?? false);
          }).toList();
    return _filtered!;
  }

  SliverGridDelegateWithFixedCrossAxisCount? _cachedGridDelegate;
  double? _lastWidth;

  SliverGridDelegateWithFixedCrossAxisCount _getGridDelegate(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (_cachedGridDelegate != null && _lastWidth == width) {
      return _cachedGridDelegate!;
    }
    _lastWidth = width;
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
    _cachedGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: cols,
      childAspectRatio: 1.0,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    );
    return _cachedGridDelegate!;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _computeFiltered();

    if (filtered.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(
          isSearch: _lastQuery.isNotEmpty,
          onAction: () {
            if (_lastQuery.isNotEmpty) {
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
        gridDelegate: _getGridDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final channel = filtered[index];
            // ExcludeSemantics prevents expensive accessibility tree
            // recalculations during fast scrolling (Semantics.ensureGeometry
            // spiked to 7.5 s in the trace).
            return ExcludeSemantics(
              child: ChannelCard(
                key: ValueKey(channel.id),
                channel: channel,
                isFavorite: widget.favorites.contains(channel.id),
                onFavoriteTap: () => widget.ref
                    .read(favoriteChannelIdsProvider.notifier)
                    .toggle(channel.id),
              ),
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

// ─── Sliver Header Delegate ──────────────────────────────────
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverHeaderDelegate({required this.child});

  @override
  double get minExtent => 48.0;
  @override
  double get maxExtent => 48.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

// ─── Category Page Content (Lazy & Kept-alive Page View Content) ─────────────────
class _CategoryPageContent extends ConsumerStatefulWidget {
  final String categoryId;
  final ValueNotifier<String> searchQueryNotifier;
  final TabController tabController;

  const _CategoryPageContent({
    super.key,
    required this.categoryId,
    required this.searchQueryNotifier,
    required this.tabController,
  });

  @override
  ConsumerState<_CategoryPageContent> createState() => _CategoryPageContentState();
}

class _CategoryPageContentState extends ConsumerState<_CategoryPageContent>
    with AutomaticKeepAliveClientMixin {
  List<Channel>? _lastPrecachedChannels;
  bool _hasBeenVisible = false;

  static final List<String> _recentCategoryIds = [];
  static final Set<_CategoryPageContentState> _activeStates = {};

  @override
  void initState() {
    super.initState();
    _activeStates.add(this);
    widget.tabController.animation?.addListener(_onTabAnimation);
    _checkIfSettled();
  }

  @override
  void didUpdateWidget(_CategoryPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabController != widget.tabController) {
      oldWidget.tabController.animation?.removeListener(_onTabAnimation);
      widget.tabController.animation?.addListener(_onTabAnimation);
    }
  }

  @override
  void dispose() {
    widget.tabController.animation?.removeListener(_onTabAnimation);
    _activeStates.remove(this);
    super.dispose();
  }

  void _onTabAnimation() {
    _checkIfSettled();
  }

  void _checkIfSettled() {
    if (!mounted) return;
    final animValue = widget.tabController.animation?.value;
    if (animValue == null) return;

    final activeCatsVal = ref.read(activeCategoriesWithCountsProvider).value;
    if (activeCatsVal == null) return;
    final categoryIds = ['all', ...activeCatsVal.map((e) => e.$1.id)];
    final myIndex = categoryIds.indexOf(widget.categoryId);
    if (myIndex == -1) return;

    final distance = (animValue - myIndex).abs();
    final isNowSettled = distance < 0.15;

    if (isNowSettled && !_hasBeenVisible) {
      setState(() {
        _hasBeenVisible = true;
      });
    }
  }

  void _markAsVisited() {
    final catId = widget.categoryId;
    if (_recentCategoryIds.isEmpty || _recentCategoryIds.last != catId) {
      if (_recentCategoryIds.contains(catId)) {
        _recentCategoryIds.remove(catId);
      }
      _recentCategoryIds.add(catId);
      if (_recentCategoryIds.length > 3) {
        _recentCategoryIds.removeAt(0);
      }
      // Schedule keep-alive updates after the current frame to prevent layout/draw phase collisions.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final state in _activeStates) {
          if (state.mounted) {
            state.updateKeepAlive();
          }
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => _recentCategoryIds.contains(widget.categoryId);

  /// Staggered precaching — fires 5 logos per frame across multiple frames
  /// so no single POST_FRAME callback blocks the pipeline.
  void _staggeredPrecache(BuildContext context, List<Channel> channels) {
    const batchSize = 5;
    final total = channels.length < 30 ? channels.length : 30;
    var offset = 0;

    void batch() {
      if (!mounted) return;
      final end = (offset + batchSize).clamp(0, total);
      for (var i = offset; i < end; i++) {
        final logo = channels[i].logo;
        if (logo != null && logo.isNotEmpty) {
          precacheImage(
            CachedNetworkImageProvider(logo, maxWidth: 108, maxHeight: 108),
            context,
          );
        }
      }
      offset = end;
      if (offset < total) {
        WidgetsBinding.instance.addPostFrameCallback((_) => batch());
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => batch());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin
    _markAsVisited();

    if (!_hasBeenVisible) {
      // Lightweight skeleton placeholder during active tab transition
      return SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: _ChannelsScreenState._gridDelegate(context),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => const _ShimmerCard(),
                  childCount: 6,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final channelsAsync = ref.watch(channelsByCategoryProvider(widget.categoryId));
    final favorites = ref.watch(favoriteChannelIdsProvider);
    final topPad = MediaQuery.paddingOf(context).top;

    return channelsAsync.when(
      data: (channels) {
        if (_lastPrecachedChannels != channels) {
          _lastPrecachedChannels = channels;
          _staggeredPrecache(context, channels);
        }

        return SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(
            key: PageStorageKey<String>(widget.categoryId),
            cacheExtent: 400, // Increased from 200 to 400 for smoother scrolling flings
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _ResponsiveGrid(
                channels: channels,
                favorites: favorites,
                ref: ref,
                topPad: topPad,
                searchQueryNotifier: widget.searchQueryNotifier,
              ),
            ],
          ),
        );
      },
      loading: () => SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: _ChannelsScreenState._gridDelegate(context),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => const _ShimmerCard(),
                  childCount: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      error: (e, s) => SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
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
                        channelsByCategoryProvider(widget.categoryId),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Retry'),
                    ),
                  ],
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
