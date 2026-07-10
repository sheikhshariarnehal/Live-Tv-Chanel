INSERT INTO channels (id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order)
VALUES
('uk-supersport-blitz-hd-oopstv', '┃UK┃ SUPERSPORT BLITZ HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTBLITZ.png', 'sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/cha-spo10/396873.m3u8', '{}'::jsonb, false, NULL, 151),
('uk-supersport-maximo-1-oopstv', '┃UK┃ SUPERSPORT MAXIMO 1', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTMAXIMO1.png', 'sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/cha-spo10/396872.m3u8', '{}'::jsonb, false, NULL, 152),
('uk-supersport-play-1-hd-oopstv', '┃UK┃ SUPERSPORT PLAY 1 HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/supersport.png', 'sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/cha-spo10/396871.m3u8', '{}'::jsonb, false, NULL, 153),
('uk-supersport-grandstand-hd-oopstv', '┃UK┃ SUPERSPORT GRANDSTAND HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTGRANDSTAND.png', 'sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/cha-spo10/396870.m3u8', '{}'::jsonb, false, NULL, 154),
('uk-supersport-psl-hd-oopstv', '┃UK┃ SUPERSPORT PSL HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/supersport.png', 'sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/cha-spo10/396869.m3u8', '{}'::jsonb, false, NULL, 155),
('uk-supersport-action-hd-oopstv', '┃UK┃ SUPERSPORT ACTION HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/supersport.png', 'sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/cha-spo10/396868.m3u8', '{}'::jsonb, false, NULL, 156)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  is_live = EXCLUDED.is_live,
  quality = EXCLUDED.quality,
  stream_url = EXCLUDED.stream_url,
  headers = EXCLUDED.headers,
  proxy = EXCLUDED.proxy,
  drm = EXCLUDED.drm,
  sort_order = EXCLUDED.sort_order;