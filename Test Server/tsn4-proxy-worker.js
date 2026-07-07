/**
 * Cloudflare Worker: Dedicated TSN4 SPORTS FHD Stream Proxy & Player
 * Hosts a premium embedded Shaka Player and acts as a header-spoofing/CORS proxy.
 * No external authentication scripts or "foxy code".
 */

const STREAM_URL = "https://otte.cache.aiv-cdn.net/bom-nitro/live/clients/dash/enc/ihys8nw4wv/out/v1/fde190f369484bc6b6117cc16cd82a9f/cenc.mpd";
const KEY_ID = "abc5b2883121012850ebda05b528c5ec";
const KEY = "e5250924f4b738905f7163a0134587a7";

export default {
  async fetch(request, env, ctx) {
    const urlObj = new URL(request.url);
    const path = urlObj.pathname;

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

    // 1. Serve the embedded premium player on /player or /index.html
    if (path === '/player' || path === '/index.html') {
      const html = getPlayerHTML(urlObj.origin);
      return new Response(html, {
        headers: { 'Content-Type': 'text/html; charset=utf-8' }
      });
    }

    // 1.1 Serve raw M3U playlist for TSN4 on root / and /playlist.m3u
    if (path === '/playlist.m3u' || (path === '/' && !urlObj.searchParams.has('url'))) {
      const m3u = `#EXTM3U

#EXTINF:-1 tvg-id="tsn4-sports-fhd" tvg-name="TSN4 SPORTS FHD" tvg-logo="https://akamaividz2.zee5.com/image/upload/w_1013,h_570,c_scale,f_webp,q_auto:eco/resources/0-1-6z5974942/list/1920x1080list0ce1240f590c42e5a0e83f278b2d1529ee8eb0fddfda4bb78445105c231d6efe" group-title="Sports", TSN4 SPORTS FHD
#KODIPROP:inputstream=inputstream.adaptive
#KODIPROP:inputstream.adaptive.manifest_type=mpd
#KODIPROP:inputstream.adaptive.license_type=clearkey
#KODIPROP:inputstream.adaptive.license_key=${KEY_ID}:${KEY}
${urlObj.origin}/manifest.mpd
`;
      return new Response(m3u, {
        headers: {
          'Content-Type': 'text/plain; charset=utf-8',
          'Access-Control-Allow-Origin': '*'
        }
      });
    }

    // 2. Stream Proxy Router
    let targetUrl = '';

    if (path === '/manifest.mpd') {
      targetUrl = STREAM_URL;
    } else {
      // Allow fallback to ?url= query parameter or custom sub-routes if needed
      targetUrl = urlObj.searchParams.get('url');
    }

    if (!targetUrl) {
      return new Response('TSN4 Proxy Worker is Active. Access / to watch the stream or /manifest.mpd to fetch the stream.', {
        status: 200,
        headers: { 'Content-Type': 'text/plain' }
      });
    }

    // 3. Upstream Request Execution
    try {
      const targetUrlObj = new URL(targetUrl);
      const targetHostname = targetUrlObj.hostname;

      const upstreamHeaders = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
        'Accept': request.headers.get('accept') || '*/*',
        'Accept-Language': request.headers.get('accept-language') || 'en-US,en;q=0.9',
        'Connection': 'keep-alive',
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache'
      };

      const rangeHeader = request.headers.get('range');
      if (rangeHeader) {
        upstreamHeaders['Range'] = rangeHeader;
      }

      // Spoof Referer and Origin for the target streaming host
      upstreamHeaders['Referer'] = `https://${targetHostname}/`;
      upstreamHeaders['Origin'] = `https://${targetHostname}`;

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

      responseHeaders.set('Access-Control-Allow-Origin', '*');
      responseHeaders.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
      responseHeaders.set('Access-Control-Allow-Headers', '*');

      const contentType = response.headers.get('content-type') || '';
      const isMpd = targetUrl.includes('.mpd') || contentType.includes('application/dash+xml') || contentType.includes('video/vnd.mpeg.dash.mpd');

      // If it is the DASH Manifest (MPD), rewrite relative URLs so media segments route back through this proxy worker
      if (isMpd) {
        responseHeaders.set('content-type', 'application/dash+xml');
        let text = await response.text();

        const baseUrl = new URL(targetUrl);
        const basePath = baseUrl.origin + baseUrl.pathname.substring(0, baseUrl.pathname.lastIndexOf('/') + 1);
        const proxyPrefix = `${urlObj.origin}${urlObj.pathname}?url=`;

        const hasAbsoluteBaseUrl = /<BaseURL>\s*https?:\/\//i.test(text);

        if (!hasAbsoluteBaseUrl) {
          if (text.includes('<BaseURL>') || text.includes('<BaseURL/>')) {
            text = text.replace(/<BaseURL>([^<]*)<\/BaseURL>/gi, (match, urlValue) => {
              urlValue = urlValue.trim();
              if (urlValue.startsWith('http://') || urlValue.startsWith('https://')) {
                return match;
              }
              let absoluteUrl = '';
              if (urlValue.startsWith('/')) {
                absoluteUrl = `${baseUrl.origin}${urlValue}`;
              } else {
                absoluteUrl = `${basePath}${urlValue}`;
              }
              return `<BaseURL>${proxyPrefix}${encodeURIComponent(absoluteUrl)}</BaseURL>`;
            });
          } else {
            // Inject BaseURL that goes through proxy worker
            text = text.replace(/<MPD([^>]*)>/i, (match, attrs) => {
              return `<MPD${attrs}>\n  <BaseURL>${proxyPrefix}${encodeURIComponent(basePath)}</BaseURL>`;
            });
          }
        }

        return new Response(text, {
          status: response.status,
          headers: responseHeaders
        });
      }

      // Segment or chunk passthrough
      if (response.ok) {
        responseHeaders.set('Cache-Control', 'public, max-age=15');
      }

      return new Response(response.body, {
        status: response.status,
        headers: responseHeaders
      });

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

/**
 * Returns the Premium HTML player client
 */
function getPlayerHTML(workerOrigin) {
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TSN4 SPORTS FHD - Premium Player</title>
  
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  
  <!-- Shaka Player CDN -->
  <script src="https://cdn.jsdelivr.net/npm/shaka-player@latest/dist/shaka-player.compiled.js"></script>

  <style>
    :root {
      --bg: #07090e;
      --panel: rgba(15, 18, 27, 0.75);
      --panel-border: rgba(255, 255, 255, 0.06);
      --accent: #e50914;
      --accent-glow: rgba(229, 9, 20, 0.4);
      --text: #f5f6f8;
      --text-muted: rgba(245, 246, 248, 0.6);
      --green: #00e676;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      background-color: var(--bg);
      color: var(--text);
      font-family: 'Outfit', sans-serif;
      height: 100vh;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }

    .app-container {
      width: 100%;
      max-width: 1100px;
      padding: 20px;
      display: flex;
      flex-direction: column;
      gap: 20px;
      height: 100%;
    }

    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 10px 0;
    }

    .logo-container {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .logo-container i {
      color: var(--accent);
      font-size: 24px;
      text-shadow: 0 0 12px var(--accent-glow);
    }

    .logo-container h1 {
      font-size: 20px;
      font-weight: 700;
      letter-spacing: 0.5px;
    }

    .badge {
      background: rgba(0, 230, 118, 0.15);
      color: var(--green);
      padding: 4px 10px;
      border-radius: 6px;
      font-size: 11px;
      font-weight: 600;
      border: 1px solid rgba(0, 230, 118, 0.2);
      display: flex;
      align-items: center;
      gap: 6px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .badge-pulse {
      width: 6px;
      height: 6px;
      background-color: var(--green);
      border-radius: 50%;
      box-shadow: 0 0 8px var(--green);
      animation: pulse 1.5s infinite;
    }

    @keyframes pulse {
      0% { transform: scale(0.95); opacity: 0.5; }
      50% { transform: scale(1.2); opacity: 1; }
      100% { transform: scale(0.95); opacity: 0.5; }
    }

    .player-wrapper {
      position: relative;
      flex: 1;
      width: 100%;
      background: #000;
      border-radius: 16px;
      overflow: hidden;
      border: 1px solid var(--panel-border);
      box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5);
    }

    video {
      width: 100%;
      height: 100%;
      object-fit: contain;
    }

    /* Loading Overlay */
    .overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: var(--bg);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      z-index: 100;
      gap: 16px;
      transition: opacity 0.4s ease;
    }

    .spinner {
      width: 50px;
      height: 50px;
      border: 3px solid rgba(255, 255, 255, 0.05);
      border-top-color: var(--accent);
      border-radius: 50%;
      animation: spin 1s infinite linear;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    .overlay p {
      font-size: 15px;
      color: var(--text-muted);
      font-weight: 500;
    }

    .info-card {
      background: var(--panel);
      border: 1px solid var(--panel-border);
      border-radius: 12px;
      padding: 16px;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .info-title {
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: var(--text-muted);
      font-weight: 600;
    }

    .info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 12px;
    }

    .info-item {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .info-label {
      font-size: 11px;
      color: var(--text-muted);
    }

    .info-value {
      font-size: 13px;
      font-weight: 500;
      word-break: break-all;
    }

    /* Logs Console */
    .console-log-box {
      background: #040508;
      border: 1px solid var(--panel-border);
      border-radius: 10px;
      padding: 12px;
      font-family: monospace;
      font-size: 11px;
      height: 120px;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .log-line {
      display: flex;
      gap: 8px;
    }

    .log-time {
      color: var(--text-muted);
    }

    .log-info { color: #00b0ff; }
    .log-success { color: var(--green); }
    .log-error { color: var(--accent); }
    .log-warn { color: #ffeb3b; }
  </style>
</head>
<body>

  <div class="app-container">
    <header>
      <div class="logo-container">
        <i class="fa-solid fa-circle-play"></i>
        <h1>TSN4 SPORTS FHD</h1>
      </div>
      <div class="badge">
        <div class="badge-pulse"></div>
        Live Stream
      </div>
    </header>

    <div class="player-wrapper">
      <div id="overlay" class="overlay">
        <div class="spinner"></div>
        <p id="overlay-text">Initializing player engine...</p>
      </div>
      <video id="video" controls autoplay crossorigin playsinline></video>
    </div>

    <div class="info-card">
      <div class="info-title">Stream Configuration</div>
      <div class="info-grid">
        <div class="info-item">
          <span class="info-label">Source Host</span>
          <span class="info-value">otte.cache.aiv-cdn.net</span>
        </div>
        <div class="info-item">
          <span class="info-label">DRM Protocol</span>
          <span class="info-value">DASH / ClearKey</span>
        </div>
        <div class="info-item">
          <span class="info-label">Key ID</span>
          <span class="info-value">${KEY_ID}</span>
        </div>
        <div class="info-item">
          <span class="info-label">ClearKey</span>
          <span class="info-value">${KEY}</span>
        </div>
      </div>
    </div>

    <div class="console-log-box" id="console-logs"></div>
  </div>

  <script>
    const video = document.getElementById('video');
    const overlay = document.getElementById('overlay');
    const overlayText = document.getElementById('overlay-text');
    const logBox = document.getElementById('console-logs');

    function log(message, type = 'info') {
      const now = new Date();
      const timeStr = now.toTimeString().split(' ')[0];
      
      const line = document.createElement('div');
      line.className = 'log-line';
      line.innerHTML = \`<span class="log-time">[\${timeStr}]</span> <span class="log-\${type}">\${message}</span>\`;
      
      logBox.appendChild(line);
      logBox.scrollTop = logBox.scrollHeight;
      console.log(\`[\${type.toUpperCase()}] \${message}\`);
    }

    async function initPlayer() {
      log("Installing Shaka Player polyfills...");
      shaka.polyfill.installAll();

      if (!shaka.Player.isBrowserSupported()) {
        log("Error: Browser does not support Shaka Player or EME DRM.", "error");
        overlayText.innerText = "Browser unsupported";
        return;
      }

      log("Creating player instance...");
      const player = new shaka.Player(video);
      window.player = player;

      player.addEventListener('error', (event) => {
        log("Player error: " + event.detail.code + " - " + event.detail.message, "error");
        overlayText.innerText = "Playback error";
        overlay.style.opacity = '1';
        overlay.style.pointerEvents = 'auto';
      });

      // Configure DRM Keys
      log("Configuring ClearKey DRM values...");
      player.configure({
        drm: {
          clearKeys: {
            "${KEY_ID}": "${KEY}"
          }
        },
        manifest: {
          retryParameters: {
            maxAttempts: 3,
            timeout: 8000
          }
        }
      });

      // Shaka Player Networking request filter to route segment files through the proxy automatically
      player.getNetworkingEngine().registerRequestFilter((type, request) => {
        const uri = request.uris[0];
        // Only rewrite if it's not already proxied, not local, and is on aiv-cdn
        if (uri.startsWith('http') && !uri.includes('localhost') && !uri.startsWith('${workerOrigin}')) {
          request.uris[0] = '${workerOrigin}/proxy?url=' + encodeURIComponent(uri);
        }
      });

      const manifestUrl = '${workerOrigin}/manifest.mpd';
      log("Loading proxied DASH manifest: " + manifestUrl);
      
      try {
        await player.load(manifestUrl);
        log("Manifest loaded successfully! Stream started.", "success");
        overlay.style.opacity = '0';
        overlay.style.pointerEvents = 'none';
        video.play().catch(e => {
          log("Autoplay blocked by browser. Please tap play button.", "warn");
        });
      } catch (err) {
        log("Loading failed: " + err.code + " - " + err.message, "error");
        overlayText.innerText = "Load failed: " + err.message;
      }
    }

    window.addEventListener('DOMContentLoaded', initPlayer);
  </script>
</body>
</html>`;
}
