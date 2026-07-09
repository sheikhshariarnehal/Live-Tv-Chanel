const fs = require('fs');

function slugify(text) {
    return text.toString().toLowerCase()
        .replace(/\s+/g, '-')           // Replace spaces with -
        .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
        .replace(/\-\-+/g, '-')         // Replace multiple - with single -
        .replace(/^-+/, '')             // Trim - from start of text
        .replace(/-+$/, '');            // Trim - from end of text
}

function escapeSql(text) {
    if (!text) return '';
    return text.replace(/'/g, "''");
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

    // Build SQL query
    let sql = `-- Reborn Sports categories and channels import SQL\n\n`;

    // Step 1: Insert Categories
    sql += `-- 1. Categories Insertion\n`;
    let categorySortOrderStart = 17;
    for (const group of uniqueGroups) {
        const categoryName = `Reborn ${group}`;
        const categoryId = slugify(categoryName);
        
        sql += `INSERT INTO categories (id, name, icon, sort_order) VALUES (
    '${escapeSql(categoryId)}', '${escapeSql(categoryName)}', NULL, ${categorySortOrderStart++}
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name, 
    sort_order = EXCLUDED.sort_order;\n`;
    }

    sql += `\n-- 2. Channels Insertion\n`;

    // Remove duplicates from channels based on ID
    const uniqueChannelsMap = new Map();
    for (const ch of channels) {
        uniqueChannelsMap.set(ch.id, ch);
    }
    const uniqueChannels = Array.from(uniqueChannelsMap.values());

    // Track sort order per category
    const categorySortCounters = {};
    for (const group of uniqueGroups) {
        const categoryId = slugify(`Reborn ${group}`);
        categorySortCounters[categoryId] = 1;
    }

    for (const ch of uniqueChannels) {
        const groupName = ch.group || 'Sports';
        const categoryId = slugify(`Reborn ${groupName}`);
        const sortOrder = categorySortCounters[categoryId]++;

        const id = escapeSql(ch.id);
        const name = escapeSql(ch.name);
        const logo = ch.logo ? `'${escapeSql(ch.logo)}'` : 'NULL';
        const category = escapeSql(categoryId);
        const is_live = true;
        const quality = ch.resolution || 'HD';
        const stream_url = escapeSql(ch.url);

        let headers = {};
        if (ch.referer) headers.Referer = ch.referer;
        if (ch['user-agent']) headers['User-Agent'] = ch['user-agent'];
        const headersStr = Object.keys(headers).length > 0 ? `'${JSON.stringify(headers).replace(/'/g, "''")}'::jsonb` : `'{}'::jsonb`;

        const proxy = ch.proxy ? true : false;

        let drmStr = 'NULL';
        if (ch.drm) {
            const drmObj = {
                type: ch.drmSystem || 'clearkey',
                kid: ch.drm.kid,
                key: ch.drm.key,
                licenseUrl: ch.drm.licenseUrl
            };
            drmStr = `'${JSON.stringify(drmObj).replace(/'/g, "''")}'::jsonb`;
        }

        sql += `INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm, sort_order
) VALUES (
    '${id}', '${name}', ${logo}, '${category}', ${is_live}, '${quality}', '${stream_url}', ${headersStr}, ${proxy}, ${drmStr}, ${sortOrder}
) ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    logo = EXCLUDED.logo,
    category = EXCLUDED.category,
    is_live = EXCLUDED.is_live,
    quality = EXCLUDED.quality,
    stream_url = EXCLUDED.stream_url,
    headers = EXCLUDED.headers,
    proxy = EXCLUDED.proxy,
    drm = EXCLUDED.drm,
    sort_order = EXCLUDED.sort_order;\n`;
    }

    // Step 3: Update app_settings channels_version
    sql += `\n-- 3. Update app settings version\n`;
    sql += `UPDATE app_settings SET channels_version = channels_version + 1, updated_at = now() WHERE id = 1;\n`;

    fs.writeFileSync('insert_reborn_sports.sql', sql);
    console.log(`Generated insert_reborn_sports.sql with ${uniqueChannels.length} channels.`);
}

main().catch(console.error);
