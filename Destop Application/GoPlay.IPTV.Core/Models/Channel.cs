using System;
using System.Collections.Generic;

namespace GoPlay.IPTV.Core.Models
{
    /// <summary>
    /// Represents a TV channel domain entity.
    /// </summary>
    public class Channel
    {
        public string Id { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string? Logo { get; set; }
        public string? Category { get; set; }
        public string? Country { get; set; }
        public string? Language { get; set; }
        public string StreamUrl { get; set; } = string.Empty;
        public bool IsLive { get; set; } = true;
        public bool IsTrending { get; set; } = false;
        public string Quality { get; set; } = "HD";
        public Dictionary<string, string> Headers { get; set; } = new();
        public int SortOrder { get; set; } = 0;
        public DateTime AddedAt { get; set; } = DateTime.UtcNow;
        public bool Proxy { get; set; } = false;
        public DrmConfig? Drm { get; set; }

        public bool HasDrm => Drm != null;
    }
}
