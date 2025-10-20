# Live TV Deployment Guide

## Issues Fixed ✅

### 1. **channels.json Loading Issues After Deployment**
The application now tries multiple paths to load `channels.json`:
- `channels.json` (recommended for most servers)
- `./channels.json` (relative path)
- `../channels.json` (parent directory)
- `/channels.json` (absolute from domain root)

### 2. **Cache-Busting**
Added timestamp parameter to ensure fresh data loads after deployment and updates.

### 3. **Better Error Handling**
- Console logs show which path successfully loaded the data
- User-friendly error messages if loading fails
- Visual loading indicators

---

## Deployment Checklist

### 1. **File Structure** (Must be maintained)
```
your-domain/
├── index.html
├── channels.json
└── assets/
    ├── css/
    │   └── style.css
    ├── js/
    │   └── script.js
    └── image/
        └── (your channel logos)
```

### 2. **Server Configuration**

#### For Apache (.htaccess)
```apache
# Enable CORS
<IfModule mod_headers.c>
    Header set Access-Control-Allow-Origin "*"
</IfModule>

# Set correct MIME types
<IfModule mod_mime.c>
    AddType application/json .json
    AddType video/mp2t .ts
    AddType application/x-mpegURL .m3u8
</IfModule>

# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE application/json
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE text/javascript
</IfModule>
```

#### For Nginx (nginx.conf)
```nginx
location / {
    add_header Access-Control-Allow-Origin *;
    
    # MIME types
    types {
        application/json json;
        video/mp2t ts;
        application/x-mpegURL m3u8;
    }
}
```

### 3. **Before Deployment**
- ✅ Verify `channels.json` is valid JSON (no trailing commas)
- ✅ Ensure all image paths in `channels.json` are correct
- ✅ Test locally first with `python -m http.server 8000`
- ✅ Check browser console for errors

### 4. **After Deployment**
- ✅ Open browser DevTools (F12) and check Console tab
- ✅ Look for "✅ Channels loaded successfully from:" message
- ✅ Verify no CORS errors
- ✅ Test on multiple browsers (Chrome, Firefox, Safari)

---

## Troubleshooting

### Issue: "Failed to load channels data"

**Solutions:**
1. Check browser console for specific error
2. Verify `channels.json` is accessible: `https://yourdomain.com/channels.json`
3. Check server MIME type for `.json` files
4. Clear browser cache (Ctrl+Shift+Delete)
5. Verify file permissions on server (should be readable)

### Issue: Channels load but videos don't play

**Solutions:**
1. Check if stream URLs are accessible
2. Verify CORS headers on streaming server
3. Check if HLS.js is loading: `https://cdn.jsdelivr.net/npm/hls.js@latest`
4. Try a different channel to isolate the issue
5. Check browser console for HLS errors

### Issue: Works locally but not after deployment

**Solutions:**
1. Use relative paths without leading `./` in `channels.json`
2. Ensure file names match exactly (case-sensitive on Linux servers)
3. Check if `channels.json` has proper MIME type
4. Verify CDN links are accessible (HLS.js, fonts)
5. Check server's Content Security Policy (CSP)

### Issue: Images not loading

**Solutions:**
1. Use relative paths: `assets/image/logo.png` (not `./assets/image/logo.png`)
2. Ensure image files are uploaded to server
3. Check file name case sensitivity
4. Verify image paths in `channels.json`

---

## Testing Your Deployment

### 1. **Browser Console Test**
Open DevTools (F12) → Console tab and check for:
```
✅ Channels loaded successfully from: channels.json
```

### 2. **Network Test**
DevTools → Network tab:
- `channels.json` should return Status: 200
- Content-Type should be `application/json`

### 3. **Manual JSON Test**
Visit: `https://yourdomain.com/channels.json`
- Should display JSON content
- Should NOT download or show 404

---

## Common Deployment Platforms

### GitHub Pages
1. Push all files to repository
2. Enable GitHub Pages in Settings
3. Ensure `channels.json` is in root
4. URL will be: `https://username.github.io/repo-name/`

### Netlify
1. Drag and drop entire folder
2. Or connect to GitHub repository
3. Auto-deploys on git push

### Vercel
1. Install Vercel CLI: `npm i -g vercel`
2. Run `vercel` in project directory
3. Follow prompts

### Traditional Hosting (cPanel, etc.)
1. Upload all files via FTP/SFTP
2. Maintain folder structure
3. Set file permissions (644 for files, 755 for folders)
4. Add `.htaccess` if using Apache

---

## Performance Tips

1. **Optimize Images**: Compress channel logos (use WebP format)
2. **Enable Gzip**: Compress text files on server
3. **Use CDN**: For static assets if possible
4. **Minify CSS/JS**: For production (optional)
5. **Enable Caching**: Set cache headers for static assets

---

## Security Recommendations

1. **HTTPS**: Always use HTTPS in production
2. **Validate URLs**: Ensure stream URLs are from trusted sources
3. **Rate Limiting**: Implement if possible to prevent abuse
4. **Regular Updates**: Keep dependencies updated

---

## Support

If you still face issues after following this guide:
1. Check browser console for specific errors
2. Test in incognito/private mode
3. Try different browsers
4. Verify server logs

---

Last Updated: October 20, 2025
