using System;
using System.Collections.Generic;

namespace GoPlay.IPTV.Core.Models
{
    /// <summary>
    /// Represents DRM settings for a DRM-protected video stream.
    /// </summary>
    public class DrmConfig
    {
        public string Type { get; set; } = string.Empty; // e.g., clearkey, widevine
        public string? Kid { get; set; }
        public string? Key { get; set; }
        public string? LicenseUrl { get; set; }
        public Dictionary<string, string> Headers { get; set; } = new();
        public Dictionary<string, string> ClearKeys { get; set; } = new();

        public bool IsClearKey => "clearkey".Equals(Type, StringComparison.OrdinalIgnoreCase);
        public bool IsWidevine => "widevine".Equals(Type, StringComparison.OrdinalIgnoreCase);
    }
}
