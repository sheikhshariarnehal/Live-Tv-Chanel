function parseRSS(xmlText, sourceName, filterSports = false) {
  const articles = [];
  const itemRegex = /<item>([\s\S]*?)<\/item>/g;
  const sportsKeywords = ['খেলা', 'ফুটবল', 'ক্রিকেট', 'খেলাধুলা', 'ক্রীড়া', 'sports', 'cricket', 'football'];
  let match;
  while ((match = itemRegex.exec(xmlText)) !== null) {
    const itemContent = match[1];
    
    // If filterSports is enabled, check if categories match sports keywords
    if (filterSports) {
      const categories = [];
      const catRegex = /<category>(?:<!\[CDATA\[)?([\s\S]*?)(?:\]\]>)?<\/category>/g;
      let catMatch;
      while ((catMatch = catRegex.exec(itemContent)) !== null) {
        categories.push(catMatch[1].trim());
      }
      
      const isSports = categories.some(cat => 
        sportsKeywords.some(keyword => cat.toLowerCase().includes(keyword.toLowerCase()))
      );
      
      if (!isSports) continue;
    }
    
    let title = '';
    const titleMatch = itemContent.match(/<title><!\[CDATA\[([\s\S]*?)\]\]><\/title>/) || 
                       itemContent.match(/<title>([\s\S]*?)<\/title>/);
    if (titleMatch) {
      title = titleMatch[1].trim();
      title = title.replace(/<[^>]*>/g, '').trim();
    }
    
    let url = '#';
    const linkMatch = itemContent.match(/<link><!\[CDATA\[([\s\S]*?)\]\]><\/link>/) || 
                     itemContent.match(/<link>([\s\S]*?)<\/link>/);
    if (linkMatch) {
      url = linkMatch[1].trim();
      if (url.startsWith('/')) {
        if (sourceName === 'The Daily Star') {
          url = 'https://www.thedailystar.net' + url;
        }
      }
    }
    
    let publishedAt = '';
    const pubDateMatch = itemContent.match(/<pubDate>([\s\S]*?)<\/pubDate>/);
    if (pubDateMatch) {
      publishedAt = pubDateMatch[1].trim();
    } else {
      publishedAt = new Date().toISOString();
    }
    
    if (title) {
      articles.push({
        title,
        url,
        sourceName,
        publishedAt
      });
    }
  }
  return articles;
}

let newsCache = null;
let newsCacheExpiresAt = 0;
const NEWS_CACHE_TTL = 10 * 60 * 1000; // Cache news for 10 minutes on the server

async function fetchArticles() {
  const apikey = 'c5bf15e467bd15383b818fd266422399';
  const url = `https://gnews.io/api/v4/top-headlines?country=bd&category=sports&apikey=${apikey}`;

  // 1. Try Prothom Alo Sports RSS first (for Bangla news)
  try {
    const paResponse = await fetch('https://www.prothomalo.com/feed/', {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
      },
      signal: AbortSignal.timeout(4000)
    });

    if (paResponse.ok) {
      const xmlText = await paResponse.text();
      const articles = parseRSS(xmlText, 'প্রথম আলো খেলা', true);
      if (articles.length > 0) return articles;
    }
  } catch (paError) {
    console.warn(`Prothom Alo RSS failed (${paError.message}). Attempting GNews API...`);
  }

  // 2. Try GNews API next
  try {
    const response = await fetch(url, { signal: AbortSignal.timeout(4000) });
    if (response.ok) {
      const data = await response.json();
      const articles = (data.articles || []).map(article => ({
        title: article.title || '',
        url: article.url || '#',
        sourceName: article.source ? article.source.name : 'Sports News',
        publishedAt: article.publishedAt || ''
      }));
      if (articles.length > 0) return articles;
    }
  } catch (gnewsError) {
    console.warn(`GNews API failed (${gnewsError.message}). Attempting English RSS fallbacks...`);
  }

  // 3. Try Daily Star Sports RSS (English fallback)
  try {
    const dsResponse = await fetch('https://www.thedailystar.net/sports/rss.xml', {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
      },
      signal: AbortSignal.timeout(4000)
    });
    
    if (dsResponse.ok) {
      const xmlText = await dsResponse.text();
      const articles = parseRSS(xmlText, 'The Daily Star');
      if (articles.length > 0) return articles;
    }
  } catch (dsError) {
    console.warn(`Daily Star RSS failed (${dsError.message}). Attempting BBC Sport RSS...`);
  }

  // 4. Try BBC Sport RSS (English fallback)
  try {
    const bbcResponse = await fetch('https://feeds.bbci.co.uk/sport/rss.xml', {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
      },
      signal: AbortSignal.timeout(4000)
    });

    if (bbcResponse.ok) {
      const xmlText = await bbcResponse.text();
      const articles = parseRSS(xmlText, 'BBC Sport');
      if (articles.length > 0) return articles;
    }
  } catch (bbcError) {
    console.error('All sports news sources failed. Using static fallback headlines. Error:', bbcError.message);
  }

  // Fallback static sports headlines in case all live sources fail
  return [
    {
      title: 'শরিফুলের ৬ উইকেটের পরও হোয়াইটওয়াশ থেকে বাঁচল অজিরা',
      url: '#',
      sourceName: 'Vibestream Sports',
      publishedAt: new Date().toISOString()
    },
    {
      title: 'জয় দিয়ে বিশ্বকাপ শুরু বাঘিনীদের',
      url: '#',
      sourceName: 'Vibestream Sports',
      publishedAt: new Date().toISOString()
    },
    {
      title: 'নাটকীয়ভাবে ম্যাচে ফিরেও অস্ট্রেলিয়াকে ধবলধোলাই করা হলো না বাংলাদেশের',
      url: '#',
      sourceName: 'Vibestream Sports',
      publishedAt: new Date().toISOString()
    }
  ];
}

export async function GET() {
  const now = Date.now();
  if (newsCache && now < newsCacheExpiresAt) {
    return new Response(JSON.stringify({ articles: newsCache }), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Cache-Control': 'public, max-age=900, stale-while-revalidate=1800',
        'X-News-Cache': 'HIT'
      }
    });
  }

  const articles = await fetchArticles();

  // Cache fetched articles (even fallbacks, to protect the server from consecutive load failures)
  newsCache = articles;
  newsCacheExpiresAt = Date.now() + NEWS_CACHE_TTL;

  return new Response(JSON.stringify({ articles }), {
    status: 200,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Cache-Control': 'public, max-age=900, stale-while-revalidate=1800',
      'X-News-Cache': 'MISS'
    }
  });
}
