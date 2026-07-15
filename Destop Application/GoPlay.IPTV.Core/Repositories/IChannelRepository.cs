using System.Collections.Generic;
using System.Threading.Tasks;
using GoPlay.IPTV.Core.Models;

namespace GoPlay.IPTV.Core.Repositories
{
    /// <summary>
    /// Contract for Channel data access.
    /// </summary>
    public interface IChannelRepository
    {
        Task<IEnumerable<Channel>> GetAllChannelsAsync();
        Task<Channel?> GetChannelByIdAsync(string id);
        Task<IEnumerable<Channel>> GetChannelsByCategoryAsync(string categoryId);
        Task<IEnumerable<Channel>> GetTrendingChannelsAsync();
        Task SyncChannelsAsync();
    }
}
