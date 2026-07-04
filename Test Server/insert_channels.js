const fs = require('fs');

const data = JSON.parse(fs.readFileSync('scrabe_1.json', 'utf8'));

const channels = data.channels || [];
let sql = ``;

for (const ch of channels) {
    const id = ch.id.replace(/'/g, "''");
    const name = ch.name.replace(/'/g, "''");
    const logo = ch.logo ? ch.logo.replace(/'/g, "''") : null;
    const category = 'test-category';
    const is_live = true;
    const quality = ch.resolution || 'HD';
    const stream_url = ch.url.replace(/'/g, "''");
    
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

    sql += `
INSERT INTO channels (
    id, name, logo, category, is_live, quality, stream_url, headers, proxy, drm
) VALUES (
    '${id}', '${name}', ${logo ? `'${logo}'` : 'NULL'}, '${category}', ${is_live}, '${quality}', '${stream_url}', ${headersStr}, ${proxy}, ${drmStr}
) ON CONFLICT (id) DO NOTHING;
`;
}

// Update channels_version
sql += `\nUPDATE app_settings SET channels_version = channels_version + 1, updated_at = now() WHERE id = 1;`;

fs.writeFileSync('insert_channels.sql', sql);
console.log('Generated insert_channels.sql');
