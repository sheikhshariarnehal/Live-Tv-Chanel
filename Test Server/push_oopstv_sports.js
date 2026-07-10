
const https = require('https');

const SUPABASE_URL = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';
const M3U_URL = 'https://raw.githubusercontent.com/IPTVFlixBD/OopsTv/refs/heads/main/new-sports-fast.m3u';

function slugify(text) {
    return text.toString().toLowerCase()
        .replace(/\s+/g, '-')
        .replace(/[^\w\-]+/g, '')
        .replace(/\-\-+/g, '-')
        .replace(/^-+/, '')
        .replace(/-+$/, '');
}

function fetchUrl(url) {
    return new Promise((resolve, reject) => {
        https.get(url, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => resolve(data));
            res.on('error', reject);
        }).on('error', reject);
    });
}

async function main() {
    console.log('Fetching M3U playlist from OopsTv...');
    const m3uContent = await fetchUrl(M3U_URL);
    const lines = m3uContent.split('\n');

    const channels = [];
    let currentChannel = {};

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();
        if (!line) continue;

        if (line.startsWith('#EXTINF:')) {
            currentChannel = {};

            const nameMatch = line.match(/,(.+)$/);
            if (nameMatch) {
                currentChannel.name = nameMatch[1].trim();
                currentChannel.id = slugify(currentChannel.name) + '-oopstv';
            }

            const logoMatch = line.match(/tvg-logo="([^"]+)"/);
            if (logoMatch) currentChannel.logo = logoMatch[1];

            const groupMatch = line.match(/group-title="([^"]+)"/);
            if (groupMatch) currentChannel.group = groupMatch[1];

        } else if (!line.startsWith('#')) {
            let urlPart = line;
            let headersPart = '';

            if (line.includes('|')) {
                const parts = line.split('|');
                urlPart = parts[0];
                headersPart = parts.slice(1).join('|');
            }

            currentChannel.url = urlPart;

            if (headersPart) {
                const headers = {};
                const pairs = headersPart.split('&');
                for (const pair of pairs) {
                    const eqIdx = pair.indexOf('=');
                    if (eqIdx > -1) {
                        const k = pair.substring(0, eqIdx);
                        const v = pair.substring(eqIdx + 1);
                        headers[k] = decodeURIComponent(v);
                    }
                }
                if (headers['User-Agent'] || headers['user-agent']) {
                    currentChannel['user-agent'] = headers['User-Agent'] || headers['user-agent'];
                }
                if (headers['Referer'] || headers['referer']) {
                    currentChannel.referer = headers['Referer'] || headers['referer'];
                }
            }

            if (currentChannel.id && currentChannel.url) {
                channels.push({ ...currentChannel });
            }
            currentChannel = {};
        }
    }

    console.log('Parsed ' + channels.length + ' total channels.');

    // Build payload - all channels go to 'sports' category
    let sortOrder = 1;
    const payload = channels.map(ch => {
        const headers = {};
        if (ch.referer) headers['Referer'] = ch.referer;
        if (ch['user-agent']) headers['User-Agent'] = ch['user-agent'];

        return {
            id: ch.id,
            name: ch.name,
            logo: ch.logo || null,
            category: 'sports',
            is_live: true,
            quality: 'HD',
            stream_url: ch.url,
            headers: Object.keys(headers).length > 0 ? headers : {},
            proxy: false,
            drm: null,
            sort_order: sortOrder++
        };
    });

    // Deduplicate by ID
    const uniqueMap = new Map();
    for (const item of payload) {
        uniqueMap.set(item.id, item);
    }
    const uniquePayload = Array.from(uniqueMap.values());

    console.log('Pushing ' + uniquePayload.length + ' unique channels to sports category...');

    // Push in batches of 100
    const BATCH_SIZE = 100;
    let successCount = 0;
    let errorCount = 0;

    for (let i = 0; i < uniquePayload.length; i += BATCH_SIZE) {
        const batch = uniquePayload.slice(i, i + BATCH_SIZE);
        const batchNum = Math.floor(i / BATCH_SIZE) + 1;
        const totalBatches = Math.ceil(uniquePayload.length / BATCH_SIZE);

        const response = await fetch(SUPABASE_URL + '/rest/v1/channels', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'apikey': SUPABASE_KEY,
                'Authorization': 'Bearer ' + SUPABASE_KEY,
                'Prefer': 'resolution=merge-duplicates'
            },
            body: JSON.stringify(batch)
        });

        if (response.ok) {
            successCount += batch.length;
            console.log('  Batch ' + batchNum + '/' + totalBatches + ' -- ' + batch.length + ' channels inserted OK.');
        } else {
            const text = await response.text();
            errorCount += batch.length;
            console.error('  Batch ' + batchNum + '/' + totalBatches + ' FAILED: ' + response.status + ' -- ' + text);
        }
    }

    console.log('\nDone! ' + successCount + ' inserted, ' + errorCount + ' failed.');
}

main().catch(console.error);
