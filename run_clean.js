const fs = require('fs');

async function main() {
    const dataStr = fs.readFileSync('C:/Users/sheik/.gemini/antigravity/brain/195075f1-ef46-44c4-b66c-ab4647001d5c/.system_generated/steps/72/output.txt', 'utf8');

    const fileJson = JSON.parse(dataStr);
    const resultStr = fileJson.result;
    const start = resultStr.indexOf('[{');
    const end = resultStr.lastIndexOf('}]') + 2;
    const channels = JSON.parse(resultStr.substring(start, end));

    const seenUrls = new Set();
    const toDelete = [];
    const toUpdate = [];

    for (const ch of channels) {
        let url = ch.stream_url;
        if (url.endsWith('?')) url = url.slice(0, -1);
        
        if (seenUrls.has(url)) {
            toDelete.push(ch.id);
            continue;
        }
        seenUrls.add(url);

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
                   
        if (!name) name = "Unknown Channel";

        name = name.toLowerCase().split(' ').map(word => word.charAt(0).toUpperCase() + word.substring(1)).join(' ');

        name = name.replace(/\bTv\b/g, 'TV');
        name = name.replace(/\bBbc\b/g, 'BBC');
        name = name.replace(/\bTsn\b/g, 'TSN');
        name = name.replace(/\bBein\b/g, 'beIN');

        toUpdate.push({ id: ch.id, name });
    }

    const SUPABASE_URL = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';

    console.log(`Deleting ${toDelete.length} duplicates...`);
    if (toDelete.length > 0) {
        const ids = toDelete.join(',');
        const res = await fetch(`${SUPABASE_URL}/rest/v1/channels?id=in.(${ids})`, {
            method: 'DELETE',
            headers: {
                'apikey': SUPABASE_KEY,
                'Authorization': `Bearer ${SUPABASE_KEY}`
            }
        });
        if (!res.ok) console.error("Error deleting:", await res.text());
    }

    console.log(`Updating ${toUpdate.length} names...`);
    for (const up of toUpdate) {
        const res = await fetch(`${SUPABASE_URL}/rest/v1/channels?id=eq.${up.id}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'apikey': SUPABASE_KEY,
                'Authorization': `Bearer ${SUPABASE_KEY}`
            },
            body: JSON.stringify({ name: up.name })
        });
        if (!res.ok) console.error("Error updating", up.id, await res.text());
    }

    console.log("Done.");
}

main().catch(console.error);
