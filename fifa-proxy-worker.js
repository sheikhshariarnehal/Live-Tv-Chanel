/**
 * Cloudflare Worker: Stream Proxy
 * Offloads video stream proxying (CORS bypass, header spoofing, playlist rewriting)
 * from the Next.js VPS application to Cloudflare's edge network.
 */

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
  'ctghub.com',
  'rockstreamer.com',
  'pages.dev',
  'workers.dev',
  'fifalive.click',
];

// In-memory cache for special authentication times
const lastAuthTimes = new Map();

function getHostnameFast(url, defaultHostname = '') {
  if (!url) return defaultHostname;
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return defaultHostname;
  }
  const match = url.match(/^https?:\/\/([^\/:]+)/i);
  return match ? match[1] : defaultHostname;
}

function requiresFullProxy(url, parentHostname = '') {
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

async function doKkx4Authorize(key) {
  try {
    const mainRes = await fetch('https://kkx4.livekhelatv.com/', {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Referer': 'https://kkx4.livekhelatv.com/'
      }
    });
    if (mainRes.ok) {
      lastAuthTimes.set(key, Date.now());
      console.log(`[Proxy] Successfully authorized IP for kkx4 channel ${key}`);
    } else {
      throw new Error(`Auth page returned status ${mainRes.status}`);
    }
  } catch (e) {
    console.error(`[Proxy] Failed to authorize IP for kkx4 channel ${key}:`, e.message);
    lastAuthTimes.set(key + ':failed', Date.now());
  }
}

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
  const now = Date.now();
  if (lastAuth && (now - lastAuth) < 120_000) {
    return;
  }
  const lastFail = lastAuthTimes.get(key + ':failed');
  if (lastFail && (now - lastFail) < 300_000) {
    return;
  }

  if (lastAuth) {
    // Perform background re-authorization
    doKkx4Authorize(key).catch(err => {
      console.error(`[Proxy] Background auth error for ${key}:`, err.message);
    });
    return;
  }

  await doKkx4Authorize(key);
}

export default {
  async fetch(request, env, ctx) {
    // Handle CORS preflight OPTIONS request
    if (request.method === 'OPTIONS') {
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

    const urlObj = new URL(request.url);
    const targetUrl = urlObj.searchParams.get('url');

    if (!targetUrl) {
      return new Response('Target URL parameter "url" is required.', { 
        status: 400,
        headers: { 'Access-Control-Allow-Origin': '*' }
      });
    }

    const isPlaylist = /\.m3u8(\?|$)/i.test(targetUrl) ||
                       /\.mpd(\?|$)/i.test(targetUrl) ||
                       targetUrl.includes('chunklist') ||
                       targetUrl.includes('playlist');

    const forceFullProxy = urlObj.searchParams.get('full') === 'true' || urlObj.searchParams.get('proxy') === 'true';

    // 1. Authorization for kkx4 streams
    ctx.waitUntil(ensureKkx4Authorized(targetUrl));

    // 2. Bandwidth Optimization: 302 Redirect for segment URLs that don't need header spoofing
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

    // 3. Cache Check (only for Cloudflare CDN edge caching)
    const cache = caches.default;
    let cachedResponse = await cache.match(request);
    if (cachedResponse) {
      // Return a copy of cached response with HIT header
      const responseHeaders = new Headers(cachedResponse.headers);
      responseHeaders.set('X-Proxy-Cache', 'HIT');
      return new Response(cachedResponse.body, {
        status: cachedResponse.status,
        headers: responseHeaders
      });
    }

    // 4. Request Headers Customization (Referer/Origin Spoofing)
    let userAgent = request.headers.get('user-agent') || 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36';
    if (userAgent.includes('Headless') || userAgent.includes('headless') || userAgent.includes('Electron') || userAgent.includes('crawler') || userAgent.includes('bot')) {
      userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36';
    }

    const targetUrlObj = new URL(targetUrl);
    const targetHostname = targetUrlObj.hostname;
    const connectionHeader = targetHostname.includes('inproviszon.st') ? 'close' : 'keep-alive';

    const upstreamHeaders = {
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

    // Spoof Referer and Origin for specific servers
    if (targetHostname === 'cdn.fifalive.click' || targetHostname.endsWith('.fifalive.click') || targetHostname.endsWith('.workers.dev') || targetHostname === 'fifalive.click') {
      upstreamHeaders['Referer'] = 'https://fifalive.click/';
      upstreamHeaders['Origin'] = 'https://fifalive.click';
    } else if (targetHostname.includes('toffeelive.com')) {
      upstreamHeaders['Referer'] = 'https://toffeelive.com/';
      upstreamHeaders['Origin'] = 'https://toffeelive.com';
    } else {
      upstreamHeaders['Referer'] = `https://${targetHostname}/`;
      upstreamHeaders['Origin'] = `https://${targetHostname}`;
    }

    // 5. Fetch content from upstream
    try {
      const response = await fetch(targetUrl, {
        headers: upstreamHeaders,
        redirect: 'follow'
      });

      const responseHeaders = new Headers();
      const headersToCopy = ['content-type', 'cache-control', 'content-length', 'accept-ranges', 'content-range'];
      headersToCopy.forEach(h => {
        const val = response.headers.get(h);
        if (val) responseHeaders.set(h, val);
      });

      // Force video/mp2t content-type for TS files to prevent MSE parse errors in Hls.js
      if (targetUrl.includes('.ts') || targetUrl.includes('byazin-')) {
        responseHeaders.set('content-type', 'video/mp2t');
      }

      responseHeaders.set('Access-Control-Allow-Origin', '*');
      responseHeaders.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
      responseHeaders.set('Access-Control-Allow-Headers', '*');
      responseHeaders.set('X-Proxy-Cache', 'MISS');

      const contentType = response.headers.get('content-type') || '';
      const isMpd = targetUrl.includes('.mpd') || contentType.includes('application/dash+xml') || contentType.includes('video/vnd.mpeg.dash.mpd');
      const isM3u8 = contentType.includes('application/vnd.apple.mpegurl') || contentType.includes('application/x-mpegurl') || targetUrl.includes('.m3u8');

      const proxyPrefix = `${urlObj.origin}${urlObj.pathname}?url=`;

      // 6. DASH Playlist Manifest Rewriting
      if (isMpd) {
        responseHeaders.set('content-type', 'application/dash+xml');
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

        const rewrittenResponse = new Response(text, {
          status: response.status,
          headers: responseHeaders
        });

        // Cache playlist for 1 second on CDN to avoid hammering stream sources
        const cacheTtl = targetHostname.includes('inproviszon.st') ? 0 : 1;
        if (response.ok && cacheTtl > 0) {
          responseHeaders.set('Cache-Control', `public, max-age=${cacheTtl}`);
          ctx.waitUntil(cache.put(request, rewrittenResponse.clone()));
        }

        return rewrittenResponse;
      }

      // 7. HLS Playlist Manifest Rewriting
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
              return proxyPrefix + encodeURIComponent(absoluteUrl) + (forceFullProxy ? '&full=true' : '');
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
                 return `URI="${proxyPrefix}${encodeURIComponent(absoluteUrl)}${forceFullProxy ? '&full=true' : ''}"`;
               } else {
                 return `URI="${absoluteUrl}"`;
               }
            });
          }
          return line;
        });

        const rewrittenText = rewrittenLines.join('\n');
        
        // Force the content-type header for M3U8
        responseHeaders.set('content-type', 'application/vnd.apple.mpegurl');
        
        const rewrittenResponse = new Response(rewrittenText, {
          status: response.status,
          headers: responseHeaders
        });

        // Cache playlist for 1 second on CDN
        const cacheTtl = targetHostname.includes('inproviszon.st') ? 0 : 1;
        if (response.ok && cacheTtl > 0) {
          responseHeaders.set('Cache-Control', `public, max-age=${cacheTtl}`);
          ctx.waitUntil(cache.put(request, rewrittenResponse.clone()));
        }

        return rewrittenResponse;
      }

      // 8. Stream segment / binary chunk passthrough
      // Set longer cache time for segment chunks (e.g. 10 seconds) if they successfully resolve
      if (response.ok) {
        responseHeaders.set('Cache-Control', 'public, max-age=10');
      }

      const finalResponse = new Response(response.body, {
        status: response.status,
        headers: responseHeaders
      });

      if (response.ok) {
        ctx.waitUntil(cache.put(request, finalResponse.clone()));
      }

      return finalResponse;
    } catch (err) {
      return new Response(JSON.stringify({ 
        error: err.message || 'Fetch failed',
        stack: err.stack
      }), { 
        status: 500,
        headers: { 
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        }
      });
    }
  }
};
