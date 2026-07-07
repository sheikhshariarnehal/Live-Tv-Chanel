/// Data model representing the remote update configuration.
class UpdateInfo {
  final String latestVersion;
  final String minimumVersion;
  final bool forceUpdate;
  final String apkUrl;
  final List<String> releaseNotes;
  final DateTime publishedAt;

  const UpdateInfo({
    required this.latestVersion,
    required this.minimumVersion,
    required this.forceUpdate,
    required this.apkUrl,
    required this.releaseNotes,
    required this.publishedAt,
  });

  /// Factory constructor to parse JSON.
  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      latestVersion: json['latestVersion'] as String,
      minimumVersion: json['minimumVersion'] as String,
      forceUpdate: json['forceUpdate'] as bool? ?? false,
      apkUrl: json['apkUrl'] as String,
      releaseNotes: List<String>.from(json['releaseNotes'] ?? const []),
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert model back to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'latestVersion': latestVersion,
      'minimumVersion': minimumVersion,
      'forceUpdate': forceUpdate,
      'apkUrl': apkUrl,
      'releaseNotes': releaseNotes,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}

/// Helper class for comparing semantic versions.
class VersionUtils {
  /// Compares two semantic version strings (e.g., '1.10.0' and '1.9.9').
  /// Returns:
  ///   1 if version1 > version2
  ///  -1 if version1 < version2
  ///   0 if version1 == version2
  static int compare(String version1, String version2) {
    // Strip build numbers (+...) or pre-release tags (-...)
    final cleanV1 = version1.split('+').first.split('-').first;
    final cleanV2 = version2.split('+').first.split('-').first;

    final parts1 = cleanV1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = cleanV2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final length = parts1.length > parts2.length ? parts1.length : parts2.length;
    for (int i = 0; i < length; i++) {
      final val1 = i < parts1.length ? parts1[i] : 0;
      final val2 = i < parts2.length ? parts2[i] : 0;

      if (val1 > val2) return 1;
      if (val1 < val2) return -1;
    }

    // If main semantic versions are identical, compare build codes (suffixes after '+')
    final hasBuild1 = version1.contains('+');
    final hasBuild2 = version2.contains('+');
    if (hasBuild1 || hasBuild2) {
      final build1Str = hasBuild1 ? version1.split('+').last.split('-').first : '';
      final build2Str = hasBuild2 ? version2.split('+').last.split('-').first : '';
      final build1 = int.tryParse(build1Str) ?? 0;
      final build2 = int.tryParse(build2Str) ?? 0;
      
      if (build1 > build2) return 1;
      if (build1 < build2) return -1;
    }

    return 0;
  }
}
