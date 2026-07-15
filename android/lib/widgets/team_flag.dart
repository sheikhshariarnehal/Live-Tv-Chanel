import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Renders a team flag or logo, supporting both emoji characters, network image URLs, and country codes.
///
/// Uses pre-rasterized PNG flags from flagcdn.com instead of SVG to avoid
/// per-frame XML re-parsing and Canvas::saveLayer overhead.
class TeamFlagWidget extends StatelessWidget {
  final String? flag;
  final double size;
  final String fallbackEmoji;

  const TeamFlagWidget({
    super.key,
    required this.flag,
    this.size = 22,
    this.fallbackEmoji = '🏳️',
  });

  String? _emojiToCountryCode(String emoji) {
    final trimmed = emoji.trim();
    if (RegExp(r'^[a-zA-Z]{2}(-[a-zA-Z]{3})?$').hasMatch(trimmed)) {
      return trimmed.toLowerCase();
    }
    final runes = trimmed.runes.toList();
    if (runes.length >= 2 && runes.every((r) => r >= 0x1F1E6 && r <= 0x1F1FF)) {
      return runes
          .map((r) => String.fromCharCode(r - 0x1F1E6 + 97)) // 97 is 'a'
          .join('');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (flag == null || flag!.trim().isEmpty) {
      return _buildFallback();
    }

    final trimmed = flag!.trim();

    // 1. If it's a URL — use CachedNetworkImage for all URLs (including SVG URLs,
    //    which CachedNetworkImage handles by downloading and decoding the bytes).
    if (trimmed.startsWith('http') || trimmed.startsWith('/') || trimmed.startsWith('data:')) {
      // RepaintBoundary isolates image raster work from parent list repaints.
      return RepaintBoundary(
        child: Container(
          width: size * 1.2,
          height: size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(25), width: 0.5),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: trimmed,
              fit: BoxFit.cover,
              // Cap decode size to 96 px (covers up to 40 dp at 3× DPR).
              memCacheWidth: 96,
              memCacheHeight: 96,
              fadeInDuration: const Duration(milliseconds: 100),
              placeholder: (context, url) => _buildFallback(),
              errorWidget: (context, url, error) => _buildFallback(),
            ),
          ),
        ),
      );
    }

    // 2. Try to get country code (either from raw code or from emoji flag).
    //    Use pre-rasterized PNG from flagcdn.com instead of SVG from flag-icons.
    final countryCode = _emojiToCountryCode(trimmed);
    if (countryCode != null) {
      // flagcdn.com serves pre-rasterized PNGs at exact widths — no SVG parsing needed.
      // w80 covers up to 26dp flags at 3× DPR.
      final pngUrl = 'https://flagcdn.com/w80/$countryCode.png';
      // RepaintBoundary isolates image raster work from parent list repaints.
      return RepaintBoundary(
        child: Container(
          width: size * 1.2,
          height: size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(25), width: 0.5),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: pngUrl,
              fit: BoxFit.cover,
              memCacheWidth: 80,
              memCacheHeight: 80,
              fadeInDuration: const Duration(milliseconds: 100),
              placeholder: (context, url) => _buildFallback(),
              errorWidget: (context, url, error) => _buildFallback(),
            ),
          ),
        ),
      );
    }

    // 3. Fallback: Render text or emoji using fitted box
    return Container(
      width: size * 1.2,
      height: size * 1.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(20),
      ),
      child: ClipOval(
        child: SizedBox.expand(
          child: Transform.scale(
            scale: 1.35,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Text(
                trimmed,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: size * 1.2,
      height: size * 1.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(20),
      ),
      child: Center(
        child: Text(
          fallbackEmoji,
          style: TextStyle(fontSize: size * 0.8),
        ),
      ),
    );
  }
}
