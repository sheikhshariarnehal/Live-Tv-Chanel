using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using GoPlay.IPTV.Core.Models;
using GoPlay.IPTV.Core.Repositories;

namespace GoPlay.IPTV.Infrastructure.Repositories
{
    public class SupabaseChannelRepository : IChannelRepository
    {
        private readonly HttpClient _httpClient;
        private const string BaseUrl = "https://hqmhuvsjlykrdusfkmeg.supabase.co/rest/v1";

        public SupabaseChannelRepository(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<IEnumerable<Channel>> GetAllChannelsAsync()
        {
            try
            {
                var response = await _httpClient.GetAsync($"{BaseUrl}/channels?select=*&order=sort_order.asc");
                response.EnsureSuccessStatusCode();
                var json = await response.Content.ReadAsStringAsync();
                
                var options = new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
                    PropertyNameCaseInsensitive = true
                };
                var channels = JsonSerializer.Deserialize<List<Channel>>(json, options);
                return channels ?? new List<Channel>();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error fetching channels: {ex.Message}");
                return new List<Channel>();
            }
        }

        public async Task<Channel?> GetChannelByIdAsync(string id)
        {
            try
            {
                var response = await _httpClient.GetAsync($"{BaseUrl}/channels?id=eq.{id}&select=*");
                response.EnsureSuccessStatusCode();
                var json = await response.Content.ReadAsStringAsync();
                
                var options = new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
                    PropertyNameCaseInsensitive = true
                };
                var channels = JsonSerializer.Deserialize<List<Channel>>(json, options);
                return channels != null && channels.Count > 0 ? channels[0] : null;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error fetching channel by id: {ex.Message}");
                return null;
            }
        }

        public async Task<IEnumerable<Channel>> GetChannelsByCategoryAsync(string categoryId)
        {
            try
            {
                var response = await _httpClient.GetAsync($"{BaseUrl}/channels?category=eq.{Uri.EscapeDataString(categoryId)}&select=*&order=sort_order.asc");
                response.EnsureSuccessStatusCode();
                var json = await response.Content.ReadAsStringAsync();
                
                var options = new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
                    PropertyNameCaseInsensitive = true
                };
                var channels = JsonSerializer.Deserialize<List<Channel>>(json, options);
                return channels ?? new List<Channel>();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error fetching channels by category: {ex.Message}");
                return new List<Channel>();
            }
        }

        public async Task<IEnumerable<Channel>> GetTrendingChannelsAsync()
        {
            try
            {
                var response = await _httpClient.GetAsync($"{BaseUrl}/channels?is_trending=eq.true&select=*&order=sort_order.asc");
                response.EnsureSuccessStatusCode();
                var json = await response.Content.ReadAsStringAsync();
                
                var options = new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
                    PropertyNameCaseInsensitive = true
                };
                var channels = JsonSerializer.Deserialize<List<Channel>>(json, options);
                return channels ?? new List<Channel>();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error fetching trending channels: {ex.Message}");
                return new List<Channel>();
            }
        }

        public Task SyncChannelsAsync() => Task.CompletedTask;
    }
}
