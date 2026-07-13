'use client';

import TrendingChannelManager from '../../../components/TrendingChannelManager';
import { useAuth } from '../../../providers/auth-provider';

export default function TrendingPage() {
  const { adminToken, refreshStats } = useAuth();
  return <TrendingChannelManager adminToken={adminToken} onRefreshStats={refreshStats} />;
}
