-- SQL Script to insert/upsert BDIX-FIFA World CUP channels
INSERT INTO public.categories (id, name, sort_order) 
VALUES ('bdix-fifa-world-cup', 'BDIX-FIFA World CUP', 10) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.channels (id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm)
VALUES
('btv-bdix-fifa', 'BTV', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/BTV/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('t-sports-1080p-bdix-fifa', 'T Sports 1080p', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/T-Sports-HD/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('t-sports-bdix-bdix-fifa', 'T Sports BDIX', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/T-Sports-BDIX/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('a-sports-bdix-bdix-fifa', 'A Sports BDIX', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/A-sports-BDIX/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('bein-sports-bdix-fifa', 'BEIN SPORTS', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/BEIN-SPORTS/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('ptv-bdix-fifa', 'PTV', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/PTV/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('ptv-bdix-bdix-fifa', 'PTV BDIX', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/PTV-BDIX/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('somoy-tv-bdix-fifa', 'Somoy TV', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/SOMOY-TV/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('sony-sports-1-bdix-fifa', 'Sony Sports 1', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Sony-sports-1/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('sony-sports-2-bdix-fifa', 'Sony Sports 2', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Sony-sports-2/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('sony-sports-3-bdix-fifa', 'Sony Sports 3', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Sony-sports-3/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-select-1-bdix-fifa', 'Star Select 1', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Star-select-1/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-select-3-bdix-fifa', 'Star Select 3', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Star-select-3/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-sports-1-bdix-fifa', 'Star Sports 1', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Star-sports-1/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-sports-2-bdix-fifa', 'Star Sports 2', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Star-sports-2/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('unite8-sports-1-1080p-bdix-fifa', 'Unite8 Sports 1 1080p', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Unite8-sports-2/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('caze-tv-1080p-bdix-fifa', 'Caze Tv 1080p', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/CazeTv1080p/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('caze-tv-720p-bdix-fifa', 'Caze Tv 720p', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/caze-tv-720p/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('colors-bangla-bdix-fifa', 'Colors Bangla', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Colours-bangla/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('jalsha-movies-bdix-fifa', 'Jalsha Movies', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Jalsha-Movies/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('sony-aath-bdix-fifa', 'Sony Aath', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Sony-8/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('star-jalsha-bdix-fifa', 'Star Jalsha', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Star-Jalsha/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('zee-bangla-bdix-fifa', 'ZEE Bangla', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/ZEE-Bangla/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb),
('zee-cinema-bdix-fifa', 'Zee Cinema', NULL, 'bdix-fifa-world-cup', true, 'HD', 'http://103.114.11.37:8081/Z-Cinema/video.m3u8?token=iK4pAMF8tQ', '{}'::jsonb, true, NULL::jsonb)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  stream_url = EXCLUDED.stream_url,
  headers = EXCLUDED.headers,
  proxy = EXCLUDED.proxy,
  drm = EXCLUDED.drm;

UPDATE app_settings SET channels_version = channels_version + 1, updated_at = now() WHERE id = 1;
