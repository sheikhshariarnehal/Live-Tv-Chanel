import 'drm_config.dart';
import '../utils/channel_name.dart';

/// Data model for a TV channel
class Channel {
  final String id;
  final String name;
  final String? logo;
  final String? category;
  final String? country;
  final String? language;
  final bool isLive;
  final bool isTrending;
  final String? quality;
  final String streamUrl;
  final Map<String, dynamic> headers;
  final int sortOrder;
  final DateTime? addedAt;
  final bool proxy;
  final DrmConfig? drm;

  /// Whether the channel uses any form of DRM protection.
  bool get hasDrm => drm != null;

  /// Whether the channel uses ClearKey DRM (embedded keys, no license server).
  bool get isClearKey => drm?.type == DrmType.clearkey;

  /// Whether the channel uses Widevine DRM (requires license server).
  bool get isWidevine => drm?.type == DrmType.widevine;

  /// Lazily built, cached lowercase haystack used by every search path
  /// (category filter bar and the global search screen).
  ///
  /// Building this once per channel replaces three `toLowerCase()` allocations
  /// per channel *per keystroke* with a single cached `contains` lookup.
  String? _searchIndex;

  String get searchIndex => _searchIndex ??=
      '$name\u0000${category ?? ''}\u0000${country ?? ''}\u0000${language ?? ''}'
          .toLowerCase();

  String? _displayName;

  /// [name] cleaned up for rendering — see `normalizeChannelName`.
  ///
  /// Every surface that shows a channel to the user should read this instead of
  /// [name]. [name] stays raw so [searchIndex], analytics, and the operator
  /// dashboard keep matching the source catalog: a user searching the literal
  /// string they saw in a playlist still finds the channel.
  ///
  /// Cached for the same reason [searchIndex] is — the channel grid rebuilds
  /// these on every scroll frame.
  String get displayName => _displayName ??= normalizeChannelName(name);

  /// Two-letter avatar initials. Never throws: [name] is guaranteed non-empty
  /// by [fromJson], but callers may construct channels directly.
  ///
  /// Derived from [displayName] so a scraped `0. Tom and Jerry 2` shows `TO`
  /// rather than `0.`.
  String get initials {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  Channel({
    required this.id,
    required this.name,
    this.logo,
    this.category,
    this.country,
    this.language,
    this.isLive = true,
    this.isTrending = false,
    this.quality = 'HD',
    required this.streamUrl,
    this.headers = const {},
    this.sortOrder = 0,
    this.addedAt,
    this.proxy = false,
    this.drm,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    // Scraped M3U rows regularly carry a blank or missing `name`. An empty
    // name used to crash the grid via `''.substring(0, 1)` and rendered a
    // nameless card, so normalise it at the boundary.
    final rawName = (json['name'] as String?)?.trim() ?? '';
    final rawQuality = (json['quality'] as String?)?.trim();

    return Channel(
      id: json['id'] as String,
      name: rawName.isEmpty ? 'Unknown Channel' : rawName,
      logo: json['logo'] as String?,
      category: json['category'] as String?,
      country: json['country'] as String?,
      language: json['language'] as String?,
      isLive: json['is_live'] as bool? ?? true,
      isTrending: json['is_trending'] as bool? ?? false,
      quality: (rawQuality == null || rawQuality.isEmpty) ? 'HD' : rawQuality,
      streamUrl: json['stream_url'] as String? ?? '',
      headers: json['headers'] is Map
          ? Map<String, dynamic>.from(json['headers'] as Map)
          : {},
      sortOrder: json['sort_order'] as int? ?? 0,
      addedAt: json['added_at'] != null
          ? DateTime.tryParse(json['added_at'] as String)
          : null,
      proxy: json['proxy'] as bool? ?? false,
      drm: DrmConfig.fromJson(json['drm']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo': logo,
        'category': category,
        'country': country,
        'language': language,
        'is_live': isLive,
        'is_trending': isTrending,
        'quality': quality,
        'stream_url': streamUrl,
        'headers': headers,
        'sort_order': sortOrder,
        'added_at': addedAt?.toIso8601String(),
        'proxy': proxy,
        'drm': drm?.toJson(),
      };
}
