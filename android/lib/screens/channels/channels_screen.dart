import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
// `show` is required: flutter/foundation also exports a `Category` annotation
// class, which would clash with our Category model.
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../providers/app_providers.dart';
import '../../widgets/cards/channel_card.dart';
import '../../models/category.dart';
import '../../models/channel.dart';
import '../../widgets/app_overflow_menu.dart';

const double _kTabStripHeight = 48.0;
const double _kToolbarHeight = 56.0;
const double _kGridSpacing = 8.0;
const double _kGridEdgeInset = 10.0;

/// How many recently visited category pages stay alive in the TabBarView.
const int _kKeepAliveCount = 3;

/// Shares which page is active, and which pages stay resident, without pushing
/// the screen through a rebuild.
///
/// A tab change used to `setState` on `_ChannelsScreenState`, which re-ran the
/// AppBar and rebuilt every `Tab` — including one `CachedNetworkImage` per
/// category icon — on the exact frame the swipe animation settled. Pages now
/// listen here and react with `updateKeepAlive()` only, so settling a tab costs
/// zero widget rebuilds.
class _PageCoordinator extends ChangeNotifier {
  int _activeIndex = 0;
  List<String> _residentIds = const <String>[];

  int get activeIndex => _activeIndex;

  bool isResident(String categoryId) => _residentIds.contains(categoryId);

  void update({required int activeIndex, required List<String> residentIds}) {
    if (_activeIndex == activeIndex && listEquals(_residentIds, residentIds)) {
      return;
    }
    _activeIndex = activeIndex;
    _residentIds = List<String>.unmodifiable(residentIds);
    notifyListeners();
  }
}

class ChannelsScreen extends ConsumerStatefulWidget {
  const ChannelsScreen({super.key});

  @override
  ConsumerState<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends ConsumerState<ChannelsScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _searchQueryNotifier = ValueNotifier<String>('');
  Timer? _debounceTimer;
  bool _isSearching = false;

  TabController? _tabController;

  /// Source of truth for tab index -> category id. Held as a field (not
  /// captured in a listener closure) so a rebuilt category list can never map a
  /// tab index onto a stale category.
  List<String> _categoryIds = const <String>['trending', 'favorite', 'all'];

  /// Active index and residency, shared with the pages without rebuilding this
  /// widget. `activeIndex` also distinguishes a re-tap from a new tap, because
  /// `TabBar` calls `onTap` *after* `animateTo` has already moved
  /// `controller.index`.
  final _coordinator = _PageCoordinator();

  final List<String> _recentlyVisited = <String>['trending'];
  final Map<String, ScrollController> _scrollControllers =
      <String, ScrollController>{};

  Timer? _prefetchTimer;
  int _prefetchGeneration = 0;

  bool _initialised = false;

  @override
  void initState() {
    super.initState();

    // Controller lifecycle is driven by provider updates, not by build().
    ref.listenManual<AsyncValue<List<(Category, int)>>>(
      activeCategoriesWithCountsProvider,
      (previous, next) => _applyCategories(next.value),
      fireImmediately: true,
    );

    ref.listenManual<String>(
      selectedCategoryProvider,
      (previous, next) => _syncControllerToSelection(next),
    );

    _initialised = true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    _debounceTimer?.cancel();
    _prefetchTimer?.cancel();
    _prefetchGeneration++;
    _tabController?.removeListener(_onTabControllerChanged);
    _tabController?.dispose();
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    _scrollControllers.clear();
    _coordinator.dispose();
    super.dispose();
  }

  // ─── Tab controller lifecycle ───────────────────────────────

  void _applyCategories(List<(Category, int)>? categories) {
    final ids = <String>[
      'trending',
      'favorite',
      'all',
      ...?categories?.map((e) => e.$1.id),
    ];

    // Keyed on the id list, not its length: two categories swapping in/out in
    // the same sync kept the old controller *and* the old id mapping alive.
    if (_tabController != null && listEquals(ids, _categoryIds)) return;

    final selected = ref.read(selectedCategoryProvider);
    var initialIndex = ids.indexOf(selected);
    if (initialIndex < 0) initialIndex = 0;

    final previous = _tabController;
    previous?.removeListener(_onTabControllerChanged);

    final next = TabController(
      length: ids.length,
      initialIndex: initialIndex,
      vsync: this,
    );
    next.addListener(_onTabControllerChanged);

    _categoryIds = ids;
    _tabController = next;
    _touchRecent(ids[initialIndex]);
    _pruneScrollControllers(ids);
    _publishCoordinator(initialIndex);

    // Dispose only after the frame that swaps the new controller into TabBar
    // and TabBarView, otherwise an in-flight animation touches a dead
    // controller.
    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
    }

    // Rebuilding here is unavoidable: the tab *count* changed, so TabBar and
    // TabBarView need new children.
    if (_initialised && mounted) setState(() {});
    _schedulePrefetch();

    // The previously selected category no longer exists — reconcile the
    // provider, deferred so we never write to it from inside a provider update.
    if (ids[initialIndex] != selected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(selectedCategoryProvider.notifier).select(ids[initialIndex]);
      });
    }
  }

  void _onTabControllerChanged() {
    final controller = _tabController;
    if (controller == null || controller.indexIsChanging) return;

    final index = controller.index;
    if (index < 0 || index >= _categoryIds.length) return;

    final id = _categoryIds[index];
    _touchRecent(id);
    // No setState: pages observe the coordinator and respond with
    // `updateKeepAlive()`, so settling a tab does not rebuild the AppBar or the
    // tab strip.
    _publishCoordinator(index);
    _schedulePrefetch();

    if (ref.read(selectedCategoryProvider) != id) {
      ref.read(selectedCategoryProvider.notifier).select(id);
    }
  }

  void _publishCoordinator(int activeIndex) {
    _coordinator.update(
      activeIndex: activeIndex,
      residentIds: _recentlyVisited,
    );
  }

  void _syncControllerToSelection(String categoryId) {
    final controller = _tabController;
    if (controller == null) return;
    final index = _categoryIds.indexOf(categoryId);
    if (index == -1 || index == controller.index) return;
    controller.animateTo(index);
  }

  /// Moves [id] to the front of the residency LRU.
  void _touchRecent(String id) {
    if (_recentlyVisited.isNotEmpty && _recentlyVisited.last == id) return;
    _recentlyVisited.remove(id);
    _recentlyVisited.add(id);
    while (_recentlyVisited.length > _kKeepAliveCount) {
      _recentlyVisited.removeAt(0);
    }
  }

  // ─── Neighbour prefetch ─────────────────────────────────────

  /// Warms the first screen of logos for the categories either side of the
  /// active one, a short beat after the swipe settles.
  ///
  /// Without this, an incoming page hits cold image decodes for every visible
  /// card during the transition, which is what made swiping feel heavy. The
  /// per-page precache only ever warmed logos the user was already looking at.
  void _schedulePrefetch() {
    _prefetchTimer?.cancel();
    _prefetchTimer = Timer(
      const Duration(milliseconds: 280),
      _prefetchNeighbours,
    );
  }

  void _prefetchNeighbours() {
    if (!mounted) return;

    final index = _coordinator.activeIndex;
    final grouped = ref.read(channelsByCategoryMapProvider).value;
    final allChannels = ref.read(channelsProvider).value;
    if (grouped == null && allChannels == null) return;

    final urls = <String>[];
    for (final offset in const [1, -1]) {
      final neighbour = index + offset;
      if (neighbour < 0 || neighbour >= _categoryIds.length) continue;
      final id = _categoryIds[neighbour];
      final List<Channel>? channels;
      if (id == 'all') {
        channels = allChannels;
      } else if (id == 'trending') {
        channels = allChannels?.where((c) => c.isTrending).toList();
      } else if (id == 'favorite') {
        final favIds = ref.read(favoriteChannelIdsProvider);
        channels = allChannels?.where((c) => favIds.contains(c.id)).toList();
      } else {
        channels = grouped?[id];
      }
      if (channels == null) continue;
      // One screen's worth on the widest phone layout.
      for (final channel in channels.take(12)) {
        final logo = channel.logo;
        if (logo != null && logo.isNotEmpty) urls.add(logo);
      }
    }
    if (urls.isEmpty) return;

    final generation = ++_prefetchGeneration;
    var offset = 0;

    void runBatch() {
      if (!mounted || generation != _prefetchGeneration) return;
      final end = math.min(offset + 4, urls.length);
      for (var i = offset; i < end; i++) {
        precacheImage(
          CachedNetworkImageProvider(urls[i], maxWidth: 108, maxHeight: 108),
          context,
          // Dead logo URLs are endemic in scraped playlists (403/404, invalid
          // image data). Without this, every failure is rethrown into
          // FlutterError even though the card already falls back to initials.
          onError: (error, stack) {},
        );
      }
      offset = end;
      if (offset < urls.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => runBatch());
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => runBatch());
  }

  // ─── Scroll controllers ─────────────────────────────────────

  ScrollController _scrollControllerFor(String id) =>
      _scrollControllers.putIfAbsent(id, ScrollController.new);

  void _pruneScrollControllers(List<String> ids) {
    final keep = ids.toSet();
    final stale =
        _scrollControllers.keys.where((k) => !keep.contains(k)).toList();
    for (final key in stale) {
      _scrollControllers.remove(key)?.dispose();
    }
  }

  /// Scrolls the *visible* category page to the top.
  ///
  /// The previous implementation animated the screen-level `CustomScrollView`,
  /// whose content exactly filled the viewport, so `maxScrollExtent` was always
  /// zero and this silently did nothing.
  void _scrollToTop() {
    final activeIndex = _coordinator.activeIndex;
    if (activeIndex < 0 || activeIndex >= _categoryIds.length) return;
    final controller = _scrollControllers[_categoryIds[activeIndex]];
    if (controller == null || !controller.hasClients) return;
    if (controller.offset <= 0) return;
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // ─── Search ─────────────────────────────────────────────────

  void _openSearch() => setState(() => _isSearching = true);

  void _closeSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();
    _searchQueryNotifier.value = '';
    setState(() => _isSearching = false);
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 150),
      () => _searchQueryNotifier.value = value,
    );
  }

  void _onSearchClearPressed() {
    if (_searchController.text.isEmpty) {
      _closeSearch();
      return;
    }
    _debounceTimer?.cancel();
    _searchController.clear();
    _searchQueryNotifier.value = '';
  }

  // ─── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final activeCatsAsync = ref.watch(activeCategoriesWithCountsProvider);
    final controller = _tabController;
    final categories = activeCatsAsync.value;

    return PopScope(
      // Back closes the search field first instead of leaving the screen with
      // search still open.
      canPop: !_isSearching,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _isSearching) _closeSearch();
      },
      child: Material(
        color: cs.surface,
        child: Column(
          children: [
            // AppBar handles the status-bar inset itself, so no SafeArea is
            // needed above it.
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: cs.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              titleSpacing: 16,
              toolbarHeight: _kToolbarHeight,
              title: _isSearching
                  ? _SearchField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onClear: _onSearchClearPressed,
                    )
                  : Text('Channels', style: theme.appBarTheme.titleTextStyle),
              actions: _isSearching
                  ? null
                  : [
                      IconButton(
                        tooltip: 'Search channels',
                        icon: Icon(Icons.search_rounded,
                            color: cs.onSurface, size: 22),
                        onPressed: _openSearch,
                      ),
                      const AppOverflowMenu(),
                      const SizedBox(width: 8),
                    ],
            ),

            // The tab strip occupies the same 48dp in every state, so the grid
            // no longer jumps down when categories finish loading.
            SizedBox(
              height: _kTabStripHeight,
              child: (controller == null || categories == null)
                  ? const _TabStripSkeleton()
                  : _CategoryFilterBar(
                      tabController: controller,
                      activeCatsWithCounts: categories,
                      trendingCount:
                          (ref.watch(channelsProvider).value ?? const [])
                              .where((c) => c.isTrending)
                              .length,
                      favoriteCount:
                          (ref.watch(channelsProvider).value ?? const [])
                              .where((c) => ref
                                  .watch(favoriteChannelIdsProvider)
                                  .contains(c.id))
                              .length,
                      totalCount:
                          (ref.watch(channelsProvider).value ?? const []).length,
                      onTabTapped: (index) {
                        if (index == _coordinator.activeIndex) _scrollToTop();
                      },
                    ),
            ),

            Expanded(child: _buildBody(activeCatsAsync, controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    AsyncValue<List<(Category, int)>> async,
    TabController? controller,
  ) {
    if (async.hasError && !async.hasValue) {
      return _ErrorState(
        title: 'Could not load categories',
        error: async.error,
        onRetry: () {
          ref.invalidate(categoriesProvider);
          ref.invalidate(channelsProvider);
        },
      );
    }

    if (async.value == null || controller == null) {
      return const _SkeletonGrid(itemCount: 12);
    }

    return TabBarView(
      controller: controller,
      children: [
        for (var i = 0; i < _categoryIds.length; i++)
          _CategoryPageContent(
            key: ValueKey(_categoryIds[i]),
            categoryId: _categoryIds[i],
            pageIndex: i,
            coordinator: _coordinator,
            scrollController: _scrollControllerFor(_categoryIds[i]),
            searchQueryNotifier: _searchQueryNotifier,
          ),
      ],
    );
  }
}

// ─── Search Field ──────────────────────────────────────────────
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const radius = BorderRadius.all(Radius.circular(100));

    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        cursorColor: cs.primary,
        style: GoPlayType.body.copyWith(color: cs.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: cs.surfaceContainerHigh,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          hintText: 'Search by name, country, language…',
          hintStyle: GoPlayType.body.copyWith(color: cs.onSurfaceVariant),
          isDense: true,
          border: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
          prefixIcon:
              Icon(Icons.search_rounded, color: cs.onSurfaceVariant, size: 20),
          suffixIcon: IconButton(
            tooltip: 'Clear search',
            icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant, size: 18),
            onPressed: onClear,
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isSearch;
  final String categoryId;
  final VoidCallback onAction;

  const _EmptyState({
    required this.isSearch,
    this.categoryId = 'all',
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isFavorite = categoryId == 'favorite';
    final isTrending = categoryId == 'trending';

    final String title;
    final String subtitle;
    final String actionText;

    if (isSearch) {
      title = 'No channels match your search';
      subtitle = 'Try checking for spelling errors or searching another keyword.';
      actionText = 'Clear search';
    } else if (isFavorite) {
      title = 'No bookmarks available';
      subtitle = 'Long press any channel card to add it to your favorites.';
      actionText = 'Explore channels';
    } else if (isTrending) {
      title = 'No trending channels right now';
      subtitle = 'Check back soon as live streaming activity updates.';
      actionText = 'View all channels';
    } else {
      title = 'No channels in this category';
      subtitle = 'Browse other categories or check back later.';
      actionText = 'View all channels';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isFavorite && !isSearch)
              const _BookmarkIllustration()
            else
              SizedBox(
                width: 80,
                height: 80,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSearch ? Icons.search_off_rounded : Icons.live_tv_outlined,
                    size: 36,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoPlayType.subtitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoPlayType.body.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: GoPlayType.sm,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: GoPlayTheme.surfaceContainerHigh,
                foregroundColor: GoPlayTheme.onSurface,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onPressed: onAction,
              child: Text(actionText, style: GoPlayType.label),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkIllustration extends StatelessWidget {
  const _BookmarkIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 14,
            top: 6,
            child: Container(
              width: 52,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F3E9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < 4; i++) ...[
                    Container(
                      height: 3.5,
                      width: i == 0 ? 24 : (i == 2 ? 30 : 20),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF8E8E93),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error State ──────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final String title;
  final Object? error;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.title,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: cs.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoPlayType.subtitle.copyWith(color: cs.onSurface),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: GoPlayType.body.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              // Diagnostics stay available without being the headline.
              ExpansionTile(
                title: Text(
                  'Technical details',
                  style: GoPlayType.labelSmall.copyWith(color: cs.onSurfaceVariant),
                ),
                tilePadding: EdgeInsets.zero,
                shape: const Border(),
                collapsedShape: const Border(),
                children: [
                  Text(
                    '$error',
                    style: GoPlayType.inter(
                      color: cs.onSurfaceVariant,
                      fontSize: GoPlayType.xs,
                      height: GoPlayType.leadingBody,
                    ),
                    // Raw exception text; keep the sheet from growing forever.
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Category Filter Bar ──────────────────────────────────────
class _CategoryFilterBar extends StatelessWidget {
  final TabController tabController;
  final List<(Category, int)> activeCatsWithCounts;
  final int trendingCount;
  final int favoriteCount;
  final int totalCount;
  final ValueChanged<int> onTabTapped;

  const _CategoryFilterBar({
    required this.tabController,
    required this.activeCatsWithCounts,
    required this.trendingCount,
    required this.favoriteCount,
    required this.totalCount,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final tabs = <Widget>[
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Trending'),
            const SizedBox(width: 6),
            _CountBadge(
              animation: tabController.animation,
              index: 0,
              count: trendingCount,
            ),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Favorite'),
            const SizedBox(width: 6),
            _CountBadge(
              animation: tabController.animation,
              index: 1,
              count: favoriteCount,
            ),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('All'),
            const SizedBox(width: 6),
            _CountBadge(
              animation: tabController.animation,
              index: 2,
              count: totalCount,
            ),
          ],
        ),
      ),
      for (var i = 0; i < activeCatsWithCounts.length; i++)
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (activeCatsWithCounts[i].$1.iconUrl?.isNotEmpty ?? false) ...[
                _CategoryIcon(url: activeCatsWithCounts[i].$1.iconUrl!),
                const SizedBox(width: 6),
              ],
              Text(activeCatsWithCounts[i].$1.name),
              const SizedBox(width: 6),
              _CountBadge(
                animation: tabController.animation,
                index: i + 3,
                count: activeCatsWithCounts[i].$2,
              ),
            ],
          ),
        ),
    ];

    return TabBar(
      controller: tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      physics: const BouncingScrollPhysics(),
      dividerColor: Colors.transparent,
      onTap: onTabTapped,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: cs.primary, width: 3.0),
        borderRadius: const BorderRadius.all(Radius.circular(1.5)),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: const EdgeInsets.only(bottom: 2),
      labelColor: cs.primary,
      unselectedLabelColor: cs.onSurface.withValues(alpha: 0.6),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(left: 4),
      labelStyle: GoPlayType.label,
      unselectedLabelStyle: GoPlayType.label.copyWith(
        fontWeight: FontWeight.w500,
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) {
          return cs.onSurface.withValues(alpha: 0.04);
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          return cs.primary.withValues(alpha: 0.08);
        }
        return null;
      }),
      tabs: tabs,
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String url;
  const _CategoryIcon({required this.url});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CachedNetworkImage(
        imageUrl: url,
        width: 16,
        height: 16,
        fit: BoxFit.cover,
        memCacheWidth: 48,
        memCacheHeight: 48,
        fadeInDuration: const Duration(milliseconds: 100),
        imageBuilder: (context, imageProvider) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.category_outlined,
          size: 12,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Count pill that tracks the tab *animation* rather than the settled
/// selection, so its highlight crosses over at the same point as the underline
/// indicator during a swipe. It rebuilds only when its selected flag flips, not
/// on every animation tick.
class _CountBadge extends StatefulWidget {
  final Animation<double>? animation;
  final int index;
  final int count;

  const _CountBadge({
    required this.animation,
    required this.index,
    required this.count,
  });

  @override
  State<_CountBadge> createState() => _CountBadgeState();
}

class _CountBadgeState extends State<_CountBadge> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = _resolveSelected();
    widget.animation?.addListener(_onTick);
  }

  @override
  void didUpdateWidget(_CountBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation) {
      oldWidget.animation?.removeListener(_onTick);
      widget.animation?.addListener(_onTick);
    }
    final next = _resolveSelected();
    if (next != _selected) _selected = next;
  }

  @override
  void dispose() {
    widget.animation?.removeListener(_onTick);
    super.dispose();
  }

  bool _resolveSelected() {
    final value = widget.animation?.value;
    if (value == null) return widget.index == 0;
    return (value - widget.index).abs() < 0.5;
  }

  void _onTick() {
    final next = _resolveSelected();
    if (next == _selected || !mounted) return;
    setState(() => _selected = next);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _selected ? cs.primary : cs.onSurface.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
        child: Text(
          '${widget.count}',
          style: GoPlayType.inter(
            color: _selected ? cs.onPrimary : cs.onSurfaceVariant,
            fontSize: GoPlayType.xs,
            fontWeight: FontWeight.w700,
            height: GoPlayType.leadingFlat,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}

// ─── Responsive Grid ──────────────────────────────────────────
class _ResponsiveGrid extends StatefulWidget {
  final List<Channel> channels;
  final String categoryId;
  final int pageIndex;
  final _PageCoordinator coordinator;
  final ValueNotifier<String> searchQueryNotifier;
  final VoidCallback onClearSearch;
  final VoidCallback onViewAll;

  const _ResponsiveGrid({
    required this.channels,
    required this.categoryId,
    required this.pageIndex,
    required this.coordinator,
    required this.searchQueryNotifier,
    required this.onClearSearch,
    required this.onViewAll,
  });

  @override
  State<_ResponsiveGrid> createState() => _ResponsiveGridState();
}

class _ResponsiveGridState extends State<_ResponsiveGrid> {
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
  }

  @override
  void dispose() {
    widget.searchQueryNotifier.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    // Only the visible tab re-filters on a keystroke. Off-screen kept-alive
    // pages recompute lazily when they are next built, because
    // `_computeFiltered` compares against the query it last ran with.
    //
    // Read from the coordinator rather than a widget prop so a tab change never
    // has to rebuild this grid just to update an `isActive` flag.
    if (!mounted) return;
    if (widget.coordinator.activeIndex != widget.pageIndex) return;
    setState(() => _filtered = null);
  }

  List<Channel> _computeFiltered() {
    final query = widget.searchQueryNotifier.value.trim().toLowerCase();
    if (_filtered != null &&
        _lastQuery == query &&
        identical(_lastChannels, widget.channels)) {
      return _filtered!;
    }
    _lastQuery = query;
    _lastChannels = widget.channels;
    // One `contains` against a cached, pre-lowercased index per channel instead
    // of three fresh `toLowerCase()` allocations.
    _filtered = query.isEmpty
        ? widget.channels
        : widget.channels
            .where((ch) => ch.searchIndex.contains(query))
            .toList();
    return _filtered!;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _computeFiltered();

    if (filtered.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(
          isSearch: _lastQuery.isNotEmpty,
          categoryId: widget.categoryId,
          onAction:
              _lastQuery.isNotEmpty ? widget.onClearSearch : widget.onViewAll,
        ),
      );
    }

    // The Scaffold already insets the body above the bottom nav bar, so the old
    // `+ 80` was pure dead space under the last row.
    final bottomInset = MediaQuery.paddingOf(context).bottom + 12.0;

    return SliverPadding(
      padding: EdgeInsets.only(
        left: _kGridEdgeInset,
        right: _kGridEdgeInset,
        top: _kGridEdgeInset,
        bottom: bottomInset,
      ),
      // Sliver-level layout: column count follows the real available width and
      // is immune to keyboard-driven MediaQuery.size changes.
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final gridDelegate =
              _buildGridDelegate(context, constraints.crossAxisExtent);
          return SliverGrid(
            gridDelegate: gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, index) => ChannelCard(
                key: ValueKey(filtered[index].id),
                channel: filtered[index],
                scope: filtered,
              ),
              childCount: filtered.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              // Semantic index bookkeeping is the expensive part of a large
              // grid; dropping it keeps cards readable by screen readers while
              // avoiding the churn that motivated the old ExcludeSemantics.
              addSemanticIndexes: false,
            ),
          );
        },
      ),
    );
  }
}

/// Grid metrics shared by the real grid and the loading skeleton so the two
/// never disagree on tile size.
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

  final tileWidth =
      (crossAxisExtent - _kGridSpacing * (cols - 1)) / cols;
  // Grow the tile when the card cannot fit at the current text scale. A fixed
  // 1.0 ratio overflowed on 320dp widths and above ~1.15 text scale.
  final tileHeight = math.max(tileWidth, ChannelCard.measureHeight(context));

  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: cols,
    childAspectRatio: tileWidth <= 0 ? 1.0 : tileWidth / tileHeight,
    crossAxisSpacing: _kGridSpacing,
    mainAxisSpacing: _kGridSpacing,
  );
}

// ─── Category Page Content ────────────────────────────────────
class _CategoryPageContent extends ConsumerStatefulWidget {
  final String categoryId;
  final int pageIndex;
  final _PageCoordinator coordinator;
  final ScrollController scrollController;
  final ValueNotifier<String> searchQueryNotifier;

  const _CategoryPageContent({
    super.key,
    required this.categoryId,
    required this.pageIndex,
    required this.coordinator,
    required this.scrollController,
    required this.searchQueryNotifier,
  });

  @override
  ConsumerState<_CategoryPageContent> createState() =>
      _CategoryPageContentState();
}

class _CategoryPageContentState extends ConsumerState<_CategoryPageContent>
    with AutomaticKeepAliveClientMixin {
  String? _precachedSignature;
  int _precacheGeneration = 0;

  /// Not `late`: [AutomaticKeepAliveClientMixin.initState] reads
  /// [wantKeepAlive] from inside `super.initState()`, so this must already hold
  /// a value by then.
  bool _resident = false;

  @override
  bool get wantKeepAlive => _resident;

  @override
  void initState() {
    // Assigned before super.initState(): AutomaticKeepAliveClientMixin reads
    // wantKeepAlive from inside its own initState, so the value must already be
    // correct by then.
    _resident = widget.coordinator.isResident(widget.categoryId);
    super.initState();
    widget.coordinator.addListener(_onCoordinatorChanged);
  }

  @override
  void didUpdateWidget(_CategoryPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coordinator != widget.coordinator) {
      oldWidget.coordinator.removeListener(_onCoordinatorChanged);
      widget.coordinator.addListener(_onCoordinatorChanged);
      _onCoordinatorChanged();
    }
  }

  @override
  void dispose() {
    _precacheGeneration++; // cancels any in-flight precache chain
    widget.coordinator.removeListener(_onCoordinatorChanged);
    super.dispose();
  }

  /// Residency changes are applied without a rebuild — `updateKeepAlive` only
  /// notifies the enclosing sliver.
  void _onCoordinatorChanged() {
    final resident = widget.coordinator.isResident(widget.categoryId);
    if (resident == _resident) return;
    _resident = resident;
    updateKeepAlive();
  }

  /// Warms the rows just below the fold. Keyed on a cheap signature and
  /// cancellable, so a re-sync or a swipe away stops the chain.
  void _staggeredPrecache(List<Channel> channels) {
    final signature =
        '${channels.length}:${channels.isEmpty ? '' : channels.first.id}';
    if (_precachedSignature == signature) return;
    _precachedSignature = signature;

    final generation = ++_precacheGeneration;
    const batchSize = 5;
    final total = math.min(channels.length, 24);
    var offset = 0;

    void runBatch() {
      if (!mounted || generation != _precacheGeneration) return;
      final end = math.min(offset + batchSize, total);
      for (var i = offset; i < end; i++) {
        final logo = channels[i].logo;
        if (logo == null || logo.isEmpty) continue;
        precacheImage(
          CachedNetworkImageProvider(logo, maxWidth: 108, maxHeight: 108),
          context,
          // Swallowed deliberately — see _prefetchNeighbours.
          onError: (error, stack) {},
        );
      }
      offset = end;
      if (offset < total) {
        WidgetsBinding.instance.addPostFrameCallback((_) => runBatch());
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => runBatch());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin

    // No visibility gate. TabBarView builds this page the moment it enters the
    // viewport (first pixel of a drag, or on tap), so building the real grid
    // here is a single build during the gesture. The previous gate showed a
    // shimmer for ~85% of the swipe and then built the whole grid on the frame
    // the animation settled — double work, landing at the worst moment.
    final channelsAsync =
        ref.watch(channelsByCategoryProvider(widget.categoryId));

    return channelsAsync.when(
      data: (channels) {
        _staggeredPrecache(channels);
        return CustomScrollView(
          key: PageStorageKey<String>(widget.categoryId),
          controller: widget.scrollController,
          cacheExtent: 400,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _ResponsiveGrid(
              channels: channels,
              categoryId: widget.categoryId,
              pageIndex: widget.pageIndex,
              coordinator: widget.coordinator,
              searchQueryNotifier: widget.searchQueryNotifier,
              onClearSearch: () => widget.searchQueryNotifier.value = '',
              onViewAll: () =>
                  ref.read(selectedCategoryProvider.notifier).select('all'),
            ),
          ],
        );
      },
      loading: () => const _SkeletonGrid(itemCount: 12, scrollable: false),
      error: (e, s) => _ErrorState(
        title: 'Could not load channels',
        error: e,
        onRetry: () =>
            ref.invalidate(channelsByCategoryProvider(widget.categoryId)),
      ),
    );
  }
}

// ─── Loading Skeletons ────────────────────────────────────────
class _SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final bool scrollable;

  const _SkeletonGrid({required this.itemCount, this.scrollable = true});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(_kGridEdgeInset),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) => SliverGrid(
              gridDelegate:
                  _buildGridDelegate(context, constraints.crossAxisExtent),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => const _ShimmerCard(),
                childCount: itemCount,
                addAutomaticKeepAlives: false,
                addSemanticIndexes: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TabStripSkeleton extends StatelessWidget {
  const _TabStripSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(width: 20),
      itemBuilder: (context, index) => SizedBox(
        width: index.isEven ? 62 : 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.06),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Derived from the color scheme so the skeleton stays visible in a light
    // theme; the old hardcoded 5%-white fill was invisible on a light surface.
    final base = cs.onSurface.withValues(alpha: 0.06);
    final highlight = cs.onSurface.withValues(alpha: 0.10);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: base,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.fromBorderSide(BorderSide(color: cs.outline, width: 0.8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: highlight, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 56,
            height: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: highlight,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 32,
            height: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: highlight,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
