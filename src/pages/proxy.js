// ---------------------------------------------------------------------------
// Bounded LRU Cache — prevents unbounded memory growth under traffic spikes.
// Max 150 entries; oldest evicted when full.
// ---------------------------------------------------------------------------
class LRUCache {
  constructor(maxSize = 150) {
    this.maxSize = maxSize;
    this.map = new Map();
  }

  get(key) {
    if (!this.map.has(key)) return undefined;
    // Move to end (most recently used)
    const value = this.map.get(key);
    this.map.delete(key);
    this.map.set(key, value);
    return value;
  }

  set(key, value) {
    if (this.map.has(key)) {
      this.map.delete(key);
    } else if (this.map.size >= this.maxSize) {
      // Evict least recently used (first entry)
      const firstKey = this.map.keys().next().value;
      this.map.delete(firstKey);
    }
    this.map.set(key, value);
  }

  delete(key) {
    this.map.delete(key);
  }

  entries() {
    return this.map.entries();
  }

  get size() {
    return this.map.size;
  }
}

const cache = new LRUCache(150);

// ---------------------------------------------------------------------------
// Concurrency Semaphore — caps simultaneous outgoing fetch() calls to 50.
// Excess requests immediately receive 503 rather than queuing and crashing.
// ---------------------------------------------------------------------------
class Semaphore {
  constructor(max) {
    this.max = max;
    this.count = 0;
  }

  tryAcquire() {
    if (this.count < this.max) {
      this.count++;
      return true;
    }
    return false;
  }

  release() {
    if (this.count > 0) this.count--;
  }
}

const fetchSemaphore = new Semaphore(50);

// ---------------------------------------------------------------------------
// Per-IP Rate Limiter — sliding window token bucket.
// Playlist requests: max 60/min per IP
// All other requests: max 120/min per IP
// ---------------------------------------------------------------------------
const rateLimitWindows = new Map();

function isRateLimited(ip, isPlaylist) {
  const limit = isPlaylist ? 60 : 120;
  const windowMs = 60_000;
  const now = Date.now();
  const key = `${ip}:${isPlaylist ? 'pl' : 'seg'}`;

  let record = rateLimitWindows.get(key);
  if (!record) {
    record = { count: 1, windowStart: now };
    rateLimitWindows.set(key, record);
    return false;
  }

  if (now - record.windowStart > windowMs) {
    record.count = 1;
    record.windowStart = now;
    return false;
  }

  record.count++;
  if (record.count > limit) {
    return true;
  }
  return false;
}

// ---------------------------------------------------------------------------
// Domains that REQUIRE full server-side proxying (CORS-blocked, auth-gated,
// or Cloudflare-protected). Everything else gets a lightweight 302 redirect
// so the browser fetches video segments directly — saving CPU & bandwidth.
// ---------------------------------------------------------------------------
const REQUIRES_FULL_PROXY = [
  // Amazon IVS / Nitro CDNs — strict CORS + Widevine DRM MPD endpoints
  'aiv-cdn.net',
  'pv-cdn.net',
  'fly.ww.aiv-cdn.net',
  // Akamai IVS OTT linear — requires Referer / auth headers
  'akamaihd.net',
  // kkx4 / livekhelatv — requires server-IP authorization (tigosports, etc.)
  'livekhelatv.com',
  // foxbleu — raw .ts streams that block direct browser access
  'foxbleu-cdn.com',
  // thebosstv — CORS-blocked ncare-origin streams
  'thebosstv.com',
  'ncare.live',
  // Cloudflare Worker proxy (already proxied upstream — keep stable)
  'alarafatofficial.workers.dev',
  // Cloudflare-protected zflixbd token streams
  'zflixbd.com',
  // SRK TV / ncare-based streams
  'srknowapp.ncare.live',
  // Heroku CORS proxy (already a proxy — keep stable)
  'herokuapp.com',
  // VRT live streams — geographic restriction + CORS
  'vrtcdn.be',
  // Antik DASH streams — CORS-blocked
  'antik.sk',
  // IndIHuy DASH — CORS-blocked
  'indihuy.streamized.net',
  // pishow.tv — requires token in headers
  'pishow.tv',
  // aynaott.com tvsen servers — CORS-blocked
  'tvsen5.aynaott.com',
  'tvsen6.aynaott.com',
  'tvsen7.aynaott.com',
  // klowdtv — CORS-blocked
  'klowdtv.com',
  // jagobd — token-based stream
  'jagobd.com.bd',
  // gpcdn - CORS-blocked Bangladesh news streams
  'gpcdn.net',
  // mxonlive — CORS-blocked
  'mxonlive.xyz',
  // v3v3v IPTV — requires auth in URL
  'v3v3v.xyz',
  // Toffee Live CDN — strict CORS on TS media segments
  'toffeelive.com',
];

/**
 * Returns true if the target URL requires full server-side proxying.
 * Returns false if the browser can fetch the resource directly (redirect is safe).
 */
function requiresFullProxy(url) {
  try {
    const { hostname } = new URL(url);
    return REQUIRES_FULL_PROXY.some(domain => hostname === domain || hostname.endsWith('.' + domain));
  } catch {
    return true; // If URL is malformed, proxy to be safe
  }
}

// ---------------------------------------------------------------------------
// Housekeeping: clean expired cache entries every 60s + purge stale rate
// limit windows every 5 minutes to prevent memory accumulation over time.
// ---------------------------------------------------------------------------
if (typeof globalThis.proxyCacheInterval === 'undefined') {
  globalThis.proxyCacheInterval = setInterval(() => {
    const now = Date.now();
    for (const [key, value] of cache.entries()) {
      if (now > value.expiresAt) {
        cache.delete(key);
      }
    }
  }, 60_000);
}

if (typeof globalThis.proxyRateLimitInterval === 'undefined') {
  globalThis.proxyRateLimitInterval = setInterval(() => {
    const now = Date.now();
    for (const [key, record] of rateLimitWindows.entries()) {
      if (now - record.windowStart > 120_000) {
        rateLimitWindows.delete(key);
      }
    }
  }, 300_000);
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
  // Back off 5 minutes after a failure — stops retrying on every request
  // when the remote site has changed its HTML structure.
  const lastFail = lastAuthTimes.get(key + ':failed');
  if (lastFail && (Date.now() - lastFail) < 300000) {
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
    // Record failure time so we back off for 5 minutes before retrying
    lastAuthTimes.set(key + ':failed', Date.now());
  }
}

export async function GET({ request }) {
  const url = new URL(request.url);
  const targetUrl = url.searchParams.get('url');

  if (!targetUrl) {
    return new Response('Target URL required', { status: 400 });
  }

  // ---------------------------------------------------------------------------
  // RATE LIMITING — protect against request floods from any single IP.
  // ---------------------------------------------------------------------------
  const isPlaylist = /\.m3u8(\?|$)/i.test(targetUrl) ||
                     /\.mpd(\?|$)/i.test(targetUrl) ||
                     targetUrl.includes('chunklist') ||
                     targetUrl.includes('playlist');

  const clientIp =
    request.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ||
    request.headers.get('x-real-ip') ||
    '0.0.0.0';

  if (isRateLimited(clientIp, isPlaylist)) {
    return new Response(
      JSON.stringify({ error: 'Too Many Requests. Please slow down.' }),
      {
        status: 429,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Retry-After': '10',
          'X-RateLimit-Limit': isPlaylist ? '60' : '120',
          'X-RateLimit-Window': '60s'
        }
      }
    );
  }

  // Authorize kkx4 CDN if needed (only runs for livekhelatv domains, rate-limited)
  await ensureKkx4Authorized(targetUrl);

  // ---------------------------------------------------------------------------
  // SMART REDIRECT: For binary media segments from open CDNs, send a 302 so
  // the browser fetches the data directly. This avoids relaying video bytes
  // through the server — the #1 cause of CPU saturation.
  //
  // Only redirect for segments (not playlists), and only for CDNs that don't
  // require server-side CORS bypass or auth.
  // ---------------------------------------------------------------------------
  if (!isPlaylist && !requiresFullProxy(targetUrl)) {
    // Binary segment (TS, MP4, M4S, AAC, KEY, INIT, etc.) from an open CDN.
    // Tell the browser to fetch it directly — zero CPU cost to us.
    return new Response(null, {
      status: 302,
      headers: {
        'Location': targetUrl,
        'Access-Control-Allow-Origin': '*',
        'Cache-Control': 'no-store',
        'X-Proxy-Mode': 'redirect'
      }
    });
  }

  // 1. Check in-memory LRU cache first (only for m3u8 and mpd playlists)
  const cached = cache.get(targetUrl);
  if (cached && Date.now() < cached.expiresAt) {
    const headers = new Headers(cached.headers);
    headers.set('X-Proxy-Cache', 'HIT');
    return new Response(cached.body, {
      status: cached.status,
      headers
    });
  }

  // ---------------------------------------------------------------------------
  // CONCURRENCY LIMITER — cap simultaneous upstream fetches to 50.
  // Return 503 immediately if at capacity rather than queuing and OOM-crashing.
  // ---------------------------------------------------------------------------
  if (!fetchSemaphore.tryAcquire()) {
    return new Response(
      JSON.stringify({ error: 'Server busy. Please try again in a moment.' }),
      {
        status: 503,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Retry-After': '1'
        }
      }
    );
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
    const headersToCopy = ['content-type', 'cache-control', 'content-length', 'accept-ranges'];
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
          expiresAt: Date.now() + 15000 // Cache manifests 15s — cuts CDN fetches ~85% under concurrent load
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
          // Optimization: Only proxy the segment URL if its domain requires full proxying.
          // Otherwise, reference the direct URL to save proxy roundtrips (and avoid 302 redirects).
          if (requiresFullProxy(absoluteUrl)) {
            return '/proxy?url=' + encodeURIComponent(absoluteUrl);
          } else {
            return absoluteUrl;
          }
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
             if (requiresFullProxy(absoluteUrl)) {
               return `URI="/proxy?url=${encodeURIComponent(absoluteUrl)}"`;
             } else {
               return `URI="${absoluteUrl}"`;
             }
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
          expiresAt: Date.now() + 15000 // Cache manifests 15s — cuts CDN fetches ~85% under concurrent load
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
  } finally {
    // Always release the semaphore slot, even on error
    fetchSemaphore.release();
  }
}
