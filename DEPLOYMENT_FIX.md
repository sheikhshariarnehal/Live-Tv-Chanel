# Live TV - cPanel Deployment Fix

## Problem
After deploying to cPanel with HTTPS, channels won't play due to **Mixed Content** errors. Browsers block HTTP content (your stream URLs) when the page is loaded over HTTPS.

## Solutions Applied

### 1. **Automatic HTTPS Upgrade** (Already Applied)
The JavaScript now automatically converts HTTP URLs to HTTPS when the site is loaded over HTTPS.

**Location:** `assets/js/script.js`
- Added `getProxiedUrl()` function that converts http:// to https://
- This works if your streaming servers support HTTPS

### 2. **Content Security Policy Meta Tag** (Already Applied)
Added a meta tag to upgrade insecure requests automatically.

**Location:** `index.html`
```html
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
```

### 3. **PHP Proxy** (Optional - Upload if needed)
If the streaming servers don't support HTTPS, use the PHP proxy.

**File:** `proxy.php`

**How to use:**
1. Upload `proxy.php` to your cPanel public_html directory
2. Update `script.js` to use the proxy:

```javascript
function getProxiedUrl(url) {
  if (window.location.protocol === 'https:' && url.startsWith('http://')) {
    // Use your own domain proxy
    return `/proxy.php?url=${encodeURIComponent(url)}`;
  }
  return url;
}
```

## Deployment Steps

### Step 1: Upload Files to cPanel
1. Login to your cPanel
2. Open **File Manager**
3. Navigate to `public_html` (or your domain's root folder)
4. Upload all files:
   - `index.html`
   - `assets/` folder (with all subfolders)
   - `proxy.php` (optional, but recommended)

### Step 2: Test Your Site
1. Visit your website using HTTPS: `https://yourdomain.com`
2. Open browser Developer Tools (F12)
3. Go to the Console tab
4. Click on a channel and watch for errors

### Step 3: Troubleshooting

#### If channels still don't play:

**Option A: Update Stream URLs to HTTPS**
If the streaming servers support HTTPS, update `assets/data/channels.json`:

```json
{
  "url": "https://tv.dugdugilive.com:8080/0ne$ky23/sonyten1/tracks-v1a1/mono.m3u8"
}
```

**Option B: Use the PHP Proxy**
1. Ensure `proxy.php` is uploaded
2. Update the `getProxiedUrl()` function in `script.js` as shown above

**Option C: Check Server Configuration**
Some streaming servers may block requests. Contact your stream provider.

## Common Issues & Fixes

### Issue 1: "Mixed Content" errors in console
**Fix:** Already applied. The meta tag and JavaScript should handle this.

### Issue 2: CORS errors
**Fix:** Use the PHP proxy (`proxy.php`)

### Issue 3: "Network error, trying to recover..."
**Fix:** The streaming URL may be incorrect or the server is down. Check `channels.json`

### Issue 4: Nothing plays at all
**Fix:** 
1. Check if HLS.js is loading: Open console and type `Hls`
2. Verify your stream URLs are working by testing them in VLC Media Player
3. Make sure your hosting supports PHP (for proxy)

## Testing Stream URLs

To test if a stream URL works:
1. Open VLC Media Player
2. Go to Media > Open Network Stream
3. Paste the stream URL
4. Click Play

If it doesn't work in VLC, the URL is invalid or the server is down.

## File Structure
```
/
├── index.html
├── proxy.php (optional)
└── assets/
    ├── css/
    │   └── style.css
    ├── data/
    │   └── channels.json
    ├── image/
    │   └── [channel logos]
    └── js/
        └── script.js
```

## Additional Notes

- The current stream URLs use:
  - `http://10.10.10.2/live/...` (local IP - won't work online)
  - `http://tv.dugdugilive.com:8080/...` (HTTP URLs that need conversion)

- **Important:** The local IP address `10.10.10.2` will NOT work on a public server. You need to replace these with public URLs.

## Need More Help?

Check the browser console (F12 > Console) for specific error messages and update accordingly.
