const fs = require('fs');

async function main() {
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

    const SUPABASE_URL = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
    const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';

    console.log(`Updating ${channels.length} IDs...`);
    for (const ch of channels) {
        let baseSlug = slugify(ch.name);
        if (!baseSlug) baseSlug = 'channel';
        
        let success = false;
        let counter = 1;
        let finalSlug = baseSlug;

        while (!success) {
            const res = await fetch(`${SUPABASE_URL}/rest/v1/channels?id=eq.${ch.id}`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    'apikey': SUPABASE_KEY,
                    'Authorization': `Bearer ${SUPABASE_KEY}`
                },
                body: JSON.stringify({ id: finalSlug })
            });

            if (res.ok) {
                success = true;
            } else {
                const text = await res.text();
                if (text.includes('duplicate key value violates unique constraint') || text.includes('409') || text.includes('already exists')) {
                    counter++;
                    finalSlug = `${baseSlug}-${counter}`;
                } else {
                    console.error("Error updating", ch.id, text);
                    break;
                }
            }
        }
    }
    console.log("Done.");
}

main().catch(console.error);
