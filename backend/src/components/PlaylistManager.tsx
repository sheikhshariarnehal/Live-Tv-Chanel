'use client';

import React, { useState, useEffect, useMemo } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import { 
  Plus, Edit2, Trash2, Save, X, Search, List, Check, AlertCircle,
  ChevronUp, ChevronDown, Folder, Tv, CheckSquare, Square, RefreshCw, GripVertical
} from 'lucide-react';

interface Playlist {
  id: string;
  name: string;
  channels: string[];
}

interface Channel {
  id: string;
  name: string;
  category: string | null;
  logo: string | null;
}

interface Category {
  id: string;
  name: string;
}

interface PlaylistManagerProps {
  adminToken: string;
  onRefreshStats: () => void;
}

export default function PlaylistManager({ adminToken, onRefreshStats }: PlaylistManagerProps) {
  const [playlists, setPlaylists] = useState<Playlist[]>([]);
  const [channels, setChannels] = useState<Channel[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  // Search states
  const [searchTerm, setSearchTerm] = useState('');
  const [channelSearchTerm, setChannelSearchTerm] = useState('');

  // Form states
  const [editingId, setEditingId] = useState<string | null>(null);
  const [formData, setFormData] = useState({
    id: '',
    name: '',
    channels: [] as string[]
  });
  const [isSlugManual, setIsSlugManual] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [showBulkCategories, setShowBulkCategories] = useState(false);
  const [showAddForm, setShowAddForm] = useState(false);
  const [draggedIndex, setDraggedIndex] = useState<number | null>(null);
  const [dragOverIndex, setDragOverIndex] = useState<number | null>(null);

  const supabaseAdmin = createAdminSupabaseClient(adminToken);

  const fetchData = async () => {
    try {
      setLoading(true);
      setError(null);

      // Fetch Playlists and Categories in parallel
      const [plRes, catRes] = await Promise.all([
        supabaseAdmin
          .from('playlists')
          .select('*')
          .order('name', { ascending: true }),
        supabaseAdmin
          .from('categories')
          .select('id, name')
          .order('name', { ascending: true })
      ]);

      if (plRes.error) throw plRes.error;
      if (catRes.error) throw catRes.error;

      setPlaylists(plRes.data || []);
      setCategories(catRes.data || []);

      // Fetch all Channels using pagination (bypass 1000-row PostgREST limit)
      // Optimized query: selecting only required fields (id, name, category, logo)
      const BATCH_SIZE = 1000;
      let offset = 0;
      const allChannels: Channel[] = [];

      while (true) {
        const { data: batch, error: chErr } = await supabaseAdmin
          .from('channels')
          .select('id, name, category, logo')
          .order('name', { ascending: true })
          .range(offset, offset + BATCH_SIZE - 1);

        if (chErr) throw chErr;
        if (!batch || batch.length === 0) break;
        allChannels.push(...batch);

        if (batch.length < BATCH_SIZE) break;
        offset += BATCH_SIZE;
      }

      setChannels(allChannels);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch playlists data');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
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

  const handleEdit = (playlist: Playlist) => {
    setEditingId(playlist.id);
    setFormData({
      id: playlist.id,
      name: playlist.name,
      channels: playlist.channels || []
    });
    setChannelSearchTerm('');
    setSelectedCategory('all');
    setIsSlugManual(false);
    setShowAddForm(true);
  };

  const handleCancel = () => {
    setEditingId(null);
    setFormData({ id: '', name: '', channels: [] });
    setChannelSearchTerm('');
    setSelectedCategory('all');
    setIsSlugManual(false);
    setShowAddForm(false);
  };

  const handleChannelToggle = (channelId: string) => {
    setFormData(prev => {
      const isSelected = prev.channels.includes(channelId);
      if (isSelected) {
        return { ...prev, channels: prev.channels.filter(id => id !== channelId) };
      } else {
        return { ...prev, channels: [...prev.channels, channelId] };
      }
    });
  };

  const moveChannel = (index: number, direction: -1 | 1) => {
    const targetIndex = index + direction;
    if (targetIndex < 0 || targetIndex >= formData.channels.length) return;
    
    setFormData(prev => {
      const updated = [...prev.channels];
      const temp = updated[index];
      updated[index] = updated[targetIndex];
      updated[targetIndex] = temp;
      return { ...prev, channels: updated };
    });
  };

  const handleDragStart = (e: React.DragEvent, index: number) => {
    setDraggedIndex(index);
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/plain', index.toString());
  };

  const handleDragOver = (e: React.DragEvent, index: number) => {
    e.preventDefault();
    if (draggedIndex === null) return;
    if (dragOverIndex !== index) {
      setDragOverIndex(index);
    }
  };

  const handleDragEnd = () => {
    setDraggedIndex(null);
    setDragOverIndex(null);
  };

  const handleDrop = (e: React.DragEvent, targetIndex: number) => {
    e.preventDefault();
    if (draggedIndex === null || draggedIndex === targetIndex) {
      setDraggedIndex(null);
      setDragOverIndex(null);
      return;
    }

    setFormData(prev => {
      const updated = [...prev.channels];
      const draggedId = updated[draggedIndex];
      updated.splice(draggedIndex, 1);
      updated.splice(targetIndex, 0, draggedId);
      return { ...prev, channels: updated };
    });

    setDraggedIndex(null);
    setDragOverIndex(null);
  };

  const handleBulkCategoryToggle = (categoryId: string, selectAll: boolean) => {
    const categoryChannels = channels
      .filter(ch => (ch.category || 'uncategorized') === categoryId)
      .map(ch => ch.id);

    setFormData(prev => {
      let updatedChannels = [...prev.channels];
      if (selectAll) {
        const toAdd = categoryChannels.filter(id => !updatedChannels.includes(id));
        updatedChannels = [...updatedChannels, ...toAdd];
      } else {
        updatedChannels = updatedChannels.filter(id => !categoryChannels.includes(id));
      }
      return { ...prev, channels: updatedChannels };
    });
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (!formData.name.trim()) {
        showNotification('error', 'Playlist name is required');
        return;
      }

      if (editingId) {
        // Edit Mode
        const { error: updateErr } = await supabaseAdmin
          .from('playlists')
          .update({
            name: formData.name.trim(),
            channels: formData.channels
          })
          .eq('id', editingId);

        if (updateErr) throw updateErr;
        showNotification('success', 'Playlist updated successfully');
      } else {
        // Create Mode
        if (!formData.id.trim()) {
          showNotification('error', 'Playlist ID/Slug is required');
          return;
        }

        const cleanId = formData.id.toLowerCase().replace(/[^a-z0-9-_]/g, '-').trim();
        
        const idExists = playlists.some(pl => pl.id === cleanId);
        if (idExists) {
          showNotification('error', 'Playlist ID/Slug already exists');
          return;
        }

        const { error: insertErr } = await supabaseAdmin
          .from('playlists')
          .insert({
            id: cleanId,
            name: formData.name.trim(),
            channels: formData.channels
          });

        if (insertErr) throw insertErr;
        showNotification('success', 'Playlist created successfully');
      }

      handleCancel();
      fetchData();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to save playlist');
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm(`Are you sure you want to delete playlist "${id}"?`)) {
      return;
    }

    try {
      const { error: deleteErr } = await supabaseAdmin
        .from('playlists')
        .delete()
        .eq('id', id);

      if (deleteErr) throw deleteErr;

      showNotification('success', 'Playlist deleted successfully');
      fetchData();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to delete playlist');
    }
  };

  // Filter playlists list
  const filteredPlaylists = playlists.filter(pl => 
    pl.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    pl.id.toLowerCase().includes(searchTerm.toLowerCase())
  );

  // Compute category statistics dynamically
  const categoryStats = useMemo(() => {
    const stats: Record<string, { total: number; selected: number }> = {};
    
    // Initialize
    categories.forEach(cat => {
      stats[cat.id] = { total: 0, selected: 0 };
    });
    stats['uncategorized'] = { total: 0, selected: 0 };
    
    channels.forEach(ch => {
      const catId = ch.category || 'uncategorized';
      if (!stats[catId]) {
        stats[catId] = { total: 0, selected: 0 };
      }
      stats[catId].total += 1;
      if (formData.channels.includes(ch.id)) {
        stats[catId].selected += 1;
      }
    });
    
    return stats;
  }, [categories, channels, formData.channels]);

  // Filter channels inside the form
  const filteredChannels = useMemo(() => {
    return channels.filter(ch => {
      const matchesSearch = 
        ch.name.toLowerCase().includes(channelSearchTerm.toLowerCase()) ||
        ch.id.toLowerCase().includes(channelSearchTerm.toLowerCase());
      
      if (!matchesSearch) return false;

      if (selectedCategory === 'all') return true;
      if (selectedCategory === 'uncategorized') return !ch.category;
      return ch.category === selectedCategory;
    });
  }, [channels, channelSearchTerm, selectedCategory]);

  const handleSelectVisible = (select: boolean) => {
    const visibleIds = filteredChannels.map(ch => ch.id);
    setFormData(prev => {
      let updated = [...prev.channels];
      if (select) {
        const toAdd = visibleIds.filter(id => !updated.includes(id));
        updated = [...updated, ...toAdd];
      } else {
        updated = updated.filter(id => !visibleIds.includes(id));
      }
      return { ...prev, channels: updated };
    });
  };

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header and Controls */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <List className="text-purple-400 w-6 h-6" />
            Playlist Management
          </h1>
          <p className="text-xs text-zinc-500 mt-1">Create and manage groups of channels to easily schedule events</p>
        </div>
        {!showAddForm && (
          <button
            onClick={() => {
              handleCancel();
              setShowAddForm(true);
            }}
            className="flex items-center gap-2 px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200 shadow-lg shadow-purple-500/20 hover:scale-[1.02]"
          >
            <Plus className="w-4 h-4" />
            Create Playlist
          </button>
        )}
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

      {/* Add / Edit Form */}
      {showAddForm && (
        <form onSubmit={handleSave} className="p-6 rounded-2xl glass-panel space-y-6 animate-slideDown">
          <div className="flex justify-between items-center border-b border-zinc-800 pb-4">
            <div>
              <h3 className="text-lg font-semibold text-white">
                {editingId ? 'Edit Playlist' : 'Create New Playlist'}
              </h3>
              <p className="text-xs text-zinc-500 mt-0.5">Customize metadata and select channels</p>
            </div>
            <button
              type="button"
              onClick={handleCancel}
              className="p-1.5 text-zinc-400 hover:text-white hover:bg-zinc-800 rounded-lg transition"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
            {/* Left Column: Metadata & Selected Channels list */}
            <div className="lg:col-span-5 space-y-4 flex flex-col">
              <div className="space-y-4 p-4 rounded-xl bg-zinc-900/30 border border-zinc-800/80">
                <div className="space-y-1">
                  <label className="text-xs font-semibold text-zinc-400">Playlist Name</label>
                  <input
                    type="text"
                    placeholder="e.g. Sports HD Package"
                    value={formData.name}
                    onChange={e => {
                      const name = e.target.value;
                      setFormData(prev => {
                        const newSlug = isSlugManual || editingId 
                          ? prev.id 
                          : name.toLowerCase().replace(/[^a-z0-9-_]/g, '-').replace(/-+/g, '-').trim();
                        return { ...prev, name, id: newSlug };
                      });
                    }}
                    className="w-full p-2.5 rounded-xl glass-input text-sm"
                    required
                  />
                </div>

                <div className="space-y-1">
                  <div className="flex justify-between items-center">
                    <label className="text-xs font-semibold text-zinc-400">Playlist ID / Slug</label>
                    {!editingId && isSlugManual && (
                      <button
                        type="button"
                        onClick={() => {
                          setIsSlugManual(false);
                          setFormData(prev => ({
                            ...prev,
                            id: prev.name.toLowerCase().replace(/[^a-z0-9-_]/g, '-').replace(/-+/g, '-').trim()
                          }));
                        }}
                        className="text-[10px] text-purple-400 hover:text-purple-300 transition"
                      >
                        Reset Auto-Slug
                      </button>
                    )}
                  </div>
                  <input
                    type="text"
                    placeholder="e.g. sports-hd, live-cricket"
                    value={formData.id}
                    onChange={e => {
                      setIsSlugManual(true);
                      setFormData({ ...formData, id: e.target.value.toLowerCase().replace(/[^a-z0-9-_]/g, '-') });
                    }}
                    className="w-full p-2.5 rounded-xl glass-input text-sm"
                    required
                    disabled={!!editingId}
                  />
                  {!editingId && (
                    <p className="text-[10px] text-zinc-500">Lowercase letters, numbers, and dashes only. Cannot be changed later.</p>
                  )}
                </div>
              </div>

              {/* Selected Channels Panel */}
              <div className="flex-1 flex flex-col min-h-[300px] lg:min-h-0">
                <div className="flex justify-between items-center mb-2 px-1">
                  <label className="text-xs font-semibold text-zinc-400">
                    Selected Channels ({formData.channels.length})
                  </label>
                  {formData.channels.length > 0 && (
                    <button
                      type="button"
                      onClick={() => setFormData({ ...formData, channels: [] })}
                      className="text-[10px] text-red-400 hover:text-red-300 transition font-semibold"
                    >
                      Clear All
                    </button>
                  )}
                </div>

                <div className={`flex-1 p-3 rounded-xl bg-zinc-950/80 border border-zinc-850 overflow-y-auto max-h-[350px] lg:max-h-[380px] ${
                  formData.channels.length === 0 ? 'flex flex-col items-center justify-center' : 'flex flex-wrap gap-2 content-start'
                }`}>
                  {formData.channels.length === 0 ? (
                    <div className="py-12 text-center flex flex-col items-center justify-center">
                      <Tv className="w-8 h-8 text-zinc-700 mb-2" />
                      <div className="text-xs text-zinc-500 font-medium">No channels selected</div>
                      <div className="text-[10px] text-zinc-600 mt-1 max-w-[200px]">Click channels on the right to add them to this playlist.</div>
                    </div>
                  ) : (
                    formData.channels.map((chId, idx) => {
                      const channel = channels.find(c => c.id === chId);
                      if (!channel) return null;
                      return (
                        <div
                          key={`${chId}-${idx}`}
                          draggable
                          onDragStart={(e) => handleDragStart(e, idx)}
                          onDragOver={(e) => handleDragOver(e, idx)}
                          onDragEnd={handleDragEnd}
                          onDrop={(e) => handleDrop(e, idx)}
                          className={`px-3.5 py-1.5 rounded-full border text-[11px] font-semibold flex items-center gap-1.5 cursor-grab active:cursor-grabbing transition-all duration-150 ${
                            draggedIndex === idx 
                              ? 'opacity-40 border-dashed border-purple-500 bg-purple-950/10' 
                              : dragOverIndex === idx 
                              ? 'border-purple-400 bg-purple-950/30 scale-[1.05] shadow-sm shadow-purple-500/20 text-white' 
                              : 'bg-purple-950/15 border-purple-900/60 text-purple-300 hover:border-purple-500/60 hover:text-purple-200'
                          }`}
                        >
                          <span className="truncate max-w-[160px] select-none">{channel.name}</span>
                          <button
                            type="button"
                            onClick={(e) => {
                              e.stopPropagation();
                              handleChannelToggle(chId);
                            }}
                            className="text-purple-400 hover:text-white transition-colors p-0.5 rounded-full hover:bg-purple-800/20 shrink-0"
                            title="Remove"
                          >
                            <X className="w-3 h-3" />
                          </button>
                        </div>
                      );
                    })
                  )}
                </div>
              </div>

              {/* Form Action buttons */}
              <div className="pt-4 flex gap-3 border-t border-zinc-850 mt-auto">
                <button
                  type="submit"
                  className="flex-1 py-2.5 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200 flex items-center justify-center gap-2"
                >
                  <Save className="w-4 h-4" />
                  Save Playlist
                </button>
                <button
                  type="button"
                  onClick={handleCancel}
                  className="px-5 py-2.5 bg-zinc-850 hover:bg-zinc-755 text-zinc-300 rounded-xl text-sm font-semibold transition-all duration-200"
                >
                  Cancel
                </button>
              </div>
            </div>

            {/* Right Column: Channels selection & filtering */}
            <div className="lg:col-span-7 space-y-4">
              {/* Category Filter Row */}
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-zinc-400 block px-1">Filter by Category</label>
                <div className="flex gap-1.5 overflow-x-auto pb-2 scrollbar-none">
                  {/* All channels pill */}
                  <button
                    type="button"
                    onClick={() => setSelectedCategory('all')}
                    className={`shrink-0 px-3.5 py-1.5 rounded-full text-xs font-semibold transition flex items-center gap-1.5 ${
                      selectedCategory === 'all'
                        ? 'bg-purple-600 text-white shadow-lg shadow-purple-500/25'
                        : 'bg-zinc-900/60 border border-zinc-800 text-zinc-400 hover:border-zinc-700 hover:text-white'
                    }`}
                  >
                    <span>All</span>
                    <span className={`text-[10px] px-1.5 py-0.5 rounded-full shrink-0 font-medium ${
                      selectedCategory === 'all' ? 'bg-purple-700 text-purple-100' : 'bg-zinc-950 text-zinc-500'
                    }`}>
                      {formData.channels.length}/{channels.length}
                    </span>
                  </button>

                  {/* Uncategorized pill */}
                  {categoryStats['uncategorized']?.total > 0 && (
                    <button
                      type="button"
                      onClick={() => setSelectedCategory('uncategorized')}
                      className={`shrink-0 px-3.5 py-1.5 rounded-full text-xs font-semibold transition flex items-center gap-1.5 ${
                        selectedCategory === 'uncategorized'
                          ? 'bg-purple-600 text-white shadow-lg shadow-purple-500/25'
                          : 'bg-zinc-900/60 border border-zinc-800 text-zinc-400 hover:border-zinc-700 hover:text-white'
                      }`}
                    >
                      <span>Uncategorized</span>
                      <span className={`text-[10px] px-1.5 py-0.5 rounded-full shrink-0 font-medium ${
                        selectedCategory === 'uncategorized' ? 'bg-purple-700 text-purple-100' : 'bg-zinc-950 text-zinc-500'
                      }`}>
                        {categoryStats['uncategorized'].selected}/{categoryStats['uncategorized'].total}
                      </span>
                    </button>
                  )}

                  {/* Rest of the Categories */}
                  {categories.map(cat => {
                    const stats = categoryStats[cat.id] || { total: 0, selected: 0 };
                    if (stats.total === 0) return null;
                    return (
                      <button
                        key={cat.id}
                        type="button"
                        onClick={() => setSelectedCategory(cat.id)}
                        className={`shrink-0 px-3.5 py-1.5 rounded-full text-xs font-semibold transition flex items-center gap-1.5 ${
                          selectedCategory === cat.id
                            ? 'bg-purple-600 text-white shadow-lg shadow-purple-500/25'
                            : 'bg-zinc-900/60 border border-zinc-800 text-zinc-400 hover:border-zinc-700 hover:text-white'
                        }`}
                      >
                        <span>{cat.name}</span>
                        <span className={`text-[10px] px-1.5 py-0.5 rounded-full shrink-0 font-medium ${
                          selectedCategory === cat.id ? 'bg-purple-700 text-purple-100' : 'bg-zinc-950 text-zinc-500'
                        }`}>
                          {stats.selected}/{stats.total}
                        </span>
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Bulk Categories Selection panel */}
              <div className="space-y-2">
                <button
                  type="button"
                  onClick={() => setShowBulkCategories(!showBulkCategories)}
                  className="flex items-center justify-between w-full px-4 py-2.5 bg-zinc-900/30 border border-zinc-800/80 hover:border-zinc-700 rounded-xl text-xs text-zinc-300 font-semibold transition hover:bg-zinc-900/50"
                >
                  <span className="flex items-center gap-2">
                    <Folder className="w-4 h-4 text-purple-400" />
                    Bulk Selection by Category
                  </span>
                  <span className="text-[10px] text-zinc-500 bg-zinc-950 px-2 py-0.5 rounded-full border border-zinc-850">
                    {showBulkCategories ? 'Hide' : 'Expand'}
                  </span>
                </button>
                
                {showBulkCategories && (
                  <div className="grid grid-cols-2 sm:grid-cols-3 gap-2 p-3 rounded-xl bg-zinc-950/60 border border-zinc-850 animate-slideDown">
                    {categoryStats['uncategorized']?.total > 0 && (
                      (() => {
                        const stats = categoryStats['uncategorized'];
                        const allSelected = stats.selected === stats.total;
                        return (
                          <button
                            type="button"
                            onClick={() => handleBulkCategoryToggle('uncategorized', !allSelected)}
                            className={`p-2 rounded-lg border text-left text-[11px] flex items-center justify-between transition-all ${
                              allSelected 
                                ? 'bg-purple-950/30 border-purple-500 text-purple-300' 
                                : stats.selected > 0 
                                ? 'bg-zinc-900 border-purple-900/40 text-zinc-300' 
                                : 'bg-zinc-900/40 border-zinc-800 text-zinc-500 hover:border-zinc-700'
                            }`}
                          >
                            <span className="truncate">Uncategorized</span>
                            <span className="text-[9px] font-mono bg-zinc-950 px-1.5 py-0.5 rounded text-zinc-400 font-semibold shrink-0 ml-1">
                              {stats.selected}/{stats.total}
                            </span>
                          </button>
                        );
                      })()
                    )}

                    {categories.map(cat => {
                      const stats = categoryStats[cat.id] || { total: 0, selected: 0 };
                      if (stats.total === 0) return null;
                      const allSelected = stats.selected === stats.total;
                      return (
                        <button
                          key={cat.id}
                          type="button"
                          onClick={() => handleBulkCategoryToggle(cat.id, !allSelected)}
                          className={`p-2 rounded-lg border text-left text-[11px] flex items-center justify-between transition-all ${
                            allSelected 
                              ? 'bg-purple-950/30 border-purple-500 text-purple-300' 
                              : stats.selected > 0 
                              ? 'bg-zinc-900 border-purple-900/40 text-zinc-300' 
                              : 'bg-zinc-900/40 border-zinc-800/80 text-zinc-500 hover:border-zinc-700'
                          }`}
                        >
                          <span className="truncate">{cat.name}</span>
                          <span className="text-[9px] font-mono bg-zinc-950 px-1.5 py-0.5 rounded text-zinc-400 font-semibold shrink-0 ml-1">
                            {stats.selected}/{stats.total}
                          </span>
                        </button>
                      );
                    })}
                  </div>
                )}
              </div>

              {/* Search and Bulk Actions */}
              <div className="flex flex-col sm:flex-row gap-3">
                <div className="relative flex-1">
                  <Search className="absolute left-3 top-2.5 w-4 h-4 text-zinc-500" />
                  <input
                    type="text"
                    placeholder="Search channels..."
                    value={channelSearchTerm}
                    onChange={e => setChannelSearchTerm(e.target.value)}
                    className="w-full pl-9 pr-4 py-2 rounded-lg bg-zinc-950 border border-zinc-800 text-xs text-white"
                  />
                </div>
                
                {filteredChannels.length > 0 && (
                  <div className="flex gap-2 shrink-0">
                    <button
                      type="button"
                      onClick={() => handleSelectVisible(true)}
                      className="px-3 py-2 bg-zinc-900 border border-zinc-800 hover:border-zinc-700 rounded-lg text-[10px] font-semibold text-zinc-300 flex items-center gap-1 transition"
                    >
                      <CheckSquare className="w-3.5 h-3.5" />
                      Select Page ({filteredChannels.length})
                    </button>
                    <button
                      type="button"
                      onClick={() => handleSelectVisible(false)}
                      className="px-3 py-2 bg-zinc-900 border border-zinc-800 hover:border-zinc-700 rounded-lg text-[10px] font-semibold text-zinc-300 flex items-center gap-1 transition"
                    >
                      <Square className="w-3.5 h-3.5" />
                      Deselect Page
                    </button>
                  </div>
                )}
              </div>

              {/* Channels Grid */}
              <div className="p-3 rounded-xl bg-zinc-950/80 border border-zinc-850 max-h-[300px] lg:max-h-[360px] overflow-y-auto">
                {filteredChannels.length === 0 ? (
                  <div className="text-center py-12 text-xs text-zinc-600">No channels found</div>
                ) : (
                  <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2">
                    {filteredChannels.map(ch => {
                      const isSelected = formData.channels.includes(ch.id);
                      const chCategory = categories.find(c => c.id === ch.category)?.name || 'Uncategorized';
                      return (
                        <button
                          key={ch.id}
                          type="button"
                          onClick={() => handleChannelToggle(ch.id)}
                          className={`p-2.5 rounded-xl border text-left text-xs transition-all flex items-center gap-2 group relative ${
                            isSelected
                              ? 'bg-purple-950/20 border-purple-500 text-purple-300 font-semibold shadow-lg shadow-purple-500/5'
                              : 'bg-zinc-900 border-zinc-800 hover:border-zinc-700 text-zinc-400 hover:text-zinc-300'
                          }`}
                        >
                          <div className="relative shrink-0">
                            {ch.logo ? (
                              <img src={ch.logo} alt="" className="w-8 h-8 object-contain rounded bg-black border border-zinc-800" />
                            ) : (
                              <div className="w-8 h-8 rounded bg-zinc-950 border border-zinc-850 flex items-center justify-center text-zinc-600 group-hover:text-zinc-500">
                                <Tv className="w-4 h-4" />
                              </div>
                            )}
                            {isSelected && (
                              <div className="absolute -top-1 -right-1 bg-purple-500 text-white rounded-full p-0.5 border border-zinc-950">
                                <Check className="w-2 h-2" />
                              </div>
                            )}
                          </div>
                          
                          <div className="min-w-0 flex-1">
                            <div className="truncate font-medium text-zinc-200 group-hover:text-white transition-colors">{ch.name}</div>
                            <div className="text-[10px] text-zinc-500 truncate mt-0.5">{chCategory}</div>
                          </div>
                        </button>
                      );
                    })}
                  </div>
                )}
              </div>
            </div>
          </div>
        </form>
      )}

      {/* Playlists Directory */}
      <div className="p-6 rounded-2xl glass-panel space-y-4">
        {/* Search */}
        <div className="relative">
          <Search className="absolute left-3 top-3 w-4 h-4 text-zinc-500" />
          <input
            type="text"
            placeholder="Search playlists by name or ID..."
            value={searchTerm}
            onChange={e => setSearchTerm(e.target.value)}
            className="w-full pl-9 pr-4 py-2.5 rounded-xl glass-input text-sm"
          />
        </div>

        {loading ? (
          <div className="text-center py-12 text-zinc-500 flex items-center justify-center gap-2">
            <RefreshCw className="w-4 h-4 animate-spin text-purple-400" />
            <span>Loading playlists...</span>
          </div>
        ) : filteredPlaylists.length === 0 ? (
          <div className="text-center py-12 text-zinc-500">No playlists found.</div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredPlaylists.map(playlist => (
              <div
                key={playlist.id}
                className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800 hover:border-zinc-750 transition-all flex flex-col justify-between"
              >
                <div>
                  <div className="flex justify-between items-start mb-2">
                    <h4 className="text-base font-bold text-white truncate">{playlist.name}</h4>
                    <span className="text-[10px] font-mono px-2 py-0.5 rounded-full bg-purple-950/40 text-purple-400 border border-purple-900/40">
                      {playlist.channels?.length || 0} channels
                    </span>
                  </div>
                  <span className="text-xs font-mono px-2 py-0.5 rounded bg-zinc-950 text-zinc-400">
                    ID: {playlist.id}
                  </span>

                  <div className="mt-4 flex flex-wrap gap-1 max-h-24 overflow-y-auto">
                    {playlist.channels && playlist.channels.length > 0 ? (
                      <>
                        {playlist.channels.slice(0, 15).map((chId, index) => (
                          <span key={`${chId}-${index}`} className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-950/80 text-zinc-400 border border-zinc-850/40">
                            {channels.find(c => c.id === chId)?.name || chId}
                          </span>
                        ))}
                        {playlist.channels.length > 15 && (
                          <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-purple-950/30 text-purple-400 border border-purple-900/30 font-semibold">
                            +{playlist.channels.length - 15} more
                          </span>
                        )}
                      </>
                    ) : (
                      <span className="text-[10px] text-zinc-600 italic">No channels assigned</span>
                    )}
                  </div>
                </div>

                <div className="mt-6 pt-3 border-t border-zinc-850 flex justify-end gap-2">
                  <button
                    onClick={() => handleEdit(playlist)}
                    className="p-2 bg-zinc-950 hover:bg-zinc-850 text-purple-400 hover:text-white rounded-lg border border-zinc-800 hover:border-zinc-700 transition-colors"
                    title="Edit Playlist"
                  >
                    <Edit2 className="w-3.5 h-3.5" />
                  </button>
                  <button
                    onClick={() => handleDelete(playlist.id)}
                    className="p-2 bg-zinc-950 hover:bg-red-950/20 text-red-400 hover:text-red-300 rounded-lg border border-zinc-800 hover:border-red-900/50 transition-colors"
                    title="Delete Playlist"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

