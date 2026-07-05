import 'dart:convert';
import 'package:hive/hive.dart';
import '../core/constants.dart';
import '../models/update_info.dart';
import '../services/update_service.dart';

class UpdateRepository {
  final UpdateService _updateService;

  UpdateRepository(this._updateService);

  /// Gets the current version of the app.
  Future<String> getCurrentVersion() => _updateService.getCurrentVersion();

  /// Checks if a check is needed (i.e. more than 6 hours have passed since the last check).
  bool shouldCheckForUpdate() {
    try {
      final box = Hive.box(AppConstants.settingsBox);
      final lastCheckStr = box.get('last_update_check_time') as String?;
      if (lastCheckStr == null) return true;
      
      final lastCheck = DateTime.tryParse(lastCheckStr);
      if (lastCheck == null) return true;

      final difference = DateTime.now().difference(lastCheck);
      return difference.inHours >= 6;
    } catch (_) {
      return true;
    }
  }

  /// Updates the last check timestamp in cache.
  Future<void> updateLastCheckTimestamp() async {
    try {
      final box = Hive.box(AppConstants.settingsBox);
      await box.put('last_update_check_time', DateTime.now().toIso8601String());
    } catch (_) {
      // Ignore cache write errors
    }
  }

  /// Gets the last check timestamp from Hive.
  DateTime? getLastCheckTimestamp() {
    try {
      final box = Hive.box(AppConstants.settingsBox);
      final lastCheckStr = box.get('last_update_check_time') as String?;
      if (lastCheckStr != null) {
        return DateTime.tryParse(lastCheckStr);
      }
    } catch (_) {}
    return null;
  }

  /// Fetches update info and determines if an update is available.
  Future<UpdateCheckResult> checkForUpdates({bool forceCheck = false}) async {
    final currentVersion = await getCurrentVersion();
    
    // Check if we should skip check based on 6-hour caching rule
    if (!forceCheck && !shouldCheckForUpdate()) {
      final cachedInfo = _getCachedUpdateInfo();
      if (cachedInfo != null) {
        final hasUpdate = VersionUtils.compare(cachedInfo.latestVersion, currentVersion) > 0;
        final isForce = cachedInfo.forceUpdate || VersionUtils.compare(currentVersion, cachedInfo.minimumVersion) < 0;
        return UpdateCheckResult(
          updateInfo: cachedInfo,
          isUpdateAvailable: hasUpdate,
          isForceUpdate: isForce && hasUpdate,
          currentVersion: currentVersion,
        );
      }
      return UpdateCheckResult(
        updateInfo: null,
        isUpdateAvailable: false,
        isForceUpdate: false,
        currentVersion: currentVersion,
      );
    }

    try {
      final updateInfo = await _updateService.fetchUpdateInfo(AppConstants.updateJsonUrl);
      await updateLastCheckTimestamp();
      await _cacheUpdateInfo(updateInfo);

      final hasUpdate = VersionUtils.compare(updateInfo.latestVersion, currentVersion) > 0;
      final isForce = updateInfo.forceUpdate || VersionUtils.compare(currentVersion, updateInfo.minimumVersion) < 0;

      return UpdateCheckResult(
        updateInfo: updateInfo,
        isUpdateAvailable: hasUpdate,
        isForceUpdate: isForce && hasUpdate,
        currentVersion: currentVersion,
      );
    } catch (e) {
      // Gracefully handle network errors by falling back to cache if available
      final cachedInfo = _getCachedUpdateInfo();
      if (cachedInfo != null) {
        final hasUpdate = VersionUtils.compare(cachedInfo.latestVersion, currentVersion) > 0;
        final isForce = cachedInfo.forceUpdate || VersionUtils.compare(currentVersion, cachedInfo.minimumVersion) < 0;
        return UpdateCheckResult(
          updateInfo: cachedInfo,
          isUpdateAvailable: hasUpdate,
          isForceUpdate: isForce && hasUpdate,
          currentVersion: currentVersion,
          error: e.toString(),
        );
      }
      rethrow;
    }
  }

  UpdateInfo? _getCachedUpdateInfo() {
    try {
      final box = Hive.box(AppConstants.settingsBox);
      final jsonStr = box.get('cached_update_info') as String?;
      if (jsonStr != null) {
        final Map<String, dynamic> map = jsonDecode(jsonStr);
        return UpdateInfo.fromJson(map);
      }
    } catch (_) {}
    return null;
  }

  Future<void> _cacheUpdateInfo(UpdateInfo info) async {
    try {
      final box = Hive.box(AppConstants.settingsBox);
      await box.put('cached_update_info', jsonEncode(info.toJson()));
    } catch (_) {}
  }
}

class UpdateCheckResult {
  final UpdateInfo? updateInfo;
  final bool isUpdateAvailable;
  final bool isForceUpdate;
  final String currentVersion;
  final String? error;

  UpdateCheckResult({
    required this.updateInfo,
    required this.isUpdateAvailable,
    required this.isForceUpdate,
    required this.currentVersion,
    this.error,
  });
}
