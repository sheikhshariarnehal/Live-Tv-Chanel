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

    // Determine unique categories in order of appearance in M3U
    const uniqueGroups = [];
    const groupSet = new Set();
    for (const ch of channels) {
        const groupName = ch.group || 'Sports';
        if (!groupSet.has(groupName)) {
            groupSet.add(groupName);
            uniqueGroups.push(groupName);
        }
    }

    console.log(`Found ${uniqueGroups.length} unique groups/categories in the M3U file.`);

    // Build the categories payload
    // We start category sort_order from 17
    let categorySortOrderStart = 17;
    const categoriesPayload = uniqueGroups.map(group => {
        const categoryName = `Reborn ${group}`;
        const categoryId = slugify(categoryName);
        return {
            id: categoryId,
            name: categoryName,
            icon: null,
            sort_order: categorySortOrderStart++
        };
    });

    // Remove duplicates from channels based on ID
    const uniqueChannelsMap = new Map();
    for (const ch of channels) {
        uniqueChannelsMap.set(ch.id, ch);
    }
    const uniqueChannels = Array.from(uniqueChannelsMap.values());

    // Map channels to the Supabase schema
    // Track sort order per category
    const categorySortCounters = {};
    for (const group of uniqueGroups) {
        const categoryId = slugify(`Reborn ${group}`);
        categorySortCounters[categoryId] = 1;
    }

    const channelsPayload = uniqueChannels.map(ch => {
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

        const groupName = ch.group || 'Sports';
        const categoryId = slugify(`Reborn ${groupName}`);
        const sortOrder = categorySortCounters[categoryId]++;

        return {
            id: ch.id,
            name: ch.name,
            logo: ch.logo || null,
            category: categoryId,
            is_live: true,
            quality: ch.resolution || 'HD',
            stream_url: ch.url,
            headers: headers,
            proxy: ch.proxy ? true : false,
            drm: drm,
            sort_order: sortOrder
        };
    });

    const SUPABASE_URL = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';

    // Step 1: Push Categories
    console.log(`Pushing ${categoriesPayload.length} categories to Supabase...`);
    const catResponse = await fetch(`${SUPABASE_URL}/rest/v1/categories`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
            'Prefer': 'resolution=merge-duplicates'
        },
        body: JSON.stringify(categoriesPayload)
    });

    if (catResponse.ok) {
        console.log('Successfully inserted/updated categories.');
    } else {
        const text = await catResponse.text();
        console.error('Error inserting categories:', catResponse.status, text);
        return;
    }

    // Step 2: Push Channels
    console.log(`Pushing ${channelsPayload.length} channels to Supabase...`);
    const chanResponse = await fetch(`${SUPABASE_URL}/rest/v1/channels`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
            'Prefer': 'resolution=merge-duplicates'
        },
        body: JSON.stringify(channelsPayload)
    });

    if (chanResponse.ok) {
        console.log('Successfully inserted/updated channels.');
    } else {
        const text = await chanResponse.text();
        console.error('Error inserting channels:', chanResponse.status, text);
    }
}

main().catch(console.error);
