'use client';

import React from 'react';
import ChannelMonitor from '../../../components/ChannelMonitor';
import { useAuth } from '../../../providers/auth-provider';

export default function ChannelMonitorPage() {
  const { adminToken } = useAuth();
  return <ChannelMonitor adminToken={adminToken} />;
}
