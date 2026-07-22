import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../models/channel.dart';
import '../tv_focus_wrapper.dart';

// ─── Pre-cached card decoration — never reallocated ──────────
const _cardDeco = BoxDecoration(
  gradient: GoPlayTheme.cardGradient,
  borderRadius: BorderRadius.all(Radius.circular(8)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
);

// ─── Pre-cached quality badge decorations ────────────────────
const _hd4kDeco = BoxDecoration(
  color: Color(0x1E3B82F6), // blue @ 12%
  borderRadius: BorderRadius.all(Radius.circular(4)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x323B82F6), width: 0.5), // blue @ 20%
  ),
);

const _hdDeco = BoxDecoration(
  color: Color(0x1900ADB5), // primary @ 10%
  borderRadius: BorderRadius.all(Radius.circular(4)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x2800ADB5), width: 0.5), // primary @ 16%
  ),
);

// ─── Pre-cached avatar decoration ────────────────────────────
const _avatarDeco = BoxDecoration(
  color: Color(0x14FFFFFF),
  shape: BoxShape.circle,
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 1.0),
  ),
);

// ─── Pre-cached text styles ───────────────────────────────────
const _nameStyle = TextStyle(
  color: GoPlayTheme.onSurface,
  fontSize: 11.5,
  fontWeight: FontWeight.w600,
  height: 1.2,
);

const _hdStyle = TextStyle(
  color: Color(0xFF60A5FA),
  fontSize: 8,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.5,
);

const _sdStyle = TextStyle(
  color: GoPlayTheme.primary,
  fontSize: 8,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.5,
);

// ─── Pre-cached initials text style ──────────────────────────
const _initialsStyle = TextStyle(
  color: Color(0xC8FFFFFF), // white @ 78%
  fontSize: 14,
  fontWeight: FontWeight.w800,
  letterSpacing: 1,
);

/// Fully stateless channel card widget for the channel grid.
/// StatelessWidget eliminates ~400 State objects per category view,
/// reducing tree walk cost, GC pressure and rebuild overhead on mobile
/// where hover events never fire.
class ChannelCard extends StatelessWidget {
  final Channel channel;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const ChannelCard({
    super.key,
    required this.channel,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  String get _initials {
    final name = channel.name;
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  Widget _buildInitials() => Center(
        child: Text(_initials, style: _initialsStyle),
      );

  @override
  Widget build(BuildContext context) {
    final is4K = channel.quality == '4K';

    return TvFocusable(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.push('/player/${channel.id}'),
      child: SizedBox.expand(
        child: DecoratedBox(
          decoration: _cardDeco,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Main Content ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo avatar — const decoration, no rebuild cost
                  Center(
                    child: SizedBox(
                      width: 54,
                      height: 54,
                      child: DecoratedBox(
                        decoration: _avatarDeco,
                        child: channel.logo != null && channel.logo!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: channel.logo!,
                                fit: BoxFit.cover,
                                width: 54,
                                height: 54,
                                memCacheWidth: 108,
                                memCacheHeight: 108,
                                fadeInDuration: const Duration(milliseconds: 150),
                                imageBuilder: (context, imageProvider) => DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => _buildInitials(),
                                errorWidget: (context, url, err) => _buildInitials(),
                              )
                            : _buildInitials(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    channel.name,
                    style: _nameStyle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── Quality Badge ─────────────────────────────────
            if (channel.quality != null)
              Positioned(
                top: 6,
                left: 6,
                child: DecoratedBox(
                  decoration: is4K ? _hd4kDeco : _hdDeco,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    child: Text(
                      channel.quality!,
                      style: is4K ? _hdStyle : _sdStyle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    );
  }
}
