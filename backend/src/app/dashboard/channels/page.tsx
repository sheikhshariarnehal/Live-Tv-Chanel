'use client';

import ChannelManager from '../../../components/ChannelManager';
import { useAuth } from '../../../providers/auth-provider';

export default function ChannelsPage() {
  const { adminToken, refreshStats } = useAuth();
  return <ChannelManager adminToken={adminToken} onRefreshStats={refreshStats} />;
}
