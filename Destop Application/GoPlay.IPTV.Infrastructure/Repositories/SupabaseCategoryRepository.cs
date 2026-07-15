using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using GoPlay.IPTV.Core.Models;
using GoPlay.IPTV.Core.Repositories;

namespace GoPlay.IPTV.Infrastructure.Repositories
{
    public class SupabaseCategoryRepository : ICategoryRepository
    {
        private readonly HttpClient _httpClient;
        private const string BaseUrl = "https://hqmhuvsjlykrdusfkmeg.supabase.co/rest/v1";

        public SupabaseCategoryRepository(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<IEnumerable<Category>> GetAllCategoriesAsync()
        {
            try
            {
                var response = await _httpClient.GetAsync($"{BaseUrl}/categories?select=*&order=sort_order.asc");
                response.EnsureSuccessStatusCode();
                var json = await response.Content.ReadAsStringAsync();
                
                var options = new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
                    PropertyNameCaseInsensitive = true
                };
                var categories = JsonSerializer.Deserialize<List<Category>>(json, options);
                return categories ?? new List<Category>();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error fetching categories: {ex.Message}");
                return new List<Category>();
            }
        }

        public Task SyncCategoriesAsync() => Task.CompletedTask;
    }
}
