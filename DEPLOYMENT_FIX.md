# Live TV Player - Deployment Fix

## 🚨 Critical Issue: Mixed Content Error

Your site is hosted on **HTTPS** (`https://live-tv-chanel.vercel.app/`) but your stream URLs use **HTTP**. Modern browsers **block HTTP content on HTTPS sites** for security reasons.

### The Problem:
- ❌ Site: `https://live-tv-chanel.vercel.app/`
- ❌ Stream: `http://10.10.10.2/live/fnf002/index.m3u8`
- ❌ Browser blocks this for security (Mixed Content Policy)

## 🔧 Solutions

### Option 1: Use HTTPS Streams (RECOMMENDED)
Replace all HTTP stream URLs with HTTPS versions in `assets/data/channels.json`

**Example:**
```json
{
  "url": "https://your-stream-provider.com/live/channel.m3u8"
}
```

### Option 2: Deploy on HTTP (Not Recommended)
Deploy your site on a non-HTTPS server (but this is insecure and not recommended)

### Option 3: Use a CORS Proxy (Temporary Solution)
For testing purposes, you can use a proxy service, but this is not reliable for production:

```javascript
// In script.js, modify the URL before playing
const proxyUrl = 'https://cors-anywhere.herokuapp.com/';
const streamUrl = proxyUrl + channel.url;
```

⚠️ **This won't fix the Mixed Content issue** - you still need HTTPS streams!

## 📝 Changes Made

1. **script.js**: 
   - Added fallback path loading for better deployment compatibility
   - Added Mixed Content detection and warning
   - Improved error messages
   - Added timeout handling for streams

2. **index.html**: 
   - Updated asset paths to use absolute paths

3. **channels.json**: 
   - Updated image paths to absolute paths

4. **vercel.json**: 
   - Added proper headers for JSON files
   - Configured rewrite rules

## 🎯 Next Steps

### To Fix Immediately:

1. **Update your stream URLs to HTTPS** in `assets/data/channels.json`:
   - Contact your stream provider for HTTPS URLs
   - Or find alternative HTTPS stream sources

2. **Test locally with HTTP server**:
   ```bash
   # Install http-server globally
   npm install -g http-server
   
   # Run from project directory
   http-server -p 8080
   
   # Open: http://localhost:8080
   ```
   This tests without HTTPS to verify streams work.

3. **Check browser console** after deployment:
   - Press F12
   - Look for specific error messages
   - Share errors if still having issues

## 📋 Testing Checklist

- [ ] JSON file loads successfully
- [ ] Channel buttons appear
- [ ] Logo images load
- [ ] No Mixed Content errors in console
- [ ] Stream URLs are HTTPS (if site is HTTPS)
- [ ] Video player initializes
- [ ] HLS.js loads correctly

## 🌐 Current Stream Issues

Your current streams use HTTP and will **NOT work** on HTTPS deployment:
- `http://10.10.10.2/live/fnf002/index.m3u8` - Local network stream
- `http://tv.dugdugilive.com:8080/...` - HTTP stream

**You need HTTPS versions or deploy on HTTP-only server.**

## 💡 Recommended Stream Providers

Look for IPTV providers that offer:
- ✅ HTTPS streams
- ✅ CORS-enabled headers
- ✅ Reliable uptime
- ✅ Legal content

---

**Need help?** Check browser console (F12) for specific error messages.
