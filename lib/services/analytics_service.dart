import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';

/// Service to handle real-time user presence and playback telemetry.
class AnalyticsService with WidgetsBindingObserver {
  String? _deviceId;
  String? _deviceName;
  String? _osVersion;
  String? _appVersion;

  String _status = 'online'; // 'online', 'watching', 'offline'
  String? _currentChannelId;
  String? _currentChannelName;

  Timer? _heartbeatTimer;
  bool _isInitialized = false;

  AnalyticsService();

  /// Initialize device info, generate unique ID if needed, and start heartbeats.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final box = Hive.box(AppConstants.settingsBox);

      // 1. Retrieve or generate unique device_id
      _deviceId = box.get('analytics_device_id') as String?;
      _deviceName = box.get('analytics_device_name') as String?;
      _osVersion = box.get('analytics_os_version') as String?;

      if (_deviceId == null || _deviceName == null || _osVersion == null) {
        final deviceInfo = DeviceInfoPlugin();
        
        if (kIsWeb) {
          _deviceId = _generateUuid();
          _deviceName = 'Web Browser';
          _osVersion = 'Web';
        } else {
          if (Platform.isAndroid) {
            final androidInfo = await deviceInfo.androidInfo;
            // Use Android hardware ID as fallback if stable, or generate UUID
            _deviceId = androidInfo.id.isNotEmpty ? androidInfo.id : _generateUuid();
            _deviceName = '${androidInfo.brand} ${androidInfo.model}';
            _osVersion = 'Android ${androidInfo.version.release}';
          } else if (Platform.isIOS) {
            final iosInfo = await deviceInfo.iosInfo;
            _deviceId = iosInfo.identifierForVendor ?? _generateUuid();
            _deviceName = iosInfo.name;
            _osVersion = 'iOS ${iosInfo.systemVersion}';
          } else {
            _deviceId = _generateUuid();
            _deviceName = Platform.operatingSystem;
            _osVersion = Platform.operatingSystemVersion;
          }
        }

        // Cache resolved info to prevent future async calls
        await box.put('analytics_device_id', _deviceId);
        await box.put('analytics_device_name', _deviceName);
        await box.put('analytics_os_version', _osVersion);
      }

      // 2. Fetch app version
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        _appVersion = packageInfo.version;
      } catch (_) {
        _appVersion = AppConstants.appVersion;
      }

      // 3. Register lifecycle observer
      WidgetsBinding.instance.addObserver(this);
      _isInitialized = true;

      // 4. Send initial heartbeat and start timer
      _status = 'online';
      await _sendHeartbeat();
      _startHeartbeatTimer();
      
      debugPrint('AnalyticsService initialized successfully (Device ID: $_deviceId)');
    } catch (e) {
      debugPrint('Error initializing AnalyticsService: $e');
    }
  }

  /// Clean up resources
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _heartbeatTimer?.cancel();
  }

  // ─── Telemetry Hooks ────────────────────────────────────────

  /// Call when user starts watching a channel.
  void startWatching(String channelId, String channelName) {
    _status = 'watching';
    _currentChannelId = channelId;
    _currentChannelName = channelName;
    _triggerImmediateHeartbeat();
  }

  /// Call when user stops watching (closes player).
  void stopWatching() {
    _status = 'online';
    _currentChannelId = null;
    _currentChannelName = null;
    _triggerImmediateHeartbeat();
  }

  // ─── Lifecycle Observer ─────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isInitialized) return;

    if (state == AppLifecycleState.resumed) {
      // App brought to foreground - resume monitoring
      _status = 'online';
      _triggerImmediateHeartbeat();
      _startHeartbeatTimer();
      debugPrint('App resumed: Started analytics heartbeats');
    } else if (state == AppLifecycleState.paused) {
      // App sent to background - mark user offline immediately and stop timer
      _status = 'offline';
      _sendHeartbeat(sync: true); // Send synchronously/quickly before OS suspends
      _heartbeatTimer?.cancel();
      debugPrint('App paused: Stopped analytics heartbeats');
    }
  }

  // ─── Heartbeat Loops ────────────────────────────────────────

  void _startHeartbeatTimer() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _sendHeartbeat();
    });
  }

  void _triggerImmediateHeartbeat() {
    _sendHeartbeat();
    // Restart timer sequence to align with the latest state change
    _startHeartbeatTimer();
  }

  Future<void> _sendHeartbeat({bool sync = false}) async {
    if (_deviceId == null) return;

    final presenceData = {
      'device_id': _deviceId,
      'device_name': _deviceName,
      'os_version': _osVersion,
      'app_version': _appVersion,
      'status': _status,
      'current_channel_id': _currentChannelId,
      'current_channel_name': _currentChannelName,
      'last_active_at': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      final client = Supabase.instance.client;
      if (sync) {
        // Run un-awaited to execute quickly during app exit/pause
        unawaited(client.from('user_presence').upsert(presenceData).then((_) {}).catchError((_){}));
      } else {
        await client.from('user_presence').upsert(presenceData);
      }
    } catch (e) {
      debugPrint('Failed to send presence heartbeat: $e');
    }
  }

  // ─── Helper UUID generator ──────────────────────────────────

  /// Generates a RFC 4122 v4 compliant UUID in pure Dart (no dependencies).
  String _generateUuid() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));

    // Set version to 4 (random)
    values[6] = (values[6] & 0x0f) | 0x40;
    // Set variant to RFC 4122
    values[8] = (values[8] & 0x3f) | 0x80;

    final buffer = StringBuffer();
    for (var i = 0; i < 16; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10) {
        buffer.write('-');
      }
      buffer.write(values[i].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}


