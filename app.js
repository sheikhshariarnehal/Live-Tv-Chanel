// Global variables
let channelsData = {};
let currentCategory = 'sports';
let currentChannel = null;
let hls = null;

// DOM Elements
const videoPlayer = document.getElementById('videoPlayer');
const channelGrid = document.getElementById('channelGrid');
const currentChannelName = document.getElementById('currentChannelName');
const loadingSpinner = document.getElementById('loadingSpinner');
const errorMessage = document.getElementById('errorMessage');
const categoryTabs = document.querySelectorAll('.tab-btn');

// Initialize the app
async function init() {
    try {
        // Load channels data
        const response = await fetch('channels.json');
        const data = await response.json();
        channelsData = data.categories;

        // Set up event listeners
        setupCategoryTabs();

        // Load initial category
        loadChannels(currentCategory);
    } catch (error) {
        console.error('Error loading channels:', error);
        showError('Failed to load channels data');
    }
}

// Setup category tab listeners
function setupCategoryTabs() {
    categoryTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const category = tab.dataset.category;
            
            // Update active tab
            categoryTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            
            // Load channels for selected category
            currentCategory = category;
            loadChannels(category);
        });
    });
}

// Load channels for a specific category
function loadChannels(category) {
    const categoryData = channelsData[category];
    
    if (!categoryData) {
        channelGrid.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: #9ca3af;">No channels available</p>';
        return;
    }

    channelGrid.innerHTML = '';

    categoryData.channels.forEach(channel => {
        const channelCard = createChannelCard(channel);
        channelGrid.appendChild(channelCard);
    });
}

// Create a channel card element
function createChannelCard(channel) {
    const card = document.createElement('div');
    card.className = 'channel-card';
    card.dataset.channelId = channel.id;

    // Create logo
    const logo = document.createElement('div');
    if (channel.logo && channel.logo !== '') {
        const img = document.createElement('img');
        img.src = channel.logo;
        img.alt = channel.name;
        img.className = 'channel-logo';
        img.onerror = function() {
            // If image fails to load, show placeholder
            this.parentElement.innerHTML = createPlaceholderLogo(channel.name);
        };
        logo.appendChild(img);
    } else {
        logo.innerHTML = createPlaceholderLogo(channel.name);
    }

    // Create name
    const name = document.createElement('div');
    name.className = 'channel-name';
    name.textContent = channel.name;

    card.appendChild(logo);
    card.appendChild(name);

    // Add click event
    card.addEventListener('click', () => {
        if (channel.url && channel.url !== '') {
            playChannel(channel);
            
            // Update active state
            document.querySelectorAll('.channel-card').forEach(c => c.classList.remove('active'));
            card.classList.add('active');
        } else {
            showError('Stream URL not available for this channel');
        }
    });

    return card;
}

// Create placeholder logo with initials
function createPlaceholderLogo(channelName) {
    const initials = channelName
        .split(' ')
        .map(word => word[0])
        .join('')
        .substring(0, 2)
        .toUpperCase();
    
    return `<div class="channel-logo placeholder">${initials}</div>`;
}

// Play a channel
function playChannel(channel) {
    currentChannel = channel;
    currentChannelName.textContent = channel.name;
    
    showLoading();
    hideError();

    // Clean up previous HLS instance
    if (hls) {
        hls.destroy();
        hls = null;
    }

    const videoUrl = channel.url;

    // Check if HLS is supported
    if (Hls.isSupported()) {
        hls = new Hls({
            enableWorker: true,
            lowLatencyMode: true,
            backBufferLength: 90
        });

        hls.loadSource(videoUrl);
        hls.attachMedia(videoPlayer);

        hls.on(Hls.Events.MANIFEST_PARSED, function() {
            hideLoading();
            videoPlayer.play().catch(error => {
                console.error('Playback error:', error);
                showError('Failed to start playback. Click play to try again.');
            });
        });

        hls.on(Hls.Events.ERROR, function(event, data) {
            console.error('HLS error:', data);
            
            if (data.fatal) {
                hideLoading();
                
                switch(data.type) {
                    case Hls.ErrorTypes.NETWORK_ERROR:
                        showError('Network error - unable to load stream');
                        // Try to recover
                        hls.startLoad();
                        break;
                    case Hls.ErrorTypes.MEDIA_ERROR:
                        showError('Media error - attempting to recover');
                        hls.recoverMediaError();
                        break;
                    default:
                        showError('Fatal error - unable to play stream');
                        hls.destroy();
                        break;
                }
            }
        });
    } 
    // Check if native HLS is supported (Safari)
    else if (videoPlayer.canPlayType('application/vnd.apple.mpegurl')) {
        videoPlayer.src = videoUrl;
        
        videoPlayer.addEventListener('loadedmetadata', function() {
            hideLoading();
            videoPlayer.play().catch(error => {
                console.error('Playback error:', error);
                showError('Failed to start playback');
            });
        });

        videoPlayer.addEventListener('error', function() {
            hideLoading();
            showError('Failed to load stream');
        });
    } else {
        hideLoading();
        showError('HLS streaming is not supported in this browser');
    }
}

// Show loading spinner
function showLoading() {
    loadingSpinner.classList.add('active');
}

// Hide loading spinner
function hideLoading() {
    loadingSpinner.classList.remove('active');
}

// Show error message
function showError(message) {
    errorMessage.querySelector('p').textContent = message;
    errorMessage.style.display = 'block';
    
    setTimeout(() => {
        hideError();
    }, 5000);
}

// Hide error message
function hideError() {
    errorMessage.style.display = 'none';
}

// Video player event listeners
videoPlayer.addEventListener('playing', () => {
    hideLoading();
});

videoPlayer.addEventListener('waiting', () => {
    showLoading();
});

videoPlayer.addEventListener('error', (e) => {
    hideLoading();
    console.error('Video error:', e);
});

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', init);

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
    if (hls) {
        hls.destroy();
    }
});
