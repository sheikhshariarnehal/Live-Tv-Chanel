'use client';

import AnnouncementManager from '../../../components/AnnouncementManager';
import { useAuth } from '../../../providers/auth-provider';

export default function AnnouncementsPage() {
  const { adminToken, refreshStats } = useAuth();
  return <AnnouncementManager adminToken={adminToken} onRefreshStats={refreshStats} />;
}
