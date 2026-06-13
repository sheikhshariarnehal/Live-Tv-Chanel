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
const btnSwitchPublic = document.getElementById('btnSwitchPublic');
const btnReloadStream = document.getElementById('btnReloadStream');
const btnLocalSource = document.getElementById('btnLocalSource');
const btnPublicSource = document.getElementById('btnPublicSource');

let hls;
let mpegtsPlayer;
let channelsData = null;
let currentCategory = '';
let currentSource = (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') ? 'local' : 'public';

let lastSelectedChannelBtn = null;
let lastSelectedChannelUrl = null;
let lastSelectedChannelName = null;

// ===== Load channels data from selected source =====
async function loadChannelsData() {
  // Update source button active states
  if (currentSource === 'local') {
    btnLocalSource.classList.add('active');
    btnPublicSource.classList.remove('active');
  } else {
    btnLocalSource.classList.remove('active');
    btnPublicSource.classList.add('active');
  }

  try {
    if (currentSource === 'local') {
      const response = await fetch('./assets/data/channels.json');
      channelsData = await response.json();
    } else {
      const response = await fetch('https://iptv-org.github.io/iptv/countries/bd.m3u');
      if (!response.ok) throw new Error('Failed to fetch public M3U list');
      const text = await response.text();
      channelsData = parseM3U(text);
    }
    initializeUI();
  } catch (error) {
    console.error('Error loading channels data:', error);
    showError(`Failed to load ${currentSource === 'local' ? 'BDIX' : 'Public'} channels`);
  }
}

// ===== Switch Stream Source =====
async function switchSource(source) {
  if (currentSource === source && channelsData) return;
  
  currentSource = source;
  
  // Update UI active buttons
  if (source === 'local') {
    btnLocalSource.classList.add('active');
    btnPublicSource.classList.remove('active');
  } else {
    btnLocalSource.classList.remove('active');
    btnPublicSource.classList.add('active');
  }
  
  // Show loading in video player or category tabs
  categoryTabsContainer.innerHTML = '<p class="loading-text" style="padding: 1rem;">Loading source...</p>';
  channelGridContainer.innerHTML = '';
  errorOverlay.classList.remove('active');
  
  // Destroy existing player instances
  if (hls) {
    hls.destroy();
    hls = null;
  }
  if (mpegtsPlayer) {
    mpegtsPlayer.destroy();
    mpegtsPlayer = null;
  }
  
  try {
    if (source === 'local') {
      const response = await fetch('./assets/data/channels.json');
      channelsData = await response.json();
    } else {
      const response = await fetch('https://iptv-org.github.io/iptv/countries/bd.m3u');
      if (!response.ok) throw new Error('Failed to fetch public M3U list');
      const text = await response.text();
      channelsData = parseM3U(text);
    }
    initializeUI();
  } catch (error) {
    console.error('Error switching source:', error);
    categoryTabsContainer.innerHTML = '';
    showError(`Failed to load ${source === 'local' ? 'BDIX' : 'Public'} channels`);
  }
}

// ===== M3U Playlist Parser =====
function parseM3U(text) {
  const lines = text.split('\n');
  const categories = {};
  let currentChannel = null;
  
  for (let line of lines) {
    line = line.trim();
    if (line.startsWith('#EXTINF:')) {
      const nameMatch = line.match(/,(.+)$/);
      const logoMatch = line.match(/tvg-logo="([^"]+)"/);
      const idMatch = line.match(/tvg-id="([^"]+)"/);
      const groupMatch = line.match(/group-title="([^"]+)"/);
      
      const channelName = nameMatch ? nameMatch[1].trim() : 'Unknown';
      const logo = logoMatch ? logoMatch[1] : '';
      const id = idMatch ? idMatch[1].replace(/\s+/g, '-').toLowerCase() : 'pub-' + Math.random().toString(36).substr(2, 9);
      const group = groupMatch ? groupMatch[1].trim() : 'General';
      
      currentChannel = {
        id: id,
        name: channelName,
        logo: logo,
        group: group
      };
    } else if (line && !line.startsWith('#')) {
      if (currentChannel) {
        let url = line;
        // Proxy HTTP streams through HTTPS on Vercel to avoid mixed content
        if (window.location.protocol === 'https:' && url.startsWith('http://')) {
          url = '/proxy?url=' + encodeURIComponent(url);
        }
        
        currentChannel.url = url;
        
        // Categorize
        let groupKey = currentChannel.group.toLowerCase().replace(/\s+/g, '_');
        if (!groupKey) groupKey = 'general';
        
        // Merge similar categories
        if (groupKey.includes('news')) groupKey = 'news';
        else if (groupKey.includes('sport')) groupKey = 'sports';
        else if (groupKey.includes('religion') || groupKey.includes('islam') || groupKey.includes('peace')) groupKey = 'religion';
        else if (groupKey.includes('movie') || groupKey.includes('cinema')) groupKey = 'movies';
        else if (groupKey.includes('kid') || groupKey.includes('cartoon')) groupKey = 'kids';
        else if (groupKey.includes('entertainment') || groupKey.includes('general')) groupKey = 'entertainment';
        else groupKey = 'other';
        
        const groupNames = {
          news: 'News',
          sports: 'Sports',
          religion: 'Religion',
          movies: 'Movies',
          kids: 'Kids',
          entertainment: 'Entertainment',
          other: 'Other'
        };
        
        const categoryName = groupNames[groupKey] || currentChannel.group;
        
        if (!categories[groupKey]) {
          categories[groupKey] = {
            name: categoryName,
            channels: []
          };
        }
        
        categories[groupKey].channels.push({
          id: currentChannel.id,
          name: currentChannel.name,
          url: currentChannel.url,
          logo: currentChannel.logo
        });
        
        currentChannel = null;
      }
    }
  }
  
  // Clean empty categories and return
  const cleanCategories = {};
  Object.keys(categories).forEach(key => {
    if (categories[key].channels.length > 0) {
      cleanCategories[key] = categories[key];
    }
  });
  
  return { categories: cleanCategories };
}

// ===== Initialize UI with tabs and channels =====
function initializeUI() {
  if (!channelsData || !channelsData.categories) return;
  
  // Reset category tabs & channels
  createCategoryTabs();
  createChannelCategories();
  setupEventListeners();
  autoPlayFirstChannel();
}

// ===== Create category tabs dynamically =====
function createCategoryTabs() {
  categoryTabsContainer.innerHTML = '';
  
  const categoryKeys = Object.keys(channelsData.categories);
  if (categoryKeys.length === 0) return;
  
  // Set current category to the first one available
  currentCategory = categoryKeys[0];
  
  categoryKeys.forEach((categoryKey, index) => {
    const category = channelsData.categories[categoryKey];
    const tabBtn = document.createElement('button');
    tabBtn.className = `tab-btn ${index === 0 ? 'active' : ''}`;
    tabBtn.dataset.category = categoryKey;
    tabBtn.textContent = category.name;
    categoryTabsContainer.appendChild(tabBtn);
  });
}

// ===== Create channel categories and buttons dynamically =====
function createChannelCategories() {
  channelGridContainer.innerHTML = '';
  
  Object.keys(channelsData.categories).forEach((categoryKey, index) => {
    const category = channelsData.categories[categoryKey];
    const categoryDiv = document.createElement('div');
    categoryDiv.className = `channel-category ${index !== 0 ? 'hidden' : ''}`;
    categoryDiv.dataset.category = categoryKey;
    
    category.channels.forEach(channel => {
      const channelBtn = createChannelButton(channel);
      categoryDiv.appendChild(channelBtn);
    });
    
    channelGridContainer.appendChild(categoryDiv);
  });
}

// ===== Create individual channel button =====
function createChannelButton(channel) {
  const button = document.createElement('button');
  button.className = 'channel-btn';
  button.dataset.url = channel.url;
  button.dataset.channelId = channel.id;
  button.dataset.channelName = channel.name;
  button.title = channel.name;
  
  if (channel.logo) {
    const img = document.createElement('img');
    img.src = channel.logo;
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
  
  const isPrivateIp = url.includes('10.254.252.70') || url.includes('/proxy?url=http%3A%2F%2F10.');
  
  if (isPrivateIp) {
    errorDesc.innerHTML = `
      Failed to load <strong>${channelName}</strong>.<br><br>
      This stream points to a private ISP local network (BDIX) which cannot be reached from Vercel's public cloud servers.<br><br>
      <strong>Solutions:</strong><br>
      1. Switch to <strong>Public (Global)</strong> streams using the sidebar.<br>
      2. Or clone this repository and run the app locally on your computer.
    `;
    btnSwitchPublic.style.display = 'block';
  } else {
    errorDesc.innerHTML = `
      Failed to load <strong>${channelName}</strong>.<br><br>
      The stream might be temporarily offline or blocked by your browser's CORS/Mixed Content settings.
    `;
    btnSwitchPublic.style.display = 'none';
  }
}

// ===== Setup event listeners =====
function setupEventListeners() {
  // Category tab switching
  const tabButtons = document.querySelectorAll('.tab-btn');
  tabButtons.forEach(tab => {
    tab.addEventListener('click', () => {
      const category = tab.dataset.category;
      currentCategory = category;
      
      tabButtons.forEach(btn => btn.classList.remove('active'));
      tab.classList.add('active');
      
      const channelCategories = document.querySelectorAll('.channel-category');
      channelCategories.forEach(cat => {
        if (cat.dataset.category === category) {
          cat.classList.remove('hidden');
        } else {
          cat.classList.add('hidden');
        }
      });
    });
  });
  
  // Channel button clicks
  const channelButtons = document.querySelectorAll('.channel-btn');
  channelButtons.forEach(button => {
    button.addEventListener('click', function() {
      const url = this.dataset.url;
      const channelName = this.dataset.channelName;
      
      if (url && url !== '') {
        playChannel(this, url, channelName);
        // Close sidebar on mobile landscape after selecting channel (641px - 768px)
        if (window.innerWidth > 640 && window.innerWidth <= 768) {
          sidebar.classList.remove('active');
        }
      } else {
        showError(`${channelName} is coming soon!`);
      }
    });
  });
}

// ===== Play channel =====
function playChannel(button, url, channelName) {
  // Hide error screen & show loading overlay
  errorOverlay.classList.remove('active');
  videoOverlay.classList.add('active');
  
  // Save last selected context for reloads
  lastSelectedChannelBtn = button;
  lastSelectedChannelUrl = url;
  lastSelectedChannelName = channelName;
  
  // Remove active state from all channel buttons
  document.querySelectorAll('.channel-btn').forEach(btn => btn.classList.remove('active'));
  if (button) button.classList.add('active');
  
  // Destroy existing HLS instance
  if (hls) {
    hls.destroy();
    hls = null;
  }
  
  // Destroy existing mpegts instance
  if (mpegtsPlayer) {
    mpegtsPlayer.destroy();
    mpegtsPlayer = null;
  }

  const isTs = url.includes('.ts');

  if (isTs && typeof mpegts !== 'undefined' && mpegts.getFeatureList().mseLivePlayback) {
    mpegtsPlayer = mpegts.createPlayer({
      type: 'mse',
      isLive: true,
      url: url
    });
    
    mpegtsPlayer.attachMediaElement(video);
    mpegtsPlayer.load();
    mpegtsPlayer.play()
      .then(() => {
        videoOverlay.classList.remove('active');
      })
      .catch(err => {
        console.log('Autoplay prevented or error:', err);
        showPlayerError(channelName, url);
      });
      
    mpegtsPlayer.on(mpegts.Events.ERROR, (errorType, errorDetail, errorInfo) => {
      console.error('MPEGTS error:', errorType, errorDetail, errorInfo);
      showPlayerError(channelName, url);
    });

  } else if (Hls.isSupported() && !isTs) {
    hls = new Hls({
      enableWorker: true,
      lowLatencyMode: true,
      backBufferLength: 90,
      maxBufferLength: 30,
      maxMaxBufferLength: 600,
      maxBufferSize: 60 * 1000 * 1000,
      maxBufferHole: 0.5
    });
    
    hls.loadSource(url);
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
              showPlayerError(channelName, url);
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
            showPlayerError(channelName, url);
            hls.destroy();
            break;
        }
      }
    });
  } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
    // Native HLS support (Safari)
    video.src = url;
    video.play().then(() => {
      videoOverlay.classList.remove('active');
    }).catch(err => {
      console.log('Autoplay prevented:', err);
      showPlayerError(channelName, url);
    });
  } else {
    videoOverlay.classList.remove('active');
    showError('Your browser does not support HLS streaming.');
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
  // Space - Play/Pause
  if (e.code === 'Space' && e.target === document.body) {
    e.preventDefault();
    if (video.paused) {
      video.play();
    } else {
      video.pause();
    }
  }
  
  // Escape - Close sidebar on mobile
  if (e.code === 'Escape' && window.innerWidth > 640 && window.innerWidth <= 768) {
    sidebar.classList.remove('active');
  }
  
  // M - Toggle sidebar on mobile
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

// Add animation styles dynamically
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

// ===== Source Selection & Initial setup =====
function setupSourceSelector() {
  btnLocalSource.addEventListener('click', () => {
    switchSource('local');
  });
  
  btnPublicSource.addEventListener('click', () => {
    switchSource('public');
  });
  
  btnReloadStream.addEventListener('click', () => {
    if (lastSelectedChannelUrl) {
      playChannel(lastSelectedChannelBtn, lastSelectedChannelUrl, lastSelectedChannelName);
    }
  });
  
  btnSwitchPublic.addEventListener('click', () => {
    switchSource('public');
  });
}

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

// ===== Initialize the app =====
setupSourceSelector();
loadChannelsData();
