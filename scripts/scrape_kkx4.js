import fs from 'fs';
import path from 'path';

function mlbdB64UrlToBytes(value) {
  let s = String(value || "").replace(/-/g, "+").replace(/_/g, "/");
  while (s.length % 4) s += "=";
  const bin = atob(s);
  const out = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
  return out;
}

async function decodePayload(payload, accessToken) {
  try {
    if (typeof payload === "string") {
      return JSON.parse(atob(String(payload || "").split("").reverse().join("")));
    }
    if (payload && payload.legacy && payload.data) {
      return JSON.parse(atob(String(payload.data || "").split("").reverse().join("")));
    }
    
    // AES-GCM
    const enc = new TextEncoder();
    const keyBytes = await crypto.subtle.digest("SHA-256", enc.encode(String(accessToken || "") + "|mlbd-web-stream-v2"));
    const key = await crypto.subtle.importKey("raw", keyBytes, {name: "AES-GCM"}, false, ["decrypt"]);
    
    const iv = mlbdB64UrlToBytes(payload.iv);
    const ct = mlbdB64UrlToBytes(payload.ct);
    const tag = mlbdB64UrlToBytes(payload.tag);
    
    if (!iv.length || !ct.length || !tag.length) return null;
    
    const packed = new Uint8Array(ct.length + tag.length);
    packed.set(ct, 0);
    packed.set(tag, ct.length);
    
    const plain = await crypto.subtle.decrypt({name: "AES-GCM", iv: iv, tagLength: 128}, key, packed);
    return JSON.parse(new TextDecoder().decode(plain));
  } catch (e) {
    console.error('Error decoding payload:', e);
    return null;
  }
}

async function scrape() {
  try {
    console.log('Fetching kkx4.livekhelatv.com home page...');
    const res = await fetch('https://kkx4.livekhelatv.com/', {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Referer': 'https://kkx4.livekhelatv.com/'
      }
    });
    const html = await res.text();
    
    console.log('Extracting CHANNELS configuration...');
    const regex = /const\s+CHANNELS\s*=\s*(\[[\s\S]*?\]);/g;
    const match = regex.exec(html);
    if (!match) {
      throw new Error('CHANNELS array not found in website source HTML.');
    }
    
    const channels = JSON.parse(match[1]);
    console.log(`Found ${channels.length} channels.`);
    
    const results = [];
    
    for (const channel of channels) {
      console.log(`Fetching stream parameters for: ${channel.name} (${channel.key})...`);
      
      const body = new URLSearchParams();
      body.set("key", channel.key);
      body.set("access", channel.play_token);
      
      const apiRes = await fetch(`https://kkx4.livekhelatv.com/v1/mks/channel?t=${Date.now()}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
          "Referer": "https://kkx4.livekhelatv.com/",
          "Origin": "https://kkx4.livekhelatv.com",
          "Cache-Control": "no-cache",
          "Pragma": "no-cache"
        },
        body: body.toString()
      });
      
      if (!apiRes.ok) {
        console.error(`Error: Received status ${apiRes.status} for channel ${channel.key}`);
        continue;
      }
      
      const json = await apiRes.json();
      if (!json.success) {
        console.error(`API Error for channel ${channel.key}:`, json.message);
        continue;
      }
      
      const decrypted = await decodePayload(json.payload, channel.play_token);
      if (decrypted) {
        results.push(decrypted);
        console.log(`Successfully fetched stream for ${channel.key}`);
      } else {
        console.error(`Could not decrypt payload for channel ${channel.key}`);
      }
    }
    
    // Format JSON with structured categories
    const outputData = {
      categories: {}
    };
    
    for (const item of results) {
      let categoryId = 'other';
      let categoryName = 'Other';
      if (item.category) {
        categoryName = item.category;
        categoryId = item.category.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
      }
      
      if (!outputData.categories[categoryId]) {
        outputData.categories[categoryId] = {
          name: categoryName,
          channels: []
        };
      }
      
      const chObj = {
        id: item.key,
        name: item.name,
        url: item.url,
        logo: item.image || ''
      };
      
      if (item.key_id && item.key_value) {
        chObj.drm = {
          kid: item.key_id,
          key: item.key_value
        };
      }
      
      outputData.categories[categoryId].channels.push(chObj);
    }
    
    const outputPath = path.resolve('public/assets/data/kkx4_channels.json');
    fs.writeFileSync(outputPath, JSON.stringify(outputData, null, 2), 'utf8');
    console.log(`Done! Saved ${results.length} channels to ${outputPath}`);
    
  } catch (err) {
    console.error('Scrape execution failed:', err);
  }
}

scrape();
