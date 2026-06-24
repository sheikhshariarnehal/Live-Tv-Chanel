'use client';

import { useRef, useEffect, useState } from 'react';
import { Channel } from '@/types';
import Image from 'next/image';

interface SidebarProps {
  categories: Record<string, { name: string; channels: Channel[] }>;
  activeCategory: string;
  setActiveCategory: (cat: string) => void;
  activeChannelId?: string;
  onChannelSelect: (channel: Channel) => void;
  isOpen: boolean;
  onClose: () => void;
}

export default function Sidebar({
  categories,
  activeCategory,
  setActiveCategory,
  activeChannelId,
  onChannelSelect,
  isOpen,
  onClose,
}: SidebarProps) {
  const tabsRef = useRef<HTMLDivElement>(null);
  
  // Track failed logos to display text fallback
  const [failedLogos, setFailedLogos] = useState<Record<string, boolean>>({});

  // Horizontal scroll handler for category tabs via mouse wheel
  const handleWheel = (e: React.WheelEvent) => {
    if (tabsRef.current) {
      tabsRef.current.scrollLeft += e.deltaY;
    }
  };

  // Close on ESC key
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    if (isOpen) {
      window.addEventListener('keydown', handleKeyDown);
    }
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, onClose]);

  const activeChannels = categories[activeCategory]?.channels || [];

  return (
    <div className={`sidebar ${isOpen ? 'active' : ''}`} id="sidebar">
      {/* Close button for mobile layout */}
      <button className="btn-close" id="closeSidebarBtn" onClick={onClose} aria-label="Close channels list">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M18 6L6 18M6 6l12 12" />
        </svg>
      </button>

      {/* Category Tabs */}
      <div
        className="category-tabs"
        id="categoryTabs"
        ref={tabsRef}
        onWheel={handleWheel}
      >
        {Object.entries(categories).map(([key, category]) => {
          if (!category.channels || category.channels.length === 0) return null;
          return (
            <button
              key={key}
              className={`tab-btn ${activeCategory === key ? 'active' : ''}`}
              onClick={() => setActiveCategory(key)}
            >
              {category.name}
            </button>
          );
        })}
      </div>

      {/* Channel Grid */}
      <div className="channel-grid" id="channelGrid">
        <div className="channel-category" data-category={activeCategory}>
          {activeChannels.map((channel) => {
            const isActive = channel.id === activeChannelId;
            const logoFailed = failedLogos[channel.id];
            const logoUrl = channel.logo;

            return (
              <button
                key={channel.id}
                className={`channel-btn ${channel.proxy ? 'border-proxy' : 'border-direct'} ${
                  isActive ? 'active' : ''
                }`}
                onClick={() => onChannelSelect(channel)}
                title={channel.name}
              >
                {/* Resolution Badge */}
                {channel.resolution && (
                  <div className="btn-badge-container">
                    <span className={`btn-badge ${channel.resolution === '4K' ? 'res-4k' : 'res-hd'}`}>
                      {channel.resolution}
                    </span>
                  </div>
                )}

                {/* Channel Logo or Fallback Name */}
                {logoUrl && !logoFailed ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={logoUrl}
                    alt={channel.name}
                    className="channel-logo"
                    onError={() => {
                      setFailedLogos((prev) => ({ ...prev, [channel.id]: true }));
                    }}
                  />
                ) : (
                  <span className="channel-name">{channel.name}</span>
                )}
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
