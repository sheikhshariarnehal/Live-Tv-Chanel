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

  // ── Widevine / PlayReady fields ──
  final String? licenseUrl;
  final Map<String, String>? licenseHeaders;

  const DrmConfig({
    required this.type,
    this.kid,
    this.key,
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

    return DrmConfig(
      type: type,
      kid: map['kid'] as String?,
      key: map['key'] as String?,
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
    if (licenseUrl != null) map['licenseUrl'] = licenseUrl;
    if (licenseHeaders != null) map['headers'] = licenseHeaders;
    return map;
  }

  /// Whether this is a ClearKey scheme (keys embedded, no license server).
  bool get isClearKey => type == DrmType.clearkey;

  /// Whether this is a Widevine scheme (requires license server).
  bool get isWidevine => type == DrmType.widevine;

  @override
  String toString() => 'DrmConfig(type: $type, kid: $kid)';
}
