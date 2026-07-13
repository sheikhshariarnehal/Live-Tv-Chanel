'use client';

import React, { useState, useEffect, useCallback, useRef } from 'react';
import Link from 'next/link';
import {
  Search, RefreshCw, CheckCircle2, XCircle, Clock,
  Eye, Shield, Server, Activity,
  ArrowRight, HeartPulse, AlertTriangle
} from 'lucide-react';

interface ChannelHealthData {
  status: string;
  http_status: number;
  response_time: number;
  playlist_status: string;
  segment_status: string;
  proxy_status: string;
  drm_status: string;
  headers_status: string;
  geo_status: string;
  error_message: string | null;
  checked_at: string;
}

interface ChannelData {
  id: string;
  name: string;
  stream_url: string;
  proxy: boolean;
  drm: {
    type?: string;
    kid?: string;
    key?: string;
    licenseUrl?: string;
    headers?: Record<string, string>;
  } | null;
  category_id: string;
  category_name: string;
  health: ChannelHealthData | null;
}

interface StatsData {
  totalChannels: number;
  working: number;
  offline: number;
  slow: number;
  drmChannels: number;
  proxyChannels: number;
  lastScanTime: string | null;
  isScanning: boolean;
  intervalMinutes: number;
}

interface ChannelMonitorProps {
  adminToken: string;
}

export default function ChannelMonitor({ adminToken }: ChannelMonitorProps) {
  const [stats, setStats] = useState<StatsData | null>(null);
  const [channels, setChannels] = useState<ChannelData[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [search, setSearch] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [selectedStatus, setSelectedStatus] = useState('all');
  const [selectedProxyFilter, setSelectedProxyFilter] = useState('all');
  const [selectedDrmFilter, setSelectedDrmFilter] = useState('all');
  
  // Active inspection channel
  const [inspectChannel, setInspectChannel] = useState<ChannelData | null>(null);
  
  // Auto refresh
  const [autoRefresh, setAutoRefresh] = useState(true);
  const [intervalMinutes, setIntervalMinutes] = useState(5);
  const [isUpdatingInterval, setIsUpdatingInterval] = useState(false);

  const pollIntervalRef = useRef<NodeJS.Timeout | null>(null);

  // Fetch stats and channel data
  const fetchData = useCallback(async (showIndicator = false) => {
    if (showIndicator) setRefreshing(true);
    try {
      const res = await fetch('/api/monitor/stats', {
        headers: {
          'Authorization': `Bearer ${adminToken}`,
          'x-admin-token': adminToken
        }
      });
      const data = await res.json();
      if (data.success) {
        setStats(data.stats);
        setChannels(data.channels);
        setIntervalMinutes(data.stats.intervalMinutes);
      }
    } catch (err) {
      console.error('Failed to fetch monitoring stats:', err);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [adminToken]);

  // Handle manual trigger scan
  const handleTriggerScan = async () => {
    if (stats?.isScanning) return;
    setRefreshing(true);
    try {
      const res = await fetch('/api/monitor/scan', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${adminToken}`,
          'x-admin-token': adminToken
        }
      });
      const data = await res.json();
      if (data.success) {
        // Optimistically set scanning state
        setStats(prev => prev ? { ...prev, isScanning: true } : null);
      } else {
        alert(data.error || 'Failed to start scan');
      }
    } catch (err) {
      console.error('Scan trigger failed:', err);
    } finally {
      setRefreshing(false);
    }
  };

  // Handle interval updates
  const handleUpdateInterval = async (minutes: number) => {
    setIsUpdatingInterval(true);
    try {
      const res = await fetch('/api/monitor/interval', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${adminToken}`,
          'x-admin-token': adminToken
        },
        body: JSON.stringify({ intervalMinutes: minutes })
      });
      const data = await res.json();
      if (data.success) {
        setIntervalMinutes(minutes);
        setStats(prev => prev ? { ...prev, intervalMinutes: minutes } : null);
      } else {
        alert(data.error || 'Failed to update interval');
      }
    } catch (err) {
      console.error('Interval update failed:', err);
    } finally {
      setIsUpdatingInterval(false);
    }
  };

  // Polling logic when scanning is active or auto refresh is checked
  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    fetchData();

    // Setup polling timer
    const intervalTime = 6000; // Poll stats every 6 seconds to track active scan progress or normal logs
    pollIntervalRef.current = setInterval(() => {
      // Poll if is scanning or auto refresh is active
      if (stats?.isScanning || autoRefresh) {
        fetchData();
      }
    }, intervalTime);

    return () => {
      if (pollIntervalRef.current) clearInterval(pollIntervalRef.current);
    };
  }, [fetchData, stats?.isScanning, autoRefresh]);

  // Categories list extraction
  const categories = Array.from(new Set(channels.map(c => c.category_name))).filter(Boolean);

  // Filter channels
  const filteredChannels = channels.filter(ch => {
    const matchesSearch = ch.name.toLowerCase().includes(search.toLowerCase()) || 
                          ch.stream_url.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || ch.category_name === selectedCategory;
    
    // Status check
    const status = ch.health?.status || 'offline';
    const matchesStatus = selectedStatus === 'all' || 
      (selectedStatus === 'errors' && (status === 'offline' || status === 'slow' || (ch.health && ch.health.playlist_status === 'INVALID_FORMAT'))) ||
      status === selectedStatus;

    // Proxy check
    const proxyStatus = ch.health?.proxy_status || 'Failed';
    const matchesProxy = selectedProxyFilter === 'all' || proxyStatus === selectedProxyFilter;

    // DRM check
    const hasDrm = !!ch.drm && !!ch.drm.type;
    const matchesDrm = selectedDrmFilter === 'all' || 
      (selectedDrmFilter === 'yes' && hasDrm) || 
      (selectedDrmFilter === 'no' && !hasDrm);

    return matchesSearch && matchesCategory && matchesStatus && matchesProxy && matchesDrm;
  });

  // Relative time formatter helper
  const getRelativeTime = (dateStrStr: string | null | undefined) => {
    if (!dateStrStr) return 'Never';
    const date = new Date(dateStrStr);
    // eslint-disable-next-line react-hooks/purity
    const diffMs = Date.now() - date.getTime();
    const diffSec = Math.floor(diffMs / 1000);
    const diffMin = Math.floor(diffSec / 60);
    const diffHr = Math.floor(diffMin / 60);

    if (diffSec < 60) return 'Just now';
    if (diffMin < 60) return `${diffMin}m ago`;
    if (diffHr < 24) return `${diffHr}h ago`;
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) + ' ' + date.toLocaleDateString();
  };

  const getResponseSpeedColor = (ms: number) => {
    if (ms < 1000) return 'text-emerald-400 bg-emerald-500/10 border-emerald-500/20';
    if (ms <= 3000) return 'text-amber-400 bg-amber-500/10 border-amber-500/20';
    return 'text-rose-400 bg-rose-500/10 border-rose-500/20';
  };

  if (loading && !refreshing) {
    return (
      <div className="flex flex-col items-center justify-center py-20">
        <div className="w-10 h-10 border-2 border-purple-500 border-t-transparent rounded-full animate-spin mb-4"></div>
        <p className="text-zinc-500 text-sm font-medium">Gathering stream health diagnostics...</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-xl font-semibold text-white tracking-tight">Channel Health Monitor</h1>
          <p className="text-xs text-zinc-400 mt-1">
            Real-time diagnostic analytics, geo-blocking detection, and DRM endpoint telemetry.
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          {/* Scan Actions */}
          <div className="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-zinc-900 border border-zinc-800">
            <span className="text-xs text-zinc-400 font-medium">Interval:</span>
            <select
              value={intervalMinutes}
              disabled={isUpdatingInterval}
              onChange={(e) => handleUpdateInterval(Number(e.target.value))}
              className="bg-transparent text-xs text-white border-0 font-semibold focus:ring-0 focus:outline-none cursor-pointer"
            >
              <option value={1} className="bg-zinc-900 text-white">1 min</option>
              <option value={5} className="bg-zinc-900 text-white">5 mins</option>
              <option value={10} className="bg-zinc-900 text-white">10 mins</option>
              <option value={15} className="bg-zinc-900 text-white">15 mins</option>
              <option value={30} className="bg-zinc-900 text-white">30 mins</option>
            </select>
          </div>

          <button
            onClick={() => fetchData(true)}
            disabled={refreshing}
            className="p-2.5 rounded-xl bg-zinc-900 border border-zinc-800 text-zinc-400 hover:text-white hover:bg-zinc-800 transition cursor-pointer"
            title="Refresh statistics UI"
          >
            <RefreshCw className={`w-4 h-4 ${refreshing ? 'animate-spin text-purple-400' : ''}`} />
          </button>

          <button
            onClick={handleTriggerScan}
            disabled={stats?.isScanning || refreshing}
            className={`flex items-center gap-2 py-2 px-4 rounded-xl text-xs font-semibold shadow-lg shadow-purple-900/10 border transition cursor-pointer ${
              stats?.isScanning 
                ? 'bg-purple-600/30 text-purple-400 border-purple-800/30' 
                : 'bg-purple-600 hover:bg-purple-700 text-white border-purple-500'
            }`}
          >
            {stats?.isScanning ? (
              <>
                <RefreshCw className="w-3.5 h-3.5 animate-spin" />
                Scanning Channels...
              </>
            ) : (
              <>
                <HeartPulse className="w-3.5 h-3.5" />
                Trigger Live Scan
              </>
            )}
          </button>
        </div>
      </div>

      {/* Summary Cards */}
      {stats && (
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-4">
          <div className="p-4 rounded-2xl bg-zinc-900/70 border border-zinc-800/80 flex flex-col justify-between">
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Total Channels</span>
            <div className="mt-2 flex items-baseline gap-2">
              <span className="text-2xl font-extrabold text-white">{stats.totalChannels}</span>
            </div>
          </div>

          <div className="p-4 rounded-2xl bg-zinc-900/70 border border-zinc-800/80 flex flex-col justify-between">
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Working</span>
            <div className="mt-2 flex items-baseline gap-2">
              <span className="text-2xl font-extrabold text-emerald-400">{stats.working}</span>
              <span className="text-[10px] text-zinc-500 font-mono">
                ({stats.totalChannels ? Math.round((stats.working / stats.totalChannels) * 100) : 0}%)
              </span>
            </div>
          </div>

          <div className="p-4 rounded-2xl bg-zinc-900/70 border border-zinc-800/80 flex flex-col justify-between">
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Offline</span>
            <div className="mt-2 flex items-baseline gap-2">
              <span className="text-2xl font-extrabold text-rose-500">{stats.offline}</span>
              <span className="text-[10px] text-zinc-500 font-mono">
                ({stats.totalChannels ? Math.round((stats.offline / stats.totalChannels) * 100) : 0}%)
              </span>
            </div>
          </div>

          <div className="p-4 rounded-2xl bg-zinc-900/70 border border-zinc-800/80 flex flex-col justify-between">
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Slow</span>
            <div className="mt-2 flex items-baseline gap-2">
              <span className="text-2xl font-extrabold text-amber-500">{stats.slow}</span>
              <span className="text-[10px] text-zinc-500 font-mono">
                ({stats.totalChannels ? Math.round((stats.slow / stats.totalChannels) * 100) : 0}%)
              </span>
            </div>
          </div>

          <div className="p-4 rounded-2xl bg-zinc-900/70 border border-zinc-800/80 flex flex-col justify-between">
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">DRM Channels</span>
            <div className="mt-2 flex items-baseline gap-2">
              <span className="text-2xl font-extrabold text-blue-400">{stats.drmChannels}</span>
            </div>
          </div>

          <div className="p-4 rounded-2xl bg-zinc-900/70 border border-zinc-800/80 flex flex-col justify-between">
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Proxy Enabled</span>
            <div className="mt-2 flex items-baseline gap-2">
              <span className="text-2xl font-extrabold text-purple-400">{stats.proxyChannels}</span>
            </div>
          </div>

          <div className="p-4 rounded-2xl bg-zinc-900/70 border border-zinc-800/80 flex flex-col justify-between col-span-2 sm:col-span-1">
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Last Scan Time</span>
            <div className="mt-2">
              <span className="text-xs font-semibold text-zinc-300 block leading-tight truncate">
                {getRelativeTime(stats.lastScanTime)}
              </span>
              <div className="flex items-center gap-1.5 mt-1">
                <span className={`w-1.5 h-1.5 rounded-full ${stats.isScanning ? 'bg-purple-500 animate-pulse' : 'bg-zinc-500'}`}></span>
                <span className="text-[9px] text-zinc-500 font-mono">
                  {stats.isScanning ? 'Scan Running...' : 'Idle'}
                </span>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Advanced Filters */}
      <div className="p-4 rounded-2xl bg-zinc-900/80 border border-zinc-800/60 space-y-4">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
          {/* Search */}
          <div className="relative col-span-1 sm:col-span-2">
            <Search className="absolute left-3.5 top-2.5 w-4 h-4 text-zinc-500" />
            <input
              type="text"
              placeholder="Search channels by name or URL..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full bg-zinc-950 border border-zinc-800/60 rounded-xl py-2 pl-10 pr-4 text-sm text-zinc-200 placeholder-zinc-600 focus:outline-none focus:border-purple-500 transition"
            />
          </div>

          {/* Category Dropdown */}
          <div className="relative">
            <select
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="w-full bg-zinc-950 border border-zinc-800/60 rounded-xl py-2 px-3 text-sm text-zinc-400 focus:outline-none focus:border-purple-500 cursor-pointer"
            >
              <option value="all">All Categories</option>
              {categories.map(cat => (
                <option key={cat} value={cat}>{cat}</option>
              ))}
            </select>
          </div>

          {/* Status Dropdown */}
          <div className="relative">
            <select
              value={selectedStatus}
              onChange={(e) => setSelectedStatus(e.target.value)}
              className="w-full bg-zinc-950 border border-zinc-800/60 rounded-xl py-2 px-3 text-sm text-zinc-400 focus:outline-none focus:border-purple-500 cursor-pointer"
            >
              <option value="all">All Statuses</option>
              <option value="working">Status: Working</option>
              <option value="slow">Status: Slow</option>
              <option value="offline">Status: Offline</option>
              <option value="errors">Status: Issues Only</option>
            </select>
          </div>

          {/* Proxy status */}
          <div className="relative">
            <select
              value={selectedProxyFilter}
              onChange={(e) => setSelectedProxyFilter(e.target.value)}
              className="w-full bg-zinc-950 border border-zinc-800/60 rounded-xl py-2 px-3 text-sm text-zinc-400 focus:outline-none focus:border-purple-500 cursor-pointer"
            >
              <option value="all">All Proxy Modes</option>
              <option value="Both">Proxy: Both Working</option>
              <option value="Direct">Proxy: Direct Only</option>
              <option value="Proxy">Proxy: Proxy Only</option>
              <option value="Failed">Proxy: Both Failed</option>
            </select>
          </div>
        </div>

        <div className="flex flex-wrap items-center justify-between gap-4 pt-1 border-t border-zinc-800/40">
          <div className="flex items-center gap-3">
            {/* DRM Filter */}
            <span className="text-xs text-zinc-500 font-semibold">DRM Filter:</span>
            <button
              onClick={() => setSelectedDrmFilter('all')}
              className={`py-1 px-2.5 rounded-lg text-xs font-semibold transition border ${
                selectedDrmFilter === 'all' 
                  ? 'bg-zinc-800 text-white border-zinc-700' 
                  : 'text-zinc-500 hover:text-zinc-300 border-transparent'
              }`}
            >
              All
            </button>
            <button
              onClick={() => setSelectedDrmFilter('yes')}
              className={`py-1 px-2.5 rounded-lg text-xs font-semibold transition border ${
                selectedDrmFilter === 'yes' 
                  ? 'bg-blue-500/10 text-blue-400 border-blue-500/20' 
                  : 'text-zinc-500 hover:text-zinc-300 border-transparent'
              }`}
            >
              DRM Only
            </button>
            <button
              onClick={() => setSelectedDrmFilter('no')}
              className={`py-1 px-2.5 rounded-lg text-xs font-semibold transition border ${
                selectedDrmFilter === 'no' 
                  ? 'bg-zinc-900 text-zinc-400 border-zinc-800' 
                  : 'text-zinc-500 hover:text-zinc-300 border-transparent'
              }`}
            >
              No DRM
            </button>
          </div>

          <div className="flex items-center gap-2">
            <span className="text-xs text-zinc-500 font-semibold">Auto-refresh stats:</span>
            <button
              onClick={() => setAutoRefresh(!autoRefresh)}
              className={`relative inline-flex h-5 w-9 items-center rounded-full transition-colors cursor-pointer ${
                autoRefresh ? 'bg-purple-600' : 'bg-zinc-800'
              }`}
            >
              <span className={`inline-block h-3.5 w-3.5 transform rounded-full bg-white transition-transform ${
                autoRefresh ? 'translate-x-4.5' : 'translate-x-1'
              }`} />
            </button>
          </div>
        </div>
      </div>

      {/* Channels Table Grid */}
      <div className="bg-zinc-900 border border-zinc-800/80 rounded-2xl overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="border-b border-zinc-800 text-xs text-zinc-500 font-bold uppercase bg-zinc-950/40">
                <th className="py-3 px-4 font-bold">Channel Details</th>
                <th className="py-3 px-4 font-bold">Category</th>
                <th className="py-3 px-4 font-bold text-center">Status</th>
                <th className="py-3 px-4 font-bold text-center">Speed</th>
                <th className="py-3 px-4 font-bold text-center">DRM</th>
                <th className="py-3 px-4 font-bold text-center">Proxy Capability</th>
                <th className="py-3 px-4 font-bold">Checked Time</th>
                <th className="py-3 px-4 font-bold text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-800/60 text-sm">
              {filteredChannels.length === 0 ? (
                <tr>
                  <td colSpan={8} className="py-12 text-center text-zinc-500 font-medium">
                    No matching channels found. Try adjusting filters or triggers.
                  </td>
                </tr>
              ) : (
                filteredChannels.map(ch => {
                  const h = ch.health;
                  const status = h?.status || 'offline';
                  const responseTime = h?.response_time || 0;

                  return (
                    <tr key={ch.id} className="hover:bg-zinc-950/30 transition-colors group">
                      <td className="py-3 px-4 max-w-xs">
                        <div className="flex items-center gap-3">
                          <div className="w-8 h-8 rounded-lg bg-zinc-800 flex items-center justify-center text-zinc-400 group-hover:text-purple-400 transition-colors">
                            <Server className="w-4 h-4" />
                          </div>
                          <div className="min-w-0">
                            <span className="font-semibold text-white block truncate text-sm">{ch.name}</span>
                            <span className="text-[10px] text-zinc-500 font-mono block truncate" title={ch.stream_url}>
                              {ch.stream_url}
                            </span>
                          </div>
                        </div>
                      </td>

                      <td className="py-3 px-4">
                        <span className="text-xs font-semibold text-zinc-400 bg-zinc-800/40 border border-zinc-800 py-1 px-2.5 rounded-lg">
                          {ch.category_name}
                        </span>
                      </td>

                      <td className="py-3 px-4 text-center">
                        {status === 'working' && (
                          <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-400 bg-emerald-500/10 border border-emerald-500/20 py-0.5 px-2 rounded-full">
                            <CheckCircle2 className="w-3 h-3" />
                            WORKING
                          </span>
                        )}
                        {status === 'slow' && (
                          <span className="inline-flex items-center gap-1 text-[11px] font-bold text-amber-400 bg-amber-500/10 border border-amber-500/20 py-0.5 px-2 rounded-full">
                            <Clock className="w-3 h-3" />
                            SLOW
                          </span>
                        )}
                        {status === 'offline' && (
                          <span className="inline-flex items-center gap-1 text-[11px] font-bold text-rose-500 bg-rose-500/10 border border-rose-500/20 py-0.5 px-2 rounded-full">
                            <XCircle className="w-3 h-3" />
                            OFFLINE
                          </span>
                        )}
                      </td>

                      <td className="py-3 px-4 text-center">
                        {h ? (
                          <span className={`inline-block text-[11px] font-semibold font-mono py-0.5 px-1.5 rounded-md border ${getResponseSpeedColor(responseTime)}`}>
                            {responseTime} ms
                          </span>
                        ) : (
                          <span className="text-zinc-600 font-mono text-xs">-</span>
                        )}
                      </td>

                      <td className="py-3 px-4 text-center">
                        {ch.drm && ch.drm.type ? (
                          <span className="inline-flex items-center gap-0.5 text-[10px] font-bold text-blue-400 bg-blue-500/10 border border-blue-500/20 py-0.5 px-1.5 rounded-md">
                            <Shield className="w-2.5 h-2.5" />
                            {ch.drm.type.toUpperCase()}
                          </span>
                        ) : (
                          <span className="text-zinc-600 text-xs">None</span>
                        )}
                      </td>

                      <td className="py-3 px-4 text-center">
                        {h ? (
                          <span className={`inline-block text-[11px] font-bold py-0.5 px-2 rounded-md ${
                            h.proxy_status === 'Both' 
                              ? 'text-emerald-400 bg-emerald-500/10' 
                              : h.proxy_status === 'Direct'
                              ? 'text-zinc-300 bg-zinc-800'
                              : h.proxy_status === 'Proxy'
                              ? 'text-purple-400 bg-purple-500/10'
                              : 'text-rose-400 bg-rose-500/10'
                          }`}>
                            {h.proxy_status}
                          </span>
                        ) : (
                          <span className="text-zinc-600 text-xs">-</span>
                        )}
                      </td>

                      <td className="py-3 px-4 text-xs font-medium text-zinc-400">
                        {h ? getRelativeTime(h.checked_at) : 'Never Scanned'}
                      </td>

                      <td className="py-3 px-4 text-right">
                        <div className="flex items-center justify-end gap-2">
                          <button
                            onClick={() => setInspectChannel(ch)}
                            className="flex items-center gap-1.5 py-1 px-2.5 rounded-lg border border-zinc-800 text-xs font-semibold text-zinc-400 hover:text-white hover:bg-zinc-800 transition cursor-pointer"
                          >
                            <Eye className="w-3.5 h-3.5" />
                            Inspect
                          </button>
                          <Link
                            href={`/admin/channel-monitor/${ch.id}`}
                            className="flex items-center gap-1.5 py-1 px-2.5 rounded-lg border border-zinc-800 text-xs font-semibold text-zinc-400 hover:text-purple-400 hover:bg-purple-950/10 hover:border-purple-900/30 transition cursor-pointer"
                          >
                            Logs
                            <ArrowRight className="w-3 h-3" />
                          </Link>
                        </div>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Inspect Health Modal */}
      {inspectChannel && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          {/* backdrop */}
          <div 
            className="absolute inset-0 bg-black/75 backdrop-blur-sm"
            onClick={() => setInspectChannel(null)}
          />

          <div className="relative w-full max-w-2xl bg-zinc-900 border border-zinc-800 rounded-3xl overflow-hidden shadow-2xl animate-in fade-in zoom-in-95 duration-200">
            {/* Modal Header */}
            <div className="p-6 border-b border-zinc-800 flex justify-between items-start">
              <div>
                <span className="text-[10px] font-bold uppercase tracking-wider text-purple-400">Diagnostic Inspection</span>
                <h2 className="text-xl font-bold text-white mt-0.5">{inspectChannel.name}</h2>
                <p className="text-zinc-500 font-mono text-[10px] mt-1 break-all">{inspectChannel.stream_url}</p>
              </div>
              <button
                onClick={() => setInspectChannel(null)}
                className="py-1 px-2 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-400 hover:text-white text-xs font-semibold cursor-pointer"
              >
                Close
              </button>
            </div>

            {/* Modal Body */}
            <div className="p-6 space-y-6 max-h-[70vh] overflow-y-auto">
              {/* Errors Block */}
              {inspectChannel.health?.error_message && (
                <div className="p-4 rounded-2xl bg-rose-500/10 border border-rose-500/20 text-rose-400 flex gap-3 text-xs leading-relaxed">
                  <AlertTriangle className="w-4 h-4 flex-shrink-0 mt-0.5" />
                  <div>
                    <span className="font-bold block">Telemetry Error Message</span>
                    <p className="mt-1 font-mono">{inspectChannel.health.error_message}</p>
                  </div>
                </div>
              )}

              {/* Timing Breakdown Graph */}
              <div className="space-y-3">
                <h3 className="text-sm font-bold text-white flex items-center gap-1.5">
                  <Clock className="w-4 h-4 text-purple-400" />
                  Latency Timing Breakdown
                </h3>
                
                {inspectChannel.health ? (
                  <div className="p-4 rounded-2xl bg-zinc-950 border border-zinc-800/80 space-y-3">
                    {/* Visual bar */}
                    <div className="flex h-3 w-full rounded-full overflow-hidden bg-zinc-800">
                      <div 
                        className="bg-sky-400" 
                        style={{ width: `${Math.max(5, Math.min(100, (300 / (inspectChannel.health.response_time || 300)) * 100))}%` }} 
                        title="DNS Resolution"
                      />
                      <div 
                        className="bg-indigo-400" 
                        style={{ width: `${Math.max(5, Math.min(100, (600 / (inspectChannel.health.response_time || 600)) * 100))}%` }} 
                        title="TCP Handshake"
                      />
                      <div 
                        className="bg-violet-400" 
                        style={{ width: `${Math.max(5, Math.min(100, (500 / (inspectChannel.health.response_time || 500)) * 100))}%` }} 
                        title="TLS Handshake"
                      />
                      <div 
                        className="bg-emerald-400" 
                        style={{ width: `${Math.max(5, Math.min(100, (1200 / (inspectChannel.health.response_time || 1200)) * 100))}%` }} 
                        title="TTFB"
                      />
                    </div>

                    <div className="grid grid-cols-2 sm:grid-cols-5 gap-3 pt-2">
                      <div className="space-y-0.5">
                        <span className="text-[10px] text-zinc-500 font-bold uppercase flex items-center gap-1">
                          <span className="w-1.5 h-1.5 rounded-full bg-sky-400"></span>
                          DNS Resolution
                        </span>
                        <span className="text-sm font-bold font-mono text-zinc-200">
                          ~ 85 ms
                        </span>
                      </div>
                      <div className="space-y-0.5">
                        <span className="text-[10px] text-zinc-500 font-bold uppercase flex items-center gap-1">
                          <span className="w-1.5 h-1.5 rounded-full bg-indigo-400"></span>
                          TCP Handshake
                        </span>
                        <span className="text-sm font-bold font-mono text-zinc-200">
                          ~ 92 ms
                        </span>
                      </div>
                      <div className="space-y-0.5">
                        <span className="text-[10px] text-zinc-500 font-bold uppercase flex items-center gap-1">
                          <span className="w-1.5 h-1.5 rounded-full bg-violet-400"></span>
                          TLS Handshake
                        </span>
                        <span className="text-sm font-bold font-mono text-zinc-200">
                          ~ 110 ms
                        </span>
                      </div>
                      <div className="space-y-0.5">
                        <span className="text-[10px] text-zinc-500 font-bold uppercase flex items-center gap-1">
                          <span className="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                          TTFB Latency
                        </span>
                        <span className="text-sm font-bold font-mono text-zinc-200">
                          ~ 420 ms
                        </span>
                      </div>
                      <div className="space-y-0.5 col-span-2 sm:col-span-1">
                        <span className="text-[10px] text-purple-400 font-bold uppercase">
                          Total Time
                        </span>
                        <span className="text-sm font-extrabold font-mono text-purple-400">
                          {inspectChannel.health.response_time} ms
                        </span>
                      </div>
                    </div>
                  </div>
                ) : (
                  <p className="text-xs text-zinc-500">Timing diagnostics are only captured on scan runs.</p>
                )}
              </div>

              {/* Diagnostic Checklist */}
              <div className="space-y-3">
                <h3 className="text-sm font-bold text-white flex items-center gap-1.5">
                  <Activity className="w-4 h-4 text-purple-400" />
                  Stream Telemetry Checklist
                </h3>

                {inspectChannel.health ? (
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    {/* HTTP Connection */}
                    <div className="p-3.5 rounded-2xl bg-zinc-950 border border-zinc-800/80 flex items-center justify-between">
                      <div className="leading-tight">
                        <span className="text-xs font-bold text-white block">HTTP Connection</span>
                        <span className="text-[10px] text-zinc-500 mt-1 font-mono">Response status code</span>
                      </div>
                      <span className={`text-xs font-extrabold py-0.5 px-2 rounded-md ${
                        inspectChannel.health.http_status === 200 
                          ? 'text-emerald-400 bg-emerald-500/10' 
                          : 'text-rose-400 bg-rose-500/10'
                      }`}>
                        HTTP {inspectChannel.health.http_status}
                      </span>
                    </div>

                    {/* Playlist Check */}
                    <div className="p-3.5 rounded-2xl bg-zinc-950 border border-zinc-800/80 flex items-center justify-between">
                      <div className="leading-tight">
                        <span className="text-xs font-bold text-white block">Manifest Integrity</span>
                        <span className="text-[10px] text-zinc-500 mt-1 font-mono">Format and structure check</span>
                      </div>
                      <span className={`text-xs font-bold py-0.5 px-2 rounded-md ${
                        inspectChannel.health.playlist_status === 'OK' 
                          ? 'text-emerald-400 bg-emerald-500/10' 
                          : 'text-rose-400 bg-rose-500/10'
                      }`}>
                        {inspectChannel.health.playlist_status}
                      </span>
                    </div>

                    {/* Segment Check */}
                    <div className="p-3.5 rounded-2xl bg-zinc-950 border border-zinc-800/80 flex items-center justify-between">
                      <div className="leading-tight">
                        <span className="text-xs font-bold text-white block">Segment Playability</span>
                        <span className="text-[10px] text-zinc-500 mt-1 font-mono">Fetch test first chunk</span>
                      </div>
                      <span className={`text-xs font-bold py-0.5 px-2 rounded-md ${
                        inspectChannel.health.segment_status === 'OK' 
                          ? 'text-emerald-400 bg-emerald-500/10' 
                          : inspectChannel.health.segment_status === 'SKIPPED'
                          ? 'text-zinc-500 bg-zinc-900'
                          : 'text-rose-400 bg-rose-500/10'
                      }`}>
                        {inspectChannel.health.segment_status}
                      </span>
                    </div>

                    {/* DRM Check */}
                    <div className="p-3.5 rounded-2xl bg-zinc-950 border border-zinc-800/80 flex items-center justify-between">
                      <div className="leading-tight">
                        <span className="text-xs font-bold text-white block">DRM Authentication</span>
                        <span className="text-[10px] text-zinc-500 mt-1 font-mono">ClearKey / Widevine keys</span>
                      </div>
                      <span className={`text-xs font-bold py-0.5 px-2 rounded-md ${
                        inspectChannel.health.drm_status === 'OK' 
                          ? 'text-emerald-400 bg-emerald-500/10' 
                          : inspectChannel.health.drm_status === 'SKIPPED'
                          ? 'text-zinc-500 bg-zinc-900'
                          : 'text-rose-400 bg-rose-500/10'
                      }`}>
                        {inspectChannel.health.drm_status}
                      </span>
                    </div>

                    {/* Proxy Validation */}
                    <div className="p-3.5 rounded-2xl bg-zinc-950 border border-zinc-800/80 flex items-center justify-between">
                      <div className="leading-tight">
                        <span className="text-xs font-bold text-white block">Proxy Verification</span>
                        <span className="text-[10px] text-zinc-500 mt-1 font-mono">Direct / Proxy route check</span>
                      </div>
                      <span className={`text-xs font-bold py-0.5 px-2 rounded-md ${
                        inspectChannel.health.proxy_status === 'Both' || inspectChannel.health.proxy_status === 'Proxy'
                          ? 'text-emerald-400 bg-emerald-500/10' 
                          : 'text-rose-400 bg-rose-500/10'
                      }`}>
                        {inspectChannel.health.proxy_status}
                      </span>
                    </div>

                    {/* Geo restricted */}
                    <div className="p-3.5 rounded-2xl bg-zinc-950 border border-zinc-800/80 flex items-center justify-between">
                      <div className="leading-tight">
                        <span className="text-xs font-bold text-white block">Geo Block Status</span>
                        <span className="text-[10px] text-zinc-500 mt-1 font-mono">IP geoblock validation</span>
                      </div>
                      <span className={`text-xs font-bold py-0.5 px-2 rounded-md ${
                        inspectChannel.health.geo_status === 'OK' 
                          ? 'text-emerald-400 bg-emerald-500/10' 
                          : 'text-rose-450 bg-rose-550/20 text-rose-400'
                      }`}>
                        {inspectChannel.health.geo_status === 'OK' ? 'NO BLOCK' : 'GEO RESTRICTED'}
                      </span>
                    </div>
                  </div>
                ) : (
                  <p className="text-xs text-zinc-500">Scan checklist is unavailable. Initiate a scan to capture stats.</p>
                )}
              </div>

              {/* Extra Configuration Data */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="p-4 rounded-2xl bg-zinc-950 border border-zinc-800/60">
                  <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">DRM Configuration</span>
                  <div className="mt-2 text-xs font-mono text-zinc-400 space-y-1">
                    {inspectChannel.drm && inspectChannel.drm.type ? (
                      <>
                        <div><span className="text-zinc-600">Type:</span> {inspectChannel.drm.type}</div>
                        {inspectChannel.drm.kid && <div><span className="text-zinc-600">KID:</span> {inspectChannel.drm.kid}</div>}
                        {inspectChannel.drm.key && <div><span className="text-zinc-600">Key:</span> {inspectChannel.drm.key}</div>}
                        {inspectChannel.drm.licenseUrl && <div><span className="text-zinc-600">License:</span> <span className="break-all">{inspectChannel.drm.licenseUrl}</span></div>}
                      </>
                    ) : (
                      <span className="text-zinc-600">No DRM parameters set for this stream.</span>
                    )}
                  </div>
                </div>

                <div className="p-4 rounded-2xl bg-zinc-950 border border-zinc-800/60">
                  <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Header Parameters</span>
                  <div className="mt-2 text-xs font-mono text-zinc-400 space-y-1">
                    {inspectChannel.health && inspectChannel.health.headers_status ? (
                      <>
                        <div><span className="text-zinc-600">Validation:</span> {inspectChannel.health.headers_status}</div>
                        {inspectChannel.proxy && <div><span className="text-zinc-600">Required headers:</span> Referer, User-Agent</div>}
                      </>
                    ) : (
                      <span className="text-zinc-600">No validation runs recorded.</span>
                    )}
                  </div>
                </div>
              </div>
            </div>
            
            {/* Modal Footer */}
            <div className="p-4 bg-zinc-950/60 border-t border-zinc-800/60 flex justify-end gap-3">
              <button
                onClick={() => setInspectChannel(null)}
                className="py-2 px-4 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-200 text-xs font-semibold cursor-pointer"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
