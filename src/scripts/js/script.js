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

// ===== Load channels data from both sources and merge =====
async function loadChannelsData() {
  categoryTabsContainer.innerHTML = '<p class="loading-text" style="padding: 1rem;">Loading channels...</p>';
  channelGridContainer.innerHTML = '';
  errorOverlay.classList.remove('active');

  let localData = null;
  let publicData = null;

  // Fetch local BDIX channels
  try {
    const response = await fetch('./assets/data/channels.json');
    if (response.ok) {
      localData = await response.json();
    }
  } catch (error) {
    console.error('Error loading local channels:', error);
  }

  // Fetch public global channels
  try {
    let response;
    try {
      response = await fetch('https://raw.githubusercontent.com/abusaeeidx/Mrgify-BDIX-IPTV/main/playlist.m3u');
      if (!response.ok) throw new Error();
    } catch (e) {
      response = await fetch('https://iptv-org.github.io/iptv/countries/bd.m3u');
    }
    if (response && response.ok) {
      const text = await response.text();
      publicData = parseM3U(text);
    }
  } catch (error) {
    console.error('Error loading public channels:', error);
  }

  if (!localData && !publicData) {
    console.error('Failed to load any channels.');
    categoryTabsContainer.innerHTML = '<p class="loading-text" style="padding: 1rem; color: #ef4444;">Failed to load channels.</p>';
    return;
  }

  // Merge the sources
  channelsData = mergeSources(localData, publicData);
  initializeUI();
}

// ===== Merge BDIX and Public Channels with Fallbacks =====
function mergeSources(local, publicData) {
  const merged = { categories: {} };

  // Define category layout configurations and ordering
  const categoryConfig = {
    'prime_play': { name: 'Prime Play' },
    'top_picks': { name: 'Top Picks' },
    'news': { name: 'News' },
    'sports': { name: 'Sports' },
    'sportzfy': { name: 'Sportzfy' },
    'movies': { name: 'Movies' },
    'entertainment': { name: 'Entertainment' },
    'kids': { name: 'Kids' },
    'music': { name: 'Music' },
    'infotainment': { name: 'Infotainment' },
    'religion': { name: 'Religion' },
    'international': { name: 'International' },
    'other': { name: 'Other' }
  };

  // Helper to map different category keys to standardized ones
  function mapCategoryKey(key) {
    const k = key.toLowerCase().trim();
    if (k === 'movie' || k === 'movies') return 'movies';
    if (k === 'ent' || k === 'entertainment') return 'entertainment';
    if (k === 'info' || k === 'infotainment') return 'infotainment';
    if (categoryConfig[k]) return k;
    return 'other';
  }

  // Pre-populate standard categories
  Object.keys(categoryConfig).forEach(key => {
    merged.categories[key] = {
      name: categoryConfig[key].name,
      channels: []
    };
  });

  const addedChannels = {}; // key: categoryKey_normalizedName -> channel reference

  function normalizeChannelName(name) {
    return name.toLowerCase()
      .replace(/\s+/g, '')
      .replace(/[^\w]/g, '')
      .replace(/hd/g, '')
      .replace(/sd/g, '')
      .replace(/live/g, '')
      .replace(/tv/g, '')
      .replace(/spots/g, 'sports')
      .replace(/sportzfy/g, 'sports');
  }

  function addChannel(categoryKey, channel, isLocal) {
    const normKey = mapCategoryKey(categoryKey);
    const normName = normalizeChannelName(channel.name);
    const uniqueId = `${normKey}_${normName}`;

    if (addedChannels[uniqueId]) {
      const existing = addedChannels[uniqueId];
      if (isLocal) {
        // Local BDIX stream prioritized as primary
        if (!existing.fallbackUrl && existing.url !== channel.url) {
          existing.fallbackUrl = existing.url;
        }
        existing.url = channel.url;
        if (channel.logo) {
          existing.logo = channel.logo;
        }
      } else {
        // Public stream added as fallback if it differs from local
        if (!existing.fallbackUrl && existing.url !== channel.url) {
          existing.fallbackUrl = channel.url;
        }
      }
    } else {
      const newChannel = {
        id: channel.id || `${normKey}-${Math.random().toString(36).substr(2, 9)}`,
        name: channel.name,
        url: channel.url,
        logo: channel.logo || '',
        fallbackUrl: channel.fallbackUrl || null
      };
      merged.categories[normKey].channels.push(newChannel);
      addedChannels[uniqueId] = newChannel;
    }
  }

  // 1. Process BDIX channels (localData) first to prioritize their streams
  if (local && local.categories) {
    Object.keys(local.categories).forEach(catKey => {
      const cat = local.categories[catKey];
      if (cat.channels && cat.channels.length > 0) {
        cat.channels.forEach(ch => {
          addChannel(catKey, ch, true);
        });
      }
    });
  }

  // 2. Process public global channels (publicData)
  if (publicData && publicData.categories) {
    Object.keys(publicData.categories).forEach(catKey => {
      const cat = publicData.categories[catKey];
      if (cat.channels && cat.channels.length > 0) {
        cat.channels.forEach(ch => {
          addChannel(catKey, ch, false);
        });
      }
    });
  }

  // 3. Remove categories that remain empty
  const finalCategories = {};
  Object.keys(merged.categories).forEach(key => {
    if (merged.categories[key].channels.length > 0) {
      finalCategories[key] = merged.categories[key];
    }
  });
  merged.categories = finalCategories;

  return merged;
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
        if (window.location.protocol === 'https:' && url.startsWith('http://')) {
          url = '/proxy?url=' + encodeURIComponent(url);
        }
        
        currentChannel.url = url;
        
        let groupKey = currentChannel.group.toLowerCase().replace(/\s+/g, '_');
        if (!groupKey) groupKey = 'general';
        
        if (groupKey.includes('news')) groupKey = 'news';
        else if (groupKey.includes('sport') || groupKey.includes('cricket') || groupKey.includes('fifa')) groupKey = 'sports';
        else if (groupKey.includes('religion') || groupKey.includes('islam') || groupKey.includes('peace') || groupKey.includes('relagion')) groupKey = 'religion';
        else if (groupKey.includes('movie') || groupKey.includes('cinema')) groupKey = 'movies';
        else if (groupKey.includes('kid') || groupKey.includes('cartoon')) groupKey = 'kids';
        else if (groupKey.includes('music')) groupKey = 'music';
        else if (groupKey.includes('infotainment') || groupKey.includes('documentary')) groupKey = 'infotainment';
        else if (groupKey.includes('entertainment') || groupKey.includes('general') || groupKey.includes('bangla') || groupKey.includes('akash_go')) groupKey = 'entertainment';
        else groupKey = 'other';
        
        const groupNames = {
          news: 'News',
          sports: 'Sports',
          religion: 'Religion',
          movies: 'Movies',
          kids: 'Kids',
          music: 'Music',
          infotainment: 'Infotainment',
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
  
  const channelButtons = document.querySelectorAll('.channel-btn');
  channelButtons.forEach(button => {
    button.addEventListener('click', function() {
      const url = this.dataset.url;
      const fallbackUrl = this.dataset.fallbackUrl;
      const channelName = this.dataset.channelName;
      
      if (url && url !== '') {
        playChannel(this, url, channelName, fallbackUrl);
        if (window.innerWidth > 640 && window.innerWidth <= 768) {
          sidebar.classList.remove('active');
        }
      } else {
        showError(`${channelName} is coming soon!`);
      }
    });
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
function playChannel(button, url, channelName, fallbackUrl = null) {
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

  if (isTs && typeof mpegts !== 'undefined' && mpegts.getFeatureList().mseLivePlayback) {
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

// ===== Initialize the app =====
loadChannelsData();
