const fs = require('fs');

function slugify(text) {
    return text.toString().toLowerCase()
        .replace(/\s+/g, '-')           // Replace spaces with -
        .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
        .replace(/\-\-+/g, '-')         // Replace multiple - with single -
        .replace(/^-+/, '')             // Trim - from start of text
        .replace(/-+$/, '');            // Trim - from end of text
}

async function scrape() {
    const url = "https://ayna-ott-allinonereborn.aiorbd.workers.dev/playlist.m3u?t=1783076962&token=d6e43080b35302bc3e7e5c9b33360357afae5c5ec0b4576dc250b6ea9b7d32da.m3u";
    console.log("Fetching Ayna OTT playlist from URL...");
    const res = await fetch(url, {
        headers: {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
        }
    });
    if (!res.ok) {
        throw new Error(`Failed to fetch playlist: ${res.status} ${res.statusText}`);
    }
    const text = await res.text();
    console.log(`Downloaded ${text.length} bytes.`);

    const lines = text.split('\n');
    const channels = [];
    let currentChannel = {};

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();
        if (!line) continue;

        if (line.startsWith('#EXTINF:')) {
            currentChannel = { proxy: true };
            const nameMatch = line.match(/,(.+)$/);
            if (nameMatch) {
                currentChannel.name = nameMatch[1].trim();
                currentChannel.id = slugify(currentChannel.name) + '-ayna';
            }
            
            const logoMatch = line.match(/tvg-logo="([^"]+)"/);
            if (logoMatch) {
                currentChannel.logo = logoMatch[1];
            }

            const groupMatch = line.match(/group-title="([^"]+)"/);
            if (groupMatch) {
                currentChannel.group = groupMatch[1];
            }
        } else if (line.startsWith('#KODIPROP:')) {
            const prop = line.substring(10);
            if (prop.startsWith('inputstream.adaptive.license_type=')) {
                currentChannel.drmSystem = prop.split('=')[1].trim();
            } else if (prop.startsWith('inputstream.adaptive.license_key=')) {
                const keyVal = prop.split('=')[1].trim();
                if (keyVal.includes(':')) {
                    const [kid, key] = keyVal.split(':');
                    currentChannel.drm = { kid, key };
                }
            }
        } else if (!line.startsWith('#')) {
            currentChannel.url = line;
            currentChannel.resolution = 'HD';
            
            if (currentChannel.id && currentChannel.url) {
                channels.push(currentChannel);
            }
            currentChannel = {};
        }
    }

    console.log(`Parsed ${channels.length} channels from M3U.`);

    // 1. Update channels.json
    console.log("Updating channels.json...");
    let channelsJson = {};
    if (fs.existsSync('channels.json')) {
        channelsJson = JSON.parse(fs.readFileSync('channels.json', 'utf8'));
    }
    if (!channelsJson.categories) {
        channelsJson.categories = {};
    }

    // Format channels for channels.json
    const formattedChannelsForJson = channels.map(ch => {
        const item = {
            id: ch.id,
            name: ch.name,
            url: ch.url,
            logo: ch.logo || "",
            resolution: ch.resolution || "HD",
            proxy: ch.proxy
        };
        if (ch.drm) {
            item.drm = {
                kid: ch.drm.kid,
                key: ch.drm.key
            };
        }
        return item;
    });

    channelsJson.categories['ayna-ott-playlists'] = {
        name: "Ayna OTT Playlists",
        channels: formattedChannelsForJson
    };

    fs.writeFileSync('channels.json', JSON.stringify(channelsJson, null, 2), 'utf8');
    console.log("channels.json updated successfully.");

    // 2. Update player.html
    console.log("Updating player.html...");
    let playerHtml = fs.readFileSync('player.html', 'utf8');
    
    const channelsString = JSON.stringify(channelsJson, null, 2);
    const channelsStartIdx = playerHtml.indexOf('const CHANNELS =');
    const proxiesStartIdx = playerHtml.indexOf('const PROXIES =');
    
    if (channelsStartIdx !== -1 && proxiesStartIdx !== -1) {
        playerHtml = playerHtml.substring(0, channelsStartIdx) + 
                     `const CHANNELS = ${channelsString};\n\n    ` + 
                     playerHtml.substring(proxiesStartIdx);
        fs.writeFileSync('player.html', playerHtml, 'utf8');
        console.log("player.html updated successfully.");
    } else {
        console.error("Could not find const CHANNELS or const PROXIES in player.html.");
    }

    // 3. Push to Supabase
    console.log("Preparing payload for Supabase...");
    const payload = channels.map(ch => {
        let headers = {};
        let drm = null;
        if (ch.drm) {
            drm = {
                type: ch.drmSystem || 'clearkey',
                kid: ch.drm.kid,
                key: ch.drm.key
            };
        }

        return {
            id: ch.id,
            name: ch.name,
            logo: ch.logo || null,
            category: 'ayna-ott-playlists',
            is_live: true,
            quality: ch.resolution || 'HD',
            stream_url: ch.url,
            headers: headers,
            proxy: ch.proxy ? true : false,
            drm: drm
        };
    });

    // Remove duplicate IDs from the payload
    const uniquePayloadMap = new Map();
    for (const item of payload) {
        uniquePayloadMap.set(item.id, item);
    }
    const uniquePayload = Array.from(uniquePayloadMap.values());

    const SUPABASE_URL = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';

    // 3. Generate SQL script for database insert/upsert
    console.log("Generating SQL insert script...");
    let sqlContent = `-- SQL Script to insert/upsert Ayna OTT Playlists channels\n`;
    sqlContent += `INSERT INTO public.categories (id, name, sort_order) \n`;
    sqlContent += `VALUES ('ayna-ott-playlists', 'Ayna OTT Playlists', 10) \n`;
    sqlContent += `ON CONFLICT (id) DO NOTHING;\n\n`;

    const sqlValues = [];
    for (const item of uniquePayload) {
        const idEscaped = item.id.replace(/'/g, "''");
        const nameEscaped = item.name.replace(/'/g, "''");
        const logoEscaped = item.logo ? `'${item.logo.replace(/'/g, "''")}'` : 'NULL';
        const streamUrlEscaped = item.stream_url.replace(/'/g, "''");
        const headersStr = JSON.stringify(item.headers);
        const proxyVal = item.proxy ? 'true' : 'false';
        const drmVal = item.drm ? `'${JSON.stringify(item.drm).replace(/'/g, "''")}'` : 'NULL';

        sqlValues.push(`('${idEscaped}', '${nameEscaped}', ${logoEscaped}, 'ayna-ott-playlists', true, 'HD', '${streamUrlEscaped}', '${headersStr}'::jsonb, ${proxyVal}, ${drmVal}::jsonb)`);
    }

    sqlContent += `INSERT INTO public.channels (id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm)\nVALUES\n`;
    sqlContent += sqlValues.join(',\n') + '\n';
    sqlContent += `ON CONFLICT (id) DO UPDATE SET\n`;
    sqlContent += `  name = EXCLUDED.name,\n`;
    sqlContent += `  logo = EXCLUDED.logo,\n`;
    sqlContent += `  stream_url = EXCLUDED.stream_url,\n`;
    sqlContent += `  headers = EXCLUDED.headers,\n`;
    sqlContent += `  proxy = EXCLUDED.proxy,\n`;
    sqlContent += `  drm = EXCLUDED.drm;\n`;

    fs.writeFileSync('insert_ayna_channels.sql', sqlContent, 'utf8');
    console.log("SQL insert script written to insert_ayna_channels.sql successfully.");
}

scrape().catch(console.error);
