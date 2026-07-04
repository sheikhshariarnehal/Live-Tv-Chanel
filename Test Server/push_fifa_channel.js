/**
 * Push the FIFA channel (scraped from FifaLive.click) into the Supabase `channels` table.
 * Usage:  node push_fifa_channel.js
 *
 * NOTE: The stream URL contains an expiry token (hdntl=Expires=...).
 *       When it stops playing, re-scrape FifaLive.click and run this again.
 */

const fs = require('fs');

async function main() {
    const data = JSON.parse(fs.readFileSync('fifalive_channels.json', 'utf8'));

    // Flatten the scraped data into the same shape the `channels` table expects.
    const channel = data.channels[0];
    const server1 = channel.servers.server_1;

    const payload = [{
        id: 'fifa-2026-live-fhd',
        name: channel.name,
        logo: null,
        category: 'Sports',
        is_live: true,
        quality: 'FHD',
        stream_url: server1.url,
        headers: {
            // toffeelive.com is already in your proxy list — route through the worker.
            // A Referer/Origin matching the source helps some CDNs.
            'Referer': 'https://fifalive.click/',
            'Origin': 'https://fifalive.click'
        },
        proxy: true,   // goes through fifa-proxy-worker.js
        drm: null
    }];

    const SUPABASE_URL = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';

    console.log(`Pushing channel: ${payload[0].name} ...`);

    const response = await fetch(`${SUPABASE_URL}/rest/v1/channels`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
            'Prefer': 'resolution=ignore-duplicates' // ON CONFLICT DO NOTHING
        },
        body: JSON.stringify(payload)
    });

    if (response.ok) {
        console.log('✅ Successfully inserted FIFA channel (duplicate ignored if already exists).');
    } else {
        const text = await response.text();
        console.error('❌ Error inserting channel:', response.status, text);
    }
}

main().catch(console.error);
