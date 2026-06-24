import { Metadata } from 'next';
import { getChannelsData } from '@/services/channels';
import WatchDirectoryClient from './WatchDirectoryClient';

export const metadata: Metadata = {
  title: 'Live TV Channels Directory | Vibestream',
  description: 'Explore live TV channels across sports, news, entertainment, and more. Direct stream with Vibestream player.',
};

export default async function WatchDirectoryPage() {
  const channelsData = getChannelsData();

  return (
    <WatchDirectoryClient channelsData={channelsData} />
  );
}
