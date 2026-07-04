import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../models/channel.dart';

// ─── Pre-cached card decorations — never reallocated ─────────
const _cardDecoNormal = BoxDecoration(
  gradient: GoPlayTheme.cardGradient,
  borderRadius: BorderRadius.all(Radius.circular(10)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
);

const _cardDecoHovered = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF35373C), Color(0xFF2C2D31)], // Highlighted container
  ),
  borderRadius: BorderRadius.all(Radius.circular(10)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x6471768E), width: 0.8), // Alabaster Grey @ 39%
  ),
  boxShadow: [
    BoxShadow(
      color: Color(0x1471768E), // Alabaster Grey @ 8%
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ],
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
  color: Color(0x1900E676), // primary @ 10%
  borderRadius: BorderRadius.all(Radius.circular(4)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x2800E676), width: 0.5), // primary @ 16%
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

/// Premium channel card widget for the channel grid.
class ChannelCard extends StatefulWidget {
  final Channel channel;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const ChannelCard({
    super.key,
    required this.channel,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  State<ChannelCard> createState() => _ChannelCardState();
}

class _ChannelCardState extends State<ChannelCard> {
  bool _isHovered = false;

  Widget _buildInitials() {
    final name = widget.channel.name;
    final initials = name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: Color(0xC8FFFFFF), // white @ 78%
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final channel = widget.channel;
    final is4K = channel.quality == '4K';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/player/${channel.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          // Hovered: slight 3% scale — uses cached Matrix; not built per frame.
          transform: _isHovered
              ? Matrix4.diagonal3Values(1.03, 1.03, 1.0)
              : Matrix4.identity(),
          // Switch between two pre-cached decorations — zero allocations.
          decoration: _isHovered ? _cardDecoHovered : _cardDecoNormal,
          child: Stack(
            alignment: Alignment
                .center, // Vertically and horizontally centers the main content!
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
                          child: ClipOval(
                            child:
                                channel.logo != null && channel.logo!.isNotEmpty
                                ? Image.network(
                                    channel.logo!,
                                    fit: BoxFit.cover,
                                    width: 54,
                                    height: 54,
                                    cacheWidth: 108,
                                    cacheHeight: 108,
                                    errorBuilder: (_, err, st) =>
                                        _buildInitials(),
                                  )
                                : _buildInitials(),
                          ),
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
