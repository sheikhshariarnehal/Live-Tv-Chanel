const video = document.getElementById('player');
const categoryTabsContainer = document.getElementById('categoryTabs');
const channelGridContainer = document.getElementById('channelGrid');
let hls;
let channelsData = null;
let currentCategory = 'bangla';

// Load channels data from JSON
async function loadChannelsData() {
  try {
    const response = await fetch('assets/data/channels.json');
    channelsData = await response.json();
    initializeUI();
  } catch (error) {
    console.error('Error loading channels data:', error);
    alert('❌ Failed to load channels data.');
  }
}

// Initialize UI with tabs and channels
function initializeUI() {
  if (!channelsData) return;
  
  // Create category tabs
  createCategoryTabs();
  
  // Create channel categories
  createChannelCategories();
  
  // Setup event listeners
  setupEventListeners();
  
  // Auto play first available channel
  autoPlayFirstChannel();
}

// Create category tabs dynamically
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

// Create channel categories and buttons dynamically
function createChannelCategories() {
  channelGridContainer.innerHTML = '';
  
  Object.keys(channelsData.categories).forEach((categoryKey, index) => {
    const category = channelsData.categories[categoryKey];
    const categoryDiv = document.createElement('div');
    categoryDiv.className = `channel-category ${index !== 0 ? 'hidden' : ''}`;
    categoryDiv.dataset.category = categoryKey;
    
    // Create channel buttons
    category.channels.forEach(channel => {
      const channelBtn = createChannelButton(channel);
      categoryDiv.appendChild(channelBtn);
    });
    
    channelGridContainer.appendChild(categoryDiv);
  });
}

// Create individual channel button
function createChannelButton(channel) {
  const button = document.createElement('button');
  button.className = 'channel-btn';
  button.dataset.url = channel.url;
  button.dataset.channelId = channel.id;
  button.title = channel.name;
  
  if (channel.logo) {
    // Channel has a logo
    const img = document.createElement('img');
    img.src = channel.logo;
    img.alt = channel.name;
    img.className = 'channel-logo';
    img.onerror = function() {
      // If logo fails to load, show channel name
      this.remove();
      const span = document.createElement('span');
      span.className = 'channel-name';
      span.textContent = channel.name;
      button.appendChild(span);
    };
    button.appendChild(img);
  } else {
    // No logo, show channel name
    const span = document.createElement('span');
    span.className = 'channel-name';
    span.textContent = channel.name;
    button.appendChild(span);
  }
  
  return button;
}

// Setup event listeners
function setupEventListeners() {
  // Category tab switching
  const tabButtons = document.querySelectorAll('.tab-btn');
  tabButtons.forEach(tab => {
    tab.addEventListener('click', () => {
      const category = tab.dataset.category;
      currentCategory = category;
      
      // Update active tab
      tabButtons.forEach(btn => btn.classList.remove('active'));
      tab.classList.add('active');
      
      // Show selected category channels
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
      const channelName = this.title;
      
      if (url && url !== '') {
        playChannel(this, url, channelName);
      } else {
        alert(`📺 ${channelName} coming soon!`);
      }
    });
  });
}

// Play channel
function playChannel(button, url, channelName) {
  // Remove active state from all channel buttons
  document.querySelectorAll('.channel-btn').forEach(btn => btn.classList.remove('active'));
  button.classList.add('active');

  if (hls) {
    hls.destroy();
  }

  if (Hls.isSupported()) {
    hls = new Hls({
      enableWorker: true,
      lowLatencyMode: true,
      backBufferLength: 90
    });
    hls.loadSource(url);
    hls.attachMedia(video);
    hls.on(Hls.Events.MANIFEST_PARSED, () => {
      video.play().catch(err => {
        console.log('Autoplay prevented:', err);
      });
    });
    hls.on(Hls.Events.ERROR, (event, data) => {
      console.error('HLS error:', data);
      if (data.fatal) {
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
            alert(`⚠️ Failed to load ${channelName}. Please try another channel.`);
            hls.destroy();
            break;
        }
      }
    });
  } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
    video.src = url;
    video.play().catch(err => {
      console.log('Autoplay prevented:', err);
    });
  } else {
    alert('❌ Your browser does not support HLS streaming.');
  }
}

// Auto play the first available channel on page load
function autoPlayFirstChannel() {
  setTimeout(() => {
    const firstChannel = document.querySelector('.channel-btn[data-url]:not([data-url=""])');
    if (firstChannel) {
      firstChannel.click();
    }
  }, 500);
}

// Keyboard shortcuts
document.addEventListener('keydown', (e) => {
  if (e.code === 'Space' && e.target === document.body) {
    e.preventDefault();
    if (video.paused) {
      video.play();
    } else {
      video.pause();
    }
  }
});

// Initialize the app
loadChannelsData();
