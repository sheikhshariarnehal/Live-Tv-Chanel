'use client';

import EventManager from '../../../components/EventManager';
import { useAuth } from '../../../providers/auth-provider';

export default function EventsPage() {
  const { adminToken, refreshStats } = useAuth();
  return <EventManager adminToken={adminToken} onRefreshStats={refreshStats} />;
}
