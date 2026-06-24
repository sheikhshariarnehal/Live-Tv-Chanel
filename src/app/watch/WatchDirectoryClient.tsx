'use client';

import { useState } from 'react';
import { ChannelsData } from '@/types';
import Header from '@/components/Header';
import NewsTicker from '@/components/NewsTicker';
import Link from 'next/link';

interface WatchDirectoryClientProps {
  channelsData: ChannelsData;
}

export default function WatchDirectoryClient({ channelsData }: WatchDirectoryClientProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [failedLogos, setFailedLogos] = useState<Record<string, boolean>>({});

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchQuery(e.target.value.toLowerCase().trim());
  };

  const categories = Object.entries(channelsData.categories);

  return (
    <div className="portal-layout min-h-screen flex flex-col bg-[#0a0a0a] text-white">
      <Header />
      <NewsTicker />

      <main className="main-container flex-1">
        <div className="portal-wrapper">
          <div className="portal-header">
            <h1 className="portal-title">Explore Live TV Channels</h1>
            <p className="portal-subtitle">
              Select any channel from sports, movies, news, and entertainment to start streaming instantly.
            </p>

            {/* Search Input */}
            <div className="search-container">
              <svg
                className="search-icon"
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
              >
                <circle cx="11" cy="11" r="8" />
                <line x1="21" y1="21" x2="16.65" y2="16.65" />
              </svg>
              <input
                type="text"
                id="channelSearch"
                placeholder="Search channels by name..."
                autoComplete="off"
                value={searchQuery}
                onChange={handleSearchChange}
              />
            </div>
          </div>

          {/* Category Sections */}
          <div className="portal-categories">
            {categories.map(([catKey, category]) => {
              const filteredChannels = (category.channels || []).filter(
                (c) =>
                  c.name.toLowerCase().includes(searchQuery) ||
                  c.id.toLowerCase().includes(searchQuery)
              );

              if (filteredChannels.length === 0) return null;

              return (
                <section
                  key={catKey}
                  className="portal-category-section"
                  data-category={catKey}
                >
                  <div className="category-header">
                    <h2 className="category-title">{category.name}</h2>
                    <span className="channel-count">
                      {filteredChannels.length}{' '}
                      {filteredChannels.length === 1 ? 'Channel' : 'Channels'}
                    </span>
                  </div>
                  
                  <div className="portal-channel-grid">
                    {filteredChannels.map((channel) => {
                      const proxyClass = channel.proxy ? 'border-proxy' : 'border-direct';
                      const logoUrl = channel.logo;
                      const hasLogo = logoUrl && !failedLogos[channel.id];

                      return (
                        <Link
                          key={channel.id}
                          href={`/watch/${channel.slug}`}
                          className={`portal-channel-card ${proxyClass}`}
                          data-id={channel.id}
                          data-name={channel.name}
                        >
                          <div className="card-logo-container">
                            {channel.resolution && (
                              <div className="btn-badge-container">
                                <span
                                  className={`btn-badge ${
                                    channel.resolution === '4K' ? 'res-4k' : 'res-hd'
                                  }`}
                                >
                                  {channel.resolution}
                                </span>
                              </div>
                            )}

                            {hasLogo ? (
                              // eslint-disable-next-line @next/next/no-img-element
                              <img
                                src={logoUrl}
                                alt={channel.name}
                                className="card-logo"
                                loading="lazy"
                                onError={() => {
                                  setFailedLogos((prev) => ({ ...prev, [channel.id]: true }));
                                }}
                              />
                            ) : (
                              <div className="card-fallback-name">{channel.name}</div>
                            )}

                            <div className="card-hover-overlay">
                              <div className="play-button">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                  <polygon points="5 3 19 12 5 21 5 3" />
                                </svg>
                              </div>
                            </div>
                          </div>
                          <div className="card-details">
                            <span className="card-name">{channel.name}</span>
                          </div>
                        </Link>
                      );
                    })}
                  </div>
                </section>
              );
            })}
          </div>
        </div>
      </main>
    </div>
  );
}
