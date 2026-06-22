const cache = new Map();

// Clean up expired cache entries periodically to prevent memory leaks
if (typeof globalThis.proxyCacheInterval === 'undefined') {
  globalThis.proxyCacheInterval = setInterval(() => {
    const now = Date.now();
    for (const [key, value] of cache.entries()) {
      if (now > value.expiresAt) {
        cache.delete(key);
      }
    }
  }, 10000);
}

export async function OPTIONS() {
  return new Response(null, {
    status: 204,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Access-Control-Allow-Headers': '*',
      'Access-Control-Max-Age': '86400'
    }
  });
}

const lastAuthTimes = new Map();

async function ensureKkx4Authorized(targetUrl) {
  let key = '';
  if (targetUrl.includes('otte.cache.aiv-cdn.net')) {
    key = 'foxeng';
  } else if (targetUrl.includes('otte-qw.live.pv-cdn.net')) {
    key = 'cazetv';
  } else if (targetUrl.includes('cdn.livekhelatv.com')) {
    key = 'tigosports';
  } else {
    return;
  }

  const lastAuth = lastAuthTimes.get(key);
  if (lastAuth && (Date.now() - lastAuth) < 120000) {
    return;
  }

  try {
    const mainRes = await fetch('https://kkx4.livekhelatv.com/', {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Referer': 'https://kkx4.livekhelatv.com/'
      }
    });
    const html = await mainRes.text();
    
    const regex = /const\s+CHANNELS\s*=\s*(\[[\s\S]*?\]);/g;
    const match = regex.exec(html);
    if (!match) throw new Error('CHANNELS not found');
    
    const channels = JSON.parse(match[1]);
    const ch = channels.find(c => c.key === key);
    if (!ch) throw new Error(`Key ${key} not found`);
    
    const body = new URLSearchParams();
    body.set("key", key);
    body.set("access", ch.play_token);
    
    const apiRes = await fetch(`https://kkx4.livekhelatv.com/v1/mks/channel?t=${Date.now()}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        'Referer': 'https://kkx4.livekhelatv.com/',
        'Origin': 'https://kkx4.livekhelatv.com',
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache'
      },
      body: body.toString()
    });
    
    if (apiRes.ok) {
      const json = await apiRes.json();
      if (json.success) {
        lastAuthTimes.set(key, Date.now());
      }
    }
  } catch (e) {
    console.error(`[Proxy] Failed to authorize IP for kkx4 channel ${key}:`, e.message);
  }
}

export async function GET({ request }) {
  const url = new URL(request.url);
  const targetUrl = url.searchParams.get('url');

  if (!targetUrl) {
    return new Response('Target URL required', { status: 400 });
  }

  // Authorize kkx4 CDN if needed
  await ensureKkx4Authorized(targetUrl);

  // 1. Check in-memory cache first (only for m3u8 and mpd playlists)
  const cached = cache.get(targetUrl);
  if (cached && Date.now() < cached.expiresAt) {
    const headers = new Headers(cached.headers);
    headers.set('X-Proxy-Cache', 'HIT');
    return new Response(cached.body, {
      status: cached.status,
      headers
    });
  }

  // Set a timeout of 5 seconds to prevent the function from hanging on unreachable IP addresses
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 5000);

  try {
    const response = await fetch(targetUrl, {
      signal: controller.signal,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache'
      }
    });

    clearTimeout(timeoutId);

    const headers = new Headers();
    const headersToCopy = ['content-type', 'cache-control'];
    headersToCopy.forEach(h => {
      const val = response.headers.get(h);
      if (val) headers.set(h, val);
    });
    headers.set('Access-Control-Allow-Origin', '*');
    headers.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
    headers.set('Access-Control-Allow-Headers', '*');
    headers.set('X-Proxy-Cache', 'MISS');

    const contentType = response.headers.get('content-type') || '';
    const isMpd = targetUrl.includes('.mpd') || contentType.includes('application/dash+xml') || contentType.includes('video/vnd.mpeg.dash.mpd');
    const isM3u8 = contentType.includes('application/vnd.apple.mpegurl') || contentType.includes('application/x-mpegurl') || targetUrl.includes('.m3u8');

    // A. Handle DASH manifests (.mpd) to resolve relative segment paths
    if (isMpd) {
      let text = await response.text();
      const baseUrl = new URL(targetUrl);
      const basePath = baseUrl.origin + baseUrl.pathname.substring(0, baseUrl.pathname.lastIndexOf('/') + 1);
      
      if (text.includes('<BaseURL>') || text.includes('<BaseURL/>')) {
        text = text.replace(/<BaseURL>([^<]*)<\/BaseURL>/gi, (match, urlValue) => {
          urlValue = urlValue.trim();
          if (urlValue.startsWith('http://') || urlValue.startsWith('https://')) {
            return match; // Already absolute
          }
          if (urlValue.startsWith('/')) {
            return `<BaseURL>${baseUrl.origin}${urlValue}</BaseURL>`; // Path-absolute
          }
          return `<BaseURL>${basePath}${urlValue}</BaseURL>`; // Relative path
        });
      } else {
        text = text.replace(/<MPD([^>]*)>/i, (match, attrs) => {
          return `<MPD${attrs}>\n  <BaseURL>${basePath}</BaseURL>`;
        });
      }
      
      const responseHeaders = {
        'Content-Type': 'application/dash+xml',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': '*'
      };

      if (response.ok) {
        cache.set(targetUrl, {
          body: text,
          status: response.status,
          headers: responseHeaders,
          expiresAt: Date.now() + 2000 // Cache playlists for 2 seconds
        });
      }

      const resHeaders = new Headers(responseHeaders);
      resHeaders.set('X-Proxy-Cache', 'MISS');
      return new Response(text, {
        status: response.status,
        headers: resHeaders
      });
    }

    // B. Rewrite m3u8 playlists so they also proxy the TS segments
    if (isM3u8) {
      const text = await response.text();
      const baseUrl = new URL(targetUrl);
      const basePath = baseUrl.origin + baseUrl.pathname.substring(0, baseUrl.pathname.lastIndexOf('/') + 1);
      
      const rewrittenLines = text.split('\n').map(line => {
        line = line.trim();
        if (line && !line.startsWith('#')) {
          let absoluteUrl = line;
          if (!line.startsWith('http')) {
            absoluteUrl = line.startsWith('/') ? baseUrl.origin + line : basePath + line;
          }
          if (baseUrl.search && !absoluteUrl.includes('?')) {
            absoluteUrl += baseUrl.search;
          }
          return '/proxy?url=' + encodeURIComponent(absoluteUrl);
        }
        if (line.startsWith('#EXT-X-KEY') || line.startsWith('#EXT-X-MAP')) {
          return line.replace(/URI="([^"]+)"/, (match, uri) => {
             let absoluteUrl = uri;
             if (!uri.startsWith('http')) {
               absoluteUrl = uri.startsWith('/') ? baseUrl.origin + uri : basePath + uri;
             }
             if (baseUrl.search && !absoluteUrl.includes('?')) {
               absoluteUrl += baseUrl.search;
             }
             return `URI="/proxy?url=${encodeURIComponent(absoluteUrl)}"`;
          });
        }
        return line;
      });

      const rewrittenText = rewrittenLines.join('\n');
      const responseHeaders = {
        'Content-Type': 'application/vnd.apple.mpegurl',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': '*'
      };

      if (response.ok) {
        cache.set(targetUrl, {
          body: rewrittenText,
          status: response.status,
          headers: responseHeaders,
          expiresAt: Date.now() + 2000 // Cache playlists for 2 seconds
        });
      }

      const resHeaders = new Headers(responseHeaders);
      resHeaders.set('X-Proxy-Cache', 'MISS');
      return new Response(rewrittenText, {
        status: response.status,
        headers: resHeaders
      });
    }

    // Default fallback (uncached continuous MPEG-TS streams or general redirects/errors)
    // Streams the body directly to prevent buffering infinite live streams in memory
    return new Response(response.body, {
      status: response.status,
      headers
    });
  } catch (error) {
    clearTimeout(timeoutId);
    return new Response(JSON.stringify({ error: error.message || 'Fetch failed' }), { 
      status: 500,
      headers: { 
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    });
  }
}
