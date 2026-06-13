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
      // Forward range header for partial requests (useful for video segments)
      headers: {
        ...(req.headers.range ? { range: req.headers.range } : {}),
        'user-agent': req.headers['user-agent'] || 'node-proxy'
      }
    });

    if (!upstream.ok) return res.status(502).send('Upstream error: ' + upstream.status);

    // Forward selected headers from upstream
    upstream.headers.forEach((value, name) => {
      const forbidden = ['connection', 'transfer-encoding', 'keep-alive'];
      if (!forbidden.includes(name.toLowerCase())) res.setHeader(name, value);
    });

    // Stream the response body
    const body = upstream.body;
    if (!body) return res.status(502).send('No body from upstream');
    // Node's fetch returns a WHATWG ReadableStream; convert to Node stream
    Readable.fromWeb(body).pipe(res);
  } catch (err) {
    console.error('Proxy error', err);
    res.status(500).send('Proxy fetch failed');
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Server listening on port ${port}`));
