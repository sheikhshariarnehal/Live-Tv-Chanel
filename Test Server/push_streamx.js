const fs = require('fs');
const path = require('path');

function slugify(text) {
    return text.toString().toLowerCase()
        .replace(/\s+/g, '-')           // Replace spaces with -
        .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
        .replace(/\-\-+/g, '-')         // Replace multiple - with single -
        .replace(/^-+/, '')             // Trim - from start of text
        .replace(/-+$/, '');            // Trim - from end of text
}

async function main() {
    const playlistPath = path.resolve(__dirname, '../../full_playlist.json');
    console.log(`Reading playlist from ${playlistPath}...`);
    const data = JSON.parse(fs.readFileSync(playlistPath, 'utf8'));
    const channels = data.channels || [];

    console.log(`Loaded ${channels.length} channels from JSON.`);

    const SUPABASE_URL = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';
    const ADMIN_TOKEN = 'GoLiveAdminSecret2026';

    const headers = {
        'Content-Type': 'application/json',
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
        'x-admin-token': ADMIN_TOKEN
    };

    // 1. Fetch current max sort order for fifa-world-cup-2026 category
    console.log('Fetching max sort order for FIFA category...');
    let fifaSortCounter = 1600;
    try {
        const orderRes = await fetch(`${SUPABASE_URL}/rest/v1/channels?category=eq.fifa-world-cup-2026&select=sort_order&order=sort_order.desc&limit=1`, {
            method: 'GET',
            headers
        });
        if (orderRes.ok) {
            const orderData = await orderRes.json();
            if (orderData && orderData.length > 0) {
                fifaSortCounter = (orderData[0].sort_order || 0) + 1;
                console.log(`Found max sort order. New FIFA channels will start from sort order: ${fifaSortCounter}`);
            }
        } else {
            console.warn('Failed to fetch max sort order, using default 1600.');
        }
    } catch (e) {
        console.warn('Error fetching max sort order:', e.message, 'using default 1600.');
    }

    // 2. Prepare payload
    let streamxSortCounter = 1;
    const seenIds = new Set();
    const payload = [];

    for (const ch of channels) {
        // Base ID generation
        let baseId = slugify(ch.name) + '-streamx';
        let finalId = baseId;
        let counter = 1;
        while (seenIds.has(finalId)) {
            finalId = `${baseId}-${counter}`;
            counter++;
        }
        seenIds.add(finalId);

        // Category & Sort Order determination
        const isFifa = ch.attributes && ch.attributes['group-title'] === 'FIFA 2026 | STREAMX';
        const categoryId = isFifa ? 'fifa-world-cup-2026' : 'streamx';
        const sortOrder = isFifa ? fifaSortCounter++ : streamxSortCounter++;

        // Headers construction
        let channelHeaders = {};
        if (ch.vlcopts && ch.vlcopts['http-user-agent']) {
            channelHeaders['User-Agent'] = ch.vlcopts['http-user-agent'];
        }
        if (ch.exthttp) {
            for (const [k, v] of Object.entries(ch.exthttp)) {
                if (v) {
                    let key = k;
                    if (k.toLowerCase() === 'user-agent') key = 'User-Agent';
                    else if (k.toLowerCase() === 'referer') key = 'Referer';
                    else if (k.toLowerCase() === 'origin') key = 'Origin';
                    else if (k.toLowerCase() === 'cookie') key = 'Cookie';
                    channelHeaders[key] = v;
                }
            }
        }

        // DRM construction
        let drm = null;
        if (ch.kodiprops && ch.kodiprops['inputstream.adaptive.license_key']) {
            const keyVal = ch.kodiprops['inputstream.adaptive.license_key'];
            const keyType = ch.kodiprops['inputstream.adaptive.license_type'] || 'clearkey';
            if (keyVal.includes(':')) {
                const [kid, key] = keyVal.split(':');
                drm = {
                    type: keyType,
                    kid: kid.trim(),
                    key: key.trim(),
                    licenseUrl: null
                };
            }
        }

        payload.push({
            id: finalId,
            name: ch.name,
            logo: (ch.attributes ? (ch.attributes['tvg-logo'] || ch.attributes['group-logo']) : null) || null,
            category: categoryId,
            is_live: true,
            quality: 'HD',
            stream_url: ch.url,
            headers: channelHeaders,
            proxy: false,
            drm: drm,
            sort_order: sortOrder
        });
    }

    console.log(`Prepared ${payload.length} channels for insertion.`);

    // 3. Batch insert (100 channels per request)
    const BATCH_SIZE = 100;
    for (let i = 0; i < payload.length; i += BATCH_SIZE) {
        const batch = payload.slice(i, i + BATCH_SIZE);
        console.log(`Pushing batch ${Math.floor(i / BATCH_SIZE) + 1}/${Math.ceil(payload.length / BATCH_SIZE)} (${batch.length} channels)...`);

        const response = await fetch(`${SUPABASE_URL}/rest/v1/channels`, {
            method: 'POST',
            headers: {
                ...headers,
                'Prefer': 'resolution=merge-duplicates' // update on conflict
            },
            body: JSON.stringify(batch)
        });

        if (!response.ok) {
            const text = await response.text();
            console.error(`Error inserting batch: ${response.status} - ${text}`);
            throw new Error('Failed to insert channels batch.');
        }
    }

    console.log('Successfully inserted all channels.');
}

main().catch(e => {
    console.error('Unhandled error:', e);
    process.exit(1);
});
