'use client';

import { useAuth } from '../../../providers/auth-provider';
import DashboardOverview from '../../../components/DashboardOverview';

export default function OverviewPage() {
  const { stats } = useAuth();
  return <DashboardOverview stats={stats} />;
}
