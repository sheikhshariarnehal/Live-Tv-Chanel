import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goplay/models/category.dart';
import 'package:goplay/models/channel.dart';
import 'package:goplay/providers/app_providers.dart';
import 'package:goplay/screens/channels/channels_screen.dart';
import 'package:goplay/services/cache_service.dart';
import 'package:goplay/widgets/cards/channel_card.dart';

/// Serves fixture data without touching Hive.
class _FakeCache extends CacheService {
  _FakeCache({required this.channels, required this.categories});

  final List<Channel> channels;
  final List<Category> categories;

  @override
  List<Channel> getLocalChannels() => channels;

  @override
  List<Category> getLocalCategories() => categories;

  @override
  Set<String> getFavoriteChannelIds() => <String>{};

  @override
  Future<void> saveFavoriteChannelIds(Set<String> ids) async {}
}

/// Logos are deliberately null so no network image is created in tests.
Channel channel(String id, String name, String? category) => Channel(
      id: id,
      name: name,
      category: category,
      streamUrl: 'https://example.test/$id.m3u8',
    );

Category category(String id, String name, int sortOrder) =>
    Category(id: id, name: name, sortOrder: sortOrder);

Future<ProviderContainer> pumpScreen(WidgetTester tester) async {
  final cache = _FakeCache(
    channels: [
      channel('c1', 'Alpha One', 'sports'),
      channel('c2', 'Bravo Two', 'sports'),
      channel('c3', 'Charlie Three', 'news'),
      channel('c4', 'Delta Four', 'movies'),
    ],
    categories: [
      category('sports', 'Sports', 0),
      category('news', 'News', 1),
      category('movies', 'Movies', 2),
    ],
  );

  final container = ProviderContainer(
    overrides: [cacheServiceProvider.overrideWithValue(cache)],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: ChannelsScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  group('ChannelsScreen', () {
    // Regression: `_CategoryPageContentState._resident` was `late` and assigned
    // after `super.initState()`, but AutomaticKeepAliveClientMixin reads
    // `wantKeepAlive` from inside its own initState. Every page threw
    // LateInitializationError on mount. Neither the analyzer nor a compile
    // catches this — only mounting the widget does.
    testWidgets('mounts without throwing', (tester) async {
      await pumpScreen(tester);
      expect(tester.takeException(), isNull);
      expect(find.byType(ChannelsScreen), findsOneWidget);
    });

    testWidgets('renders Trending, Favorite, All tabs plus one tab per non-empty category',
        (tester) async {
      await pumpScreen(tester);

      expect(find.text('Trending'), findsOneWidget);
      expect(find.text('Favorite'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Sports'), findsOneWidget);
      expect(find.text('News'), findsOneWidget);
      expect(find.text('Movies'), findsOneWidget);
    });

    testWidgets('the All tab lists every channel', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(find.byType(ChannelCard), findsNWidgets(4));
    });

    testWidgets('tapping a tab maps to the right category', (tester) async {
      final container = await pumpScreen(tester);

      await tester.tap(find.text('Sports'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(container.read(selectedCategoryProvider), 'sports');
      expect(find.text('Alpha One'), findsOneWidget);
      expect(find.text('Charlie Three'), findsNothing);

      await tester.tap(find.text('Movies'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(container.read(selectedCategoryProvider), 'movies');
      expect(find.text('Delta Four'), findsOneWidget);
      expect(find.text('Alpha One'), findsNothing);
    });

    testWidgets('driving the provider moves the tab', (tester) async {
      final container = await pumpScreen(tester);

      container.read(selectedCategoryProvider.notifier).select('news');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Charlie Three'), findsOneWidget);
    });

    testWidgets('search filters the visible category', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Sports'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'bravo');
      // Query is debounced by 150ms.
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Bravo Two'), findsOneWidget);
      expect(find.text('Alpha One'), findsNothing);
    });

    testWidgets('search matches country and language too', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Sports'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'zzzz-no-match');
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.byType(ChannelCard), findsNothing);
      expect(find.text('No channels match your search'), findsOneWidget);
    });

    testWidgets('back closes search instead of leaving the screen',
        (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);

      // Simulates the Android system back gesture.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(TextField), findsNothing);
      expect(find.text('Channels'), findsOneWidget);
    });

    testWidgets('a category dropping to zero channels retires its tab',
        (tester) async {
      // Exercises the TabController rebuild path: the id list changes, so the
      // controller and the index -> category mapping must be replaced together.
      final container = await pumpScreen(tester);

      container.read(selectedCategoryProvider.notifier).select('movies');
      await tester.pumpAndSettle();
      expect(find.text('Delta Four'), findsOneWidget);

      container.updateOverrides([
        cacheServiceProvider.overrideWithValue(
          _FakeCache(
            channels: [
              channel('c1', 'Alpha One', 'sports'),
              channel('c3', 'Charlie Three', 'news'),
            ],
            categories: [
              category('sports', 'Sports', 0),
              category('news', 'News', 1),
              category('movies', 'Movies', 2),
            ],
          ),
        ),
      ]);
      container.invalidate(channelsProvider);
      container.invalidate(categoriesProvider);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Movies'), findsNothing);
      // Selection fell back rather than pointing at a stale index.
      expect(container.read(selectedCategoryProvider), 'trending');
    });

    testWidgets('Favorite tab shows empty state when no favorites exist',
        (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Favorite'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('No bookmarks available'), findsOneWidget);
      expect(find.text('Explore channels'), findsOneWidget);
    });
  });
}
