import 'package:flutter/foundation.dart' hide Category;
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';
import '../models/channel.dart';
import '../models/event.dart';
import '../models/category.dart';

/// Service for managing local cache operations.
///
/// Uses an **in-memory store** as the primary data holder so the app always
/// works even when Hive boxes fail to open (e.g. Windows lock-file issues
/// during debug sessions). Hive is used as optional persistence — when boxes
/// are available, data is persisted across restarts; when they're not, the
/// in-memory store keeps data alive for the lifetime of the session.
class CacheService {
  // ─── In-memory fallback store ──────────────────────────────
  // Static so the data survives across provider rebuilds within a session.
  static List<Channel>? _memChannels;
  static List<SportEvent>? _memEvents;
  static List<Category>? _memCategories;
  static int? _memChannelsVersion;
  static int? _memEventsVersion;

  /// Returns the Hive box only if it is currently open, otherwise null.
  Box? _safeBox(String name) {
    if (!Hive.isBoxOpen(name)) return null;
    return Hive.box(name);
  }

  // ─── Channels ───────────────────────────────────────────────
  List<Channel> getLocalChannels() {
    final box = _safeBox(AppConstants.channelsBox);
    if (box != null) {
      final List<dynamic>? rawList = box.get('channels');
      if (rawList != null) {
        final channels = rawList
            .map((e) => Channel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        _memChannels = channels; // keep memory in sync
        return channels;
      }
    }
    return _memChannels ?? [];
  }

  Future<void> saveLocalChannels(List<Channel> channels) async {
    _memChannels = channels; // always persist to memory first
    final box = _safeBox(AppConstants.channelsBox);
    if (box == null) {
      debugPrint('CacheService: channels saved to memory only (Hive unavailable).');
      return;
    }
    await box.put('channels', channels.map((c) => c.toJson()).toList());
  }

  // ─── Events ─────────────────────────────────────────────────
  List<SportEvent> getLocalEvents() {
    final box = _safeBox(AppConstants.eventsBox);
    if (box != null) {
      final List<dynamic>? rawList = box.get('events');
      if (rawList != null) {
        final events = rawList
            .map((e) => SportEvent.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        _memEvents = events;
        return events;
      }
    }
    return _memEvents ?? [];
  }

  Future<void> saveLocalEvents(List<SportEvent> events) async {
    _memEvents = events;
    final box = _safeBox(AppConstants.eventsBox);
    if (box == null) {
      debugPrint('CacheService: events saved to memory only (Hive unavailable).');
      return;
    }
    await box.put('events', events.map((e) => e.toJson()).toList());
  }

  // ─── Categories ─────────────────────────────────────────────
  List<Category> getLocalCategories() {
    final box = _safeBox(AppConstants.categoriesBox);
    if (box != null) {
      final List<dynamic>? rawList = box.get('categories');
      if (rawList != null) {
        final cats = rawList
            .map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        _memCategories = cats;
        return cats;
      }
    }
    return _memCategories ?? [];
  }

  Future<void> saveLocalCategories(List<Category> categories) async {
    _memCategories = categories;
    final box = _safeBox(AppConstants.categoriesBox);
    if (box == null) {
      debugPrint('CacheService: categories saved to memory only (Hive unavailable).');
      return;
    }
    await box.put('categories', categories.map((c) => c.toJson()).toList());
  }

  // ─── Sync Versions ──────────────────────────────────────────
  int? getLocalChannelsVersion() {
    final box = _safeBox(AppConstants.settingsBox);
    if (box != null) {
      final v = box.get('channels_version') as int?;
      if (v != null) {
        _memChannelsVersion = v;
        return v;
      }
    }
    return _memChannelsVersion;
  }

  Future<void> saveLocalChannelsVersion(int version) async {
    _memChannelsVersion = version;
    final box = _safeBox(AppConstants.settingsBox);
    if (box == null) return;
    await box.put('channels_version', version);
  }

  int? getLocalEventsVersion() {
    final box = _safeBox(AppConstants.settingsBox);
    if (box != null) {
      final v = box.get('events_version') as int?;
      if (v != null) {
        _memEventsVersion = v;
        return v;
      }
    }
    return _memEventsVersion;
  }

  Future<void> saveLocalEventsVersion(int version) async {
    _memEventsVersion = version;
    final box = _safeBox(AppConstants.settingsBox);
    if (box == null) return;
    await box.put('events_version', version);
  }
}
