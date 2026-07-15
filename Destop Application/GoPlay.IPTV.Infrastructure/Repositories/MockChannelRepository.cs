using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using GoPlay.IPTV.Core.Models;
using GoPlay.IPTV.Core.Repositories;

namespace GoPlay.IPTV.Infrastructure.Repositories
{
    public class MockChannelRepository : IChannelRepository
    {
        private readonly List<Channel> _channels;

        public MockChannelRepository()
        {
            _channels = new List<Channel>
            {
                new Channel
                {
                    Id = "1",
                    Name = "Big Buck Bunny (HLS)",
                    Logo = "https://upload.wikimedia.org/wikipedia/commons/c/c5/Big_Buck_Bunny_堅毅的兵哥.png",
                    Category = "Movies",
                    Country = "US",
                    Language = "English",
                    StreamUrl = "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
                    IsLive = false,
                    IsTrending = true,
                    Quality = "FHD",
                    SortOrder = 1
                },
                new Channel
                {
                    Id = "2",
                    Name = "Sintel (HLS)",
                    Logo = "https://upload.wikimedia.org/wikipedia/commons/d/dc/Sintel_poster_v2.jpg",
                    Category = "Movies",
                    Country = "NL",
                    Language = "Dutch",
                    StreamUrl = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
                    IsLive = false,
                    IsTrending = true,
                    Quality = "FHD",
                    SortOrder = 2
                },
                new Channel
                {
                    Id = "3",
                    Name = "Tears of Steel (HLS)",
                    Logo = "https://upload.wikimedia.org/wikipedia/commons/6/6f/Tears_of_Steel_poster.jpg",
                    Category = "Sci-Fi",
                    Country = "NL",
                    Language = "English",
                    StreamUrl = "https://demo.unified-streaming.com/kaltura/the-daily-show.isml/.m3u8",
                    IsLive = false,
                    IsTrending = false,
                    Quality = "HD",
                    SortOrder = 3
                },
                new Channel
                {
                    Id = "4",
                    Name = "Akamai Test Stream",
                    Logo = "https://www.akamai.com/content/dam/site/en/images/logo/akamai-logo.svg",
                    Category = "Test",
                    Country = "US",
                    Language = "English",
                    StreamUrl = "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f081829.m3u8",
                    IsLive = true,
                    IsTrending = false,
                    Quality = "HD",
                    SortOrder = 4
                }
            };
        }

        public Task<IEnumerable<Channel>> GetAllChannelsAsync()
        {
            return Task.FromResult<IEnumerable<Channel>>(_channels);
        }

        public Task<Channel?> GetChannelByIdAsync(string id)
        {
            var channel = _channels.FirstOrDefault(c => c.Id == id);
            return Task.FromResult(channel);
        }

        public Task<IEnumerable<Channel>> GetChannelsByCategoryAsync(string categoryId)
        {
            var channels = _channels.Where(c => c.Category != null && c.Category.Equals(categoryId, StringComparison.OrdinalIgnoreCase));
            return Task.FromResult(channels);
        }

        public Task<IEnumerable<Channel>> GetTrendingChannelsAsync()
        {
            var channels = _channels.Where(c => c.IsTrending);
            return Task.FromResult(channels);
        }

        public Task SyncChannelsAsync()
        {
            return Task.CompletedTask;
        }
    }
}
