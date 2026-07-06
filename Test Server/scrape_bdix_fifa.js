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
    const url = "https://bdix1fifa.allinonereborn.workers.dev/6klfpw.m3u";
    console.log("Fetching World Cup (BDIX) playlist from URL...");
    
    // Using a VLC user-agent is required as the server returns an HTML notice for browser agents.
    const res = await fetch(url, {
        headers: {
            "User-Agent": "VLC/3.0.18"
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
                currentChannel.id = slugify(currentChannel.name) + '-bdix-fifa';
            }
            
            const logoMatch = line.match(/tvg-logo="([^"]+)"/);
            if (logoMatch) {
                currentChannel.logo = logoMatch[1];
            }

            const groupMatch = line.match(/group-title="([^"]+)"/);
            if (groupMatch) {
                currentChannel.group = groupMatch[1];
            }
        } else if (!line.startsWith('#')) {
            currentChannel.url = line;
            currentChannel.resolution = 'HD';
            
            if (currentChannel.id && currentChannel.url) {
                // Filter out the Telegram sponsored/notice items
                const isSponsored = currentChannel.group === 'Sponsored' || 
                                    currentChannel.url.includes('raw.githubusercontent.com') ||
                                    currentChannel.name.includes('Telegram') ||
                                    currentChannel.name.includes('টেলিগ্রাম') ||
                                    currentChannel.name.includes('All In One');
                
                if (!isSponsored) {
                    channels.push(currentChannel);
                }
            }
            currentChannel = {};
        }
    }

    console.log(`Parsed ${channels.length} valid channels from M3U.`);

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
        return {
            id: ch.id,
            name: ch.name,
            url: ch.url,
            logo: ch.logo || "",
            resolution: ch.resolution || "HD",
            proxy: ch.proxy
        };
    });

    channelsJson.categories['world-cup-bdix'] = {
        name: "World Cup (BDIX)",
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

    // 3. Prepare payload for Supabase
    console.log("Preparing payload for Supabase...");
    const payload = channels.map(ch => {
        return {
            id: ch.id,
            name: ch.name,
            logo: ch.logo || null,
            category: 'world-cup-bdix',
            is_live: true,
            quality: ch.resolution || 'HD',
            stream_url: ch.url,
            headers: {},
            proxy: ch.proxy ? true : false,
            drm: null
        };
    });

    // Remove duplicate IDs from the payload
    const uniquePayloadMap = new Map();
    for (const item of payload) {
        uniquePayloadMap.set(item.id, item);
    }
    const uniquePayload = Array.from(uniquePayloadMap.values());

    // 4. Generate SQL script for database insert/upsert
    console.log("Generating SQL insert script...");
    let sqlContent = `-- SQL Script to insert/upsert World Cup (BDIX) channels and playlist\n`;
    
    // Category Insert
    sqlContent += `INSERT INTO public.categories (id, name, sort_order) \n`;
    sqlContent += `VALUES ('world-cup-bdix', 'World Cup (BDIX)', 10) \n`;
    sqlContent += `ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;\n\n`;

    // Channels Insert
    const sqlValues = [];
    for (const item of uniquePayload) {
        const idEscaped = item.id.replace(/'/g, "''");
        const nameEscaped = item.name.replace(/'/g, "''");
        const logoEscaped = item.logo ? `'${item.logo.replace(/'/g, "''")}'` : 'NULL';
        const streamUrlEscaped = item.stream_url.replace(/'/g, "''");
        const headersStr = JSON.stringify(item.headers);
        const proxyVal = item.proxy ? 'true' : 'false';
        const drmVal = item.drm ? `'${JSON.stringify(item.drm).replace(/'/g, "''")}'` : 'NULL';

        sqlValues.push(`('${idEscaped}', '${nameEscaped}', ${logoEscaped}, 'world-cup-bdix', true, 'HD', '${streamUrlEscaped}', '${headersStr}'::jsonb, ${proxyVal}, ${drmVal}::jsonb)`);
    }

    sqlContent += `INSERT INTO public.channels (id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm)\nVALUES\n`;
    sqlContent += sqlValues.join(',\n') + '\n';
    sqlContent += `ON CONFLICT (id) DO UPDATE SET\n`;
    sqlContent += `  name = EXCLUDED.name,\n`;
    sqlContent += `  logo = EXCLUDED.logo,\n`;
    sqlContent += `  category = EXCLUDED.category,\n`;
    sqlContent += `  stream_url = EXCLUDED.stream_url,\n`;
    sqlContent += `  headers = EXCLUDED.headers,\n`;
    sqlContent += `  proxy = EXCLUDED.proxy,\n`;
    sqlContent += `  drm = EXCLUDED.drm;\n\n`;

    // Playlist Insert
    const channelIdsArrayStr = uniquePayload.map(ch => `'${ch.id.replace(/'/g, "''")}'`).join(', ');
    sqlContent += `INSERT INTO public.playlists (id, name, channels) \n`;
    sqlContent += `VALUES ('world-cup-bdix', 'World Cup (BDIX)', ARRAY[${channelIdsArrayStr}]) \n`;
    sqlContent += `ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, channels = EXCLUDED.channels;\n\n`;

    // Increment channels version to notify clients
    sqlContent += `UPDATE app_settings SET channels_version = channels_version + 1, updated_at = now() WHERE id = 1;\n`;

    fs.writeFileSync('insert_world_cup_bdix_channels.sql', sqlContent, 'utf8');
    console.log("SQL insert script written to insert_world_cup_bdix_channels.sql successfully.");
}

scrape().catch(console.error);
