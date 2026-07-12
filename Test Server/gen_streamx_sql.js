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

function escapeSql(str) {
    if (str === null || str === undefined) return 'NULL';
    return "'" + str.replace(/'/g, "''") + "'";
}

function escapeJsonb(obj) {
    if (obj === null || obj === undefined) return 'NULL';
    const jsonStr = JSON.stringify(obj);
    return "'" + jsonStr.replace(/'/g, "''") + "'::jsonb";
}

async function main() {
    const playlistPath = path.resolve(__dirname, '../../full_playlist.json');
    console.log(`Reading playlist from ${playlistPath}...`);
    const data = JSON.parse(fs.readFileSync(playlistPath, 'utf8'));
    const channels = data.channels || [];

    console.log(`Loaded ${channels.length} channels from JSON.`);

    let fifaSortCounter = 1597;
    let streamxSortCounter = 1;
    const seenIds = new Set();
    const rows = [];

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

        const logo = (ch.attributes ? (ch.attributes['tvg-logo'] || ch.attributes['group-logo']) : null) || null;

        rows.push(`(
            ${escapeSql(finalId)},
            ${escapeSql(ch.name)},
            ${escapeSql(logo)},
            ${escapeSql(categoryId)},
            NULL,
            NULL,
            ${escapeSql(ch.url)},
            true,
            false,
            'HD',
            ${escapeJsonb(channelHeaders)},
            ${sortOrder},
            false,
            ${escapeJsonb(drm)}
        )`);
    }

    const sqlContent = `
-- Insert channels generated from full_playlist.json
INSERT INTO public.channels (
    id, name, logo, category, country, language, stream_url, is_live, is_trending, quality, headers, sort_order, proxy, drm
) VALUES 
${rows.join(',\n')}
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    logo = EXCLUDED.logo,
    category = EXCLUDED.category,
    stream_url = EXCLUDED.stream_url,
    headers = EXCLUDED.headers,
    drm = EXCLUDED.drm,
    sort_order = EXCLUDED.sort_order;
`;

    const outputPath = path.resolve(__dirname, 'insert_streamx.sql');
    fs.writeFileSync(outputPath, sqlContent, 'utf8');
    console.log(`Successfully generated SQL insert file at ${outputPath}`);
}

main().catch(console.error);
