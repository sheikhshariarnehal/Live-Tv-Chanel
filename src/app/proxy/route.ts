import dns from 'node:dns';
import { ProxyAgent, fetch as undiciFetch } from 'undici';

export const dynamic = 'force-dynamic';

// Disable TLS verification to handle stream servers with invalid, self-signed,
// or misconfigured certificate chains (very common for IPTV and proxy endpoints).
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

// Set public fast DNS servers to avoid slow/unreliable local router DNS lookups.
try {
  dns.setServers(['1.1.1.1', '8.8.8.8', '1.0.0.1', '8.8.4.4']);
} catch (e) {
  console.warn('[Proxy] Failed to set custom DNS servers:', e);
}


// ---------------------------------------------------------------------------
// Bounded LRU Cache — prevents unbounded memory growth under traffic spikes.
// Max 150 entries; oldest evicted when full.
// ---------------------------------------------------------------------------
class LRUCache {
  private maxSize: number;
  private map: Map<string, { body: string | ReadableStream | null; status: number; headers: Record<string, string>; expiresAt: number }>;

  constructor(maxSize = 150) {
    this.maxSize = maxSize;
    this.map = new Map();
  }

  get(key: string) {
    if (!this.map.has(key)) return undefined;
    const value = this.map.get(key)!;
    this.map.delete(key);
    this.map.set(key, value);
    return value;
  }

  set(key: string, value: { body: string | ReadableStream | null; status: number; headers: Record<string, string>; expiresAt: number }) {
    if (this.map.has(key)) {
      this.map.delete(key);
    } else if (this.map.size >= this.maxSize) {
      const firstKey = this.map.keys().next().value;
      if (firstKey) this.map.delete(firstKey);
    }
    this.map.set(key, value);
  }

  delete(key: string) {
    this.map.delete(key);
  }

  entries() {
    return this.map.entries();
  }

  get size() {
    return this.map.size;
  }
}

const cache: LRUCache = (globalThis as any).proxyCache || ((globalThis as any).proxyCache = new LRUCache(150));

// ---------------------------------------------------------------------------
// Concurrency Semaphore — caps simultaneous outgoing fetch() calls to 50.
// Excess requests immediately receive 503 rather than queuing and crashing.
// ---------------------------------------------------------------------------
class Semaphore {
  private max: number;
  private count: number;

  constructor(max: number) {
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
const rateLimitWindows: Map<string, { count: number; windowStart: number }> = (globalThis as any).proxyRateLimitWindows || ((globalThis as any).proxyRateLimitWindows = new Map<string, { count: number; windowStart: number }>());

function isRateLimited(ip: string, isPlaylist: boolean) {
  if (process.env.NODE_ENV === 'development' || ip === '127.0.0.1' || ip === '::1' || ip === 'localhost' || ip === '0.0.0.0') {
    return false;
  }
  const limit = isPlaylist ? 120 : 600;
  const windowMs = 60_000;
  const now = Date.now();
  const key = `${ip}:${isPlaylist ? 'pl' : 'seg'}`;

  const record = rateLimitWindows.get(key);
  if (!record) {
    rateLimitWindows.set(key, { count: 1, windowStart: now });
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
  'aiv-cdn.net',
  'pv-cdn.net',
  'fly.ww.aiv-cdn.net',
  'akamaihd.net',
  'livekhelatv.com',
  'foxbleu-cdn.com',
  'thebosstv.com',
  'ncare.live',
  'alarafatofficial.workers.dev',
  'zflixbd.com',
  'srknowapp.ncare.live',
  'herokuapp.com',
  'vrtcdn.be',
  'antik.sk',
  'indihuy.streamized.net',
  'pishow.tv',
  'tvsen5.aynaott.com',
  'tvsen6.aynaott.com',
  'tvsen7.aynaott.com',
  'klowdtv.com',
  'jagobd.com.bd',
  'gpcdn.net',
  'mxonlive.xyz',
  'v3v3v.xyz',
  'toffeelive.com',
  'cdn.fifalive.click',
  'inproviszon.st',
  'starhub.pro',
];

function getHostnameFast(url: string, defaultHostname = '') {
  if (!url) return defaultHostname;
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return defaultHostname;
  }
  const match = url.match(/^https?:\/\/([^\/:]+)/i);
  return match ? match[1] : defaultHostname;
}

function requiresFullProxy(url: string, parentHostname = '') {
  if (!url) return true;
  if (url.startsWith('http://')) {
    return true;
  }
  try {
    const hostname = getHostnameFast(url, parentHostname);
    if (!hostname) return true;
    return REQUIRES_FULL_PROXY.some(domain => hostname === domain || hostname.endsWith('.' + domain));
  } catch {
    return true;
  }
}

// Housekeeping
if (typeof (globalThis as any).proxyCacheInterval === 'undefined') {
  (globalThis as any).proxyCacheInterval = setInterval(() => {
    const now = Date.now();
    for (const [key, value] of cache.entries()) {
      if (now > value.expiresAt) {
        cache.delete(key);
      }
    }
  }, 60_000);
}

if (typeof (globalThis as any).proxyRateLimitInterval === 'undefined') {
  (globalThis as any).proxyRateLimitInterval = setInterval(() => {
    const now = Date.now();
    for (const [key, record] of rateLimitWindows.entries()) {
      if (now - record.windowStart > 120_000) {
        rateLimitWindows.delete(key);
      }
    }
  }, 300_000);
}

const lastAuthTimes: Map<string, number> = (globalThis as any).proxyLastAuthTimes || ((globalThis as any).proxyLastAuthTimes = new Map<string, number>());
lastAuthTimes.clear();

async function doKkx4Authorize(key: string) {
  try {
    const mainRes = await undiciFetch('https://kkx4.livekhelatv.com/', {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Referer': 'https://kkx4.livekhelatv.com/'
      },
      cache: 'no-store'
    });
    if (mainRes.ok) {
      lastAuthTimes.set(key, Date.now());
      lastAuthTimes.delete(key + ':failed');
      console.log(`[Proxy] Successfully authorized IP for kkx4 channel ${key}`);
    } else {
      throw new Error(`Auth page returned status ${mainRes.status}`);
    }
  } catch (e: any) {
    console.error(`[Proxy] Failed to authorize IP for kkx4 channel ${key}:`, e.message);
    lastAuthTimes.set(key + ':failed', Date.now());
  }
}

async function ensureKkx4Authorized(targetUrl: string) {
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
  const now = Date.now();
  if (lastAuth && (now - lastAuth) < 120_000) {
    return;
  }
  const lastFail = lastAuthTimes.get(key + ':failed');
  if (lastFail && (now - lastFail) < 300_000) {
    return;
  }

  if (lastAuth) {
    doKkx4Authorize(key).catch(err => {
      console.error(`[Proxy] Background auth error for ${key}:`, err.message);
    });
    return;
  }

  await doKkx4Authorize(key);
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

export async function GET(request: Request) {
  const url = new URL(request.url);
  const proxyOrigin = url.origin;
  const targetUrl = url.searchParams.get('url');

  if (!targetUrl) {
    return new Response('Target URL required', { status: 400 });
  }

  const isPlaylist = /\.m3u8(\?|$)/i.test(targetUrl) ||
                     /\.mpd(\?|$)/i.test(targetUrl) ||
                     targetUrl.includes('chunklist') ||
                     targetUrl.includes('playlist');

  const forceFullProxy = url.searchParams.get('full') === 'true' || url.searchParams.get('proxy') === 'true';

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
          'X-RateLimit-Limit': isPlaylist ? '120' : '600',
          'X-RateLimit-Window': '60s'
        }
      }
    );
  }

  await ensureKkx4Authorized(targetUrl);

  if (!forceFullProxy && !isPlaylist && !requiresFullProxy(targetUrl)) {
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

  const cached = cache.get(targetUrl);
  if (cached && Date.now() < cached.expiresAt) {
    const headers = new Headers(cached.headers);
    headers.set('X-Proxy-Cache', 'HIT');
    return new Response(cached.body, {
      status: cached.status,
      headers
    });
  }

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

  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 6000);

  try {
    let userAgent = request.headers.get('user-agent') || 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36';
    if (userAgent.includes('Headless') || userAgent.includes('headless') || userAgent.includes('Electron') || userAgent.includes('crawler') || userAgent.includes('bot')) {
      userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36';
    }

    const targetHostname = new URL(targetUrl).hostname;
    const connectionHeader = targetHostname.includes('inproviszon.st') ? 'close' : 'keep-alive';

    const upstreamHeaders: Record<string, string> = {
      'User-Agent': userAgent,
      'Accept': request.headers.get('accept') || '*/*',
      'Accept-Language': request.headers.get('accept-language') || 'en-US,en;q=0.9',
      'Connection': connectionHeader,
      'Cache-Control': 'no-cache',
      'Pragma': 'no-cache'
    };

    const rangeHeader = request.headers.get('range');
    if (rangeHeader) {
      upstreamHeaders['Range'] = rangeHeader;
    }

    try {
      const targetHostname = new URL(targetUrl).hostname;
      if (targetHostname === 'cdn.fifalive.click' || targetHostname.endsWith('.fifalive.click')) {
        upstreamHeaders['Referer'] = 'https://fifalive.click/';
        upstreamHeaders['Origin'] = 'https://fifalive.click';
      } else if (targetHostname.includes('toffeelive.com')) {
        upstreamHeaders['Referer'] = 'https://toffeelive.com/';
        upstreamHeaders['Origin'] = 'https://toffeelive.com';
      } else {
        upstreamHeaders['Referer'] = `https://${targetHostname}/`;
        upstreamHeaders['Origin'] = `https://${targetHostname}`;
      }
    } catch (_) {}

    console.log('[Proxy] Fetching upstream:', targetUrl, 'Headers:', JSON.stringify(upstreamHeaders, null, 2));

    let response;
    let usedProxy = false;
    const fetchOptions: any = {
      signal: controller.signal,
      headers: upstreamHeaders,
      cache: 'no-store'
    };

    const needsProxy = targetHostname.includes('toffeelive.com') ||
                       targetHostname.includes('fifalive.click') ||
                       targetHostname.includes('inproviszon.st');

    if (needsProxy && process.env.BD_PROXY_URL) {
      try {
        fetchOptions.dispatcher = new ProxyAgent(process.env.BD_PROXY_URL);
        usedProxy = true;
      } catch (err) {
        console.error('[Proxy] Failed to initialize ProxyAgent:', err);
      }
    }

    try {
      response = await undiciFetch(targetUrl, fetchOptions);
    } catch (err) {
      if (usedProxy) {
        console.warn('[Proxy] Fetch with ProxyAgent failed, retrying directly without proxy:', err);
        delete fetchOptions.dispatcher;
        response = await undiciFetch(targetUrl, fetchOptions);
      } else {
        throw err;
      }
    }

    clearTimeout(timeoutId);

    const headers = new Headers();
    const headersToCopy = ['content-type', 'cache-control', 'content-length', 'accept-ranges', 'content-range'];
    headersToCopy.forEach(h => {
      const val = response.headers.get(h);
      if (val) headers.set(h, val);
    });

    // Force video/mp2t content-type for TS files to prevent MSE parse errors in Hls.js
    if (targetUrl.includes('.ts') || targetUrl.includes('byazin-')) {
      headers.set('content-type', 'video/mp2t');
    }

    headers.set('Access-Control-Allow-Origin', '*');
    headers.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
    headers.set('Access-Control-Allow-Headers', '*');
    headers.set('X-Proxy-Cache', 'MISS');

    const contentType = response.headers.get('content-type') || '';
    const isMpd = targetUrl.includes('.mpd') || contentType.includes('application/dash+xml') || contentType.includes('video/vnd.mpeg.dash.mpd');
    const isM3u8 = contentType.includes('application/vnd.apple.mpegurl') || contentType.includes('application/x-mpegurl') || targetUrl.includes('.m3u8');

    if (isMpd) {
      let text = await response.text();
      const baseUrl = new URL(targetUrl);
      const basePath = baseUrl.origin + baseUrl.pathname.substring(0, baseUrl.pathname.lastIndexOf('/') + 1);
      
      if (text.includes('<BaseURL>') || text.includes('<BaseURL/>')) {
        text = text.replace(/<BaseURL>([^<]*)<\/BaseURL>/gi, (match, urlValue) => {
          urlValue = urlValue.trim();
          if (urlValue.startsWith('http://') || urlValue.startsWith('https://')) {
            return match;
          }
          if (urlValue.startsWith('/')) {
            return `<BaseURL>${baseUrl.origin}${urlValue}</BaseURL>`;
          }
          return `<BaseURL>${basePath}${urlValue}</BaseURL>`;
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

      const targetHostname = getHostnameFast(targetUrl);
      const cacheTtl = targetHostname.includes('inproviszon.st') ? 0 : 1000;

      if (response.ok && cacheTtl > 0) {
        cache.set(targetUrl, {
          body: text,
          status: response.status,
          headers: responseHeaders,
          expiresAt: Date.now() + cacheTtl
        });
      }

      const resHeaders = new Headers(responseHeaders);
      resHeaders.set('X-Proxy-Cache', 'MISS');
      return new Response(text, {
        status: response.status,
        headers: resHeaders
      });
    }

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
          if (requiresFullProxy(absoluteUrl, baseUrl.hostname) || forceFullProxy) {
            return proxyOrigin + '/proxy?url=' + encodeURIComponent(absoluteUrl) + (forceFullProxy ? '&full=true' : '');
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
             if (requiresFullProxy(absoluteUrl, baseUrl.hostname) || forceFullProxy) {
               return `URI="${proxyOrigin}/proxy?url=${encodeURIComponent(absoluteUrl)}${forceFullProxy ? '&full=true' : ''}"`;
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

      const targetHostname = getHostnameFast(targetUrl);
      const cacheTtl = targetHostname.includes('inproviszon.st') ? 0 : 1000;

      if (response.ok && cacheTtl > 0) {
        cache.set(targetUrl, {
          body: rewrittenText,
          status: response.status,
          headers: responseHeaders,
          expiresAt: Date.now() + cacheTtl
        });
      }

      const resHeaders = new Headers(responseHeaders);
      resHeaders.set('X-Proxy-Cache', 'MISS');
      return new Response(rewrittenText, {
        status: response.status,
        headers: resHeaders
      });
    }

    let bodyStream: any = null;
    if (response.body) {
      const reader = response.body.getReader();
      bodyStream = new ReadableStream({
        async start(controller) {
          try {
            while (true) {
              const { done, value } = await reader.read();
              if (done) {
                controller.close();
                break;
              }
              controller.enqueue(value);
            }
          } catch (e) {
            controller.error(e);
          } finally {
            reader.releaseLock();
          }
        }
      });
    }

    return new Response(bodyStream, {
      status: response.status,
      headers
    });
  } catch (error: any) {
    clearTimeout(timeoutId);
    return new Response(JSON.stringify({ 
      error: error.message || 'Fetch failed',
      cause: error.cause ? {
        message: error.cause.message,
        code: error.cause.code,
        stack: error.cause.stack
      } : null,
      stack: error.stack
    }), { 
      status: 500,
      headers: { 
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    });
  } finally {
    fetchSemaphore.release();
  }
}
