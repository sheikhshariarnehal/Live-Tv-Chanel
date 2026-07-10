
const https = require('https');
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

function esc(str) {
    if (!str) return 'NULL';
    return "'" + String(str).replace(/'/g, "''") + "'";
}

async function main() {
    console.log('Fetching playlist...');
    const m3uContent = await fetchUrl(M3U_URL);
    const lines = m3uContent.split('\n');

    const channels = [];
    let cur = {};

    for (const line of lines) {
        const l = line.trim();
        if (!l) continue;

        if (l.startsWith('#EXTINF:')) {
            cur = {};
            const nameMatch = l.match(/,(.+)$/);
            if (nameMatch) {
                cur.name = nameMatch[1].trim();
                cur.id = slugify(cur.name) + '-oopstv';
            }
            const logoMatch = l.match(/tvg-logo="([^"]+)"/);
            if (logoMatch) cur.logo = logoMatch[1];
            const groupMatch = l.match(/group-title="([^"]+)"/);
            if (groupMatch) cur.group = groupMatch[1];
        } else if (!l.startsWith('#')) {
            let urlPart = l;
            let headersPart = '';
            if (l.includes('|')) {
                const parts = l.split('|');
                urlPart = parts[0];
                headersPart = parts.slice(1).join('|');
            }
            cur.url = urlPart;
            if (headersPart) {
                const headers = {};
                for (const pair of headersPart.split('&')) {
                    const eqIdx = pair.indexOf('=');
                    if (eqIdx > -1) {
                        const k = pair.substring(0, eqIdx);
                        const v = decodeURIComponent(pair.substring(eqIdx + 1));
                        headers[k] = v;
                    }
                }
                if (headers['User-Agent'] || headers['user-agent']) cur['user-agent'] = headers['User-Agent'] || headers['user-agent'];
                if (headers['Referer'] || headers['referer']) cur.referer = headers['Referer'] || headers['referer'];
            }
            if (cur.id && cur.url) channels.push({ ...cur });
            cur = {};
        }
    }

    // Deduplicate
    const uniqueMap = new Map();
    for (const ch of channels) uniqueMap.set(ch.id, ch);
    const unique = Array.from(uniqueMap.values());

    console.log('Total unique channels: ' + unique.length);

    // Build SQL values
    let sortOrder = 1;
    const rows = unique.map(ch => {
        const headers = {};
        if (ch.referer) headers['Referer'] = ch.referer;
        if (ch['user-agent']) headers['User-Agent'] = ch['user-agent'];
        const hdrsJson = JSON.stringify(headers).replace(/'/g, "''");
        
        return `(${esc(ch.id)}, ${esc(ch.name)}, ${esc(ch.logo)}, 'sports', true, 'HD', ${esc(ch.url)}, '${hdrsJson}'::jsonb, false, NULL, ${sortOrder++})`;
    });

    // Split into batches of 50 for SQL safety
    const BATCH = 50;
    const sqlBatches = [];
    for (let i = 0; i < rows.length; i += BATCH) {
        const batch = rows.slice(i, i + BATCH);
        const sql = `INSERT INTO channels (id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order)
VALUES
${batch.join(',\n')}
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo,
  category = EXCLUDED.category,
  is_live = EXCLUDED.is_live,
  quality = EXCLUDED.quality,
  stream_url = EXCLUDED.stream_url,
  headers = EXCLUDED.headers,
  proxy = EXCLUDED.proxy,
  drm = EXCLUDED.drm,
  sort_order = EXCLUDED.sort_order;`;
        sqlBatches.push(sql);
    }

    // Write sql batches to file so MCP can pick them up
    const fs = require('fs');
    fs.writeFileSync('oopstv_sports_batches.json', JSON.stringify(sqlBatches, null, 2));
    console.log('Written ' + sqlBatches.length + ' SQL batches to oopstv_sports_batches.json');
}

main().catch(console.error);
