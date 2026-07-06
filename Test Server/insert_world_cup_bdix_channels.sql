-- SQL Script to insert/upsert World Cup (BDIX) channels and playlist
INSERT INTO public.categories (id, name, sort_order) 
VALUES ('world-cup-bdix', 'World Cup (BDIX)', 10) 
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO public.channels (id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm)
VALUES
('btv-bdix-fifa', 'BTV', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/BTV/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('t-sports-1080p-bdix-fifa', 'T Sports 1080p', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/T-Sports-HD/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('t-sports-bdix-bdix-fifa', 'T Sports BDIX', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/T-Sports-BDIX/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('a-sports-bdix-bdix-fifa', 'A Sports BDIX', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/A-sports-BDIX/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('bein-sports-bdix-fifa', 'BEIN SPORTS', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/BEIN-SPORTS/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('ptv-bdix-fifa', 'PTV', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/PTV/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('ptv-bdix-bdix-fifa', 'PTV BDIX', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/PTV-BDIX/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('somoy-tv-bdix-fifa', 'Somoy TV', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/SOMOY-TV/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('sony-sports-1-bdix-fifa', 'Sony Sports 1', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Sony-sports-1/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('sony-sports-2-bdix-fifa', 'Sony Sports 2', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Sony-sports-2/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('sony-sports-3-bdix-fifa', 'Sony Sports 3', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Sony-sports-3/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-select-1-bdix-fifa', 'Star Select 1', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Star-select-1/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-select-3-bdix-fifa', 'Star Select 3', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Star-select-3/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-sports-1-bdix-fifa', 'Star Sports 1', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Star-sports-1/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-sports-2-bdix-fifa', 'Star Sports 2', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Star-sports-2/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('unite8-sports-1-1080p-bdix-fifa', 'Unite8 Sports 1 1080p', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Unite8-sports-2/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('caze-tv-1080p-bdix-fifa', 'Caze Tv 1080p', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/CazeTv1080p/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('caze-tv-720p-bdix-fifa', 'Caze Tv 720p', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/caze-tv-720p/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('colors-bangla-bdix-fifa', 'Colors Bangla', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Colours-bangla/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('jalsha-movies-bdix-fifa', 'Jalsha Movies', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Jalsha-Movies/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('sony-aath-bdix-fifa', 'Sony Aath', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Sony-8/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-jalsha-bdix-fifa', 'Star Jalsha', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Star-Jalsha/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('zee-bangla-bdix-fifa', 'ZEE Bangla', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/ZEE-Bangla/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('zee-cinema-bdix-fifa', 'Zee Cinema', NULL, 'world-cup-bdix', true, 'HD', 'http://103.114.11.37:8081/Z-Cinema/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  stream_url = EXCLUDED.stream_url,
  headers = EXCLUDED.headers,
  proxy = EXCLUDED.proxy,
  drm = EXCLUDED.drm;

INSERT INTO public.playlists (id, name, channels) 
VALUES ('world-cup-bdix', 'World Cup (BDIX)', ARRAY['btv-bdix-fifa', 't-sports-1080p-bdix-fifa', 't-sports-bdix-bdix-fifa', 'a-sports-bdix-bdix-fifa', 'bein-sports-bdix-fifa', 'ptv-bdix-fifa', 'ptv-bdix-bdix-fifa', 'somoy-tv-bdix-fifa', 'sony-sports-1-bdix-fifa', 'sony-sports-2-bdix-fifa', 'sony-sports-3-bdix-fifa', 'star-select-1-bdix-fifa', 'star-select-3-bdix-fifa', 'star-sports-1-bdix-fifa', 'star-sports-2-bdix-fifa', 'unite8-sports-1-1080p-bdix-fifa', 'caze-tv-1080p-bdix-fifa', 'caze-tv-720p-bdix-fifa', 'colors-bangla-bdix-fifa', 'jalsha-movies-bdix-fifa', 'sony-aath-bdix-fifa', 'star-jalsha-bdix-fifa', 'zee-bangla-bdix-fifa', 'zee-cinema-bdix-fifa']) 
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, channels = EXCLUDED.channels;

UPDATE app_settings SET channels_version = channels_version + 1, updated_at = now() WHERE id = 1;
