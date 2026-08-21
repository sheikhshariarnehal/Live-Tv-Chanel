import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../services/cache_service.dart';
import '../services/sync_service.dart';
import '../services/analytics_service.dart';
import '../models/channel.dart';
import '../models/event.dart';
import '../models/category.dart';
import '../models/announcement.dart';

// ─── Core Service Providers ───────────────────────────────────
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(Supabase.instance.client);
});

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref);
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final service = AnalyticsService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

/// Startup provider to trigger the background synchronization process
final appSyncProvider = FutureProvider<void>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  await syncService.sync();
});

// ─── Channels ─────────────────────────────────────────────────
final channelsProvider = FutureProvider<List<Channel>>((ref) async {
  final cache = ref.watch(cacheServiceProvider);
  final localChannels = cache.getLocalChannels();
  
  final List<Channel> channelsList;
  if (localChannels.isEmpty) {
    // If the local cache is empty (first install), wait for the background sync to populate it
    await ref.watch(appSyncProvider.future);
    channelsList = cache.getLocalChannels();
  } else {
    channelsList = localChannels;
  }

  // Filter channels to only show those that belong to active categories (or have no category)
  final localCategories = cache.getLocalCategories();
  final activeCategoryIds = localCategories.map((c) => c.id).toSet();

  return channelsList.where((ch) {
    final cat = ch.category;
    return cat == null || cat.isEmpty || activeCategoryIds.contains(cat);
  }).toList();
});

final trendingChannelsProvider = FutureProvider<List<Channel>>((ref) async {
  final channels = await ref.watch(channelsProvider.future);
  return channels.where((ch) => ch.isTrending).toList();
});

/// Single O(n) grouping pass over the channel list.
///
/// Previously `channelsByCategoryProvider` was a non-disposing `Provider.family`
/// that ran a full `.where()` scan per category, so one channel-list change cost
/// O(categories x channels) and every filtered list stayed alive for the app
/// lifetime. `activeCategoriesWithCountsProvider` then walked the list a third
/// time just to build counts. Both now read this one map.
final channelsByCategoryMapProvider =
    Provider<AsyncValue<Map<String, List<Channel>>>>((ref) {
  return ref.watch(channelsProvider).whenData((channels) {
    final grouped = <String, List<Channel>>{};
    for (final ch in channels) {
      final key = (ch.category == null || ch.category!.isEmpty)
          ? _uncategorizedKey
          : ch.category!;
      (grouped[key] ??= <Channel>[]).add(ch);
    }
    return grouped;
  });
});

const String _uncategorizedKey = 'uncategorized';

/// Channels for one tab.
/// Supports 'trending', 'favorite', 'all', and specific category IDs.
final channelsByCategoryProvider = Provider.autoDispose
    .family<AsyncValue<List<Channel>>, String>((ref, categoryId) {
  if (categoryId == 'trending') {
    return ref.watch(channelsProvider).whenData(
          (channels) => channels.where((c) => c.isTrending).toList(),
        );
  }
  if (categoryId == 'favorite') {
    return ref.watch(favoriteChannelsProvider);
  }
  if (categoryId == 'all') return ref.watch(channelsProvider);
  return ref
      .watch(channelsByCategoryMapProvider)
      .whenData((grouped) => grouped[categoryId] ?? const <Channel>[]);
});

final channelProvider =
    FutureProvider.family<Channel?, String>((ref, id) async {
  final channels = await ref.watch(channelsProvider.future);
  try {
    return channels.firstWhere((ch) => ch.id == id);
  } catch (_) {
    return null;
  }
});

// ─── Events ───────────────────────────────────────────────────
final eventsProvider = FutureProvider<List<SportEvent>>((ref) async {
  final cache = ref.watch(cacheServiceProvider);
  final localEvents = cache.getLocalEvents();

  if (localEvents.isEmpty) {
    // If the local cache is empty (first install), wait for the background sync to populate it
    await ref.watch(appSyncProvider.future);
    return cache.getLocalEvents();
  }
  return localEvents;
});

final liveEventsProvider = FutureProvider<List<SportEvent>>((ref) async {
  final events = await ref.watch(eventsProvider.future);
  final list = events.where((e) => e.isLive && e.channels.isNotEmpty).toList();
  list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return list;
});

final upcomingEventsProvider = FutureProvider<List<SportEvent>>((ref) async {
  final events = await ref.watch(eventsProvider.future);
  final list = events.where((e) => e.isUpcoming).toList();
  list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return list;
});

final featuredEventsProvider = Provider<AsyncValue<List<SportEvent>>>((ref) {
  final eventsState = ref.watch(eventsProvider);
  return eventsState.whenData(
    (events) => events.where((e) => e.isFeatured).toList(),
  );
});

final todayEventsProvider = Provider<AsyncValue<List<SportEvent>>>((ref) {
  final eventsState = ref.watch(eventsProvider);
  return eventsState.whenData((events) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return events.where((e) {
      final localStart = e.startTime.toLocal();
      final isToday = localStart.year == today.year &&
          localStart.month == today.month &&
          localStart.day == today.day;
      // Filter out any live event that does not have active channels added
      if (e.isLive && e.channels.isEmpty) return false;
      return isToday;
    }).toList();
  });
});

// ─── Sorted Sport Categories (cached, not recomputed on chip tap) ─────
const List<String> _popularSportsPriority = [
  'Cricket', 'Football', 'Motorsports', 'Motorsport', 'Formula 1',
  'Tennis', 'Golf', 'Volleyball', 'Basketball', 'Boxing',
  'Baseball', 'Rugby', 'American Football', 'Cycling',
];

final sortedSportCategoriesProvider = Provider<AsyncValue<List<String>>>((ref) {
  final eventsState = ref.watch(eventsProvider);
  return eventsState.whenData((events) {
    final rawSports = events
        .map((e) => e.sport.trim())
        .where((s) => s.isNotEmpty)
        .toSet();

    int getPriority(String sport) {
      final lower = sport.toLowerCase();
      for (int i = 0; i < _popularSportsPriority.length; i++) {
        if (_popularSportsPriority[i].toLowerCase() == lower) return i;
      }
      return 999;
    }

    final sortedSports = rawSports.toList()
      ..sort((a, b) {
        final pA = getPriority(a);
        final pB = getPriority(b);
        if (pA != pB) return pA.compareTo(pB);
        return a.compareTo(b);
      });

    return ['All', ...sortedSports];
  });
});

// ─── Filtered Today Events by Sport (cached per sport key) ────────────
final filteredTodayEventsProvider =
    Provider.family<AsyncValue<List<SportEvent>>, String>((ref, sport) {
  final todayState = ref.watch(todayEventsProvider);
  return todayState.whenData((allEvents) {
    if (sport.toLowerCase() == 'all') return allEvents;
    return allEvents
        .where((e) => e.sport.toLowerCase() == sport.toLowerCase())
        .toList();
  });
});

// ─── Categories ───────────────────────────────────────────────
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final cache = ref.watch(cacheServiceProvider);
  final localCategories = cache.getLocalCategories();

  if (localCategories.isEmpty) {
    // If the local cache is empty (first install), wait for the background sync to populate it
    await ref.watch(appSyncProvider.future);
    return cache.getLocalCategories();
  }
  return localCategories;
});

final activeCategoriesWithCountsProvider = Provider<AsyncValue<List<(Category, int)>>>((ref) {
  final categoriesAsync = ref.watch(categoriesProvider);
  final groupedAsync = ref.watch(channelsByCategoryMapProvider);

  if (categoriesAsync.isLoading || groupedAsync.isLoading) {
    return const AsyncValue.loading();
  }
  if (categoriesAsync.hasError) {
    return AsyncValue.error(categoriesAsync.error!, categoriesAsync.stackTrace!);
  }
  if (groupedAsync.hasError) {
    return AsyncValue.error(groupedAsync.error!, groupedAsync.stackTrace!);
  }

  final categories = categoriesAsync.requireValue;
  final grouped = groupedAsync.requireValue;

  // Counts come straight from the shared grouping map — no extra scan.
  final list = <(Category, int)>[];
  for (final cat in categories) {
    final count = grouped[cat.id]?.length ?? 0;
    if (count > 0) list.add((cat, count));
  }

  list.sort((a, b) {
    final byOrder = a.$1.sortOrder.compareTo(b.$1.sortOrder);
    // Stable, deterministic ordering when sort_order collides, otherwise the
    // tab order can shuffle between syncs and desync the TabController.
    return byOrder != 0 ? byOrder : a.$1.id.compareTo(b.$1.id);
  });

  return AsyncValue.data(list);
});

// ─── Announcements (cache-first, background refresh) ─────────
final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final cache = ref.read(cacheServiceProvider);
  final local = cache.getLocalAnnouncements();
  if (local.isNotEmpty) return local;
  // If cache is empty, wait for sync to populate it
  await ref.watch(appSyncProvider.future);
  return cache.getLocalAnnouncements();
});

// ─── Search ───────────────────────────────────────────────────
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

final filteredChannelsProvider =
    FutureProvider.family<List<Channel>, String>((ref, query) async {
  if (query.isEmpty) return const [];
  final channels = await ref.watch(channelsProvider.future);
  final lowerQuery = query.toLowerCase();
  // Uses the cached per-channel search index instead of allocating four
  // lowercase strings per channel on every query.
  return channels.where((ch) => ch.searchIndex.contains(lowerQuery)).toList();
});

final filteredEventsProvider =
    FutureProvider.family<List<SportEvent>, String>((ref, query) async {
  if (query.isEmpty) return const [];
  final events = await ref.watch(eventsProvider.future);
  final lowerQuery = query.toLowerCase();
  return events.where((e) {
    return e.league.toLowerCase().contains(lowerQuery) ||
        e.sport.toLowerCase().contains(lowerQuery) ||
        e.homeTeam.name.toLowerCase().contains(lowerQuery) ||
        e.awayTeam.name.toLowerCase().contains(lowerQuery);
  }).toList();
});

// ─── Selected Category ───────────────────────────────────────
final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
  SelectedCategoryNotifier.new,
);

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'trending';

  void select(String category) => state = category;
}

// ─── Favorites (persisted to Hive) ────────────────────────────
final favoriteChannelIdsProvider =
    NotifierProvider<FavoriteNotifier, Set<String>>(
  FavoriteNotifier.new,
);

class FavoriteNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => ref.read(cacheServiceProvider).getFavoriteChannelIds();

  void toggle(String channelId) {
    final next = <String>{...state};
    if (!next.remove(channelId)) next.add(channelId);
    state = next;
    // Fire-and-forget write; the in-memory memo is updated synchronously so a
    // failed disk write never desyncs the UI within the session.
    ref.read(cacheServiceProvider).saveFavoriteChannelIds(next);
  }

  bool isFavorite(String channelId) => state.contains(channelId);
}

final favoriteChannelsProvider = Provider<AsyncValue<List<Channel>>>((ref) {
  final channelsAsync = ref.watch(channelsProvider);
  final favIds = ref.watch(favoriteChannelIdsProvider);

  return channelsAsync.whenData((channels) {
    return channels.where((ch) => favIds.contains(ch.id)).toList();
  });
});

// ─── Watch History (local) ────────────────────────────────────
final watchHistoryProvider =
    NotifierProvider<WatchHistoryNotifier, List<Channel>>(
  WatchHistoryNotifier.new,
);

class WatchHistoryNotifier extends Notifier<List<Channel>> {
  @override
  List<Channel> build() => [];

  void addChannel(Channel channel) {
    // Remove if exists, then prepend
    final updated = state.where((c) => c.id != channel.id).toList();
    updated.insert(0, channel);
    // Keep only last 20
    state = updated.take(20).toList();
  }
}

// ─── Navigation ───────────────────────────────────────────────
final selectedTabProvider = NotifierProvider<SelectedTabNotifier, int>(
  SelectedTabNotifier.new,
);

class SelectedTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int tab) => state = tab;
}

// ─── Selected Sport Filter ────────────────────────────────────
final selectedSportFilterProvider =
    NotifierProvider<SelectedSportFilterNotifier, String>(
  SelectedSportFilterNotifier.new,
);

class SelectedSportFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void select(String sport) => state = sport;
}
