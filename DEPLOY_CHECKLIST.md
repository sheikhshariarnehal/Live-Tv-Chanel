# 🚀 Quick Deployment Checklist

## Before You Deploy

- [ ] All files are ready in the project folder
- [ ] channels.json is valid (test with validator.html locally)
- [ ] Images are in assets/image/ folder
- [ ] Test locally: `python -m http.server 8000`
- [ ] Channels play on localhost:8000

## File Structure to Upload

```
📁 Root Directory (upload everything inside)
├── 📄 index.html                    ← Main page
├── 📄 channels.json                 ← Channel data (MUST be in root!)
├── 📄 validator.html                ← Testing tool (optional but helpful)
├── 📄 DEPLOYMENT_GUIDE.md          ← Reference guide (optional)
└── 📁 assets/
    ├── 📁 css/
    │   └── 📄 style.css
    ├── 📁 js/
    │   └── 📄 script.js
    └── 📁 image/
        ├── 🖼️ T SPORTS1744972630.png
        ├── 🖼️ ten1.png
        ├── 🖼️ sonysix.png
        ├── 🖼️ dbcnews.png
        ├── 🖼️ gtv.png
        ├── 🖼️ starjalsha.png
        └── 🖼️ colorsbangla.png
```

## After Deployment

### Step 1: Verify File Upload
- [ ] Visit your domain: `https://yourdomain.com`
- [ ] Page loads without errors

### Step 2: Check channels.json
- [ ] Visit: `https://yourdomain.com/channels.json`
- [ ] Should show JSON content (not download or 404)

### Step 3: Run Validator
- [ ] Visit: `https://yourdomain.com/validator.html`
- [ ] Should show ✅ "channels.json is valid and loaded successfully!"
- [ ] Check statistics match your expectations

### Step 4: Browser Console Test
- [ ] Open main page: `https://yourdomain.com`
- [ ] Press F12 (open DevTools)
- [ ] Go to Console tab
- [ ] Look for: `✅ Channels loaded successfully from: channels.json`
- [ ] No red error messages

### Step 5: Test Video Playback
- [ ] Click any channel button
- [ ] Video should start playing
- [ ] Try multiple channels
- [ ] Test on mobile device

## If Something Goes Wrong

### ❌ Page shows "Failed to load channels data"

**Quick Fix:**
1. Press F12 → Console tab
2. Check what the error says
3. Verify channels.json is in root directory
4. Clear browser cache (Ctrl+Shift+Del)
5. Hard refresh (Ctrl+F5)

**Common Causes:**
- channels.json not in root directory
- File name typo (must be exactly `channels.json`)
- Server not serving JSON files
- CORS policy blocking requests

### ❌ validator.html shows error

**Quick Fix:**
1. Re-upload channels.json to root directory
2. Check file permissions (should be readable)
3. Validate JSON at jsonlint.com
4. Ensure no trailing commas in JSON

### ❌ Channels load but videos don't play

**Quick Fix:**
1. Check if stream URLs are working
2. Try different channel
3. Check browser console for HLS errors
4. Verify HLS.js CDN is accessible

### ❌ Works on desktop but not mobile

**Quick Fix:**
1. Test in mobile Chrome/Safari
2. Check for HTTPS (many browsers require it)
3. Verify mobile data/wifi connection
4. Try different stream sources

## Platform-Specific Notes

### GitHub Pages
- URL: `https://username.github.io/repo-name/`
- Takes 1-2 minutes to deploy
- Clear cache after updates

### Netlify
- Drag & drop the entire folder
- Instant deployment
- Auto-HTTPS enabled

### Vercel
- `vercel` command in project folder
- Follow prompts
- Instant deployment

### cPanel / Traditional Hosting
- Upload via File Manager or FTP
- Put files in `public_html` folder
- Maintain folder structure exactly

## Emergency Contacts

**If deployment fails:**
1. Read DEPLOYMENT_GUIDE.md (detailed troubleshooting)
2. Check browser console for specific errors
3. Test with validator.html
4. Verify server configuration

## Success Indicators ✅

You'll know it's working when:
- ✅ Main page loads instantly
- ✅ Channel buttons appear in sidebar
- ✅ Console shows: "✅ Channels loaded successfully"
- ✅ validator.html shows valid configuration
- ✅ Clicking channels plays video
- ✅ No error messages in console
- ✅ Works on both desktop and mobile

## Post-Deployment

- [ ] Bookmark validator.html for future checks
- [ ] Test on different browsers (Chrome, Firefox, Safari)
- [ ] Test on different devices (phone, tablet, desktop)
- [ ] Share URL and get feedback
- [ ] Keep DEPLOYMENT_GUIDE.md for reference

---

**Deployment Date:** _______________
**Platform Used:** _______________
**Live URL:** _______________
**Status:** [ ] Working  [ ] Issues

---

💡 **Pro Tip**: Always keep a local copy of your project and test changes locally before deploying!

🔄 **Need to Update Channels?**
1. Edit channels.json locally
2. Test with validator.html locally
3. Upload new channels.json
4. Clear cache and refresh (Ctrl+F5)
