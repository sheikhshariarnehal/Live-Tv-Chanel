# 🚀 Deployment Guide - Live TV Channel Player

## 🔴 Common Issue: Channels Not Playing After Deployment

### **Problem:**
Your channels work locally but fail to play after deploying to GitHub Pages, Netlify, Vercel, or similar platforms.

### **Root Cause:**
1. **Mixed Content Policy**: Your site is served over HTTPS, but your stream URLs use HTTP
2. **CORS (Cross-Origin Resource Sharing)**: Streaming servers may block requests from your domain
3. **Local IP Addresses**: URLs like `http://10.10.10.2/...` only work on your local network

---

## ✅ Solutions Implemented

### 1. **Proxy Configuration (Already Added)**
The code now includes a proxy system that wraps HTTP URLs to work with HTTPS:

```javascript
// In index.html
const USE_PROXY = true; // Set to true for HTTPS deployment
const PROXY_URL = "https://corsproxy.io/?";
```

**How to use:**
- For **local testing**: Set `USE_PROXY = false`
- For **deployment**: Set `USE_PROXY = true`

### 2. **Alternative Proxy Services**
If `corsproxy.io` doesn't work, try these alternatives:

```javascript
// Option 1: AllOrigins
const PROXY_URL = "https://api.allorigins.win/raw?url=";

// Option 2: CORS Anywhere (requires setup)
const PROXY_URL = "https://cors-anywhere.herokuapp.com/";

// Option 3: ThingProxy
const PROXY_URL = "https://thingproxy.freeboard.io/fetch/";
```

### 3. **Local IP Warning**
Channels using local IPs (like `http://10.10.10.2/...`) will show a warning and won't work online.

---

## 🛠️ Recommended Solutions

### **Option A: Use HTTPS Stream URLs**
Best practice - Contact your stream provider and request HTTPS URLs:
```javascript
// ❌ HTTP (blocked on HTTPS sites)
"url": "http://tv.dugdugilive.com:8080/stream"

// ✅ HTTPS (works everywhere)
"url": "https://tv.dugdugilive.com:8080/stream"
```

### **Option B: Self-Hosted Proxy Server**
Create your own proxy server for better reliability:

1. Create a simple Node.js proxy:
```javascript
// server.js
const express = require('express');
const cors = require('cors');
const request = require('request');

const app = express();
app.use(cors());

app.get('/proxy', (req, res) => {
  const url = req.query.url;
  request(url).pipe(res);
});

app.listen(3000);
```

2. Deploy to Heroku/Vercel/Railway
3. Update your proxy URL:
```javascript
const PROXY_URL = "https://your-proxy-server.herokuapp.com/proxy?url=";
```

### **Option C: Deploy with Proper Headers**
Add these headers to your deployment:

**For Netlify** (`netlify.toml`):
```toml
[[headers]]
  for = "/*"
  [headers.values]
    Access-Control-Allow-Origin = "*"
    Content-Security-Policy = "upgrade-insecure-requests"
```

**For Vercel** (`vercel.json`):
```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "Access-Control-Allow-Origin", "value": "*" },
        { "key": "Content-Security-Policy", "value": "upgrade-insecure-requests" }
      ]
    }
  ]
}
```

---

## 🧪 Testing Your Deployment

### 1. **Check Console for Errors**
Open browser DevTools (F12) → Console tab:
- **Mixed Content Error**: Need to enable proxy or use HTTPS URLs
- **CORS Error**: Stream server blocking your domain
- **Network Error**: Stream may be offline or URL incorrect

### 2. **Test Individual Channels**
Try each channel and note which ones work/fail. Some streams may have different CORS policies.

### 3. **Test on Different Browsers**
- Chrome/Edge: Strict mixed content policy
- Firefox: Slightly more lenient
- Safari: Native HLS support, different behavior

---

## 📋 Deployment Checklist

- [ ] Set `USE_PROXY = true` in `index.html`
- [ ] Remove or update local IP addresses (`10.10.10.2`)
- [ ] Test all channels after deployment
- [ ] Check browser console for errors
- [ ] Verify HTTPS is working on your deployed site
- [ ] Test on mobile devices
- [ ] Consider setting up your own proxy server

---

## 🔧 Quick Configuration

### For Local Development:
```javascript
const USE_PROXY = false;
```

### For GitHub Pages/Netlify/Vercel:
```javascript
const USE_PROXY = true;
const PROXY_URL = "https://corsproxy.io/?";
```

### For Custom Domain with SSL:
```javascript
const USE_PROXY = false; // If your streams are already HTTPS
```

---

## 📞 Need Help?

If channels still don't work:
1. Check if stream URLs are still valid (test in VLC Media Player)
2. Try different proxy services
3. Contact stream provider for HTTPS URLs
4. Consider using a CDN service for streams

---

## 🎯 Best Practices

1. **Always use HTTPS stream URLs** when available
2. **Keep proxy as backup** for HTTP-only streams
3. **Monitor stream availability** - some may go offline
4. **Cache proxy responses** to reduce load
5. **Add error recovery** for better user experience

---

**Last Updated**: October 2025
