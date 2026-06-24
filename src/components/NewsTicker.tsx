'use client';

import { useEffect, useState, useRef } from 'react';

interface NewsArticle {
  title: string;
  url: string;
  sourceName: string;
}

export default function NewsTicker() {
  const [articles, setArticles] = useState<NewsArticle[]>([]);
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    let cancelled = false;
    fetch('/api/news')
      .then((r) => r.json())
      .then((data) => {
        if (cancelled) return;
        const items: NewsArticle[] = data.articles || [];
        if (items.length > 0) {
          setArticles(items);
          setVisible(true);
        }
      })
      .catch(() => {});
    return () => { cancelled = true; };
  }, []);

  if (!visible || articles.length === 0) return null;

  const tickerItems = [...articles, ...articles]; // duplicate for infinite scroll

  return (
    <section className="news-ticker-section" id="newsTicker">
      <div className="news-ticker-container">
        <div className="news-ticker-label">
          <span className="news-ticker-label-text">NEWS</span>
        </div>
        <div className="news-ticker-content">
          <div className="news-ticker-track" id="newsTickerTrack">
            <div className="news-marquee-list" id="marqueeList1">
              {tickerItems.map((article, i) => (
                <a
                  key={i}
                  href={article.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="news-ticker-item"
                >
                  <span className="news-source">{article.sourceName}:</span>
                  <span className="news-title">{article.title}</span>
                  <span className="news-separator" aria-hidden="true">◆</span>
                </a>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
