using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using GoPlay.IPTV.Core.Models;
using GoPlay.IPTV.Core.Repositories;

namespace GoPlay.IPTV.Infrastructure.Repositories
{
    public class MockCategoryRepository : ICategoryRepository
    {
        private readonly List<Category> _categories;

        public MockCategoryRepository()
        {
            _categories = new List<Category>
            {
                new Category { Id = "Movies", Name = "Movies", SortOrder = 1, Active = true },
                new Category { Id = "Sci-Fi", Name = "Sci-Fi", SortOrder = 2, Active = true },
                new Category { Id = "Test", Name = "Test Streams", SortOrder = 3, Active = true }
            };
        }

        public Task<IEnumerable<Category>> GetAllCategoriesAsync()
        {
            return Task.FromResult<IEnumerable<Category>>(_categories);
        }

        public Task SyncCategoriesAsync()
        {
            return Task.CompletedTask;
        }
    }
}
