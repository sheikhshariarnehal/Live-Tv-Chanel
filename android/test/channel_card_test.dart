import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goplay/models/channel.dart';
import 'package:goplay/providers/app_providers.dart';
import 'package:goplay/widgets/cards/channel_card.dart';

/// Mirrors the sizing rule used by the channel grid so these tests exercise the
/// exact tile geometry the app produces.
({int columns, double width, double height}) tileFor(
  BuildContext context,
  double crossAxisExtent,
) {
  const spacing = 8.0;
  final int columns;
  if (crossAxisExtent >= 1180) {
    columns = 6;
  } else if (crossAxisExtent >= 880) {
    columns = 5;
  } else if (crossAxisExtent >= 580) {
    columns = 4;
  } else {
    columns = 3;
  }
  final width = (crossAxisExtent - spacing * (columns - 1)) / columns;
  final height = width > ChannelCard.measureHeight(context)
      ? width
      : ChannelCard.measureHeight(context);
  return (columns: columns, width: width, height: height);
}

Channel channelFrom(Map<String, dynamic> overrides) => Channel.fromJson({
      'id': 'c1',
      'name': 'Sky Sports Main Event',
      'stream_url': 'https://example.test/a.m3u8',
      ...overrides,
    });

Future<void> pumpCard(
  WidgetTester tester,
  Channel channel, {
  double screenWidth = 360,
  double textScale = 1.0,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(screenWidth, 800),
            textScaler: TextScaler.linear(textScale),
          ),
          child: Builder(
            builder: (context) {
              // 10dp grid edge inset on each side, as in _ResponsiveGrid.
              final tile = tileFor(context, screenWidth - 20);
              return Center(
                child: SizedBox(
                  width: tile.width,
                  height: tile.height,
                  child: ChannelCard(channel: channel),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('Channel model', () {
    test('blank names are normalised so initials never throw', () {
      // Regression: `''.substring(0, 1)` threw RangeError and took down the
      // whole category grid when a scraped row had an empty tvg-name.
      for (final raw in <Object?>['', '   ', null]) {
        final channel = channelFrom({'name': raw});
        expect(channel.name, 'Unknown Channel');
        expect(channel.initials, 'UN');
      }
    });

    test('initials handles a single-character name', () {
      expect(channelFrom({'name': 'A'}).initials, 'A');
    });

    test('initials on a directly constructed empty name degrades to "?"', () {
      final channel = Channel(id: 'x', name: '', streamUrl: '');
      expect(channel.initials, '?');
    });

    test('searchIndex covers name, category, country and language', () {
      final channel = channelFrom({
        'name': 'TNT Sports 1',
        'category': 'Sports',
        'country': 'United Kingdom',
        'language': 'English',
      });

      for (final query in ['tnt', 'sports', 'united kingdom', 'english']) {
        expect(channel.searchIndex.contains(query), isTrue, reason: query);
      }
      expect(channel.searchIndex.contains('bundesliga'), isFalse);
    });

    test('searchIndex is cached and never re-derived', () {
      final channel = channelFrom({});
      expect(channel.searchIndex, same(channel.searchIndex));
    });

    test('searchIndex does not match across field boundaries', () {
      final channel = channelFrom({'name': 'AB', 'category': 'CD'});
      expect(channel.searchIndex.contains('abcd'), isFalse);
    });

    test('blank quality falls back to HD instead of an empty badge', () {
      expect(channelFrom({'quality': '  '}).quality, 'HD');
      expect(channelFrom({'quality': '4K'}).quality, '4K');
    });

    test('a malformed row does not poison the rest of the list', () {
      // `id` is required; the cache decoder skips rows that throw.
      expect(() => Channel.fromJson({'name': 'no id'}), throwsA(anything));
    });
  });

  group('ChannelCard layout', () {
    // Regression: the card was a fixed 1.0 aspect ratio holding 54dp of avatar
    // plus two lines of text. It overflowed on 320dp-wide screens at the
    // default font size, and on every phone above ~1.15 text scale.
    for (final width in <double>[320, 360, 411, 600, 800, 1280]) {
      for (final scale in <double>[1.0, 1.15, 1.3]) {
        testWidgets('no overflow at ${width}dp width, ${scale}x text',
            (tester) async {
          await pumpCard(
            tester,
            channelFrom({'name': 'A Very Long Channel Name That Wraps Twice'}),
            screenWidth: width,
            textScale: scale,
          );
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('measureHeight grows with text scale', (tester) async {
      late double atOne;
      late double atLarge;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
            child: Builder(builder: (c) {
              atOne = ChannelCard.measureHeight(c);
              return const SizedBox();
            }),
          ),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: Builder(builder: (c) {
              atLarge = ChannelCard.measureHeight(c);
              return const SizedBox();
            }),
          ),
        ),
      );

      expect(atLarge, greaterThan(atOne));
    });

    testWidgets('renders name and quality badge', (tester) async {
      await pumpCard(tester, channelFrom({'quality': '4K'}));
      expect(find.text('Sky Sports Main Event'), findsOneWidget);
      expect(find.text('4K'), findsOneWidget);
    });
  });

  group('ChannelCard favorites', () {
    testWidgets('long press toggles the persisted favorite state',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final channel = channelFrom({});

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Center(
              child: SizedBox(
                width: 110,
                height: 130,
                child: ChannelCard(channel: channel),
              ),
            ),
          ),
        ),
      );

      // No affordance until favorited — the bookmark is a state indicator, not
      // a competing tap target on a ~100dp tile.
      expect(find.byIcon(Icons.bookmark_rounded), findsNothing);

      await tester.longPress(find.byType(ChannelCard));
      await tester.pump();

      expect(container.read(favoriteChannelIdsProvider), contains(channel.id));
      expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);

      await tester.longPress(find.byType(ChannelCard));
      await tester.pump();

      expect(
        container.read(favoriteChannelIdsProvider),
        isNot(contains(channel.id)),
      );
      expect(find.byIcon(Icons.bookmark_rounded), findsNothing);
    });

    testWidgets('cards are exposed to screen readers', (tester) async {
      // Regression: the grid was wrapped in ExcludeSemantics, which hid every
      // channel from TalkBack.
      final handle = tester.ensureSemantics();
      await pumpCard(tester, channelFrom({'quality': 'HD'}));

      expect(
        find.bySemanticsLabel(RegExp(r'Sky Sports Main Event')),
        findsOneWidget,
      );
      handle.dispose();
    });
  });
}
