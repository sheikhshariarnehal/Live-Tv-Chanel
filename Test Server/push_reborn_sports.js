const fs = require('fs');

function slugify(text) {
    return text.toString().toLowerCase()
        .replace(/\s+/g, '-')           // Replace spaces with -
        .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
        .replace(/\-\-+/g, '-')         // Replace multiple - with single -
        .replace(/^-+/, '')             // Trim - from start of text
        .replace(/-+$/, '');            // Trim - from end of text
}

async function main() {
    const lines = fs.readFileSync('rebornsportspremium.m3u', 'utf8').split('\n');
    const channels = [];

    let currentChannel = {};

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();
        if (!line) continue;

        if (line.startsWith('#EXTINF:')) {
            // New channel
            currentChannel = { proxy: true };
            const nameMatch = line.match(/,(.+)$/);
            if (nameMatch) {
                currentChannel.name = nameMatch[1].trim();
                currentChannel.id = slugify(currentChannel.name) + '-reborn';
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
            // URL line
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
                const headers = {};
                const pairs = headersPart.split('&');
                for (const pair of pairs) {
                    const [k, v] = pair.split('=');
                    if (k && v) {
                        headers[k.toLowerCase() === 'user-agent' ? 'User-Agent' : k] = decodeURIComponent(v);
                    }
                }
                
                if (headers['User-Agent']) currentChannel['user-agent'] = headers['User-Agent'];
                if (headers['referer'] || headers['Referer']) currentChannel.referer = headers['referer'] || headers['Referer'];
            }
            
            if (currentChannel.id && currentChannel.url) {
                // Filter out sponsored and telegram channels
                const isSponsored = currentChannel.group === 'Sponsored' || 
                                    currentChannel.name.toLowerCase().includes('telegram') ||
                                    currentChannel.name.includes('টেলিগ্রাম') ||
                                    currentChannel.name.toLowerCase().includes('all in one reborn');
                if (!isSponsored) {
                    channels.push(currentChannel);
                }
            }
            currentChannel = {};
        }
    }

    let sortOrder = 1;
    const payload = channels.map(ch => {
        let headers = {};
        if (ch.referer) headers.Referer = ch.referer;
        if (ch['user-agent']) headers['User-Agent'] = ch['user-agent'];

        let drm = null;
        if (ch.drm) {
            drm = {
                type: ch.drmSystem || 'clearkey',
                kid: ch.drm.kid,
                key: ch.drm.key,
                licenseUrl: ch.drm.licenseUrl
            };
        }

        return {
            id: ch.id,
            name: ch.name,
            logo: ch.logo || null,
            category: 'reborn-sports',
            is_live: true,
            quality: ch.resolution || 'HD',
            stream_url: ch.url,
            headers: headers,
            proxy: ch.proxy ? true : false,
            drm: drm,
            sort_order: sortOrder++
        };
    });

    // Remove duplicates from payload based on ID
    const uniquePayloadMap = new Map();
    for (const item of payload) {
        uniquePayloadMap.set(item.id, item);
    }
    const uniquePayload = Array.from(uniquePayloadMap.values());

    const SUPABASE_URL = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';

    console.log(`Pushing ${uniquePayload.length} channels to reborn-sports category...`);

    const response = await fetch(`${SUPABASE_URL}/rest/v1/channels`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
            'Prefer': 'resolution=merge-duplicates' // merge/update on conflict
        },
        body: JSON.stringify(uniquePayload)
    });

    if (response.ok) {
        console.log('Successfully inserted channels.');
    } else {
        const text = await response.text();
        console.error('Error inserting channels:', response.status, text);
    }
}

main().catch(console.error);
