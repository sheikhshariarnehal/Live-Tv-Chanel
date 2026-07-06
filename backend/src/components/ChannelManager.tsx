'use client';

import React, { useState, useEffect, useMemo } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import {
  Plus, Edit2, Trash2, Save, X, Search, Tv, ToggleLeft, ToggleRight,
  Filter, ChevronLeft, ChevronRight, Check, AlertCircle, Lock, Shield,
  Copy, ExternalLink, Layers, Activity, Star, Eye
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

interface ChannelManagerProps {
  adminToken: string;
  onRefreshStats: () => void;
}

const INITIAL_FORM_STATE = {
  id: '',
  name: '',
  logo: '',
  category: '',
  quality: 'HD',
  stream_url: '',
  proxy: false,
  is_live: true,
  is_trending: false,
  sort_order: 0,
  drm_enabled: false,
  drm_type: 'clearkey' as 'clearkey' | 'widevine' | 'playready',
  drm_kid: '',
  drm_key: '',
  drm_license_url: '',
};

export default function ChannelManager({ adminToken, onRefreshStats }: ChannelManagerProps) {
  const [channels, setChannels] = useState<Channel[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  // View state: 'table' or 'grid'
  const [viewMode, setViewMode] = useState<'table' | 'grid'>('table');

  // Filter & Search states
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [filterLive, setFilterLive] = useState('all');

  // Pagination states
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 12;

  // Form modal states
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [formData, setFormData] = useState(INITIAL_FORM_STATE);

  // Copied URL state
  const [copiedUrl, setCopiedUrl] = useState<string | null>(null);

  const supabaseAdmin = createAdminSupabaseClient(adminToken);

  const fetchData = async () => {
    try {
      setLoading(true);
      setError(null);

      // Fetch Categories
      const { data: catData, error: catErr } = await supabaseAdmin
        .from('categories')
        .select('id, name')
        .order('sort_order', { ascending: true });

      if (catErr) throw catErr;
      setCategories(catData || []);

      // Fetch Channels
      const { data: chData, error: chErr } = await supabaseAdmin
        .from('channels')
        .select('*')
        .order('sort_order', { ascending: true });

      if (chErr) throw chErr;
      setChannels(chData || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch channels data');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminToken]);

  const showNotification = (type: 'success' | 'error', msg: string) => {
    if (type === 'success') {
      setSuccess(msg);
      setTimeout(() => setSuccess(null), 3000);
    } else {
      setError(msg);
      setTimeout(() => setError(null), 4000);
    }
  };

  const handleEdit = (channel: Channel) => {
    setEditingId(channel.id);
    setFormData({
      id: channel.id,
      name: channel.name,
      logo: channel.logo || '',
      category: channel.category || '',
      quality: channel.quality || 'HD',
      stream_url: channel.stream_url,
      proxy: channel.proxy,
      is_live: channel.is_live,
      is_trending: channel.is_trending,
      sort_order: channel.sort_order,
      drm_enabled: !!channel.drm,
      drm_type: channel.drm?.type || 'clearkey',
      drm_kid: channel.drm?.kid || '',
      drm_key: channel.drm?.key || '',
      drm_license_url: channel.drm?.licenseUrl || '',
    });
    setIsFormOpen(true);
  };

  const handleCancel = () => {
    setEditingId(null);
    setFormData(INITIAL_FORM_STATE);
    setIsFormOpen(false);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (!formData.name.trim()) {
        showNotification('error', 'Channel name is required');
        return;
      }
      if (!formData.stream_url.trim()) {
        showNotification('error', 'Stream URL is required');
        return;
      }

      // Build DRM config or null
      const drmConfig = formData.drm_enabled ? {
        type: formData.drm_type,
        ...(formData.drm_type === 'clearkey' ? {
          kid: formData.drm_kid.trim(),
          key: formData.drm_key.trim(),
        } : {
          licenseUrl: formData.drm_license_url.trim(),
        }),
      } : null;

      if (editingId) {
        // Update mode
        const { error: updateErr } = await supabaseAdmin
          .from('channels')
          .update({
            name: formData.name.trim(),
            logo: formData.logo.trim() || null,
            category: formData.category || null,
            quality: formData.quality,
            stream_url: formData.stream_url.trim(),
            proxy: formData.proxy,
            is_live: formData.is_live,
            is_trending: formData.is_trending,
            sort_order: Number(formData.sort_order),
            drm: drmConfig,
          })
          .eq('id', editingId);

        if (updateErr) throw updateErr;
        showNotification('success', 'Channel updated successfully');
      } else {
        // Add mode
        if (!formData.id.trim()) {
          showNotification('error', 'Channel ID/Slug is required');
          return;
        }
        const cleanId = formData.id.toLowerCase().replace(/[^a-z0-9-_]/g, '-').trim();

        // Check if ID already exists
        const idExists = channels.some(ch => ch.id === cleanId);
        if (idExists) {
          showNotification('error', 'Channel ID/Slug already exists');
          return;
        }

        const { error: insertErr } = await supabaseAdmin
          .from('channels')
          .insert({
            id: cleanId,
            name: formData.name.trim(),
            logo: formData.logo.trim() || null,
            category: formData.category || null,
            quality: formData.quality,
            stream_url: formData.stream_url.trim(),
            proxy: formData.proxy,
            is_live: formData.is_live,
            is_trending: formData.is_trending,
            sort_order: Number(formData.sort_order) || channels.length + 1,
            drm: drmConfig,
          });

        if (insertErr) throw insertErr;
        showNotification('success', 'Channel added successfully');
      }

      handleCancel();
      fetchData();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to save channel');
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm(`Are you sure you want to delete channel "${id}"?`)) {
      return;
    }

    try {
      const { error: deleteErr } = await supabaseAdmin
        .from('channels')
        .delete()
        .eq('id', id);

      if (deleteErr) throw deleteErr;

      showNotification('success', 'Channel deleted successfully');
      fetchData();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to delete channel');
    }
  };

  const toggleBooleanColumn = async (id: string, column: 'proxy' | 'is_live' | 'is_trending', currentValue: boolean) => {
    try {
      const { error: toggleErr } = await supabaseAdmin
        .from('channels')
        .update({ [column]: !currentValue })
        .eq('id', id);

      if (toggleErr) throw toggleErr;

      setChannels(prev => prev.map(ch => ch.id === id ? { ...ch, [column]: !currentValue } : ch));
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : `Failed to toggle ${column}`);
    }
  };

  const copyToClipboard = (url: string) => {
    navigator.clipboard.writeText(url);
    setCopiedUrl(url);
    setTimeout(() => setCopiedUrl(null), 2000);
  };

  // Stats calculation
  const stats = useMemo(() => {
    return {
      total: channels.length,
      active: channels.filter(c => c.is_live).length,
      trending: channels.filter(c => c.is_trending).length,
      drm: channels.filter(c => c.drm).length,
    };
  }, [channels]);

  // Filter channels
  const filteredChannels = useMemo(() => {
    return channels.filter(channel => {
      const matchesSearch =
        channel.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        channel.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
        channel.stream_url.toLowerCase().includes(searchTerm.toLowerCase());

      const matchesCategory = selectedCategory === 'all' || channel.category === selectedCategory;

      const matchesLive =
        filterLive === 'all' ||
        (filterLive === 'live' && channel.is_live) ||
        (filterLive === 'offline' && !channel.is_live) ||
        (filterLive === 'trending' && channel.is_trending) ||
        (filterLive === 'proxy' && channel.proxy) ||
        (filterLive === 'drm' && !!channel.drm);

      return matchesSearch && matchesCategory && matchesLive;
    });
  }, [channels, searchTerm, selectedCategory, filterLive]);

  // Pagination calculation
  const totalItems = filteredChannels.length;
  const totalPages = Math.ceil(totalItems / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = Math.min(startIndex + itemsPerPage, totalItems);
  const paginatedChannels = useMemo(() => {
    return filteredChannels.slice(startIndex, endIndex);
  }, [filteredChannels, startIndex, endIndex]);

  const [selectedChannelIds, setSelectedChannelIds] = useState<string[]>([]);

  const handleSelectRow = (id: string) => {
    setSelectedChannelIds(prev =>
      prev.includes(id) ? prev.filter(item => item !== id) : [...prev, id]
    );
  };

  const handleSelectAll = () => {
    const pageIds = paginatedChannels.map(ch => ch.id);
    const allPageSelected = pageIds.length > 0 && pageIds.every(id => selectedChannelIds.includes(id));

    if (allPageSelected) {
      setSelectedChannelIds(prev => prev.filter(id => !pageIds.includes(id)));
    } else {
      setSelectedChannelIds(prev => {
        const otherSelected = prev.filter(id => !pageIds.includes(id));
        return [...otherSelected, ...pageIds];
      });
    }
  };

  const handleBulkDelete = async () => {
    if (!confirm(`Are you sure you want to delete the ${selectedChannelIds.length} selected channels?`)) {
      return;
    }

    try {
      setLoading(true);
      const { error: deleteErr } = await supabaseAdmin
        .from('channels')
        .delete()
        .in('id', selectedChannelIds);

      if (deleteErr) throw deleteErr;

      showNotification('success', `${selectedChannelIds.length} channels deleted successfully`);
      setSelectedChannelIds([]);
      fetchData();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to delete selected channels');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      {/* Stats Counter Section */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="p-4 rounded-2xl bg-zinc-900 border border-zinc-800 shadow-md flex items-center gap-4">
          <div className="w-12 h-12 rounded-xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400">
            <Tv className="w-6 h-6" />
          </div>
          <div>
            <span className="text-xs text-zinc-500 font-semibold block">Total Channels</span>
            <span className="text-2xl font-bold text-white">{stats.total}</span>
          </div>
        </div>

        <div className="p-4 rounded-2xl bg-zinc-900 border border-zinc-800 shadow-md flex items-center gap-4">
          <div className="w-12 h-12 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400">
            <Activity className="w-6 h-6 animate-pulse" />
          </div>
          <div>
            <span className="text-xs text-zinc-500 font-semibold block">Active Streams</span>
            <span className="text-2xl font-bold text-white">{stats.active}</span>
          </div>
        </div>

        <div className="p-4 rounded-2xl bg-zinc-900 border border-zinc-800 shadow-md flex items-center gap-4">
          <div className="w-12 h-12 rounded-xl bg-orange-500/10 border border-orange-500/20 flex items-center justify-center text-orange-400">
            <Lock className="w-6 h-6" />
          </div>
          <div>
            <span className="text-xs text-zinc-500 font-semibold block">DRM Protected</span>
            <span className="text-2xl font-bold text-white">{stats.drm}</span>
          </div>
        </div>

        <div className="p-4 rounded-2xl bg-zinc-900 border border-zinc-800 shadow-md flex items-center gap-4">
          <div className="w-12 h-12 rounded-xl bg-pink-500/10 border border-pink-500/20 flex items-center justify-center text-pink-400">
            <Star className="w-6 h-6" />
          </div>
          <div>
            <span className="text-xs text-zinc-500 font-semibold block">Trending</span>
            <span className="text-2xl font-bold text-white">{stats.trending}</span>
          </div>
        </div>
      </div>

      {/* Header and Controls */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-zinc-900/40 p-4 rounded-2xl border border-zinc-800/60">
        <div>
          <h1 className="text-xl font-bold text-white flex items-center gap-2">
            Channel Directory
          </h1>
          <p className="text-xs text-zinc-500 mt-0.5">Manage live streaming sources, CORS proxy bypass and content protection DRM</p>
        </div>
        <div className="flex gap-2">
          {/* View Mode Switcher */}
          <div className="flex items-center bg-zinc-950 p-1 rounded-lg border border-zinc-800">
            <button
              onClick={() => setViewMode('table')}
              className={`p-1.5 rounded-md text-xs font-semibold transition ${viewMode === 'table' ? 'bg-zinc-800 text-white' : 'text-zinc-500 hover:text-zinc-300'}`}
              title="Dense Table"
            >
              Table
            </button>
            <button
              onClick={() => setViewMode('grid')}
              className={`p-1.5 rounded-md text-xs font-semibold transition ${viewMode === 'grid' ? 'bg-zinc-800 text-white' : 'text-zinc-500 hover:text-zinc-300'}`}
              title="Cards Grid"
            >
              Cards
            </button>
          </div>
          <button
            onClick={() => {
              setEditingId(null);
              setFormData(INITIAL_FORM_STATE);
              setIsFormOpen(true);
            }}
            className="flex items-center gap-2 px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200 shadow-lg shadow-purple-500/20 hover:scale-[1.02]"
          >
            <Plus className="w-4 h-4" />
            Add Channel
          </button>
        </div>
      </div>

      {/* Notifications */}
      {error && (
        <div className="p-4 rounded-xl bg-red-950/40 border border-red-900/50 text-red-400 text-sm flex items-center gap-2 animate-shake">
          <AlertCircle className="w-4 h-4 flex-shrink-0" />
          <span>{error}</span>
        </div>
      )}
      {success && (
        <div className="p-4 rounded-xl bg-emerald-950/40 border border-emerald-900/50 text-emerald-400 text-sm flex items-center gap-2 animate-fadeIn">
          <Check className="w-4 h-4 flex-shrink-0" />
          <span>{success}</span>
        </div>
      )}

      {/* Main Grid Filters & Table */}
      <div className="p-6 rounded-2xl bg-zinc-900 border border-zinc-800 shadow-xl space-y-4">
        {/* Filters Panel */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          {/* Search */}
          <div className="md:col-span-2 relative">
            <Search className="absolute left-3 top-3.5 w-4 h-4 text-zinc-500" />
            <input
              type="text"
              placeholder="Search by name, ID, slug, or stream URL..."
              value={searchTerm}
              onChange={e => {
                setSearchTerm(e.target.value);
                setCurrentPage(1);
                setSelectedChannelIds([]);
              }}
              className="w-full pl-9 pr-4 py-2.5 rounded-xl glass-input text-sm"
            />
          </div>

          {/* Category Filter */}
          <div className="relative">
            <Filter className="absolute left-3 top-3.5 w-4 h-4 text-zinc-500" />
            <select
              value={selectedCategory}
              onChange={e => {
                setSelectedCategory(e.target.value);
                setCurrentPage(1);
                setSelectedChannelIds([]);
              }}
              className="w-full pl-9 pr-4 py-2.5 rounded-xl glass-input text-sm appearance-none"
            >
              <option value="all">All Categories</option>
              {categories.map(c => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
          </div>

          {/* Status Filter */}
          <div className="relative">
            <Filter className="absolute left-3 top-3.5 w-4 h-4 text-zinc-500" />
            <select
              value={filterLive}
              onChange={e => {
                setFilterLive(e.target.value);
                setCurrentPage(1);
                setSelectedChannelIds([]);
              }}
              className="w-full pl-9 pr-4 py-2.5 rounded-xl glass-input text-sm appearance-none"
            >
              <option value="all">All Channels</option>
              <option value="live">Only Active</option>
              <option value="offline">Only Offline</option>
              <option value="trending">Only Trending</option>
              <option value="proxy">Only Proxied</option>
              <option value="drm">Only DRM</option>
            </select>
          </div>
        </div>

        {/* Counter Info */}
        <div className="text-xs text-zinc-500">
          Showing <span className="text-zinc-300 font-medium">{totalItems === 0 ? 0 : startIndex + 1}</span> to{' '}
          <span className="text-zinc-300 font-medium">{endIndex}</span> of{' '}
          <span className="text-purple-400 font-semibold">{totalItems}</span> matching channels
        </div>

        {/* Loading / Content */}
        {loading ? (
          <div className="text-center py-12 text-zinc-500">Loading channels library...</div>
        ) : paginatedChannels.length === 0 ? (
          <div className="text-center py-12 text-zinc-500">No channels match selected filters.</div>
        ) : (
          <div className="space-y-4">
            {/* Bulk Action Bar */}
            {selectedChannelIds.length > 0 && (
              <div className="flex items-center justify-between p-3.5 bg-red-950/20 border border-red-900/40 rounded-xl animate-fadeIn">
                <div className="flex items-center gap-2 text-red-400 text-xs font-semibold">
                  <AlertCircle className="w-4 h-4 text-red-400 animate-pulse" />
                  <span>{selectedChannelIds.length} channels selected</span>
                </div>
                <button
                  onClick={handleBulkDelete}
                  className="flex items-center gap-1.5 px-3 py-1.5 bg-red-605 hover:bg-red-700 text-white rounded-lg text-xs font-semibold transition cursor-pointer"
                >
                  <Trash2 className="w-3.5 h-3.5" />
                  Delete Selected
                </button>
              </div>
            )}

            {/* Desktop Table View */}
            {viewMode === 'table' ? (
              <div className="overflow-x-auto">
                <table className="w-full border-collapse text-left text-sm text-zinc-400">
                  <thead>
                    <tr className="border-b border-zinc-800 text-zinc-500 text-xs uppercase tracking-wider">
                      <th className="py-3 px-3 w-8">
                        <input
                          type="checkbox"
                          checked={paginatedChannels.length > 0 && paginatedChannels.every(ch => selectedChannelIds.includes(ch.id))}
                          onChange={handleSelectAll}
                          className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500 cursor-pointer"
                        />
                      </th>
                      <th className="py-3 px-3 w-16">Order</th>
                      <th className="py-3 px-3">Channel Info</th>
                      <th className="py-3 px-3">Category</th>
                      <th className="py-3 px-3">Stream URL</th>
                      <th className="py-3 px-3 text-center">DRM</th>
                      <th className="py-3 px-3 text-center">Proxy</th>
                      <th className="py-3 px-3 text-center">Active</th>
                      <th className="py-3 px-3 text-center">Trending</th>
                      <th className="py-3 px-3 text-right">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-zinc-800/40">
                    {paginatedChannels.map((channel) => (
                      <tr key={channel.id} className="hover:bg-zinc-800/30 transition-colors group">
                        <td className="py-3.5 px-3">
                          <input
                            type="checkbox"
                            checked={selectedChannelIds.includes(channel.id)}
                            onChange={() => handleSelectRow(channel.id)}
                            className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500 cursor-pointer"
                          />
                        </td>
                        {/* Sort Order */}
                        <td className="py-3.5 px-3">
                          <span className="font-mono text-zinc-500">#{channel.sort_order}</span>
                        </td>

                        {/* Info & Logo */}
                        <td className="py-3.5 px-3">
                          <div className="flex items-center gap-3">
                            <div className="w-10 h-10 rounded-lg bg-zinc-950 border border-zinc-800 overflow-hidden flex items-center justify-center flex-shrink-0">
                              {channel.logo ? (
                                <img src={channel.logo} alt="" className="w-full h-full object-contain" onError={(e) => { (e.target as HTMLElement).style.display = 'none'; }} />
                              ) : (
                                <Tv className="w-5 h-5 text-zinc-660" />
                              )}
                            </div>
                            <div className="truncate max-w-[180px]">
                              <p className="font-semibold text-white truncate text-xs">{channel.name}</p>
                              <p className="text-[10px] font-mono text-zinc-500 truncate">{channel.id}</p>
                            </div>
                            <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-zinc-850 text-zinc-400">
                              {channel.quality || 'HD'}
                            </span>
                          </div>
                        </td>

                        {/* Category */}
                        <td className="py-3.5 px-3">
                          <span className="text-[10px] text-purple-300 bg-purple-950/40 border border-purple-500/20 px-2 py-0.5 rounded-full font-semibold">
                            {categories.find(c => c.id === channel.category)?.name || channel.category || 'Uncategorized'}
                          </span>
                        </td>

                        {/* Stream URL */}
                        <td className="py-3.5 px-3 font-mono text-xs max-w-[240px] truncate relative">
                          <div className="flex items-center gap-1.5">
                            <span className="truncate text-zinc-400" title={channel.stream_url}>{channel.stream_url}</span>
                            <button
                              onClick={() => copyToClipboard(channel.stream_url)}
                              className="opacity-0 group-hover:opacity-100 p-1 rounded hover:bg-zinc-800 text-zinc-500 hover:text-white transition-all cursor-pointer flex-shrink-0"
                              title="Copy URL"
                            >
                              {copiedUrl === channel.stream_url ? (
                                <Check className="w-3.5 h-3.5 text-emerald-400" />
                              ) : (
                                <Copy className="w-3.5 h-3.5" />
                              )}
                            </button>
                          </div>
                        </td>

                        {/* DRM Badge */}
                        <td className="py-3.5 px-3 text-center">
                          {channel.drm ? (
                            <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-orange-950/40 border border-orange-500/20 text-orange-400 text-[9px] font-bold uppercase">
                              <Lock className="w-2.5 h-2.5" />
                              {channel.drm.type}
                            </span>
                          ) : (
                            <span className="text-zinc-700 text-[10px]">—</span>
                          )}
                        </td>

                        {/* Toggle: Proxy */}
                        <td className="py-3.5 px-3 text-center">
                          <button
                            onClick={() => toggleBooleanColumn(channel.id, 'proxy', channel.proxy)}
                            className="focus:outline-none transition-colors cursor-pointer"
                          >
                            {channel.proxy ? (
                              <ToggleRight className="w-6 h-6 text-purple-400" />
                            ) : (
                              <ToggleLeft className="w-6 h-6 text-zinc-700" />
                            )}
                          </button>
                        </td>

                        {/* Toggle: Active / Live */}
                        <td className="py-3.5 px-3 text-center">
                          <button
                            onClick={() => toggleBooleanColumn(channel.id, 'is_live', channel.is_live)}
                            className="focus:outline-none transition-colors cursor-pointer"
                          >
                            {channel.is_live ? (
                              <ToggleRight className="w-6 h-6 text-emerald-400" />
                            ) : (
                              <ToggleLeft className="w-6 h-6 text-zinc-700" />
                            )}
                          </button>
                        </td>

                        {/* Toggle: Trending */}
                        <td className="py-3.5 px-3 text-center">
                          <button
                            onClick={() => toggleBooleanColumn(channel.id, 'is_trending', channel.is_trending)}
                            className="focus:outline-none transition-colors cursor-pointer"
                          >
                            {channel.is_trending ? (
                              <ToggleRight className="w-6 h-6 text-pink-400" />
                            ) : (
                              <ToggleLeft className="w-6 h-6 text-zinc-700" />
                            )}
                          </button>
                        </td>

                        {/* Action Buttons */}
                        <td className="py-3.5 px-3 text-right">
                          <div className="flex justify-end gap-1.5">
                            <button
                              onClick={() => handleEdit(channel)}
                              className="p-1.5 bg-zinc-950 hover:bg-zinc-800 text-purple-400 hover:text-white rounded-lg border border-zinc-800 hover:border-zinc-700 transition-colors cursor-pointer"
                              title="Edit Channel"
                            >
                              <Edit2 className="w-3.5 h-3.5" />
                            </button>
                            <button
                              onClick={() => handleDelete(channel.id)}
                              className="p-1.5 bg-zinc-950 hover:bg-red-950/40 text-red-400 hover:text-red-300 rounded-lg border border-zinc-800 hover:border-red-900/50 transition-colors cursor-pointer"
                              title="Delete Channel"
                            >
                              <Trash2 className="w-3.5 h-3.5" />
                            </button>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              /* Grid / Card view */
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                {paginatedChannels.map((channel) => (
                  <div key={channel.id} className="p-4 rounded-xl bg-zinc-950/60 border border-zinc-850 hover:border-zinc-750 transition-all flex flex-col justify-between space-y-3 group relative">
                    {/* Corner multi-select checkbox */}
                    <div className="absolute top-3 left-3">
                      <input
                        type="checkbox"
                        checked={selectedChannelIds.includes(channel.id)}
                        onChange={() => handleSelectRow(channel.id)}
                        className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500 cursor-pointer"
                      />
                    </div>

                    {/* Logo and Metadata */}
                    <div className="flex items-start gap-3 pl-6">
                      <div className="w-12 h-12 rounded-xl bg-zinc-900 border border-zinc-800 flex-shrink-0 overflow-hidden flex items-center justify-center">
                        {channel.logo ? (
                          <img src={channel.logo} alt="" className="w-full h-full object-contain" onError={(e) => { (e.target as HTMLElement).style.display = 'none'; }} />
                        ) : (
                          <Tv className="w-5 h-5 text-zinc-650" />
                        )}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1.5">
                          <h4 className="font-bold text-white text-sm truncate">{channel.name}</h4>
                          <span className="text-[8px] font-extrabold px-1 py-0.5 rounded bg-zinc-800 text-zinc-400">
                            {channel.quality || 'HD'}
                          </span>
                        </div>
                        <span className="font-mono text-[10px] text-zinc-500 block truncate">{channel.id}</span>
                        <span className="text-[9px] text-purple-300 bg-purple-950/40 border border-purple-500/20 px-1.5 py-0.5 rounded-full font-semibold mt-1 inline-block">
                          {categories.find(c => c.id === channel.category)?.name || channel.category || 'Uncategorized'}
                        </span>
                      </div>
                    </div>

                    {/* Stream URL */}
                    <div className="space-y-1 bg-zinc-900/60 p-2.5 rounded-lg border border-zinc-900">
                      <span className="text-[10px] text-zinc-500 font-semibold block">STREAM SOURCE</span>
                      <div className="flex items-center justify-between gap-2 font-mono text-[11px]">
                        <span className="text-zinc-400 truncate" title={channel.stream_url}>{channel.stream_url}</span>
                        <button
                          onClick={() => copyToClipboard(channel.stream_url)}
                          className="p-1 rounded hover:bg-zinc-800 text-zinc-500 hover:text-white transition-all cursor-pointer flex-shrink-0"
                        >
                          {copiedUrl === channel.stream_url ? (
                            <Check className="w-3 h-3 text-emerald-400" />
                          ) : (
                            <Copy className="w-3 h-3" />
                          )}
                        </button>
                      </div>
                    </div>

                    {/* DRM details */}
                    {channel.drm && (
                      <div className="flex items-center gap-1.5 text-[10px] text-orange-400 bg-orange-950/20 border border-orange-900/40 p-1.5 rounded-lg">
                        <Lock className="w-3 h-3" />
                        <span>DRM: <span className="font-bold uppercase">{channel.drm.type}</span></span>
                        {channel.drm.kid && <span className="font-mono text-orange-500/80">({channel.drm.kid.slice(0, 8)}…)</span>}
                      </div>
                    )}

                    {/* Footer toggles and actions */}
                    <div className="flex items-center justify-between border-t border-zinc-900 pt-3">
                      <div className="flex gap-4">
                        <div className="flex flex-col items-center">
                          <span className="text-[9px] text-zinc-655 font-semibold uppercase">Proxy</span>
                          <button onClick={() => toggleBooleanColumn(channel.id, 'proxy', channel.proxy)} className="cursor-pointer">
                            {channel.proxy ? <ToggleRight className="w-5 h-5 text-purple-400" /> : <ToggleLeft className="w-5 h-5 text-zinc-800" />}
                          </button>
                        </div>
                        <div className="flex flex-col items-center">
                          <span className="text-[9px] text-zinc-655 font-semibold uppercase">Active</span>
                          <button onClick={() => toggleBooleanColumn(channel.id, 'is_live', channel.is_live)} className="cursor-pointer">
                            {channel.is_live ? <ToggleRight className="w-5 h-5 text-emerald-400" /> : <ToggleLeft className="w-5 h-5 text-zinc-800" />}
                          </button>
                        </div>
                        <div className="flex flex-col items-center">
                          <span className="text-[9px] text-zinc-655 font-semibold uppercase">Trending</span>
                          <button onClick={() => toggleBooleanColumn(channel.id, 'is_trending', channel.is_trending)} className="cursor-pointer">
                            {channel.is_trending ? <ToggleRight className="w-5 h-5 text-pink-400" /> : <ToggleLeft className="w-5 h-5 text-zinc-800" />}
                          </button>
                        </div>
                      </div>

                      <div className="flex gap-1.5 self-end">
                        <button
                          onClick={() => handleEdit(channel)}
                          className="p-1.5 bg-zinc-900 hover:bg-zinc-850 text-purple-400 border border-zinc-800 rounded-lg cursor-pointer"
                          title="Edit"
                        >
                          <Edit2 className="w-3.5 h-3.5" />
                        </button>
                        <button
                          onClick={() => handleDelete(channel.id)}
                          className="p-1.5 bg-zinc-900 hover:bg-red-950/30 text-red-400 border border-zinc-800 rounded-lg cursor-pointer"
                          title="Delete"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Pagination Controls */}
        {totalPages > 1 && (
          <div className="flex justify-between items-center pt-4 border-t border-zinc-800">
            <span className="text-xs text-zinc-500">
              Page {currentPage} of {totalPages}
            </span>
            <div className="flex gap-2">
              <button
                onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
                disabled={currentPage === 1}
                className="p-2 rounded-lg bg-zinc-950 border border-zinc-800 text-zinc-400 disabled:opacity-30 disabled:hover:bg-zinc-950 hover:bg-zinc-900 transition-all cursor-pointer"
              >
                <ChevronLeft className="w-4 h-4" />
              </button>
              <button
                onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
                disabled={currentPage === totalPages}
                className="p-2 rounded-lg bg-zinc-950 border border-zinc-800 text-zinc-400 disabled:opacity-30 disabled:hover:bg-zinc-950 hover:bg-zinc-900 transition-all cursor-pointer"
              >
                <ChevronRight className="w-4 h-4" />
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Redesigned Full Screen Form Modal for Add & Edit */}
      {isFormOpen && (
        <div className="fixed inset-0 bg-zinc-950 z-50 flex flex-col w-screen h-screen animate-fadeIn">
          {/* Header */}
          <div className="flex items-center justify-between p-5 border-b border-zinc-800 flex-shrink-0 bg-zinc-900">
            <div>
              <h2 className="text-lg font-bold text-white flex items-center gap-2">
                <Tv className="w-5 h-5 text-purple-400" />
                {editingId ? 'Edit Streaming Channel' : 'Register New Channel'}
              </h2>
              <p className="text-[11px] text-zinc-500 mt-0.5">
                {editingId ? `Channel Slug: ${editingId}` : 'Set up a new live broadcast source'}
              </p>
            </div>
            <button
              onClick={handleCancel}
              className="p-2 rounded-lg hover:bg-zinc-850 text-zinc-400 hover:text-white transition-all border border-zinc-850 cursor-pointer"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Form Content split into 2 Columns */}
          <form onSubmit={handleSave} className="flex-1 overflow-y-auto bg-zinc-950">
            <div className="grid grid-cols-1 lg:grid-cols-5 gap-0 min-h-full">
              {/* Left Column: Metadata & Core parameters (3/5 width) */}
              <div className="lg:col-span-3 p-6 space-y-6 lg:border-r border-zinc-850 bg-zinc-900/40">
                <div className="space-y-4">
                  <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-500">Channel Identity</h3>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">Channel ID / Slug</label>
                      <input
                        type="text"
                        placeholder="e.g. t-sports, gtv"
                        value={formData.id}
                        onChange={e => setFormData({ ...formData, id: e.target.value })}
                        className="w-full p-2.5 rounded-lg glass-input text-sm font-mono"
                        required
                        disabled={!!editingId}
                      />
                    </div>

                    <div className="space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">Display Name</label>
                      <input
                        type="text"
                        placeholder="e.g. T Sports HD"
                        value={formData.name}
                        onChange={e => setFormData({ ...formData, name: e.target.value })}
                        className="w-full p-2.5 rounded-lg glass-input text-sm"
                        required
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div className="space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">Category</label>
                      <select
                        value={formData.category}
                        onChange={e => setFormData({ ...formData, category: e.target.value })}
                        className="w-full p-2.5 rounded-lg glass-input text-sm"
                      >
                        <option value="">-- No Category --</option>
                        {categories.map(c => (
                          <option key={c.id} value={c.id}>{c.name}</option>
                        ))}
                      </select>
                    </div>

                    <div className="space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">Broadcast Quality</label>
                      <select
                        value={formData.quality}
                        onChange={e => setFormData({ ...formData, quality: e.target.value })}
                        className="w-full p-2.5 rounded-lg glass-input text-sm"
                      >
                        <option value="SD">SD (Standard)</option>
                        <option value="HD">HD (High Definition)</option>
                        <option value="FHD">FHD (1080p Full HD)</option>
                        <option value="4K">4K Ultra HD</option>
                      </select>
                    </div>

                    <div className="space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">Sort Priority Order</label>
                      <input
                        type="number"
                        value={formData.sort_order}
                        onChange={e => setFormData({ ...formData, sort_order: Number(e.target.value) })}
                        className="w-full p-2.5 rounded-lg glass-input text-sm"
                      />
                    </div>
                  </div>
                </div>

                <div className="border-t border-zinc-850" />

                {/* Section 2: Logo and Branding */}
                <div className="space-y-4">
                  <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-500">Logo & Branding</h3>
                  <div className="flex gap-4 items-start">
                    <div className="w-20 h-20 bg-zinc-950 border border-zinc-800 rounded-xl overflow-hidden flex items-center justify-center flex-shrink-0">
                      {formData.logo ? (
                        // eslint-disable-next-line @next/next/no-img-element
                        <img src={formData.logo} alt="Logo preview" className="w-full h-full object-contain" onError={(e) => { (e.target as HTMLElement).style.display = 'none'; }} />
                      ) : (
                        <Tv className="w-8 h-8 text-zinc-750" />
                      )}
                    </div>
                    <div className="flex-1 space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">Logo Image Link</label>
                      <input
                        type="text"
                        placeholder="https://example.com/logo.png"
                        value={formData.logo}
                        onChange={e => setFormData({ ...formData, logo: e.target.value })}
                        className="w-full p-2.5 rounded-lg glass-input text-sm"
                      />
                      <p className="text-[10px] text-zinc-500">Provide a transparent PNG link for best results.</p>
                    </div>
                  </div>
                </div>

                <div className="border-t border-zinc-850" />

                {/* Toggles */}
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  <label className="flex items-center gap-3 p-3 rounded-lg bg-zinc-950/40 border border-zinc-850 hover:border-purple-500/20 transition cursor-pointer select-none">
                    <input
                      type="checkbox"
                      checked={formData.proxy}
                      onChange={e => setFormData({ ...formData, proxy: e.target.checked })}
                      className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500"
                    />
                    <div>
                      <span className="text-xs text-zinc-300 font-semibold block">CORS Proxy Routing</span>
                      <span className="text-[9px] text-zinc-500 block">Bypass CORS header restrictions</span>
                    </div>
                  </label>

                  <label className="flex items-center gap-3 p-3 rounded-lg bg-zinc-950/40 border border-zinc-850 hover:border-emerald-500/20 transition cursor-pointer select-none">
                    <input
                      type="checkbox"
                      checked={formData.is_live}
                      onChange={e => setFormData({ ...formData, is_live: e.target.checked })}
                      className="rounded border-zinc-700 bg-zinc-950 text-emerald-600 focus:ring-emerald-500"
                    />
                    <div>
                      <span className="text-xs text-zinc-300 font-semibold block">Active Channel</span>
                      <span className="text-[9px] text-zinc-500 block">Show and enable playback on apps</span>
                    </div>
                  </label>

                  <label className="flex items-center gap-3 p-3 rounded-lg bg-zinc-950/40 border border-zinc-850 hover:border-pink-500/20 transition cursor-pointer select-none">
                    <input
                      type="checkbox"
                      checked={formData.is_trending}
                      onChange={e => setFormData({ ...formData, is_trending: e.target.checked })}
                      className="rounded border-zinc-700 bg-zinc-950 text-pink-600 focus:ring-pink-500"
                    />
                    <div>
                      <span className="text-xs text-zinc-300 font-semibold block">Trending Flag</span>
                      <span className="text-[9px] text-zinc-500 block">Highlight in spotlight suggestions</span>
                    </div>
                  </label>
                </div>
              </div>

              {/* Right Column: Stream Configuration & DRM Settings (2/5 width) */}
              <div className="lg:col-span-2 p-6 space-y-6 bg-zinc-900/20">
                <div className="space-y-4">
                  <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-500">Stream Connection</h3>
                  
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-zinc-400">Stream Source URL (.m3u8 / .mpd)</label>
                    <textarea
                      placeholder="https://example.com/live/stream.m3u8"
                      value={formData.stream_url}
                      onChange={e => setFormData({ ...formData, stream_url: e.target.value })}
                      className="w-full h-24 p-2.5 rounded-lg glass-input text-xs font-mono resize-none focus:outline-none"
                      required
                    />
                  </div>
                </div>

                <div className="border-t border-zinc-850" />

                {/* DRM Configuration */}
                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-500 flex items-center gap-1.5">
                      <Shield className="w-3.5 h-3.5 text-orange-400" />
                      DRM Protection
                    </h3>
                    <label className="relative inline-flex items-center cursor-pointer">
                      <input
                        type="checkbox"
                        checked={formData.drm_enabled}
                        onChange={e => setFormData({ ...formData, drm_enabled: e.target.checked })}
                        className="sr-only peer"
                      />
                      <div className="w-9 h-5 bg-zinc-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-zinc-400 after:border-zinc-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-orange-500"></div>
                    </label>
                  </div>

                  {formData.drm_enabled && (
                    <div className="space-y-4 p-4 rounded-xl bg-zinc-950 border border-zinc-850 animate-fadeIn">
                      <div className="space-y-1">
                        <label className="text-xs font-semibold text-zinc-400">DRM Access Type</label>
                        <select
                          value={formData.drm_type}
                          onChange={e => setFormData({ ...formData, drm_type: e.target.value as 'clearkey' | 'widevine' | 'playready' })}
                          className="w-full p-2.5 rounded-lg glass-input text-sm"
                        >
                          <option value="clearkey">ClearKey (Hex Keypair)</option>
                          <option value="widevine">Widevine Modular (License Server)</option>
                          <option value="playready">PlayReady (Microsoft)</option>
                        </select>
                      </div>

                      {formData.drm_type === 'clearkey' && (
                        <div className="space-y-3">
                          <div className="space-y-1">
                            <label className="text-xs font-semibold text-zinc-400">Key ID (KID) — 32 Hex Characters</label>
                            <input
                              type="text"
                              placeholder="e.g. 1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d"
                              value={formData.drm_kid}
                              onChange={e => setFormData({ ...formData, drm_kid: e.target.value })}
                              className="w-full p-2.5 rounded-lg glass-input text-xs font-mono"
                              required={formData.drm_enabled && formData.drm_type === 'clearkey'}
                            />
                          </div>

                          <div className="space-y-1">
                            <label className="text-xs font-semibold text-zinc-400">Content Key — 32 Hex Characters</label>
                            <input
                              type="text"
                              placeholder="e.g. f1e2d3c4b5a698877665544332211000"
                              value={formData.drm_key}
                              onChange={e => setFormData({ ...formData, drm_key: e.target.value })}
                              className="w-full p-2.5 rounded-lg glass-input text-xs font-mono"
                              required={formData.drm_enabled && formData.drm_type === 'clearkey'}
                            />
                          </div>
                        </div>
                      )}

                      {formData.drm_type === 'widevine' && (
                        <div className="space-y-1 animate-fadeIn">
                          <label className="text-xs font-semibold text-zinc-400">Widevine License Server URL</label>
                          <input
                            type="text"
                            placeholder="https://license.provider.com/widevine"
                            value={formData.drm_license_url}
                            onChange={e => setFormData({ ...formData, drm_license_url: e.target.value })}
                            className="w-full p-2.5 rounded-lg glass-input text-xs font-mono"
                            required={formData.drm_enabled && formData.drm_type === 'widevine'}
                          />
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>
            </div>
          </form>

          {/* Footer controls */}
          <div className="p-5 border-t border-zinc-800 bg-zinc-900 flex items-center justify-end gap-3 flex-shrink-0">
            <button
              type="button"
              onClick={handleCancel}
              className="py-2.5 px-6 rounded-xl border border-zinc-800 text-zinc-400 hover:text-white hover:border-zinc-650 text-sm font-semibold transition-all cursor-pointer"
            >
              Cancel
            </button>
            <button
              type="submit"
              onClick={handleSave}
              className="py-2.5 px-8 rounded-xl bg-purple-600 hover:bg-purple-700 text-white text-sm font-semibold transition-all shadow-lg shadow-purple-500/20 flex items-center justify-center gap-2 cursor-pointer"
            >
              <Save className="w-4 h-4" />
              {editingId ? 'Save Changes' : 'Register Channel'}
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
