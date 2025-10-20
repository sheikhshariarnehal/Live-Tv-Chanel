# Live TV Streaming Platform

A modern, responsive live TV streaming platform with support for multiple channels organized by categories.

## Features

✨ **Modern UI** - Dark theme with smooth animations and responsive design
📺 **Multiple Categories** - Sports, News, Shows, and Kids channels
🎬 **HLS Streaming** - Support for .m3u8 live streams using HLS.js
📱 **Responsive** - Works on desktop, tablet, and mobile devices
🎨 **Channel Logos** - Display channel logos with fallback placeholders
⚡ **Fast Loading** - Optimized performance with loading indicators

## Technologies Used

- **HTML5** - Structure and video player
- **CSS3** - Modern styling with flexbox and grid
- **JavaScript (ES6+)** - Dynamic functionality
- **HLS.js** - HTTP Live Streaming support for .m3u8 streams

## Project Structure

```
Live Tv/
├── index.html          # Main HTML file
├── styles.css          # Styling
├── app.js              # JavaScript functionality
├── channels.json       # Channel data
├── assets/
│   └── image/          # Channel logo images
└── README.md           # This file
```

## Setup Instructions

1. **Add Channel Logos**: Place your channel logo images in the `assets/image/` folder with the names specified in `channels.json`:
   - T SPORTS1744972630.png
   - ten1.png
   - sonysix.png
   - dbcnews.png
   - gtv.png
   - starjalsha.png
   - colorsbangla.png

2. **Start a Local Server**: The app requires a local server to run due to CORS restrictions with JSON files. You can use:

   **Option A - Python:**
   ```bash
   # Python 3
   python -m http.server 8000
   ```

   **Option B - Node.js (http-server):**
   ```bash
   npx http-server -p 8000
   ```

   **Option C - VS Code Live Server Extension:**
   - Install "Live Server" extension
   - Right-click on `index.html`
   - Select "Open with Live Server"

3. **Open in Browser**: Navigate to `http://localhost:8000` (or the port your server is running on)

## Usage

1. **Select a Category**: Click on Sports, News, Shows, or Kids tabs at the top
2. **Choose a Channel**: Click on any channel card to start streaming
3. **Watch**: The video player will automatically load and play the stream
4. **Switch Channels**: Click on another channel to switch streams

## Adding New Channels

Edit the `channels.json` file to add new channels:

```json
{
  "id": "channel-id",
  "name": "Channel Name",
  "url": "http://stream-url.m3u8",
  "logo": "assets/image/logo.png"
}
```

## Browser Compatibility

- ✅ Chrome/Edge (Recommended)
- ✅ Firefox
- ✅ Safari
- ✅ Opera
- ⚠️ Internet Explorer (Not Supported)

## Notes

- Some streams may require CORS headers to be properly configured on the server
- Make sure stream URLs are valid and accessible
- Channels without URLs will show an error when clicked
- Logo images that fail to load will show placeholder initials

## Troubleshooting

**Stream won't play:**
- Check if the stream URL is valid and accessible
- Verify CORS headers are set on the streaming server
- Try the stream in VLC or another media player to confirm it works

**Logos not showing:**
- Ensure logo files are in the `assets/image/` folder
- Check file names match exactly (case-sensitive)
- Verify image formats are supported (PNG, JPG, SVG)

## License

Free to use for personal and educational purposes.

---

Made with ❤️ for Live TV streaming
