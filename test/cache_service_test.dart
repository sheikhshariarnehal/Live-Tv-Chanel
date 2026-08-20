import 'package:flutter_test/flutter_test.dart';
import 'package:goplay/models/category.dart';
import 'package:goplay/models/channel.dart';
import 'package:goplay/services/cache_service.dart';

// No Hive is initialised here on purpose: `_boxOrNull` must degrade to null
// rather than throw, which also makes these tests exercise the memo in
// isolation from storage.
void main() {
  Channel channelOf(String id) =>
      Channel(id: id, name: 'Channel $id', streamUrl: 'https://x.test/$id');

  group('CacheService without an open box', () {
    test('reads degrade to empty instead of throwing', () {
      final cache = CacheService();
      expect(cache.getLocalChannels(), isEmpty);
      expect(cache.getLocalCategories(), isEmpty);
      expect(cache.getLocalEvents(), isEmpty);
      expect(cache.getLocalAnnouncements(), isEmpty);
      expect(cache.getFavoriteChannelIds(), isEmpty);
      expect(cache.getLocalChannelsVersion(), isNull);
      expect(cache.getLocalEventsVersion(), isNull);
    });

    test('writes do not throw', () async {
      final cache = CacheService();
      await expectLater(
        cache.saveLocalChannels([channelOf('a')]),
        completes,
      );
      await expectLater(cache.clearAllCache(), completes);
    });
  });

  group('CacheService memoization', () {
    test('repeated reads return the identical decoded list', () {
      final cache = CacheService();
      expect(cache.getLocalChannels(), same(cache.getLocalChannels()));
    });

    test('saving channels primes the memo with the caller objects', () async {
      // Regression: the memo used to be cleared on save, so SyncService wrote
      // fresh channels and then immediately forced a full re-decode of ~15k
      // rows on the main thread.
      final cache = CacheService();
      final channels = [channelOf('a'), channelOf('b')];

      await cache.saveLocalChannels(channels);

      final read = cache.getLocalChannels();
      expect(read, hasLength(2));
      expect(read.first, same(channels.first));
      expect(read.last, same(channels.last));
    });

    test('saving categories primes the memo', () async {
      final cache = CacheService();
      final categories = [const Category(id: 'sports', name: 'Sports')];

      await cache.saveLocalCategories(categories);

      expect(cache.getLocalCategories().single, same(categories.single));
    });

    test('favorites round-trip through the memo', () async {
      final cache = CacheService();
      await cache.saveFavoriteChannelIds({'a', 'b'});
      expect(cache.getFavoriteChannelIds(), {'a', 'b'});
    });

    test('clearAllCache drops every memo', () async {
      final cache = CacheService();
      await cache.saveLocalChannels([channelOf('a')]);
      expect(cache.getLocalChannels(), hasLength(1));

      await cache.clearAllCache();

      expect(cache.getLocalChannels(), isEmpty);
      expect(cache.getLocalCategories(), isEmpty);
    });
  });
}
