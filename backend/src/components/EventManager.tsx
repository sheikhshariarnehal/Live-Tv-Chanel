'use client';

import React, { useState, useEffect } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import { Plus, Edit2, Trash2, Save, X, Calendar, Search, Trophy, Check, AlertCircle } from 'lucide-react';
import 'flag-icons/css/flag-icons.min.css';

interface Event {
  id: string;
  sport: string;
  league: string;
  home_team: { name: string; flag?: string };
  away_team: { name: string; flag?: string };
  start_time: string;
  status: string;
  channels: string[];
  banner: string | null;
  is_featured: boolean;
}

const emojiToCountryCode = (emoji: string): string | null => {
  if (!emoji) return null;
  const trimmed = emoji.trim();
  if (/^[a-zA-Z]{2}$/.test(trimmed)) {
    return trimmed.toLowerCase();
  }
  const codePoints = Array.from(trimmed).map(char => char.codePointAt(0) || 0);
  if (codePoints.length >= 2 && codePoints.every(cp => cp >= 0x1F1E6 && cp <= 0x1F1FF)) {
    return codePoints.map(cp => String.fromCharCode(cp - 127397)).join('').toLowerCase();
  }
  return null;
};

const cleanFlagValue = (input: string): string => {
  const trimmed = input.trim();
  if (!trimmed) return '';
  if (trimmed.startsWith('http') || trimmed.startsWith('/') || trimmed.startsWith('data:')) {
    return trimmed;
  }
  const code = emojiToCountryCode(trimmed);
  if (code) return code;
  return trimmed.toLowerCase();
};

const renderTeamFlag = (flag?: string | null) => {
  if (!flag) return <Trophy className="w-5 h-5 text-zinc-600" />;
  const trimmed = flag.trim();
  if (trimmed.startsWith('http') || trimmed.startsWith('/') || trimmed.startsWith('data:')) {
    return <img src={trimmed} alt="" className="w-full h-full object-contain" />;
  }
  if (/^[a-zA-Z]{2}$/.test(trimmed)) {
    return <span className={`fi fi-${trimmed.toLowerCase()} fis w-full h-full shadow-sm`} />;
  }
  const countryCode = emojiToCountryCode(trimmed);
  if (countryCode) {
    return <span className={`fi fi-${countryCode} fis w-full h-full shadow-sm`} />;
  }
  return <span className="text-2xl select-none">{trimmed}</span>;
};

interface Channel {
  id: string;
  name: string;
}

interface EventManagerProps {
  adminToken: string;
  onRefreshStats: () => void;
}

export default function EventManager({ adminToken, onRefreshStats }: EventManagerProps) {
  const [events, setEvents] = useState<Event[]>([]);
  const [channels, setChannels] = useState<Channel[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  // Search & filter
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  // Form states
  const [showAddForm, setShowAddForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [formData, setFormData] = useState({
    id: '',
    sport: 'Football',
    league: '',
    home_name: '',
    home_logo: '',
    away_name: '',
    away_logo: '',
    start_time: '',
    status: 'upcoming',
    channels: [] as string[],
    banner: '',
    is_featured: false
  });

  const supabaseAdmin = createAdminSupabaseClient(adminToken);

  const fetchData = async () => {
    try {
      setLoading(true);
      setError(null);

      // Fetch Events
      const { data: evData, error: evErr } = await supabaseAdmin
        .from('events')
        .select('*')
        .order('start_time', { ascending: true });

      if (evErr) throw evErr;
      setEvents(evData || []);

      // Fetch Channels (to link to events)
      const { data: chData, error: chErr } = await supabaseAdmin
        .from('channels')
        .select('id, name')
        .order('name', { ascending: true });

      if (chErr) throw chErr;
      setChannels(chData || []);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch events data');
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

  const handleEdit = (event: Event) => {
    setEditingId(event.id);
    setFormData({
      id: event.id,
      sport: event.sport,
      league: event.league,
      home_name: event.home_team?.name || '',
      home_logo: event.home_team?.flag || '',
      away_name: event.away_team?.name || '',
      away_logo: event.away_team?.flag || '',
      // Convert to local datetime-local format
      start_time: event.start_time ? new Date(event.start_time).toISOString().slice(0, 16) : '',
      status: event.status,
      channels: event.channels || [],
      banner: event.banner || '',
      is_featured: event.is_featured
    });
    setShowAddForm(true);
  };

  const handleCancel = () => {
    setEditingId(null);
    setFormData({
      id: '',
      sport: 'Football',
      league: '',
      home_name: '',
      home_logo: '',
      away_name: '',
      away_logo: '',
      start_time: '',
      status: 'upcoming',
      channels: [],
      banner: '',
      is_featured: false
    });
    setShowAddForm(false);
  };

  const handleChannelSelection = (channelId: string) => {
    setFormData(prev => {
      const exists = prev.channels.includes(channelId);
      if (exists) {
        return { ...prev, channels: prev.channels.filter(id => id !== channelId) };
      } else {
        return { ...prev, channels: [...prev.channels, channelId] };
      }
    });
  };

  const handleSave = async (id: string) => {
    try {
      if (!formData.home_name.trim() || !formData.away_name.trim()) {
        showNotification('error', 'Both home and away team names are required');
        return;
      }

      const { error: updateErr } = await supabaseAdmin
        .from('events')
        .update({
          sport: formData.sport,
          league: formData.league.trim(),
          home_team: { name: formData.home_name.trim(), flag: cleanFlagValue(formData.home_logo) || undefined },
          away_team: { name: formData.away_name.trim(), flag: cleanFlagValue(formData.away_logo) || undefined },
          start_time: formData.start_time ? new Date(formData.start_time).toISOString() : new Date().toISOString(),
          status: formData.status,
          channels: formData.channels,
          banner: formData.banner.trim() || null,
          is_featured: formData.is_featured
        })
        .eq('id', id);

      if (updateErr) throw updateErr;

      showNotification('success', 'Match event updated successfully');
      setEditingId(null);
      handleCancel();
      fetchData();
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to update event');
    }
  };

  const handleFormUpdate = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingId) return;
    await handleSave(editingId);
  };

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (!formData.id.trim()) {
        showNotification('error', 'Event ID/Slug is required');
        return;
      }
      if (!formData.home_name.trim() || !formData.away_name.trim()) {
        showNotification('error', 'Home and away team names are required');
        return;
      }

      const idExists = events.some(ev => ev.id === formData.id.toLowerCase().trim());
      if (idExists) {
        showNotification('error', 'Event ID/Slug already exists');
        return;
      }

      const cleanId = formData.id.toLowerCase().replace(/[^a-z0-9-_]/g, '-').trim();

      const { error: insertErr } = await supabaseAdmin
        .from('events')
        .insert({
          id: cleanId,
          sport: formData.sport,
          league: formData.league.trim(),
          home_team: { name: formData.home_name.trim(), flag: cleanFlagValue(formData.home_logo) || undefined },
          away_team: { name: formData.away_name.trim(), flag: cleanFlagValue(formData.away_logo) || undefined },
          start_time: formData.start_time ? new Date(formData.start_time).toISOString() : new Date().toISOString(),
          status: formData.status,
          channels: formData.channels,
          banner: formData.banner.trim() || null,
          is_featured: formData.is_featured
        });

      if (insertErr) throw insertErr;

      showNotification('success', 'Match event scheduled successfully');
      handleCancel();
      fetchData();
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to schedule event');
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm(`Are you sure you want to delete event "${id}"?`)) {
      return;
    }

    try {
      const { error: deleteErr } = await supabaseAdmin
        .from('events')
        .delete()
        .eq('id', id);

      if (deleteErr) throw deleteErr;

      showNotification('success', 'Event deleted successfully');
      fetchData();
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to delete event');
    }
  };

  // Filter events
  const filteredEvents = events.filter(event => {
    const nameStr = `${event.home_team?.name} vs ${event.away_team?.name} ${event.league} ${event.sport}`;
    const matchesSearch = nameStr.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || event.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <Calendar className="text-purple-400 w-6 h-6" />
            Sports Matches Scheduler
          </h1>
          <p className="text-xs text-zinc-500 mt-1">Schedule live and upcoming sports fixtures, associate playback channels</p>
        </div>
        <button
          onClick={() => {
            setShowAddForm(!showAddForm);
            handleCancel();
          }}
          className="flex items-center gap-2 px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200 shadow-lg shadow-purple-500/20 hover:scale-[1.02]"
        >
          {showAddForm ? <X className="w-4 h-4" /> : <Plus className="w-4 h-4" />}
          {showAddForm ? 'Close Form' : 'Schedule Match'}
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
        <form onSubmit={editingId ? handleFormUpdate : handleAdd} className="p-6 rounded-2xl glass-panel space-y-4 animate-slideDown">
          <h3 className="text-lg font-semibold text-white">{editingId ? 'Edit Match Event' : 'Create New Match Event'}</h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Event ID / Slug</label>
              <input
                type="text"
                placeholder="e.g. el-clasico-2026, ucl-final"
                value={formData.id}
                onChange={e => setFormData({ ...formData, id: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
                required
                disabled={!!editingId}
              />
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Sport Type</label>
              <select
                value={formData.sport}
                onChange={e => setFormData({ ...formData, sport: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              >
                <option value="Football">Football (Soccer)</option>
                <option value="Cricket">Cricket</option>
                <option value="Basketball">Basketball</option>
                <option value="Tennis">Tennis</option>
                <option value="F1">Formula 1</option>
                <option value="WWE">WWE / Wrestling</option>
                <option value="Other">Other Sport</option>
              </select>
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">League / Cup Name</label>
              <input
                type="text"
                placeholder="e.g. UEFA Champions League"
                value={formData.league}
                onChange={e => setFormData({ ...formData, league: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
                required
              />
            </div>

            {/* Teams Details */}
            <div className="p-4 rounded-xl bg-zinc-950/60 border border-zinc-800 space-y-3">
              <span className="text-xs font-bold text-purple-400">Home Team</span>
              <input
                type="text"
                placeholder="Team Name"
                value={formData.home_name}
                onChange={e => setFormData({ ...formData, home_name: e.target.value })}
                className="w-full p-2 rounded bg-zinc-900 border border-zinc-800 text-xs text-white"
                required
              />
              <input
                type="text"
                placeholder="Flag Emoji e.g. 🇧🇩 or URL (Optional)"
                value={formData.home_logo}
                onChange={e => setFormData({ ...formData, home_logo: e.target.value })}
                className="w-full p-2 rounded bg-zinc-900 border border-zinc-800 text-xs text-white"
              />
            </div>

            <div className="p-4 rounded-xl bg-zinc-950/60 border border-zinc-800 space-y-3">
              <span className="text-xs font-bold text-pink-400">Away Team</span>
              <input
                type="text"
                placeholder="Team Name"
                value={formData.away_name}
                onChange={e => setFormData({ ...formData, away_name: e.target.value })}
                className="w-full p-2 rounded bg-zinc-900 border border-zinc-800 text-xs text-white"
                required
              />
              <input
                type="text"
                placeholder="Flag Emoji e.g. 🇮🇳 or URL (Optional)"
                value={formData.away_logo}
                onChange={e => setFormData({ ...formData, away_logo: e.target.value })}
                className="w-full p-2 rounded bg-zinc-900 border border-zinc-800 text-xs text-white"
              />
            </div>

            {/* Start Time & Status */}
            <div className="p-4 rounded-xl bg-zinc-950/60 border border-zinc-800 space-y-3">
              <span className="text-xs font-bold text-zinc-400">Timing & Status</span>
              <input
                type="datetime-local"
                value={formData.start_time}
                onChange={e => setFormData({ ...formData, start_time: e.target.value })}
                className="w-full p-2 rounded bg-zinc-900 border border-zinc-800 text-xs text-white"
                required
              />
              <select
                value={formData.status}
                onChange={e => setFormData({ ...formData, status: e.target.value })}
                className="w-full p-2 rounded bg-zinc-900 border border-zinc-800 text-xs text-white"
              >
                <option value="upcoming">Upcoming</option>
                <option value="live">Live Now</option>
                <option value="completed">Completed</option>
              </select>
            </div>

            {/* Optional Banner & Featured */}
            <div className="md:col-span-2 space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Banner Image URL (Wide banner for spotlight display)</label>
              <input
                type="text"
                placeholder="https://example.com/banner.jpg"
                value={formData.banner}
                onChange={e => setFormData({ ...formData, banner: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              />
            </div>
            <div className="flex items-center pt-6">
              <label className="flex items-center gap-2 cursor-pointer text-sm text-zinc-300">
                <input
                  type="checkbox"
                  checked={formData.is_featured}
                  onChange={e => setFormData({ ...formData, is_featured: e.target.checked })}
                  className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500"
                />
                Spotlight/Featured Event
              </label>
            </div>

            {/* Broadcast Channels Selection */}
            <div className="md:col-span-3 space-y-2">
              <label className="text-xs font-semibold text-zinc-400 block">Select Broadcasting Live Channels (Multiselect)</label>
              <div className="p-4 rounded-xl bg-zinc-950/80 border border-zinc-800 max-h-40 overflow-y-auto grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-2">
                {channels.map(ch => {
                  const isSelected = formData.channels.includes(ch.id);
                  return (
                    <button
                      key={ch.id}
                      type="button"
                      onClick={() => handleChannelSelection(ch.id)}
                      className={`p-2 rounded-lg border text-left text-xs truncate transition-all ${
                        isSelected 
                          ? 'bg-purple-950/40 border-purple-500 text-purple-300 font-semibold' 
                          : 'bg-zinc-900 border-zinc-800 text-zinc-400 hover:border-zinc-700'
                      }`}
                    >
                      {ch.name}
                    </button>
                  );
                })}
              </div>
            </div>
          </div>
          <button
            type="submit"
            className="px-5 py-2.5 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200"
          >
            {editingId ? 'Save Changes' : 'Schedule Match'}
          </button>
        </form>
      )}

      {/* Events Listing */}
      <div className="p-6 rounded-2xl glass-panel space-y-4">
        {/* Search / Filters */}
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-3 w-4 h-4 text-zinc-500" />
            <input
              type="text"
              placeholder="Search by team, league, or sport..."
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 rounded-xl glass-input text-sm"
            />
          </div>
          <select
            value={statusFilter}
            onChange={e => setStatusFilter(e.target.value)}
            className="px-4 py-2.5 rounded-xl glass-input text-sm min-w-[150px]"
          >
            <option value="all">All Match Statuses</option>
            <option value="upcoming">Upcoming Matches</option>
            <option value="live">Live Matches Now</option>
            <option value="completed">Completed Matches</option>
          </select>
        </div>

        {loading ? (
          <div className="text-center py-12 text-zinc-500">Loading events calendar...</div>
        ) : filteredEvents.length === 0 ? (
          <div className="text-center py-12 text-zinc-500">No scheduled matches found.</div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {filteredEvents.map((event) => {
              const isEditing = editingId === event.id;
              return (
                <div 
                  key={event.id} 
                  className={`p-5 rounded-2xl border transition-all duration-200 ${
                    event.status === 'live' 
                      ? 'bg-purple-950/10 border-purple-500/50 shadow-md shadow-purple-500/5' 
                      : 'bg-zinc-900/40 border-zinc-800 hover:border-zinc-700'
                  }`}
                >
                  <div className="flex justify-between items-start mb-3">
                    <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full bg-zinc-800 text-zinc-400">
                      {event.sport}
                    </span>
                    <span className={`text-[10px] font-extrabold uppercase px-2.5 py-0.5 rounded-full ${
                      event.status === 'live' 
                        ? 'bg-red-500/20 text-red-400 border border-red-500/30 animate-pulse' 
                        : event.status === 'completed'
                          ? 'bg-zinc-800 text-zinc-500'
                          : 'bg-blue-500/20 text-blue-400 border border-blue-500/30'
                    }`}>
                      {event.status}
                    </span>
                  </div>

                  {/* Team vs Team Display */}
                  {isEditing ? (
                    <div className="space-y-3 mb-4">
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div className="space-y-1">
                          <label className="text-[10px] text-zinc-500">Home Team</label>
                          <input
                            type="text"
                            value={formData.home_name}
                            onChange={e => setFormData({ ...formData, home_name: e.target.value })}
                            className="w-full p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                          />
                        </div>
                        <div className="space-y-1">
                          <label className="text-[10px] text-zinc-500">Away Team</label>
                          <input
                            type="text"
                            value={formData.away_name}
                            onChange={e => setFormData({ ...formData, away_name: e.target.value })}
                            className="w-full p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                          />
                        </div>
                      </div>
                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <select
                          value={formData.status}
                          onChange={e => setFormData({ ...formData, status: e.target.value })}
                          className="p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                        >
                          <option value="upcoming">Upcoming</option>
                          <option value="live">Live Now</option>
                          <option value="completed">Completed</option>
                        </select>
                        <input
                          type="datetime-local"
                          value={formData.start_time}
                          onChange={e => setFormData({ ...formData, start_time: e.target.value })}
                          className="p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                        />
                      </div>
                    </div>
                  ) : (
                    <div className="flex justify-between items-center my-4 py-2">
                      <div className="flex flex-col items-center flex-1 max-w-[40%] text-center">
                        <div className="w-12 h-12 rounded-full bg-zinc-950 border border-zinc-800 flex items-center justify-center mb-2 overflow-hidden">
                          {renderTeamFlag(event.home_team?.flag)}
                        </div>
                        <span className="text-xs font-bold text-white truncate w-full">{event.home_team?.name}</span>
                      </div>

                      <div className="text-zinc-500 font-extrabold text-xs">VS</div>

                      <div className="flex flex-col items-center flex-1 max-w-[40%] text-center">
                        <div className="w-12 h-12 rounded-full bg-zinc-950 border border-zinc-800 flex items-center justify-center mb-2 overflow-hidden">
                          {renderTeamFlag(event.away_team?.flag)}
                        </div>
                        <span className="text-xs font-bold text-white truncate w-full">{event.away_team?.name}</span>
                      </div>
                    </div>
                  )}

                  {/* League & Time */}
                  {!isEditing && (
                    <div className="text-center space-y-1 mb-4">
                      <p className="text-xs text-zinc-400">{event.league}</p>
                      <p className="text-[10px] text-zinc-500">
                        {event.start_time ? new Date(event.start_time).toLocaleString() : 'No Time Set'}
                      </p>
                    </div>
                  )}

                  {/* Linked Channels & Actions */}
                  <div className="flex justify-between items-center pt-3 border-t border-zinc-800/60">
                    <div className="flex gap-1 flex-wrap max-w-[70%]">
                      {isEditing ? (
                        <span className="text-[10px] text-zinc-500">Channel edit in form context</span>
                      ) : event.channels && event.channels.length > 0 ? (
                        event.channels.map(chId => (
                          <span key={chId} className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-zinc-950 text-purple-300">
                            {channels.find(ch => ch.id === chId)?.name || chId}
                          </span>
                        ))
                      ) : (
                        <span className="text-[9px] text-zinc-600 italic">No broadcast channels</span>
                      )}
                    </div>

                    <div className="flex gap-2">
                      {isEditing ? (
                        <>
                          <button
                            onClick={() => handleSave(event.id)}
                            className="p-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg transition-colors"
                          >
                            <Save className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={handleCancel}
                            className="p-1.5 bg-zinc-850 hover:bg-zinc-750 text-zinc-400 hover:text-white rounded-lg transition-colors"
                          >
                            <X className="w-3.5 h-3.5" />
                          </button>
                        </>
                      ) : (
                        <>
                          <button
                            onClick={() => handleEdit(event)}
                            className="p-1.5 bg-zinc-950 hover:bg-zinc-850 border border-zinc-805 text-purple-400 hover:text-white rounded-lg transition-all"
                          >
                            <Edit2 className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={() => handleDelete(event.id)}
                            className="p-1.5 bg-zinc-950 hover:bg-red-950/20 border border-zinc-805 text-red-400 hover:text-red-300 rounded-lg transition-all"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        </>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
