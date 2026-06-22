// ===== DOM Elements =====
const categoryTabsContainer = document.getElementById('categoryTabs');
const channelGridContainer = document.getElementById('channelGrid');
const sidebar = document.getElementById('sidebar');
const mobileMenuBtn = document.getElementById('mobileMenuBtn');
const closeSidebarBtn = document.getElementById('closeSidebarBtn');
const navToggleBtn = document.getElementById('navToggleBtn');
const mobileNavOverlay = document.getElementById('mobileNavOverlay');
const closeNavBtn = document.getElementById('closeNavBtn');

// New DOM Elements
const errorOverlay = document.getElementById('errorOverlay');
const errorDesc = document.getElementById('errorDesc');
const btnReloadStream = document.getElementById('btnReloadStream');

let hasInteracted = false;
let art = null;

// Unmute video player on first user interaction to bypass browser autoplay restrictions
function enableSoundOnInteraction() {
  const unmute = (e) => {
    if (e && e.type === 'click' && !e.isTrusted) return;
    
    hasInteracted = true;
    if (art) {
      art.muted = false;
      if (art.video && art.video.paused) {
        art.play().catch(err => console.log('Interactive play failed:', err));
      }
    }
    document.removeEventListener('click', unmute);
    document.removeEventListener('keydown', unmute);
    document.removeEventListener('touchstart', unmute);
  };
  document.addEventListener('click', unmute, { passive: true });
  document.addEventListener('keydown', unmute, { passive: true });
  document.addEventListener('touchstart', unmute, { passive: true });
}
enableSoundOnInteraction();

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

// Helper to defer non-critical execution until window load and browser idle
function executeOnLoadAndIdle(callback) {
  const run = () => {
    if (window.requestIdleCallback) {
      window.requestIdleCallback(() => callback(), { timeout: 2000 });
    } else {
      setTimeout(callback, 200);
    }
  };

  if (document.readyState === 'complete') {
    run();
  } else {
    window.addEventListener('load', run, { once: true });
  }
}

function getLogoUrl(url) {
  if (!url) return '';
  const rawUrl = getRawUrl(url);
  if (window.location.protocol === 'https:' && rawUrl.startsWith('http://') && !isPrivateIP(rawUrl)) {
    return '/proxy?url=' + encodeURIComponent(rawUrl);
  }
  return rawUrl;
}

function getPlaybackStrategy(channel, forceProxy = false) {
  if (!channel || !channel.url) return 'direct';
  const url = channel.url;
  
  if (forceProxy) {
    if (url.endsWith('.ts') || url.includes('.ts?')) {
      return 'proxy-stream';
    }
    return 'proxy';
  }

  if (url.endsWith('.mpd') || url.includes('.mpd?') || channel.drm) {
    return 'drm';
  }

  if (url.endsWith('.ts') || url.includes('.ts?')) {
    return 'proxy-stream';
  }

  if (url.includes('cdn.livekhelatv.com') || url.includes('toffeelive.com')) {
    return 'proxy';
  }

  if (url.startsWith('http://')) {
    return 'proxy';
  }

  return 'direct';
}

function enrichChannelsMetadata() {
  if (!channelsData || !channelsData.categories) return;
  const categories = channelsData.categories;
  for (const catKey in categories) {
    const category = categories[catKey];
    if (category.channels) {
      category.channels = category.channels.map(channel => {
        return {
          ...channel,
          playbackMode: getPlaybackStrategy(channel)
        };
      });
    }
  }
}

// ===== Load channels data from cached server endpoint =====
async function loadChannelsData() {
  errorOverlay.classList.remove('active');

  if (window.initialChannelsData) {
    channelsData = window.initialChannelsData;
    initializeUI();
    return;
  }

  categoryTabsContainer.innerHTML = '<p class="loading-text" style="padding: 1rem;">Loading channels...</p>';
  channelGridContainer.innerHTML = '';

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

// ===== URL slugification helpers for routing =====
function slugify(text) {
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '-')
    .replace(/[^\w\-]+/g, '')
    .replace(/\-\-+/g, '-')
    .replace(/^-+/, '')
    .replace(/-+$/, '');
}

function getChannelSlug(channel) {
  const nameSlug = slugify(channel.name);
  const id = channel.id;
  if (id.startsWith(nameSlug) || id.endsWith(nameSlug)) {
    return id;
  }
  return `${nameSlug}-${id}`;
}

function findChannelByIdOrSlug(idOrSlug) {
  if (!idOrSlug || !channelsData || !channelsData.categories) return null;
  const categories = channelsData.categories;
  for (const catKey in categories) {
    const category = categories[catKey];
    if (category.channels) {
      const channel = category.channels.find(c => c.id === idOrSlug || getChannelSlug(c) === idOrSlug || slugify(c.id) === slugify(idOrSlug));
      if (channel) {
        return { channel, categoryKey: catKey };
      }
    }
  }
  return null;
}

function playChannelById(channelId) {
  const match = findChannelByIdOrSlug(channelId);
  if (!match) return;

  const { channel, categoryKey } = match;

  if (currentCategory !== categoryKey) {
    currentCategory = categoryKey;
    const tabs = categoryTabsContainer.querySelectorAll('.tab-btn');
    tabs.forEach(tab => {
      if (tab.dataset.category === categoryKey) {
        tab.classList.add('active');
      } else {
        tab.classList.remove('active');
      }
    });
    renderChannelsForCategory(categoryKey);
  }

  const button = channelGridContainer.querySelector(`.channel-btn[data-channel-id="${channel.id}"]`);
  playChannel(button, channel.url, channel.name, channel.fallbackUrl);
}

// ===== Toggle Category Visibility for Pre-rendered Grid =====
function toggleCategoryVisibility(categoryKey) {
  const categoryDivs = channelGridContainer.querySelectorAll('.channel-category');
  categoryDivs.forEach(div => {
    if (div.dataset.category === categoryKey) {
      div.style.display = '';
    } else {
      div.style.display = 'none';
    }
  });
}

// ===== Initialize UI with tabs and channels =====
function initializeUI() {
  if (!channelsData || !channelsData.categories) return;
  enrichChannelsMetadata();
  
  const hasPrerendered = channelGridContainer.querySelector('.channel-category') !== null;
  
  if (!hasPrerendered) {
    createCategoryTabs();
  }
  
  // Determine which channel to play first
  const activeChannelId = document.body.dataset.activeChannelId;
  let initialChannelId = activeChannelId;
  if (!initialChannelId && window.location.pathname.startsWith('/watch/')) {
    initialChannelId = window.location.pathname.split('/watch/')[1];
  }
  
  const match = findChannelByIdOrSlug(initialChannelId);
  if (match) {
    currentCategory = match.categoryKey;
    if (!hasPrerendered) {
      renderChannelsForCategory(currentCategory);
    } else {
      toggleCategoryVisibility(currentCategory);
    }
    
    const tabs = categoryTabsContainer.querySelectorAll('.tab-btn');
    tabs.forEach(tab => {
      if (tab.dataset.category === currentCategory) {
        tab.classList.add('active');
      } else {
        tab.classList.remove('active');
      }
    });
    
    setupEventListeners();
    
    executeOnLoadAndIdle(() => {
      playChannelById(match.channel.id);
    });
  } else {
    const categoryKeys = Object.keys(channelsData.categories);
    if (categoryKeys.length > 0) {
      currentCategory = categoryKeys[0];
      if (!hasPrerendered) {
        renderChannelsForCategory(currentCategory);
      } else {
        toggleCategoryVisibility(currentCategory);
      }
    }
    
    setupEventListeners();
    
    executeOnLoadAndIdle(() => {
      const firstChannelBtn = channelGridContainer.querySelector('.channel-btn[data-url]:not([data-url=""])');
      if (firstChannelBtn) {
        const channelId = firstChannelBtn.dataset.channelId;
        const chanMatch = findChannelByIdOrSlug(channelId);
        if (chanMatch) {
          playChannelById(channelId);
          const slug = getChannelSlug(chanMatch.channel);
          history.replaceState({ channelId }, '', `/watch/${slug}`);
        }
      }
    });
  }
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
  const hasPrerendered = channelGridContainer.querySelector('.channel-category') !== null;
  if (hasPrerendered) {
    toggleCategoryVisibility(categoryKey);
    return;
  }

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
    img.src = getLogoUrl(channel.logo);
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
  errorOverlay.classList.add('active');
  
  const rawUrl = getRawUrl(url);
  const isPrivate = isPrivateIP(rawUrl);
  const channelId = lastSelectedChannelBtn ? lastSelectedChannelBtn.dataset.channelId : null;
  const match = findChannelByIdOrSlug(channelId);
  const channel = match ? match.channel : null;
  const isDrm = url.endsWith('.mpd') || url.includes('.mpd?') || (channel && !!channel.drm);
  
  if (isDrm) {
    errorDesc.innerHTML = `
      Failed to load <strong>${channelName}</strong>.<br><br>
      This channel uses DRM protection. Your browser or device might not support the required decryption technologies, or the stream keys may have expired.<br><br>
      <strong>How to fix:</strong><br>
      1. Ensure you are using a modern browser like Google Chrome, Microsoft Edge, or Firefox.<br>
      2. If you are on an older device, DRM playback may not be supported.
    `;
  } else if (isPrivate) {
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
  const channelId = button ? button.dataset.channelId : null;
  const match = findChannelByIdOrSlug(channelId);
  const channel = match ? match.channel : { url, name: channelName };
  const isDrm = (channel.url.endsWith('.mpd') || channel.url.includes('.mpd?') || !!channel.drm);

  if (isDrm) {
    console.error(`[DRM] Shaka error / playback failed for: ${channelName}`);
    const wasProxied = url.startsWith('/proxy?url=');
    if (!wasProxied && !isPrivateIP(channel.url)) {
      console.log(`[PLAYBACK] DRM direct failed, falling back to proxy: ${channelName}`);
      showError(`Retrying ${channelName} via proxy...`);
      playChannel(button, url, channelName, fallbackUrl, true);
      return;
    }
    showPlayerError(channelName, url);
    return;
  }

  // If direct playback (direct or drm played directly) failed, retry via proxy
  const wasProxied = url.startsWith('/proxy?url=');
  if (!wasProxied && !isPrivateIP(url)) {
    console.log(`[PLAYBACK] Direct failed, falling back to proxy: ${channelName}`);
    showError(`Retrying ${channelName} via proxy...`);
    playChannel(button, url, channelName, fallbackUrl, true);
    return;
  }

  // If already proxied or direct failed and cannot be proxied, try the fallback URL
  if (fallbackUrl && fallbackUrl !== '' && fallbackUrl !== 'null' && fallbackUrl !== 'undefined') {
    console.log(`[PLAYBACK] Proxy failed for ${channelName}. Trying fallback URL: ${fallbackUrl}`);
    showError(`Switching to fallback stream for ${channelName}...`);
    playChannel(button, fallbackUrl, channelName, null, false);
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
    const channelId = button.dataset.channelId;
    
    if (url && url !== '') {
      playChannel(button, url, channelName, fallbackUrl);
      
      // Update browser URL on user click
      const match = findChannelByIdOrSlug(channelId);
      if (match) {
        const slug = getChannelSlug(match.channel);
        const path = `/watch/${slug}`;
        if (window.location.pathname !== path) {
          history.pushState({ channelId }, '', path);
        }
      }
      
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

// ===== HLS & TS Playback Helpers for ArtPlayer =====
function playM3u8(video, url, artPlayer) {
  if (Hls.isSupported()) {
    if (artPlayer.hls) {
      try {
        artPlayer.hls.destroy();
      } catch (e) {
        console.error('Error destroying HLS instance on playM3u8:', e);
      }
      artPlayer.hls = null;
    }
    const hls = new Hls({
      enableWorker: true,
      lowLatencyMode: false,
      backBufferLength: 60,
      maxBufferLength: 30,
      maxMaxBufferLength: 90,
      maxBufferSize: 60 * 1000 * 1000,
      maxBufferHole: 0.5,
      liveSyncDurationCount: 5,
      liveSyncOnStallIncrease: 1,
      liveMaxLatencyDurationCount: 15,
      highBufferWatchdogPeriod: 2
    });
    hls.loadSource(url);
    hls.attachMedia(video);
    artPlayer.hls = hls;

    hls.on(Hls.Events.MANIFEST_PARSED, () => {
      const levels = hls.levels;
      if (levels && levels.length > 1) {
        const options = levels.map((level, index) => {
          const label = level.height ? `${level.height}p` : `${Math.round(level.bitrate / 1000)}kbps`;
          return {
            html: label,
            level: index,
          };
        });

        // Add Auto option at the beginning
        options.unshift({
          html: 'Auto',
          level: -1,
          default: true,
        });

        // Remove any existing quality setting if it exists
        try {
          artPlayer.setting.remove('quality');
        } catch (e) {
          // ignore
        }

        // Add quality selector to ArtPlayer settings
        artPlayer.setting.add({
          name: 'quality',
          html: 'Quality',
          width: 150,
          selector: options,
          onSelect: function (item) {
            hls.currentLevel = item.level;
            return item.html;
          },
        });
      }
    });

    let networkRetryCount = 0;
    hls.on(Hls.Events.ERROR, (event, data) => {
      console.error('HLS error inside ArtPlayer:', data);
      if (data.fatal) {
        switch (data.type) {
          case Hls.ErrorTypes.NETWORK_ERROR:
            networkRetryCount++;
            if (networkRetryCount > 2) {
              try {
                hls.destroy();
              } catch (e) {
                console.error('Error destroying HLS in error event:', e);
              }
              artPlayer.hls = null;
              artPlayer.emit('video:error', data);
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
            try {
              hls.destroy();
            } catch (e) {
              console.error('Error destroying HLS in default error event:', e);
            }
            artPlayer.hls = null;
            artPlayer.emit('video:error', data);
            break;
        }
      }
    });

    artPlayer.on('destroy', () => {
      if (artPlayer.hls) {
        try {
          artPlayer.hls.destroy();
        } catch (e) {
          console.error('Error destroying HLS on player destroy:', e);
        }
        artPlayer.hls = null;
      }
    });
  } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
    video.src = url;
  } else {
    showError('Your browser does not support HLS streaming.');
  }
}

function playTs(video, url, artPlayer) {
  if (typeof mpegts !== 'undefined' && mpegts.getFeatureList().mseLivePlayback) {
    if (artPlayer.mpegtsPlayer) {
      try {
        artPlayer.mpegtsPlayer.destroy();
      } catch (e) {
        console.error('Error destroying mpegtsPlayer on playTs:', e);
      }
      artPlayer.mpegtsPlayer = null;
    }
    const mpegtsPlayer = mpegts.createPlayer({
      type: 'mse',
      isLive: true,
      url: url
    });
    mpegtsPlayer.attachMediaElement(video);
    mpegtsPlayer.load();
    artPlayer.mpegtsPlayer = mpegtsPlayer;

    mpegtsPlayer.on(mpegts.Events.ERROR, (errorType, errorDetail, errorInfo) => {
      console.error('MPEGTS error inside ArtPlayer:', errorType, errorDetail, errorInfo);
      try {
        mpegtsPlayer.destroy();
      } catch (e) {
        console.error('Error destroying mpegtsPlayer in error event:', e);
      }
      artPlayer.mpegtsPlayer = null;
      artPlayer.emit('video:error', { errorType, errorDetail, errorInfo });
    });

    artPlayer.on('destroy', () => {
      if (artPlayer.mpegtsPlayer) {
        try {
          artPlayer.mpegtsPlayer.destroy();
        } catch (e) {
          console.error('Error destroying mpegtsPlayer on player destroy:', e);
        }
        artPlayer.mpegtsPlayer = null;
      }
    });
  } else {
    showError('Your browser does not support TS streaming.');
  }
}

function playMpd(video, url, artPlayer) {
  if (typeof shaka === 'undefined') {
    loadScript('https://cdnjs.cloudflare.com/ajax/libs/shaka-player/4.7.1/shaka-player.compiled.js')
      .then(() => {
        initializeShakaPlayer(video, url, artPlayer);
      })
      .catch(err => {
        console.error('Failed to load Shaka Player script:', err);
        showError('Your browser does not support DASH streaming.');
        handlePlaybackError(lastSelectedChannelBtn, url, lastSelectedChannelName, null);
      });
  } else {
    initializeShakaPlayer(video, url, artPlayer);
  }
}

function initializeShakaPlayer(video, url, artPlayer) {
  shaka.polyfill.installAll();
  
  if (!shaka.Player.isBrowserSupported()) {
    console.error('Browser not supported for Shaka Player.');
    showError('DASH playback is not supported by your browser.');
    return;
  }
  
  if (artPlayer.shaka) {
    try {
      artPlayer.shaka.destroy();
    } catch (e) {
      console.error('Error destroying previous Shaka Player instance:', e);
    }
    artPlayer.shaka = null;
  }
  
  const player = new shaka.Player(video);
  artPlayer.shaka = player;
  console.log('[DRM] Shaka initialized');
  
  player.addEventListener('error', (event) => {
    console.error('[DRM] Shaka error', event.detail);
    console.log('[DRM] Shaka error');
    if (event.detail && event.detail.severity === shaka.util.Error.Severity.CRITICAL) {
      artPlayer.emit('video:error', event.detail);
    }
  });

  const channelId = lastSelectedChannelBtn ? lastSelectedChannelBtn.dataset.channelId : null;
  const match = findChannelByIdOrSlug(channelId);
  const channel = match ? match.channel : null;
  const drm = channel ? channel.drm : null;
  
  if (drm && drm.kid && drm.key) {
    try {
      player.configure({
        drm: {
          clearKeys: {
            [drm.kid.trim()]: drm.key.trim()
          }
        }
      });
      console.log('[DRM] ClearKey configured');
    } catch (e) {
      console.error('[DRM] License configuration failed', e);
      console.log('[DRM] License configuration failed');
    }
  }
  
  player.load(url).then(() => {
    console.log('[DRM] Manifest loaded');
    video.addEventListener('playing', () => {
      console.log('[DRM] Playback started');
    }, { once: true });

    // Enable quality selection for Shaka Player
    const tracks = player.getVariantTracks();
    if (tracks && tracks.length > 1) {
      tracks.sort((a, b) => (b.height || 0) - (a.height || 0));
      const seenHeights = new Set();
      const uniqueTracks = [];
      tracks.forEach(track => {
        const height = track.height;
        if (height && !seenHeights.has(height)) {
          seenHeights.add(height);
          uniqueTracks.push(track);
        }
      });

      if (uniqueTracks.length > 1) {
        const options = uniqueTracks.map(track => {
          return {
            html: `${track.height}p`,
            track: track,
          };
        });

        options.unshift({
          html: 'Auto',
          track: null,
          default: true,
        });

        try {
          artPlayer.setting.remove('quality');
        } catch (e) {}

        artPlayer.setting.add({
          name: 'quality',
          html: 'Quality',
          width: 150,
          selector: options,
          onSelect: function (item) {
            if (item.track === null) {
              player.configure({ abr: { enabled: true } });
            } else {
              player.configure({ abr: { enabled: false } });
              player.selectVariantTrack(item.track, true);
            }
            return item.html;
          }
        });
      }
    }
  }).catch((error) => {
    console.error('[DRM] Manifest load failed', error);
    console.log('[DRM] Manifest load failed');
    artPlayer.emit('video:error', error);
  });
  
  artPlayer.on('destroy', () => {
    if (artPlayer.shaka) {
      try {
        artPlayer.shaka.destroy();
      } catch (e) {
        console.error('Error destroying Shaka Player on destroy:', e);
      }
      artPlayer.shaka = null;
    }
  });
}

// ===== Play channel =====
async function playChannel(button, url, channelName, fallbackUrl = null, forceProxy = false) {
  errorOverlay.classList.remove('active');
  
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

  // Find the enriched channel object to classify playback mode
  const channelId = button ? button.dataset.channelId : null;
  const match = findChannelByIdOrSlug(channelId);
  const channel = match ? match.channel : { url, name: channelName };

  // Update document title for better user experience/SEO on navigation
  if (channel) {
    const nameLower = channel.name.toLowerCase();
    const hasLiveWord = nameLower.endsWith('live') || nameLower.includes(' live ') || nameLower.includes(' live(') || nameLower.includes(' live');
    const defaultSeoTitle = hasLiveWord 
      ? `Watch ${channel.name} | Vibestream` 
      : `Watch ${channel.name} Live | Vibestream`;
    const seoTitle = channel.seo?.title || defaultSeoTitle;
    document.title = seoTitle;
  }

  // Classify strategy
  const strategy = getPlaybackStrategy(channel, forceProxy);

  // Log play mode
  const logPrefix = '[PLAYBACK]';
  if (strategy === 'direct') {
    console.log(`${logPrefix} Direct: ${channel.name}`);
  } else if (strategy === 'proxy') {
    console.log(`${logPrefix} Proxy: ${channel.name}`);
  } else if (strategy === 'proxy-stream') {
    console.log(`${logPrefix} Proxy Stream: ${channel.name}`);
  } else if (strategy === 'drm') {
    console.log(`${logPrefix} DRM: ${channel.name}`);
  }

  // Determine actual playback URL
  let playbackUrl = url;
  if (strategy === 'proxy' || strategy === 'proxy-stream') {
    playbackUrl = '/proxy?url=' + encodeURIComponent(url);
  }

  const isTs = (strategy === 'proxy-stream');
  const isMpd = (strategy === 'drm') || url.endsWith('.mpd') || url.includes('.mpd?') || (channel && !!channel.drm);

  try {
    // Destroy previous player inside try block safely using destroy(false) to keep container
    if (art) {
      try {
        if (art.shaka) {
          art.shaka.destroy().catch(e => console.error('Error destroying Shaka:', e));
          art.shaka = null;
        }
        art.destroy(false);
      } catch (destroyError) {
        console.error('Failed to destroy previous ArtPlayer instance:', destroyError);
      }
      art = null;
    }

    // Show visual loading indicator while loading the player engine and dependencies
    const playerEl = document.getElementById('player');
    if (playerEl) {
      playerEl.innerHTML = `
        <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; width: 100%; background: #000; color: #fff; font-family: 'Inter', sans-serif;">
          <div style="width: 40px; height: 40px; border: 3px solid rgba(255, 255, 255, 0.1); border-top-color: #6366f1; border-radius: 50%; animation: spin-loader 1s linear infinite; margin-bottom: 12px;"></div>
          <div style="font-size: 0.875rem; color: #a1a1aa; font-weight: 500;">Loading Player Engines...</div>
        </div>
        <style>
          @keyframes spin-loader {
            to { transform: rotate(360deg); }
          }
        </style>
      `;
    }

    // Load player engine and specific playback engine in parallel to optimize latency
    const enginePromises = [];
    if (typeof Artplayer === 'undefined') {
      enginePromises.push(loadScript('https://cdn.jsdelivr.net/npm/artplayer/dist/artplayer.js'));
    }

    if (isTs) {
      if (typeof mpegts === 'undefined') {
        enginePromises.push(loadScript('https://cdn.jsdelivr.net/npm/mpegts.js@1.7.3/dist/mpegts.min.js'));
      }
    } else if (isMpd) {
      if (typeof shaka === 'undefined') {
        enginePromises.push(loadScript('https://cdnjs.cloudflare.com/ajax/libs/shaka-player/4.7.1/shaka-player.compiled.js'));
      }
    } else {
      if (typeof Hls === 'undefined') {
        enginePromises.push(loadScript('https://cdn.jsdelivr.net/npm/hls.js@latest'));
      }
    }

    if (enginePromises.length > 0) {
      await Promise.all(enginePromises);
    }

    // 3. Initialize ArtPlayer
    art = new Artplayer({
      container: '#player',
      url: playbackUrl,
      type: isTs ? 'ts' : (isMpd ? 'mpd' : 'm3u8'),
      isLive: true,
      autoplay: true,
      muted: !hasInteracted,
      volume: 0.8,
      pip: true,
      fullscreen: true,
      fullscreenWeb: true,
      autoOrientation: true,
      playbackRate: false,
      aspectRatio: true,
      setting: true,
      theme: '#6366f1',
      autoSize: false,
      autoMini: false,
      customType: {
        m3u8: playM3u8,
        ts: playTs,
        mpd: playMpd
      }
    });

    // 4. Hook lifecycle events for our overlays and error handling
    art.on('video:error', (e) => {
      console.error('Artplayer video error:', e);
      handlePlaybackError(button, url, channelName, fallbackUrl);
    });

  } catch (error) {
    console.error('Failed to load player engine script or initialize player:', error);
    handlePlaybackError(button, url, channelName, fallbackUrl);
  }
}

// ===== Handle browser navigation (Back/Forward) =====
window.addEventListener('popstate', (e) => {
  let channelId = e.state?.channelId;
  if (!channelId) {
    const path = window.location.pathname;
    if (path.startsWith('/watch/')) {
      const slug = path.split('/watch/')[1];
      const match = findChannelByIdOrSlug(slug);
      if (match) {
        channelId = match.channel.id;
      }
    }
  }
  
  if (channelId) {
    playChannelById(channelId);
  } else {
    const firstChannelBtn = channelGridContainer.querySelector('.channel-btn[data-url]:not([data-url=""])');
    if (firstChannelBtn) {
      playChannelById(firstChannelBtn.dataset.channelId);
    }
  }
});

// ===== Keyboard shortcuts =====
function handleKeyboard(e) {
  if (e.code === 'Space' && e.target === document.body && art) {
    e.preventDefault();
    art.toggle();
  }
  
  if (e.code === 'Escape') {
    if (sidebar && window.innerWidth > 640 && window.innerWidth <= 768) {
      sidebar.classList.remove('active');
    }
    if (mobileNavOverlay && mobileNavOverlay.classList.contains('active')) {
      mobileNavOverlay.classList.remove('active');
    }
  }
  
  if (e.code === 'KeyM' && window.innerWidth > 640 && window.innerWidth <= 768 && sidebar) {
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
if (btnReloadStream) {
  btnReloadStream.addEventListener('click', () => {
    if (lastSelectedChannelUrl) {
      const fallbackUrl = lastSelectedChannelBtn ? lastSelectedChannelBtn.dataset.fallbackUrl : null;
      playChannel(lastSelectedChannelBtn, lastSelectedChannelUrl, lastSelectedChannelName, fallbackUrl);
    }
  });
}

// ===== Mobile layout triggers =====
if (mobileMenuBtn) {
  mobileMenuBtn.addEventListener('click', () => {
    if (sidebar) {
      sidebar.classList.add('active');
    }
  });
}

if (closeSidebarBtn) {
  closeSidebarBtn.addEventListener('click', () => {
    if (sidebar) {
      sidebar.classList.remove('active');
    }
  });
}

if (navToggleBtn && mobileNavOverlay) {
  navToggleBtn.addEventListener('click', () => {
    mobileNavOverlay.classList.add('active');
  });
}

if (closeNavBtn && mobileNavOverlay) {
  closeNavBtn.addEventListener('click', () => {
    mobileNavOverlay.classList.remove('active');
  });
}

document.addEventListener('keydown', handleKeyboard);

document.addEventListener('click', (e) => {
  // Click outside sidebar to close
  if (sidebar && mobileMenuBtn && 
      sidebar.classList.contains('active') &&
      !sidebar.contains(e.target) && 
      !mobileMenuBtn.contains(e.target)) {
    sidebar.classList.remove('active');
  }
  
  // Click outside mobile nav drawer to close
  if (mobileNavOverlay && navToggleBtn &&
      mobileNavOverlay.classList.contains('active') &&
      !mobileNavOverlay.querySelector('.mobile-nav-drawer').contains(e.target) &&
      !navToggleBtn.contains(e.target)) {
    mobileNavOverlay.classList.remove('active');
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

// ===== Initialize the app =====
const playerContainer = document.getElementById('player');
if (playerContainer && categoryTabsContainer && channelGridContainer) {
  loadChannelsData();
}
executeOnLoadAndIdle(() => {
  loadNewsData();
});

// Trigger Artplayer resize on window resize to guarantee responsiveness across dynamic layout changes
window.addEventListener('resize', () => {
  if (window.innerWidth > 1024 && mobileNavOverlay && mobileNavOverlay.classList.contains('active')) {
    mobileNavOverlay.classList.remove('active');
  }
  if (art && typeof art.resize === 'function') {
    art.resize();
  }
});

// ===== Custom Pull-to-Refresh =====
// Native browser pull-to-refresh doesn't fire when body has overflow:hidden (player layout).
// This custom implementation watches the channel grid scroll container and fires
// a page reload when the user pulls down at the top — matching the native UX.
(function initPullToRefresh() {
  const PULL_THRESHOLD = 72;   // px to trigger reload
  const MAX_VISUAL    = 110;   // max visual travel of the indicator (px)
  const HIDE_Y        = -80;   // resting off-screen Y position (px)

  // Build indicator DOM once
  const indicator = document.createElement('div');
  indicator.id = 'pullRefreshIndicator';
  indicator.innerHTML = `
    <div class="pull-refresh-pill">
      <svg class="pull-refresh-icon" id="ptrIcon" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <path d="M1 4v6h6"/>
        <path d="M3.51 15a9 9 0 1 0 .49-4"/>
      </svg>
      <span class="pull-refresh-text" id="ptrText">Pull to refresh</span>
    </div>
  `;
  document.body.appendChild(indicator);

  const ptrIcon = document.getElementById('ptrIcon');
  const ptrText = document.getElementById('ptrText');

  let touchStartY   = 0;
  let currentPullY  = 0;
  let isPulling     = false;
  let isRefreshing  = false;
  let rafId         = null;

  // Returns the primary scrollable container (channel grid on player layout, else body)
  function getScrollContainer() {
    if (channelGridContainer && channelGridContainer.scrollHeight > channelGridContainer.clientHeight) {
      return channelGridContainer;
    }
    return document.documentElement;
  }

  function getScrollTop() {
    const sc = getScrollContainer();
    return sc === document.documentElement
      ? (document.documentElement.scrollTop || document.body.scrollTop)
      : sc.scrollTop;
  }

  function applyIndicator(pullY) {
    const progress   = Math.min(pullY / PULL_THRESHOLD, 1);
    const visualY    = Math.min(pullY * 0.65, MAX_VISUAL) + HIDE_Y + 80; // slide in from top
    const triggered  = pullY >= PULL_THRESHOLD;

    // Move + fade indicator
    indicator.style.transform = `translateX(-50%) translateY(${visualY}px)`;
    indicator.style.opacity   = Math.min(progress * 1.4, 1).toString();

    // Rotate icon proportional to pull (like native UX)
    const rotation = triggered ? 180 : Math.round(progress * 160);
    ptrIcon.style.transform = `rotate(${rotation}deg)`;

    // State classes
    indicator.classList.toggle('ptr-triggered', triggered);
    ptrText.textContent = triggered ? 'Release to refresh' : 'Pull to refresh';
  }

  function resetIndicator() {
    indicator.style.transform = `translateX(-50%) translateY(${HIDE_Y}px)`;
    indicator.style.opacity   = '0';
    indicator.classList.remove('ptr-triggered', 'ptr-refreshing');
    ptrIcon.style.transform   = 'rotate(0deg)';
    ptrText.textContent       = 'Pull to refresh';
  }

  function triggerRefresh() {
    isRefreshing = true;
    indicator.classList.add('ptr-refreshing');
    indicator.classList.remove('ptr-triggered');
    ptrIcon.classList.add('spinning');
    ptrIcon.style.transform = 'rotate(0deg)';
    ptrText.textContent     = 'Refreshing…';
    // Keep indicator visible while loading
    indicator.style.transform = `translateX(-50%) translateY(20px)`;
    indicator.style.opacity   = '1';

    setTimeout(() => { window.location.reload(); }, 450);
  }

  // ── Touch Handlers ──────────────────────────────────────────────────────────

  document.addEventListener('touchstart', function(e) {
    if (isRefreshing) return;
    // Only begin pull detection when scrolled to the very top
    if (getScrollTop() <= 1) {
      touchStartY  = e.touches[0].clientY;
      currentPullY = 0;
      isPulling    = true;
    } else {
      isPulling = false;
    }
  }, { passive: true });

  document.addEventListener('touchmove', function(e) {
    if (!isPulling || isRefreshing) return;

    const dy = e.touches[0].clientY - touchStartY;
    if (dy <= 0) {
      // Scrolling up — hide indicator
      if (currentPullY > 0) {
        currentPullY = 0;
        if (rafId) cancelAnimationFrame(rafId);
        rafId = requestAnimationFrame(resetIndicator);
      }
      return;
    }

    currentPullY = dy;
    if (rafId) cancelAnimationFrame(rafId);
    rafId = requestAnimationFrame(() => applyIndicator(currentPullY));
  }, { passive: true });

  document.addEventListener('touchend', function() {
    if (!isPulling || isRefreshing) return;
    isPulling = false;

    if (rafId) cancelAnimationFrame(rafId);

    if (currentPullY >= PULL_THRESHOLD) {
      triggerRefresh();
    } else {
      // Snap back with a CSS transition for the release
      indicator.style.transition = 'transform 0.3s cubic-bezier(0.4,0,0.2,1), opacity 0.3s ease';
      resetIndicator();
      setTimeout(() => { indicator.style.transition = ''; }, 320);
    }

    currentPullY = 0;
  }, { passive: true });

  document.addEventListener('touchcancel', function() {
    if (!isPulling) return;
    isPulling    = false;
    currentPullY = 0;
    if (rafId) cancelAnimationFrame(rafId);
    resetIndicator();
  }, { passive: true });
})();

