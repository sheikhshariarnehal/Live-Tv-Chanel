// ===== DOM Elements =====
const video = document.getElementById('player');
const categoryTabsContainer = document.getElementById('categoryTabs');
const channelGridContainer = document.getElementById('channelGrid');
const sidebar = document.getElementById('sidebar');
const mobileMenuBtn = document.getElementById('mobileMenuBtn');
const closeSidebarBtn = document.getElementById('closeSidebarBtn');
const videoOverlay = document.getElementById('videoOverlay');

// New DOM Elements
const errorOverlay = document.getElementById('errorOverlay');
const errorDesc = document.getElementById('errorDesc');
const btnReloadStream = document.getElementById('btnReloadStream');

let hls;
let mpegtsPlayer;
let channelsData = null;
let currentCategory = '';

let lastSelectedChannelBtn = null;
let lastSelectedChannelUrl = null;
let lastSelectedChannelName = null;

// ===== URL Helper Functions for CORS & Mixed Content/BDIX Routing =====
function getRawUrl(url) {
  if (url && typeof url === 'string' && url.startsWith('/proxy?url=')) {
    return decodeURIComponent(url.substring(11));
  }
  return url;
}

function isPrivateIP(url) {
  try {
    const hostname = new URL(url).hostname;
    // Check if hostname is private IP
    if (/^(10|127)\./.test(hostname)) return true;
    if (/^192\.168\./.test(hostname)) return true;
    if (/^172\.(1[6-9]|2[0-9]|3[0-1])\./.test(hostname)) return true;
    if (hostname === 'localhost' || hostname === '127.0.0.1') return true;
    return false;
  } catch (e) {
    return false;
  }
}

// ===== Helper to dynamically load external scripts =====
const loadedScripts = new Set();
function loadScript(url) {
  if (loadedScripts.has(url)) return Promise.resolve();
  return new Promise((resolve, reject) => {
    const existing = document.querySelector(`script[src="${url}"]`);
    if (existing) {
      loadedScripts.add(url);
      resolve();
      return;
    }
    const script = document.createElement('script');
    script.src = url;
    script.async = true;
    script.onload = () => {
      loadedScripts.add(url);
      resolve();
    };
    script.onerror = reject;
    document.head.appendChild(script);
  });
}

function getPlaybackUrl(url) {
  if (!url) return '';
  const rawUrl = getRawUrl(url);
  
  if (window.location.protocol === 'https:') {
    // On HTTPS (Vercel): private/BDIX IPs cannot be proxied by Vercel serverless function.
    // They must be fetched directly.
    if (isPrivateIP(rawUrl)) {
      return rawUrl;
    }
    // Public HTTP urls must be proxied to prevent mixed content blocking
    if (rawUrl.startsWith('http://')) {
      return '/proxy?url=' + encodeURIComponent(rawUrl);
    }
  } else {
    // On HTTP (local): proxy everything using the local proxy to bypass CORS
    // since the local server has network connectivity.
    if (url.startsWith('/proxy?url=')) {
      return url;
    }
    if (rawUrl.startsWith('http://')) {
      return '/proxy?url=' + encodeURIComponent(rawUrl);
    }
  }
  return rawUrl;
}

// ===== Load channels data from cached server endpoint =====
async function loadChannelsData() {
  categoryTabsContainer.innerHTML = '<p class="loading-text" style="padding: 1rem;">Loading channels...</p>';
  channelGridContainer.innerHTML = '';
  errorOverlay.classList.remove('active');

  try {
    const response = await fetch('/api/channels');
    if (response.ok) {
      channelsData = await response.json();
      initializeUI();
      return;
    }
  } catch (error) {
    console.error('Error loading channels from API:', error);
  }

  categoryTabsContainer.innerHTML = '<p class="loading-text" style="padding: 1rem; color: #ef4444;">Failed to load channels.</p>';
}

// ===== Initialize UI with tabs and channels =====
function initializeUI() {
  if (!channelsData || !channelsData.categories) return;
  
  createCategoryTabs();
  
  // Set current category & render initial channels
  const categoryKeys = Object.keys(channelsData.categories);
  if (categoryKeys.length > 0) {
    currentCategory = categoryKeys[0];
    renderChannelsForCategory(currentCategory);
  }
  
  setupEventListeners();
  autoPlayFirstChannel();
}

// ===== Create category tabs dynamically =====
function createCategoryTabs() {
  categoryTabsContainer.innerHTML = '';
  
  const categoryKeys = Object.keys(channelsData.categories);
  if (categoryKeys.length === 0) return;
  
  categoryKeys.forEach((categoryKey, index) => {
    const category = channelsData.categories[categoryKey];
    const tabBtn = document.createElement('button');
    tabBtn.className = `tab-btn ${index === 0 ? 'active' : ''}`;
    tabBtn.dataset.category = categoryKey;
    tabBtn.textContent = category.name;
    categoryTabsContainer.appendChild(tabBtn);
  });
}

// ===== Render channels only for the active category =====
function renderChannelsForCategory(categoryKey) {
  channelGridContainer.innerHTML = '';
  
  const category = channelsData.categories[categoryKey];
  if (!category || !category.channels) return;
  
  const fragment = document.createDocumentFragment();
  
  const categoryDiv = document.createElement('div');
  categoryDiv.className = 'channel-category';
  categoryDiv.dataset.category = categoryKey;
  
  category.channels.forEach(channel => {
    const channelBtn = createChannelButton(channel);
    // Restore active playing state visually
    if (channel.url === lastSelectedChannelUrl || (channel.fallbackUrl && channel.fallbackUrl === lastSelectedChannelUrl)) {
      channelBtn.classList.add('active');
      lastSelectedChannelBtn = channelBtn;
    }
    categoryDiv.appendChild(channelBtn);
  });
  
  fragment.appendChild(categoryDiv);
  channelGridContainer.appendChild(fragment);
}

// ===== Create individual channel button =====
function createChannelButton(channel) {
  const button = document.createElement('button');
  button.className = 'channel-btn';
  button.dataset.url = channel.url;
  button.dataset.fallbackUrl = channel.fallbackUrl || '';
  button.dataset.channelId = channel.id;
  button.dataset.channelName = channel.name;
  button.title = channel.name;
  
  if (channel.logo) {
    const img = document.createElement('img');
    img.src = getPlaybackUrl(channel.logo);
    img.alt = channel.name;
    img.className = 'channel-logo';
    img.loading = 'lazy';
    img.onerror = function() {
      this.remove();
      const span = document.createElement('span');
      span.className = 'channel-name';
      span.textContent = channel.name;
      button.appendChild(span);
    };
    button.appendChild(img);
  } else {
    const span = document.createElement('span');
    span.className = 'channel-name';
    span.textContent = channel.name;
    button.appendChild(span);
  }
  
  return button;
}

// ===== Display Custom Error Screen =====
function showPlayerError(channelName, url) {
  videoOverlay.classList.remove('active');
  errorOverlay.classList.add('active');
  
  const rawUrl = getRawUrl(url);
  const isPrivate = isPrivateIP(rawUrl);
  
  if (isPrivate) {
    if (window.location.protocol === 'https:') {
      errorDesc.innerHTML = `
        Failed to load <strong>${channelName}</strong>.<br><br>
        This stream points to a private ISP local network (BDIX) and cannot be proxied through secure Vercel servers.<br><br>
        <strong>How to fix:</strong><br>
        1. Ensure you are connected to a BDIX-compatible ISP.<br>
        2. You must <strong>allow insecure content</strong> in your browser settings:<br>
           &bull; Click the settings/padlock icon next to the URL in your address bar.<br>
           &bull; Open <strong>Site settings</strong>.<br>
           &bull; Find <strong>Insecure content</strong> and set it to <strong>Allow</strong>.<br>
           &bull; Reload this page.
      `;
    } else {
      errorDesc.innerHTML = `
        Failed to load <strong>${channelName}</strong>.<br><br>
        This stream points to a private ISP local network (BDIX) which cannot be reached from your connection.<br><br>
        <strong>Solution:</strong> Ensure you are connected to a BDIX compatible ISP, or try playing a different channel.
      `;
    }
  } else {
    errorDesc.innerHTML = `
      Failed to load <strong>${channelName}</strong>.<br><br>
      The stream might be temporarily offline or blocked by your browser's CORS/Mixed Content settings.
    `;
  }
}

// ===== Handle Playback Errors & Fallback =====
function handlePlaybackError(button, url, channelName, fallbackUrl) {
  video.onerror = null;

  if (fallbackUrl && fallbackUrl !== '' && fallbackUrl !== 'null' && fallbackUrl !== 'undefined') {
    console.log(`Primary stream failed for ${channelName}. Trying fallback URL: ${fallbackUrl}`);
    showError(`Switching to fallback stream for ${channelName}...`);
    playChannel(button, fallbackUrl, channelName, null);
  } else {
    showPlayerError(channelName, url);
  }
}

// ===== Setup event listeners =====
function setupEventListeners() {
  const tabButtons = document.querySelectorAll('.tab-btn');
  tabButtons.forEach(tab => {
    tab.addEventListener('click', () => {
      const category = tab.dataset.category;
      currentCategory = category;
      
      tabButtons.forEach(btn => btn.classList.remove('active'));
      tab.classList.add('active');
      
      renderChannelsForCategory(category);
    });
  });
  
  // Use event delegation for dynamic channel grid buttons
  channelGridContainer.addEventListener('click', (e) => {
    const button = e.target.closest('.channel-btn');
    if (!button) return;
    
    const url = button.dataset.url;
    const fallbackUrl = button.dataset.fallbackUrl;
    const channelName = button.dataset.channelName;
    
    if (url && url !== '') {
      playChannel(button, url, channelName, fallbackUrl);
      if (window.innerWidth > 640 && window.innerWidth <= 768) {
        sidebar.classList.remove('active');
      }
    } else {
      showError(`${channelName} is coming soon!`);
    }
  });

  // Horizontal scroll for category tabs via mouse wheel
  categoryTabsContainer.addEventListener('wheel', (e) => {
    if (e.deltaY !== 0 && e.deltaX === 0) {
      e.preventDefault();
      categoryTabsContainer.scrollLeft += e.deltaY;
    }
  });
}

// ===== Play channel =====
async function playChannel(button, url, channelName, fallbackUrl = null) {
  errorOverlay.classList.remove('active');
  videoOverlay.classList.add('active');
  
  lastSelectedChannelBtn = button;
  lastSelectedChannelUrl = url;
  lastSelectedChannelName = channelName;
  
  document.querySelectorAll('.channel-btn').forEach(btn => btn.classList.remove('active'));
  if (button) {
    button.classList.add('active');
    if (fallbackUrl) {
      button.dataset.fallbackUrl = fallbackUrl;
    }
  }
  
  if (hls) {
    hls.destroy();
    hls = null;
  }
  
  if (mpegtsPlayer) {
    mpegtsPlayer.destroy();
    mpegtsPlayer = null;
  }

  video.onerror = null;
  video.onerror = () => {
    handlePlaybackError(button, url, channelName, fallbackUrl);
  };

  const playbackUrl = getPlaybackUrl(url);
  const isTs = playbackUrl.includes('.ts');

  try {
    if (isTs) {
      // Dynamic load mpegts.js if not present
      if (typeof mpegts === 'undefined') {
        await loadScript('https://cdn.jsdelivr.net/npm/mpegts.js@1.7.3/dist/mpegts.min.js');
      }
      if (typeof mpegts !== 'undefined' && mpegts.getFeatureList().mseLivePlayback) {
        mpegtsPlayer = mpegts.createPlayer({
          type: 'mse',
          isLive: true,
          url: playbackUrl
        });
        
        mpegtsPlayer.attachMediaElement(video);
        mpegtsPlayer.load();
        mpegtsPlayer.play()
          .then(() => {
            videoOverlay.classList.remove('active');
          })
          .catch(err => {
            console.log('Autoplay prevented or error:', err);
            handlePlaybackError(button, url, channelName, fallbackUrl);
          });
          
        mpegtsPlayer.on(mpegts.Events.ERROR, (errorType, errorDetail, errorInfo) => {
          console.error('MPEGTS error:', errorType, errorDetail, errorInfo);
          handlePlaybackError(button, url, channelName, fallbackUrl);
        });
      } else {
        handlePlaybackError(button, url, channelName, fallbackUrl);
      }
    } else {
      // Dynamic load hls.js if not present
      if (typeof Hls === 'undefined') {
        await loadScript('https://cdn.jsdelivr.net/npm/hls.js@latest');
      }
      if (typeof Hls !== 'undefined' && Hls.isSupported()) {
        hls = new Hls({
          enableWorker: true,
          lowLatencyMode: true,
          backBufferLength: 90,
          maxBufferLength: 30,
          maxMaxBufferLength: 600,
          maxBufferSize: 60 * 1000 * 1000,
          maxBufferHole: 0.5
        });
        
        hls.loadSource(playbackUrl);
        hls.attachMedia(video);
        
        hls.on(Hls.Events.MANIFEST_PARSED, () => {
          video.play().then(() => {
            videoOverlay.classList.remove('active');
          }).catch(err => {
            console.log('Autoplay prevented:', err);
            videoOverlay.classList.remove('active');
          });
        });
        
        let networkRetryCount = 0;
        hls.on(Hls.Events.ERROR, (event, data) => {
          console.error('HLS error:', data);
          if (data.fatal) {
            switch (data.type) {
              case Hls.ErrorTypes.NETWORK_ERROR:
                networkRetryCount++;
                if (networkRetryCount > 2) {
                  handlePlaybackError(button, url, channelName, fallbackUrl);
                  hls.destroy();
                } else {
                  console.log('Network error, trying to recover...');
                  hls.startLoad();
                }
                break;
              case Hls.ErrorTypes.MEDIA_ERROR:
                console.log('Media error, trying to recover...');
                hls.recoverMediaError();
                break;
              default:
                handlePlaybackError(button, url, channelName, fallbackUrl);
                hls.destroy();
                break;
            }
          }
        });
      } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
        video.src = playbackUrl;
        video.play().then(() => {
          videoOverlay.classList.remove('active');
        }).catch(err => {
          console.log('Autoplay prevented:', err);
          handlePlaybackError(button, url, channelName, fallbackUrl);
        });
      } else {
        videoOverlay.classList.remove('active');
        showError('Your browser does not support HLS streaming.');
      }
    }
  } catch (error) {
    console.error('Failed to load player engine script:', error);
    handlePlaybackError(button, url, channelName, fallbackUrl);
  }
}

// ===== Auto play the first available channel on page load =====
function autoPlayFirstChannel() {
  setTimeout(() => {
    const firstChannel = document.querySelector('.channel-btn[data-url]:not([data-url=""])');
    if (firstChannel) {
      firstChannel.click();
    }
  }, 500);
}

// ===== Keyboard shortcuts =====
function handleKeyboard(e) {
  if (e.code === 'Space' && e.target === document.body) {
    e.preventDefault();
    if (video.paused) {
      video.play();
    } else {
      video.pause();
    }
  }
  
  if (e.code === 'Escape' && window.innerWidth > 640 && window.innerWidth <= 768) {
    sidebar.classList.remove('active');
  }
  
  if (e.code === 'KeyM' && window.innerWidth > 640 && window.innerWidth <= 768) {
    e.preventDefault();
    sidebar.classList.toggle('active');
  }
}

// ===== Show toast error message =====
function showError(message) {
  const toast = document.createElement('div');
  toast.style.cssText = `
    position: fixed;
    bottom: 2rem;
    left: 50%;
    transform: translateX(-50%);
    background: rgba(239, 68, 68, 0.95);
    color: white;
    padding: 1rem 1.5rem;
    border-radius: 10px;
    font-size: 0.875rem;
    font-weight: 600;
    z-index: 10000;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
    animation: slideUp 0.3s ease;
  `;
  toast.textContent = message;
  document.body.appendChild(toast);
  
  setTimeout(() => {
    toast.style.animation = 'slideDown 0.3s ease';
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}

const style = document.createElement('style');
style.textContent = `
  @keyframes slideUp {
    from { transform: translateX(-50%) translateY(100px); opacity: 0; }
    to { transform: translateX(-50%) translateY(0); opacity: 1; }
  }
  @keyframes slideDown {
    from { transform: translateX(-50%) translateY(0); opacity: 1; }
    to { transform: translateX(-50%) translateY(100px); opacity: 0; }
  }
`;
document.head.appendChild(style);

// ===== Setup Reload Handler =====
btnReloadStream.addEventListener('click', () => {
  if (lastSelectedChannelUrl) {
    const fallbackUrl = lastSelectedChannelBtn ? lastSelectedChannelBtn.dataset.fallbackUrl : null;
    playChannel(lastSelectedChannelBtn, lastSelectedChannelUrl, lastSelectedChannelName, fallbackUrl);
  }
});

// ===== Mobile layout triggers =====
mobileMenuBtn.addEventListener('click', () => {
  if (window.innerWidth > 640 && window.innerWidth <= 768) {
    sidebar.classList.add('active');
  }
});

closeSidebarBtn.addEventListener('click', () => {
  sidebar.classList.remove('active');
});

document.addEventListener('keydown', handleKeyboard);

document.addEventListener('click', (e) => {
  if (window.innerWidth > 640 && window.innerWidth <= 768 && 
      sidebar.classList.contains('active') &&
      !sidebar.contains(e.target) && 
      !mobileMenuBtn.contains(e.target)) {
    sidebar.classList.remove('active');
  }
});

// ===== News Ticker Controller =====
let newsArticles = [];
const newsTicker = document.getElementById('newsTicker');
const marqueeList1 = document.getElementById('marqueeList1');
const marqueeList2 = document.getElementById('marqueeList2');

async function loadNewsData() {
  if (!newsTicker || !marqueeList1 || !marqueeList2) return;
  
  try {
    const response = await fetch('/api/news');
    if (!response.ok) throw new Error('Failed to fetch news');
    const data = await response.json();
    newsArticles = data.articles || [];
    
    if (newsArticles.length > 0) {
      renderNewsTicker();
      // Only display the ticker container if we have news items to show
      newsTicker.style.display = 'flex';
    } else {
      newsTicker.style.display = 'none';
    }
  } catch (error) {
    console.error('Error fetching sports news client-side:', error);
    newsTicker.style.display = 'none';
  }
}

function renderNewsTicker() {
  marqueeList1.innerHTML = '';
  marqueeList2.innerHTML = '';
  
  const fragment1 = document.createDocumentFragment();
  const fragment2 = document.createDocumentFragment();
  
  newsArticles.forEach((article) => {
    // Create elements for marquee list 1
    const link1 = createNewsItemElement(article);
    fragment1.appendChild(link1);
    
    // Create duplicate elements for marquee list 2 (for seamless infinite loop)
    const link2 = createNewsItemElement(article);
    fragment2.appendChild(link2);
  });
  
  marqueeList1.appendChild(fragment1);
  marqueeList2.appendChild(fragment2);
}

function createNewsItemElement(article) {
  const link = document.createElement('a');
  link.href = article.url;
  link.target = '_blank';
  link.rel = 'noopener noreferrer';
  link.className = 'news-item';
  
  const bullet = document.createElement('span');
  bullet.className = 'red-bullet';
  
  const textSpan = document.createElement('span');
  textSpan.className = 'headline-text';
  textSpan.textContent = article.title;
  
  link.appendChild(bullet);
  link.appendChild(textSpan);
  
  return link;
}

// ===== Collapse Logo Animation =====
function setupLogoCollapse() {
  const headerContent = document.querySelector('.header-content');
  const logoElement = document.querySelector('.logo');
  if (!headerContent || !logoElement) return;

  function showLogo() {
    headerContent.classList.remove('collapsed-logo');
    logoElement.classList.remove('collapsed');
  }

  function hideLogo() {
    headerContent.classList.add('collapsed-logo');
    logoElement.classList.add('collapsed');
  }

  // Initial cycle: stays visible on page load, hides after 5 seconds
  setTimeout(hideLogo, 5000);

  // Recurring cycle: every 1 minute (60 seconds), show the logo for 5 seconds, then hide it again
  setInterval(() => {
    showLogo();
    setTimeout(hideLogo, 5000);
  }, 60000);
}

// ===== Initialize the app =====
loadChannelsData();
loadNewsData();
setupLogoCollapse();
