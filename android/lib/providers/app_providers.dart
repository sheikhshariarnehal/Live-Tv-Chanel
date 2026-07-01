import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/channel.dart';
import '../models/event.dart';
import '../models/category.dart';
import '../models/announcement.dart';

// ─── Core Service Provider ────────────────────────────────────
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(Supabase.instance.client);
});

// ─── Channels ─────────────────────────────────────────────────
final channelsProvider = FutureProvider<List<Channel>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return service.getChannels();
});

final trendingChannelsProvider = FutureProvider<List<Channel>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return service.getTrendingChannels();
});

final channelsByCategoryProvider =
    FutureProvider.family<List<Channel>, String>((ref, categoryId) async {
  final service = ref.read(supabaseServiceProvider);
  if (categoryId == 'all') return service.getChannels();
  return service.getChannelsByCategory(categoryId);
});

final channelProvider =
    FutureProvider.family<Channel?, String>((ref, id) async {
  final service = ref.read(supabaseServiceProvider);
  return service.getChannel(id);
});

// ─── Events ───────────────────────────────────────────────────
final eventsProvider = FutureProvider<List<SportEvent>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return service.getEvents();
});

final liveEventsProvider = FutureProvider<List<SportEvent>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return service.getLiveEvents();
});

final upcomingEventsProvider = FutureProvider<List<SportEvent>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return service.getUpcomingEvents();
});

final featuredEventsProvider = Provider<AsyncValue<List<SportEvent>>>((ref) {
  final eventsState = ref.watch(eventsProvider);
  return eventsState.whenData(
    (events) => events.where((e) => e.isFeatured).toList(),
  );
});

// ─── Categories ───────────────────────────────────────────────
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return service.getCategories();
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
