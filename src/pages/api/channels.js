import localData from '../../../public/assets/data/channels.json';

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
      const id = idMatch ? idMatch[1].replace(/\s+/g, '-').toLowerCase() : 'pub-' + Math.random().toString(36).substring(2, 11);
      const group = groupMatch ? groupMatch[1].trim() : 'General';
      
      currentChannel = {
        id: id,
        name: channelName,
        logo: logo,
        group: group
      };
    } else if (line && !line.startsWith('#')) {
      if (currentChannel) {
        currentChannel.url = line;
        
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

// ===== Merge BDIX and Public Channels with Fallbacks =====
function mergeSources(local, publicData) {
  const merged = { categories: {} };

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

  function mapCategoryKey(key) {
    const k = key.toLowerCase().trim();
    if (k === 'movie' || k === 'movies') return 'movies';
    if (k === 'ent' || k === 'entertainment') return 'entertainment';
    if (k === 'info' || k === 'infotainment') return 'infotainment';
    if (categoryConfig[k]) return k;
    return 'other';
  }

  Object.keys(categoryConfig).forEach(key => {
    merged.categories[key] = {
      name: categoryConfig[key].name,
      channels: []
    };
  });

  const addedChannels = {};

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
        if (!existing.fallbackUrl && existing.url !== channel.url) {
          existing.fallbackUrl = existing.url;
        }
        existing.url = channel.url;
        if (channel.logo) {
          existing.logo = channel.logo;
        }
      } else {
        if (!existing.fallbackUrl && existing.url !== channel.url) {
          existing.fallbackUrl = channel.url;
        }
      }
    } else {
      const newChannel = {
        id: channel.id || `${normKey}-${Math.random().toString(36).substring(2, 11)}`,
        name: channel.name,
        url: channel.url,
        logo: channel.logo || '',
        fallbackUrl: channel.fallbackUrl || null
      };
      merged.categories[normKey].channels.push(newChannel);
      addedChannels[uniqueId] = newChannel;
    }
  }

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

  const finalCategories = {};
  Object.keys(merged.categories).forEach(key => {
    if (merged.categories[key].channels.length > 0) {
      finalCategories[key] = merged.categories[key];
    }
  });
  merged.categories = finalCategories;

  return merged;
}

export async function GET() {
  let publicData = null;

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
    console.error('Error loading public channels server-side:', error);
  }

  const merged = mergeSources(localData, publicData);

  return new Response(JSON.stringify(merged), {
    status: 200,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Cache-Control': 'public, max-age=3600, stale-while-revalidate=86400'
    }
  });
}
