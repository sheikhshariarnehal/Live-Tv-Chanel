import 'dart:developer' as developer;
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
    developer.log('Starting background sync...', name: 'SyncService');
    try {
      final SupabaseService supabase = _ref.read(supabaseServiceProvider);
      final CacheService cache = _ref.read(cacheServiceProvider);

      // 1. Fetch remote versions from Supabase
      final remoteVersions = await supabase.getSyncVersions();
      if (remoteVersions == null) {
        developer.log('Failed to fetch remote versions. Sync skipped.', name: 'SyncService');
        return;
      }

      final remoteChannelsVer = remoteVersions['channels_version'] as int;
      final remoteEventsVer = remoteVersions['events_version'] as int;

      final localChannelsVer = cache.getLocalChannelsVersion();
      final localEventsVer = cache.getLocalEventsVersion();

      developer.log(
        'Version check - Channels: local=$localChannelsVer, remote=$remoteChannelsVer | Events: local=$localEventsVer, remote=$remoteEventsVer',
        name: 'SyncService',
      );

      bool channelsUpdated = false;
      bool eventsUpdated = false;

      // 2. Synchronize Channels and Categories
      if (localChannelsVer == null || remoteChannelsVer > localChannelsVer) {
        developer.log('Channels version changed. Downloading channels and categories...', name: 'SyncService');
        
        // Sync categories first since channels have foreign-key-like category IDs
        final remoteCategories = await supabase.getCategories();
        await cache.saveLocalCategories(remoteCategories);

        // Sync channels (includes stream URLs and headers)
        final remoteChannels = await supabase.getChannels();
        await cache.saveLocalChannels(remoteChannels);

        // Update local version
        await cache.saveLocalChannelsVersion(remoteChannelsVer);
        channelsUpdated = true;
        developer.log('Channels and categories synchronized.', name: 'SyncService');
      }

      // 3. Synchronize Events
      if (localEventsVer == null || remoteEventsVer > localEventsVer) {
        developer.log('Events version changed. Downloading events...', name: 'SyncService');
        
        final remoteEvents = await supabase.getEvents();
        await cache.saveLocalEvents(remoteEvents);

        // Update local version
        await cache.saveLocalEventsVersion(remoteEventsVer);
        eventsUpdated = true;
        developer.log('Events synchronized.', name: 'SyncService');
      }

      // 4. Invalidate providers if anything changed to trigger reactive UI updates
      if (channelsUpdated) {
        developer.log('Invalidating channels and categories providers...', name: 'SyncService');
        _ref.invalidate(channelsProvider);
        _ref.invalidate(categoriesProvider);
      }

      if (eventsUpdated) {
        developer.log('Invalidating events providers...', name: 'SyncService');
        _ref.invalidate(eventsProvider);
      }

      developer.log('Background sync check completed successfully.', name: 'SyncService');
    } catch (e, stackTrace) {
      developer.log(
        'Error occurred during synchronization',
        error: e,
        stackTrace: stackTrace,
        name: 'SyncService',
      );
    }
  }
}
