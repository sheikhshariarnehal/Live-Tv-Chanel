import 'drm_config.dart';

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

  const Channel({
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
    return Channel(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      category: json['category'] as String?,
      country: json['country'] as String?,
      language: json['language'] as String?,
      isLive: json['is_live'] as bool? ?? true,
      isTrending: json['is_trending'] as bool? ?? false,
      quality: json['quality'] as String? ?? 'HD',
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
