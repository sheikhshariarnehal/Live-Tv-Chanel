using System;

namespace GoPlay.IPTV.Core.Models
{
    /// <summary>
    /// Represents a channel category domain entity.
    /// </summary>
    public class Category
    {
        public string Id { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string? Icon { get; set; }
        public bool Active { get; set; } = true;
        public string? IconUrl { get; set; }
        public int SortOrder { get; set; } = 0;
    }
}
