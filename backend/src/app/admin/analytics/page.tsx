'use client';

import React from 'react';
import UserAnalytics from '../../../components/UserAnalytics';
import { useAuth } from '../../../providers/auth-provider';

export default function AnalyticsPage() {
  const { adminToken } = useAuth();
  return <UserAnalytics />;
}
