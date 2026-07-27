import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';
import '../models/channel.dart';
import '../models/event.dart';
import '../models/category.dart';

/// Service for managing local Hive cache operations for channels, categories, events, and sync versions.
class CacheService {
  // ─── Channels ───────────────────────────────────────────────
  List<Channel> getLocalChannels() {
    final box = Hive.box(AppConstants.channelsBox);
    final List<dynamic>? rawList = box.get('channels');
    if (rawList == null) return [];
    return rawList
        .map((e) => Channel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveLocalChannels(List<Channel> channels) async {
    final box = Hive.box(AppConstants.channelsBox);
    final rawList = channels.map((c) => c.toJson()).toList();
    await box.put('channels', rawList);
  }

  // ─── Events ─────────────────────────────────────────────────
  List<SportEvent> getLocalEvents() {
    final box = Hive.box(AppConstants.eventsBox);
    final List<dynamic>? rawList = box.get('events');
    if (rawList == null) return [];
    final events = rawList
        .map((e) => SportEvent.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    events.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return events;
  }

  Future<void> saveLocalEvents(List<SportEvent> events) async {
    final box = Hive.box(AppConstants.eventsBox);
    final rawList = events.map((e) => e.toJson()).toList();
    await box.put('events', rawList);
  }

  // ─── Categories ─────────────────────────────────────────────
  List<Category> getLocalCategories() {
    final box = Hive.box(AppConstants.categoriesBox);
    final List<dynamic>? rawList = box.get('categories');
    if (rawList == null) return [];
    return rawList
        .map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveLocalCategories(List<Category> categories) async {
    final box = Hive.box(AppConstants.categoriesBox);
    final rawList = categories.map((c) => c.toJson()).toList();
    await box.put('categories', rawList);
  }

  // ─── Sync Versions ──────────────────────────────────────────
  int? getLocalChannelsVersion() {
    final box = Hive.box(AppConstants.settingsBox);
    return box.get('channels_version') as int?;
  }

  Future<void> saveLocalChannelsVersion(int version) async {
    final box = Hive.box(AppConstants.settingsBox);
    await box.put('channels_version', version);
  }

  int? getLocalEventsVersion() {
    final box = Hive.box(AppConstants.settingsBox);
    return box.get('events_version') as int?;
  }

  Future<void> saveLocalEventsVersion(int version) async {
    final box = Hive.box(AppConstants.settingsBox);
    await box.put('events_version', version);
  }

  Future<void> clearAllCache() async {
    await Hive.box(AppConstants.channelsBox).clear();
    await Hive.box(AppConstants.eventsBox).clear();
    await Hive.box(AppConstants.categoriesBox).clear();
    final settingsBox = Hive.box(AppConstants.settingsBox);
    await settingsBox.delete('channels_version');
    await settingsBox.delete('events_version');
  }
}
