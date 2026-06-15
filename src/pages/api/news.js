function parseRSS(xmlText, sourceName) {
  const articles = [];
  const itemRegex = /<item>([\s\S]*?)<\/item>/g;
  let match;
  while ((match = itemRegex.exec(xmlText)) !== null) {
    const itemContent = match[1];
    
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

export async function GET() {
  const apikey = 'c5bf15e467bd15383b818fd266422399';
  const url = `https://gnews.io/api/v4/top-headlines?country=bd&category=sports&apikey=${apikey}`;

  // Try GNews API first
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`GNews API responded with status ${response.status}`);
    }

    const data = await response.json();
    const articles = (data.articles || []).map(article => ({
      title: article.title || '',
      url: article.url || '#',
      sourceName: article.source ? article.source.name : 'Sports News',
      publishedAt: article.publishedAt || ''
    }));

    return new Response(JSON.stringify({ articles }), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Cache-Control': 'public, max-age=900, stale-while-revalidate=1800'
      }
    });

  } catch (gnewsError) {
    console.warn(`GNews API failed (${gnewsError.message}). Attempting RSS fallbacks...`);

    // Try Daily Star Sports RSS
    try {
      const dsResponse = await fetch('https://www.thedailystar.net/sports/rss.xml', {
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        },
        signal: AbortSignal.timeout(5000)
      });
      
      if (!dsResponse.ok) {
        throw new Error(`Daily Star RSS responded with status ${dsResponse.status}`);
      }

      const xmlText = await dsResponse.text();
      const articles = parseRSS(xmlText, 'The Daily Star');
      
      if (articles.length > 0) {
        return new Response(JSON.stringify({ articles }), {
          status: 200,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Cache-Control': 'public, max-age=900, stale-while-revalidate=1800'
          }
        });
      }
      throw new Error('No articles found in Daily Star RSS');

    } catch (dsError) {
      console.warn(`Daily Star RSS failed (${dsError.message}). Attempting BBC Sport RSS...`);

      // Try BBC Sport RSS
      try {
        const bbcResponse = await fetch('https://feeds.bbci.co.uk/sport/rss.xml', {
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
          },
          signal: AbortSignal.timeout(5000)
        });

        if (!bbcResponse.ok) {
          throw new Error(`BBC RSS responded with status ${bbcResponse.status}`);
        }

        const xmlText = await bbcResponse.text();
        const articles = parseRSS(xmlText, 'BBC Sport');

        if (articles.length > 0) {
          return new Response(JSON.stringify({ articles }), {
            status: 200,
            headers: {
              'Content-Type': 'application/json',
              'Access-Control-Allow-Origin': '*',
              'Cache-Control': 'public, max-age=900, stale-while-revalidate=1800'
            }
          });
        }
        throw new Error('No articles found in BBC Sport RSS');

      } catch (bbcError) {
        console.error('All sports news sources failed. Using static fallback headlines. Error:', bbcError.message);

        // Fallback static sports headlines in case all live sources fail
        const fallbackArticles = [
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

        return new Response(JSON.stringify({ articles: fallbackArticles, error: bbcError.message }), {
          status: 200,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Cache-Control': 'no-cache'
          }
        });
      }
    }
  }
}
