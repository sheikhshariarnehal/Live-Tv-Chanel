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
let consecutiveFailuresCount = 0;
let failingChannelUrl = null;
let autoAdvanceTimeoutId = null;

// ===== Playback Loop-Prevention Guards =====
// Prevents concurrent playChannel calls and stale error-event re-triggering.
let isPlayerInitializing = false;  // Re-entrancy lock for playChannel
let currentPlaybackToken = 0;      // Incremented each call; error handlers compare their captured token
let lastPlaybackErrorTime = 0;     // Timestamp of last handlePlaybackError call for cooldown

// ===== URL Helper Functions for CORS & Mixed Content/BDIX Routing =====
function getRawUrl(url) {
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

const PROXY_DOMAINS = [
  "https://fifa-proxy.nehaldiu.workers.dev/",
  "https://live-stream-proxy.nehaldev08.workers.dev/",
  "https://live-stream-proxy.nehalmahamud-cse.workers.dev/"
];

function getProxiedUrl(url, channelOrId) {
  if (!url) return '';
  if (isPrivateIP(url)) return url;
  
  const channel = (channelOrId && typeof channelOrId === 'object') ? channelOrId : null;
  const channelId = channel ? channel.id : (typeof channelOrId === 'string' ? channelOrId : null);
  
  // Clean up any existing proxy domain from the list first to avoid double-proxying
  let targetUrl = url;
  for (const p of PROXY_DOMAINS) {
    if (targetUrl.startsWith(p)) {
      if (targetUrl.startsWith(p + "?url=")) {
        try {
          targetUrl = decodeURIComponent(targetUrl.substring((p + "?url=").length));
        } catch (e) {
          targetUrl = targetUrl.substring((p + "?url=").length);
        }
      } else {
        targetUrl = targetUrl.substring(p.length);
      }
    }
  }
  
  // Clean up old DigitalOcean proxy if present
  const oldProxy = "https://cors-everywhere-wc8b4.ondigitalocean.app/";
  if (targetUrl.startsWith(oldProxy)) {
    targetUrl = targetUrl.substring(oldProxy.length);
  }
  
  // Select proxy domain deterministically based on channel ID or URL hash to keep load balanced and sticky
  const key = channelId || targetUrl;
  let hash = 0;
  for (let i = 0; i < key.length; i++) {
    hash = key.charCodeAt(i) + ((hash << 5) - hash);
  }
  const index = Math.abs(hash) % PROXY_DOMAINS.length;
  const selectedProxy = PROXY_DOMAINS[index];
  
  let proxiedUrl = selectedProxy + "?url=" + encodeURIComponent(targetUrl);
  
  if (channel && channel.headers) {
    const headers = channel.headers;
    for (const key of Object.keys(headers)) {
      const lowerKey = key.toLowerCase();
      const val = headers[key];
      if (val) {
        if (lowerKey === 'referer') {
          proxiedUrl += "&referer=" + encodeURIComponent(val);
        } else if (lowerKey === 'origin') {
          proxiedUrl += "&origin=" + encodeURIComponent(val);
        } else if (lowerKey === 'user-agent' || lowerKey === 'ua') {
          proxiedUrl += "&ua=" + encodeURIComponent(val);
        }
      }
    }
  }
  
  return proxiedUrl;
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
  return url || '';
}

function getPlaybackStrategy(channel) {
  if (!channel || !channel.url) return 'direct';
  const url = channel.url;

  if (url.endsWith('.mpd') || url.includes('.mpd?') || channel.drm) {
    return 'drm';
  }

  if (url.endsWith('.ts') || url.includes('.ts?')) {
    return 'ts';
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
  consecutiveFailuresCount = 0;
  // User/system intent to play a specific channel — forcefully reset guards so
  // a stuck initializing state or recent error cooldown never blocks the switch.
  isPlayerInitializing = false;
  lastPlaybackErrorTime = 0;
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
      // Fully render the current category if it was only partially pre-rendered
      const categoryDiv = channelGridContainer.querySelector(`.channel-category[data-category="${currentCategory}"]`);
      if (categoryDiv && categoryDiv.dataset.fullyRendered !== "true") {
        renderChannelsForCategory(currentCategory);
      }
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
      // Fully render the current category if it was only partially pre-rendered
      const categoryDiv = channelGridContainer.querySelector(`.channel-category[data-category="${currentCategory}"]`);
      if (categoryDiv && categoryDiv.dataset.fullyRendered !== "true") {
        renderChannelsForCategory(currentCategory);
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
  // Check if this category is already rendered in the DOM
  let categoryDiv = channelGridContainer.querySelector(`.channel-category[data-category="${categoryKey}"]`);
  
  // Check if this category is fully rendered (i.e. not the initial partial rendering of 24 channels)
  const isFullyRendered = categoryDiv && categoryDiv.dataset.fullyRendered === "true";
  
  if (categoryDiv && isFullyRendered) {
    // Hide all other categories, show this one
    const categoryDivs = channelGridContainer.querySelectorAll('.channel-category');
    categoryDivs.forEach(div => {
      if (div === categoryDiv) {
        div.style.display = '';
      } else {
        div.style.display = 'none';
      }
    });
    return;
  }

  if (!channelsData || !channelsData.categories) return;
  const category = channelsData.categories[categoryKey];
  if (!category || !category.channels) return;
  
  if (!categoryDiv) {
    categoryDiv = document.createElement('div');
    categoryDiv.className = 'channel-category';
    categoryDiv.dataset.category = categoryKey;
  } else {
    categoryDiv.innerHTML = ''; // Re-render the partial category fully
  }
  
  categoryDiv.dataset.fullyRendered = "true";
  
  const fragment = document.createDocumentFragment();
  category.channels.forEach(channel => {
    const channelBtn = createChannelButton(channel);
    const isPlaybackMatch = channel.url === lastSelectedChannelUrl || (channel.fallbackUrl && channel.fallbackUrl === lastSelectedChannelUrl);
    if (isPlaybackMatch) {
      channelBtn.classList.add('active');
      lastSelectedChannelBtn = channelBtn;
    }
    fragment.appendChild(channelBtn);
  });
  
  categoryDiv.appendChild(fragment);
  
  // Hide all others and show/append this one
  const categoryDivs = channelGridContainer.querySelectorAll('.channel-category');
  categoryDivs.forEach(div => {
    if (div !== categoryDiv) {
      div.style.display = 'none';
    }
  });
  
  if (!categoryDiv.parentNode) {
    channelGridContainer.appendChild(categoryDiv);
  } else {
    categoryDiv.style.display = '';
  }
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
  
  const iconContainer = document.createElement('div');
  iconContainer.className = 'channel-icon-container';
  
  if (channel.logo) {
    const img = document.createElement('img');
    img.src = getLogoUrl(channel.logo);
    img.alt = channel.name;
    img.className = 'channel-logo';
    img.loading = 'lazy';
    img.style.opacity = '0';
    img.style.transition = 'opacity 0.2s ease-in';
    img.onload = function() {
      this.style.opacity = '1';
    };
    img.onerror = function() {
      const parent = this.parentNode;
      if (parent) {
        const char = this.alt ? this.alt.charAt(0) : '?';
        parent.innerHTML = `<div class="channel-avatar">${char}</div>`;
      }
    };
    iconContainer.appendChild(img);
  } else {
    const avatar = document.createElement('div');
    avatar.className = 'channel-avatar';
    avatar.textContent = channel.name ? channel.name.charAt(0) : '?';
    iconContainer.appendChild(avatar);
  }
  
  button.appendChild(iconContainer);
  
  const nameSpan = document.createElement('span');
  nameSpan.className = 'channel-name';
  nameSpan.textContent = channel.name;
  button.appendChild(nameSpan);
  
  const playIndicator = document.createElement('span');
  playIndicator.className = 'channel-play-indicator';
  playIndicator.textContent = '▶';
  button.appendChild(playIndicator);
  
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

// ===== Clean up and stop video player completely =====
function destroyPlayer() {
  if (art) {
    try {
      if (art.shaka) {
        art.shaka.destroy().catch(e => console.error('Error destroying Shaka:', e));
        art.shaka = null;
      }
      if (art.mpegtsPlayer) {
        art.mpegtsPlayer.destroy();
        art.mpegtsPlayer = null;
      }
      art.destroy(false); // Destroy Artplayer but keep the container
    } catch (e) {
      console.error('Error destroying player:', e);
    }
    art = null;
  }
}

// ===== Handle Playback Errors & Fallback =====
function handlePlaybackError(button, url, channelName, fallbackUrl) {
  // If the error does not match the channel URL currently being loaded, ignore it (stale/aborted loads)
  if (url !== lastSelectedChannelUrl && (!fallbackUrl || fallbackUrl !== lastSelectedChannelUrl)) {
    console.log(`[PLAYBACK] Ignoring error for stale channel: "${channelName}" (${url})`);
    return;
  }

  // ── Cooldown guard ────────────────────────────────────────────────────────
  // Prevent rapid-fire error cascades (e.g. from DOM mutations or back-to-back
  // Shaka retries) from hammering the server with repeated playback attempts.
  const now = Date.now();
  if (now - lastPlaybackErrorTime < 2000) {
    console.log(`[PLAYBACK] handlePlaybackError cooldown active — ignoring rapid repeat for "${channelName}".`);
    return;
  }
  lastPlaybackErrorTime = now;

  // If we are already handling the failure for this URL, ignore duplicate error triggers
  if (failingChannelUrl === url) {
    console.log(`[PLAYBACK] Error for "${channelName}" (${url}) already being handled. Ignoring duplicate.`);
    return;
  }
  failingChannelUrl = url;

  const channelId = button ? button.dataset.channelId : null;
  const match = findChannelByIdOrSlug(channelId);
  const channel = match ? match.channel : { url, name: channelName };
  const isDrm = (channel.url.endsWith('.mpd') || channel.url.includes('.mpd?') || !!channel.drm);

  if (isDrm) {
    console.error(`[DRM] Shaka error / playback failed for: ${channelName}`);
  } else {
    console.error(`[PLAYBACK] Playback failed for: ${channelName}`);
  }

  // If this failed request was for the primary URL, and there is a fallback URL, try the fallback URL first.
  if (fallbackUrl && fallbackUrl !== url && fallbackUrl !== '' && fallbackUrl !== 'null' && fallbackUrl !== 'undefined') {
    console.log(`[PLAYBACK] Primary failed. Trying fallback URL: ${fallbackUrl}`);
    showError(`Switching to fallback stream for ${channelName}...`);
    playChannel(button, fallbackUrl, channelName, null);
    return;
  }

  // If both primary and fallback failed, or if there is no fallback, try to auto-advance to the next channel in the category
  const activeCategoryDiv = channelGridContainer.querySelector(`.channel-category[data-category="${currentCategory}"]`);
  let nextButton = null;
  if (activeCategoryDiv && button) {
    const buttons = Array.from(activeCategoryDiv.querySelectorAll('.channel-btn'));
    const currentIndex = buttons.indexOf(button);
    if (currentIndex !== -1 && currentIndex + 1 < buttons.length) {
      nextButton = buttons[currentIndex + 1];
    }
  }

  if (nextButton && consecutiveFailuresCount < 5) {
    consecutiveFailuresCount++;
    const nextUrl = nextButton.dataset.url;
    const nextFallbackUrl = nextButton.dataset.fallbackUrl;
    const nextChannelName = nextButton.dataset.channelName;
    console.log(`[PLAYBACK] Channel "${channelName}" failed. Auto-advancing to next channel: "${nextChannelName}" (Consecutive failure count: ${consecutiveFailuresCount})`);
    showError(`Playback failed. Trying next channel: ${nextChannelName}...`);
    
    // Update history/active button immediately so the UI is responsive
    const nextChannelId = nextButton.dataset.channelId;
    const nextMatch = findChannelByIdOrSlug(nextChannelId);
    if (nextMatch) {
      const slug = getChannelSlug(nextMatch.channel);
      history.replaceState({ channelId: nextChannelId }, '', `/watch/${slug}`);
    }

    // Delay slightly to give user time to see the toast/message
    if (autoAdvanceTimeoutId) {
      clearTimeout(autoAdvanceTimeoutId);
    }
    autoAdvanceTimeoutId = setTimeout(() => {
      playChannel(nextButton, nextUrl, nextChannelName, nextFallbackUrl);
    }, 1500);
  } else {
    // If no more channels, or we hit the max consecutive failures limit
    consecutiveFailuresCount = 0; // Reset
    destroyPlayer();
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
      consecutiveFailuresCount = 0;
      // User explicitly clicked a channel — clear guards so the click always wins
      isPlayerInitializing = false;
      lastPlaybackErrorTime = 0;
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

// ===== TS & Shaka (HLS/DASH) Playback Helpers for ArtPlayer =====
function playShaka(video, url, artPlayer) {
  if (typeof shaka === 'undefined') {
    loadScript('https://cdnjs.cloudflare.com/ajax/libs/shaka-player/4.7.1/shaka-player.compiled.js')
      .then(() => {
        initializeShakaPlayer(video, url, artPlayer);
      })
      .catch(err => {
        console.error('Failed to load Shaka Player script:', err);
        showError('Your browser does not support Shaka Player streaming.');
        handlePlaybackError(lastSelectedChannelBtn, url, lastSelectedChannelName, null);
      });
  } else {
    initializeShakaPlayer(video, url, artPlayer);
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

function getOriginalUrlFromProxied(proxiedUrl) {
  try {
    const urlObj = new URL(proxiedUrl);
    const target = urlObj.searchParams.get('url');
    if (target) return target;
  } catch (e) {}
  return proxiedUrl;
}

function initializeShakaPlayer(video, url, artPlayer) {
  shaka.polyfill.installAll();
  
  if (!shaka.Player.isBrowserSupported()) {
    console.warn('Shaka Player is not natively supported in this browser. Trying native fallback...');
    if (video.canPlayType('application/vnd.apple.mpegurl') || url.endsWith('.m3u8') || url.includes('.m3u8?')) {
      video.src = url;
      console.log('Using native Safari HLS playback fallback');
    } else {
      console.error('Browser not supported for Shaka Player and no native HLS fallback available.');
      showError('Playback is not supported by your browser.');
    }
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
  console.log('[Shaka] Player initialized');

  // Limit network retry parameters to fail fast and prevent hammering the server/proxy
  const retryParams = {
    timeout: 10000,           // 10 seconds timeout
    stallTimeout: 5000,       // 5 seconds stall timeout
    connectionTimeout: 10000,  // 10 seconds connection timeout
    maxAttempts: 2,           // 1 initial request + 1 retry = 2 attempts total
    baseDelay: 1000,          // 1 second base delay
    backoffFactor: 2,         // backoff multiplier
    fuzzFactor: 0.1
  };

  player.configure({
    manifest: { retryParameters: retryParams },
    streaming: {
      retryParameters: retryParams,
      bufferingGoal: 30,         // Keep 30 seconds buffered ahead
      rebufferingGoal: 5,        // Start playing after 5 seconds buffered (faster startup)
      bufferBehind: 15          // Clean up older segments quickly to save memory
    },
    drm: { retryParameters: retryParams }
  });
  
  player.addEventListener('error', (event) => {
    console.error('[Shaka] Error', event.detail);
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
    }
  }

  // Set up network request filter to proxy all segment and relative manifest requests correctly
  let originalBaseUrl = '';
  try {
    const originalUrl = lastSelectedChannelUrl || getOriginalUrlFromProxied(url);
    originalBaseUrl = originalUrl.substring(0, originalUrl.lastIndexOf('/') + 1);
  } catch (e) {
    console.error('Failed to parse original URL for Shaka request filter:', e);
  }

  if (originalBaseUrl) {
    player.getNetworkingEngine().registerRequestFilter((type, request) => {
      const uri = request.uris[0];
      if (!uri) return;

      // Check if already proxied with the target url parameter
      let isAlreadyProxied = false;
      for (const p of PROXY_DOMAINS) {
        if (uri.startsWith(p) && (uri.includes('?url=') || uri.includes('&url='))) {
          isAlreadyProxied = true;
          break;
        }
      }

      if (!isAlreadyProxied) {
        let targetUrl = uri;
        
        // Check if it's a relative URL or points to a proxy domain but without the 'url' parameter
        let isProxiedWithoutUrl = false;
        let proxyPath = '';
        for (const p of PROXY_DOMAINS) {
          if (uri.startsWith(p)) {
            isProxiedWithoutUrl = true;
            proxyPath = uri.substring(p.length);
            break;
          }
        }

        if (isProxiedWithoutUrl) {
          try {
            targetUrl = new URL(proxyPath, originalBaseUrl).href;
          } catch (e) {
            console.error('Failed to resolve proxy path to absolute:', proxyPath, e);
          }
        } else if (uri.startsWith('/') || (!uri.startsWith('http://') && !uri.startsWith('https://'))) {
          try {
            targetUrl = new URL(uri, originalBaseUrl).href;
          } catch (e) {
            console.error('Failed to resolve relative path to absolute:', uri, e);
          }
        } else if (uri.startsWith('http://localhost') || uri.startsWith('http://127.0.0.1') || uri.startsWith(window.location.origin)) {
          try {
            const urlPath = new URL(uri).pathname;
            const pageDir = window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/') + 1);
            let cleanPath = urlPath;
            if (pageDir && urlPath.startsWith(pageDir)) {
              cleanPath = urlPath.substring(pageDir.length);
            } else if (urlPath.startsWith('/')) {
              cleanPath = urlPath.substring(1);
            }
            targetUrl = new URL(cleanPath, originalBaseUrl).href;
          } catch (e) {
            console.error('Failed to resolve localhost path to absolute:', uri, e);
          }
        }

        // Proxy the resolved target URL
        const newProxiedUrl = getProxiedUrl(targetUrl, channel);
        request.uris[0] = newProxiedUrl;
      }
    });
  }
  
  player.load(url).then(() => {
    console.log('[Shaka] Manifest loaded successfully');
    video.addEventListener('playing', () => {
      console.log('[Shaka] Playback started');
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
    console.error('[Shaka] Manifest load failed', error);
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
async function playChannel(button, url, channelName, fallbackUrl = null) {
  // ── Re-entrancy guard ────────────────────────────────────────────────────
  // Prevent a second playChannel call from starting while one is already
  // loading CDN scripts or constructing the Artplayer instance.
  if (isPlayerInitializing) {
    console.warn(`[PLAYBACK] playChannel("${channelName}") blocked — already initializing.`);
    return;
  }
  isPlayerInitializing = true;

  // Invalidate every error handler that was registered by a previous call.
  // Any video:error event that fires after this point for a *dead* player
  // instance will see a stale token and exit silently.
  const myToken = ++currentPlaybackToken;

  errorOverlay.classList.remove('active');

  if (autoAdvanceTimeoutId) {
    clearTimeout(autoAdvanceTimeoutId);
    autoAdvanceTimeoutId = null;
  }
  failingChannelUrl = null;
  
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
      ? `Watch ${channel.name} | GoPlay` 
      : `Watch ${channel.name} Live | GoPlay`;
    const seoTitle = channel.seo?.title || defaultSeoTitle;
    document.title = seoTitle;
  }

  // Classify strategy
  const strategy = getPlaybackStrategy(channel);

  // Log play mode
  const logPrefix = '[PLAYBACK]';
  if (strategy === 'direct') {
    console.log(`${logPrefix} Direct: ${channel.name}`);
  } else if (strategy === 'ts') {
    console.log(`${logPrefix} TS: ${channel.name}`);
  } else if (strategy === 'drm') {
    console.log(`${logPrefix} DRM: ${channel.name}`);
  }

  // Determine actual playback URL
  let playbackUrl = getProxiedUrl(url, channel);

  const isTs = (strategy === 'ts');
  const isMpd = (strategy === 'drm') || url.endsWith('.mpd') || url.includes('.mpd?') || (channel && !!channel.drm);

  try {
    // Destroy previous player inside try block safely using destroyPlayer helper
    destroyPlayer();

    // Show visual loading indicator while loading the player engine and dependencies
    const playerEl = document.getElementById('player');
    if (playerEl) {
      playerEl.innerHTML = `
        <div class="player-skeleton">
          <div class="skeleton-spinner"></div>
          <div class="skeleton-text">Loading Player Engines...</div>
        </div>
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
    } else {
      if (typeof shaka === 'undefined') {
        enginePromises.push(loadScript('https://cdnjs.cloudflare.com/ajax/libs/shaka-player/4.7.1/shaka-player.compiled.js'));
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
        m3u8: playShaka,
        mpd: playShaka,
        ts: playTs
      }
    });

    // 4. Hook lifecycle events for our overlays and error handling
    // Capture myToken in the closure so that if this player is later destroyed
    // and a NEW playChannel call runs (incrementing currentPlaybackToken),
    // any error events that arrive late from this dead instance are ignored.
    const capturedToken = myToken;
    art.on('video:error', (e) => {
      if (capturedToken !== currentPlaybackToken) {
        console.log('[PLAYBACK] Ignoring stale video:error from previous player instance.');
        return;
      }
      console.error('Artplayer video error:', e);
      handlePlaybackError(button, url, channelName, fallbackUrl);
    });

  } catch (error) {
    console.error('Failed to load player engine script or initialize player:', error);
    // Only handle if this call is still the active one
    if (myToken === currentPlaybackToken) {
      handlePlaybackError(button, url, channelName, fallbackUrl);
    }
  } finally {
    // Always release the lock so the next user-initiated playChannel can proceed
    isPlayerInitializing = false;
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
// ===== Initialize the app =====
const playerContainer = document.getElementById('player');
if (playerContainer && categoryTabsContainer && channelGridContainer) {
  loadChannelsData();
}

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
  if (!document.body.classList.contains('player-layout')) return;
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

