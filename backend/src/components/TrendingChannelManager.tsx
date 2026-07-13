'use client';

import React, { useState, useEffect, useMemo, useRef, useCallback } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import {
  TrendingUp, Plus, Trash2, X, Search, Tv, GripVertical,
  ChevronUp, ChevronDown, Layers, Check, AlertCircle,
  Loader2, Sparkles, Radio
} from 'lucide-react';

interface DrmConfig {
  type: 'clearkey' | 'widevine' | 'playready';
  kid?: string;
  key?: string;
  licenseUrl?: string;
  headers?: Record<string, string>;
}

interface Channel {
  id: string;
  name: string;
  logo: string | null;
  category: string | null;
  quality: string | null;
  stream_url: string;
  proxy: boolean;
  is_live: boolean;
  is_trending: boolean;
  sort_order: number;
  drm: DrmConfig | null;
}

interface Category {
  id: string;
  name: string;
}

interface TrendingChannelManagerProps {
  adminToken: string;
  onRefreshStats: () => void;
}

export default function TrendingChannelManager({ adminToken, onRefreshStats }: TrendingChannelManagerProps) {
  // trendingOrderRef = always-current source of truth (synchronous reads, no stale closures)
  // trendingOrder state = mirrors ref, used only for React rendering
  const [trendingOrder, setTrendingOrder] = useState<Channel[]>([]);
  const trendingOrderRef = useRef<Channel[]>([]);

  // draggedIndexRef = synchronous source of truth for current dragged item index
  const [draggedIndex, setDraggedIndex] = useState<number | null>(null);
  const draggedIndexRef = useRef<number | null>(null);

  const [availableChannels, setAvailableChannels] = useState<Channel[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [syncing, setSyncing] = useState(false);

  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [limit, setLimit] = useState(50);

  const supabaseAdmin = createAdminSupabaseClient(adminToken);

  // Atomically update both ref and state together
  const applyTrendingOrder = useCallback((newOrder: Channel[]) => {
    trendingOrderRef.current = newOrder;
    setTrendingOrder([...newOrder]);
  }, []);

  const fetchData = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const { data: catData, error: catErr } = await supabaseAdmin
        .from('categories')
        .select('id, name')
        .order('name', { ascending: true });
      if (catErr) throw catErr;
      setCategories(catData || []);

      const BATCH_SIZE = 1000;
      let offset = 0;
      const allChannels: Channel[] = [];
      while (true) {
        const { data: chData, error: chErr } = await supabaseAdmin
          .from('channels')
          .select('*')
          .order('sort_order', { ascending: true })
          .order('id', { ascending: true })
          .range(offset, offset + BATCH_SIZE - 1);
        if (chErr) throw chErr;
        const batch = chData || [];
        allChannels.push(...batch);
        if (batch.length < BATCH_SIZE) break;
        offset += BATCH_SIZE;
      }

      const trending = allChannels
        .filter(c => c.is_trending)
        .sort((a, b) => a.sort_order !== b.sort_order ? a.sort_order - b.sort_order : a.id.localeCompare(b.id));

      applyTrendingOrder(trending);
      setAvailableChannels(allChannels.filter(c => !c.is_trending));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to retrieve channels database.');
    } finally {
      setLoading(false);
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminToken]);

  useEffect(() => { fetchData(); }, [fetchData]);

  const showNotification = useCallback((type: 'success' | 'error', msg: string) => {
    if (type === 'success') {
      setSuccess(msg);
      setTimeout(() => setSuccess(null), 3000);
    } else {
      setError(msg);
      setTimeout(() => setError(null), 4000);
    }
  }, []);

  // Persist ONLY sort_order to DB - targeted updates, never overwrites server fields
  const persistOrder = useCallback(async (orderedList: Channel[]) => {
    setSyncing(true);
    try {
      const withNewOrders = orderedList.map((ch, idx) => ({ ...ch, sort_order: idx + 1 }));
      applyTrendingOrder(withNewOrders);

      const results = await Promise.all(
        withNewOrders.map(ch =>
          supabaseAdmin
            .from('channels')
            .update({ sort_order: ch.sort_order })
            .eq('id', ch.id)
        )
      );

      const firstError = results.find(r => r.error)?.error;
      if (firstError) throw firstError;

      showNotification('success', 'Order saved.');
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Database sync failed.');
      fetchData();
    } finally {
      setSyncing(false);
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminToken, applyTrendingOrder, showNotification, onRefreshStats]);

  // Move via buttons - reads from ref, never stale even with rapid clicks
  const moveChannel = useCallback((index: number, direction: 'up' | 'down') => {
    const current = trendingOrderRef.current;
    const targetIndex = direction === 'up' ? index - 1 : index + 1;
    if (targetIndex < 0 || targetIndex >= current.length) return;

    const reordered = [...current];
    const temp = reordered[index];
    reordered[index] = reordered[targetIndex];
    reordered[targetIndex] = temp;

    // Instant visual feedback via ref+state update
    applyTrendingOrder(reordered);
    // Persist to DB
    persistOrder(reordered);
  }, [applyTrendingOrder, persistOrder]);

  const handleDragStart = useCallback((e: React.DragEvent, index: number) => {
    draggedIndexRef.current = index;
    setDraggedIndex(index);
    e.dataTransfer.effectAllowed = 'move';
  }, []);

  // onDragEnter fires ONCE per row when dragged item enters it - much more reliable than onDragOver
  const handleDragEnter = useCallback((e: React.DragEvent, overIndex: number) => {
    e.preventDefault();
    const currentDragIdx = draggedIndexRef.current;
    if (currentDragIdx === null || currentDragIdx === overIndex) return;

    const current = [...trendingOrderRef.current];
    const draggedItem = current[currentDragIdx];
    if (!draggedItem) return;

    current.splice(currentDragIdx, 1);
    current.splice(overIndex, 0, draggedItem);

    // Update refs synchronously first
    draggedIndexRef.current = overIndex;

    // Then trigger re-render
    applyTrendingOrder(current);
    setDraggedIndex(overIndex);
  }, [applyTrendingOrder]);

  const handleDragOver = useCallback((e: React.DragEvent) => {
    // Must call preventDefault to allow drop
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
  }, []);

  const handleDrop = useCallback((e: React.DragEvent) => {
    e.preventDefault();
  }, []);

  const handleDragEnd = useCallback(async () => {
    draggedIndexRef.current = null;
    setDraggedIndex(null);
    await persistOrder(trendingOrderRef.current);
  }, [persistOrder]);

  const handleAddToTrending = useCallback(async (channel: Channel) => {
    const newSortOrder = trendingOrderRef.current.length + 1;
    const updated = { ...channel, is_trending: true, sort_order: newSortOrder };
    applyTrendingOrder([...trendingOrderRef.current, updated]);
    setAvailableChannels(prev => prev.filter(c => c.id !== channel.id));

    setSyncing(true);
    try {
      const { error: updateErr } = await supabaseAdmin
        .from('channels')
        .update({ is_trending: true, sort_order: newSortOrder })
        .eq('id', channel.id);
      if (updateErr) throw updateErr;
      showNotification('success', `"${channel.name}" added to Trending`);
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to add channel.');
      fetchData();
    } finally {
      setSyncing(false);
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminToken, applyTrendingOrder, showNotification, onRefreshStats]);

  const handleRemoveFromTrending = useCallback(async (channel: Channel) => {
    const remaining = trendingOrderRef.current.filter(c => c.id !== channel.id);
    applyTrendingOrder(remaining);
    setAvailableChannels(prev => [...prev, { ...channel, is_trending: false }]);

    setSyncing(true);
    try {
      const { error: updateErr } = await supabaseAdmin
        .from('channels')
        .update({ is_trending: false })
        .eq('id', channel.id);
      if (updateErr) throw updateErr;
      await persistOrder(remaining);
      showNotification('success', `"${channel.name}" removed from Trending`);
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to remove channel.');
      fetchData();
    } finally {
      setSyncing(false);
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminToken, applyTrendingOrder, persistOrder, showNotification, onRefreshStats]);

  const availableChannelsFiltered = useMemo(() => {
    return availableChannels
      .filter(c => {
        const matchesSearch =
          c.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
          (c.stream_url && c.stream_url.toLowerCase().includes(searchTerm.toLowerCase()));
        const matchesCategory = selectedCategory === 'all' || c.category === selectedCategory;
        return matchesSearch && matchesCategory;
      })
      .sort((a, b) => {
        const n = a.name.localeCompare(b.name);
        return n !== 0 ? n : a.id.localeCompare(b.id);
      });
  }, [availableChannels, searchTerm, selectedCategory]);

  useEffect(() => { setLimit(50); }, [searchTerm, selectedCategory]);

  const totalTrending = trendingOrder.length;
  const liveTrending = trendingOrder.filter(c => c.is_live).length;
  const offlineTrending = totalTrending - liveTrending;

  return (
    <div className="space-y-6 animate-fadeIn">
      {success && (
        <div className="fixed bottom-5 right-5 z-50 flex items-center gap-2.5 bg-emerald-500 text-white font-semibold py-3 px-5 rounded-xl shadow-xl shadow-emerald-500/20 border border-emerald-400/30 animate-slideInRight">
          <Check className="w-4 h-4" /><span>{success}</span>
        </div>
      )}
      {error && (
        <div className="fixed bottom-5 right-5 z-50 flex items-center gap-2.5 bg-red-600 text-white font-semibold py-3 px-5 rounded-xl shadow-xl shadow-red-500/20 border border-red-500/30 animate-slideInRight">
          <AlertCircle className="w-4 h-4" /><span>{error}</span>
        </div>
      )}

      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 p-6 rounded-2xl glass-panel relative overflow-hidden bg-gradient-to-r from-zinc-900/60 to-zinc-950/20">
        <div className="space-y-1">
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <TrendingUp className="w-6 h-6 text-purple-400" />
            Manage Trending Channels
          </h1>
          <p className="text-xs text-zinc-400">Designate channels as trending, reorder their display hierarchy, and control live overrides. Syncs automatically.</p>
        </div>
        <div className="flex items-center gap-2 bg-zinc-950/60 border border-zinc-800/80 px-4 py-2 rounded-xl text-xs select-none">
          {syncing ? (
            <><Loader2 className="w-3.5 h-3.5 text-amber-400 animate-spin" /><span className="text-amber-400 font-medium font-mono animate-pulse">Saving...</span></>
          ) : (
            <><Sparkles className="w-3.5 h-3.5 text-emerald-400" /><span className="text-emerald-400 font-medium font-mono">Live Sync Active</span></>
          )}
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="p-4 rounded-xl glass-panel bg-gradient-to-br from-purple-500/5 to-transparent flex items-center justify-between border-l-2 border-l-purple-500">
          <div>
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Total Trending</span>
            <span className="text-2xl font-bold text-white tabular-nums">{loading ? '...' : totalTrending}</span>
          </div>
          <div className="p-2 bg-purple-500/10 rounded-lg text-purple-400"><TrendingUp className="w-5 h-5" /></div>
        </div>
        <div className="p-4 rounded-xl glass-panel bg-gradient-to-br from-emerald-500/5 to-transparent flex items-center justify-between border-l-2 border-l-emerald-500">
          <div>
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Active Live Streams</span>
            <span className="text-2xl font-bold text-white tabular-nums">{loading ? '...' : liveTrending}</span>
          </div>
          <div className="p-2 bg-emerald-500/10 rounded-lg text-emerald-400"><Radio className="w-5 h-5 animate-pulse" /></div>
        </div>
        <div className="p-4 rounded-xl glass-panel bg-gradient-to-br from-zinc-500/5 to-transparent flex items-center justify-between border-l-2 border-l-zinc-700">
          <div>
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Offline Channels</span>
            <span className="text-2xl font-bold text-white tabular-nums">{loading ? '...' : offlineTrending}</span>
          </div>
          <div className="p-2 bg-zinc-800 rounded-lg text-zinc-400"><Tv className="w-5 h-5" /></div>
        </div>
      </div>

      {loading ? (
        <div className="h-[400px] rounded-2xl glass-panel flex flex-col items-center justify-center gap-3">
          <Loader2 className="w-8 h-8 text-purple-500 animate-spin" />
          <span className="text-sm text-zinc-400 font-semibold">Retrieving channel registry...</span>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
          <div className="lg:col-span-7 space-y-3">
            <div className="flex items-center justify-between px-1">
              <h2 className="text-sm font-bold text-zinc-300 uppercase tracking-wider flex items-center gap-2">
                <Layers className="w-4 h-4 text-purple-400" />
                Active Trending Queue ({totalTrending})
              </h2>
              <span className="text-[10px] text-zinc-500 font-medium">Drag or use arrows to reorder</span>
            </div>

            {trendingOrder.length === 0 ? (
              <div className="h-[320px] rounded-2xl border border-dashed border-zinc-800 flex flex-col items-center justify-center text-center p-6 bg-zinc-950/20">
                <div className="w-12 h-12 rounded-full bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-500 mb-3">
                  <TrendingUp className="w-5 h-5 text-zinc-600" />
                </div>
                <h3 className="text-sm font-semibold text-zinc-300">No channels in trending</h3>
                <p className="text-xs text-zinc-500 max-w-xs mt-1">Search and pick channels from the available pool on the right to list them here.</p>
              </div>
            ) : (
              <div className="space-y-2 select-none max-h-[700px] overflow-y-auto pr-1 font-sans">
                {trendingOrder.map((channel, index) => (
                  <div
                    key={channel.id}
                    draggable
                    onDragStart={(e) => handleDragStart(e, index)}
                    onDragEnter={(e) => handleDragEnter(e, index)}
                    onDragOver={handleDragOver}
                    onDrop={handleDrop}
                    onDragEnd={handleDragEnd}
                    className={`flex items-center justify-between p-3 rounded-xl border transition-all duration-200 group ${
                      draggedIndex === index
                        ? 'bg-purple-950/20 border-purple-500/60 opacity-60 scale-[0.99]'
                        : 'glass-panel hover:bg-zinc-900/60 hover:border-zinc-700/60'
                    }`}
                  >
                    <div className="flex items-center gap-3 min-w-0 flex-1">
                      <div className="cursor-grab active:cursor-grabbing p-1 hover:bg-zinc-800 rounded text-zinc-500 hover:text-zinc-300 transition-colors">
                        <GripVertical className="w-4 h-4" />
                      </div>
                      {channel.logo ? (
                        // eslint-disable-next-line @next/next/no-img-element
                        <img src={channel.logo} alt={channel.name}
                          onError={(e) => { (e.target as HTMLElement).style.display = 'none'; }}
                          className="w-9 h-9 rounded-lg object-contain bg-zinc-950/60 border border-zinc-800/80 p-0.5 flex-shrink-0"
                        />
                      ) : (
                        <div className="w-9 h-9 rounded-lg bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-600 flex-shrink-0">
                          <Tv className="w-4 h-4" />
                        </div>
                      )}
                      <div className="min-w-0 leading-tight">
                        <div className="flex items-center gap-1.5 flex-wrap">
                          <span className="font-semibold text-white text-sm truncate max-w-[200px]">{channel.name}</span>
                          {channel.quality && (
                            <span className="text-[9px] px-1 py-0.5 bg-purple-500/10 border border-purple-500/20 text-purple-400 rounded font-semibold">{channel.quality}</span>
                          )}
                        </div>
                        <div className="flex items-center gap-2 mt-0.5">
                          <span className="text-[10px] text-zinc-500 truncate max-w-[120px]">
                            {categories.find(c => c.id === channel.category)?.name || 'Uncategorized'}
                          </span>
                          <span className="text-[8px] text-zinc-700 font-mono">ID: {channel.id.slice(0, 8)}</span>
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center gap-3 flex-shrink-0">
                      <div className="flex items-center gap-1 bg-zinc-950/60 border border-zinc-800 rounded-lg p-0.5">
                        <button
                          onClick={() => moveChannel(index, 'up')}
                          disabled={index === 0 || syncing}
                          className="p-1 rounded text-zinc-500 hover:text-white disabled:opacity-20 disabled:cursor-not-allowed hover:bg-zinc-800 transition-colors cursor-pointer"
                          title="Move Up"
                        >
                          <ChevronUp className="w-3.5 h-3.5" />
                        </button>
                        <button
                          onClick={() => moveChannel(index, 'down')}
                          disabled={index === trendingOrder.length - 1 || syncing}
                          className="p-1 rounded text-zinc-500 hover:text-white disabled:opacity-20 disabled:cursor-not-allowed hover:bg-zinc-800 transition-colors cursor-pointer"
                          title="Move Down"
                        >
                          <ChevronDown className="w-3.5 h-3.5" />
                        </button>
                      </div>

                      <div className="flex items-center gap-1">
                        <span className="relative flex h-1.5 w-1.5">
                          {channel.is_live && <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>}
                          <span className={`relative inline-flex rounded-full h-1.5 w-1.5 ${channel.is_live ? 'bg-emerald-500' : 'bg-red-500'}`}></span>
                        </span>
                        <span className="text-[10px] font-semibold text-zinc-500 hidden md:inline">{channel.is_live ? 'Live' : 'Offline'}</span>
                      </div>

                      <button
                        onClick={() => handleRemoveFromTrending(channel)}
                        disabled={syncing}
                        className="p-1.5 rounded-lg border border-transparent hover:border-red-950/30 text-zinc-500 hover:text-red-400 hover:bg-red-950/10 disabled:opacity-30 disabled:cursor-not-allowed transition-all cursor-pointer"
                        title="Remove from trending"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          <div className="lg:col-span-5 space-y-3">
            <h2 className="text-sm font-bold text-zinc-300 uppercase tracking-wider flex items-center gap-2 px-1">
              <Plus className="w-4 h-4 text-purple-400" />
              Add Channels to Trending
            </h2>
            <div className="p-4 rounded-2xl glass-panel space-y-4 bg-zinc-900/40">
              <div className="space-y-2.5">
                <div className="relative">
                  <Search className="absolute left-3 top-2.5 w-4 h-4 text-zinc-500" />
                  <input
                    type="text"
                    placeholder="Search available channels..."
                    value={searchTerm}
                    onChange={e => setSearchTerm(e.target.value)}
                    className="w-full pl-9 pr-4 py-2 text-xs rounded-xl glass-input placeholder-zinc-500 focus:outline-none"
                  />
                  {searchTerm && (
                    <button onClick={() => setSearchTerm('')} className="absolute right-3 top-2.5 text-zinc-500 hover:text-white">
                      <X className="w-3.5 h-3.5" />
                    </button>
                  )}
                </div>
                <div className="relative">
                  <select
                    value={selectedCategory}
                    onChange={e => setSelectedCategory(e.target.value)}
                    className="w-full px-3 py-2 text-xs rounded-xl glass-input appearance-none bg-zinc-950/80 cursor-pointer text-zinc-300"
                  >
                    <option value="all">All Categories</option>
                    {categories.map(cat => <option key={cat.id} value={cat.id}>{cat.name}</option>)}
                  </select>
                  <Layers className="absolute right-3 top-2.5 w-3.5 h-3.5 text-zinc-500 pointer-events-none" />
                </div>
              </div>

              <div className="space-y-1.5 max-h-[460px] overflow-y-auto pr-1">
                {availableChannelsFiltered.length === 0 ? (
                  <div className="py-12 text-center text-zinc-500 text-xs">
                    {availableChannels.length === 0 ? 'No channels found in registry.' : 'No matching available channels.'}
                  </div>
                ) : (
                  <>
                    {availableChannelsFiltered.slice(0, limit).map(channel => (
                      <div key={channel.id} className="flex items-center justify-between p-2.5 rounded-xl border border-zinc-800/40 bg-zinc-950/40 hover:bg-zinc-900/40 hover:border-zinc-800 transition-all duration-200">
                        <div className="flex items-center gap-2 min-w-0">
                          {channel.logo ? (
                            // eslint-disable-next-line @next/next/no-img-element
                            <img src={channel.logo} alt={channel.name}
                              onError={(e) => { (e.target as HTMLElement).style.display = 'none'; }}
                              className="w-7 h-7 rounded-md object-contain bg-zinc-900 border border-zinc-800 p-0.5 flex-shrink-0"
                            />
                          ) : (
                            <div className="w-7 h-7 rounded-md bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-600 flex-shrink-0">
                              <Tv className="w-3.5 h-3.5" />
                            </div>
                          )}
                          <div className="min-w-0 leading-tight">
                            <span className="font-medium text-white text-xs block truncate">{channel.name}</span>
                            <span className="text-[9px] text-zinc-500 block truncate font-semibold">
                              {categories.find(c => c.id === channel.category)?.name || 'Uncategorized'}
                            </span>
                          </div>
                        </div>
                        <button
                          onClick={() => handleAddToTrending(channel)}
                          disabled={syncing}
                          className="flex items-center gap-1 py-1 px-2.5 rounded-lg bg-purple-600/10 hover:bg-purple-600 border border-purple-500/20 hover:border-purple-500 text-purple-400 hover:text-white text-[10px] font-bold disabled:opacity-30 disabled:cursor-not-allowed transition-all cursor-pointer"
                        >
                          <Plus className="w-3 h-3" />Add
                        </button>
                      </div>
                    ))}
                    {availableChannelsFiltered.length > limit && (
                      <button
                        onClick={() => setLimit(prev => prev + 50)}
                        className="w-full mt-2 py-2 text-center text-[10px] text-zinc-500 hover:text-purple-400 font-bold bg-zinc-950/20 hover:bg-purple-950/5 border border-zinc-800 hover:border-purple-900/30 rounded-xl transition-all cursor-pointer"
                      >
                        Load More Channels (+50)
                      </button>
                    )}
                  </>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
