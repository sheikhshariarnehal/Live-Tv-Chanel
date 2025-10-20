const fetch = require('node-fetch');

module.exports = async (req, res) => {
  const url = req.query.url || req.url && new URL(req.url, `https://${req.headers.host}`).searchParams.get('url');
  if (!url) {
    res.status(400).send('Missing url parameter');
    return;
  }

  try {
    // Basic validation - allow only http/https
    if (!/^https?:\/\//i.test(url)) {
      res.status(400).send('Invalid url');
      return;
    }

    // Fetch the upstream resource
    const upstreamRes = await fetch(url);
    const contentType = upstreamRes.headers.get('content-type') || 'application/octet-stream';

    // If the content is an HLS playlist, rewrite relative segment URLs to route through proxy
    if (contentType.includes('application/vnd.apple.mpegurl') || contentType.includes('vnd.apple.mpegurl') || url.endsWith('.m3u8')) {
      const text = await upstreamRes.text();
      const base = url.substring(0, url.lastIndexOf('/') + 1);
      // Rewrite lines that look like URLs or relative paths
      const rewritten = text.split('\n').map(line => {
        if (line.trim().length === 0) return line;
        // comments and tags start with #
        if (line.startsWith('#')) return line;
        // if it's an absolute http/https url, proxy it
        if (/^https?:\/\//i.test(line)) {
          return `/api/proxy?url=${encodeURIComponent(line)}`;
        }
        // relative path -> make absolute and proxy
        const absolute = base + line;
        return `/api/proxy?url=${encodeURIComponent(absolute)}`;
      }).join('\n');

      res.setHeader('Content-Type', 'application/vnd.apple.mpegurl');
      res.send(rewritten);
      return;
    }

    // For other content (ts segments, etc), stream directly
    res.setHeader('Content-Type', contentType);
    const body = await upstreamRes.buffer();
    res.send(body);
  } catch (err) {
    console.error('Proxy error', err);
    res.status(502).send('Upstream fetch error');
  }
};
