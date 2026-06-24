'use client';

import { useState, useEffect } from 'react';
import { Channel, ChannelsData } from '@/types';
import Header from '@/components/Header';
import NewsTicker from '@/components/NewsTicker';
import TVPlayer from '@/components/TVPlayer';
import Sidebar from '@/components/Sidebar';
import { useRouter } from 'next/navigation';

interface WatchPageClientProps {
  initialChannel: Channel;
  channelsData: ChannelsData;
  initialCategoryKey: string;
}

export default function WatchPageClient({
  initialChannel,
  channelsData,
  initialCategoryKey,
}: WatchPageClientProps) {
  const router = useRouter();
  const [activeChannel, setActiveChannel] = useState<Channel>(initialChannel);
  const [activeCategory, setActiveCategory] = useState<string>(initialCategoryKey);
  const [sidebarOpen, setSidebarOpen] = useState(false);

  // Sync active channel with URL changes (back/forward button navigation)
  useEffect(() => {
    setActiveChannel(initialChannel);
    setActiveCategory(initialCategoryKey);
  }, [initialChannel, initialCategoryKey]);

  // Lock body scroll when sidebar drawer is open on mobile
  useEffect(() => {
    if (sidebarOpen) {
      document.body.classList.add('sidebar-open');
    } else {
      document.body.classList.remove('sidebar-open');
    }
    return () => {
      document.body.classList.remove('sidebar-open');
    };
  }, [sidebarOpen]);

  const handleChannelSelect = (channel: Channel) => {
    setActiveChannel(channel);
    // Update route dynamically without full page reload
    window.history.pushState({ channelId: channel.id }, '', `/watch/${channel.slug}`);
    
    // Close sidebar drawer on mobile after channel click
    setSidebarOpen(false);
  };

  return (
    <div className="player-layout min-h-screen flex flex-col bg-[#0a0a0a] text-white">
      <Header
        showChannelListBtn={true}
        onOpenChannelList={() => setSidebarOpen(true)}
      />
      
      <NewsTicker />

      <main className="main-container flex-1">
        <div className="container">
          <TVPlayer channel={activeChannel} />
          
          <Sidebar
            categories={channelsData.categories}
            activeCategory={activeCategory}
            setActiveCategory={setActiveCategory}
            activeChannelId={activeChannel.id}
            onChannelSelect={handleChannelSelect}
            isOpen={sidebarOpen}
            onClose={() => setSidebarOpen(false)}
          />
        </div>
      </main>
    </div>
  );
}
