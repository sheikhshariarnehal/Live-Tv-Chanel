const fs = require('fs');

const dataStr = fs.readFileSync('C:/Users/sheik/.gemini/antigravity/brain/195075f1-ef46-44c4-b66c-ab4647001d5c/.system_generated/steps/72/output.txt', 'utf8');

// Extract the JSON part
const fileJson = JSON.parse(dataStr);
const resultStr = fileJson.result;
const start = resultStr.indexOf('[{');
const end = resultStr.lastIndexOf('}]') + 2;
const channels = JSON.parse(resultStr.substring(start, end));

const seenUrls = new Set();
const toDelete = [];
const toUpdate = [];

for (const ch of channels) {
    // 1. Remove duplicate by URL
    let url = ch.stream_url;
    if (url.endsWith('?')) url = url.slice(0, -1); // normalize
    
    if (seenUrls.has(url)) {
        toDelete.push(ch.id);
        continue;
    }
    seenUrls.add(url);

    // 2. Clean Name
    let name = ch.name;
    if (name.includes('group-title=')) {
        name = name.substring(name.lastIndexOf(',') + 1).trim();
    }

    name = name.replace(/- AQ/ig, '')
               .replace(/\[.*?\]/g, '')
               .replace(/\(.*?\)/g, '')
               .replace(/\bFHD\b/ig, '')
               .replace(/\bUHD\b/ig, '')
               .replace(/\bHD\b/ig, '')
               .replace(/\b4K\b/ig, '')
               .replace(/\bSD\b/ig, '')
               .replace(/\bLIVE\b/ig, '')
               .replace(/\bSERVER\b/ig, '')
               .replace(/\bENG\b/ig, '')
               .replace(/\bAR\b/ig, '')
               .replace(/\bFAST\b/ig, '')
               .replace(/\s+/g, ' ')
               .trim();
               
    if (!name) {
        name = "Unknown Channel";
    }

    // Title Case
    name = name.toLowerCase().split(' ').map(word => word.charAt(0).toUpperCase() + word.substring(1)).join(' ');

    // specific cases
    name = name.replace(/\bTv\b/g, 'TV');
    name = name.replace(/\bBbc\b/g, 'BBC');
    name = name.replace(/\bTsn\b/g, 'TSN');
    name = name.replace(/\bBein\b/g, 'beIN');

    toUpdate.push({ id: ch.id, name });
}

let sql = '';
if (toDelete.length > 0) {
    const ids = toDelete.map(id => `'${id.replace(/'/g, "''")}'`).join(', ');
    sql += `DELETE FROM channels WHERE id IN (${ids});\n`;
}

for (const up of toUpdate) {
    sql += `UPDATE channels SET name = '${up.name.replace(/'/g, "''")}' WHERE id = '${up.id.replace(/'/g, "''")}';\n`;
}

sql += `UPDATE app_settings SET channels_version = channels_version + 1, updated_at = now() WHERE id = 1;\n`;

fs.writeFileSync('clean.sql', sql);
console.log(`Generated clean.sql. Deleting ${toDelete.length}, Updating ${toUpdate.length}`);
