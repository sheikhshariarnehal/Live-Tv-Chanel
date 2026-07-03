
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-aq', 'FOX SPORTS - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/enc/ajfoeddkbz/out/v1/b78800b9b2304879b15843f455836829/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"f6564ec2aee819046328a0e153be574d","key":"ff46a8a1031eb27ef22576a077c98ab7"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-aq', 'TSN SPORTS - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/dash/enc/w0rehjjrwe/out/v1/69a2a7041395406b970598f61680e7cf/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"14eeabf30c14b7fbf3008c03099ce011","key":"17d2ac8dbc5429bd70af3433aa12158d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'd-sports-es-aq', 'D SPORTS ES - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/dash/enc/z5oyxzsxdk/out/v1/7695a0f64a0e424b973d5b09a2a3eb91/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"f836853d8eac19446ed9535f5fc568b1","key":"b3bc5ef00602b29abac7e482d3d9fbf3"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'ctv-sports-aq', 'CTV SPORTS - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/enc/72sjo8hygl/out/v1/3079be34d72a4985852d299a02406a0c/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"d185684e2330de5bea436daa094a5e86","key":"014f0116154f5bf0050e03a6b0a23157"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tipik-french-aq', 'TIPIK FRENCH - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://c9851ec-rbm-hilv-fsly.cdn.redbee.live/L26/6b640fa2/a765d074.isml/dash/.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"adca25b8779e4168a0cd710f59f61ccf","key":"be5383ed3cd8079f4ffe78ad067f476a"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'toffee-bd-aq', 'TOFFEE BD - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://prod-cdn01-live.toffeelive.com/live/FIFA-2026-3/sst/0/master_1500.m3u8?hdntl=Expires=1783035611~_GO=Generated~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=AeQsclDGnkPZWwPpikfIMknw6R1CLxOxhkOn8kXXxvEgAfubt5THGgG4mlQt3k3uDloYMUXw1b2k-pt0iK8Pn1tIVOYH', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'caztv-br-aq', 'CazéTV BR - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/dash/enc/iayg0kyrof/out/v1/91dc04907f56415b897faccfa9d252da/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"1223d5105392cabf1bb9c2c1fdf6539a","key":"340b409f4b8f78a343e0363a7938df38"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'rte-sports-aq', 'RTE SPORTS - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://dai.google.com/linear/dash/pa/event/oPeAYQs9T9yTHS98aR1EjQ/stream/a15f395f-f7d2-4728-8db4-ee96e5643dcb:GRQ/manifest.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"d816287e21496989eae1312925a423c5","key":"00da00f13180e7e6cd5ce87d1c974e8d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'vix-spanish-aq', 'VIX SPANISH - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://live-pv-ta.amazon.fastly-edge.com/iad-nitro/live/clients/dash/enc/o2vy4aahsh/out/v1/e293c932745a44dcaf897573dfc53532/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"763ce1ebcaf23502c8cf357c6ef423e1","key":"0c5e6c0820a1ea28753721db00272411"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'binge-bd-aq', 'BINGE+ BD - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://tc-sg.rockstreamer.com/v1/019ed91616121ea540a8171c8e801f/019ed92ac80315fc600b1796d4ad8b/main.m3u8', '{"Referer":"https://iscreen.com.bd/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-4k', 'FOX SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/enc/ihpzducmif/out/v1/fc40f22f10374517a2784e1d97cb23f4/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"1f68713028d439ec03be07f56c1d6213","key":"20093db6455160fffed4c394def3193d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'canal-sports-aq', 'CANAL SPORTS - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/dash/enc/ntkdl68eob/out/v1/bd5dfb7676994383881bc6e71877d29d/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"d695093ea3e66d75a4d213a3e2cbf360","key":"01be3f645e89a067d2786c295f68dde4"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'wc-english-aq', 'WC ENGLISH - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://qp-pldt-live-bpk-ucd-prod.akamaized.net/bpk-tv/fifa_ppv1/default/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"2c338a117d434ce4bbe3569231af90f1","key":"a9633d901ee8a3f4f58ac314b5c5f4fb"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bbc-sports-hd', 'BBC SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://chatgpt.hereisman.net/playlist/52803/load-playlist?', '{"Referer":"https://gooz.aapmains.net"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-hd', 'TSN SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://chatgpt.hereisman.net/playlist/52805/load-playlist?', '{"Referer":"https://gooz.aapmains.net"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-hd', 'FOX SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://chatgpt.hereisman.net/playlist/52806/load-playlist?', '{"Referer":"https://gooz.aapmains.net"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'irib-sports-4k', 'IRIB SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://ncdn.telewebion.ir/faratar/live/playlist.m3u8', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'ct-sports-aq', 'CT SPORTS - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://dash2.antik.sk/stream/nvidia_ct_sport/playlist_cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"11223344556677889900112233445566","key":"4b80724d0ef86bcb2c21f7999d67739d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-hd', 'TELEMUNDO HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://chatgpt.hereisman.net/playlist/52807/load-playlist?', '{"Referer":"https://gooz.aapmains.net"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bbc-english-hd', 'BBC ENGLISH HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/bbc-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bbc-sports-4k', 'BBC SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/bbc-4k.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-english-hd', 'TSN ENGLISH HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/tsn1-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-english-hd', 'FOX ENGLISH HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fox-usa.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fast-server', 'FAST SERVER', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://pulltx.jdnzrgm.com/live/hd-en-6MvYMRSYcswv5p3EBp.m3u8?txSecret=013fbb0ed8194c83baacc3b607c23ac9&txTime=6A45CCB0', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'dazn-munidal', 'DAZN MUNIDAL', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/daznmundial-es.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-4k', 'TSN SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/tsn4k-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-4k-1', 'FOX SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fox4k-usa.m3u8?', '{"Referer":"https://xyzstreams.st/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-fhd', 'TELEMUNDO FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/telemundo-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-4k', 'TELEMUNDO 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/telemundo-4k.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-4k-live', 'FUSSBALL 4K LIVE', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fussballtv1uhd-de.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'match-futbol-aq', 'MATCH! FUTBOL - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://video.beeline.tv/live/d/channel319.isml/manifest-stb.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"9145a6e0f778e61866f573d4944dd533","key":"d02173d40515fea5c83944f21d0f3114"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'all-in-one-reborn-2-live', 'All in one reborn 2 LIVE', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://instreams.pro/EU/HDWC1/tracks-v1a1/mono.m3u8', '{"Referer":"https://instream.click/&origin=https://instream.click"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'hd-server-eng', 'HD SERVER ENG', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://edgestreams.pro/hls/24SDAZFcsqnj24.m3u8?', '{"Referer":"https://streamscenter.online/&Origin=https://streamscenter.online"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'hd-server-ar', 'HD SERVER AR', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://edge2caster.pro/hls/eJmauBDCIf.m3u8?', '{"Referer":"https://streamscenter.online/&Origin=https://streamscenter.online"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bbc-sports-sd', 'BBC SPORTS SD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.51/hls/HXCZzsss.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bein-arabic-sd', 'beiN ARABIC SD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.47/hls/HXCZckkkqr.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'd-sports-es-sd', 'D SPORTS ES SD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.47/hls/HXCZckkkqqq.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bein-sports-fr', 'beiN SPORTS FR', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.47/hls/HXCZckkkq.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-tv-ger', 'FUSSBALL TV (GER)', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://svc45.main.sl.t-online.de/bpk-tv/KID01037_FUSSBALLTV1_hd/DASH/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"1cb20afcd9d979c833cfd208c7d3eeb2","key":"fef0c15b4a523370892edd5e4133c269"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'zdf-german-ip', 'ZDF (GERMAN IP)', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://simplitv-live.mdn.ors.at/live/eds/zdf_hd/dash4h/zdf_hd.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"c1a0ac1044a433d0856ccdc08f245084","key":"7f0e8800a6d63d7915ac181bb88ce813"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'unify-tv-ind', 'UNiFy TV (IND)', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://ngtv-live-cbj.gcdn.co/Content/DASH/Live/channel(fifa1)/master.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"10e2114398744f3880cc96653568da55","key":"d6d40441f9fbebea03ec64c4aea7211f"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'orf-german-ip', 'ORF (GERMAN IP)', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://simplitv-live.mdn.ors.at/live/eds/orf_1_hd-1/dash4h/orf_1_hd-1.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"429bcf031bbf3146a67f3f583e4c4355","key":"d1b92aba5a38a518c8b8a1fd2bca4398"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-es-usa', 'Telemundo ES (USA)', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://live-oneapp-prd-news.akamaized.net/Content/CMAF_OL2-CTR-4s/Live/channel(WSNS)/master.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"7d6bb9f86e133e4cb33440b493b6b672","key":"584ad285dcb9e7d42cf3e93f1cc3fe11"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-usa', 'TELEMUNDO (USA)', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://live-oneapp-prd-news.akamaized.net/Content/CMAF_OL2-CTR-4s-v2/Live/channel(kvea)/master.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"ce7ab3022e753307997f58afe001bac4","key":"72d631a66e635c60829a0fe7705516c1"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-english-aq', 'TSN ENGLISH - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/dash/enc/w0rehjjrwe/out/v1/69a2a7041395406b970598f61680e7cf/cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"14eeabf30c14b7fbf3008c03099ce011","key":"17d2ac8dbc5429bd70af3433aa12158d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tipik-fr-fhd', 'TIPIK FR FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://c9851ec-rbm-hilv-fsly.cdn.redbee.live/L26/6b640fa2/a765d074.isml/dash/.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"adca25b8779e4168a0cd710f59f61ccf","key":"be5383ed3cd8079f4ffe78ad067f476a"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tudn-mexico', 'TUDN MEXICO', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://live-pv-ta.amazon.fastly-edge.com/iad-nitro/live/clients/dash/enc/o2vy4aahsh/out/v1/e293c932745a44dcaf897573dfc53532/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"763ce1ebcaf23502c8cf357c6ef423e1","key":"0c5e6c0820a1ea28753721db00272411"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-english-aq', 'FOX ENGLISH - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/enc/ajfoeddkbz/out/v1/b78800b9b2304879b15843f455836829/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"f6564ec2aee819046328a0e153be574d","key":"ff46a8a1031eb27ef22576a077c98ab7"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'binge-bdix-bd', 'BINGE+ BDIX BD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://tc-sg.rockstreamer.com/v1/019ed91616121ea540a8171c8e801f/019ed92ac80315fc600b1796d4ad8b/main.m3u8', '{"Referer":"https://iscreen.com.bd/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'toffee-bdix-bd', 'TOFFEE BDIX (BD)', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://cdn-tt.pages.dev/ch3.m3u8', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'nctv-english-aq', 'NCTV ENGLISH - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://qp-pldt-live-bpk-ucd-prod.akamaized.net/bpk-tv/fifa_ppv1/default/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"2c338a117d434ce4bbe3569231af90f1","key":"a9633d901ee8a3f4f58ac314b5c5f4fb"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'rte-english-aq', 'RTE ENGLISH - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://dai.google.com/linear/dash/pa/event/oPeAYQs9T9yTHS98aR1EjQ/stream/6b0f1602-73b1-4228-8e64-fe2cec5ae9a3:BRU/manifest.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"d816287e21496989eae1312925a423c5","key":"00da00f13180e7e6cd5ce87d1c974e8d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'irib-4k', 'IRIB 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://ncdn.telewebion.ir/faratar/live/playlist.m3u8', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-4k-2', 'FOX SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/enc/t7uu8qfape/out/v1/fc40f22f10374517a2784e1d97cb23f4/cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"1f68713028d439ec03be07f56c1d6213","key":"20093db6455160fffed4c394def3193d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'ctv-sports-fhd', 'CTV SPORTS FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/enc/72sjo8hygl/out/v1/3079be34d72a4985852d299a02406a0c/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"d185684e2330de5bea436daa094a5e86","key":"014f0116154f5bf0050e03a6b0a23157"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'caze-tv-br-aq', 'CAZE TV BR - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/gru-nitro/live/clients/dash/enc/iayg0kyrof/out/v1/91dc04907f56415b897faccfa9d252da/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"1223d5105392cabf1bb9c2c1fdf6539a","key":"340b409f4b8f78a343e0363a7938df38"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'd-sports-aq-es', 'D SPORTS - AQ [ES]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/dash/enc/z5oyxzsxdk/out/v1/7695a0f64a0e424b973d5b09a2a3eb91/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"f836853d8eac19446ed9535f5fc568b1","key":"b3bc5ef00602b29abac7e482d3d9fbf3"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-hd-1', 'TSN SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/tsn1-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fast-server-1', 'FAST SERVER', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://pulltx.jdnzrgm.com/live/hd-en-6MvYMRSYcswv5p3EBp.m3u8?txSecret=013fbb0ed8194c83baacc3b607c23ac9&txTime=6A45CCB0', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-hd-1', 'FOX SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/tsn1-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bein-max-fhd', 'beIN MAX FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://81cup.s3.us-east-2.amazonaws.com/max1/master.m3u8?', '{"Referer":"https://kora.depoooo.com/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bbc-sports-hd-1', 'BBC SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://chatgpt.hereisman.net/playlist/52804/load-playlist?', '{"Referer":"https://gooz.aapmains.net"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-4k-1', 'TSN SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/tsn4k-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-4k-3', 'FOX SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fox4k-usa.m3u8?', '{"Referer":"https://xyzstreams.st/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'unite8-hindi-hd', 'UNITE8 HINDI HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://fastshare1.com/live/112233/445566/741567.ts', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'cctv5-fast', 'CCTV5 FAST', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://play.gzxdby.com/live/183334344568_2547627555.m3u8', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bbc-sports-4k-1', 'BBC SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/bbc-4k.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'match-tv-ru', 'MATCH TV RU', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://video.beeline.tv/live/d/channel319.isml/manifest-stb.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"9145a6e0f778e61866f573d4944dd533","key":"d02173d40515fea5c83944f21d0f3114"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'iscreen-bd-aq', 'ISCREEN BD - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://m3u-tvb.pages.dev/ics.m3u8', '{"Referer":"https://iscreen.com.bd/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'trt-fast-fhd', 'TRT FAST FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://andro.2385437.xyz/checklist/androstreamlivetrt1.m3u8', '{"Referer":"https://andro.2385437.xyz&Origin=https://andro.2385437.xyz&User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-4k-2', 'TSN SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/tsn4k-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://xyzstreams.st/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-4k-4', 'FOX SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fox4k-usa.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-fhd-1', 'TELEMUNDO FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/telemundo-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://xyzstreams.st/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-4k-live-1', 'FUSSBALL 4K LIVE', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fussballtv1uhd-de.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-fhd-2', 'TELEMUNDO FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://cun-live1-ott.izzigo.tv/out/u/dash/NOG1/TELEMUNDO-ARIZONA-USA-TCS-HD/default.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"1efe4add8fdf327c5f8d2a1c195e5c71","key":"4f50e6f011e60ca01ee561f27187e78f"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-tv-2-uhd', 'FUSSBALL TV 2 UHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://raw.githubusercontent.com/hnnyo/lgi/refs/heads/main/fsb1hd.m3u8', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'hd-server-en', 'HD SERVER EN', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://instreams.pro/US/NFLHD3/tracks-v1a1/mono.m3u8?', '{"Referer":"https://instream.click/&origin=https://instream.click"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'hd-server-ar-1', 'HD SERVER AR', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://edge2caster.pro/hls/eJmauBDCIf.m3u8?', '{"Referer":"https://streamscenter.online/&Origin=https://streamscenter.online"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'arabic-fhd', 'ARABIC FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/beinsportsmax-sa.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-fhd-3', 'TELEMUNDO FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/telemundo-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://xyzstreams.st/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-tv-uhd', 'FUSSBALL TV UHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fussballtv1uhd-de.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'hd-stream-eng', 'HD STREAM ENG', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://edge2caster.pro/hls/24SDAZFcsqnj24.m3u8?', '{"Referer":"https://streamscenter.online/&Origin=https://streamscenter.online"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-tv1-4k', 'FUSSBALL TV1 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://da-50f11b292a028381000001120000000000000009.id.vx.tentcdn.eu/wp/at-live-7.tentcdn.eu/bpk-tv/WM_TV_1_UHD/default/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"4f558eae1b005126b2ac6e9eb1a7849e","key":"17aea325d91b5e66f06a8c574f2f0b03"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-tv2-4k', 'FUSSBALL TV2 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://da-50f11b292a028381000001120000000000000009.id.vx.tentcdn.eu/wp/at-live-7.tentcdn.eu/bpk-tv/WM_TV_2_UHD/default/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"ccdf9f3d9bbf5c508adf04f81918a285","key":"66cf0524fcc2eb0c7dab8bbbf8829827"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-4k-usa-vpn', 'FOX SPORTS 4k [USA VPN]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/dash/enc/buf9inoetu/out/v1/31d30c91fc65458789b84209d3fa22e4/cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"1f68713028d439ec03be07f56c1d6213","key":"20093db6455160fffed4c394def3193d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'm6-france-usa-vpn', 'M6 FRANCE (USA VPN]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://edge-fastly-m6web.live.6cloud.fr/out/v1/6play/6play-m6/cmaf_cenc00/dash-short-hd.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"0182ed7af02734ecb17a2f55eec98f99","key":"60346785b1095596de621031e9daf3ec"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'peacock-usa', 'PEACOCK - USA', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://g003-sle-us-cmaf-prd-ak.cdn.peacocktv.com/pck-sle/us-west-2/v1/dash/6f3f45fea6332a47667932dede90d20a96f2690c/peacock-dash-sle-4s-generic-cfd/co01/pcksle2/Content/CMAF_CTR-4s-v2/Live/channel(5021700-723558-49134b01366)/master_2hr.mpd?c3.ri=6a43f01f_Q1ZYMDc_0_QUtBTUFJ_d8f9151c00b3%3A0&aws.sessionId=bff46f17-7dcb-41fd-b1b9-1428d6b4ccae', '{}'::jsonb, true, '{"type":"clearkey","kid":"0022fe4cfc08704d50a5c30ad622365c","key":"ec1eb7a4a6401cb60f4a44f7fb3fd98e"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-tv-uhd-1', 'FUSSBALL TV UHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fussballtv1uhd-de.m3u8', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'canal5-fhd', 'CANAL5 FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/dash/enc/ntkdl68eob/out/v1/bd5dfb7676994383881bc6e71877d29d/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"d695093ea3e66d75a4d213a3e2cbf360","key":"01be3f645e89a067d2786c295f68dde4"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'goltv-vivo', 'GOLTV VIVO', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://dmbgaz4xf6jyh.cloudfront.net/live-stream-dai/69690cfcce0dc031830e7c1a/123a264b71764485bd49eca2d552cf33/d97743de3620a865848fff7a9de14dda1bf2409d/manifest.mpd?aid=688aae6d61c87d6274c05065&dnt=true&access_token=63ey9SOpQeHBRfWJYQLXQjelQc0QM1HXmlHp4iZrH8UCOCM8QtGIGg1sEEPJH0R0yXktUEXdLeB&uid=Knx65GY6UbaWSADZybEvf6m5MvqNIuNs&sid=bwRy9BgSc4RFeVhYh52hVIY8uPsJ4v4d&pid=A0xT1VnepBvKKqyeyRNtNkZBmHBrNNZM&ref=ditu.caracoltv.com&ext_pb=0&es=dmbgaz4xf6jyh.cloudfront.net&proto=https&pz=us&xr=us-east-2&manifestfilter=video_height:480-1080', '{}'::jsonb, true, '{"type":"clearkey","kid":"1c6bfd8d1cdd4df69ea5fc4dd2f025bb","key":"b6fd90027dac7a94a9461f8b2638cbb4"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tve-la-1-aq', 'TVE La 1 - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/dash/enc/c7di7zkdor/out/v1/f7d5b356e048494a8325563e8916d50b/cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"745cd6ec34a58f2f7ac2af35dc3da6d2","key":"ae008f1e47e6567fe4201a6ff8f1ae54"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-fhd-4', 'TELEMUNDO FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/telemundo-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'sd-server', 'SD SERVER', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.51/hls/HXCZzsss.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-4k-live-2', 'FUSSBALL 4K LIVE', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fussballtv1uhd-de.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-4k-1', 'TELEMUNDO 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/telemundo-4k.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bein-france-aq', 'BeIN FRANCE - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://api-proxad.dc2.oqee.net/playlist/v1/live/966/1/live.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"3acea01244785a6363fc04b25d696392","key":"f0b8f84dbd93407af6ab0b41fc774249:9d8b1b819cfdcff845625b86cc4968f3:480b03fe4476bc187c6a9d43ba85b9db:3cf686dc4246f19bc4419c54da0f90bc:b40f599266c8a262ccf4a384dadce08a:b6362975ca29d0685b7cac721b6faa26:da04d180e9028af27482b6a37c81e020:6ca2f2c822444ff76d9570741dec7b2b:9fc3d71ab30e8d33f09ee29e5e453608"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-one-aq', 'FOX ONE - AQ', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/enc/ajfoeddkbz/out/v1/b78800b9b2304879b15843f455836829/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"f6564ec2aee819046328a0e153be574d","key":"ff46a8a1031eb27ef22576a077c98ab7"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-fhd', 'TSN SPORTS FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/dash/enc/w0rehjjrwe/out/v1/69a2a7041395406b970598f61680e7cf/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"14eeabf30c14b7fbf3008c03099ce011","key":"17d2ac8dbc5429bd70af3433aa12158d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'ctv-sports-fhd-1', 'CTV SPORTS FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/enc/72sjo8hygl/out/v1/3079be34d72a4985852d299a02406a0c/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"d185684e2330de5bea436daa094a5e86","key":"014f0116154f5bf0050e03a6b0a23157"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'toffe-bdix-bd', 'TOFFE BDIX (BD)', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://prod-cdn01-live.toffeelive.com/live/FIFA-2026-3/sst/0/master_1500.m3u8?hdntl=Expires=1783035611~_GO=Generated~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=AeQsclDGnkPZWwPpikfIMknw6R1CLxOxhkOn8kXXxvEgAfubt5THGgG4mlQt3k3uDloYMUXw1b2k-pt0iK8Pn1tIVOYH', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'binge-bdix-bd-1', 'Binge BDIX (BD)', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://tc-sg.rockstreamer.com/v1/019ed91616121ea540a8171c8e801f/019ed92ac80315fc600b1796d4ad8b/main.m3u8', '{"Referer":"https://iscreen.com.bd/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'wc-tv-fhd', 'WC TV FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://qp-pldt-live-bpk-ucd-prod.akamaized.net/bpk-tv/fifa_ppv1/default/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"2c338a117d434ce4bbe3569231af90f1","key":"a9633d901ee8a3f4f58ac314b5c5f4fb"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tipik-fr-fhd-1', 'TIPIK FR FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://c9851ec-rbm-hilv-fsly.cdn.redbee.live/L26/6b640fa2/a765d074.isml/dash/.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"adca25b8779e4168a0cd710f59f61ccf","key":"be5383ed3cd8079f4ffe78ad067f476a"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tudn-mexico-1', 'TUDN MEXICO', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://live-pv-ta.amazon.fastly-edge.com/iad-nitro/live/clients/dash/enc/o2vy4aahsh/out/v1/e293c932745a44dcaf897573dfc53532/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"763ce1ebcaf23502c8cf357c6ef423e1","key":"0c5e6c0820a1ea28753721db00272411"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bbc-sports-hd-2', 'BBC SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://chatgpt.hereisman.net/playlist/52804/load-playlist?', '{"Referer":"https://gooz.aapmains.net"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-4k-5', 'FOX SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/enc/igx02musdz/out/v1/31d30c91fc65458789b84209d3fa22e4/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"1f68713028d439ec03be07f56c1d6213","key":"20093db6455160fffed4c394def3193d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bbc-sports-4k-2', 'BBC SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/bbc-4k.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'canal5-fhd-1', 'CANAL5 FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/dash/enc/ntkdl68eob/out/v1/bd5dfb7676994383881bc6e71877d29d/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"d695093ea3e66d75a4d213a3e2cbf360","key":"01be3f645e89a067d2786c295f68dde4"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'rte-sports-fhd', 'RTE SPORTS FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://dai.google.com/linear/dash/pa/event/oPeAYQs9T9yTHS98aR1EjQ/stream/a15f395f-f7d2-4728-8db4-ee96e5643dcb:GRQ/manifest.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"d816287e21496989eae1312925a423c5","key":"00da00f13180e7e6cd5ce87d1c974e8d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'd-sports-fhd', 'D Sports FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/dash/enc/z5oyxzsxdk/out/v1/7695a0f64a0e424b973d5b09a2a3eb91/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"f836853d8eac19446ed9535f5fc568b1","key":"b3bc5ef00602b29abac7e482d3d9fbf3"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'caze-tv-fhd', 'CAZE TV FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/gru-nitro/live/clients/dash/enc/iayg0kyrof/out/v1/91dc04907f56415b897faccfa9d252da/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"1223d5105392cabf1bb9c2c1fdf6539a","key":"340b409f4b8f78a343e0363a7938df38"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-hd-2', 'FOX SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/dash/enc/cizlveblk4/out/v1/e5c36c41621e4384b80427d87199433a/cenc.mpd', '{"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"}'::jsonb, true, '{"type":"clearkey","kid":"d7d78ea2021a29541136bd5dc8352fe7","key":"6425ac4c0cdf906fe0cce5cf40dc8933"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'npo1-dutch-fhd', 'NPO1 DUTCH FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://npo-nl-ams-p18-am5.cdn.streamgate.nl/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3ODMwMDczODEsInVyaSI6IlwvbGl2ZVwvbnBvXC91XzNfNFwvbnBvcGx1c1wvZHJtXC9kYXNoX2NlbmNcL25wby0xXC8wXC8wXC8wXC9ucG8tMS5pc21sIiwidmlld2VyIjoidmlld2VyIiwicmlkIjoiZTZhYzlkMCJ9.eCeoWGmdlBcqqnwJoe6dxR5OtY9MLePq0gnnKLKgCj0/live/npo/u_3_4/npoplus/drm/dash_cenc/npo-1/0/0/0/npo-1.isml/stream.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"8d3c85fa30730fdc39efc09de476415f","key":"8fdccd948bb2cc6d99d5305ccffebcb7"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bein-max-fhd-1', 'beIN MAX FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://81cup.s3.us-east-2.amazonaws.com/max1/master.m3u8?', '{"Referer":"https://kora.depoooo.com/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-hd-2', 'TSN SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/tsn1-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-hd-3', 'FOX SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fox-usa.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fast-server-2', 'FAST SERVER', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://pulltx.jdnzrgm.com/live/hd-en-6MvYMRSYcswv5p3EBp.m3u8?txSecret=013fbb0ed8194c83baacc3b607c23ac9&txTime=6A45CCB0', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-hd-1', 'TELEMUNDO HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://chatgpt.hereisman.net/playlist/52807/load-playlist?', '{"Referer":"https://gooz.aapmains.net"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'dazn-munidal-1', 'DAZN MUNIDAL', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/daznmundial-es.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tyc-sports-hd', 'TYC SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://1nyaler.streamhostingcdn.top/stream/84/index.m3u8', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'unite8-hindi-hd-1', 'UNITE8 HINDI HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://fastshare1.com/live/112233/445566/741567.ts', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-hd-4', 'FOX SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://abeqnpaaaaaaaaamkm25dx7jyzllj.ta.bia-cf.live.pv-cdn.net/iad-nitro/live/dash/enc/ajfoeddkbz/out/v1/b78800b9b2304879b15843f455836829/cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"f6564ec2aee819046328a0e153be574d","key":"ff46a8a1031eb27ef22576a077c98ab7"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-fhd-1', 'TSN Sports FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://abeqnpaaaaaaaaamkm25dx7jyzllj.ta.bia-cf.live.pv-cdn.net/iad-nitro/live/clients/dash/enc/cjglydxghe/out/v1/8977baf175da4b94873194613dd3fe55/cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"14eeabf30c14b7fbf3008c03099ce011","key":"17d2ac8dbc5429bd70af3433aa12158d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-4k-alt', 'FOX 4K [ALT]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://abeqnpaaaaaaaaamkm25dx7jyzllj.ta.bia-cf.live.pv-cdn.net/iad-nitro/live/clients/enc/igx02musdz/out/v1/31d30c91fc65458789b84209d3fa22e4/cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"1f68713028d439ec03be07f56c1d6213","key":"20093db6455160fffed4c394def3193d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-alt', 'FOX SPORTS [ALT]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://abgh3fbaaaaaaaambylpff72g6up6.ta.bia-cf.live.pv-cdn.net/iad-nitro/live/dash/enc/ajfoeddkbz/out/v1/b78800b9b2304879b15843f455836829/cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"f6564ec2aee819046328a0e153be574d","key":"ff46a8a1031eb27ef22576a077c98ab7"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-alt', 'TSN SPORTS [ALT]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://abgh3fbaaaaaaaambylpff72g6up6.ta.bia-cf.live.pv-cdn.net/iad-nitro/live/dash/enc/w0rehjjrwe/out/v1/69a2a7041395406b970598f61680e7cf/cenc.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"14eeabf30c14b7fbf3008c03099ce011","key":"17d2ac8dbc5429bd70af3433aa12158d"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'peacock-fhd-alt', 'PEACOCK FHD [ALT]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://g003-sle-us-cmaf-prd-cf.cdn.peacocktv.com/pck-sle/us-west-2/v1/dash/6f3f45fea6332a47667932dede90d20a96f2690c/peacock-dash-sle-4s-generic-cfd/co01/pcksle2/Content/CMAF_CTR-4s-v2/Live/channel(5021712-723570-49135672e72)/master_2hr.mpd?c3.ri=6a45a292_Q1ZYMDc_0_Q0xPVURGUk9OVA_d6fcb3357987%3A0&aws.sessionId=e093016c-87ad-4982-9a26-244265f697c8', '{}'::jsonb, true, '{"type":"clearkey","kid":"0022281c7f0e54abe3df4d9706e1ad5e","key":"a6793084f33f4e6101ffd531e03c605f"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'nbc-universo-usa', 'NBC UNIVERSO [USA]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://live-oneapp-prd-news.akamaized.net/Content/CMAF_OL2-CTR-4s/Live/channel(WSNS)/master.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"7d6bb9f86e133e4cb33440b493b6b672","key":"584ad285dcb9e7d42cf3e93f1cc3fe11"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-4k-3', 'TSN SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/tsn4k-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-4k-6', 'FOX SPORTS 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fox4k-usa.m3u8?', '{"Referer":"https://xyzstreams.st/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fs1-4k-live', 'FS1 4K LIVE', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fox4k-usa.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-fhd-5', 'TELEMUNDO FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/telemundo-xyz-waUvqaAACr.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'telemundo-4k-2', 'TELEMUNDO 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/telemundo-4k.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-4k-live-3', 'FUSSBALL 4K LIVE', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://inproviszon.st/fussballtv1uhd-de.m3u8?', '{"Referer":"https://vileembeds.pages.dev/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-tv-4k', 'FUSSBALL TV 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://da-50f11b292a028381000001120000000000000009.id.vx.tentcdn.eu/wp/at-live-7.tentcdn.eu/bpk-tv/WM_TV_1_UHD/default/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"4f558eae1b005126b2ac6e9eb1a7849e","key":"17aea325d91b5e66f06a8c574f2f0b03"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-tv2-4k-1', 'FUSSBALL TV2 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://da-50f11b292a028381000001120000000000000009.id.vx.tentcdn.eu/wp/at-live-7.tentcdn.eu/bpk-tv/WM_TV_2_UHD/default/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"ccdf9f3d9bbf5c508adf04f81918a285","key":"66cf0524fcc2eb0c7dab8bbbf8829827"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'irib-4k-1', 'IRIB 4K', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://ncdn.telewebion.ir/faratar/live/playlist.m3u8', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'arabic-live-hd', 'ARABIC LIVE HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://cdn2.xyzstreams.st/bein2/index.m3u8?', '{"Referer":"https://xyzstreams.st/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fox-sports-hd-5', 'FOX SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://chatgpt.hereisman.net/playlist/52806/load-playlist?', '{"Referer":"https://gooz.aapmains.net"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'tsn-sports-hd-3', 'TSN SPORTS HD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://chatgpt.hereisman.net/playlist/52805/load-playlist?', '{"Referer":"https://gooz.aapmains.net"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'all-in-one-reborn4-live', 'All in one reborn4 Live', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://instreams.pro/US/NFLHD1/tracks-v1a1/mono.m3u8?', '{"Referer":"https://instream.click/&origin=https://instream.click"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'all-in-one-reborn4-live-es', 'All in one reborn4 Live ES', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://instreams.pro/US/NFLHD2/tracks-v1a1/mono.m3u8?', '{"Referer":"https://instream.click/&origin=https://instream.click"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'hd-server-eng-1', 'HD SERVER ENG', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://edgestreams.pro/hls/24SDAZFcsqnj24.m3u8?', '{"Referer":"https://streamscenter.online/&Origin=https://streamscenter.online"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'hd-server-ar-2', 'HD SERVER AR', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://edge2caster.pro/hls/eJmauBDCIf.m3u8?', '{"Referer":"https://streamscenter.online/&Origin=https://streamscenter.online"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'dazn-spanish', 'DAZN SPANISH', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://1nyaler.streamhostingcdn.top/stream/94/index.m3u8', '{}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'match-football-fhd', 'Match Football FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://video.beeline.tv/live/d/channel319.isml/manifest-stb.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"9145a6e0f778e61866f573d4944dd533","key":"d02173d40515fea5c83944f21d0f3114"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'iscreen-bd-fhd', 'ISCREEN BD FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://livecdn.rockstreamer.com/main/Iscreen_fifa_main/main/in4_1080p/chunks.m3u8', '{"Referer":"https://iscreen.com.bd/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-4k-ger', 'FUSSBALL 4K [GER]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://svc45.main.sl.t-online.de/bpk-tv/KID01037_FUSSBALLTV1_uhd/DASH/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"1f09d5788fbbb03a053d03cc731f31a9","key":"d493d5a70c793362324638f61d1726ac"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball2-4k-ger', 'FUSSBALL2 4K [GER]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://svc45.main.sl.t-online.de/bpk-tv/KID01064_FUSSBALLTV2_uhd/DASH/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"1b98a0f2de7784c6e132942385a089f3","key":"546eae09a8d81c498dfd08532dcd68a5"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball-tv-fhd', 'FUSSBALL TV FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://svc45.main.sl.t-online.de/bpk-tv/KID01037_FUSSBALLTV1_hd/DASH/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"1cb20afcd9d979c833cfd208c7d3eeb2","key":"fef0c15b4a523370892edd5e4133c269"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'fussball2-tv-fhd', 'FUSSBALL2 TV FHD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'https://svc45.main.sl.t-online.de/bpk-tv/KID01064_FUSSBALLTV2_hd/DASH/index.mpd', '{}'::jsonb, true, '{"type":"clearkey","kid":"1889c6c8cdf57aa3bc90bb976ca6cbdc","key":"48ef3649d9076965b70e79e58b0028ef"}'::jsonb
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'sd-server-eng', 'SD SERVER [ENG]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.51/hls/HXCZzsss.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'eng-server-sd', 'ENG SERVER SD', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.59/hls/HXCZzsssQ.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'bein-sports-fr-1', 'beIN SPORTS FR', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.47/hls/HXCZckkkq.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'd-sports-es', 'D SPORTS ES', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.47/hls/HXCZckkkqqq.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    'sd-server-ar', 'SD SERVER [AR]', 'https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974915/list/1920x1080list4db7b3a731ea4b2c98b5ef2d007d95eed6fc8f01c3be480c8add30c394d64f0b', 'test-category', true, 'HD', 'http://193.47.62.47/hls/HXCZckkkqr.m3u8?', '{"Referer":"http://www.fawanews.sc/&Origin=http://www.fawanews.sc/"}'::jsonb, true, NULL
) ON CONFLICT (id) DO NOTHING;

UPDATE app_settings SET channels_version = channels_version + 1, updated_at = now() WHERE id = 1;