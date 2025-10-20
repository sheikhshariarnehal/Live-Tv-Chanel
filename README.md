# 📺 Live TV - Professional IPTV Player

A modern, responsive IPTV player built with vanilla JavaScript, HTML5, and CSS3. Watch live TV channels in HD quality with an elegant user interface.

## ✨ Features

- 🎬 **HLS Video Streaming** - Support for HTTP Live Streaming protocol
- 📱 **Responsive Design** - Works seamlessly on desktop, tablet, and mobile
- 🎨 **Modern UI** - Clean and professional interface with smooth animations
- 📂 **Category Organization** - Channels organized by categories (Sports, News, Shows, Kids)
- ⚡ **Fast Loading** - Optimized for quick channel switching
- 🎯 **Auto-play** - Automatically plays the first available channel

## 🚀 Deployment on Vercel

### Quick Deploy

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/sheikhshariarnehal/Live-Tv-Chanel)

### Manual Deployment

1. **Install Vercel CLI** (optional)
   ```bash
   npm i -g vercel
   ```

2. **Deploy from GitHub**
   - Go to [vercel.com](https://vercel.com)
   - Click "New Project"
   - Import your GitHub repository
   - Vercel will automatically detect the configuration
   - Click "Deploy"

3. **Deploy from CLI**
   ```bash
   vercel
   ```

### Configuration

The project includes a `vercel.json` file with optimal settings:
- Static file serving
- Proper routing for SPA
- Cache headers for assets
- Security headers

## 🛠️ Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/sheikhshariarnehal/Live-Tv-Chanel.git
   cd Live-Tv-Chanel
   ```

2. **Serve locally**
   ```bash
   npm run dev
   ```
   Or use any static server:
   ```bash
   npx serve .
   # or
   python -m http.server 8000
   ```

3. **Open in browser**
   ```
   http://localhost:3000
   ```

## 📁 Project Structure

```
Live-Tv/
├── index.html              # Main HTML file
├── vercel.json            # Vercel deployment configuration
├── netlify.toml           # Netlify deployment configuration
├── package.json           # Project metadata
├── README.md              # Project documentation
├── .gitignore            # Git ignore rules
└── assets/
    ├── css/
    │   └── style.css     # Main stylesheet
    ├── data/
    │   └── channels.json # Channel configuration
    ├── image/            # Channel logos and images
    └── js/
        └── script.js     # Main JavaScript file
```

## 🎯 Adding New Channels

Edit `assets/data/channels.json` to add or modify channels:

```json
{
  "categories": {
    "sports": {
      "name": "Sports",
      "channels": [
        {
          "id": "channel-id",
          "name": "Channel Name",
          "url": "https://stream-url.m3u8",
          "logo": "assets/image/logo.png"
        }
      ]
    }
  }
}
```

## 🔧 Technologies Used

- **HTML5** - Video element and modern markup
- **CSS3** - Modern styling with CSS Grid and Flexbox
- **Vanilla JavaScript** - No frameworks, pure JS
- **HLS.js** - HTTP Live Streaming support
- **Vercel** - Deployment and hosting

## 📄 License

MIT License - feel free to use this project for personal or commercial purposes.

## 👨‍💻 Author

**Sheikh Shariar Nehal**
- GitHub: [@sheikhshariarnehal](https://github.com/sheikhshariarnehal)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## ⭐ Show your support

Give a ⭐️ if you like this project!

---

**Note:** Make sure you have the rights to stream the channels you add to the configuration. This player is for educational purposes.
