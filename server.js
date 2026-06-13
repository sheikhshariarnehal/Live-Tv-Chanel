const express = require('express');
const { Readable } = require('stream');
const path = require('path');

const app = express();
const DIST = path.join(__dirname, 'dist');

// Serve static files from dist
app.use(express.static(DIST, { extensions: ['html'] }));

// Health check
app.get('/health', (req, res) => res.send('ok'));

// Simple proxy endpoint: /proxy?url=<encoded-url>
// Streams the upstream response to the client, forwarding most headers.
app.get('/proxy', async (req, res) => {
  const url = req.query.url;
  if (!url) return res.status(400).send('Missing url query parameter');
  if (!/^https?:\/\//i.test(url)) return res.status(400).send('Invalid url protocol');

  try {
    const upstream = await fetch(url, {
      method: 'GET',
      headers: {
        ...(req.headers.range ? { range: req.headers.range } : {}),
        'user-agent': req.headers['user-agent'] || 'node-proxy',
        accept: req.headers.accept || '*/*'
      }
    });

    if (!upstream.ok) return res.status(502).send('Upstream error: ' + upstream.status);

    // Set CORS so browsers can fetch proxied resources
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'Range,Content-Type');

    // Forward selected headers from upstream (excluding hop-by-hop)
    upstream.headers.forEach((value, name) => {
      const forbidden = ['connection', 'transfer-encoding', 'keep-alive'];
      if (!forbidden.includes(name.toLowerCase())) res.setHeader(name, value);
    });

    // If playlist (m3u8), rewrite segment/URI lines to route through /proxy
    const contentType = upstream.headers.get('content-type') || '';
    const isPlaylist = contentType.includes('application/vnd.apple.mpegurl') || contentType.includes('vnd.apple.mpegurl') || url.toLowerCase().endsWith('.m3u8');

    if (isPlaylist) {
      const text = await upstream.text();
      const base = new URL(url);
      const lines = text.split(/\r?\n/);
      const rewritten = lines.map(line => {
        if (!line || line.startsWith('#')) return line;
        // If already absolute http(s), proxy it
        try {
          const resolved = new URL(line, base).toString();
          return '/proxy?url=' + encodeURIComponent(resolved);
        } catch (e) {
          return line;
        }
      }).join('\n');
      res.setHeader('Content-Type', 'application/vnd.apple.mpegurl');
      return res.status(200).send(rewritten);
    }

    // Stream binary responses (ts segments, etc.)
    const body = upstream.body;
    if (!body) return res.status(502).send('No body from upstream');
    res.status(upstream.status || 200);
    Readable.fromWeb(body).pipe(res);
  } catch (err) {
    console.error('Proxy error', err);
    res.status(500).send('Proxy fetch failed');
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Server listening on port ${port}`));
