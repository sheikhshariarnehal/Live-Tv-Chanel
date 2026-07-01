import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/drm_config.dart';

/// Flutter-side interface to the native DRM platform channel.
///
/// Communicates with [DrmBridgePlugin] on Android to construct
/// ClearKey license responses and retrieve DRM scheme UUIDs.
class DrmService {
  static const _channel = MethodChannel('com.goplay/drm');

  /// Build a ClearKey license JSON from hex kid/key.
  /// Returns the RFC 8586 JSON string ready for ExoPlayer's LocalMediaDrmCallback.
  static Future<String> buildClearKeyLicense({
    required String kid,
    required String key,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'buildClearKeyLicense',
        {'kid': kid, 'key': key},
      );
      return result ?? _buildClearKeyFallback(kid, key);
    } catch (e) {
      // Fallback: build it in Dart if the platform channel isn't available
      return _buildClearKeyFallback(kid, key);
    }
  }

  /// Get the DRM scheme UUID string for ExoPlayer.
  static Future<String?> getDrmSchemeUuid(DrmType type) async {
    try {
      return await _channel.invokeMethod<String>(
        'getDrmSchemeUuid',
        {'type': type.name},
      );
    } catch (_) {
      return null;
    }
  }

  /// Pure-Dart fallback for building ClearKey license JSON.
  /// Used when the native platform channel is unavailable (e.g., during testing).
  static String _buildClearKeyFallback(String kidHex, String keyHex) {
    final kidBase64 = hexToBase64Url(kidHex);
    final keyBase64 = hexToBase64Url(keyHex);

    return jsonEncode({
      'keys': [
        {
          'kty': 'oct',
          'k': keyBase64,
          'kid': kidBase64,
        }
      ],
      'type': 'temporary',
    });
  }

  /// Convert a hex string to base64url encoding (no padding).
  static String hexToBase64Url(String hex) {
    final cleanHex = hex.replaceAll(' ', '').toLowerCase();
    final bytes = List<int>.generate(
      cleanHex.length ~/ 2,
      (i) => int.parse(cleanHex.substring(i * 2, i * 2 + 2), radix: 16),
    );
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}
