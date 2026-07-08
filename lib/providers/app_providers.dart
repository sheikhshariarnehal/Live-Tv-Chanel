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
  
  if (localChannels.isEmpty) {
    // If the local cache is empty (first install), wait for the background sync to populate it
    await ref.watch(appSyncProvider.future);
    return cache.getLocalChannels();
  }
  return localChannels;
});

final trendingChannelsProvider = FutureProvider<List<Channel>>((ref) async {
  final channels = await ref.watch(channelsProvider.future);
  return channels.where((ch) => ch.isTrending).toList();
});

final channelsByCategoryProvider =
    FutureProvider.family<List<Channel>, String>((ref, categoryId) async {
  final channels = await ref.watch(channelsProvider.future);
  if (categoryId == 'all') return channels;
  return channels.where((ch) => ch.category == categoryId).toList();
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
  return events.where((e) => e.isLive).toList();
});

final upcomingEventsProvider = FutureProvider<List<SportEvent>>((ref) async {
  final events = await ref.watch(eventsProvider.future);
  return events.where((e) => e.isUpcoming).toList();
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
      return localStart.year == today.year &&
          localStart.month == today.month &&
          localStart.day == today.day;
    }).toList();
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

// ─── Announcements ────────────────────────────────────────────
final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return service.getAnnouncements();
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

// ─── Selected Category ───────────────────────────────────────
final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
  SelectedCategoryNotifier.new,
);

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void select(String category) => state = category;
}

// ─── Favorites ────────────────────────────────────────────────
final favoriteChannelIdsProvider =
    NotifierProvider<FavoriteNotifier, Set<String>>(
  FavoriteNotifier.new,
);

class FavoriteNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String channelId) {
    if (state.contains(channelId)) {
      state = {...state}..remove(channelId);
    } else {
      state = {...state, channelId};
    }
  }

  bool isFavorite(String channelId) => state.contains(channelId);
}

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
