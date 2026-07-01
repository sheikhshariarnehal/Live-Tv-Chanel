'use client';

import React, { useState, useEffect } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import { Plus, Edit2, Trash2, Save, X, Search, Tv, ToggleLeft, ToggleRight, Filter, ChevronLeft, ChevronRight, Check, AlertCircle, Lock, Shield } from 'lucide-react';

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

export default function ChannelManager({ adminToken, onRefreshStats }: ChannelManagerProps) {
  const [channels, setChannels] = useState<Channel[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  // Filter & Search states
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [filterLive, setFilterLive] = useState('all');

  // Pagination states
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 15;

  // Form states
  const [showAddForm, setShowAddForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [formData, setFormData] = useState({
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
  });

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
    } catch (err: any) {
      setError(err.message || 'Failed to fetch channels data');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
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
    setShowAddForm(false);
  };

  const handleCancel = () => {
    setEditingId(null);
    setFormData({
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
      drm_type: 'clearkey',
      drm_kid: '',
      drm_key: '',
      drm_license_url: '',
    });
  };

  const handleSave = async (id: string) => {
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
        .eq('id', id);

      if (updateErr) throw updateErr;

      showNotification('success', 'Channel updated successfully');
      setEditingId(null);
      fetchData();
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to update channel');
    }
  };

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (!formData.id.trim()) {
        showNotification('error', 'Channel ID/Slug is required');
        return;
      }
      if (!formData.name.trim()) {
        showNotification('error', 'Channel Name is required');
        return;
      }
      if (!formData.stream_url.trim()) {
        showNotification('error', 'Stream URL is required');
        return;
      }

      // Check if ID already exists
      const idExists = channels.some(ch => ch.id === formData.id.toLowerCase().trim());
      if (idExists) {
        showNotification('error', 'Channel ID/Slug already exists');
        return;
      }

      const cleanId = formData.id.toLowerCase().replace(/[^a-z0-9-_]/g, '-').trim();

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
      setFormData({
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
        drm_type: 'clearkey',
        drm_kid: '',
        drm_key: '',
        drm_license_url: '',
      });
      setShowAddForm(false);
      fetchData();
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to add channel');
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
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to delete channel');
    }
  };

  const toggleBooleanColumn = async (id: string, column: 'proxy' | 'is_live' | 'is_trending', currentValue: boolean) => {
    try {
      const { error: toggleErr } = await supabaseAdmin
        .from('channels')
        .update({ [column]: !currentValue })
        .eq('id', id);

      if (toggleErr) throw toggleErr;

      // Update state locally to avoid full fetch
      setChannels(prev => prev.map(ch => ch.id === id ? { ...ch, [column]: !currentValue } : ch));
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || `Failed to toggle ${column}`);
    }
  };

  // Filter channels
  const filteredChannels = channels.filter(channel => {
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

  // Pagination calculation
  const totalItems = filteredChannels.length;
  const totalPages = Math.ceil(totalItems / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = Math.min(startIndex + itemsPerPage, totalItems);
  const paginatedChannels = filteredChannels.slice(startIndex, endIndex);

  // Reset page when filters change
  useEffect(() => {
    setCurrentPage(1);
  }, [searchTerm, selectedCategory, filterLive]);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <Tv className="text-purple-400 w-6 h-6" />
            Channel Management
          </h1>
          <p className="text-xs text-zinc-500 mt-1">Configure stream links, CORS proxy routing, and live states</p>
        </div>
        <button
          onClick={() => {
            setShowAddForm(!showAddForm);
            handleCancel();
          }}
          className="flex items-center gap-2 px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200 shadow-lg shadow-purple-500/20 hover:scale-[1.02]"
        >
          {showAddForm ? <X className="w-4 h-4" /> : <Plus className="w-4 h-4" />}
          {showAddForm ? 'Close Form' : 'Add Channel'}
        </button>
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

      {/* Add Form */}
      {showAddForm && (
        <form onSubmit={handleAdd} className="p-6 rounded-2xl glass-panel space-y-4 animate-slideDown">
          <h3 className="text-lg font-semibold text-white">Register New Channel</h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Channel ID / Slug</label>
              <input
                type="text"
                placeholder="e.g. t-sports, gtv"
                value={formData.id}
                onChange={e => setFormData({ ...formData, id: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
                required
              />
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Channel Name</label>
              <input
                type="text"
                placeholder="e.g. T Sports"
                value={formData.name}
                onChange={e => setFormData({ ...formData, name: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
                required
              />
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Category</label>
              <select
                value={formData.category}
                onChange={e => setFormData({ ...formData, category: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              >
                <option value="">-- No Category --</option>
                {categories.map(c => (
                  <option key={c.id} value={c.id}>{c.name}</option>
                ))}
              </select>
            </div>
            <div className="md:col-span-2 space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Stream Source URL (.m3u8)</label>
              <input
                type="text"
                placeholder="https://example.com/live/playlist.m3u8"
                value={formData.stream_url}
                onChange={e => setFormData({ ...formData, stream_url: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
                required
              />
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Logo Image URL</label>
              <input
                type="text"
                placeholder="https://example.com/logo.png"
                value={formData.logo}
                onChange={e => setFormData({ ...formData, logo: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              />
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Stream Quality Tag</label>
              <select
                value={formData.quality}
                onChange={e => setFormData({ ...formData, quality: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              >
                <option value="SD">SD</option>
                <option value="HD">HD</option>
                <option value="FHD">FHD (1080p)</option>
                <option value="4K">4K UHD</option>
              </select>
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Sort Order</label>
              <input
                type="number"
                value={formData.sort_order}
                onChange={e => setFormData({ ...formData, sort_order: Number(e.target.value) })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              />
            </div>
            <div className="flex gap-6 pt-6">
              <label className="flex items-center gap-2 cursor-pointer text-sm text-zinc-300">
                <input
                  type="checkbox"
                  checked={formData.proxy}
                  onChange={e => setFormData({ ...formData, proxy: e.target.checked })}
                  className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500"
                />
                Use CORS Proxy
              </label>
              <label className="flex items-center gap-2 cursor-pointer text-sm text-zinc-300">
                <input
                  type="checkbox"
                  checked={formData.is_live}
                  onChange={e => setFormData({ ...formData, is_live: e.target.checked })}
                  className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500"
                />
                Is Active/Live
              </label>
              <label className="flex items-center gap-2 cursor-pointer text-sm text-zinc-300">
                <input
                  type="checkbox"
                  checked={formData.is_trending}
                  onChange={e => setFormData({ ...formData, is_trending: e.target.checked })}
                  className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500"
                />
                Trending Flag
              </label>
            </div>
          </div>

          {/* DRM Configuration Section */}
          <div className="mt-4 p-4 rounded-xl bg-zinc-900/50 border border-zinc-800 space-y-3">
            <label className="flex items-center gap-2 cursor-pointer text-sm text-zinc-300">
              <input
                type="checkbox"
                checked={formData.drm_enabled}
                onChange={e => setFormData({ ...formData, drm_enabled: e.target.checked })}
                className="rounded border-zinc-700 bg-zinc-950 text-orange-500 focus:ring-orange-500"
              />
              <Shield className="w-4 h-4 text-orange-400" />
              Enable DRM Protection
            </label>

            {formData.drm_enabled && (
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
                <div className="space-y-1">
                  <label className="text-xs font-semibold text-zinc-400">DRM Type</label>
                  <select
                    value={formData.drm_type}
                    onChange={e => setFormData({ ...formData, drm_type: e.target.value as any })}
                    className="w-full p-2.5 rounded-xl glass-input text-sm"
                  >
                    <option value="clearkey">ClearKey (Embedded Keys)</option>
                    <option value="widevine">Widevine (License Server)</option>
                    <option value="playready">PlayReady (Future)</option>
                  </select>
                </div>

                {formData.drm_type === 'clearkey' && (
                  <>
                    <div className="space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">Key ID (KID) — Hex</label>
                      <input
                        type="text"
                        placeholder="f6564ec2aee819046328a0e153be574d"
                        value={formData.drm_kid}
                        onChange={e => setFormData({ ...formData, drm_kid: e.target.value })}
                        className="w-full p-2.5 rounded-xl glass-input text-sm font-mono"
                      />
                    </div>
                    <div className="space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">Content Key — Hex</label>
                      <input
                        type="text"
                        placeholder="ff46a8a1031eb27ef22576a077c98ab7"
                        value={formData.drm_key}
                        onChange={e => setFormData({ ...formData, drm_key: e.target.value })}
                        className="w-full p-2.5 rounded-xl glass-input text-sm font-mono"
                      />
                    </div>
                  </>
                )}

                {formData.drm_type === 'widevine' && (
                  <div className="md:col-span-2 space-y-1">
                    <label className="text-xs font-semibold text-zinc-400">License Server URL</label>
                    <input
                      type="text"
                      placeholder="https://license.provider.com/widevine"
                      value={formData.drm_license_url}
                      onChange={e => setFormData({ ...formData, drm_license_url: e.target.value })}
                      className="w-full p-2.5 rounded-xl glass-input text-sm font-mono"
                    />
                  </div>
                )}
              </div>
            )}
          </div>

          <button
            type="submit"
            className="px-5 py-2.5 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200"
          >
            Save Channel
          </button>
        </form>
      )}

      {/* Main Grid Filters & Table */}
      <div className="p-6 rounded-2xl glass-panel space-y-4">
        {/* Filters Panel */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          {/* Search */}
          <div className="md:col-span-2 relative">
            <Search className="absolute left-3 top-3 w-4 h-4 text-zinc-500" />
            <input
              type="text"
              placeholder="Search by name, ID, slug, or stream URL..."
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 rounded-xl glass-input text-sm"
            />
          </div>

          {/* Category Filter */}
          <div className="relative">
            <Filter className="absolute left-3 top-3 w-4 h-4 text-zinc-500" />
            <select
              value={selectedCategory}
              onChange={e => setSelectedCategory(e.target.value)}
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
            <Filter className="absolute left-3 top-3 w-4 h-4 text-zinc-500" />
            <select
              value={filterLive}
              onChange={e => setFilterLive(e.target.value)}
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
            {/* Desktop Table View */}
            <div className="hidden md:block overflow-x-auto">
              <table className="w-full border-collapse text-left text-sm text-zinc-400">
                <thead>
                  <tr className="border-b border-zinc-800 text-zinc-500 text-xs">
                    <th className="py-3 px-3">Order</th>
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
                  {paginatedChannels.map((channel) => {
                    const isEditing = editingId === channel.id;
                    return (
                      <tr key={channel.id} className="hover:bg-zinc-900/30 transition-colors">
                        {/* Sort Order */}
                        <td className="py-3 px-3">
                          {isEditing ? (
                            <input
                              type="number"
                              value={formData.sort_order}
                              onChange={e => setFormData({ ...formData, sort_order: Number(e.target.value) })}
                              className="w-16 p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                            />
                          ) : (
                            <span className="font-mono text-zinc-500">{channel.sort_order}</span>
                          )}
                        </td>

                        {/* Info & Logo */}
                        <td className="py-3 px-3">
                          <div className="flex items-center gap-3">
                            <div className="w-9 h-9 rounded-lg bg-zinc-950 border border-zinc-800 overflow-hidden flex items-center justify-center flex-shrink-0">
                              {channel.logo ? (
                                <img src={channel.logo} alt="" className="w-full h-full object-contain" onError={(e) => { (e.target as HTMLElement).style.display = 'none'; }} />
                              ) : (
                                <Tv className="w-4 h-4 text-zinc-600" />
                              )}
                            </div>
                            <div className="truncate max-w-[160px]">
                              {isEditing ? (
                                <div className="space-y-1">
                                  <input
                                    type="text"
                                    value={formData.name}
                                    onChange={e => setFormData({ ...formData, name: e.target.value })}
                                    className="w-full p-1 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                                    placeholder="Name"
                                  />
                                  <input
                                    type="text"
                                    value={formData.logo}
                                    onChange={e => setFormData({ ...formData, logo: e.target.value })}
                                    className="w-full p-1 rounded bg-zinc-950 border border-zinc-800 text-[10px] text-zinc-400"
                                    placeholder="Logo URL"
                                  />
                                </div>
                              ) : (
                                <>
                                  <p className="font-semibold text-white truncate">{channel.name}</p>
                                  <p className="text-[10px] font-mono text-zinc-500 truncate">{channel.id}</p>
                                </>
                              )}
                            </div>
                            <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400">
                              {isEditing ? (
                                <select
                                  value={formData.quality}
                                  onChange={e => setFormData({ ...formData, quality: e.target.value })}
                                  className="bg-zinc-950 text-white text-[9px] border border-zinc-800 rounded"
                                >
                                  <option value="SD">SD</option>
                                  <option value="HD">HD</option>
                                  <option value="FHD">FHD</option>
                                  <option value="4K">4K</option>
                                </select>
                              ) : (
                                channel.quality || 'HD'
                              )}
                            </span>
                          </div>
                        </td>

                        {/* Category */}
                        <td className="py-3 px-3">
                          {isEditing ? (
                            <select
                              value={formData.category}
                              onChange={e => setFormData({ ...formData, category: e.target.value })}
                              className="p-1 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                            >
                              <option value="">None</option>
                              {categories.map(c => (
                                <option key={c.id} value={c.id}>{c.name}</option>
                              ))}
                            </select>
                          ) : (
                            <span className="text-xs text-zinc-300 bg-purple-950/20 border border-purple-900/30 px-2 py-0.5 rounded-full">
                              {categories.find(c => c.id === channel.category)?.name || channel.category || '—'}
                            </span>
                          )}
                        </td>

                        {/* Stream URL */}
                        <td className="py-3 px-3 font-mono text-xs max-w-[200px] truncate">
                          {isEditing ? (
                            <input
                              type="text"
                              value={formData.stream_url}
                              onChange={e => setFormData({ ...formData, stream_url: e.target.value })}
                              className="w-full p-1 rounded bg-zinc-950 border border-zinc-800 text-xs text-white font-mono"
                            />
                          ) : (
                            <span title={channel.stream_url}>{channel.stream_url}</span>
                          )}
                        </td>

                        {/* DRM Badge */}
                        <td className="py-3 px-3 text-center">
                          {channel.drm ? (
                            <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-orange-950/30 border border-orange-900/40 text-orange-400 text-[9px] font-bold">
                              <Lock className="w-2.5 h-2.5" />
                              {channel.drm.type.toUpperCase()}
                            </span>
                          ) : (
                            <span className="text-zinc-600 text-[10px]">—</span>
                          )}
                        </td>

                        {/* Toggle: Proxy */}
                        <td className="py-3 px-3 text-center">
                          {isEditing ? (
                            <input
                              type="checkbox"
                              checked={formData.proxy}
                              onChange={e => setFormData({ ...formData, proxy: e.target.checked })}
                            />
                          ) : (
                            <button
                              onClick={() => toggleBooleanColumn(channel.id, 'proxy', channel.proxy)}
                              className="focus:outline-none transition-colors cursor-pointer"
                            >
                              {channel.proxy ? (
                                <ToggleRight className="w-6 h-6 text-purple-400" />
                              ) : (
                                <ToggleLeft className="w-6 h-6 text-zinc-600" />
                              )}
                            </button>
                          )}
                        </td>

                        {/* Toggle: Active / Live */}
                        <td className="py-3 px-3 text-center">
                          {isEditing ? (
                            <input
                              type="checkbox"
                              checked={formData.is_live}
                              onChange={e => setFormData({ ...formData, is_live: e.target.checked })}
                            />
                          ) : (
                            <button
                              onClick={() => toggleBooleanColumn(channel.id, 'is_live', channel.is_live)}
                              className="focus:outline-none transition-colors cursor-pointer"
                            >
                              {channel.is_live ? (
                                <ToggleRight className="w-6 h-6 text-emerald-400" />
                              ) : (
                                <ToggleLeft className="w-6 h-6 text-zinc-600" />
                              )}
                            </button>
                          )}
                        </td>

                        {/* Toggle: Trending */}
                        <td className="py-3 px-3 text-center">
                          {isEditing ? (
                            <input
                              type="checkbox"
                              checked={formData.is_trending}
                              onChange={e => setFormData({ ...formData, is_trending: e.target.checked })}
                            />
                          ) : (
                            <button
                              onClick={() => toggleBooleanColumn(channel.id, 'is_trending', channel.is_trending)}
                              className="focus:outline-none transition-colors cursor-pointer"
                            >
                              {channel.is_trending ? (
                                <ToggleRight className="w-6 h-6 text-pink-400" />
                              ) : (
                                <ToggleLeft className="w-6 h-6 text-zinc-600" />
                              )}
                            </button>
                          )}
                        </td>

                        {/* Action Buttons */}
                        <td className="py-3 px-3 text-right">
                          {isEditing ? (
                            <div className="flex justify-end gap-2">
                              <button
                                onClick={() => handleSave(channel.id)}
                                className="p-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg transition-colors cursor-pointer"
                              >
                                <Save className="w-3.5 h-3.5" />
                              </button>
                              <button
                                onClick={handleCancel}
                                className="p-2 bg-zinc-850 hover:bg-zinc-750 text-zinc-400 hover:text-white rounded-lg transition-colors cursor-pointer"
                              >
                                <X className="w-3.5 h-3.5" />
                              </button>
                            </div>
                          ) : (
                            <div className="flex justify-end gap-1.5">
                              <button
                                onClick={() => handleEdit(channel)}
                                className="p-1.5 bg-zinc-900 hover:bg-zinc-800 text-purple-400 hover:text-white rounded-lg border border-zinc-800 hover:border-zinc-700 transition-colors cursor-pointer"
                              >
                                <Edit2 className="w-3.5 h-3.5" />
                              </button>
                              <button
                                onClick={() => handleDelete(channel.id)}
                                className="p-1.5 bg-zinc-900 hover:bg-red-950/40 text-red-400 hover:text-red-300 rounded-lg border border-zinc-800 hover:border-red-900/50 transition-colors cursor-pointer"
                              >
                                <Trash2 className="w-3.5 h-3.5" />
                              </button>
                            </div>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>

            {/* Mobile Card View */}
            <div className="block md:hidden space-y-4">
              {paginatedChannels.map((channel) => {
                const isEditing = editingId === channel.id;
                return (
                  <div key={channel.id} className="p-4 rounded-xl bg-zinc-900/40 border border-zinc-805 space-y-3">
                    <div className="flex justify-between items-start border-b border-zinc-800/60 pb-2.5">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-lg bg-zinc-950 border border-zinc-800 overflow-hidden flex items-center justify-center flex-shrink-0">
                          {channel.logo ? (
                            <img src={channel.logo} alt="" className="w-full h-full object-contain" onError={(e) => { (e.target as HTMLElement).style.display = 'none'; }} />
                          ) : (
                            <Tv className="w-4 h-4 text-zinc-600" />
                          )}
                        </div>
                        <div>
                          {isEditing ? (
                            <input
                              type="text"
                              value={formData.name}
                              onChange={e => setFormData({ ...formData, name: e.target.value })}
                              className="p-1 rounded bg-zinc-950 border border-zinc-800 text-xs text-white w-32 mb-1"
                              placeholder="Name"
                            />
                          ) : (
                            <h4 className="font-bold text-white text-sm">{channel.name}</h4>
                          )}
                          <span className="font-mono text-[9px] text-zinc-500 block truncate max-w-[120px]">{channel.id}</span>
                        </div>
                      </div>
                      
                      {isEditing ? (
                        <div className="flex gap-1.5">
                          <button
                            onClick={() => handleSave(channel.id)}
                            className="p-1.5 bg-emerald-600 text-white rounded-lg cursor-pointer"
                            title="Save"
                          >
                            <Save className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={handleCancel}
                            className="p-1.5 bg-zinc-800 text-zinc-400 rounded-lg cursor-pointer"
                            title="Cancel"
                          >
                            <X className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      ) : (
                        <div className="flex gap-1.5">
                          <button
                            onClick={() => handleEdit(channel)}
                            className="p-1.5 bg-zinc-950 hover:bg-zinc-850 text-purple-400 hover:text-white rounded-lg border border-zinc-800 cursor-pointer"
                            title="Edit"
                          >
                            <Edit2 className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={() => handleDelete(channel.id)}
                            className="p-1.5 bg-zinc-950 hover:bg-red-950/20 text-red-400 hover:text-red-300 rounded-lg border border-zinc-800 cursor-pointer"
                            title="Delete"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      )}
                    </div>

                    <div className="grid grid-cols-2 gap-x-4 gap-y-2 text-xs">
                      <div>
                        <span className="text-zinc-500 block mb-0.5">Category</span>
                        {isEditing ? (
                          <select
                            value={formData.category}
                            onChange={e => setFormData({ ...formData, category: e.target.value })}
                            className="p-1 rounded bg-zinc-950 border border-zinc-800 text-xs text-white w-full"
                          >
                            <option value="">None</option>
                            {categories.map(c => (
                              <option key={c.id} value={c.id}>{c.name}</option>
                            ))}
                          </select>
                        ) : (
                          <span className="text-zinc-300 font-medium">
                            {categories.find(c => c.id === channel.category)?.name || channel.category || '—'}
                          </span>
                        )}
                      </div>

                      <div>
                        <span className="text-zinc-500 block mb-0.5">Quality / Order</span>
                        <div className="flex items-center gap-1.5">
                          {isEditing ? (
                            <>
                              <select
                                value={formData.quality}
                                onChange={e => setFormData({ ...formData, quality: e.target.value })}
                                className="p-1 bg-zinc-950 text-white text-xs border border-zinc-850 rounded"
                              >
                                <option value="SD">SD</option>
                                <option value="HD">HD</option>
                                <option value="FHD">FHD</option>
                                <option value="4K">4K</option>
                              </select>
                              <input
                                type="number"
                                value={formData.sort_order}
                                onChange={e => setFormData({ ...formData, sort_order: Number(e.target.value) })}
                                className="w-12 p-1 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                              />
                            </>
                          ) : (
                            <>
                              <span className="px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-400 font-bold text-[9px]">
                                {channel.quality || 'HD'}
                              </span>
                              <span className="text-zinc-500 font-mono">#{channel.sort_order}</span>
                            </>
                          )}
                        </div>
                      </div>

                      <div className="col-span-2">
                        <span className="text-zinc-500 block mb-0.5">Stream URL</span>
                        {isEditing ? (
                          <input
                            type="text"
                            value={formData.stream_url}
                            onChange={e => setFormData({ ...formData, stream_url: e.target.value })}
                            className="w-full p-1 rounded bg-zinc-950 border border-zinc-800 text-xs text-white font-mono"
                          />
                        ) : (
                          <div className="font-mono text-zinc-400 bg-zinc-950/40 p-1.5 rounded border border-zinc-850/60 truncate" title={channel.stream_url}>
                            {channel.stream_url}
                          </div>
                        )}
                      </div>

                      {/* DRM info (read mode) */}
                      {!isEditing && channel.drm && (
                        <div className="col-span-2">
                          <span className="text-zinc-500 block mb-0.5">DRM</span>
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-orange-950/30 border border-orange-900/40 text-orange-400 text-[10px] font-bold">
                            <Lock className="w-2.5 h-2.5" />
                            {channel.drm.type.toUpperCase()}
                            {channel.drm.kid && ` · KID: ${channel.drm.kid.substring(0, 8)}…`}
                          </span>
                        </div>
                      )}

                      {isEditing && (
                        <div className="col-span-2">
                          <span className="text-zinc-500 block mb-1">Logo URL</span>
                          <input
                            type="text"
                            value={formData.logo}
                            onChange={e => setFormData({ ...formData, logo: e.target.value })}
                            className="w-full p-1 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                          />
                        </div>
                      )}

                      {/* DRM config (edit mode) */}
                      {isEditing && (
                        <div className="col-span-2 mt-1 p-2 rounded-lg bg-zinc-950/40 border border-zinc-850/60 space-y-2">
                          <label className="flex items-center gap-2 cursor-pointer text-xs text-zinc-300">
                            <input
                              type="checkbox"
                              checked={formData.drm_enabled}
                              onChange={e => setFormData({ ...formData, drm_enabled: e.target.checked })}
                              className="rounded border-zinc-700 bg-zinc-950"
                            />
                            <Lock className="w-3 h-3 text-orange-400" />
                            DRM Protection
                          </label>
                          {formData.drm_enabled && (
                            <div className="space-y-2">
                              <select
                                value={formData.drm_type}
                                onChange={e => setFormData({ ...formData, drm_type: e.target.value as any })}
                                className="w-full p-1 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                              >
                                <option value="clearkey">ClearKey</option>
                                <option value="widevine">Widevine</option>
                              </select>
                              {formData.drm_type === 'clearkey' && (
                                <>
                                  <input
                                    type="text"
                                    placeholder="KID (hex)"
                                    value={formData.drm_kid}
                                    onChange={e => setFormData({ ...formData, drm_kid: e.target.value })}
                                    className="w-full p-1 rounded bg-zinc-950 border border-zinc-800 text-[10px] text-white font-mono"
                                  />
                                  <input
                                    type="text"
                                    placeholder="Key (hex)"
                                    value={formData.drm_key}
                                    onChange={e => setFormData({ ...formData, drm_key: e.target.value })}
                                    className="w-full p-1 rounded bg-zinc-950 border border-zinc-800 text-[10px] text-white font-mono"
                                  />
                                </>
                              )}
                              {formData.drm_type === 'widevine' && (
                                <input
                                  type="text"
                                  placeholder="License Server URL"
                                  value={formData.drm_license_url}
                                  onChange={e => setFormData({ ...formData, drm_license_url: e.target.value })}
                                  className="w-full p-1 rounded bg-zinc-950 border border-zinc-800 text-[10px] text-white font-mono"
                                />
                              )}
                            </div>
                          )}
                        </div>
                      )}


                      <div className="col-span-2 flex justify-between items-center bg-zinc-950/20 p-2 rounded-lg border border-zinc-850/60 mt-1">
                        <div className="flex flex-col items-center gap-1">
                          <span className="text-[10px] text-zinc-500">Proxy</span>
                          {isEditing ? (
                            <input
                              type="checkbox"
                              checked={formData.proxy}
                              onChange={e => setFormData({ ...formData, proxy: e.target.checked })}
                            />
                          ) : (
                            <button
                              onClick={() => toggleBooleanColumn(channel.id, 'proxy', channel.proxy)}
                              className="focus:outline-none cursor-pointer"
                            >
                              {channel.proxy ? (
                                <ToggleRight className="w-5 h-5 text-purple-400" />
                              ) : (
                                <ToggleLeft className="w-5 h-5 text-zinc-600" />
                              )}
                            </button>
                          )}
                        </div>

                        <div className="flex flex-col items-center gap-1">
                          <span className="text-[10px] text-zinc-500">Active</span>
                          {isEditing ? (
                            <input
                              type="checkbox"
                              checked={formData.is_live}
                              onChange={e => setFormData({ ...formData, is_live: e.target.checked })}
                            />
                          ) : (
                            <button
                              onClick={() => toggleBooleanColumn(channel.id, 'is_live', channel.is_live)}
                              className="focus:outline-none cursor-pointer"
                            >
                              {channel.is_live ? (
                                <ToggleRight className="w-5 h-5 text-emerald-400" />
                              ) : (
                                <ToggleLeft className="w-5 h-5 text-zinc-600" />
                              )}
                            </button>
                          )}
                        </div>

                        <div className="flex flex-col items-center gap-1">
                          <span className="text-[10px] text-zinc-500">Trending</span>
                          {isEditing ? (
                            <input
                              type="checkbox"
                              checked={formData.is_trending}
                              onChange={e => setFormData({ ...formData, is_trending: e.target.checked })}
                            />
                          ) : (
                            <button
                              onClick={() => toggleBooleanColumn(channel.id, 'is_trending', channel.is_trending)}
                              className="focus:outline-none cursor-pointer"
                            >
                              {channel.is_trending ? (
                                <ToggleRight className="w-5 h-5 text-pink-400" />
                              ) : (
                                <ToggleLeft className="w-5 h-5 text-zinc-600" />
                              )}
                            </button>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
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
                className="p-2 rounded-lg bg-zinc-900 border border-zinc-850 text-zinc-400 disabled:opacity-30 disabled:hover:bg-zinc-900 hover:bg-zinc-800 transition-all"
              >
                <ChevronLeft className="w-4 h-4" />
              </button>
              <button
                onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
                disabled={currentPage === totalPages}
                className="p-2 rounded-lg bg-zinc-900 border border-zinc-850 text-zinc-400 disabled:opacity-30 disabled:hover:bg-zinc-900 hover:bg-zinc-800 transition-all"
              >
                <ChevronRight className="w-4 h-4" />
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
