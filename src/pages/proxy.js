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
    // Copy only safe/essential headers to avoid encoding or transmission conflicts on Vercel
    // Note: Do not copy 'content-length' because Node's fetch decompresses gzip/deflate/br bodies automatically,
    // which results in a mismatch between the decompressed body and the original compressed content-length.
    const headersToCopy = ['content-type', 'cache-control'];
    headersToCopy.forEach(h => {
      const val = response.headers.get(h);
      if (val) headers.set(h, val);
    });
    headers.set('Access-Control-Allow-Origin', '*');
    headers.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
    headers.set('Access-Control-Allow-Headers', '*');

    // Optimize caching for video segments (they are static/immutable and do not change)
    const lowerUrl = targetUrl.toLowerCase();
    if (lowerUrl.includes('.ts') || lowerUrl.includes('.m4s') || lowerUrl.includes('.m4i') || lowerUrl.includes('.dash') || lowerUrl.includes('.mp4') || lowerUrl.includes('.m4v')) {
      headers.set('Cache-Control', 'public, max-age=31536000, immutable');
    }
    
    // Rewrite m3u8 playlists so they also proxy the TS segments
    const contentType = response.headers.get('content-type') || '';

    // Handle DASH manifests (.mpd) to resolve relative segment paths
    if (targetUrl.includes('.mpd') || contentType.includes('application/dash+xml') || contentType.includes('video/vnd.mpeg.dash.mpd')) {
      let text = await response.text();
      const baseUrl = new URL(targetUrl);
      const basePath = baseUrl.origin + baseUrl.pathname.substring(0, baseUrl.pathname.lastIndexOf('/') + 1);
      
      // If the manifest already contains <BaseURL> tags, make sure they are absolute
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
        // Inject absolute <BaseURL> right after <MPD> tag
        text = text.replace(/<MPD([^>]*)>/i, (match, attrs) => {
          return `<MPD${attrs}>\n  <BaseURL>${basePath}</BaseURL>`;
        });
      }
      
      return new Response(text, {
        status: response.status,
        headers: {
          'Content-Type': 'application/dash+xml',
          'Access-Control-Allow-Origin': '*'
        }
      });
    }

    if (contentType.includes('application/vnd.apple.mpegurl') || contentType.includes('application/x-mpegurl') || targetUrl.includes('.m3u8')) {
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
          // Wrap the matched absolute URL in our proxy
          return '/proxy?url=' + encodeURIComponent(absoluteUrl);
        }
        // Handle URI inside tags like #EXT-X-KEY or #EXT-X-MAP
        if (line.startsWith('#EXT-X-KEY') || line.startsWith('#EXT-X-MAP')) {
          return line.replace(/URI="([^"]+)"/, (match, uri) => {
             let absoluteUrl = uri;
             if (!uri.startsWith('http')) {
               absoluteUrl = uri.startsWith('/') ? baseUrl.origin + uri : basePath + uri;
             }
             return `URI="/proxy?url=${encodeURIComponent(absoluteUrl)}"`;
          });
        }
        return line;
      });
      
      return new Response(rewrittenLines.join('\n'), {
        status: response.status,
        headers: {
          'Content-Type': 'application/vnd.apple.mpegurl',
          'Access-Control-Allow-Origin': '*'
        }
      });
    }

    // Stream the body directly to support live TV streams (.ts) and avoid infinite buffering
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
