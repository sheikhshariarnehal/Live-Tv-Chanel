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
    const url = "https://fifa.allinonereborn.workers.dev/o2k3uu.m3u";
    console.log("Fetching FIFA playlist from URL...");
    
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

    // Save the raw M3U file
    fs.writeFileSync('FIFAWorldcup.m3u', text, 'utf8');
    console.log("Raw M3U saved to FIFAWorldcup.m3u");

    const lines = text.split('\n');
    const channels = [];
    let currentChannel = {};

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();
        if (!line) continue;

        if (line.startsWith('#EXTINF:')) {
            currentChannel = { headers: {} };
            
            // Correctly match the last comma to get the channel name
            const lastCommaIdx = line.lastIndexOf(',');
            if (lastCommaIdx !== -1) {
                currentChannel.name = line.substring(lastCommaIdx + 1).trim();
                currentChannel.id = slugify(currentChannel.name) + '-fifa-reborn';
            } else {
                currentChannel.name = "Unknown Channel";
                currentChannel.id = "unknown-fifa-reborn";
            }
            
            const logoMatch = line.match(/tvg-logo="([^"]+)"/);
            if (logoMatch) {
                currentChannel.logo = logoMatch[1];
            }

            const groupMatch = line.match(/group-title="([^"]+)"/);
            if (groupMatch) {
                currentChannel.group = groupMatch[1];
            }
        } else if (line.startsWith('#EXTVLCOPT:http-user-agent=')) {
            const ua = line.split('=')[1].trim();
            if (currentChannel.headers) {
                currentChannel.headers['User-Agent'] = ua;
            }
        } else if (line.startsWith('#KODIPROP:')) {
            const prop = line.substring(10);
            if (prop.startsWith('inputstream.adaptive.license_type=')) {
                currentChannel.drmType = prop.split('=')[1].trim();
            } else if (prop.startsWith('inputstream.adaptive.license_key=')) {
                const keyVal = prop.split('=')[1].trim();
                if (keyVal.includes(':')) {
                    const [kid, key] = keyVal.split(':');
                    currentChannel.drmKey = { kid, key };
                }
            }
        } else if (!line.startsWith('#')) {
            // URL line, check for appended headers using pipe '|'
            let urlPart = line;
            let headersPart = '';
            
            if (line.includes('|')) {
                const parts = line.split('|');
                urlPart = parts[0];
                headersPart = parts[1];
            }

            currentChannel.url = urlPart;
            currentChannel.resolution = 'HD';

            if (headersPart) {
                const pairs = headersPart.split('&');
                for (const pair of pairs) {
                    const eqIndex = pair.indexOf('=');
                    if (eqIndex !== -1) {
                        const key = pair.substring(0, eqIndex);
                        const val = pair.substring(eqIndex + 1);
                        if (key && val) {
                            let headerKey = key;
                            if (key.toLowerCase() === 'user-agent') headerKey = 'User-Agent';
                            else if (key.toLowerCase() === 'referer') headerKey = 'Referer';
                            else if (key.toLowerCase() === 'origin') headerKey = 'Origin';
                            
                            currentChannel.headers[headerKey] = decodeURIComponent(val);
                        }
                    }
                }
            }

            if (currentChannel.id && currentChannel.url) {
                // Filter out sponsored/Telegram notice channels if any
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

    console.log(`Parsed ${channels.length} valid channels from FIFA M3U.`);

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
            proxy: true
        };
        if (ch.headers && Object.keys(ch.headers).length > 0) {
            item.headers = ch.headers;
        }
        if (ch.drmKey) {
            item.drmSystem = ch.drmType || "clearkey";
            item.drm = {
                kid: ch.drmKey.kid,
                key: ch.drmKey.key
            };
        }
        return item;
    });

    channelsJson.categories['fifa-world-cup-2026'] = {
        name: "FIFA™",
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

    // 3. Prepare unique payload for Supabase
    console.log("Preparing payload for Supabase...");
    const payload = channels.map(ch => {
        let drm = null;
        if (ch.drmKey) {
            drm = {
                type: ch.drmType || 'clearkey',
                kid: ch.drmKey.kid,
                key: ch.drmKey.key
            };
        }
        return {
            id: ch.id,
            name: ch.name,
            logo: ch.logo || null,
            category: 'fifa-world-cup-2026',
            is_live: true,
            quality: ch.resolution || 'HD',
            stream_url: ch.url,
            headers: ch.headers || {},
            proxy: true,
            drm: drm
        };
    });

    // Remove duplicate IDs
    const uniquePayloadMap = new Map();
    for (const item of payload) {
        uniquePayloadMap.set(item.id, item);
    }
    const uniquePayload = Array.from(uniquePayloadMap.values());

    // 4. Generate SQL script for database insert/upsert
    console.log("Generating SQL insert script...");
    let sqlContent = `-- SQL Script to insert/upsert FIFA World Cup channels and playlist\n`;
    
    // Category Insert
    sqlContent += `INSERT INTO public.categories (id, name, sort_order) \n`;
    sqlContent += `VALUES ('fifa-world-cup-2026', 'FIFA™', 0) \n`;
    sqlContent += `ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;\n\n`;

    // Channels Insert
    const sqlValues = [];
    for (const item of uniquePayload) {
        const idEscaped = item.id.replace(/'/g, "''");
        const nameEscaped = item.name.replace(/'/g, "''");
        const logoEscaped = item.logo ? `'${item.logo.replace(/'/g, "''")}'` : 'NULL';
        const streamUrlEscaped = item.stream_url.replace(/'/g, "''");
        const headersStr = JSON.stringify(item.headers).replace(/'/g, "''");
        const proxyVal = item.proxy ? 'true' : 'false';
        const drmVal = item.drm ? `'${JSON.stringify(item.drm).replace(/'/g, "''")}'` : 'NULL';

        sqlValues.push(`('${idEscaped}', '${nameEscaped}', ${logoEscaped}, 'fifa-world-cup-2026', true, 'HD', '${streamUrlEscaped}', '${headersStr}'::jsonb, ${proxyVal}, ${drmVal}::jsonb)`);
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
    sqlContent += `VALUES ('fifa-world-cup-2026', 'FIFA World Cup 2026', ARRAY[${channelIdsArrayStr}]) \n`;
    sqlContent += `ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, channels = EXCLUDED.channels;\n\n`;

    // Increment channels version to notify clients
    sqlContent += `UPDATE app_settings SET channels_version = channels_version + 1, updated_at = now() WHERE id = 1;\n`;

    fs.writeFileSync('insert_fifa_channels.sql', sqlContent, 'utf8');
    console.log("SQL insert script written to insert_fifa_channels.sql successfully.");
}

scrape().catch(console.error);
