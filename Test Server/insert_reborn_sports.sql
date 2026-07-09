-- Reborn Sports categories and channels import SQL

-- 1. Categories Insertion
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-world-cricket', 'Reborn WORLD CRICKET', NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-asia-sports', 'Reborn ┃ASIA┃ SPORTS', NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-pk-sports', 'Reborn ┃PK┃ SPORTS', NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-ca-fr-sports', 'Reborn ┃CA FR┃ SPORTS', NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-ar-bein-sports-hd', 'Reborn ┃AR┃ BEIN SPORTS HD', NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-ar-tod-sport', 'Reborn ┃AR┃ TOD SPORT', NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-ro-canale-sport', 'Reborn ┃RO┃ CANALE SPORT', NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-pl-polsat-sport', 'Reborn ┃PL┃ POLSAT SPORT', NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-pl-eleven-sports', 'Reborn ┃PL┃ ELEVEN SPORTS', NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-hr-arena-sport', 'Reborn ┃HR┃ ARENA SPORT', NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-hr-sport-klub', 'Reborn ┃HR┃ SPORT KLUB', NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-tr-s-sports', 'Reborn ┃TR┃ S SPORTS', NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-tr-bein-sports-fhd', 'Reborn ┃TR┃ BEIN SPORTS FHD', NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-pt-sport-tv', 'Reborn ┃PT┃ SPORT TV', NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-it-my-sports', 'Reborn ┃IT┃ MY SPORTS', NULL, 31
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-it-sky-calcio', 'Reborn ┃IT┃ SKY CALCIO', NULL, 32
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-it-sky-sport', 'Reborn ┃IT┃ SKY SPORT', NULL, 33
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-it-sport', 'Reborn ┃IT┃ SPORT', NULL, 34
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-cy-sport', 'Reborn ┃CY┃ SPORT', NULL, 35
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-gr-cosmote-sports', 'Reborn ┃GR┃ COSMOTE SPORTS', NULL, 36
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-gr-nova-sports', 'Reborn ┃GR┃ NOVA SPORTS', NULL, 37
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-al-digitalb-supersport', 'Reborn ┃AL┃ DIGITALB SUPERSPORT', NULL, 38
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-at-sport', 'Reborn ┃AT┃ SPORT', NULL, 39
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-uk-sport', 'Reborn ┃UK┃ SPORT', NULL, 40
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-fr-bein-sports', 'Reborn ┃FR┃ BEIN SPORTS', NULL, 41
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-uk-bein-sports', 'Reborn ┃UK┃ BEIN SPORTS', NULL, 42
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-uk-supersport', 'Reborn ┃UK┃ SUPERSPORT', NULL, 43
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-uk-tnt-sports-hd', 'Reborn ┃UK┃ TNT SPORTS HD', NULL, 44
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-de-sky-sport-hd', 'Reborn ┃DE┃ SKY SPORT HD', NULL, 45
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-de-sport', 'Reborn ┃DE┃ SPORT', NULL, 46
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-nl-max-sport', 'Reborn ┃NL┃ MAX SPORT', NULL, 47
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-nl-sport-tv', 'Reborn ┃NL┃ SPORT TV+', NULL, 48
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-nl-ziggo-kabel', 'Reborn ┃NL┃ ZIGGO KABEL', NULL, 49
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;
INSERT INTO categories (id, name, icon, sort_order) VALUES (
    'reborn-de-fussballtv-fifa-wm-2026', 'Reborn ┃DE┃ FUSSBALL.TV FIFA WM 2026', NULL, 50
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;

-- 2. Channels Insertion
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-astro-cricket-hd-reborn', '┃WC┃ ASTRO CRICKET HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809382.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-star-sports-1-hd-reborn', '┃WC┃ STAR SPORTS 1 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809383.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-star-sports-2-hd-reborn', '┃WC┃ STAR SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809384.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-sports-18-hd-reborn', '┃WC┃ SPORTS 18 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809385.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-willow-cricket-hd-reborn', '┃WC┃ WILLOW CRICKET HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809386.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-willow-cricket-extra-hd-reborn', '┃WC┃ WILLOW CRICKET EXTRA HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809387.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-atn-sports-hd-reborn', '┃WC┃ ATN SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809388.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-fox-cricket-hd-reborn', '┃WC┃ FOX CRICKET HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809389.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-sky-sports-cricket-hd-reborn', '┃WC┃ SKY SPORTS CRICKET HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809390.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-sky-sport-1-hd-reborn', '┃WC┃ SKY SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809392.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-sky-sport-2-hd-reborn', '┃WC┃ SKY SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809393.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-sky-sport-3-hd-reborn', '┃WC┃ SKY SPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809394.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-sky-sport-4-hd-reborn', '┃WC┃ SKY SPORT 4 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809395.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-super-sports-cricket-hd-reborn', '┃WC┃ SUPER SPORTS CRICKET HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809391.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-ten-sports-hd-reborn', '┃WC┃ TEN SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809396.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-a-sports-hd-reborn', '┃WC┃ A SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809397.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-ptv-sports-hd-reborn', '┃WC┃ PTV SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809398.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-geo-super-hd-reborn', '┃WC┃ GEO SUPER HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809399.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-starzplay-crlife-1-hd-reborn', '┃WC┃ STARZPLAY CRLIFE 1 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809400.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-starzplay-crlife-2-hd-reborn', '┃WC┃ STARZPLAY CRLIFE 2 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809401.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-starzplay-criiiclife-max-hd-reborn', '┃WC┃ STARZPLAY CRIIICLIFE MAX HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809402.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-hub-sports-3-hd-reborn', '┃WC┃ HUB SPORTS 3 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809403.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-flow-sports-hd-reborn', '┃WC┃ FLOW SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809404.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-rush-sports-hd-reborn', '┃WC┃ RUSH SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809405.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-rush-sports-2-hd-reborn', '┃WC┃ RUSH SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809406.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-sportsmax-hd-reborn', '┃WC┃ SPORTSMAX HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809407.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-sportsmax-2-hd-reborn', '┃WC┃ SPORTSMAX 2 HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809408.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-sportsmax-cricket-hd-reborn', '┃WC┃ SPORTSMAX CRICKET HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809409.m3u8', '{}'::jsonb, true, NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-jio-cricket-english-hd-reborn', '┃WC┃ JIO CRICKET ENGLISH HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809411.m3u8', '{}'::jsonb, true, NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'wc-cricket-gold-hd-reborn', '┃WC┃ CRICKET GOLD HD', 'http://picon.tivi-ott.net:25461/picon/MIX/Live%20Cricket%20TV.png', 'reborn-world-cricket', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/809410.m3u8', '{}'::jsonb, true, NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-d-sports-hd-reborn', '┃SPORTS┃ D SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/DSports.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373209.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-star-sports-first-reborn', '┃SPORTS┃ STAR SPORTS FIRST', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/Star_Sports_First.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373207.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-star-sports-1-hd-english-reborn', '┃SPORTS┃ STAR SPORTS 1 HD ENGLISH', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/starsports1.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373206.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-star-sports-1-hd-hindi-reborn', '┃SPORTS┃ STAR SPORTS 1 HD HINDI', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/starsports1.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373205.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-star-sports-2-hd-reborn', '┃SPORTS┃ STAR SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/STAR%20Sports%202%20logo.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373204.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-star-sports-3-reborn', '┃SPORTS┃ STAR SPORTS 3', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/StarSports3.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373203.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-star-sports-select-1-hd-reborn', '┃SPORTS┃ STAR SPORTS SELECT 1 HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/Star-sports-select-1.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373202.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-star-sports-select-2-hd-reborn', '┃SPORTS┃ STAR SPORTS SELECT 2 HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/Star-sport-select-2.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373201.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-sony-ten-sports-1-hd-reborn', '┃SPORTS┃ SONY TEN SPORTS 1 HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/TEN_1_HD_1.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373200.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-sony-ten-sports-2-hd-reborn', '┃SPORTS┃ SONY TEN SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/Tensports-New-Logo-1-2.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373199.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-sony-ten-sports-3-hd-reborn', '┃SPORTS┃ SONY TEN SPORTS 3 HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/Tensports-New-Logo-1-2.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373198.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-willow-cricket-hd-reborn', '┃SPORTS┃ WILLOW CRICKET HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/willowcricket.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373197.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-sony-ten-sports-5-hd-reborn', '┃SPORTS┃ SONY TEN SPORTS 5 HD', 'http://picon.tivi-ott.net:25461/picon/INDIA/ddsport.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373196.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-star-sports-tamil-reborn', '┃SPORTS┃ STAR SPORTS TAMIL', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/STAR SPORTS TAMIL.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373195.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-eurosports-hd-reborn', '┃SPORTS┃ EUROSPORTS HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/sports18.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373194.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'sports-sports-18-english-reborn', '┃SPORTS┃ SPORTS 18 ENGLISH', 'http://picon.tivi-ott.net:25461/picon/ASIA/SPORTS/SPORTS 18 ENGLISH.png', 'reborn-asia-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373193.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-a-sports-fhd-reborn', '┃PK┃ A SPORTS FHD', 'http://picon.tivi-ott.net:25461/picon/PAKISTAN/SPORTS/A SPORTS.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/911320.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-a-sports-hd-reborn', '┃PK┃ A SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/PAKISTAN/SPORTS/A SPORTS.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/911321.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-a-sports-reborn', '┃PK┃ A SPORTS', 'http://picon.tivi-ott.net:25461/picon/PAKISTAN/SPORTS/A SPORTS.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/911322.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-ptv-sports-hd-reborn', '┃PK┃ PTV SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/PAKISTAN/SPORTS/PTV SPORTS.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/911324.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-ptv-sports-reborn', '┃PK┃ PTV SPORTS', 'http://picon.tivi-ott.net:25461/picon/PAKISTAN/SPORTS/PTV SPORTS.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/911325.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-ten-sports-fhd-reborn', '┃PK┃ TEN SPORTS FHD', 'http://picon.tivi-ott.net:25461/picon/PAKISTAN/SPORTS/TEN SPORTS.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/911326.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-ten-sports-hd-reborn', '┃PK┃ TEN SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/PAKISTAN/tensports.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373119.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-ten-sports-reborn', '┃PK┃ TEN SPORTS', 'http://picon.tivi-ott.net:25461/picon/PAKISTAN/SPORTS/TEN SPORTS.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/911327.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-geo-super-hd-reborn', '┃PK┃ GEO SUPER HD', 'http://picon.tivi-ott.net:25461/picon/ASIA/PAKISTAN/geosuper.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/373118.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pk-fast-sports-reborn', '┃PK┃ FAST SPORTS', 'http://picon.tivi-ott.net:25461/picon/PAKISTAN/SPORTS/FAST SPORTS.png', 'reborn-pk-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/911323.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-tsn-1-reborn', '┃CA FR┃ TSN 1', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/TSN 1.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902070.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-tsn-2-reborn', '┃CA FR┃ TSN 2', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/TSN 2.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902071.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-tsn-3-reborn', '┃CA FR┃ TSN 3', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/TSN 3.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902072.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-tsn-4-reborn', '┃CA FR┃ TSN 4', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/TSN 4.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902073.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-tsn-5-reborn', '┃CA FR┃ TSN 5', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/TSN 5.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902074.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-tva-sports-fhd-reborn', '┃CA FR┃ TVA SPORTS FHD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/TVA SPORTS FHD.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902076.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-tva-sports-hd-reborn', '┃CA FR┃ TVA SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/TVA SPORTS FHD.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902077.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-tva-sports-2-hd-reborn', '┃CA FR┃ TVA SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/TVA SPORTS 2 HD.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902075.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-world-hd-reborn', '┃CA FR┃ SPORTSNET WORLD HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902084.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-world-extra-1-reborn', '┃CA FR┃ SPORTSNET WORLD EXTRA 1', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902087.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-world-extra-2-reborn', '┃CA FR┃ SPORTSNET WORLD EXTRA 2', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902088.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-world-extra-3-reborn', '┃CA FR┃ SPORTSNET WORLD EXTRA 3', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902089.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-world-extra-4-reborn', '┃CA FR┃ SPORTSNET WORLD EXTRA 4', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902090.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportssnet-one-fhd-reborn', '┃CA FR┃ SPORTSSNET ONE FHD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET ONE FHD.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902080.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-east-fhd-reborn', '┃CA FR┃ SPORTSNET EAST FHD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902079.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-west-fhd-reborn', '┃CA FR┃ SPORTSNET WEST FHD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902083.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-360-fhd-reborn', '┃CA FR┃ SPORTSNET 360 FHD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902078.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-ontario-fhd-reborn', '┃CA FR┃ SPORTSNET ONTARIO FHD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902081.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-pacific-fhd-reborn', '┃CA FR┃ SPORTSNET PACIFIC FHD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902082.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-wwe-hd-reborn', '┃CA FR┃ SPORTSNET WWE HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSSNET WW.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902085.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-sportsnet-ppv-reborn', '┃CA FR┃ SPORTSNET PPV', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/SPORTSNET WO.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902086.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-euro-world-sport-reborn', '┃CA FR┃ EURO WORLD SPORT', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/EURO WORLD SPORTS.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902091.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-nfl-network-reborn', '┃CA FR┃ NFL NETWORK', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/NFL NETWORK.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902093.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ca-fr-nba-tv-reborn', '┃CA FR┃ NBA TV', 'http://picon.tivi-ott.net:25461/picon/CANADA/CA FR/SPORTS/NBA TV.png', 'reborn-ca-fr-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/902092.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-news-hd-s2-reborn', '┃AR┃ BEIN SPORTS NEWS HD S2', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS NEWS.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985171.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-global-hd-s2-reborn', '┃AR┃ BEIN SPORTS GLOBAL HD S2', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS GLOBAL.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985170.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-1-hd-s1-reborn', '┃AR┃ BEIN SPORTS 1 HD S1', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242255.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-1-hd-s3-reborn', '┃AR┃ BEIN SPORTS 1 HD S3', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985161.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-2-hd-s1-reborn', '┃AR┃ BEIN SPORTS 2 HD S1', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242254.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-2-hd-s3-reborn', '┃AR┃ BEIN SPORTS 2 HD S3', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985162.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-3-hd-s1-reborn', '┃AR┃ BEIN SPORTS 3 HD S1', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 3.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242253.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-3-hd-s3-reborn', '┃AR┃ BEIN SPORTS 3 HD S3', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 3.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985163.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-4-hd-s1-reborn', '┃AR┃ BEIN SPORTS 4 HD S1', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 4.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242252.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-4-hd-s3-reborn', '┃AR┃ BEIN SPORTS 4 HD S3', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 4.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985164.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-5-hd-s1-reborn', '┃AR┃ BEIN SPORTS 5 HD S1', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 5.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242251.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-5-hd-s3-reborn', '┃AR┃ BEIN SPORTS 5 HD S3', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 5.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985165.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-6-hd-s1-reborn', '┃AR┃ BEIN SPORTS 6 HD S1', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 6.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242250.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-6-hd-s3-reborn', '┃AR┃ BEIN SPORTS 6 HD S3', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 6.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985166.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-7-hd-s1-reborn', '┃AR┃ BEIN SPORTS 7 HD S1', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 7.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242249.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-7-hd-s3-reborn', '┃AR┃ BEIN SPORTS 7 HD S3', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 7.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985167.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-8-hd-s1-reborn', '┃AR┃ BEIN SPORTS 8 HD S1', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 8.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242248.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-8-hd-s3-reborn', '┃AR┃ BEIN SPORTS 8 HD S3', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 8.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985168.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-9-hd-s1-reborn', '┃AR┃ BEIN SPORTS 9 HD S1', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 9.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242247.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-bein-sports-9-hd-s3-reborn', '┃AR┃ BEIN SPORTS 9 HD S3', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/BEIN SPORTS/BEIN SPORTS 9.png', 'reborn-ar-bein-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/985169.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-1-reborn', '┃AR┃ TOD BEIN EVENT 1', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744949.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-2-reborn', '┃AR┃ TOD BEIN EVENT 2', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744950.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-3-reborn', '┃AR┃ TOD BEIN EVENT 3', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744951.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-4-reborn', '┃AR┃ TOD BEIN EVENT 4', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744952.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-5-reborn', '┃AR┃ TOD BEIN EVENT 5', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744953.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-6-reborn', '┃AR┃ TOD BEIN EVENT 6', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744954.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-7-reborn', '┃AR┃ TOD BEIN EVENT 7', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744955.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-8-reborn', '┃AR┃ TOD BEIN EVENT 8', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744956.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-9-reborn', '┃AR┃ TOD BEIN EVENT 9', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744957.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-10-reborn', '┃AR┃ TOD BEIN EVENT 10', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744958.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-11-reborn', '┃AR┃ TOD BEIN EVENT 11', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744959.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-12-reborn', '┃AR┃ TOD BEIN EVENT 12', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744960.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-13-reborn', '┃AR┃ TOD BEIN EVENT 13', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744961.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-14-reborn', '┃AR┃ TOD BEIN EVENT 14', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744962.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-15-reborn', '┃AR┃ TOD BEIN EVENT 15', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744963.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-16-reborn', '┃AR┃ TOD BEIN EVENT 16', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744964.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-17-reborn', '┃AR┃ TOD BEIN EVENT 17', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744965.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-18-reborn', '┃AR┃ TOD BEIN EVENT 18', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744966.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-19-reborn', '┃AR┃ TOD BEIN EVENT 19', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744967.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-20-reborn', '┃AR┃ TOD BEIN EVENT 20', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744968.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-21-reborn', '┃AR┃ TOD BEIN EVENT 21', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744969.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-22-reborn', '┃AR┃ TOD BEIN EVENT 22', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744970.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-23-reborn', '┃AR┃ TOD BEIN EVENT 23', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744971.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-24-reborn', '┃AR┃ TOD BEIN EVENT 24', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744972.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-25-reborn', '┃AR┃ TOD BEIN EVENT 25', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744973.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ar-tod-bein-event-26-reborn', '┃AR┃ TOD BEIN EVENT 26', 'http://picon.tivi-ott.net:25461/picon/ARABIA/TOD%20SPORT/TOD%20SPORT.png', 'reborn-ar-tod-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1744974.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-1-4k-reborn', '┃RO┃ DIGI SPORT 1 4K', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444075.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-1-fhd-reborn', '┃RO┃ DIGI SPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444072.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-1-hd-reborn', '┃RO┃ DIGI SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444073.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-1-reborn', '┃RO┃ DIGI SPORT 1', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444074.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-1-fibra-reborn', '┃RO┃ DIGI SPORT 1 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444076.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-2-4k-reborn', '┃RO┃ DIGI SPORT 2 4K', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444080.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-2-fhd-reborn', '┃RO┃ DIGI SPORT 2 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444077.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-2-hd-reborn', '┃RO┃ DIGI SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444078.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-2-reborn', '┃RO┃ DIGI SPORT 2', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444079.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-2-fibra-reborn', '┃RO┃ DIGI SPORT 2 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444081.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-3-4k-reborn', '┃RO┃ DIGI SPORT 3 4K', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 3.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444085.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-3-fhd-reborn', '┃RO┃ DIGI SPORT 3 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 3.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444082.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-3-hd-reborn', '┃RO┃ DIGI SPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 3.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444083.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-3-reborn', '┃RO┃ DIGI SPORT 3', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 3.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444084.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-3-fibra-reborn', '┃RO┃ DIGI SPORT 3 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 3.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444086.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-4-4k-reborn', '┃RO┃ DIGI SPORT 4 4K', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 4.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444090.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-4-fhd-reborn', '┃RO┃ DIGI SPORT 4 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 4.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444087.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-4-hd-reborn', '┃RO┃ DIGI SPORT 4 HD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 4.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444088.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-4-reborn', '┃RO┃ DIGI SPORT 4', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 4.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444089.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-sport-4-fibra-reborn', '┃RO┃ DIGI SPORT 4 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI SPORT 4.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444091.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-digi-4k-reborn', '┃RO┃ DIGI 4K', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/DIGI 4K.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444092.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-pro-arena-fhd-reborn', '┃RO┃ PRO ARENA FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRO ARENA.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444093.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-pro-arena-hd-reborn', '┃RO┃ PRO ARENA HD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRO ARENA.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444094.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-pro-arena-reborn', '┃RO┃ PRO ARENA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRO ARENA.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444095.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-pro-arena-fibra-reborn', '┃RO┃ PRO ARENA FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRO ARENA.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444096.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-1-fhd-reborn', '┃RO┃ PRIMA SPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444099.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-1-hd-reborn', '┃RO┃ PRIMA SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444098.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-1-reborn', '┃RO┃ PRIMA SPORT 1', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444097.m3u8', '{}'::jsonb, true, NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-1-fibra-reborn', '┃RO┃ PRIMA SPORT 1 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444100.m3u8', '{}'::jsonb, true, NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-2-fhd-reborn', '┃RO┃ PRIMA SPORT 2 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444102.m3u8', '{}'::jsonb, true, NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-2-reborn', '┃RO┃ PRIMA SPORT 2', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444101.m3u8', '{}'::jsonb, true, NULL, 31
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-2-fibra-reborn', '┃RO┃ PRIMA SPORT 2 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444103.m3u8', '{}'::jsonb, true, NULL, 32
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-3-fhd-reborn', '┃RO┃ PRIMA SPORT 3 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 3.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444105.m3u8', '{}'::jsonb, true, NULL, 33
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-3-reborn', '┃RO┃ PRIMA SPORT 3', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 3.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444104.m3u8', '{}'::jsonb, true, NULL, 34
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-3-fibra-reborn', '┃RO┃ PRIMA SPORT 3 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 3.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444106.m3u8', '{}'::jsonb, true, NULL, 35
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-4-fhd-reborn', '┃RO┃ PRIMA SPORT 4 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 4.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444108.m3u8', '{}'::jsonb, true, NULL, 36
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-4-hd-reborn', '┃RO┃ PRIMA SPORT 4 HD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 4.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444107.m3u8', '{}'::jsonb, true, NULL, 37
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-4-fibra-reborn', '┃RO┃ PRIMA SPORT 4 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 4.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444109.m3u8', '{}'::jsonb, true, NULL, 38
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-5-fhd-reborn', '┃RO┃ PRIMA SPORT 5 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 5.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444111.m3u8', '{}'::jsonb, true, NULL, 39
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-5-reborn', '┃RO┃ PRIMA SPORT 5', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 5.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444110.m3u8', '{}'::jsonb, true, NULL, 40
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-prima-sport-5-fibra-reborn', '┃RO┃ PRIMA SPORT 5 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/PRIMA SPORT 5.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444112.m3u8', '{}'::jsonb, true, NULL, 41
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-eurosport-1-fhd-reborn', '┃RO┃ EUROSPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/EUROSPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444113.m3u8', '{}'::jsonb, true, NULL, 42
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-eurosport-1-reborn', '┃RO┃ EUROSPORT 1', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/EUROSPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444114.m3u8', '{}'::jsonb, true, NULL, 43
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-eurosport-1-fibra-reborn', '┃RO┃ EUROSPORT 1 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/EUROSPORT 1.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444115.m3u8', '{}'::jsonb, true, NULL, 44
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-eurosport-2-fhd-reborn', '┃RO┃ EUROSPORT 2 FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/EUROSPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444116.m3u8', '{}'::jsonb, true, NULL, 45
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-eurosport-2-reborn', '┃RO┃ EUROSPORT 2', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/EUROSPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444117.m3u8', '{}'::jsonb, true, NULL, 46
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-eurosport-2-fibra-reborn', '┃RO┃ EUROSPORT 2 FIBRA', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/EUROSPORT 2.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444118.m3u8', '{}'::jsonb, true, NULL, 47
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-eurosport-4k-reborn', '┃RO┃ EUROSPORT 4K', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/EUROSPORT.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444119.m3u8', '{}'::jsonb, true, NULL, 48
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-tvr-sport-hd-reborn', '┃RO┃ TVR SPORT HD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/TVR SPORT.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444120.m3u8', '{}'::jsonb, true, NULL, 49
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'ro-sport-extra-fhd-reborn', '┃RO┃ SPORT EXTRA FHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/┃RO┃ CANALE SPORT/SPORT EXTRA.png', 'reborn-ro-canale-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1444121.m3u8', '{}'::jsonb, true, NULL, 50
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-1-fhd-reborn', '┃PL┃ POLSAT SPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT 1.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729162.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-1-hd-reborn', '┃PL┃ POLSAT SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT 1.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729163.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-2-fhd-reborn', '┃PL┃ POLSAT SPORT 2 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT 2.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729164.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-2-hd-reborn', '┃PL┃ POLSAT SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT 2.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729165.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-3-fhd-reborn', '┃PL┃ POLSAT SPORT 3 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT 3.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729168.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-3-hd-reborn', '┃PL┃ POLSAT SPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT 3.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729169.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-fight-fhd-reborn', '┃PL┃ POLSAT SPORT Fight FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT Fight.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729166.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-fight-hd-reborn', '┃PL┃ POLSAT SPORT FIGHT HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT Fight.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729167.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-premium-1-fhd-reborn', '┃PL┃ POLSAT SPORT PREMIUM 1 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT PREMIUM 1.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729170.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-premium-1-hd-reborn', '┃PL┃ POLSAT SPORT PREMIUM 1 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT PREMIUM 1.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729171.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-premium-2-fhd-reborn', '┃PL┃ POLSAT SPORT PREMIUM 2 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT PREMIUM 2.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729172.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-premium-2-hd-reborn', '┃PL┃ POLSAT SPORT PREMIUM 2 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT PREMIUM 2.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729173.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-extra-1-fhd-reborn', '┃PL┃ POLSAT SPORT EXTRA 1 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT EXTRA 1.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729174.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-extra-1-hd-reborn', '┃PL┃ POLSAT SPORT EXTRA 1 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT EXTRA 1.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729175.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-extra-2-fhd-reborn', '┃PL┃ POLSAT SPORT EXTRA 2 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT EXTRA 2.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729176.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-extra-2-hd-reborn', '┃PL┃ POLSAT SPORT EXTRA 2 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT EXTRA 2.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729177.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-extra-3-fdh-reborn', '┃PL┃ POLSAT SPORT EXTRA 3 FDH', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT EXTRA 3.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729178.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-extra-3-hd-reborn', '┃PL┃ POLSAT SPORT EXTRA 3 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT EXTRA 3.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729179.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-extra-4-fhd-reborn', '┃PL┃ POLSAT SPORT EXTRA 4 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT EXTRA 4.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729180.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-polsat-sport-extra-4-hd-reborn', '┃PL┃ POLSAT SPORT EXTRA 4 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/POLSAT SPORT EXTRA 4.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729181.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-tvp-sport-fhd-reborn', '┃PL┃ TVP SPORT FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/TVP SPORT.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729190.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-tvp-sport-hd-reborn', '┃PL┃ TVP SPORT HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/TVP SPORT.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729191.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eurosport-1-fhd-reborn', '┃PL┃ EUROSPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EUROSPORT 1.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729182.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eurosport-1-hd-reborn', '┃PL┃ EUROSPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EUROSPORT 1.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729183.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eurosport-2-fhd-reborn', '┃PL┃ EUROSPORT 2 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EUROSPORT 2.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729184.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eurosport-2-hd-reborn', '┃PL┃ EUROSPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EUROSPORT 2.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729185.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eurosport-3-fhd-reborn', '┃PL┃ EUROSPORT 3 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EUROSPORT 3.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729186.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eurosport-3-hd-reborn', '┃PL┃ EUROSPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EUROSPORT 3.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729187.m3u8', '{}'::jsonb, true, NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eurosport-4-fhd-reborn', '┃PL┃ EUROSPORT 4 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EUROSPORT 4.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729188.m3u8', '{}'::jsonb, true, NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eurosport-4-hd-reborn', '┃PL┃ EUROSPORT 4 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EUROSPORT 4.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729189.m3u8', '{}'::jsonb, true, NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-sport-klub-fhd-reborn', '┃PL┃ SPORT KLUB FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/SPORT KLUB.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729192.m3u8', '{}'::jsonb, true, NULL, 31
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-sport-klub-hd-reborn', '┃PL┃ SPORT KLUB HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/SPORT KLUB.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729193.m3u8', '{}'::jsonb, true, NULL, 32
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-fightklub-fhd-reborn', '┃PL┃ FIGHTKLUB FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/FIGHTKLUB.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729198.m3u8', '{}'::jsonb, true, NULL, 33
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-fightklub-hd-reborn', '┃PL┃ FIGHTKLUB HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/FIGHTKLUB.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729199.m3u8', '{}'::jsonb, true, NULL, 34
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-fightbox-fhd-reborn', '┃PL┃ FIGHTBOX FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/FIGHTBOX.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729196.m3u8', '{}'::jsonb, true, NULL, 35
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-fightbox-hd-reborn', '┃PL┃ FIGHTBOX HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/FIGHTBOX.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729197.m3u8', '{}'::jsonb, true, NULL, 36
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-golf-zone-fhd-reborn', '┃PL┃ GOLF ZONE FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/GOLF ZONE.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729200.m3u8', '{}'::jsonb, true, NULL, 37
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-golf-zone-hd-reborn', '┃PL┃ GOLF ZONE HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/GOLF ZONE.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729201.m3u8', '{}'::jsonb, true, NULL, 38
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-extreme-sports-fhd-reborn', '┃PL┃ EXTREME SPORTS FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EXTREME SPORTS.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729194.m3u8', '{}'::jsonb, true, NULL, 39
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-extreme-sports-hd-reborn', '┃PL┃ EXTREME SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/EXTREME SPORTS.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729195.m3u8', '{}'::jsonb, true, NULL, 40
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-sportowa-tv-fhd-reborn', '┃PL┃ SPORTOWA TV FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/SPORTOWA TV.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729205.m3u8', '{}'::jsonb, true, NULL, 41
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-gametoon-fhd-reborn', '┃PL┃ GAMETOON FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/GAMETOON.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729202.m3u8', '{}'::jsonb, true, NULL, 42
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-e-sport-fhd-reborn', '┃PL┃ E-SPORT FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/E-SPORT.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729203.m3u8', '{}'::jsonb, true, NULL, 43
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-x-sport-fhd-reborn', '┃PL┃ X-SPORT FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ POLSAT SPORT/X-SPORT.png', 'reborn-pl-polsat-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729204.m3u8', '{}'::jsonb, true, NULL, 44
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-1-fhd-reborn', '┃PL┃ ELEVEN SPORTS 1 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 1.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729221.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-1-hd-reborn', '┃PL┃ ELEVEN SPORTS 1 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 1.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729222.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-1-reborn', '┃PL┃ ELEVEN SPORTS 1', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 1.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729223.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-2-fhd-reborn', '┃PL┃ ELEVEN SPORTS 2 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 2.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729224.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-2-hd-reborn', '┃PL┃ ELEVEN SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 2.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729225.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-2-reborn', '┃PL┃ ELEVEN SPORTS 2', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 2.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729226.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-3-fhd-reborn', '┃PL┃ ELEVEN SPORTS 3 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 3.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729227.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-3-hd-reborn', '┃PL┃ ELEVEN SPORTS 3 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 3.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729228.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-3-reborn', '┃PL┃ ELEVEN SPORTS 3', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 3.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729229.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-4-fhd-reborn', '┃PL┃ ELEVEN SPORTS 4 FHD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 4.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729230.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-4-hd-reborn', '┃PL┃ ELEVEN SPORTS 4 HD', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 4.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729231.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pl-eleven-sports-4-reborn', '┃PL┃ ELEVEN SPORTS 4', 'http://picon.tivi-ott.net:25461/picon/Poland/┃PL┃ ELEVEN SPORTS/ELEVEN SPORTS 4.png', 'reborn-pl-eleven-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1729232.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-max-sport-1-4k-reborn', '┃HR┃ MAX SPORT 1 4K', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/558965.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-max-sport-1-hd-reborn', '┃HR┃ MAX SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/559133.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-max-sport-2-4k-reborn', '┃HR┃ MAX SPORT 2 4K', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/558966.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-max-sport-2-hd-reborn', '┃HR┃ MAX SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/559134.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-1-hd-reborn', '┃HR┃ ARENA SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1115.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-2-hd-reborn', '┃HR┃ ARENA SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1114.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-3-hd-reborn', '┃HR┃ ARENA SPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1113.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-4-hd-reborn', '┃HR┃ ARENA SPORT 4 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1112.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-5-hd-reborn', '┃HR┃ ARENA SPORT 5 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1111.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-6-hd-reborn', '┃HR┃ ARENA SPORT 6 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1110.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-7-hd-reborn', '┃HR┃ ARENA SPORT 7 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/558961.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-8-hd-reborn', '┃HR┃ ARENA SPORT 8 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/558962.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-9-hd-reborn', '┃HR┃ ARENA SPORT 9 HD', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/558963.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-sport-10-4k-reborn', '┃HR┃ ARENA SPORT 10 4K', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/558964.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-fight-4k-reborn', '┃HR┃ ARENA FIGHT 4K', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/558967.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-arena-e-sport-4k-reborn', '┃HR┃ ARENA E SPORT 4K', 'http://picon.tivi-ott.net:25461/picon/BOSNA/Arena_sport_logo.png', 'reborn-hr-arena-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/558969.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sport-klub-hd-reborn', '┃HR┃ SPORT KLUB HD', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1109.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sport-klub-1-hd-reborn', '┃HR┃ SPORT KLUB 1 HD', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1108.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sport-klub-2-hd-reborn', '┃HR┃ SPORT KLUB 2 HD', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1107.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sport-klub-3-hd-reborn', '┃HR┃ SPORT KLUB 3 HD', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1106.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sport-klub-4-hd-reborn', '┃HR┃ SPORT KLUB 4 HD', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1105.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sport-klub-5-hd-reborn', '┃HR┃ SPORT KLUB 5 HD', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1104.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sport-klub-6-hd-reborn', '┃HR┃ SPORT KLUB 6 HD', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1103.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sport-klub-golf-hd-reborn', '┃HR┃ SPORT KLUB GOLF HD', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1102.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sport-klub-fight-hd-reborn', '┃HR┃ SPORT KLUB FIGHT HD', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/559136.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'hr-sportska-reborn', '┃HR┃ SPORTSKA', 'http://picon.tivi-ott.net:25461/picon/SRBIJA/Sportklub_Logo.svg.png', 'reborn-hr-sport-klub', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/558968.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-1-4k-reborn', '┃TR┃ S SPORT 1 4K', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/712.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-2-4k-reborn', '┃TR┃ S SPORT 2 4K', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/711.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-spor-smart-1-4k-reborn', '┃TR┃ SPOR SMART 1 4K', 'http://picon.tivi-ott.net:25461/picon/TURKEY/sporsmart.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/713.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-spor-smart-2-4k-reborn', '┃TR┃ SPOR SMART 2 4K', 'http://picon.tivi-ott.net:25461/picon/TURKEY/sporsmart.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/18631.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-eurosport-1-4k-reborn', '┃TR┃ EUROSPORT 1 4K', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Eurosport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/708.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-eurosport-2-4k-reborn', '┃TR┃ EUROSPORT 2 4K', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Eurosport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/707.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-nba-tv-4k-reborn', '┃TR┃ NBA TV 4K', 'http://picon.tivi-ott.net:25461/picon/TURKEY/NBA_TV_II.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/18632.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-fightbox-4k-reborn', '┃TR┃ FIGHTBOX 4K', 'http://picon.tivi-ott.net:25461/picon/TURKEY/fightbox.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/18635.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-paket-s-sports-hd-reborn', '☰☰☰☰ ┃TR┃ PAKET S SPORTS HD ☰☰☰☰', 'http://picon.tivi-ott.net:25461/picon/MIX2/TURKEYFLAG.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/18629.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-1-hd-reborn', '┃TR┃ S SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/703.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-2-hd-reborn', '┃TR┃ S SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/18638.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-spor-smart-1-hd-reborn', '┃TR┃ SPOR SMART 1 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/sporsmart.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/704.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-spor-smart-2-hd-reborn', '┃TR┃ SPOR SMART 2 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/sporsmart.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/18640.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-eurosport-1-hd-reborn', '┃TR┃ EUROSPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Eurosport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/700.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-eurosport-2-hd-reborn', '┃TR┃ EUROSPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Eurosport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/699.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-nba-tv-hd-reborn', '┃TR┃ NBA TV HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/NBA_TV_II.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/698.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-paket-s-sports-fhd-reborn', '☰☰☰☰ ┃TR┃ PAKET S SPORTS+ FHD ☰☰☰☰', 'http://picon.tivi-ott.net:25461/picon/MIX2/TURKEYFLAG.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/18630.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-1-hd-match-time-reborn', '┃TR┃ S SPORT+ 1 HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/15562.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-2-hd-match-time-reborn', '┃TR┃ S SPORT+ 2 HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/15561.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-3-hd-match-time-reborn', '┃TR┃ S SPORT+ 3 HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/15560.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-4-hd-match-time-reborn', '┃TR┃ S SPORT+ 4 HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/15559.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-5-hd-match-time-reborn', '┃TR┃ S SPORT+ 5 HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/15558.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-s-sport-6-hd-match-time-reborn', '┃TR┃ S SPORT+ 6 HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Ssport.png', 'reborn-tr-s-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/15557.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-1-raw-reborn', '┃TR┃ BEIN SPORTS 1 RAW', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988867.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-1-fhd-reborn', '┃TR┃ BEIN SPORTS 1 FHD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988874.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-1-hd-reborn', '┃TR┃ BEIN SPORTS 1 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988881.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-2-raw-reborn', '┃TR┃ BEIN SPORTS 2 RAW', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988868.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-2-fhd-reborn', '┃TR┃ BEIN SPORTS 2 FHD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988875.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-2-hd-reborn', '┃TR┃ BEIN SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988882.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-3-raw-reborn', '┃TR┃ BEIN SPORTS 3 RAW', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 3.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988869.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-3-fhd-reborn', '┃TR┃ BEIN SPORTS 3 FHD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 3.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988876.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-3-hd-reborn', '┃TR┃ BEIN SPORTS 3 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 3.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988883.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-4-raw-reborn', '┃TR┃ BEIN SPORTS 4 RAW', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 4.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988870.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-4-fhd-reborn', '┃TR┃ BEIN SPORTS 4 FHD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 4.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988877.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-4-hd-reborn', '┃TR┃ BEIN SPORTS 4 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 4.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988884.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-5-raw-reborn', '┃TR┃ BEIN SPORTS 5 RAW', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 5.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988871.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-5-fhd-reborn', '┃TR┃ BEIN SPORTS 5 FHD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 5.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988878.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-5-hd-reborn', '┃TR┃ BEIN SPORTS 5 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 5.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988885.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-max-1-raw-reborn', '┃TR┃ BEIN SPORTS MAX 1 RAW', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS MAX 1.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988872.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-max-1-fhd-reborn', '┃TR┃ BEIN SPORTS MAX 1 FHD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS MAX 1.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988879.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-max-2-raw-reborn', '┃TR┃ BEIN SPORTS MAX 2 RAW', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS MAX 2.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988873.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-max-2-fhd-reborn', '┃TR┃ BEIN SPORTS MAX 2 FHD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS MAX 2.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988880.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'tr-bein-sports-1-hevc-ma-zamani-reborn', '┃TR┃ BEIN SPORTS 1 HEVC (MAÇ ZAMANI)', 'http://picon.tivi-ott.net:25461/picon/TURKEY/BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-tr-bein-sports-fhd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/988886.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-canal-11-fhd-hevc-reborn', '┃PT┃ CANAL 11 FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/CANAL 11.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959328.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-canal-11-fhd-reborn', '┃PT┃ CANAL 11 FHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/CANAL 11.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959329.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-canal-11-hd-reborn', '┃PT┃ CANAL 11 HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/CANAL 11.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959330.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-canal-11-reborn', '┃PT┃ CANAL 11', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/CANAL 11.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959331.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-multi-screen-hd-reborn', '┃PT┃ SPORT TV MULTI SCREEN HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/MOSAICO SPORT TV.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959332.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-fhd-hevc-reborn', '┃PT┃ SPORT TV+ FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV+.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959333.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-fhd-reborn', '┃PT┃ SPORT TV+ FHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV+.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959334.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-hd-reborn', '┃PT┃ SPORT TV+ HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV+.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959335.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-reborn', '┃PT┃ SPORT TV+', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV+.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959336.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-1-4k-uhd-reborn', '┃PT┃ SPORT TV 1 4K UHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 1.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959337.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-1-fhd-hevc-reborn', '┃PT┃ SPORT TV 1 FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 1.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959338.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-1-fhd-reborn', '┃PT┃ SPORT TV 1 FHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 1.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959339.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-1-hd-reborn', '┃PT┃ SPORT TV 1 HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 1.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959340.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-1-reborn', '┃PT┃ SPORT TV 1', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 1.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959341.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-2-fhd-hevc-reborn', '┃PT┃ SPORT TV 2 FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 2.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959342.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-2-fhd-reborn', '┃PT┃ SPORT TV 2 FHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 2.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959343.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-2-hd-reborn', '┃PT┃ SPORT TV 2 HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 2.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959344.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-2-reborn', '┃PT┃ SPORT TV 2', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 2.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959345.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-3-fhd-hevc-reborn', '┃PT┃ SPORT TV 3 FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 3.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959346.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-3-fhd-reborn', '┃PT┃ SPORT TV 3 FHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 3.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959347.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-3-hd-reborn', '┃PT┃ SPORT TV 3 HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 3.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959348.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-3-reborn', '┃PT┃ SPORT TV 3', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 3.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959349.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-4-fhd-hevc-reborn', '┃PT┃ SPORT TV 4 FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 4.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959350.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-4-fhd-reborn', '┃PT┃ SPORT TV 4 FHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 4.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959351.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-4-hd-reborn', '┃PT┃ SPORT TV 4 HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 4.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959352.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-4-reborn', '┃PT┃ SPORT TV 4', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 4.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959353.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-5-fhd-hevc-reborn', '┃PT┃ SPORT TV 5 FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 5.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959354.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-5-fhd-reborn', '┃PT┃ SPORT TV 5 FHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 5.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959355.m3u8', '{}'::jsonb, true, NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-5-hd-reborn', '┃PT┃ SPORT TV 5 HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 5.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959356.m3u8', '{}'::jsonb, true, NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-5-reborn', '┃PT┃ SPORT TV 5', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 5.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959357.m3u8', '{}'::jsonb, true, NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-6-fhd-hevc-reborn', '┃PT┃ SPORT TV 6 FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 6.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959358.m3u8', '{}'::jsonb, true, NULL, 31
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-6-fhd-reborn', '┃PT┃ SPORT TV 6 FHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 6.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959359.m3u8', '{}'::jsonb, true, NULL, 32
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-6-hd-reborn', '┃PT┃ SPORT TV 6 HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 6.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959360.m3u8', '{}'::jsonb, true, NULL, 33
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-6-reborn', '┃PT┃ SPORT TV 6', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 6.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959361.m3u8', '{}'::jsonb, true, NULL, 34
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-7-fhd-reborn', '┃PT┃ SPORT TV 7 FHD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 7.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959362.m3u8', '{}'::jsonb, true, NULL, 35
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-7-hd-reborn', '┃PT┃ SPORT TV 7 HD', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 7.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959363.m3u8', '{}'::jsonb, true, NULL, 36
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'pt-sport-tv-7-reborn', '┃PT┃ SPORT TV 7', 'http://picon.tivi-ott.net:25461/picon/PORTUGALIA/SPORT TV/SPORT TV 7.png', 'reborn-pt-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/959364.m3u8', '{}'::jsonb, true, NULL, 37
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-my-sports-1-fhd-reborn', '┃IT┃ MY SPORTS 1 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/MY SPORTS/MY SPORTS.png', 'reborn-it-my-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167377.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-my-sports-2-fhd-reborn', '┃IT┃ MY SPORTS 2 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/MY SPORTS/MY SPORTS 2.png', 'reborn-it-my-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167378.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-my-sports-3-fhd-reborn', '┃IT┃ MY SPORTS 3 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/MY SPORTS/MY SPORTS 3.png', 'reborn-it-my-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167379.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-my-sports-4-fhd-reborn', '┃IT┃ MY SPORTS 4 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/MY SPORTS/MY SPORTS 4.png', 'reborn-it-my-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167380.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-my-sports-5-fhd-reborn', '┃IT┃ MY SPORTS 5 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/MY SPORTS/MY SPORTS 5.png', 'reborn-it-my-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167381.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-my-sports-6-fhd-reborn', '┃IT┃ MY SPORTS 6 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/MY SPORTS/MY SPORTS 6.png', 'reborn-it-my-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167382.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-my-sports-7-fhd-reborn', '┃IT┃ MY SPORTS 7 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/MY SPORTS/MY SPORTS 7.png', 'reborn-it-my-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167383.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-my-sports-8-fhd-reborn', '┃IT┃ MY SPORTS 8 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/MY SPORTS/MY SPORTS 8.png', 'reborn-it-my-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167384.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-calcio-251-fhd-reborn', '┃IT┃ SKY CALCIO 251 fHD', 'http://picon.tivi-ott.net:25461/picon/MIX/ITSKYCALCIO.png', 'reborn-it-sky-calcio', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177769.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-calcio-252-fhd-reborn', '┃IT┃ SKY CALCIO 252 FHD', 'http://picon.tivi-ott.net:25461/picon/MIX/ITSKYCALCIO.png', 'reborn-it-sky-calcio', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177770.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-calcio-253-fhd-reborn', '┃IT┃ SKY CALCIO 253 FHD', 'http://picon.tivi-ott.net:25461/picon/MIX/ITSKYCALCIO.png', 'reborn-it-sky-calcio', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177771.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-calcio-254-fhd-reborn', '┃IT┃ SKY CALCIO 254 FHD', 'http://picon.tivi-ott.net:25461/picon/MIX/ITSKYCALCIO.png', 'reborn-it-sky-calcio', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177772.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-calcio-255-fhd-reborn', '┃IT┃ SKY CALCIO 255 FHD', 'http://picon.tivi-ott.net:25461/picon/MIX/ITSKYCALCIO.png', 'reborn-it-sky-calcio', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177773.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-calcio-256-fhd-reborn', '┃IT┃ SKY CALCIO 256 FHD', 'http://picon.tivi-ott.net:25461/picon/MIX/ITSKYCALCIO.png', 'reborn-it-sky-calcio', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177774.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-calcio-257-fhd-reborn', '┃IT┃ SKY CALCIO 257 FHD', 'http://picon.tivi-ott.net:25461/picon/MIX/ITSKYCALCIO.png', 'reborn-it-sky-calcio', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/704711.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-uno-hevc-reborn', '┃IT┃ SKY SPORT UNO HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTUNO.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167167.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-uno-fhd-reborn', '┃IT┃ SKY SPORT UNO FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTUNO.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177687.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-24-hevc-reborn', '┃IT┃ SKY SPORT 24 HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORT24.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167168.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-24-fhd-reborn', '┃IT┃ SKY SPORT 24 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORT24.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177690.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-calcio-hevc-reborn', '┃IT┃ SKY SPORT CALCIO HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTCALCIO.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167169.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-calcio-fhd-reborn', '┃IT┃ SKY SPORT CALCIO FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTCALCIO.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177694.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-golf-hevc-reborn', '┃IT┃ SKY SPORT GOLF HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTACTION.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167170.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-golf-fhd-reborn', '┃IT┃ SKY SPORT GOLF FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTACTION.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/240463.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-arena-hevc-reborn', '┃IT┃ SKY SPORT ARENA HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTARENA.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167171.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-arena-fhd-reborn', '┃IT┃ SKY SPORT ARENA FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTARENA.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177696.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-max-hevc-reborn', '┃IT┃ SKY SPORT MAX HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTFOOTBALL.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167172.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-max-fhd-reborn', '┃IT┃ SKY SPORT MAX FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTFOOTBALL.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177697.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-f1-hevc-reborn', '┃IT┃ SKY SPORT F1 HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTF1.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167173.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-f1-fhd-reborn', '┃IT┃ SKY SPORT F1 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTF1.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177699.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-motogp-hevc-reborn', '┃IT┃ SKY SPORT MOTOGP HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTMOTOGP.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167177.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-motogp-fhd-reborn', '┃IT┃ SKY SPORT MOTOGP FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTMOTOGP.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177700.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-tennis-hevc-reborn', '┃IT┃ SKY SPORT TENNIS HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKY SPORT TENNIS.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167175.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-tennis-fhd-reborn', '┃IT┃ SKY SPORT TENNIS FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKY SPORT TENNIS.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167174.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-nba-hevc-reborn', '┃IT┃ SKY SPORT NBA HEVC', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTNBA.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1167176.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-sky-sport-nba-fhd-reborn', '┃IT┃ SKY SPORT NBA FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/SKYSPORTNBA.png', 'reborn-it-sky-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177701.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-eurosport-1-fhd-reborn', '┃IT┃ EUROSPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/Eurosport_1_Logo_2015.png', 'reborn-it-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177964.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-eurosport-2-fhd-reborn', '┃IT┃ EUROSPORT 2 FHD', 'http://picon.tivi-ott.net:25461/picon/ITALY/Eurosport_2_HD.png', 'reborn-it-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/177966.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-horse-tv-fhd-reborn', '┃IT┃ HORSE TV FHD', 'http://picon.tivi-ott.net:25461/picon/HORSERACING/HORSERACING.png', 'reborn-it-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/228926.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'it-super-tennis-4k-reborn', '┃IT┃ SUPER TENNIS 4K', 'http://picon.tivi-ott.net:25461/picon/ITALY/Supertennis_logo.png', 'reborn-it-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/228924.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-aek-pass-hd-reborn', '┃CY┃ AEK PASS HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/AEK PASS HD.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/866580.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-olympicos-pass-hd-reborn', '┃CY┃ OLYMPICOS PASS HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/OLYMPICOS PASS HD.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/866579.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-panathinaikos-pass-hd-reborn', '┃CY┃ PANATHINAIKOS PASS HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/PANATHINAIKOS PASS HD.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/866578.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-omonoia-tv-reborn', '┃CY┃ OMONOIA TV', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/OMONOIA TV.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1017407.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-premiere-league-hd-reborn', '┃CY┃ CYTAVISION SPORT PREMIERE LEAGUE HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/CYTAVISION SPORT PREMIERE LEAGUE.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1017405.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-1-4k-reborn', '┃CY┃ CYTAVISION SPORT 1 4K', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/758636.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-1-hd-reborn', '┃CY┃ CYTAVISION SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/244151.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-2-4k-reborn', '┃CY┃ CYTAVISION SPORT 2 4K', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/758637.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-2-hd-reborn', '┃CY┃ CYTAVISION SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/244152.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-3-4k-reborn', '┃CY┃ CYTAVISION SPORT 3 4K', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/758638.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-3-hd-reborn', '┃CY┃ CYTAVISION SPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/244153.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-4-4k-reborn', '┃CY┃ CYTAVISION SPORT 4 4K', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/758640.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-4-hd-reborn', '┃CY┃ CYTAVISION SPORT 4 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/244154.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-5-4k-reborn', '┃CY┃ CYTAVISION SPORT 5 4K', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/758641.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-5-hd-reborn', '┃CY┃ CYTAVISION SPORT 5 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/244155.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-6-4k-reborn', '┃CY┃ CYTAVISION SPORT 6 4K', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/758644.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-6-hd-reborn', '┃CY┃ CYTAVISION SPORT 6 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/244156.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-7-4k-reborn', '┃CY┃ CYTAVISION SPORT 7 4K', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/758648.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-7-hd-reborn', '┃CY┃ CYTAVISION SPORT 7 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/244157.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cytavision-sport-8-hd-reborn', '┃CY┃ CYTAVISION SPORT 8 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/cytavision.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1017408.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cabelnet-sport-1-4k-reborn', '┃CY┃ CABELNET SPORT 1 4K', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/Cablenet-logo_Transparent_No-Services.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/758652.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cabelnet-sport-1-hd-reborn', '┃CY┃ CABELNET SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/Cablenet-logo_Transparent_No-Services.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/244149.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cabelnet-sport-2-4k-reborn', '┃CY┃ CABELNET SPORT 2 4K', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/Cablenet-logo_Transparent_No-Services.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/758653.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cabelnet-sport-2-hd-reborn', '┃CY┃ CABELNET SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/Cablenet-logo_Transparent_No-Services.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/244150.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'cy-cabelnet-sport-3-hd-reborn', '┃CY┃ CABELNET SPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/CYPRUS/Cablenet-logo_Transparent_No-Services.png', 'reborn-cy-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/983268.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-4k-reborn', '┃GR┃ COSMOTE SPORT 4K', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648352.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-highlights-fhd-reborn', '┃GR┃ COSMOTE SPORT HIGHLIGHTS FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1891.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-highlights-hd-reborn', '┃GR┃ COSMOTE SPORT HIGHLIGHTS HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/671498.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-1-fhd-reborn', '┃GR┃ COSMOTE SPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174426.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-1-hd-reborn', '┃GR┃ COSMOTE SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1890.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-1-sd-reborn', '┃GR┃ COSMOTE SPORT 1 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/671508.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-2-fhd-reborn', '┃GR┃ COSMOTE SPORT 2 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174427.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-2-hd-reborn', '┃GR┃ COSMOTE SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1889.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-2-sd-reborn', '┃GR┃ COSMOTE SPORT 2 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/671509.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-3-fhd-reborn', '┃GR┃ COSMOTE SPORT 3 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174428.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-3-hd-reborn', '┃GR┃ COSMOTE SPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1888.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-3-sd-reborn', '┃GR┃ COSMOTE SPORT 3 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/671510.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-4-fhd-reborn', '┃GR┃ COSMOTE SPORT 4 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174429.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-4-hd-reborn', '┃GR┃ COSMOTE SPORT 4 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1887.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-4-sd-reborn', '┃GR┃ COSMOTE SPORT 4 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/671511.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-5-fhd-reborn', '┃GR┃ COSMOTE SPORT 5 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174430.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-5-hd-reborn', '┃GR┃ COSMOTE SPORT 5 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1886.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-5-sd-reborn', '┃GR┃ COSMOTE SPORT 5 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/671512.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-6-fhd-reborn', '┃GR┃ COSMOTE SPORT 6 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174265.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-6-hd-reborn', '┃GR┃ COSMOTE SPORT 6 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1885.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-6-sd-reborn', '┃GR┃ COSMOTE SPORT 6 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/671513.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-7-fhd-reborn', '┃GR┃ COSMOTE SPORT 7 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174264.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-7-hd-reborn', '┃GR┃ COSMOTE SPORT 7 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1884.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-8-fhd-reborn', '┃GR┃ COSMOTE SPORT 8 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174263.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-8-hd-reborn', '┃GR┃ COSMOTE SPORT 8 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1883.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-9-fhd-reborn', '┃GR┃ COSMOTE SPORT 9 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1882.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-9-hd-reborn', '┃GR┃ COSMOTE SPORT 9 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/COSMOTETV.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/671507.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-sl-pass-panathinaikos-fhd-reborn', '┃GR┃ COSMOTE SPORT SL PASS PANATHINAIKOS FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Olympiacos_FC_logo.svg.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/699599.m3u8', '{}'::jsonb, true, NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-sl-panathinaikos-pass-hd-reborn', '┃GR┃ COSMOTE SPORT SL PANATHINAIKOS PASS HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Panathinaikos_F.C._logo.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242084.m3u8', '{}'::jsonb, true, NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-sl-pass-olympiakos-fhd-reborn', '┃GR┃ COSMOTE SPORT SL PASS OLYMPIAKOS FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Olympiacos_FC_logo.svg.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/699598.m3u8', '{}'::jsonb, true, NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-sl-pass-olympiakos-hd-reborn', '┃GR┃ COSMOTE SPORT SL PASS OLYMPIAKOS HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Olympiacos_FC_logo.svg.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242085.m3u8', '{}'::jsonb, true, NULL, 31
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-sl-pass-aek-fhd-reborn', '┃GR┃ COSMOTE SPORT SL PASS AEK FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Olympiacos_FC_logo.svg.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/699597.m3u8', '{}'::jsonb, true, NULL, 32
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-cosmote-sport-sl-pass-aek-hd-reborn', '┃GR┃ COSMOTE SPORT SL PASS AEK HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/AEKPASS.png', 'reborn-gr-cosmote-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/242086.m3u8', '{}'::jsonb, true, NULL, 33
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-news-fhd-reborn', '┃GR┃ NOVA SPORTS NEWS FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Nova_Sports_News_V2021.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1880.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sport-news-hd-reborn', '┃GR┃ NOVA SPORT NEWS HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Nova_Sports_News_V2021.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174431.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-prime-fhd-reborn', '┃GR┃ NOVA SPORTS PRIME FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Nova_Sports_Prime_V2021.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1142146.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-prime-hd-reborn', '┃GR┃ NOVA SPORTS PRIME HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Nova_Sports_Prime_V2021.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1874.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-prime-sd-reborn', '┃GR┃ NOVA SPORTS PRIME SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Nova_Sports_Prime_V2021.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648351.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-start-fhd-reborn', '┃GR┃ NOVA SPORTS START FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/NOVASPORTSSTART.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/56829.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-start-hd-reborn', '┃GR┃ NOVA SPORTS START HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/NOVASPORTSSTART.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174254.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-start-sd-reborn', '┃GR┃ NOVA SPORTS START SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/NOVASPORTSSTART.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648350.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-premier-league-fhd-reborn', '┃GR┃ NOVA SPORTS PREMIER LEAGUE FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1879.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-premier-league-hd-reborn', '┃GR┃ NOVA SPORTS PREMIER LEAGUE HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/663683.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-premier-league-sd-reborn', '┃GR┃ NOVA SPORTS PREMIER LEAGUE SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648349.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-1-fhd-reborn', '┃GR┃ NOVA SPORTS 1 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/173185.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-1-hd-reborn', '┃GR┃ NOVA SPORTS 1 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/193070.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-1-sd-reborn', '┃GR┃ NOVA SPORTS 1 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648348.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-2-fhd-reborn', '┃GR┃ NOVA SPORTS 2 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/173186.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-2-hd-reborn', '┃GR┃ NOVA SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1878.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-2-sd-reborn', '┃GR┃ NOVA SPORTS 2 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648347.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-3-fhd-reborn', '┃GR┃ NOVA SPORTS 3 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174271.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-3-hd-reborn', '┃GR┃ NOVA SPORTS 3 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1877.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-3-sd-reborn', '┃GR┃ NOVA SPORTS 3 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648346.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-4-fhd-reborn', '┃GR┃ NOVA SPORTS 4 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174272.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-4-hd-reborn', '┃GR┃ NOVA SPORTS 4 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1876.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-4-sd-reborn', '┃GR┃ NOVA SPORTS 4 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648345.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-5-fhd-reborn', '┃GR┃ NOVA SPORTS 5 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1875.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-5-hd-reborn', '┃GR┃ NOVA SPORTS 5 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/193074.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-5-sd-reborn', '┃GR┃ NOVA SPORTS 5 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648344.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-6-fhd-reborn', '┃GR┃ NOVA SPORTS 6 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/174273.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-6-hd-reborn', '┃GR┃ NOVA SPORTS 6 HD', 'http://picon.tivi-ott.net:25461/picon/GREECE/NOVASPORTSSTART.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/699928.m3u8', '{}'::jsonb, true, NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-6-sd-reborn', '┃GR┃ NOVA SPORTS 6 SD', 'http://picon.tivi-ott.net:25461/picon/GREECE/NOVASPORTSSTART.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1648343.m3u8', '{}'::jsonb, true, NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-extra-1-fhd-reborn', '┃GR┃ NOVA SPORTS EXTRA 1 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/193071.m3u8', '{}'::jsonb, true, NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-extra-2-fhd-reborn', '┃GR┃ NOVA SPORTS EXTRA 2 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/193072.m3u8', '{}'::jsonb, true, NULL, 31
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-extra-3-fhd-reborn', '┃GR┃ NOVA SPORTS EXTRA 3 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/193073.m3u8', '{}'::jsonb, true, NULL, 32
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'gr-nova-sports-extra-4-fhd-reborn', '┃GR┃ NOVA SPORTS EXTRA 4 FHD', 'http://picon.tivi-ott.net:25461/picon/GREECE/Novasports21.png', 'reborn-gr-nova-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/724019.m3u8', '{}'::jsonb, true, NULL, 33
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-1-hevc-reborn', '┃AL┃ SUPER SPORT 1 HEVC', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/285.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-1-fhd-reborn', '┃AL┃ SUPER SPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/299.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-1-hd-reborn', '┃AL┃ SUPER SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/212476.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-2-hevc-reborn', '┃AL┃ SUPER SPORT 2 HEVC', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/286.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-2-fhd-reborn', '┃AL┃ SUPER SPORT 2 FHD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/300.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-2-hd-reborn', '┃AL┃ SUPER SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/212477.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-3-hevc-reborn', '┃AL┃ SUPER SPORT 3 HEVC', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/287.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-3-fhd-reborn', '┃AL┃ SUPER SPORT 3 FHD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/301.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-3-hd-reborn', '┃AL┃ SUPER SPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/212478.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-4-hevc-reborn', '┃AL┃ SUPER SPORT 4 HEVC', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/288.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-4-fhd-reborn', '┃AL┃ SUPER SPORT 4 FHD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/302.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-4-hd-reborn', '┃AL┃ SUPER SPORT 4 HD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/212479.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-5-hevc-reborn', '┃AL┃ SUPER SPORT 5 HEVC', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/289.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-5-fhd-reborn', '┃AL┃ SUPER SPORT 5 FHD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/303.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-5-hd-reborn', '┃AL┃ SUPER SPORT 5 HD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/212480.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-6-hevc-reborn', '┃AL┃ SUPER SPORT 6 HEVC', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/290.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-6-fhd-reborn', '┃AL┃ SUPER SPORT 6 FHD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/304.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-6-hd-reborn', '┃AL┃ SUPER SPORT 6 HD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/212481.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-7-hevc-reborn', '┃AL┃ SUPER SPORT 7 HEVC', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/291.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-7-fhd-reborn', '┃AL┃ SUPER SPORT 7 FHD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/305.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-super-sport-7-hd-reborn', '┃AL┃ SUPER SPORT 7 HD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/SUPERSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/212482.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-mcn-tv-reborn', '┃AL┃ MCN TV', 'http://picon.tivi-ott.net:25461/picon/POLONIA/mcnalbaniatv.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/645001.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-eurosport-1-hd-reborn', '┃AL┃ EUROSPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Eurosport.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/676123.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-eurosport-2-hd-reborn', '┃AL┃ EUROSPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/TURKEY/Eurosport.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/676124.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-rtsh-sport-hd-reborn', '┃AL┃ RTSH SPORT HD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/RTSHSPORT.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/340.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'al-fightbox-hd-reborn', '┃AL┃ FIGHTBOX HD', 'http://picon.tivi-ott.net:25461/picon/ALBANIA/FightBoxHD-logo.png', 'reborn-al-digitalb-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/339.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'at-orf-sport-hd-reborn', '┃AT┃ ORF SPORT+ HD', 'http://picon.tivi-ott.net:25461/picon/AUSTRIA/ORFSPORT.png', 'reborn-at-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/2386.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'at-sky-sport-austria-1-fhd-reborn', '┃AT┃ SKY SPORT AUSTRIA 1 FHD', 'http://picon.tivi-ott.net:25461/picon/AUSTRIA/Sky_Sport_Austria_HD_Logo_2016.png', 'reborn-at-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/36062.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'at-sky-sport-austria-2-fhd-reborn', '┃AT┃ SKY SPORT AUSTRIA 2 FHD', 'http://picon.tivi-ott.net:25461/picon/AUSTRIA/Sky_Sport_Austria_HD_Logo_2016.png', 'reborn-at-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/36063.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'at-sky-sport-austria-3-fhd-reborn', '┃AT┃ SKY SPORT AUSTRIA 3 FHD', 'http://picon.tivi-ott.net:25461/picon/AUSTRIA/Sky_Sport_Austria_HD_Logo_2016.png', 'reborn-at-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/36064.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'at-sky-sport-austria-4-fhd-reborn', '┃AT┃ SKY SPORT AUSTRIA 4 FHD', 'http://picon.tivi-ott.net:25461/picon/AUSTRIA/Sky_Sport_Austria_HD_Logo_2016.png', 'reborn-at-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/36065.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'at-sky-sport-austria-5-fhd-reborn', '┃AT┃ SKY SPORT AUSTRIA 5 FHD', 'http://picon.tivi-ott.net:25461/picon/AUSTRIA/Sky_Sport_Austria_HD_Logo_2016.png', 'reborn-at-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/36066.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'at-sky-sport-austria-6-fhd-reborn', '┃AT┃ SKY SPORT AUSTRIA 6 FHD', 'http://picon.tivi-ott.net:25461/picon/AUSTRIA/Sky_Sport_Austria_HD_Logo_2016.png', 'reborn-at-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/36067.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'at-sky-sport-austria-7-fhd-reborn', '┃AT┃ SKY SPORT AUSTRIA 7 FHD', 'http://picon.tivi-ott.net:25461/picon/AUSTRIA/Sky_Sport_Austria_HD_Logo_2016.png', 'reborn-at-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/36068.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-premier-sports-1-8k-reborn', '┃UK┃ PREMIER SPORTS 1 8K', 'http://picon.tivi-ott.net:25461/picon/UK/PREMIERSPORTS.png', 'reborn-uk-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/827990.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-premier-sports-2-8k-reborn', '┃UK┃ PREMIER SPORTS 2 8K', 'http://picon.tivi-ott.net:25461/picon/UK/PREMIERSPORTS.png', 'reborn-uk-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/827989.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-dazn-1-8k-reborn', '┃UK┃ DAZN 1 8K', 'http://picon.tivi-ott.net:25461/picon/GERMANY/DAZNHD.png', 'reborn-uk-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/827993.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-la-liga-tv-8k-reborn', '┃UK┃ LA LIGA TV 8K', 'http://picon.tivi-ott.net:25461/picon/SPAIN/LALIGA.png', 'reborn-uk-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/827985.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-mutv-8k-reborn', '┃UK┃ MUTV 8K', 'http://picon.tivi-ott.net:25461/picon/UK/MUTV.png', 'reborn-uk-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/827988.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-lfc-8k-reborn', '┃UK┃ LFC 8K', 'http://picon.tivi-ott.net:25461/picon/UK/LFCTV.png', 'reborn-uk-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/827987.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-racing-8k-reborn', '┃UK┃ RACING 8K', 'http://picon.tivi-ott.net:25461/picon/UK/2/RACINGTV.png', 'reborn-uk-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/827986.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-ufc-247-8k-reborn', '┃UK┃ UFC 24/7 8K', 'http://picon.tivi-ott.net:25461/picon/USA/ufc.png', 'reborn-uk-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/828041.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-wwe-8k-reborn', '┃UK┃ WWE 8K', 'http://picon.tivi-ott.net:25461/picon/TURKEY/wwe-network.png', 'reborn-uk-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/828042.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-1-fhd-reborn', '┃FR┃ BEIN SPORTS 1 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941417.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-1-hd-reborn', '┃FR┃ BEIN SPORTS 1 HD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941418.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-1-reborn', '┃FR┃ BEIN SPORTS 1', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941419.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-2-fhd-reborn', '┃FR┃ BEIN SPORTS 2 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941420.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-2-hd-reborn', '┃FR┃ BEIN SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941421.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-2-reborn', '┃FR┃ BEIN SPORTS 2', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941422.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-3-fhd-reborn', '┃FR┃ BEIN SPORTS 3 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS 3.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941423.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-3-hd-reborn', '┃FR┃ BEIN SPORTS 3 HD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS 3.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941424.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-3-reborn', '┃FR┃ BEIN SPORTS 3', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS 3.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941425.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-max-4-fhd-reborn', '┃FR┃ BEIN SPORTS MAX 4 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS MAX 4.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941426.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-max-5-fhd-reborn', '┃FR┃ BEIN SPORTS MAX 5 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS MAX 5.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941427.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-max-6-fhd-reborn', '┃FR┃ BEIN SPORTS MAX 6 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS MAX 6.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941428.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-max-7-fhd-reborn', '┃FR┃ BEIN SPORTS MAX 7 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS MAX 7.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941429.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-max-8-fhd-reborn', '┃FR┃ BEIN SPORTS MAX 8 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS MAX 8.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941430.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-max-9-fhd-reborn', '┃FR┃ BEIN SPORTS MAX 9 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS MAX 9.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941431.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'fr-bein-sports-max-10-fhd-reborn', '┃FR┃ BEIN SPORTS MAX 10 FHD', 'http://picon.tivi-ott.net:25461/picon/France/FR BEIN SPORTS/BEIN SPORTS MAX 10.png', 'reborn-fr-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/941432.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-en-live-reborn', '☰☰☰☰ ┃UK┃ BEIN SPORTS EN LIVE ☰☰☰☰', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313532.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-en-fhd-reborn', '┃UK┃ BEIN SPORTS 1 EN FHD', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313533.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-en-fhd-reborn', '┃UK┃ BEIN SPORTS 2 EN FHD', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313534.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-en-fhd-hevc-reborn', '┃UK┃ BEIN SPORTS 1 EN FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313535.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-en-fhd-hevc-reborn', '┃UK┃ BEIN SPORTS 2 EN FHD HEVC', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313536.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-en-hd-reborn', '┃UK┃ BEIN SPORTS 1 EN HD', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313537.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-en-hd-reborn', '┃UK┃ BEIN SPORTS 2 EN HD', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313538.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-en-sd-reborn', '┃UK┃ BEIN SPORTS 1 EN SD', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313539.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-en-sd-reborn', '┃UK┃ BEIN SPORTS 2 EN SD', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313540.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-uk-bein-sports-en-4k-match-time-reborn', '┃UK┃ ☰☰☰☰ ┃UK┃ BEIN SPORTS EN 4K (MATCH TIME) ☰☰☰☰', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313541.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-4k-en-fhd-match-time-reborn', '┃UK┃ BEIN SPORTS 1 4K EN FHD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313559.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-ein-sports-2-4k-en-fhd-match-time-reborn', '┃UK┃ EIN SPORTS 2 4K EN FHD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313560.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-4k-en-hevc-fhd-match-time-reborn', '┃UK┃ BEIN SPORTS 1 4K EN HEVC FHD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313561.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-4k-en-hevc-fhd-match-time-reborn', '┃UK┃ BEIN SPORTS 2 4K EN HEVC FHD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313562.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-4k-en-hd-match-time-reborn', '┃UK┃ BEIN SPORTS 1 4K EN HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313563.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-4k-en-hd-match-time-reborn', '┃UK┃ BEIN SPORTS 2 4K EN HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313564.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-4k-en-sd-match-time-reborn', '┃UK┃ BEIN SPORTS 1 4K EN SD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313565.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-4k-en-sd-match-time-reborn', '┃UK┃ BEIN SPORTS 2 4K EN SD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313566.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-uk-bein-sports-en-uhd-match-time-reborn', '┃UK┃ ☰☰☰☰ ┃UK┃ BEIN SPORTS EN UHD (MATCH TIME) ☰☰☰☰', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313550.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-uhd-en-fhd-match-time-reborn', '┃UK┃ BEIN SPORTS 1 UHD EN FHD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313567.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-uhd-en-fhd-match-time-reborn', '┃UK┃ BEIN SPORTS 2 UHD EN FHD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313568.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-uhd-en-hevc-match-time-reborn', '┃UK┃ BEIN SPORTS 1 UHD EN HEVC (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313569.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-uhd-en-hevc-match-time-reborn', '┃UK┃ BEIN SPORTS 2 UHD EN HEVC (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313570.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-uhd-en-hd-match-time-reborn', '┃UK┃ BEIN SPORTS 1 UHD EN HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313571.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-uhd-en-hd-match-time-reborn', '┃UK┃ BEIN SPORTS 2 UHD EN HD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313572.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-1-uhd-en-sd-match-time-reborn', '┃UK┃ BEIN SPORTS 1 UHD EN SD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 1.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313573.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-bein-sports-2-uhd-en-sd-match-time-reborn', '┃UK┃ BEIN SPORTS 2 UHD EN SD (MATCH TIME)', 'http://picon.tivi-ott.net:25461/picon/UK/UK BEIN SPORTS/BEIN SPORTS 2.png', 'reborn-uk-bein-sports', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1313574.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-variety-1-hd-reborn', '┃UK┃ SUPERSPORT VARIETY 1 HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTVARIETY1.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396886.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-variety-2-hd-reborn', '┃UK┃ SUPERSPORT VARIETY 2 HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTVARIETY2.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396885.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-variety-3-hd-reborn', '┃UK┃ SUPERSPORT VARIETY 3 HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTVARIETY3.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396884.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-variety-4-hd-reborn', '┃UK┃ SUPERSPORT VARIETY 4 HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTVARIETY4.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396883.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-football-hd-reborn', '┃UK┃ SUPERSPORT FOOTBALL HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTFOOTBALL.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396882.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-premier-league-hd-reborn', '┃UK┃ SUPERSPORT PREMIER LEAGUE HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTPREMIERLEAGUE.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396881.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-la-liga-hd-reborn', '┃UK┃ SUPERSPORT LA LIGA HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTLALIGA.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396880.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-tennis-hd-reborn', '┃UK┃ SUPERSPORT TENNIS HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTTENNIS.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396878.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-rugby-hd-reborn', '┃UK┃ SUPERSPORT RUGBY HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTRUGBY.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396877.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-cricket-hd-reborn', '┃UK┃ SUPERSPORT CRICKET HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTCRICKET.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396876.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-golf-hd-reborn', '┃UK┃ SUPERSPORT GOLF HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTGOLF.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396875.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-motorsport-hd-reborn', '┃UK┃ SUPERSPORT MOTORSPORT HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/supersport.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396874.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-blitz-hd-reborn', '┃UK┃ SUPERSPORT BLITZ HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTBLITZ.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396873.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-maximo-1-reborn', '┃UK┃ SUPERSPORT MAXIMO 1', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTMAXIMO1.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396872.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-play-1-hd-reborn', '┃UK┃ SUPERSPORT PLAY 1 HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/supersport.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396871.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-grandstand-hd-reborn', '┃UK┃ SUPERSPORT GRANDSTAND HD', 'http://picon.tivi-ott.net:25461/picon/UK/SUPERSPORTGRANDSTAND.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396870.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-psl-hd-reborn', '┃UK┃ SUPERSPORT PSL HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/supersport.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396869.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-supersport-action-hd-reborn', '┃UK┃ SUPERSPORT ACTION HD', 'http://picon.tivi-ott.net:25461/picon/CANADA/supersport.png', 'reborn-uk-supersport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/396868.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-tnt-sports-hd-reborn', '☰☰☰☰ ┃UK┃ TNT SPORTS HD ☰☰☰☰', 'http://picon.tivi-ott.net:25461/picon/UK/TNT SPORTS/TNT SPORTS.png', 'reborn-uk-tnt-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1174235.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-tnt-sports-1-hd-reborn', '┃UK┃ TNT SPORTS 1 HD', 'http://picon.tivi-ott.net:25461/picon/UK/TNT SPORTS/TNT SPORTS.png', 'reborn-uk-tnt-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1174236.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-tnt-sports-2-hd-reborn', '┃UK┃ TNT SPORTS 2 HD', 'http://picon.tivi-ott.net:25461/picon/UK/TNT SPORTS/TNT SPORTS.png', 'reborn-uk-tnt-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1174237.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-tnt-sports-3-hd-reborn', '┃UK┃ TNT SPORTS 3 HD', 'http://picon.tivi-ott.net:25461/picon/UK/TNT SPORTS/TNT SPORTS.png', 'reborn-uk-tnt-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1174238.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'uk-tnt-sports-4-hd-reborn', '┃UK┃ TNT SPORTS 4 HD', 'http://picon.tivi-ott.net:25461/picon/UK/TNT SPORTS/TNT SPORTS.png', 'reborn-uk-tnt-sports-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1174239.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-news-hd-reborn', '┃DE┃ SKY SPORT NEWS HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT NEWS.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149457.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-top-event-hd-reborn', '┃DE┃ SKY SPORT TOP EVENT HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT TOP EVENT.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149460.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-premier-league-hd-reborn', '┃DE┃ SKY SPORT PREMIER LEAGUE HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT PREMIER LEAGUE.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149458.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-f1-hd-reborn', '┃DE┃ SKY SPORT F1 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT F1.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149474.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-mix-hd-reborn', '┃DE┃ SKY SPORT MIX HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT MIX.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149456.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-tennis-hd-reborn', '┃DE┃ SKY SPORT TENNIS HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT TENNIS.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149459.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-golf-hd-reborn', '┃DE┃ SKY SPORT GOLF HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT GOLF.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149454.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-1-hd-reborn', '┃DE┃ SKY SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 1.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149461.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-2-hd-reborn', '┃DE┃ SKY SPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 2.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149462.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-3-hd-reborn', '┃DE┃ SKY SPORT 3 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 3.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149463.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-4-hd-reborn', '┃DE┃ SKY SPORT 4 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 4.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149464.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-5-hd-reborn', '┃DE┃ SKY SPORT 5 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 5.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149465.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-6-hd-reborn', '┃DE┃ SKY SPORT 6 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 6.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149466.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-7-hd-reborn', '┃DE┃ SKY SPORT 7 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 7.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149467.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-8-hd-reborn', '┃DE┃ SKY SPORT 8 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 8.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149468.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-9-hd-reborn', '┃DE┃ SKY SPORT 9 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 9.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149469.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sky-sport-10-hd-reborn', '┃DE┃ SKY SPORT 10 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SKY SPORT/SKY SPORT 10.png', 'reborn-de-sky-sport-hd', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149470.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-ms-golf-1-fhd-reborn', '┃DE┃ MS GOLF 1 FHD', 'https://image.allinonereborn.workers.dev/image/9ebfed7a-df6d-44d0-aaba-318247014d05.jpg', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1571540.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-ms-golf-2-fhd-reborn', '┃DE┃ MS GOLF 2 FHD', 'https://image.allinonereborn.workers.dev/image/9ebfed7a-df6d-44d0-aaba-318247014d05.jpg', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1571541.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-eurosport-1-fhd-reborn', '┃DE┃ EUROSPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/EUROSPORT 1.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/760961.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-eurosport-1-hd-reborn', '┃DE┃ EUROSPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/EUROSPORT 1.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149499.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-eurosport-2-fhd-reborn', '┃DE┃ EUROSPORT 2 FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/EUROSPORT 2.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/760962.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-eurosport-2-hd-reborn', '┃DE┃ EUROSPORT 2 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/EUROSPORT 2.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149500.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sportdigital-fhd-reborn', '┃DE┃ SPORTDIGITAL FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORTDIGITAL.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149507.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sportdigital-hd-reborn', '┃DE┃ SPORTDIGITAL HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORTDIGITAL.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149506.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sport-digital-fussball-fhd-reborn', '┃DE┃ SPORT DIGITAL FUSSBALL FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORT DIGITAL FUSSBALL.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/760963.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sport-digital-fussball-hd-reborn', '┃DE┃ SPORT DIGITAL FUSSBALL HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORT DIGITAL FUSSBALL.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149501.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sportdigital-1-fhd-reborn', '┃DE┃ SPORTDIGITAL +1 FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORTDIGIAL +1.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/760965.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sportdigial-1-hd-reborn', '┃DE┃ SPORTDIGIAL +1 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORTDIGIAL +1.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149505.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sportdigital-edge-fhd-reborn', '┃DE┃ SPORTDIGITAL EDGE FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORTDIGITAL EDGE.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/760968.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sportdigital-edge-hd-reborn', '┃DE┃ SPORTDIGITAL EDGE HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORTDIGITAL EDGE.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149508.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-servus-tv-motorsport-fhd-reborn', '┃DE┃ SERVUS TV MOTORSPORT FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SERVUS TV MOTORSPORT.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/761092.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-servus-tv-motorsport-hd-reborn', '┃DE┃ SERVUS TV MOTORSPORT HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SERVUS TV MOTORSPORT.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149502.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-ms-sport-fhd-reborn', '┃DE┃ MS SPORT FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/MS SPORT.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/761090.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-ms-sport-hd-reborn', '┃DE┃ MS SPORT HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/MS SPORT.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149503.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sport-1-fhd-reborn', '┃DE┃ SPORT 1 FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORT 1.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/760964.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-sport-1-hd-reborn', '┃DE┃ SPORT 1 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/SPORT 1.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149504.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-motorvision-tv-fhd-reborn', '┃DE┃ MOTORVISION TV FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/MOTORVISION TV.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/760966.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-auto-motor-sport-channel-fhd-reborn', '┃DE┃ AUTO MOTOR SPORT CHANNEL FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/AUTO MOTOR SPORT CHANNEL.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/760967.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-auto-motor-und-sport-hd-reborn', '┃DE┃ AUTO MOTOR UND SPORT HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/AUTO MOTOR UND SPORT.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149509.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-more-than-sports-fhd-reborn', '┃DE┃ MORE THAN SPORTS FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/MORE THAN SPORTS.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/761079.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-more-than-sports-hd-reborn', '┃DE┃ MORE THAN SPORTS HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/MORE THAN SPORTS.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149510.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-red-bull-tv-fhd-reborn', '┃DE┃ RED BULL TV FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/RED BULL TV.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/761080.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-red-bull-tv-hd-reborn', '┃DE┃ RED BULL TV HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/RED BULL TV.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1149511.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-esports-1-fhd-reborn', '┃DE┃ ESPORTS 1 FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/ESPORTS 1.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/760969.m3u8', '{}'::jsonb, true, NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-clip-my-horsetv-fhd-reborn', '┃DE┃ CLIP MY HORSE.TV FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/CLIP MY HORSE.TV.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/761037.m3u8', '{}'::jsonb, true, NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-horse-country-tv-fhd-reborn', '┃DE┃ HORSE & COUNTRY TV FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/SPORT/HORSE & COUNTRY TV.png', 'reborn-de-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/761096.m3u8', '{}'::jsonb, true, NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-1-reborn', '┃NL┃ HBO MAX SPORT 1 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859415.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-2-reborn', '┃NL┃ HBO MAX SPORT 2 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859414.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-3-reborn', '┃NL┃ HBO MAX SPORT 3 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859413.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-4-reborn', '┃NL┃ HBO MAX SPORT 4 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859412.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-5-reborn', '┃NL┃ HBO MAX SPORT 5 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859411.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-6-reborn', '┃NL┃ HBO MAX SPORT 6 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859410.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-7-reborn', '┃NL┃ HBO MAX SPORT 7 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859409.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-8-reborn', '┃NL┃ HBO MAX SPORT 8 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859408.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-9-reborn', '┃NL┃ HBO MAX SPORT 9 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859407.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-10-reborn', '┃NL┃ HBO MAX SPORT 10 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859406.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-11-reborn', '┃NL┃ HBO MAX SPORT 11 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859405.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-12-reborn', '┃NL┃ HBO MAX SPORT 12 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859404.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-13-reborn', '┃NL┃ HBO MAX SPORT 13 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859403.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-14-reborn', '┃NL┃ HBO MAX SPORT 14 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859402.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-15-reborn', '┃NL┃ HBO MAX SPORT 15 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859401.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-16-reborn', '┃NL┃ HBO MAX SPORT 16 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859400.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-17-reborn', '┃NL┃ HBO MAX SPORT 17 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859399.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-18-reborn', '┃NL┃ HBO MAX SPORT 18 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859398.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-19-reborn', '┃NL┃ HBO MAX SPORT 19 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859397.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-20-reborn', '┃NL┃ HBO MAX SPORT 20 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859396.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-21-reborn', '┃NL┃ HBO MAX SPORT 21 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859395.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-22-reborn', '┃NL┃ HBO MAX SPORT 22 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859394.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-23-reborn', '┃NL┃ HBO MAX SPORT 23 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859393.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-24-reborn', '┃NL┃ HBO MAX SPORT 24 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859392.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-25-reborn', '┃NL┃ HBO MAX SPORT 25 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859391.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-26-reborn', '┃NL┃ HBO MAX SPORT 26 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859390.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-27-reborn', '┃NL┃ HBO MAX SPORT 27 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859389.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-28-reborn', '┃NL┃ HBO MAX SPORT 28 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859388.m3u8', '{}'::jsonb, true, NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-29-reborn', '┃NL┃ HBO MAX SPORT 29 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859387.m3u8', '{}'::jsonb, true, NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-30-reborn', '┃NL┃ HBO MAX SPORT 30 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859386.m3u8', '{}'::jsonb, true, NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-31-reborn', '┃NL┃ HBO MAX SPORT 31 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859385.m3u8', '{}'::jsonb, true, NULL, 31
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-32-reborn', '┃NL┃ HBO MAX SPORT 32 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859384.m3u8', '{}'::jsonb, true, NULL, 32
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-33-reborn', '┃NL┃ HBO MAX SPORT 33 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859383.m3u8', '{}'::jsonb, true, NULL, 33
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-34-reborn', '┃NL┃ HBO MAX SPORT 34 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859382.m3u8', '{}'::jsonb, true, NULL, 34
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-35-reborn', '┃NL┃ HBO MAX SPORT 35 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859381.m3u8', '{}'::jsonb, true, NULL, 35
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-36-reborn', '┃NL┃ HBO MAX SPORT 36 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859380.m3u8', '{}'::jsonb, true, NULL, 36
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-37-reborn', '┃NL┃ HBO MAX SPORT 37 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859379.m3u8', '{}'::jsonb, true, NULL, 37
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-38-reborn', '┃NL┃ HBO MAX SPORT 38 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859378.m3u8', '{}'::jsonb, true, NULL, 38
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-39-reborn', '┃NL┃ HBO MAX SPORT 39 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859377.m3u8', '{}'::jsonb, true, NULL, 39
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-40-reborn', '┃NL┃ HBO MAX SPORT 40 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859376.m3u8', '{}'::jsonb, true, NULL, 40
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-41-reborn', '┃NL┃ HBO MAX SPORT 41 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859375.m3u8', '{}'::jsonb, true, NULL, 41
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-42-reborn', '┃NL┃ HBO MAX SPORT 42 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859374.m3u8', '{}'::jsonb, true, NULL, 42
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-43-reborn', '┃NL┃ HBO MAX SPORT 43 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859373.m3u8', '{}'::jsonb, true, NULL, 43
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-44-reborn', '┃NL┃ HBO MAX SPORT 44 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859372.m3u8', '{}'::jsonb, true, NULL, 44
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-45-reborn', '┃NL┃ HBO MAX SPORT 45 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859371.m3u8', '{}'::jsonb, true, NULL, 45
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-46-reborn', '┃NL┃ HBO MAX SPORT 46 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859370.m3u8', '{}'::jsonb, true, NULL, 46
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-47-reborn', '┃NL┃ HBO MAX SPORT 47 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859369.m3u8', '{}'::jsonb, true, NULL, 47
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-48-reborn', '┃NL┃ HBO MAX SPORT 48 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859368.m3u8', '{}'::jsonb, true, NULL, 48
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-49-reborn', '┃NL┃ HBO MAX SPORT 49 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859367.m3u8', '{}'::jsonb, true, NULL, 49
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hbo-max-sport-50-reborn', '┃NL┃ HBO MAX SPORT 50 |', 'http://picon.tivi-ott.net:25461/picon/MIX/HBO%20max.png', 'reborn-nl-max-sport', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/859366.m3u8', '{}'::jsonb, true, NULL, 50
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-espn-8k-uhd-reborn', '┃NL┃ ESPN 8K UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ESPNHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/92512.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-espn-1-8k-reborn', '┃NL┃ ESPN 1 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ESPNHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237593.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-espn-2-8k-reborn', '┃NL┃ ESPN 2 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ESPNHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237594.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-espn-3-8k-reborn', '┃NL┃ ESPN 3 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ESPNHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237595.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-espn-4-8k-reborn', '┃NL┃ ESPN 4 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ESPNHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237596.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-1-8k-reborn', '┃NL┃ ZIGGO SPORT 1 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTSELECTHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237598.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-2-8k-reborn', '┃NL┃ ZIGGO SPORT 2 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTVOETBALHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237599.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-3-8k-reborn', '┃NL┃ ZIGGO SPORT 3 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTGOLFHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237601.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-4-8k-reborn', '┃NL┃ ZIGGO SPORT 4 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTRACINGHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237600.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-5-8k-reborn', '┃NL┃ ZIGGO SPORT 5 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTDOCUHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237602.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-6-8k-reborn', '┃NL┃ ZIGGO SPORT 6 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTTENNISHD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237603.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-eurosport-1-8k-reborn', '┃NL┃ EUROSPORT 1 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/EUROSPORT1HD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237604.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-eurosport-2-8k-reborn', '┃NL┃ EUROSPORT 2 8K', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/EUROSPORT2HD.png', 'reborn-nl-sport-tv', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/237605.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-npo-1-8k-uhd-reborn', '┃NL┃ NPO 1  8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NPO1HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392166.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-npo-2-8k-uhd-reborn', '┃NL┃ NPO 2  8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NPO2HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392164.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-npo-3-8k-uhd-reborn', '┃NL┃ NPO 3 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NPO3HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392162.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtl-4-8k-uhd-reborn', '┃NL┃ RTL 4 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTL4HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392151.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtl-5-8k-uhd-reborn', '┃NL┃ RTL 5 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTL5HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392150.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-sbs-6-8k-uhd-reborn', '┃NL┃ SBS 6 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/SBS6HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392136.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtl-7-8k-uhd-reborn', '┃NL┃ RTL 7 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTL7HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392149.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtl-8-8k-uhd-reborn', '┃NL┃ RTL 8 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTL8HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392148.m3u8', '{}'::jsonb, true, NULL, 8
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-sbs-9-8k-uhd-reborn', '┃NL┃ SBS 9  8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/SBS9HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392135.m3u8', '{}'::jsonb, true, NULL, 9
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-viaplay-tv-8k-uhd-reborn', '┃NL┃ VIAPLAY TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/VIAPLAY TV.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1152827.m3u8', '{}'::jsonb, true, NULL, 10
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-net-5-8k-uhd-reborn', '┃NL┃ NET 5 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NET5HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392173.m3u8', '{}'::jsonb, true, NULL, 11
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtl-z-8k-uhd-reborn', '┃NL┃ RTL Z 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTLZHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392144.m3u8', '{}'::jsonb, true, NULL, 12
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-veronica-dinseyxd-8k-uhd-reborn', '┃NL┃ VERONICA / DINSEYXD 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/VERONICAHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392124.m3u8', '{}'::jsonb, true, NULL, 13
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-npo-1-extra-8k-uhd-reborn', '┃NL┃ NPO 1 EXTRA 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NPO1EXTRAHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392165.m3u8', '{}'::jsonb, true, NULL, 14
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-npo-2-extra-8k-uhd-reborn', '┃NL┃ NPO 2 EXTRA 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NPO2EXTRAHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392163.m3u8', '{}'::jsonb, true, NULL, 15
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-npo-politiek-en-nieuws-8k-uhd-reborn', '┃NL┃ NPO POLITIEK EN NIEUWS 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NPOPOLITIEKENNIEUWSHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392161.m3u8', '{}'::jsonb, true, NULL, 16
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-nickelodeon-8k-uhd-reborn', '┃NL┃ NICKELODEON 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NICKELODEONHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392168.m3u8', '{}'::jsonb, true, NULL, 17
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-nick-toons-8k-uhd-reborn', '┃NL┃ NICK TOONS 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NICKTOONSHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392167.m3u8', '{}'::jsonb, true, NULL, 18
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-nick-jr-8k-uhd-reborn', '┃NL┃ NICK JR. 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NICKJRHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392170.m3u8', '{}'::jsonb, true, NULL, 19
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-disney-channel-8k-uhd-reborn', '┃NL┃ DISNEY CHANNEL 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/DISNEYHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392206.m3u8', '{}'::jsonb, true, NULL, 20
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-cartoon-network-8k-uhd-reborn', '┃NL┃ CARTOON NETWORK 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/CNHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392217.m3u8', '{}'::jsonb, true, NULL, 21
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-cartoonito-8k-uhd-reborn', '┃NL┃ CARTOONITO 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/CARTOONITO.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392216.m3u8', '{}'::jsonb, true, NULL, 22
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtl-telekids-8k-uhd-reborn', '┃NL┃ RTL TELEKIDS 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTLTELEKIDSHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392145.m3u8', '{}'::jsonb, true, NULL, 23
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-pebble-tv-8k-uhd-reborn', '┃NL┃ PEBBLE TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/PEBBLETVHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392152.m3u8', '{}'::jsonb, true, NULL, 24
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-baby-tv-8k-uhd-reborn', '┃NL┃ BABY TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/BABYTVHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392224.m3u8', '{}'::jsonb, true, NULL, 25
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-duck-8k-tv-uhd-reborn', '┃NL┃ DUCK 8K+ TV UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/DUCKTVHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392230.m3u8', '{}'::jsonb, true, NULL, 26
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-moonbug-8k-uhd-reborn', '┃NL┃ MOONBUG 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/MOONBUG.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1152811.m3u8', '{}'::jsonb, true, NULL, 27
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-film1-premiere-8k-uhd-reborn', '┃NL┃ FILM1 PREMIERE 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/FILMPREMIEREHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392191.m3u8', '{}'::jsonb, true, NULL, 28
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-film1-action-8k-uhd-reborn', '┃NL┃ FILM1 ACTION 8K+  UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/FILMACTIONHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392194.m3u8', '{}'::jsonb, true, NULL, 29
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-film1-family-8k-uhd-reborn', '┃NL┃ FILM1 FAMILY 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/FILMFAMILYHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392192.m3u8', '{}'::jsonb, true, NULL, 30
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-film1-drama-8k-uhd-reborn', '┃NL┃ FILM1 DRAMA 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/FILMDRAMAHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392193.m3u8', '{}'::jsonb, true, NULL, 31
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-filmbox-8k-uhd-reborn', '┃NL┃ FILMBOX 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/FILMBOXHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392190.m3u8', '{}'::jsonb, true, NULL, 32
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-mtv-8k-uhd-reborn', '┃NL┃ MTV  8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/MTVHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392182.m3u8', '{}'::jsonb, true, NULL, 33
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-e-entertainment-8k-uhd-reborn', '┃NL┃ E! ENTERTAINMENT 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ENTERTAINMENTHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392204.m3u8', '{}'::jsonb, true, NULL, 34
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-star-channel-8k-uhd-reborn', '┃NL┃ STAR CHANNEL 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/FOXHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392189.m3u8', '{}'::jsonb, true, NULL, 35
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtl-lounge-8k-uhd-reborn', '┃NL┃ RTL LOUNGE 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTLLOUNGEHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392146.m3u8', '{}'::jsonb, true, NULL, 36
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtl-crime-8k-uhd-reborn', '┃NL┃ RTL CRIME 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTLCRIMEHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392147.m3u8', '{}'::jsonb, true, NULL, 37
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-comedy-central-8k-uhd-reborn', '┃NL┃ COMEDY CENTRAL 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/COMEDYCENTRALHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392213.m3u8', '{}'::jsonb, true, NULL, 38
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-paramount-network-8k-uhd-reborn', '┃NL┃ PARAMOUNT NETWORK 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/PARAMOUNTHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392153.m3u8', '{}'::jsonb, true, NULL, 39
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-curiosity-channel-8k-uhd-reborn', '┃NL┃ CURIOSITY CHANNEL 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/CURIOSITY.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392211.m3u8', '{}'::jsonb, true, NULL, 40
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-bbc-nl-8k-uhd-reborn', '┃NL┃ BBC NL 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/BBCFIRSTHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392222.m3u8', '{}'::jsonb, true, NULL, 41
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-out-tv-8k-uhd-reborn', '┃NL┃ OUT TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/OUTTVHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392154.m3u8', '{}'::jsonb, true, NULL, 42
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-shorts-tv-8k-uhd-reborn', '┃NL┃ SHORTS TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/SHORTSTVHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392133.m3u8', '{}'::jsonb, true, NULL, 43
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-espn-1-8k-uhd-reborn', '┃NL┃ ESPN 1 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ESPNHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392203.m3u8', '{}'::jsonb, true, NULL, 44
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-espn-2-8k-uhd-reborn', '┃NL┃ ESPN 2 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ESPNHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392202.m3u8', '{}'::jsonb, true, NULL, 45
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-espn-3-8k-uhd-reborn', '┃NL┃ ESPN 3 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ESPNHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392201.m3u8', '{}'::jsonb, true, NULL, 46
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-espn-4-8k-uhd-reborn', '┃NL┃ ESPN 4 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ESPNHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392200.m3u8', '{}'::jsonb, true, NULL, 47
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-8k-uhd-reborn', '┃NL┃ ZIGGO SPORT  8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392231.m3u8', '{}'::jsonb, true, NULL, 48
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-2-8k-uhd-reborn', '┃NL┃ ZIGGO SPORT 2 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTVOETBALHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392115.m3u8', '{}'::jsonb, true, NULL, 49
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-3-8k-uhd-reborn', '┃NL┃ ZIGGO SPORT 3 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTGOLFHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392120.m3u8', '{}'::jsonb, true, NULL, 50
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-4-8k-uhd-reborn', '┃NL┃ ZIGGO SPORT 4 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTRACINGHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392119.m3u8', '{}'::jsonb, true, NULL, 51
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-5-8k-uhd-reborn', '┃NL┃ ZIGGO SPORT 5 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTDOCUHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392121.m3u8', '{}'::jsonb, true, NULL, 52
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ziggo-sport-6-8k-uhd-reborn', '┃NL┃ ZIGGO SPORT 6 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ZIGGOSPORTTENNISHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392117.m3u8', '{}'::jsonb, true, NULL, 53
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-eurosport-1-8k-uhd-reborn', '┃NL┃ EUROSPORT 1 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/EUROSPORT1HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392198.m3u8', '{}'::jsonb, true, NULL, 54
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-eurosport-2-8k-uhd-reborn', '┃NL┃ EUROSPORT 2 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/EUROSPORT2HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392197.m3u8', '{}'::jsonb, true, NULL, 55
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-top40-tv-8k-uhd-reborn', '┃NL┃ TOP40 TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/TOP40 TV.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1152815.m3u8', '{}'::jsonb, true, NULL, 56
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-slamtv-8k-uhd-reborn', '┃NL┃ SLAM!TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/SLAMHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392132.m3u8', '{}'::jsonb, true, NULL, 57
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-tv538-8k-uhd-reborn', '┃NL┃ TV538 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/TV538HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392126.m3u8', '{}'::jsonb, true, NULL, 58
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-xite-8k-uhd-reborn', '┃NL┃ XITE 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/XITEHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392122.m3u8', '{}'::jsonb, true, NULL, 59
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-tv-oranje-8k-uhd-reborn', '┃NL┃ TV ORANJE 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/TVORANJEHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392125.m3u8', '{}'::jsonb, true, NULL, 60
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-100-nl-tv-8k-uhd-reborn', '┃NL┃ 100% NL TV  8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RADIO100NLHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392229.m3u8', '{}'::jsonb, true, NULL, 61
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-192tv-8k-uhd-reborn', '┃NL┃ 192TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/192TVHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392228.m3u8', '{}'::jsonb, true, NULL, 62
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-ons-8k-uhd-reborn', '┃NL┃ ONS 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ONSHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392160.m3u8', '{}'::jsonb, true, NULL, 63
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-dance-television-8k-uhd-reborn', '┃NL┃ DANCE TELEVISION 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/DANCETRIPPINHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392210.m3u8', '{}'::jsonb, true, NULL, 64
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-stingray-lite-tv-8k-uhd-reborn', '┃NL┃ STINGRAY LITE TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/LITETVSTINGRAYHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392128.m3u8', '{}'::jsonb, true, NULL, 65
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-stingray-djazz-8k-uhd-reborn', '┃NL┃ STINGRAY DJAZZ 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/DJAZZSTINGRAYHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392130.m3u8', '{}'::jsonb, true, NULL, 66
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-stingray-classica-8k-uhd-reborn', '┃NL┃ STINGRAY CLASSICA 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/ROMANIA/Stingray_Classica.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392131.m3u8', '{}'::jsonb, true, NULL, 67
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-mezzo-8k-uhd-reborn', '┃NL┃ MEZZO 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/MEZZOHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392183.m3u8', '{}'::jsonb, true, NULL, 68
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-nat-geo-8k-uhd-reborn', '┃NL┃ NAT GEO 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NATIONALGEOGRAPHICHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392175.m3u8', '{}'::jsonb, true, NULL, 69
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-nat-geo-wild-8k-uhd-reborn', '┃NL┃ NAT GEO WILD 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NGWILDHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392174.m3u8', '{}'::jsonb, true, NULL, 70
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-discovery-channel-8k-uhd-reborn', '┃NL┃ DISCOVERY CHANNEL 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/DISCOVERYCHANNELHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392209.m3u8', '{}'::jsonb, true, NULL, 71
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-discovery-science-8k-uhd-reborn', '┃NL┃ DISCOVERY SCIENCE 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/DISCOVERYSCIENCEHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392207.m3u8', '{}'::jsonb, true, NULL, 72
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-id-8k-uhd-reborn', '┃NL┃ ID 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/INVESTIGATIONDISCOVERYHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392208.m3u8', '{}'::jsonb, true, NULL, 73
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-crime-investigation-8k-uhd-reborn', '┃NL┃ CRIME+ INVESTIGATION 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/CRIMEINVESTIGATION.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392212.m3u8', '{}'::jsonb, true, NULL, 74
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-history-8k-uhd-reborn', '┃NL┃ HISTORY 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/HISTORYHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392188.m3u8', '{}'::jsonb, true, NULL, 75
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-animal-planet-8k-uhd-reborn', '┃NL┃ ANIMAL PLANET 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/ANIMALPLANETHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392226.m3u8', '{}'::jsonb, true, NULL, 76
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-love-nature-8k-uhd-reborn', '┃NL┃ LOVE NATURE 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/LOVENATUREHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392184.m3u8', '{}'::jsonb, true, NULL, 77
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-tlc-8k-uhd-reborn', '┃NL┃ TLC 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/TLCHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392127.m3u8', '{}'::jsonb, true, NULL, 78
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-hgtv-8k-uhd-reborn', '┃NL┃ HGTV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NL NEDERLAND 8K+ UHD/HGTV 8K+ UHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/724979.m3u8', '{}'::jsonb, true, NULL, 79
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-24kitchen-8k-uhd-reborn', '┃NL┃ 24KITCHEN 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/24KITCHENHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392227.m3u8', '{}'::jsonb, true, NULL, 80
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-family7-8k-uhd-reborn', '┃NL┃ FAMILY7 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/FAMILY7HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392196.m3u8', '{}'::jsonb, true, NULL, 81
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-horse-country-8k-uhd-reborn', '┃NL┃ HORSE & COUNTRY 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/HCHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392187.m3u8', '{}'::jsonb, true, NULL, 82
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-fashion-tv-8k-uhd-reborn', '┃NL┃ FASHION TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/FASHIONTVHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392195.m3u8', '{}'::jsonb, true, NULL, 83
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-my-zen-8k-uhd-reborn', '┃NL┃ MY ZEN 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/MYZENHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392176.m3u8', '{}'::jsonb, true, NULL, 84
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-at5-8k-uhd-reborn', '┃NL┃ AT5 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/AT5HD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392225.m3u8', '{}'::jsonb, true, NULL, 85
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-twee-tv-8k-uhd-reborn', '┃NL┃ TWEE TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/TWEE TV.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1152823.m3u8', '{}'::jsonb, true, NULL, 86
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtv-utrecht-8k-uhd-reborn', '┃NL┃ RTV UTRECHT 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTVUTRECHTHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392139.m3u8', '{}'::jsonb, true, NULL, 87
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-l1-tv-8k-uhd-reborn', '┃NL┃ L1 TV 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/LIMBURGHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392185.m3u8', '{}'::jsonb, true, NULL, 88
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtv-noord-8k-uhd-reborn', '┃NL┃ RTV NOORD 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTVNOORDHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392142.m3u8', '{}'::jsonb, true, NULL, 89
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-nh-nieuws-8k-uhd-reborn', '┃NL┃ NH NIEUWS 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/NHNIEWSHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392171.m3u8', '{}'::jsonb, true, NULL, 90
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtv-rijnmond-8k-uhd-reborn', '┃NL┃ RTV RIJNMOND 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RIJNMONDHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392140.m3u8', '{}'::jsonb, true, NULL, 91
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-omroep-gelderland-8k-uhd-reborn', '┃NL┃ OMROEP GELDERLAND 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/OMROEPGLDHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392157.m3u8', '{}'::jsonb, true, NULL, 92
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtv-oost-8k-uhd-reborn', '┃NL┃ RTV OOST 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTVOOSTHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392141.m3u8', '{}'::jsonb, true, NULL, 93
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtv-west-8k-uhd-reborn', '┃NL┃ RTV WEST 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/WESTRADIOTVHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392138.m3u8', '{}'::jsonb, true, NULL, 94
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtv-drenthe-8k-uhd-reborn', '┃NL┃ RTV DRENTHE 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTVDRENTHEHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392143.m3u8', '{}'::jsonb, true, NULL, 95
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-omroep-brabant-8k-uhd-reborn', '┃NL┃ OMROEP BRABANT 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/OMROEPBRABANTHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392159.m3u8', '{}'::jsonb, true, NULL, 96
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-omrop-fryslan-8k-uhd-reborn', '┃NL┃ OMROP FRYSLAN 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/OMROPFRYSLANHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392155.m3u8', '{}'::jsonb, true, NULL, 97
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-omroep-flevoland-8k-uhd-reborn', '┃NL┃ OMROEP FLEVOLAND 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/OMREPFLEVOLAND.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392158.m3u8', '{}'::jsonb, true, NULL, 98
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-omroep-zeeland-8k-uhd-reborn', '┃NL┃ OMROEP ZEELAND 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/OMROEPZEELANDHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392156.m3u8', '{}'::jsonb, true, NULL, 99
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-rtv-7-8k-uhd-reborn', '┃NL┃ RTV-7 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/RTV7.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392137.m3u8', '{}'::jsonb, true, NULL, 100
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-bbc-one-8k-uhd-reborn', '┃NL┃ BBC ONE 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/BBCONEHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392220.m3u8', '{}'::jsonb, true, NULL, 101
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-bbc-two-8k-uhd-reborn', '┃NL┃ BBC TWO 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/BBCTWOHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392219.m3u8', '{}'::jsonb, true, NULL, 102
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-bbc-news-8k-uhd-reborn', '┃NL┃ BBC NEWS 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/UK/BBCNEWS.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392221.m3u8', '{}'::jsonb, true, NULL, 103
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'nl-cnn-8k-uhd-reborn', '┃NL┃ CNN 8K+ UHD', 'http://picon.tivi-ott.net:25461/picon/NEDERLAND/CNNHD.png', 'reborn-nl-ziggo-kabel', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/392214.m3u8', '{}'::jsonb, true, NULL, 104
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-fussballtv-1-fhd-reborn', '┃DE┃ FUSSBALL.TV 1 FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/┃DE┃ FUSSBALL.TV FIFA WM 2026/FUSSBALL.TV 1.png', 'reborn-de-fussballtv-fifa-wm-2026', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1745176.m3u8', '{}'::jsonb, true, NULL, 1
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-fussballtv-1-hd-reborn', '┃DE┃ FUSSBALL.TV 1 HD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/┃DE┃ FUSSBALL.TV FIFA WM 2026/FUSSBALL.TV 1.png', 'reborn-de-fussballtv-fifa-wm-2026', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1745177.m3u8', '{}'::jsonb, true, NULL, 2
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-fussballtv-2-fhd-reborn', '┃DE┃ FUSSBALL.TV 2 FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/┃DE┃ FUSSBALL.TV FIFA WM 2026/FUSSBALL.TV 2.png', 'reborn-de-fussballtv-fifa-wm-2026', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1745178.m3u8', '{}'::jsonb, true, NULL, 3
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-fussballtv-3-fhd-reborn', '┃DE┃ FUSSBALL.TV 3 FHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/┃DE┃ FUSSBALL.TV FIFA WM 2026/FUSSBALL.TV 3.png', 'reborn-de-fussballtv-fifa-wm-2026', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1745179.m3u8', '{}'::jsonb, true, NULL, 4
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-fussballtv-1-uhd-reborn', '┃DE┃ FUSSBALL.TV 1 UHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/┃DE┃ FUSSBALL.TV FIFA WM 2026/FUSSBALL.TV 1.png', 'reborn-de-fussballtv-fifa-wm-2026', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1745180.m3u8', '{}'::jsonb, true, NULL, 5
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-fussballtv-2-uhd-reborn', '┃DE┃ FUSSBALL.TV 2 UHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/┃DE┃ FUSSBALL.TV FIFA WM 2026/FUSSBALL.TV 2.png', 'reborn-de-fussballtv-fifa-wm-2026', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1745181.m3u8', '{}'::jsonb, true, NULL, 6
) ON CONFLICT (id) DO UPDATE SET 
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
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    'de-fussballtv-3-uhd-reborn', '┃DE┃ FUSSBALL.TV 3 UHD', 'http://picon.tivi-ott.net:25461/picon/GERMANY/┃DE┃ FUSSBALL.TV FIFA WM 2026/FUSSBALL.TV 3.png', 'reborn-de-fussballtv-fifa-wm-2026', true, 'HD', 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/spo-s5-n/1745182.m3u8', '{}'::jsonb, true, NULL, 7
) ON CONFLICT (id) DO UPDATE SET 
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

-- 3. Update app settings version
UPDATE app_settings SET channels_version = channels_version + 1, updated_at = now() WHERE id = 1;
