'use client';

import React, { useState, useEffect, useCallback } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import { useAuth } from '../../../../providers/auth-provider';
import {
  ArrowLeft, RefreshCw, CheckCircle2, XCircle, Clock,
  Calendar, Check, X, Minus
} from 'lucide-react';

interface LogData {
  id: string;
  channel_id: string;
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

interface ChannelInfo {
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
}

export default function ChannelLogsPage() {
  const { adminToken } = useAuth();
  const params = useParams();
  const channelId = params?.channelId as string;

  const [channel, setChannel] = useState<ChannelInfo | null>(null);
  const [logs, setLogs] = useState<LogData[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchLogs = useCallback(async (showIndicator = false) => {
    if (showIndicator) setRefreshing(true);
    try {
      const res = await fetch(`/api/monitor/logs?channelId=${encodeURIComponent(channelId)}`, {
        headers: {
          'Authorization': `Bearer ${adminToken}`,
          'x-admin-token': adminToken
        }
      });
      const data = await res.json();
      if (data.success) {
        setChannel(data.channel);
        setLogs(data.logs);
      } else {
        setError(data.error || 'Failed to fetch log details');
      }
    } catch (err) {
      console.error('Failed to fetch channel logs:', err);
      setError('Connection failure while loading logs');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [adminToken, channelId]);

  useEffect(() => {
    if (adminToken && channelId) {
      // eslint-disable-next-line react-hooks/set-state-in-effect
      fetchLogs();
    }
  }, [adminToken, channelId, fetchLogs]);

  // Calculations
  const totalScans = logs.length;
  const successScans = logs.filter(l => l.status === 'working' || l.status === 'slow').length;
  const successRate = totalScans ? Math.round((successScans / totalScans) * 100) : 0;
  const avgResponseTime = totalScans 
    ? Math.round(logs.reduce((acc, l) => acc + (l.response_time || 0), 0) / totalScans)
    : 0;

  const getResponseSpeedColor = (ms: number) => {
    if (ms < 1000) return 'text-emerald-400 bg-emerald-500/10 border-emerald-500/20';
    if (ms <= 3000) return 'text-amber-400 bg-amber-500/10 border-amber-500/20';
    return 'text-rose-400 bg-rose-500/10 border-rose-500/20';
  };

  const renderCheckIcon = (status: string) => {
    if (status === 'OK' || status === 'Both' || status === 'Direct' || status === 'Proxy') {
      return <Check className="w-3.5 h-3.5 text-emerald-400" />;
    }
    if (status === 'FAILED' || status === 'Failed' || status === 'INVALID_FORMAT') {
      return <X className="w-3.5 h-3.5 text-rose-500" />;
    }
    return <Minus className="w-3.5 h-3.5 text-zinc-650" />;
  };

  if (loading && !refreshing) {
    return (
      <div className="flex flex-col items-center justify-center py-20">
        <div className="w-10 h-10 border-2 border-purple-500 border-t-transparent rounded-full animate-spin mb-4"></div>
        <p className="text-zinc-500 text-sm font-medium">Extracting scan metrics history...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="max-w-md mx-auto py-20 text-center space-y-4">
        <div className="w-12 h-12 rounded-full bg-rose-500/10 border border-rose-500/20 flex items-center justify-center mx-auto text-rose-500">
          <ShieldAlert className="w-6 h-6" />
        </div>
        <h2 className="text-lg font-bold text-white">Log Retrieval Failed</h2>
        <p className="text-zinc-500 text-sm">{error}</p>
        <Link
          href="/admin/channel-monitor"
          className="inline-flex items-center gap-2 py-2 px-4 rounded-xl bg-zinc-900 border border-zinc-800 text-xs font-semibold text-zinc-300 hover:text-white transition cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4" />
          Back to Monitor
        </Link>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div className="space-y-1">
          <Link
            href="/admin/channel-monitor"
            className="inline-flex items-center gap-1 text-xs font-semibold text-purple-400 hover:text-purple-300 transition"
          >
            <ArrowLeft className="w-3 h-3" />
            Back to Health Monitor
          </Link>
          {channel && (
            <>
              <h1 className="text-2xl font-bold text-white tracking-tight">{channel.name}</h1>
              <p className="text-zinc-500 font-mono text-[10px] truncate max-w-2xl">{channel.stream_url}</p>
            </>
          )}
        </div>
        <div>
          <button
            onClick={() => fetchLogs(true)}
            disabled={refreshing}
            className="flex items-center gap-2 py-2 px-4 rounded-xl bg-zinc-900 border border-zinc-800 text-xs font-semibold text-zinc-400 hover:text-white transition cursor-pointer"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${refreshing ? 'animate-spin text-purple-400' : ''}`} />
            Refresh Log List
          </button>
        </div>
      </div>

      {/* Overview Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 flex flex-col justify-between">
          <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Total Scans Cached</span>
          <div className="mt-2 flex items-baseline gap-2">
            <span className="text-3xl font-extrabold text-white">{totalScans}</span>
            <span className="text-xs text-zinc-500 font-medium">runs</span>
          </div>
        </div>

        <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 flex flex-col justify-between">
          <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Uptime Success Rate</span>
          <div className="mt-2 flex items-baseline gap-2">
            <span className={`text-3xl font-extrabold ${successRate > 90 ? 'text-emerald-400' : successRate > 70 ? 'text-amber-400' : 'text-rose-500'}`}>
              {successRate}%
            </span>
            <span className="text-xs text-zinc-500 font-medium">online</span>
          </div>
        </div>

        <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 flex flex-col justify-between">
          <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Average Latency</span>
          <div className="mt-2 flex items-baseline gap-2">
            <span className="text-3xl font-extrabold text-purple-400">{avgResponseTime}</span>
            <span className="text-xs text-zinc-500 font-medium">ms</span>
          </div>
        </div>
      </div>

      {/* Latency History Chart (Visual CSS Representation) */}
      {logs.length > 0 && (
        <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
          <h3 className="text-xs font-bold text-white uppercase tracking-wider flex items-center gap-1.5">
            <Activity className="w-4 h-4 text-purple-400" />
            Connection Latency Timeline (Last {logs.length} Scans)
          </h3>
          
          <div className="h-32 flex items-end gap-1.5 pt-6 px-4 bg-zinc-950 border border-zinc-800/40 rounded-xl relative">
            {/* Latency guidelines */}
            <div className="absolute top-2 right-4 text-[9px] text-zinc-600 font-mono flex flex-col items-end gap-1 select-none pointer-events-none">
              <div>&gt; 3000ms (Slow)</div>
              <div>&lt; 1000ms (Healthy)</div>
            </div>

            {logs.slice().reverse().map((log) => {
              const heightPct = Math.max(8, Math.min(100, (log.response_time / 5000) * 100));
              let barColor = 'bg-emerald-500/80 hover:bg-emerald-400';
              if (log.status === 'slow') barColor = 'bg-amber-500/80 hover:bg-amber-400';
              if (log.status === 'offline') barColor = 'bg-rose-600/80 hover:bg-rose-500';

              return (
                <div 
                  key={log.id} 
                  className="flex-1 flex flex-col items-center group relative cursor-pointer"
                  style={{ height: '100%' }}
                >
                  {/* Tooltip */}
                  <div className="absolute bottom-full mb-2 bg-zinc-900 border border-zinc-800 text-[10px] text-zinc-300 font-mono py-1 px-2 rounded-lg opacity-0 pointer-events-none group-hover:opacity-100 transition-opacity z-10 w-28 text-center leading-normal shadow-xl">
                    <span className="font-bold block text-white">{log.response_time} ms</span>
                    <span>{new Date(log.checked_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                  </div>
                  
                  {/* Bar */}
                  <div 
                    className={`w-full rounded-t-sm transition-all duration-300 ${barColor}`}
                    style={{ height: `${heightPct}%` }}
                  />
                  
                  {/* Dots / Indicators */}
                  <div className={`w-1 h-1 rounded-full mt-1.5 ${
                    log.status === 'working' ? 'bg-emerald-400' : log.status === 'slow' ? 'bg-amber-400' : 'bg-rose-500'
                  }`} />
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Logs Table */}
      <div className="bg-zinc-900 border border-zinc-800 rounded-2xl overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="border-b border-zinc-800 text-xs text-zinc-500 font-bold uppercase bg-zinc-950/40">
                <th className="py-3 px-4">Scan Timestamp</th>
                <th className="py-3 px-4 text-center">Status</th>
                <th className="py-3 px-4 text-center font-mono">Latency</th>
                <th className="py-3 px-4 text-center">HTTP</th>
                <th className="py-3 px-4 text-center" title="Manifest Structure Check">Playlist</th>
                <th className="py-3 px-4 text-center" title="First Segment Playable">Segment</th>
                <th className="py-3 px-4 text-center" title="DRM Credentials Verification">DRM</th>
                <th className="py-3 px-4 text-center" title="Proxy capability">Proxy</th>
                <th className="py-3 px-4 text-center" title="IP Geo-restriction detection">Geo</th>
                <th className="py-3 px-4">Diagnostic Details / Error Log</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-800/60 text-sm">
              {logs.length === 0 ? (
                <tr>
                  <td colSpan={10} className="py-12 text-center text-zinc-500 font-medium">
                    No diagnostics logs recorded for this channel.
                  </td>
                </tr>
              ) : (
                logs.map(log => {
                  const date = new Date(log.checked_at);
                  const dateString = date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' }) + ' - ' + date.toLocaleDateString();

                  return (
                    <tr key={log.id} className="hover:bg-zinc-950/20 transition-colors">
                      <td className="py-3.5 px-4 font-semibold text-zinc-300 whitespace-nowrap text-xs">
                        <div className="flex items-center gap-2">
                          <Calendar className="w-3.5 h-3.5 text-zinc-500" />
                          {dateString}
                        </div>
                      </td>

                      <td className="py-3 px-4 text-center">
                        {log.status === 'working' && (
                          <span className="inline-flex items-center gap-0.5 text-[10px] font-bold text-emerald-400 bg-emerald-500/10 border border-emerald-500/20 py-0.5 px-2 rounded-full">
                            <CheckCircle2 className="w-2.5 h-2.5" />
                            WORKING
                          </span>
                        )}
                        {log.status === 'slow' && (
                          <span className="inline-flex items-center gap-0.5 text-[10px] font-bold text-amber-400 bg-amber-500/10 border border-amber-500/20 py-0.5 px-2 rounded-full">
                            <Clock className="w-2.5 h-2.5" />
                            SLOW
                          </span>
                        )}
                        {log.status === 'offline' && (
                          <span className="inline-flex items-center gap-0.5 text-[10px] font-bold text-rose-500 bg-rose-500/10 border border-rose-500/20 py-0.5 px-2 rounded-full">
                            <XCircle className="w-2.5 h-2.5" />
                            OFFLINE
                          </span>
                        )}
                      </td>

                      <td className="py-3 px-4 text-center">
                        <span className={`inline-block text-[11px] font-semibold font-mono py-0.5 px-1.5 rounded-md border ${getResponseSpeedColor(log.response_time)}`}>
                          {log.response_time} ms
                        </span>
                      </td>

                      <td className="py-3 px-4 text-center font-mono text-xs font-semibold text-zinc-400">
                        {log.http_status ? `HTTP ${log.http_status}` : '-'}
                      </td>

                      <td className="py-3 px-4 text-center">
                        <div className="flex items-center justify-center" title={`Playlist status: ${log.playlist_status}`}>
                          {renderCheckIcon(log.playlist_status)}
                        </div>
                      </td>

                      <td className="py-3 px-4 text-center">
                        <div className="flex items-center justify-center" title={`Segment status: ${log.segment_status}`}>
                          {renderCheckIcon(log.segment_status)}
                        </div>
                      </td>

                      <td className="py-3 px-4 text-center">
                        <div className="flex items-center justify-center" title={`DRM status: ${log.drm_status}`}>
                          {renderCheckIcon(log.drm_status)}
                        </div>
                      </td>

                      <td className="py-3 px-4 text-center">
                        <span className={`inline-block text-[10px] font-bold py-0.5 px-1.5 rounded-md ${
                          log.proxy_status === 'Both' 
                            ? 'text-emerald-400 bg-emerald-500/10' 
                            : log.proxy_status === 'Direct'
                            ? 'text-zinc-400 bg-zinc-800'
                            : log.proxy_status === 'Proxy'
                            ? 'text-purple-400 bg-purple-500/10'
                            : 'text-rose-455 bg-rose-500/10 text-rose-500'
                        }`}>
                          {log.proxy_status}
                        </span>
                      </td>

                      <td className="py-3 px-4 text-center">
                        <span className={`inline-block text-[10px] font-bold py-0.5 px-1.5 rounded-md ${
                          log.geo_status === 'OK' 
                            ? 'text-emerald-400 bg-emerald-500/10' 
                            : 'text-rose-400 bg-rose-500/10'
                        }`}>
                          {log.geo_status === 'OK' ? 'No' : 'Blocked'}
                        </span>
                      </td>

                      <td className="py-3.5 px-4 text-xs font-mono text-zinc-400 max-w-sm truncate" title={log.error_message || ''}>
                        {log.error_message || <span className="text-zinc-600">-</span>}
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
