import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../models/channel.dart';

/// Premium channel card widget for the channel grid
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

class _ChannelCardState extends State<ChannelCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  /// Builds a clean initials widget from the channel name
  Widget _buildInitials(double fontSize) {
    final name = widget.channel.name;
    final initials =
        name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: GoPlayTheme.primary,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final channel = widget.channel;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/player/${channel.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: _isHovered
              ? (Matrix4.identity()..scale(1.03))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            gradient: GoPlayTheme.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? GoPlayTheme.primary.withAlpha(60)
                  : GoPlayTheme.cardBorder,
              width: _isHovered ? 1.0 : 0.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: GoPlayTheme.primary.withAlpha(15),
                      blurRadius: 16,
                      spreadRadius: 0,
                    )
                  ]
                : null,
          ),
          child: Stack(
            children: [
              // Main content (Logo and Title centered)
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo circle (uniform border)
                      _LogoAvatar(
                        channel: channel,
                        buildInitials: _buildInitials,
                      ),
                      const SizedBox(height: 12),

                      // Channel name centered
                      Text(
                        channel.name,
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // Quality badge — top left corner
              if (channel.quality != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: channel.quality == '4K'
                          ? const Color(0xFF3B82F6).withAlpha(25)
                          : GoPlayTheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: channel.quality == '4K'
                            ? const Color(0xFF3B82F6).withAlpha(40)
                            : GoPlayTheme.primary.withAlpha(30),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      channel.quality!,
                      style: TextStyle(
                        color: channel.quality == '4K'
                            ? const Color(0xFF3B82F6)
                            : GoPlayTheme.primary,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

              // Live badge — top right corner
              if (channel.isLive)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: GoPlayTheme.liveBadge.withAlpha(20),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: GoPlayTheme.liveBadge.withAlpha(40),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: GoPlayTheme.liveBadge,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            color: GoPlayTheme.liveBadge,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // DRM badge — below quality badge (top left)
              if (channel.hasDrm)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withAlpha(20),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFFFF9800).withAlpha(40),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.lock,
                          color: Color(0xFFFF9800),
                          size: 7,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'DRM',
                          style: TextStyle(
                            color: Color(0xFFFF9800),
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
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

/// Logo avatar with clean standard border
class _LogoAvatar extends StatelessWidget {
  final Channel channel;
  final Widget Function(double fontSize) buildInitials;

  const _LogoAvatar({
    required this.channel,
    required this.buildInitials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: GoPlayTheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(
          color: channel.isLive
              ? GoPlayTheme.primary.withAlpha(50)
              : GoPlayTheme.cardBorder,
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: channel.logo != null && channel.logo!.isNotEmpty
            ? Image.network(
                channel.logo!,
                fit: BoxFit.cover,
                width: 52,
                height: 52,
                errorBuilder: (context, error, stackTrace) =>
                    buildInitials(14),
              )
            : buildInitials(14),
      ),
    );
  }
}
