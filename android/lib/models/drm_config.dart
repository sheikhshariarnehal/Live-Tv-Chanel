/// Supported DRM protection schemes
enum DrmType { clearkey, widevine, playready }

/// DRM configuration for a channel stream.
///
/// ClearKey: kid + key (hex strings) are embedded locally — no license server.
/// Widevine: licenseUrl is required; licenseHeaders are optional auth tokens.
/// PlayReady: reserved for future use.
class DrmConfig {
  final DrmType type;

  // ── ClearKey fields ──
  final String? kid;
  final String? key;
  final Map<String, String>? clearKeys;

  // ── Widevine / PlayReady fields ──
  final String? licenseUrl;
  final Map<String, String>? licenseHeaders;

  const DrmConfig({
    required this.type,
    this.kid,
    this.key,
    this.clearKeys,
    this.licenseUrl,
    this.licenseHeaders,
  });

  /// Parse DRM config from Supabase JSONB column.
  /// Returns null if the json is null or empty.
  static DrmConfig? fromJson(dynamic json) {
    if (json == null || json is! Map) return null;
    final map = Map<String, dynamic>.from(json);

    final typeStr = map['type'] as String? ?? 'clearkey';
    final type = DrmType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => DrmType.clearkey,
    );

    // Parse clearKeys if present
    Map<String, String>? clearKeys;
    final clearKeysJson = map['clearKeys'] ?? map['clearkeys'];
    if (clearKeysJson is Map) {
      clearKeys = Map<String, String>.from(
        clearKeysJson.map((k, v) => MapEntry(k.toString(), v.toString())),
      );
    } else if (map['keys'] is List) {
      clearKeys = {};
      for (final item in map['keys']) {
        if (item is Map) {
          final k = item['kid']?.toString();
          final v = item['key']?.toString();
          if (k != null && v != null) {
            clearKeys[k] = v;
          }
        }
      }
    }

    final kid = map['kid'] as String?;
    final key = map['key'] as String?;

    // Backwards compatibility fallback: if kid/key are in the root but not in clearKeys
    if (kid != null && key != null) {
      clearKeys ??= {};
      if (!clearKeys.containsKey(kid)) {
        clearKeys[kid] = key;
      }
    }

    return DrmConfig(
      type: type,
      kid: kid,
      key: key,
      clearKeys: clearKeys,
      licenseUrl: map['licenseUrl'] as String?,
      licenseHeaders: map['headers'] != null
          ? Map<String, String>.from(map['headers'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'type': type.name};
    if (kid != null) map['kid'] = kid;
    if (key != null) map['key'] = key;
    if (clearKeys != null) map['clearKeys'] = clearKeys;
    if (licenseUrl != null) map['licenseUrl'] = licenseUrl;
    if (licenseHeaders != null) map['headers'] = licenseHeaders;
    return map;
  }

  /// Whether this is a ClearKey scheme (keys embedded, no license server).
  bool get isClearKey => type == DrmType.clearkey;

  /// Whether this is a Widevine scheme (requires license server).
  bool get isWidevine => type == DrmType.widevine;

  @override
  String toString() => 'DrmConfig(type: $type, kid: $kid, keysCount: ${clearKeys?.length ?? 0})';
}
