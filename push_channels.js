const fs = require('fs');

async function main() {
    const data = JSON.parse(fs.readFileSync('scrabe_1.json', 'utf8'));
    const channels = data.channels || [];

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
            category: 'test-category',
            is_live: true,
            quality: ch.resolution || 'HD',
            stream_url: ch.url,
            headers: headers,
            proxy: ch.proxy ? true : false,
            drm: drm
        };
    });

    const SUPABASE_URL = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';

    console.log(`Pushing ${payload.length} channels...`);

    const response = await fetch(`${SUPABASE_URL}/rest/v1/channels`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
            'Prefer': 'resolution=ignore-duplicates' // same as ON CONFLICT DO NOTHING
        },
        body: JSON.stringify(payload)
    });

    if (response.ok) {
        console.log('Successfully inserted channels (duplicates ignored).');
    } else {
        const text = await response.text();
        console.error('Error inserting channels:', response.status, text);
    }
}

main().catch(console.error);
