export async function GET() {
  const apikey = 'c5bf15e467bd15383b818fd266422399';
  const url = `https://gnews.io/api/v4/top-headlines?country=bd&category=sports&apikey=${apikey}`;

  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`GNews API responded with status ${response.status}`);
    }

    const data = await response.json();
    
    // Filter and sanitize articles to minimize payload size
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
        // Cache: 15 minutes, stale-while-revalidate: 30 minutes
        'Cache-Control': 'public, max-age=900, stale-while-revalidate=1800'
      }
    });

  } catch (error) {
    console.error('Error fetching sports news server-side:', error);
    
    // Fallback static sports headlines in case the GNews API limit is reached or fails
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

    return new Response(JSON.stringify({ articles: fallbackArticles, error: error.message }), {
      status: 200, // Still return 200 to load fallback smoothly in the client
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Cache-Control': 'no-cache'
      }
    });
  }
}
