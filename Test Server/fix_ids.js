const fs = require('fs');

const dataStr = fs.readFileSync('C:/Users/sheik/.gemini/antigravity/brain/195075f1-ef46-44c4-b66c-ab4647001d5c/.system_generated/steps/130/output.txt', 'utf8');

const fileJson = JSON.parse(dataStr);
const resultStr = fileJson.result;
const start = resultStr.indexOf('[{');
const end = resultStr.lastIndexOf('}]') + 2;
const channels = JSON.parse(resultStr.substring(start, end));

const slugify = (text) => {
    return text.toString().toLowerCase()
        .replace(/\s+/g, '-')           
        .replace(/[^\w\-]+/g, '')       
        .replace(/\-\-+/g, '-')         
        .replace(/^-+/, '')             
        .replace(/-+$/, '');            
};

const seenIds = new Set();
let sql = '';

for (const ch of channels) {
    let baseSlug = slugify(ch.name);
    if (!baseSlug) baseSlug = 'channel';
    
    let finalSlug = baseSlug;
    let counter = 1;
    while (seenIds.has(finalSlug)) {
        counter++;
        finalSlug = `${baseSlug}-${counter}`;
    }
    seenIds.add(finalSlug);
    
    // We update the ID in the channels table
    // PostgreSQL allows updating primary keys.
    sql += `UPDATE channels SET id = '${finalSlug.replace(/'/g, "''")}' WHERE id = '${ch.id.replace(/'/g, "''")}';\n`;
}

fs.writeFileSync('fix_ids.sql', sql);
console.log(`Generated fix_ids.sql with ${channels.length} updates`);
