import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/event.dart';
import '../models/channel.dart';
import '../providers/app_providers.dart';
import '../core/theme.dart';
import '../core/typography.dart';

void showChannelSelector({
  required BuildContext context,
  required WidgetRef ref,
  required SportEvent event,
}) {
  if (event.channels.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No channels available for this event.'),
        backgroundColor: GoPlayTheme.error,
      ),
    );
    return;
  }

  if (event.channels.length == 1) {
    context.push('/player/${event.channels.first}');
    return;
  }

  // Fetch all channels from the provider
  final channelsAsync = ref.read(channelsProvider);
  final allChannels = channelsAsync.value ?? [];

  // Map the event channels to actual Channel models
  final matchedChannels = event.channels.map((id) {
    final match = allChannels.firstWhere(
      (c) => c.id == id,
      orElse: () => Channel(id: id, name: id, streamUrl: ''),
    );
    return match;
  }).toList();

  showModalBottomSheet(
    context: context,
    backgroundColor: GoPlayTheme.surfaceContainer,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Channel',
                          style: GoPlayType.subtitle.copyWith(
                            color: GoPlayTheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${event.homeTeam.name} vs ${event.awayTeam.name}',
                          style: GoPlayType.bodySmall.copyWith(
                            color: GoPlayTheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: GoPlayTheme.onSurfaceVariant),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: matchedChannels.length,
                  itemBuilder: (context, index) {
                    final channel = matchedChannels[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: GoPlayTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: GoPlayTheme.cardBorder, width: 0.5),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(15),
                          ),
                          child: channel.logo != null && channel.logo!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: channel.logo!,
                                  fit: BoxFit.cover,
                                  memCacheWidth: 80,
                                  memCacheHeight: 80,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => const Icon(
                                    Icons.live_tv_rounded,
                                    color: GoPlayTheme.primary,
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.live_tv_rounded,
                                    color: GoPlayTheme.primary,
                                  ),
                                )
                              : const Icon(
                                  Icons.live_tv_rounded,
                                  color: GoPlayTheme.primary,
                                ),
                        ),
                        title: Text(
                          channel.displayName,
                          style: GoPlayType.label.copyWith(
                            color: GoPlayTheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(
                          Icons.play_arrow_rounded,
                          color: GoPlayTheme.primary,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/player/${channel.id}');
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
