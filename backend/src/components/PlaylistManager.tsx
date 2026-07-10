'use client';

import React, { useState, useEffect } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import { Plus, Edit2, Trash2, Save, X, Search, List, Check, AlertCircle } from 'lucide-react';

interface Playlist {
  id: string;
  name: string;
  channels: string[];
}

interface Channel {
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

  const [showAddForm, setShowAddForm] = useState(false);

  const supabaseAdmin = createAdminSupabaseClient(adminToken);

  const fetchData = async () => {
    try {
      setLoading(true);
      setError(null);

      // Fetch Playlists
      const { data: plData, error: plErr } = await supabaseAdmin
        .from('playlists')
        .select('*')
        .order('name', { ascending: true });

      if (plErr) throw plErr;
      setPlaylists(plData || []);

      // Fetch all Channels using pagination (bypass 1000-row PostgREST limit)
      const BATCH_SIZE = 1000;
      let offset = 0;
      const allChannels: any[] = [];

      while (true) {
        const { data: batch, error: chErr } = await supabaseAdmin
          .from('channels')
          .select('id, name')
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
    setShowAddForm(true);
  };

  const handleCancel = () => {
    setEditingId(null);
    setFormData({ id: '', name: '', channels: [] });
    setChannelSearchTerm('');
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

  // Filter playlists
  const filteredPlaylists = playlists.filter(pl => 
    pl.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    pl.id.toLowerCase().includes(searchTerm.toLowerCase())
  );

  // Filter channels inside the form
  const filteredChannels = channels.filter(ch =>
    ch.name.toLowerCase().includes(channelSearchTerm.toLowerCase()) ||
    ch.id.toLowerCase().includes(channelSearchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6">
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
        <form onSubmit={handleSave} className="p-6 rounded-2xl glass-panel space-y-4 animate-slideDown">
          <div className="flex justify-between items-center border-b border-zinc-800 pb-3">
            <h3 className="text-lg font-semibold text-white">
              {editingId ? 'Edit Playlist' : 'Create New Playlist'}
            </h3>
            <button
              type="button"
              onClick={handleCancel}
              className="p-1 text-zinc-400 hover:text-white hover:bg-zinc-800 rounded-lg transition"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-4">
              <div className="space-y-1">
                <label className="text-xs font-semibold text-zinc-400">Playlist ID / Slug</label>
                <input
                  type="text"
                  placeholder="e.g. sports-hd, live-cricket"
                  value={formData.id}
                  onChange={e => setFormData({ ...formData, id: e.target.value })}
                  className="w-full p-2.5 rounded-xl glass-input text-sm"
                  required
                  disabled={!!editingId}
                />
                {!editingId && (
                  <p className="text-[10px] text-zinc-500">Lowercase letters, numbers, and dashes only. Cannot be changed later.</p>
                )}
              </div>

              <div className="space-y-1">
                <label className="text-xs font-semibold text-zinc-400">Playlist Name</label>
                <input
                  type="text"
                  placeholder="e.g. Sports HD Package"
                  value={formData.name}
                  onChange={e => setFormData({ ...formData, name: e.target.value })}
                  className="w-full p-2.5 rounded-xl glass-input text-sm"
                  required
                />
              </div>

              <div className="pt-4 flex gap-3">
                <button
                  type="submit"
                  className="px-5 py-2.5 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200"
                >
                  <Save className="w-4 h-4 inline mr-2" />
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

            <div className="space-y-3">
              <div className="flex justify-between items-center">
                <label className="text-xs font-semibold text-zinc-400">
                  Select Channels ({formData.channels.length} selected)
                </label>
                <div className="flex gap-2">
                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, channels: channels.map(c => c.id) })}
                    className="text-[10px] text-purple-400 hover:text-purple-300 font-semibold"
                  >
                    Select All
                  </button>
                  <span className="text-zinc-700">|</span>
                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, channels: [] })}
                    className="text-[10px] text-zinc-400 hover:text-zinc-300 font-semibold"
                  >
                    Clear All
                  </button>
                </div>
              </div>

              <div className="relative">
                <Search className="absolute left-3 top-2.5 w-4 h-4 text-zinc-500" />
                <input
                  type="text"
                  placeholder="Search channels..."
                  value={channelSearchTerm}
                  onChange={e => setChannelSearchTerm(e.target.value)}
                  className="w-full pl-9 pr-4 py-2 rounded-lg bg-zinc-950 border border-zinc-800 text-xs text-white"
                />
              </div>

              <div className="p-3 rounded-xl bg-zinc-950/80 border border-zinc-850 max-h-60 overflow-y-auto grid grid-cols-1 sm:grid-cols-2 gap-2">
                {filteredChannels.length === 0 ? (
                  <div className="col-span-2 text-center py-6 text-xs text-zinc-600">No channels found</div>
                ) : (
                  filteredChannels.map(ch => {
                    const isSelected = formData.channels.includes(ch.id);
                    return (
                      <button
                        key={ch.id}
                        type="button"
                        onClick={() => handleChannelToggle(ch.id)}
                        className={`p-2 rounded-lg border text-left text-xs truncate transition-all flex items-center justify-between ${
                          isSelected
                            ? 'bg-purple-950/30 border-purple-500 text-purple-300 font-semibold'
                            : 'bg-zinc-900 border-zinc-800 text-zinc-400 hover:border-zinc-700'
                        }`}
                      >
                        <span className="truncate">{ch.name}</span>
                        {isSelected && <Check className="w-3.5 h-3.5 text-purple-400 flex-shrink-0 ml-1" />}
                      </button>
                    );
                  })
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
          <div className="text-center py-12 text-zinc-500">Loading playlists...</div>
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
                      playlist.channels.map((chId, index) => (
                        <span key={`${chId}-${index}`} className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-950/80 text-zinc-500">
                          {channels.find(c => c.id === chId)?.name || chId}
                        </span>
                      ))
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
