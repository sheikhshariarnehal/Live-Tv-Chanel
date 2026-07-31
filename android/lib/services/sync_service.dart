import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cache_service.dart';
import 'supabase_service.dart';
import '../providers/app_providers.dart';

/// Orchestrates version-based background synchronization for channels and events.
class SyncService {
  final Ref _ref;

  SyncService(this._ref);

  /// Compares local cache versions with remote Supabase versions,
  /// downloads any modified tables, and updates Riverpod states.
  Future<void> sync() async {
    debugPrint('SyncService: Starting background sync...');
    try {
      final SupabaseService supabase = _ref.read(supabaseServiceProvider);
      final CacheService cache = _ref.read(cacheServiceProvider);

      // 1. Fetch remote versions from Supabase
      final remoteVersions = await supabase.getSyncVersions();
      if (remoteVersions == null) {
        debugPrint('SyncService: Failed to fetch remote versions. Sync skipped.');
        if (cache.getLocalChannels().isEmpty) {
          throw Exception('Failed to connect to server. Please check your internet connection.');
        }
        return;
      }

      final remoteChannelsVer = remoteVersions['channels_version'] as int;
      final remoteEventsVer = remoteVersions['events_version'] as int;

      final localChannelsVer = cache.getLocalChannelsVersion();
      final localEventsVer = cache.getLocalEventsVersion();

      debugPrint(
        'SyncService: Version check - Channels: local=$localChannelsVer, remote=$remoteChannelsVer | Events: local=$localEventsVer, remote=$remoteEventsVer',
      );

      bool channelsUpdated = false;
      bool eventsUpdated = false;

      // 2. Synchronize Channels and Categories
      if (localChannelsVer == null || remoteChannelsVer > localChannelsVer) {
        debugPrint('SyncService: Channels version changed. Downloading channels and categories...');
        
        // Sync categories first since channels have foreign-key-like category IDs
        final remoteCategories = await supabase.getCategories();
        await cache.saveLocalCategories(remoteCategories);

        // Sync channels (includes stream URLs and headers)
        final remoteChannels = await supabase.getChannels();
        await cache.saveLocalChannels(remoteChannels);

        // Update local version
        await cache.saveLocalChannelsVersion(remoteChannelsVer);
        channelsUpdated = true;
        debugPrint('SyncService: Channels and categories synchronized.');
      }

      // 3. Synchronize Events
      if (localEventsVer == null || remoteEventsVer > localEventsVer) {
        debugPrint('SyncService: Events version changed. Downloading events...');
        
        final remoteEvents = await supabase.getEvents();
        await cache.saveLocalEvents(remoteEvents);

        // Update local version
        await cache.saveLocalEventsVersion(remoteEventsVer);
        eventsUpdated = true;
        debugPrint('SyncService: Events synchronized.');
      }

      // 4. Invalidate providers if anything changed to trigger reactive UI updates
      // Only invalidate if we had a prior valid local version (meaning we displayed old cache and need to refresh it).
      // If the local version was null, the provider was awaiting the sync completion anyway, so it will naturally load the new data.
      if (channelsUpdated && localChannelsVer != null) {
        debugPrint('SyncService: Invalidating channels and categories providers...');
        _ref.invalidate(channelsProvider);
        _ref.invalidate(categoriesProvider);
      }

      if (eventsUpdated && localEventsVer != null) {
        debugPrint('SyncService: Invalidating events providers...');
        _ref.invalidate(eventsProvider);
      }

      // 5. Sync announcements (lightweight — no version check, always refresh)
      try {
        final remoteAnnouncements = await supabase.getAnnouncements();
        await cache.saveLocalAnnouncements(remoteAnnouncements);
      } catch (e) {
        debugPrint('SyncService: Announcements sync failed (non-fatal): $e');
      }

      debugPrint('SyncService: Background sync check completed successfully.');
    } catch (e, stackTrace) {
      debugPrint('SyncService: Error occurred during synchronization: $e\n$stackTrace');
      final cache = _ref.read(cacheServiceProvider);
      if (cache.getLocalChannels().isEmpty) {
        rethrow;
      }
    }
  }
}
