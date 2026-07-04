-- ============================================================
-- Insert FIFA 2026 Live channel (scraped from FifaLive.click)
-- Run this in the Supabase SQL Editor (SQL bypasses RLS).
-- ============================================================

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fifa-2026-live-fhd',
    'FIFA 2026 Live',
    NULL,
    'Sports',
    true,
    'FHD',
    'https://prod-cdn01-live.toffeelive.com/live/FIFA-2026/sst/0/master_1750.m3u8?hdntl=Expires=1782900632~_GO=Generated~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=AeQsclBR_RMMixQ_bjbHn-R4b8WwE0LlFdwYKOrlIXmxXxuEfhqDewLDbhJnPtZG2fnCuCcwCqPQM1vMe1J3E0N4h0AG',
    '{"Referer": "https://fifalive.click/", "Origin": "https://fifalive.click"}'::jsonb,
    true,
    NULL
) ON CONFLICT (id) DO UPDATE SET
    stream_url = EXCLUDED.stream_url,
    headers    = EXCLUDED.headers,
    quality    = EXCLUDED.quality,
    is_live    = true;

-- Bump the channels version so the app picks up the change.
UPDATE app_settings
SET channels_version = channels_version + 1,
    updated_at = now()
WHERE id = 1;
