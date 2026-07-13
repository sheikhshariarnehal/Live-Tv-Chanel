'use client';

import React, { useState, useEffect, useMemo } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import { useAuth } from '../providers/auth-provider';
import { 
  Users, Tv, Smartphone, Shield, Globe, Activity, 
  RefreshCw, Radio, HardDrive, AlertTriangle, Search,
  Calendar, Laptop, ChevronDown, Check, BarChart2, LineChart
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
  CN: 'China',
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

  // Enhanced Analytics States
  const [chartType, setChartType] = useState<'line' | 'bar'>('line');
  const [timeframe, setTimeframe] = useState<'24h' | '7d' | '30d'>('7d');
  const [hoveredDayIndex, setHoveredDayIndex] = useState<number | null>(null);
  const [pruneHours, setPruneHours] = useState<number>(720); // 720 hours = 30 days default
  const [searchQuery, setSearchQuery] = useState('');
  const [statusTab, setStatusTab] = useState<'all' | 'active' | 'watching' | 'offline'>('all');
  const [geoSearchQuery, setGeoSearchQuery] = useState('');

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
            const oldRow = payload.old as { id?: string; device_id?: string };

            if (eventType === 'INSERT') {
              // Prepend new row, removing duplicate device_id if exists
              return [newRow, ...updated.filter((u) => u.device_id !== newRow.device_id)];
            } else if (eventType === 'UPDATE') {
              // Replace row, maintaining order (or moving active to top)
              const index = updated.findIndex((u) => u.device_id === newRow.device_id);
              if (index > -1) {
                updated[index] = newRow;
                return [newRow, ...updated.filter((u) => u.device_id !== newRow.device_id)];
              } else {
                return [newRow, ...updated];
              }
            } else if (eventType === 'DELETE') {
              const id = oldRow.id || payload.old.id;
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

  // Clean up database sessions that are stale based on user preference
  const pruneStaleSessions = async () => {
    if (!adminToken) return;
    const supabase = createAdminSupabaseClient(adminToken);
    
    const cutoffDate = new Date();
    cutoffDate.setHours(cutoffDate.getHours() - pruneHours);
    
    try {
      const { error } = await supabase
        .from('user_presence')
        .delete()
        .lt('last_active_at', cutoffDate.toISOString());
      
      if (error) throw error;
      
      // Update local state as well
      setUsers(prev => prev.filter(u => new Date(u.last_active_at) >= cutoffDate));
      alert(`Pruned sessions inactive for more than ${pruneHours} hours.`);
    } catch (e) {
      console.error('Failed to prune database sessions', e);
      alert('Error pruning sessions. Check logs.');
    }
  };

  // Determine if a session is "Active" right now (sent heartbeat in last 120 seconds and is not offline)
  const isSessionActive = (user: UserPresenceRow) => {
    if (user.status === 'offline') return false;
    const correctedNow = new Date(nowTime.getTime() + clockOffset);
    const diffMs = correctedNow.getTime() - new Date(user.last_active_at).getTime();
    return diffMs <= 120000; // 120 seconds heartbeat tolerance
  };

  // ─── Telemetry Summary Metrics ──────────────────────────────
  const totalRegisteredUsers = users.length;
  
  const activeUsers = users.filter((u) => isSessionActive(u));
  const activeUsersCount = activeUsers.length;
  const watchingUsersCount = activeUsers.filter((u) => u.status === 'watching').length;
  const browsingUsersCount = activeUsers.filter((u) => u.status !== 'watching').length;

  // Active User Metrics over Time
  const dauCount = useMemo(() => {
    const correctedNow = new Date(nowTime.getTime() + clockOffset);
    return users.filter((u) => {
      const diffMs = correctedNow.getTime() - new Date(u.last_active_at).getTime();
      return diffMs <= 86400000; // 24 hours
    }).length;
  }, [users, nowTime, clockOffset]);

  const wauCount = useMemo(() => {
    const correctedNow = new Date(nowTime.getTime() + clockOffset);
    return users.filter((u) => {
      const diffMs = correctedNow.getTime() - new Date(u.last_active_at).getTime();
      return diffMs <= 604800000; // 7 days
    }).length;
  }, [users, nowTime, clockOffset]);

  const mauCount = useMemo(() => {
    const correctedNow = new Date(nowTime.getTime() + clockOffset);
    return users.filter((u) => {
      const diffMs = correctedNow.getTime() - new Date(u.last_active_at).getTime();
      return diffMs <= 2592000000; // 30 days
    }).length;
  }, [users, nowTime, clockOffset]);

  // Breakdown of top channels currently being watched
  const topChannels = useMemo(() => {
    const counts: Record<string, { name: string; count: number }> = {};
    activeUsers.forEach((u) => {
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
  }, [activeUsers]);

  // Geographical distribution of active users
  const activeCountries = useMemo(() => {
    const counts: Record<string, number> = {};
    activeUsers.forEach((u) => {
      const code = u.country_code || 'UN';
      counts[code] = (counts[code] || 0) + 1;
    });

    const list = Object.entries(counts)
      .map(([code, count]) => ({
        code,
        name: countryNames[code] || code,
        count,
      }))
      .sort((a, b) => b.count - a.count);

    if (geoSearchQuery.trim() === '') return list;
    return list.filter(c => 
      c.name.toLowerCase().includes(geoSearchQuery.toLowerCase()) || 
      c.code.toLowerCase().includes(geoSearchQuery.toLowerCase())
    );
  }, [activeUsers, geoSearchQuery]);

  // Platform Distribution Stats
  const platformStats = useMemo(() => {
    let android = 0;
    let ios = 0;
    let web = 0;
    let other = 0;

    users.forEach(u => {
      const os = (u.os_version || '').toLowerCase();
      if (os.includes('android')) android++;
      else if (os.includes('ios') || os.includes('iphone') || os.includes('ipad')) ios++;
      else if (os.includes('web') || os.includes('chrome') || os.includes('safari') || os.includes('firefox')) web++;
      else other++;
    });

    const total = users.length || 1;
    return [
      { name: 'Android', count: android, pct: Math.round((android / total) * 100), color: 'bg-emerald-500', barColor: '#10b981' },
      { name: 'iOS', count: ios, pct: Math.round((ios / total) * 100), color: 'bg-sky-500', barColor: '#0ea5e9' },
      { name: 'Web Client', count: web, pct: Math.round((web / total) * 100), color: 'bg-purple-500', barColor: '#a855f7' },
      { name: 'Others', count: other, pct: Math.round((other / total) * 100), color: 'bg-zinc-500', barColor: '#71717a' },
    ];
  }, [users]);

  // App Version adoption stats
  const versionStats = useMemo(() => {
    const counts: Record<string, number> = {};
    users.forEach(u => {
      const ver = u.app_version || '1.0.0';
      counts[ver] = (counts[ver] || 0) + 1;
    });

    const total = users.length || 1;
    return Object.entries(counts)
      .map(([version, count]) => ({
        version,
        count,
        pct: Math.round((count / total) * 100),
      }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 5);
  }, [users]);

  // Recently Registered Devices
  const recentlyAddedUsers = useMemo(() => {
    return [...users]
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
      .slice(0, 4);
  }, [users]);

  // Helper to determine if we should draw the X-axis label based on timeframe length
  const shouldDrawLabel = (idx: number, totalPoints: number) => {
    if (totalPoints === 7) return true;
    if (totalPoints === 24) return idx % 4 === 0 || idx === 23;
    if (totalPoints === 30) return idx % 5 === 0 || idx === 29;
    return true;
  };

  // ─── Last Active Recency Graph Data by Timeframe ─────────────
  const chartData = useMemo(() => {
    const correctedNow = new Date(nowTime.getTime() + clockOffset);

    if (timeframe === '24h') {
      // 24 Hours View: Group by hour for the last 24 hours
      const data = Array.from({ length: 24 }, (_, i) => {
        const d = new Date(correctedNow.getTime());
        d.setHours(d.getHours() - (23 - i));
        const hour = d.getHours();
        const ampm = hour >= 12 ? 'PM' : 'AM';
        const displayHour = hour % 12 || 12;
        const label = `${displayHour}${ampm}`;
        const dateStr = d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });
        return { label, dateStr, count: 0 };
      });

      users.forEach((user) => {
        const userDate = new Date(user.last_active_at);
        const diffMs = correctedNow.getTime() - userDate.getTime();
        const diffHrs = Math.floor(diffMs / 3600000);
        if (diffHrs >= 0 && diffHrs < 24) {
          const binIndex = 23 - diffHrs;
          if (binIndex >= 0 && binIndex < 24) {
            data[binIndex].count++;
          }
        }
      });

      return data;
    } else if (timeframe === '30d') {
      // 30 Days View: Group by day for the last 30 days
      const data = Array.from({ length: 30 }, (_, i) => {
        const d = new Date(correctedNow.getTime());
        d.setDate(d.getDate() - (29 - i));
        const label = d.toLocaleDateString('en-US', { day: 'numeric' });
        const dateStr = d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
        return { label, dateStr, count: 0 };
      });

      users.forEach((user) => {
        const userDate = new Date(user.last_active_at);
        const midnightNow = new Date(correctedNow.getFullYear(), correctedNow.getMonth(), correctedNow.getDate());
        const midnightUser = new Date(userDate.getFullYear(), userDate.getMonth(), userDate.getDate());
        const diffMs = midnightNow.getTime() - midnightUser.getTime();
        const diffDays = Math.round(diffMs / 86400000);

        if (diffDays >= 0 && diffDays < 30) {
          const binIndex = 29 - diffDays;
          if (binIndex >= 0 && binIndex < 30) {
            data[binIndex].count++;
          }
        }
      });

      return data;
    } else {
      // Default: 7 Days View
      const data = Array.from({ length: 7 }, (_, i) => {
        const d = new Date(correctedNow.getTime());
        d.setDate(d.getDate() - (6 - i));
        const label = d.toLocaleDateString('en-US', { weekday: 'short' });
        const dateStr = d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
        return { label, dateStr, count: 0 };
      });

      users.forEach((user) => {
        const userDate = new Date(user.last_active_at);
        const midnightNow = new Date(correctedNow.getFullYear(), correctedNow.getMonth(), correctedNow.getDate());
        const midnightUser = new Date(userDate.getFullYear(), userDate.getMonth(), userDate.getDate());
        const diffMs = midnightNow.getTime() - midnightUser.getTime();
        const diffDays = Math.round(diffMs / 86400000);

        if (diffDays >= 0 && diffDays < 7) {
          const binIndex = 6 - diffDays;
          if (binIndex >= 0 && binIndex < 7) {
            data[binIndex].count++;
          }
        }
      });

      return data;
    }
  }, [users, timeframe, nowTime, clockOffset]);

  // SVG Chart Computations
  const chartHeight = 240;
  const chartWidth = 520;
  const chartPadding = 30;
  const maxChartVal = Math.max(...chartData.map(d => d.count), 5);

  const chartPoints = useMemo(() => {
    const N = chartData.length;
    return chartData.map((d, i) => {
      const x = chartPadding + (i * (chartWidth - 2 * chartPadding)) / (N - 1 || 1);
      const y = chartHeight - chartPadding - (d.count / maxChartVal) * (chartHeight - 2 * chartPadding);
      return { x, y, ...d };
    });
  }, [chartData, maxChartVal]);

  const linePath = useMemo(() => {
    if (chartPoints.length === 0) return '';
    return `M ${chartPoints[0].x} ${chartPoints[0].y} ` + 
      chartPoints.slice(1).map(p => `L ${p.x} ${p.y}`).join(' ');
  }, [chartPoints]);

  const areaPath = useMemo(() => {
    if (chartPoints.length === 0) return '';
    const bottomY = chartHeight - chartPadding;
    return `${linePath} L ${chartPoints[chartPoints.length - 1].x} ${bottomY} L ${chartPoints[0].x} ${bottomY} Z`;
  }, [chartPoints, linePath]);

  // Format elapsed time string
  const getElapsedString = (isoString: string) => {
    const correctedNow = new Date(nowTime.getTime() + clockOffset);
    const diffSec = Math.floor((correctedNow.getTime() - new Date(isoString).getTime()) / 1000);
    if (diffSec < 10) return 'Just now';
    if (diffSec < 60) return `${diffSec}s ago`;
    const diffMin = Math.floor(diffSec / 60);
    if (diffMin < 60) return `${diffMin}m ago`;
    const diffHrs = Math.floor(diffMin / 60);
    if (diffHrs < 24) return `${diffHrs}h ago`;
    const diffDays = Math.floor(diffHrs / 24);
    return `${diffDays}d ago`;
  };

  // ─── Filtered Users for Grid Feed ───────────────────────────
  const filteredUsers = useMemo(() => {
    return users.filter(user => {
      const matchesSearch = 
        (user.device_name || '').toLowerCase().includes(searchQuery.toLowerCase()) ||
        (user.os_version || '').toLowerCase().includes(searchQuery.toLowerCase()) ||
        (user.app_version || '').toLowerCase().includes(searchQuery.toLowerCase()) ||
        (user.ip_address || '').toLowerCase().includes(searchQuery.toLowerCase()) ||
        (user.country_code || '').toLowerCase().includes(searchQuery.toLowerCase()) ||
        (user.current_channel_name || '').toLowerCase().includes(searchQuery.toLowerCase());
      
      if (!matchesSearch) return false;

      const isActive = isSessionActive(user);
      if (statusTab === 'active') return isActive && user.status !== 'watching';
      if (statusTab === 'watching') return isActive && user.status === 'watching';
      if (statusTab === 'offline') return !isActive;
      return true; // 'all'
    });
  }, [users, searchQuery, statusTab, nowTime, clockOffset]);

  return (
    <div className="space-y-6">

      {/* Metrics Row */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Total Users Box */}
        <div className="p-5 rounded-2xl glass-panel relative overflow-hidden bg-zinc-900 border border-zinc-800">
          <div className="flex items-center justify-between mb-3">
            <div className="p-2.5 rounded-xl bg-purple-500/10 border border-purple-500/20 text-purple-400">
              <Laptop className="w-5 h-5" />
            </div>
            <span className="text-[10px] font-bold text-purple-400 bg-purple-500/10 px-2 py-0.5 rounded-full">
              Registered
            </span>
          </div>
          <div className="space-y-1">
            <div className="text-3xl font-extrabold text-white tabular-nums">{totalRegisteredUsers}</div>
            <span className="text-sm font-semibold text-zinc-200 block">Total User Instances</span>
            <p className="text-xs text-zinc-500">Total unique device fingerprints cached</p>
          </div>
        </div>

        {/* Daily Active (DAU) */}
        <div className="p-5 rounded-2xl glass-panel bg-zinc-900 border border-zinc-800">
          <div className="flex items-center justify-between mb-3">
            <div className="p-2.5 rounded-xl bg-blue-500/10 border border-blue-500/20 text-blue-400">
              <Users className="w-5 h-5" />
            </div>
            <span className="text-[10px] font-bold text-blue-400 bg-blue-500/10 px-2 py-0.5 rounded-full">
              {totalRegisteredUsers ? Math.round((dauCount / totalRegisteredUsers) * 100) : 0}% of Total
            </span>
          </div>
          <div className="space-y-1">
            <div className="text-3xl font-extrabold text-white tabular-nums">{dauCount}</div>
            <span className="text-sm font-semibold text-zinc-200 block">Daily Active (DAU)</span>
            <p className="text-xs text-zinc-500">Devices active in the last 24 hours</p>
          </div>
        </div>

        {/* Weekly Active (WAU) */}
        <div className="p-5 rounded-2xl glass-panel bg-zinc-900 border border-zinc-800">
          <div className="flex items-center justify-between mb-3">
            <div className="p-2.5 rounded-xl bg-indigo-500/10 border border-indigo-500/20 text-indigo-400">
              <Calendar className="w-5 h-5" />
            </div>
            <span className="text-[10px] font-bold text-indigo-400 bg-indigo-500/10 px-2 py-0.5 rounded-full">
              {totalRegisteredUsers ? Math.round((wauCount / totalRegisteredUsers) * 100) : 0}% of Total
            </span>
          </div>
          <div className="space-y-1">
            <div className="text-3xl font-extrabold text-white tabular-nums">{wauCount}</div>
            <span className="text-sm font-semibold text-zinc-200 block">Weekly Active (WAU)</span>
            <p className="text-xs text-zinc-500">Devices active in the last 7 days</p>
          </div>
        </div>

        {/* Monthly Active (MAU) */}
        <div className="p-5 rounded-2xl glass-panel bg-zinc-900 border border-zinc-800">
          <div className="flex items-center justify-between mb-3">
            <div className="p-2.5 rounded-xl bg-sky-500/10 border border-sky-500/20 text-sky-400">
              <Activity className="w-5 h-5" />
            </div>
            <span className="text-[10px] font-bold text-sky-400 bg-sky-500/10 px-2 py-0.5 rounded-full">
              {totalRegisteredUsers ? Math.round((mauCount / totalRegisteredUsers) * 100) : 0}% of Total
            </span>
          </div>
          <div className="space-y-1">
            <div className="text-3xl font-extrabold text-white tabular-nums">{mauCount}</div>
            <span className="text-sm font-semibold text-zinc-200 block">Monthly Active (MAU)</span>
            <p className="text-xs text-zinc-500">Devices active in the last 30 days</p>
          </div>
        </div>
      </div>

      {/* Main Content Layout - Row 1: Graph and Live Viewer Share */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 min-w-0 items-stretch">
        
        {/* Left Column - Custom Interactive SVG Graph Card */}
        <div className="lg:col-span-2 min-w-0">
          <div className="p-6 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4 h-full flex flex-col justify-between">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div>
                <h2 className="text-base font-bold text-white flex items-center gap-2">
                  <Activity className="w-5 h-5 text-purple-400" />
                  User Last-Seen Recency
                </h2>
                <p className="text-[11px] text-zinc-500">Number of active devices grouped by timeframe recency.</p>
              </div>
              
              <div className="flex flex-wrap items-center gap-2">
                {/* Timeframe Select Dropdown */}
                <div className="flex items-center bg-zinc-950 px-2.5 py-1.5 rounded-xl border border-zinc-800 text-[11px] font-semibold text-zinc-400">
                  <span className="text-zinc-500 mr-1.5 select-none">Range:</span>
                  <select
                    value={timeframe}
                    onChange={(e) => {
                      setTimeframe(e.target.value as any);
                      setHoveredDayIndex(null);
                    }}
                    className="bg-transparent text-white border-0 py-0.5 pl-0 pr-6 text-[11px] font-bold focus:ring-0 focus:outline-none cursor-pointer"
                  >
                    <option value="24h" className="bg-zinc-900 text-white">24 Hours</option>
                    <option value="7d" className="bg-zinc-900 text-white">7 Days</option>
                    <option value="30d" className="bg-zinc-900 text-white">30 Days</option>
                  </select>
                </div>

                {/* Chart Toggle */}
                <div className="flex items-center bg-zinc-950 p-1 rounded-xl border border-zinc-800">
                  <button
                    onClick={() => setChartType('line')}
                    className={`px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition-all ${
                      chartType === 'line' 
                        ? 'bg-zinc-800 text-white border border-zinc-700' 
                        : 'text-zinc-500 hover:text-zinc-300'
                    }`}
                  >
                    <LineChart className="w-3.5 h-3.5" />
                    Line
                  </button>
                  <button
                    onClick={() => setChartType('bar')}
                    className={`px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition-all ${
                      chartType === 'bar' 
                        ? 'bg-zinc-800 text-white border border-zinc-700' 
                        : 'text-zinc-500 hover:text-zinc-300'
                    }`}
                  >
                    <BarChart2 className="w-3.5 h-3.5" />
                    Bar
                  </button>
                </div>
              </div>
            </div>

            {/* Graph Visualization Frame */}
            <div className="relative bg-zinc-950/40 rounded-xl border border-zinc-800/80 flex items-center justify-center p-4">
              {totalRegisteredUsers === 0 ? (
                <span className="text-xs text-zinc-500 py-12">No data available for active metrics.</span>
              ) : (
                <div className="relative w-full aspect-[520/240]">
                  <svg 
                    viewBox={`0 0 ${chartWidth} ${chartHeight}`} 
                    className="w-full h-full overflow-visible"
                  >
                    <defs>
                      <linearGradient id="lineGrad" x1="0" y1="0" x2="1" y2="0">
                        <stop offset="0%" stopColor="#8b5cf6" />
                        <stop offset="100%" stopColor="#ec4899" />
                      </linearGradient>
                      <linearGradient id="areaGrad" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stopColor="#8b5cf6" stopOpacity="0.08" />
                        <stop offset="100%" stopColor="#8b5cf6" stopOpacity="0.0" />
                      </linearGradient>
                    </defs>

                    {/* Y-Axis Labels */}
                    <text x={8} y={chartPadding + 3} fill="#3f3f46" fontSize="8" fontWeight="600" className="font-mono select-none">
                      {maxChartVal}
                    </text>
                    <text x={8} y={chartHeight / 2 + 3} fill="#27272a" fontSize="8" fontWeight="600" className="font-mono select-none">
                      {Math.round(maxChartVal / 2)}
                    </text>
                    <text x={8} y={chartHeight - chartPadding + 3} fill="#27272a" fontSize="8" fontWeight="600" className="font-mono select-none">
                      0
                    </text>

                    {/* Horizontal gridlines */}
                    {[0, 0.5, 1].map((ratio, idx) => {
                      const y = chartPadding + ratio * (chartHeight - 2 * chartPadding);
                      return (
                        <line
                          key={idx}
                          x1={chartPadding}
                          y1={y}
                          x2={chartWidth - chartPadding}
                          y2={y}
                          stroke="#1f1f22"
                          strokeWidth="1"
                          strokeDasharray="3 3"
                        />
                      );
                    })}

                    {/* Hover Guide Line */}
                    {hoveredDayIndex !== null && (
                      <line
                        x1={chartPoints[hoveredDayIndex].x}
                        y1={chartPadding}
                        x2={chartPoints[hoveredDayIndex].x}
                        y2={chartHeight - chartPadding}
                        stroke="#8b5cf6"
                        strokeWidth="1"
                        strokeDasharray="2 2"
                        opacity="0.3"
                      />
                    )}

                    {/* Render Line Chart */}
                    {chartType === 'line' && (
                      <>
                        <path 
                          d={areaPath} 
                          fill="url(#areaGrad)" 
                        />
                        <path 
                          d={linePath} 
                          fill="none" 
                          stroke="url(#lineGrad)" 
                          strokeWidth="2" 
                          strokeLinecap="round"
                        />
                        {/* Glowing point only on active hover */}
                        {hoveredDayIndex !== null && (
                          <g>
                            <circle
                              cx={chartPoints[hoveredDayIndex].x}
                              cy={chartPoints[hoveredDayIndex].y}
                              r="8"
                              fill="#ec4899"
                              opacity="0.3"
                              className="animate-pulse"
                            />
                            <circle
                              cx={chartPoints[hoveredDayIndex].x}
                              cy={chartPoints[hoveredDayIndex].y}
                              r="4"
                              fill="#ec4899"
                              stroke="#09090b"
                              strokeWidth="2"
                            />
                          </g>
                        )}
                      </>
                    )}

                    {/* Render Bar Chart */}
                    {chartType === 'bar' && (
                      chartPoints.map((p, i) => {
                        const barWidth = 16;
                        const barHeight = chartHeight - chartPadding - p.y;
                        return (
                          <g key={i}>
                            <rect
                              x={p.x - barWidth / 2}
                              y={p.y}
                              width={barWidth}
                              height={Math.max(barHeight, 3)}
                              rx="3"
                              fill={hoveredDayIndex === i ? 'url(#lineGrad)' : '#1f1f22'}
                              stroke={hoveredDayIndex === i ? 'none' : '#27272a'}
                              strokeWidth="0.5"
                              className="transition-all duration-200 hover:fill-[url(#lineGrad)]"
                            />
                          </g>
                        );
                      })
                    )}

                    {/* Hover Hotspots for Grid Area */}
                    {chartPoints.map((p, i) => {
                      const colWidth = (chartWidth - 2 * chartPadding) / (chartPoints.length - 1 || 1);
                      return (
                        <rect
                          key={i}
                          x={p.x - colWidth / 2}
                          y={0}
                          width={colWidth}
                          height={chartHeight}
                          fill="transparent"
                          className="cursor-pointer"
                          onMouseEnter={() => setHoveredDayIndex(i)}
                          onMouseLeave={() => setHoveredDayIndex(null)}
                        />
                      );
                    })}

                    {/* X-Axis labels */}
                    {chartPoints.map((p, i) => {
                      if (!shouldDrawLabel(i, chartPoints.length)) return null;
                      return (
                        <text
                          key={i}
                          x={p.x}
                          y={chartHeight - 8}
                          textAnchor="middle"
                          fill={hoveredDayIndex === i ? '#a855f7' : '#52525b'}
                          fontSize="9"
                          fontWeight="600"
                          className="font-mono transition-colors duration-150 select-none"
                        >
                          {p.label}
                        </text>
                      );
                    })}
                  </svg>
                  
                  {/* Absolute HTML Tooltip overlay */}
                  {hoveredDayIndex !== null && (
                    <div 
                      className="absolute p-2.5 rounded-xl border border-zinc-850 bg-zinc-950 text-[11px] font-semibold text-white pointer-events-none shadow-2xl backdrop-blur-md z-30 transition-all duration-100 ease-out"
                      style={{
                        left: `${(chartPoints[hoveredDayIndex].x / chartWidth) * 100}%`,
                        top: `${(chartPoints[hoveredDayIndex].y / chartHeight) * 100 - 8}%`,
                        transform: hoveredDayIndex === 0 
                          ? 'translate(-10%, -100%)' 
                          : hoveredDayIndex === chartPoints.length - 1 
                            ? 'translate(-90%, -100%)' 
                            : 'translate(-50%, -100%)',
                      }}
                    >
                      <div className="text-zinc-500 font-bold uppercase tracking-wider text-[9px] mb-0.5">
                        {chartPoints[hoveredDayIndex].dateStr}
                      </div>
                      <div className="flex items-center gap-1.5">
                        <span className="w-1.5 h-1.5 rounded-full bg-purple-500"></span>
                        <span>{chartPoints[hoveredDayIndex].count} active devices</span>
                      </div>
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Right Column - Top Channels being watched (Live Viewer Share) */}
        <div className="lg:col-span-1 min-w-0">
          <div className="p-6 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4 h-full flex flex-col">
            <h2 className="text-sm font-bold text-white flex items-center gap-2">
              <Tv className="w-4 h-4 text-purple-400" />
              Live Viewer Share
            </h2>
            {topChannels.length === 0 ? (
              <div className="flex-1 flex flex-col items-center justify-center text-zinc-600 text-xs border border-dashed border-zinc-850 rounded-xl py-12">
                No active viewers streaming.
              </div>
            ) : (
              <div className="flex-1 overflow-y-auto space-y-2.5 pr-1 scrollbar-thin max-h-[220px]">
                {topChannels.map((ch) => {
                  const pct = Math.round((ch.count / watchingUsersCount) * 100);
                  return (
                    <div key={ch.id} className="space-y-1">
                      <div className="flex items-center justify-between text-xs">
                        <span className="font-medium text-white truncate max-w-[160px] flex items-center gap-2">
                          <span className="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse" />
                          {ch.name}
                        </span>
                        <span className="font-semibold text-zinc-400 tabular-nums">
                          {ch.count} {ch.count === 1 ? 'user' : 'users'} <span className="text-[10px] text-zinc-600 font-mono font-bold">({pct}%)</span>
                        </span>
                      </div>
                      <div className="h-1.5 rounded-full bg-zinc-950 overflow-hidden border border-zinc-900">
                        <div 
                          className="h-full bg-purple-500 rounded-full" 
                          style={{ width: `${pct}%` }}
                        />
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>

      </div>

      {/* Main Content Layout - Row 2: Platforms, Versions, and Geo Coverage */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 min-w-0 items-stretch">
        
        {/* Left Column - Platforms and Versions Grid */}
        <div className="lg:col-span-2 min-w-0">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 h-full">
            
            {/* Recently Added Users */}
            <div className="p-6 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4 h-full flex flex-col justify-between">
              <h3 className="text-sm font-bold text-white flex items-center gap-2">
                <Users className="w-4 h-4 text-purple-400" />
                Recently Added Users
              </h3>
              {recentlyAddedUsers.length === 0 ? (
                <div className="h-44 flex items-center justify-center text-xs text-zinc-650">
                  No users registered.
                </div>
              ) : (
                <div className="space-y-2.5 flex-1 flex flex-col justify-center">
                  {recentlyAddedUsers.map((user) => (
                    <div key={user.device_id} className="p-2.5 rounded-xl bg-zinc-950/40 border border-zinc-850 hover:border-zinc-700/60 transition-all flex items-center justify-between">
                      <div className="flex items-center gap-2.5 min-w-0">
                        <div className="p-1.5 rounded-lg bg-purple-600/10 text-purple-400 flex-shrink-0">
                          <Smartphone className="w-3.5 h-3.5" />
                        </div>
                        <div className="truncate leading-tight">
                          <span className="text-xs font-semibold text-zinc-200 block truncate max-w-[130px] md:max-w-[160px]">
                            {user.device_name}
                          </span>
                          <span className="text-[9px] text-zinc-500 font-mono">
                            {getFlagEmoji(user.country_code)} • {user.os_version.split(' ')[0] || 'Unknown'}
                          </span>
                        </div>
                      </div>
                      <span className="text-[10px] text-zinc-500 font-mono font-bold whitespace-nowrap ml-2">
                        {getElapsedString(user.created_at)}
                      </span>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* App Versions */}
            <div className="p-6 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4 h-full flex flex-col justify-between">
              <h3 className="text-sm font-bold text-white flex items-center gap-2">
                <Shield className="w-4 h-4 text-purple-400" />
                App Version Adoption
              </h3>
              {versionStats.length === 0 ? (
                <div className="h-44 flex items-center justify-center text-xs text-zinc-600">
                  No versions detected.
                </div>
              ) : (
                <div className="space-y-3.5">
                  {versionStats.map((ver) => (
                    <div key={ver.version} className="space-y-1.5">
                      <div className="flex items-center justify-between text-xs">
                        <span className="font-semibold text-zinc-300">Build v{ver.version}</span>
                        <span className="font-mono text-zinc-400 font-bold">{ver.count} instances ({ver.pct}%)</span>
                      </div>
                      <div className="h-1.5 rounded-full bg-zinc-950 overflow-hidden border border-zinc-900">
                        <div 
                          className="h-full bg-indigo-500 rounded-full transition-all duration-500" 
                          style={{ width: `${ver.pct}%` }}
                        />
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

          </div>
        </div>

        {/* Right Column - Geographic Coverage */}
        <div className="lg:col-span-1 min-w-0">
          <div className="p-6 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4 flex flex-col h-full">
            <div className="flex items-center justify-between">
              <h2 className="text-sm font-bold text-white flex items-center gap-2">
                <Globe className="w-4 h-4 text-purple-400" />
                Geographic Coverage
              </h2>
              <span className="text-[10px] font-mono text-zinc-500 font-bold uppercase">
                {activeCountries.length} countries
              </span>
            </div>
            
            {/* Geo Search input */}
            <div className="relative">
              <Search className="absolute left-2.5 top-2 w-3.5 h-3.5 text-zinc-500" />
              <input
                type="text"
                placeholder="Filter locations..."
                value={geoSearchQuery}
                onChange={(e) => setGeoSearchQuery(e.target.value)}
                className="w-full bg-zinc-950 border border-zinc-850 rounded-lg py-1.5 pl-8 pr-3 text-[11px] text-zinc-200 placeholder-zinc-600 focus:outline-none focus:border-purple-500 transition"
              />
            </div>

            {activeCountries.length === 0 ? (
              <div className="flex-1 flex flex-col items-center justify-center text-zinc-650 text-xs py-8">
                No locations match.
              </div>
            ) : (
              <div className="flex-1 overflow-y-auto pr-1 space-y-2 scrollbar-thin max-h-[180px]">
                {activeCountries.map((c) => {
                  const pct = activeUsersCount ? Math.round((c.count / activeUsersCount) * 100) : 0;
                  return (
                    <div key={c.code} className="p-2.5 rounded-xl bg-zinc-950/45 border border-zinc-850 flex items-center justify-between hover:border-zinc-700/60 transition-all">
                      <div className="flex items-center gap-2 min-w-0">
                        <span className="text-base flex-shrink-0" role="img" aria-label={c.name}>
                          {getFlagEmoji(c.code)}
                        </span>
                        <div className="truncate">
                          <span className="text-xs font-semibold text-zinc-300 block leading-tight">{c.name}</span>
                          <span className="text-[9px] text-zinc-500 font-mono font-bold uppercase">{c.code}</span>
                        </div>
                      </div>
                      <div className="text-right">
                        <span className="text-xs font-bold text-white tabular-nums block">{c.count}</span>
                        <span className="text-[8px] text-zinc-500 font-semibold tabular-nums">{pct}% of live</span>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Detailed Live Activity Grid */}
      <div className="p-6 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4 min-w-0">
        
        {/* Table Controls */}
        <div className="flex flex-col md:flex-row justify-between md:items-center gap-4">
          <div>
            <h2 className="text-base font-bold text-white flex items-center gap-2">
              <Activity className="w-5 h-5 text-purple-400" />
              Live Activity Feed
            </h2>
            <p className="text-[11px] text-zinc-500">Real-time table log of registered devices and client heartbeat telemetry.</p>
          </div>

          <div className="flex flex-wrap items-center gap-3">
            {/* Search Input */}
            <div className="relative w-full sm:w-60">
              <Search className="absolute left-3 top-2.5 w-4 h-4 text-zinc-500" />
              <input
                type="text"
                placeholder="Search device, OS, IP, version..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full bg-zinc-950 border border-zinc-800 rounded-xl py-2 pl-9 pr-4 text-xs text-zinc-200 placeholder-zinc-600 focus:outline-none focus:border-purple-500 transition"
              />
            </div>

            {/* Filter Tabs */}
            <div className="flex flex-wrap bg-zinc-950 p-1 rounded-xl border border-zinc-800 text-[11px] font-bold w-full sm:w-auto justify-center">
              {[
                { id: 'all', label: 'All' },
                { id: 'active', label: 'Online' },
                { id: 'watching', label: 'Streaming' },
                { id: 'offline', label: 'Offline' }
              ].map(tab => (
                <button
                  key={tab.id}
                  onClick={() => setStatusTab(tab.id as any)}
                  className={`px-3 py-1.5 rounded-lg transition-all ${
                    statusTab === tab.id 
                      ? 'bg-zinc-900 text-white border border-zinc-800/80 shadow-md' 
                      : 'text-zinc-500 hover:text-zinc-350'
                  }`}
                >
                  {tab.label}
                </button>
              ))}
            </div>
          </div>
        </div>
        
        {isLoading ? (
          <div className="h-64 flex items-center justify-center">
            <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin"></div>
          </div>
        ) : filteredUsers.length === 0 ? (
          <div className="h-48 rounded-xl bg-zinc-950/40 border border-zinc-850 flex flex-col items-center justify-center text-zinc-600 text-xs">
            No matching devices found in this filter range.
          </div>
        ) : (
          <div className="overflow-hidden rounded-xl border border-zinc-800 bg-zinc-950/40">
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse min-w-[800px]">
                <thead>
                  <tr className="border-b border-zinc-800 text-[10px] uppercase tracking-wider text-zinc-500 font-bold bg-zinc-950/80">
                    <th className="px-4 py-3">Device / Platform</th>
                    <th className="px-4 py-3">App Version</th>
                    <th className="px-4 py-3">IP Address</th>
                    <th className="px-4 py-3">Location</th>
                    <th className="px-4 py-3">Current Activity</th>
                    <th className="px-4 py-3 text-right">Last Heartbeat</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-zinc-800/50 text-sm text-zinc-300">
                  {filteredUsers.map((user) => {
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
                                {user.os_version}
                              </span>
                            </div>
                          </div>
                        </td>

                        {/* App Version */}
                        <td className="px-4 py-3.5">
                          <span className="inline-flex items-center px-2.5 py-0.5 rounded-md text-[10px] font-bold bg-zinc-950 border border-zinc-850 text-indigo-400 font-mono">
                            v{user.app_version}
                          </span>
                        </td>

                        {/* IP Address */}
                        <td className="px-4 py-3.5 font-mono text-xs text-zinc-400">
                          {user.ip_address || '127.0.0.1'}
                        </td>

                        {/* Country */}
                        <td className="px-4 py-3.5">
                          <div className="flex items-center gap-2">
                            <span className="text-base" role="img" aria-label={user.country_code}>
                              {getFlagEmoji(user.country_code)}
                            </span>
                            <span className="text-zinc-350">{countryNames[user.country_code] || user.country_code}</span>
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

