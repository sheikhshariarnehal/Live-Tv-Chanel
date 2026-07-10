const https = require('https');

const SUPABASE_URL = 'hqmhuvsjlykrdusfkmeg.supabase.co';
const KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';

function patch(path, body) {
    return new Promise((resolve, reject) => {
        const data = JSON.stringify(body);
        const options = {
            hostname: SUPABASE_URL,
            path: path,
            method: 'PATCH',
            headers: {
                'apikey': KEY,
                'Authorization': 'Bearer ' + KEY,
                'Content-Type': 'application/json',
                'Prefer': 'return=representation',
                'Content-Length': Buffer.byteLength(data)
            }
        };
        const req = https.request(options, (res) => {
            let result = '';
            res.on('data', chunk => result += chunk);
            res.on('end', () => resolve({ status: res.statusCode, body: result }));
        });
        req.on('error', reject);
        req.write(data);
        req.end();
    });
}

async function main() {
    // Bump channels_version to force all Flutter apps to re-sync
    const result = await patch('/rest/v1/app_settings?id=eq.1', {
        channels_version: 2258
    });
    console.log('Status:', result.status);
    console.log('Response:', result.body);
    if (result.status >= 200 && result.status < 300) {
        console.log('\nSUCCESS: channels_version bumped to 2258');
        console.log('All Flutter apps will now re-sync and load all 156 channels.');
    } else {
        console.error('\nFAILED to bump version - RLS may be blocking. Trying via SQL...');
    }
}

main().catch(console.error);
