// ===== DOM Elements =====
const video = document.getElementById('player');
const categoryTabsContainer = document.getElementById('categoryTabs');
const channelGridContainer = document.getElementById('channelGrid');
const sidebar = document.getElementById('sidebar');
const mobileMenuBtn = document.getElementById('mobileMenuBtn');
const closeSidebarBtn = document.getElementById('closeSidebarBtn');
const videoOverlay = document.getElementById('videoOverlay');

let hls;
let channelsData = null;
let currentCategory = 'bangla';

// ===== Load channels data from JSON =====
async function loadChannelsData() {
  try {
    const response = await fetch('./assets/data/channels.json');
    channelsData = await response.json();
    initializeUI();
  } catch (error) {
    console.error('Error loading channels data:', error);
    showError('Failed to load channels data');
  }
}

// ===== Initialize UI with tabs and channels =====
function initializeUI() {
  if (!channelsData) return;
  
  createCategoryTabs();
  createChannelCategories();
  setupEventListeners();
  autoPlayFirstChannel();
}

// ===== Create category tabs dynamically =====
function createCategoryTabs() {
  categoryTabsContainer.innerHTML = '';
  
  Object.keys(channelsData.categories).forEach((categoryKey, index) => {
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
  
  // Mobile menu toggle
  mobileMenuBtn.addEventListener('click', () => {
    // Only toggle on landscape tablets (641px - 768px)
    if (window.innerWidth > 640 && window.innerWidth <= 768) {
      sidebar.classList.add('active');
    }
  });
  
  closeSidebarBtn.addEventListener('click', () => {
    sidebar.classList.remove('active');
  });
  
  // Keyboard shortcuts
  document.addEventListener('keydown', handleKeyboard);
  
  // Close sidebar when clicking outside on mobile
  document.addEventListener('click', (e) => {
    if (window.innerWidth > 640 && window.innerWidth <= 768 && 
        sidebar.classList.contains('active') &&
        !sidebar.contains(e.target) && 
        !mobileMenuBtn.contains(e.target)) {
      sidebar.classList.remove('active');
    }
  });
}

// ===== Convert HTTP to HTTPS using CORS proxy (for mixed content issues) =====
function getProxiedUrl(url) {
  // If the page is loaded over HTTPS and the stream URL is HTTP, use a CORS proxy
  if (window.location.protocol === 'https:' && url.startsWith('http://')) {
    // Option 1: Use CORS Anywhere proxy (you may need to request temporary access)
    // return `https://cors-anywhere.herokuapp.com/${url}`;
    
    // Option 2: Use AllOrigins proxy
    // Note: This may not work for video streams, better for API calls
    // return `https://api.allorigins.win/raw?url=${encodeURIComponent(url)}`;
    
    // Option 3: Try direct HTTPS conversion (works if server supports HTTPS)
    const httpsUrl = url.replace('http://', 'https://');
    console.warn(`Converting HTTP to HTTPS: ${httpsUrl}`);
    console.warn('If stream fails, the server may not support HTTPS.');
    return httpsUrl;
  }
  return url;
}

// ===== Play channel =====
function playChannel(button, url, channelName) {
  // Show loading overlay
  videoOverlay.classList.add('active');
  
  // Remove active state from all channel buttons
  document.querySelectorAll('.channel-btn').forEach(btn => btn.classList.remove('active'));
  button.classList.add('active');
  
  // Convert URL if needed for HTTPS compatibility
  const processedUrl = getProxiedUrl(url);
  
  // Destroy existing HLS instance
  if (hls) {
    hls.destroy();
  }

  if (Hls.isSupported()) {
    hls = new Hls({
      enableWorker: true,
      lowLatencyMode: true,
      backBufferLength: 90,
      maxBufferLength: 30,
      maxMaxBufferLength: 600,
      maxBufferSize: 60 * 1000 * 1000,
      maxBufferHole: 0.5,
      xhrSetup: function(xhr, url) {
        // Add headers if needed for CORS
        xhr.withCredentials = false;
      }
    });
    
    hls.loadSource(processedUrl);
    hls.attachMedia(video);
    
    hls.on(Hls.Events.MANIFEST_PARSED, () => {
      video.play().then(() => {
        videoOverlay.classList.remove('active');
      }).catch(err => {
        console.log('Autoplay prevented:', err);
        videoOverlay.classList.remove('active');
      });
    });
    
    hls.on(Hls.Events.ERROR, (event, data) => {
      console.error('HLS error:', data);
      if (data.fatal) {
        videoOverlay.classList.remove('active');
        switch (data.type) {
          case Hls.ErrorTypes.NETWORK_ERROR:
            console.log('Network error, trying to recover...');
            hls.startLoad();
            break;
          case Hls.ErrorTypes.MEDIA_ERROR:
            console.log('Media error, trying to recover...');
            hls.recoverMediaError();
            break;
          default:
            showError(`Failed to load ${channelName}. Please try another channel.`);
            hls.destroy();
            break;
        }
      }
    });
  } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
    // Native HLS support (Safari)
    video.src = processedUrl;
    video.play().then(() => {
      videoOverlay.classList.remove('active');
    }).catch(err => {
      console.log('Autoplay prevented:', err);
      videoOverlay.classList.remove('active');
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

// ===== Show error message =====
function showError(message) {
  // Create error toast
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

// Add animation styles
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

// ===== Initialize the app =====
loadChannelsData();
