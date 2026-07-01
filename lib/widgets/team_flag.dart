import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders a team flag or logo, supporting both emoji characters, network image URLs, and country codes
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
    if (trimmed.length == 2 && RegExp(r'^[a-zA-Z]{2}$').hasMatch(trimmed)) {
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

    // 1. If it's a URL
    if (trimmed.startsWith('http') || trimmed.startsWith('/') || trimmed.startsWith('data:')) {
      final isSvg = trimmed.toLowerCase().split('?').first.endsWith('.svg');
      return Container(
        width: size * 1.2,
        height: size * 1.2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha(25), width: 0.5),
        ),
        child: ClipOval(
          child: isSvg
              ? SvgPicture.network(
                  trimmed,
                  fit: BoxFit.cover,
                  placeholderBuilder: (context) => _buildFallback(),
                )
              : Image.network(
                  trimmed,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildFallback(),
                ),
        ),
      );
    }

    // 2. Try to get country code (either from raw code or from emoji flag)
    final countryCode = _emojiToCountryCode(trimmed);
    if (countryCode != null) {
      final svgUrl = 'https://cdn.jsdelivr.net/gh/lipis/flag-icons@7.3.2/flags/1x1/$countryCode.svg';
      return Container(
        width: size * 1.2,
        height: size * 1.2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha(25), width: 0.5),
        ),
        child: ClipOval(
          child: SvgPicture.network(
            svgUrl,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => _buildFallback(),
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
