'use client';

import React, { useState, useEffect } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import { useAuth } from '../providers/auth-provider';
import { 
  Users, Tv, Smartphone, Shield, Globe, Activity, 
  RefreshCw, Radio, HardDrive, AlertTriangle 
} from 'lucide-react';

interface UserPresenceRow {
  id: string;
  device_id: string;
  device_name: string;
  os_version: string;
  app_version: string;
  status: string;
  current_channel_id: string | null;
  current_channel_name: string | null;
  ip_address: string | null;
  country_code: string;
  last_active_at: string;
  created_at: string;
}

const countryNames: Record<string, string> = {
  BD: 'Bangladesh',
  US: 'United States',
  GB: 'United Kingdom',
  IN: 'India',
  PK: 'Pakistan',
  CA: 'Canada',
  AU: 'Australia',
  SG: 'Singapore',
  MY: 'Malaysia',
  SA: 'Saudi Arabia',
  AE: 'United Arab Emirates',
  ZA: 'South Africa',
  DE: 'Germany',
  FR: 'France',
  JP: 'Japan',
  UN: 'Unknown Location',
};

// Helper to convert 2-letter ISO code to Flag Emoji
function getFlagEmoji(countryCode: string): string {
  if (!countryCode || countryCode === 'UN' || countryCode === '🏳️') return '🏳️';
  try {
    const codePoints = countryCode
      .toUpperCase()
      .split('')
      .map((char) => 127397 + char.charCodeAt(0));
    return String.fromCodePoint(...codePoints);
  } catch (e) {
    return '🏳️';
  }
}

export default function UserAnalytics() {
  const { adminToken } = useAuth();
  const [users, setUsers] = useState<UserPresenceRow[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [realtimeStatus, setRealtimeStatus] = useState<'connecting' | 'connected' | 'error'>('connecting');
  const [nowTime, setNowTime] = useState(new Date());
  const [clockOffset, setClockOffset] = useState(0);

  // Sync clock offset with server on mount
  useEffect(() => {
    const syncClock = async () => {
      try {
        const start = Date.now();
        const res = await fetch('/', { method: 'HEAD' });
        const latency = (Date.now() - start) / 2;
        const serverDateHeader = res.headers.get('Date');
        if (serverDateHeader) {
          const serverTime = new Date(serverDateHeader).getTime() + latency;
          setClockOffset(serverTime - Date.now());
        }
      } catch (e) {
        console.error('Failed to sync clock offset:', e);
      }
    };
    syncClock();
  }, []);

  // Force component re-renders to update elapsed active times and check for timeouts
  useEffect(() => {
    const timer = setInterval(() => {
      setNowTime(new Date());
    }, 10000);
    return () => clearInterval(timer);
  }, []);

  // Fetch initial data & set up realtime subscriber
  useEffect(() => {
    if (!adminToken) return;

    const supabase = createAdminSupabaseClient(adminToken);
    let channel: any;

    const fetchPresenceData = async () => {
      setIsLoading(true);
      try {
        // Fetch all sessions (including offline ones, but sorted by last active)
        const { data, error } = await supabase
          .from('user_presence')
          .select('*')
          .order('last_active_at', { ascending: false });

        if (error) throw error;
        setUsers(data || []);
      } catch (err) {
        console.error('Error fetching user presence data:', err);
      } finally {
        setIsLoading(false);
      }
    };

    fetchPresenceData();

    // Listen to changes in public.user_presence in real-time
    channel = supabase
      .channel('schema-user-presence')
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'user_presence',
        },
        (payload: any) => {
          setUsers((prev) => {
            const updated = [...prev];
            const eventType = payload.eventType;
            const newRow = payload.new as UserPresenceRow;
            const oldRow = payload.old as { device_id?: string };

            if (eventType === 'INSERT') {
              // Prepend new row, removing duplicate device_id if exists
              return [newRow, ...updated.filter((u) => u.device_id !== newRow.device_id)];
            } else if (eventType === 'UPDATE') {
              // Replace row, maintaining order (or moving active to top)
              const index = updated.findIndex((u) => u.device_id === newRow.device_id);
              if (index > -1) {
                updated[index] = newRow;
                // Move updated user to top since they sent activity
                return [newRow, ...updated.filter((u) => u.device_id !== newRow.device_id)];
              } else {
                return [newRow, ...updated];
              }
            } else if (eventType === 'DELETE') {
              const id = payload.old.id;
              return updated.filter((u) => u.id !== id);
            }
            return prev;
          });
        }
      );

    channel.subscribe((status: string) => {
      if (status === 'SUBSCRIBED') {
        setRealtimeStatus('connected');
      } else if (status === 'CLOSED' || status === 'CHANNEL_ERROR') {
        setRealtimeStatus('error');
      } else {
        setRealtimeStatus('connecting');
      }
    });

    return () => {
      if (channel) {
        supabase.removeChannel(channel);
      }
    };
  }, [adminToken]);

  // Clean up database sessions that are extremely old
  const pruneStaleSessions = async () => {
    if (!adminToken) return;
    const supabase = createAdminSupabaseClient(adminToken);
    
    // Prune entries older than 24 hours
    const oneDayAgo = new Date();
    oneDayAgo.setDate(oneDayAgo.getDate() - 1);
    
    try {
      const { error } = await supabase
        .from('user_presence')
        .delete()
        .lt('last_active_at', oneDayAgo.toISOString());
      
      if (error) throw error;
      
      // Update local state as well
      setUsers(prev => prev.filter(u => new Date(u.last_active_at) >= oneDayAgo));
    } catch (e) {
      console.error('Failed to prune database sessions', e);
    }
  };

  // Determine if a session is "Active" right now (sent heartbeat in last 120 seconds and is not offline)
  const isSessionActive = (user: UserPresenceRow) => {
    if (user.status === 'offline') return false;
    const correctedNow = new Date(nowTime.getTime() + clockOffset);
    const diffMs = correctedNow.getTime() - new Date(user.last_active_at).getTime();
    return diffMs <= 120000; // 120 seconds heartbeat tolerance (more robust against network lag)
  };

  // Filter users active in last 120s
  const activeUsers = users.filter((u) => isSessionActive(u));
  
  // Browsing users (online but not watching)
  const browsingUsersCount = activeUsers.filter((u) => u.status !== 'watching').length;
  
  // Active viewers (watching a channel)
  const watchingUsers = activeUsers.filter((u) => u.status === 'watching');
  const watchingUsersCount = watchingUsers.length;

  // Unique devices in last 24 hours
  const uniqueDevicesToday = users.filter((u) => {
    const correctedNow = new Date(nowTime.getTime() + clockOffset);
    const diffMs = correctedNow.getTime() - new Date(u.last_active_at).getTime();
    return diffMs <= 86400000; // 24 hours
  }).length;

  // Breakdown of top channels currently being watched
  const topChannels = React.useMemo(() => {
    const counts: Record<string, { name: string; count: number }> = {};
    watchingUsers.forEach((u) => {
      if (u.current_channel_id && u.current_channel_name) {
        const id = u.current_channel_id;
        if (!counts[id]) {
          counts[id] = { name: u.current_channel_name, count: 0 };
        }
        counts[id].count++;
      }
    });

    return Object.entries(counts)
      .map(([id, data]) => ({ id, name: data.name, count: data.count }))
      .sort((a, b) => b.count - a.count);
  }, [watchingUsers]);

  // Geographical distribution of active users
  const activeCountries = React.useMemo(() => {
    const counts: Record<string, number> = {};
    activeUsers.forEach((u) => {
      const code = u.country_code || 'UN';
      counts[code] = (counts[code] || 0) + 1;
    });

    return Object.entries(counts)
      .map(([code, count]) => ({
        code,
        name: countryNames[code] || code,
        count,
      }))
      .sort((a, b) => b.count - a.count);
  }, [activeUsers]);

  // Format elapsed time string
  const getElapsedString = (isoString: string) => {
    const correctedNow = new Date(nowTime.getTime() + clockOffset);
    const diffSec = Math.floor((correctedNow.getTime() - new Date(isoString).getTime()) / 1000);
    if (diffSec < -5) return 'Just now'; // Handle minor negative offsets
    if (diffSec < 10) return 'Just now';
    if (diffSec < 60) return `${diffSec}s ago`;
    const diffMin = Math.floor(diffSec / 60);
    if (diffMin < 60) return `${diffMin}m ago`;
    const diffHrs = Math.floor(diffMin / 60);
    return `${diffHrs}h ago`;
  };

  return (
    <div className="space-y-6">
      {/* Header and status */}
      <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
        <div>
          <h1 className="text-3xl font-extrabold tracking-tight text-white flex items-center gap-2">
            Realtime <span className="gradient-text">User Monitoring</span>
          </h1>
          <p className="text-zinc-400 text-sm mt-1">
            Track active client devices, active channels, and location telemetry in real-time.
          </p>
        </div>
        
        {/* Realtime Indicators */}
        <div className="flex items-center gap-2">
          <button
            onClick={pruneStaleSessions}
            className="px-3.5 py-1.5 rounded-xl bg-zinc-900 hover:bg-zinc-800 border border-zinc-800 text-zinc-400 hover:text-white text-xs font-semibold flex items-center gap-1.5 transition-all"
            title="Remove sessions inactive for > 24 hours"
          >
            <HardDrive className="w-3.5 h-3.5 text-zinc-500" />
            Prune Old Sessions
          </button>
          
          <div className="px-3 py-1.5 rounded-xl bg-zinc-900 border border-zinc-800 flex items-center gap-2">
            {realtimeStatus === 'connected' && (
              <>
                <span className="relative flex h-2 w-2">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                  <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
                </span>
                <span className="text-[11px] font-mono text-emerald-400 font-bold uppercase tracking-wider">Live Sync</span>
              </>
            )}
            {realtimeStatus === 'connecting' && (
              <>
                <RefreshCw className="w-3 h-3 text-amber-400 animate-spin" />
                <span className="text-[11px] font-mono text-amber-400 font-bold uppercase tracking-wider">Connecting...</span>
              </>
            )}
            {realtimeStatus === 'error' && (
              <>
                <AlertTriangle className="w-3 h-3 text-red-500" />
                <span className="text-[11px] font-mono text-red-500 font-bold uppercase tracking-wider">Sync Error</span>
              </>
            )}
          </div>
        </div>
      </div>

      {/* Metrics Row */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Total Online */}
        <div className="p-5 rounded-2xl glass-panel relative overflow-hidden bg-zinc-900 border border-zinc-800">
          <div className="flex items-center justify-between mb-3">
            <div className="p-2.5 rounded-xl bg-blue-500/10 border border-blue-500/20 text-blue-400">
              <Users className="w-5 h-5" />
            </div>
            {activeUsers.length > 0 && (
              <span className="text-[10px] font-bold text-emerald-400 bg-emerald-500/10 px-2 py-0.5 rounded-full">
                ● Live
              </span>
            )}
          </div>
          <div className="space-y-1">
            <div className="text-3xl font-extrabold text-white tabular-nums">{activeUsers.length}</div>
            <span className="text-sm font-semibold text-zinc-200 block">Total Active Users</span>
            <p className="text-xs text-zinc-500">Connected in the last 60 seconds</p>
          </div>
        </div>

        {/* Streaming Count */}
        <div className="p-5 rounded-2xl glass-panel relative overflow-hidden bg-zinc-900 border border-zinc-800">
          <div className="flex items-center justify-between mb-3">
            <div className="p-2.5 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400">
              <Radio className="w-5 h-5" />
            </div>
            {watchingUsersCount > 0 && (
              <span className="text-[10px] font-bold text-red-400 bg-red-500/10 px-2 py-0.5 rounded-full animate-pulse">
                REC
              </span>
            )}
          </div>
          <div className="space-y-1">
            <div className="text-3xl font-extrabold text-white tabular-nums">{watchingUsersCount}</div>
            <span className="text-sm font-semibold text-zinc-200 block">Watching Streams</span>
            <p className="text-xs text-zinc-500">Currently playing a channel</p>
          </div>
        </div>

        {/* Browsing App */}
        <div className="p-5 rounded-2xl glass-panel relative overflow-hidden bg-zinc-900 border border-zinc-800">
          <div className="flex items-center justify-between mb-3">
            <div className="p-2.5 rounded-xl bg-violet-500/10 border border-violet-500/20 text-violet-400">
              <Activity className="w-5 h-5" />
            </div>
          </div>
          <div className="space-y-1">
            <div className="text-3xl font-extrabold text-white tabular-nums">{browsingUsersCount}</div>
            <span className="text-sm font-semibold text-zinc-200 block">Browsing App</span>
            <p className="text-xs text-zinc-500">Navigating home/menus</p>
          </div>
        </div>

        {/* Unique Devices (24h) */}
        <div className="p-5 rounded-2xl glass-panel relative overflow-hidden bg-zinc-900 border border-zinc-800">
          <div className="flex items-center justify-between mb-3">
            <div className="p-2.5 rounded-xl bg-amber-500/10 border border-amber-500/20 text-amber-400">
              <Smartphone className="w-5 h-5" />
            </div>
          </div>
          <div className="space-y-1">
            <div className="text-3xl font-extrabold text-white tabular-nums">{uniqueDevicesToday}</div>
            <span className="text-sm font-semibold text-zinc-200 block">Unique Devices (24h)</span>
            <p className="text-xs text-zinc-500">Active device instances today</p>
          </div>
        </div>
      </div>

      {/* Analytics Breakdown split layout */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Top Channels watched */}
        <div className="lg:col-span-2 p-6 rounded-2xl bg-zinc-900 border border-zinc-800/80 space-y-4">
          <h2 className="text-base font-bold text-white flex items-center gap-2">
            <Tv className="w-4 h-4 text-purple-400" />
            Top Channels Being Watched
          </h2>
          {topChannels.length === 0 ? (
            <div className="h-48 rounded-xl bg-zinc-950/40 border border-zinc-800/50 flex flex-col items-center justify-center text-zinc-500 text-xs">
              No active viewers streaming right now.
            </div>
          ) : (
            <div className="overflow-hidden rounded-xl border border-zinc-800 bg-zinc-950/40">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="border-b border-zinc-800 text-[10px] uppercase tracking-wider text-zinc-500 font-bold bg-zinc-950/80">
                    <th className="px-4 py-3">Channel Name</th>
                    <th className="px-4 py-3 text-right">Viewers</th>
                    <th className="px-4 py-3 text-right w-36">Viewer Share</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-zinc-800/50 text-sm text-zinc-300">
                  {topChannels.map((ch) => {
                    const pct = Math.round((ch.count / watchingUsersCount) * 100);
                    return (
                      <tr key={ch.id} className="hover:bg-zinc-900/40 transition-colors">
                        <td className="px-4 py-3.5 font-medium text-white flex items-center gap-2.5">
                          <div className="w-2 h-2 rounded-full bg-red-500 animate-pulse flex-shrink-0" />
                          {ch.name}
                        </td>
                        <td className="px-4 py-3.5 text-right font-semibold text-zinc-200 tabular-nums">
                          {ch.count} {ch.count === 1 ? 'user' : 'users'}
                        </td>
                        <td className="px-4 py-3.5">
                          <div className="flex items-center justify-end gap-2">
                            <div className="w-16 h-1.5 rounded-full bg-zinc-800 overflow-hidden hidden sm:block">
                              <div 
                                className="h-full bg-purple-500" 
                                style={{ width: `${pct}%` }}
                              />
                            </div>
                            <span className="text-xs font-semibold text-zinc-400 tabular-nums">{pct}%</span>
                          </div>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/* Location distribution */}
        <div className="p-6 rounded-2xl bg-zinc-900 border border-zinc-800/80 space-y-4">
          <h2 className="text-base font-bold text-white flex items-center gap-2">
            <Globe className="w-4 h-4 text-purple-400" />
            Geographic Coverage
          </h2>
          {activeCountries.length === 0 ? (
            <div className="h-48 rounded-xl bg-zinc-950/40 border border-zinc-800/50 flex flex-col items-center justify-center text-zinc-500 text-xs">
              No active users detected.
            </div>
          ) : (
            <div className="space-y-2">
              {activeCountries.map((c) => {
                const pct = Math.round((c.count / activeUsers.length) * 100);
                return (
                  <div key={c.code} className="p-3 rounded-xl bg-zinc-950/40 border border-zinc-800/50 flex items-center justify-between hover:border-zinc-700/60 transition-all">
                    <div className="flex items-center gap-2.5 min-w-0">
                      <span className="text-xl flex-shrink-0" role="img" aria-label={c.name}>
                        {getFlagEmoji(c.code)}
                      </span>
                      <div className="truncate">
                        <span className="text-xs font-semibold text-zinc-300 block">{c.name}</span>
                        <span className="text-[10px] text-zinc-500 font-mono">{c.code}</span>
                      </div>
                    </div>
                    <div className="text-right">
                      <span className="text-sm font-bold text-white tabular-nums block">{c.count}</span>
                      <span className="text-[9px] text-zinc-500 font-semibold tabular-nums">{pct}% of total</span>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>

      {/* Detailed Live Activity Grid */}
      <div className="p-6 rounded-2xl bg-zinc-900 border border-zinc-800/80 space-y-4">
        <h2 className="text-base font-bold text-white flex items-center gap-2">
          <Activity className="w-5 h-5 text-purple-400" />
          Live Activity Feed
        </h2>
        
        {isLoading ? (
          <div className="h-64 flex items-center justify-center">
            <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin"></div>
          </div>
        ) : users.length === 0 ? (
          <div className="h-64 rounded-xl bg-zinc-950/40 border border-zinc-800/50 flex flex-col items-center justify-center text-zinc-500 text-xs">
            No tracked devices found. Setup the Flutter client to send telemetry.
          </div>
        ) : (
          <div className="overflow-hidden rounded-xl border border-zinc-800 bg-zinc-950/40">
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse min-w-[800px]">
                <thead>
                  <tr className="border-b border-zinc-800 text-[10px] uppercase tracking-wider text-zinc-500 font-bold bg-zinc-950/80">
                    <th className="px-4 py-3">Device / Platform</th>
                    <th className="px-4 py-3">IP Address</th>
                    <th className="px-4 py-3">Location</th>
                    <th className="px-4 py-3">Current Activity</th>
                    <th className="px-4 py-3 text-right">Last Heartbeat</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-zinc-800/50 text-sm text-zinc-300">
                  {users.map((user) => {
                    const isOnline = isSessionActive(user);
                    
                    return (
                      <tr 
                        key={user.device_id} 
                        className={`hover:bg-zinc-900/40 transition-colors ${
                          !isOnline ? 'opacity-50 hover:opacity-100' : ''
                        }`}
                      >
                        {/* Device & OS */}
                        <td className="px-4 py-3.5">
                          <div className="flex items-center gap-3">
                            <div className={`p-2 rounded-lg ${
                              isOnline ? 'bg-purple-600/10 text-purple-400' : 'bg-zinc-800 text-zinc-500'
                            }`}>
                              <Smartphone className="w-4 h-4" />
                            </div>
                            <div className="leading-tight">
                              <span className="font-semibold text-white block truncate max-w-xs">{user.device_name}</span>
                              <span className="text-[10px] text-zinc-500 font-mono">
                                {user.os_version} • App v{user.app_version}
                              </span>
                            </div>
                          </div>
                        </td>

                        {/* IP Address */}
                        <td className="px-4 py-3.5 font-mono text-xs text-zinc-400">
                          {user.ip_address || '127.0.0.1'}
                        </td>

                        {/* Country */}
                        <td className="px-4 py-3.5">
                          <div className="flex items-center gap-2">
                            <span className="text-lg" role="img" aria-label={user.country_code}>
                              {getFlagEmoji(user.country_code)}
                            </span>
                            <span className="text-zinc-300">{countryNames[user.country_code] || user.country_code}</span>
                          </div>
                        </td>

                        {/* Status */}
                        <td className="px-4 py-3.5">
                          {isOnline ? (
                            user.status === 'watching' ? (
                              <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-semibold">
                                <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-ping"></span>
                                Streaming: {user.current_channel_name}
                              </div>
                            ) : (
                              <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold">
                                <span className="w-1.5 h-1.5 rounded-full bg-blue-500"></span>
                                Browsing App
                              </div>
                            )
                          ) : (
                            <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-zinc-800 border border-zinc-700 text-zinc-500 text-xs font-semibold">
                              Offline
                            </div>
                          )}
                        </td>

                        {/* Last Active */}
                        <td className="px-4 py-3.5 text-right font-mono text-xs text-zinc-400 tabular-nums">
                          {getElapsedString(user.last_active_at)}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
