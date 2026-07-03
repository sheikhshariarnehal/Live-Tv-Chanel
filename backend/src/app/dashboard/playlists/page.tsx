'use client';

import PlaylistManager from '../../../components/PlaylistManager';
import { useAuth } from '../../../providers/auth-provider';

export default function PlaylistsPage() {
  const { adminToken, refreshStats } = useAuth();
  return <PlaylistManager adminToken={adminToken} onRefreshStats={refreshStats} />;
}
