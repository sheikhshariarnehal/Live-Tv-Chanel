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

export async function GET({ request }) {
  const url = new URL(request.url);
  const targetUrl = url.searchParams.get('url');

  if (!targetUrl) {
    return new Response('Target URL required', { status: 400 });
  }

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
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64 AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
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
          if (absoluteUrl.includes('.m3u8')) {
            return '/proxy?url=' + encodeURIComponent(absoluteUrl);
          }
          return absoluteUrl;
        }
        if (line.startsWith('#EXT-X-KEY') || line.startsWith('#EXT-X-MAP')) {
          return line.replace(/URI="([^"]+)"/, (match, uri) => {
             let absoluteUrl = uri;
             if (!uri.startsWith('http')) {
               absoluteUrl = uri.startsWith('/') ? baseUrl.origin + uri : basePath + uri;
             }
             if (line.startsWith('#EXT-X-KEY') || absoluteUrl.includes('.m3u8')) {
               return `URI="/proxy?url=${encodeURIComponent(absoluteUrl)}"`;
             }
             return `URI="${absoluteUrl}"`;
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
