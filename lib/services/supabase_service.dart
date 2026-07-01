import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/channel.dart';
import '../models/event.dart';
import '../models/category.dart';
import '../models/announcement.dart';

/// Service for all Supabase database operations
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  // ─── Channels ───────────────────────────────────────────────

  /// Columns needed for list/grid display (excludes heavy stream_url & headers)
  static const String _listColumns =
      'id, name, logo, category, country, language, is_live, is_trending, quality, sort_order, added_at, proxy';

  Future<List<Channel>> getChannels() async {
    final response = await _client
        .from('channels')
        .select(_listColumns)
        .order('sort_order', ascending: true);
    return (response as List).map((e) => Channel.fromJson(e)).toList();
  }

  Future<List<Channel>> getTrendingChannels() async {
    final response = await _client
        .from('channels')
        .select(_listColumns)
        .eq('is_trending', true)
        .order('sort_order', ascending: true);
    return (response as List).map((e) => Channel.fromJson(e)).toList();
  }

  Future<List<Channel>> getChannelsByCategory(String categoryId) async {
    final response = await _client
        .from('channels')
        .select(_listColumns)
        .eq('category', categoryId)
        .order('sort_order', ascending: true);
    return (response as List).map((e) => Channel.fromJson(e)).toList();
  }

  Future<Channel?> getChannel(String id) async {
    final response =
        await _client.from('channels').select().eq('id', id).maybeSingle();
    if (response == null) return null;
    return Channel.fromJson(response);
  }

  // ─── Events ─────────────────────────────────────────────────
  Future<List<SportEvent>> getEvents() async {
    final response = await _client
        .from('events')
        .select()
        .order('start_time', ascending: true);
    return (response as List).map((e) => SportEvent.fromJson(e)).toList();
  }

  Future<List<SportEvent>> getLiveEvents() async {
    final response = await _client
        .from('events')
        .select()
        .eq('status', 'live')
        .order('start_time', ascending: true);
    return (response as List).map((e) => SportEvent.fromJson(e)).toList();
  }

  Future<List<SportEvent>> getUpcomingEvents() async {
    final response = await _client
        .from('events')
        .select()
        .eq('status', 'upcoming')
        .order('start_time', ascending: true);
    return (response as List).map((e) => SportEvent.fromJson(e)).toList();
  }

  Future<List<SportEvent>> getFeaturedEvents() async {
    final response = await _client
        .from('events')
        .select()
        .eq('is_featured', true)
        .order('start_time', ascending: true);
    return (response as List).map((e) => SportEvent.fromJson(e)).toList();
  }

  // ─── Categories ─────────────────────────────────────────────
  Future<List<Category>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('sort_order', ascending: true);
    return (response as List).map((e) => Category.fromJson(e)).toList();
  }

  // ─── Announcements ─────────────────────────────────────────
  Future<List<Announcement>> getAnnouncements() async {
    final response = await _client
        .from('announcements')
        .select()
        .eq('active', true)
        .order('created_at', ascending: false);
    return (response as List).map((e) => Announcement.fromJson(e)).toList();
  }

  // ─── Favorites ──────────────────────────────────────────────
  Future<List<String>> getFavoriteIds(String deviceId, String itemType) async {
    final response = await _client
        .from('favorites')
        .select('item_id')
        .eq('device_id', deviceId)
        .eq('item_type', itemType);
    return (response as List).map((e) => e['item_id'] as String).toList();
  }

  Future<void> addFavorite(
      String deviceId, String itemType, String itemId) async {
    await _client.from('favorites').upsert({
      'device_id': deviceId,
      'item_type': itemType,
      'item_id': itemId,
    }, onConflict: 'device_id,item_type,item_id');
  }

  Future<void> removeFavorite(
      String deviceId, String itemType, String itemId) async {
    await _client
        .from('favorites')
        .delete()
        .eq('device_id', deviceId)
        .eq('item_type', itemType)
        .eq('item_id', itemId);
  }

  // ─── Watch History ──────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getWatchHistory(String deviceId) async {
    final response = await _client
        .from('watch_history')
        .select()
        .eq('device_id', deviceId)
        .order('watched_at', ascending: false)
        .limit(20);
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<void> upsertWatchHistory({
    required String deviceId,
    required String channelId,
    String? title,
    String? logo,
  }) async {
    // Check if entry exists
    final existing = await _client
        .from('watch_history')
        .select('id')
        .eq('device_id', deviceId)
        .eq('channel_id', channelId)
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('watch_history')
          .update({'watched_at': DateTime.now().toIso8601String()})
          .eq('id', existing['id']);
    } else {
      await _client.from('watch_history').insert({
        'device_id': deviceId,
        'channel_id': channelId,
        'title': title,
        'logo': logo,
      });
    }
  }
}
