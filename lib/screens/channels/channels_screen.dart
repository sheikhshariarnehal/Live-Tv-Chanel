import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/cards/channel_card.dart';

class ChannelsScreen extends ConsumerWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final channelsAsync = ref.watch(channelsByCategoryProvider(selectedCategory));
    final searchQuery = ref.watch(searchQueryProvider);
    final favorites = ref.watch(favoriteChannelIdsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            title: const Text('Channels'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () => context.push('/search'),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: categoriesAsync.when(
                data: (categories) {
                  return SizedBox(
                    height: 42,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _CategoryChip(
                          label: 'All',
                          icon: '📺',
                          isSelected: selectedCategory == 'all',
                          onTap: () => ref
                              .read(selectedCategoryProvider.notifier)
                              .select('all'),
                        ),
                        ...categories.map((cat) => _CategoryChip(
                              label: cat.name,
                              icon: cat.icon ?? '📁',
                              isSelected: selectedCategory == cat.id,
                              onTap: () => ref
                                  .read(selectedCategoryProvider.notifier)
                                  .select(cat.id),
                            )),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox(height: 42),
                error: (_, __) => const SizedBox(height: 42),
              ),
            ),
          ),

          // Channel Grid
          channelsAsync.when(
            data: (channels) {
              // Apply search filter
              final filtered = searchQuery.isEmpty
                  ? channels
                  : channels
                      .where((ch) =>
                          ch.name.toLowerCase().contains(searchQuery.toLowerCase()))
                      .toList();

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.live_tv_outlined,
                            size: 60, color: GoPlayTheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(
                          'No channels found',
                          style: TextStyle(
                            color: GoPlayTheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final width = MediaQuery.of(context).size.width;
              int crossAxisCount = 3;
              if (width >= 1000) {
                crossAxisCount = 6;
              } else if (width >= 700) {
                crossAxisCount = 4;
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final channel = filtered[index];
                      return ChannelCard(
                        channel: channel,
                        isFavorite: favorites.contains(channel.id),
                        onFavoriteTap: () {
                          ref
                              .read(favoriteChannelIdsProvider.notifier)
                              .toggle(channel.id);
                        },
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: GoPlayTheme.primary),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48, color: GoPlayTheme.error),
                    const SizedBox(height: 8),
                    Text('Error loading channels',
                        style: TextStyle(color: GoPlayTheme.error)),
                    const SizedBox(height: 4),
                    Text('$e',
                        style: TextStyle(
                            color: GoPlayTheme.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? GoPlayTheme.primary.withAlpha(25)
              : GoPlayTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? GoPlayTheme.primary : GoPlayTheme.cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? GoPlayTheme.primary : GoPlayTheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
