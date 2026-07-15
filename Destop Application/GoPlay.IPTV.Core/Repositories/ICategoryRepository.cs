using System.Collections.Generic;
using System.Threading.Tasks;
using GoPlay.IPTV.Core.Models;

namespace GoPlay.IPTV.Core.Repositories
{
    /// <summary>
    /// Contract for Category data access.
    /// </summary>
    public interface ICategoryRepository
    {
        Task<IEnumerable<Category>> GetAllCategoriesAsync();
        Task SyncCategoriesAsync();
    }
}
