'use client';

import React, { useState, useEffect, useMemo, useCallback } from 'react';
import { createAdminSupabaseClient } from '../../utils/supabase';
import { AlertCircle, Check, Trash2, CheckCircle, Calendar } from 'lucide-react';
import 'flag-icons/css/flag-icons.min.css';

import EventHeader from './EventHeader';
import EventFilters from './EventFilters';
import EventTable from './EventTable';
import EventCard from './EventCard';
import EventFormModal from './EventFormModal';
import {
  EventData, ChannelData, PlaylistData, EventFormState,
  defaultFormState, eventToFormState, formStateToPayload, cleanFlagValue,
  parseLocalDateTime,
} from './utils';

interface EventManagerProps {
  adminToken: string;
  onRefreshStats: () => void;
}

export default function EventManager({ adminToken, onRefreshStats }: EventManagerProps) {
  // ── Data state ──────────────────────────────────────────────────────
  const [events, setEvents] = useState<EventData[]>([]);
  const [channels, setChannels] = useState<ChannelData[]>([]);
  const [playlists, setPlaylists] = useState<PlaylistData[]>([]);
  const [loading, setLoading] = useState(true);

  // ── UI state ────────────────────────────────────────────────────────
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [viewMode, setViewMode] = useState<'table' | 'cards'>('table');
  const [selectedIds, setSelectedIds] = useState<string[]>([]);

  // ── Form state ──────────────────────────────────────────────────────
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [formData, setFormData] = useState<EventFormState>(defaultFormState);

  // ── Pagination ──────────────────────────────────────────────────────
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  const supabaseAdmin = useMemo(() => createAdminSupabaseClient(adminToken), [adminToken]);

  // ── Data fetching ───────────────────────────────────────────────────
  const fetchData = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const [evRes, plRes] = await Promise.all([
        supabaseAdmin.from('events').select('*').order('start_time', { ascending: true }),
        supabaseAdmin.from('playlists').select('*').order('name', { ascending: true }),
      ]);

      if (evRes.error) throw evRes.error;
      if (plRes.error) throw plRes.error;

      // Fetch all Channels using pagination (bypass 1000-row PostgREST limit)
      const BATCH_SIZE = 1000;
      let offset = 0;
      const allChannels: any[] = [];

      while (true) {
        const { data: batch, error: chErr } = await supabaseAdmin
          .from('channels')
          .select('id, name, category')
          .order('name', { ascending: true })
          .range(offset, offset + BATCH_SIZE - 1);

        if (chErr) throw chErr;
        if (!batch || batch.length === 0) break;
        allChannels.push(...batch);

        if (batch.length < BATCH_SIZE) break;
        offset += BATCH_SIZE;
      }

      setEvents(evRes.data || []);
      setChannels(allChannels);
      setPlaylists(plRes.data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch data');
    } finally {
      setLoading(false);
    }
  }, [supabaseAdmin]);

  useEffect(() => { fetchData(); }, [fetchData]);

  // ── Notifications ───────────────────────────────────────────────────
  const notify = useCallback((type: 'success' | 'error', msg: string) => {
    if (type === 'success') {
      setSuccess(msg);
      setTimeout(() => setSuccess(null), 3000);
    } else {
      setError(msg);
      setTimeout(() => setError(null), 4000);
    }
  }, []);

  // ── Filtering ───────────────────────────────────────────────────────
  const filteredEvents = useMemo(() => {
    const term = searchTerm.toLowerCase().trim();
    return events.filter(event => {
      const home = event.home_team?.name || '';
      const away = event.away_team?.name || '';
      const text = `${home} ${away} ${event.league} ${event.sport} ${event.id}`.toLowerCase();
      const matchesSearch = !term || text.includes(term);
      const matchesStatus = statusFilter === 'all' || event.status === statusFilter;
      return matchesSearch && matchesStatus;
    });
  }, [events, searchTerm, statusFilter]);

  // ── Pagination ──────────────────────────────────────────────────────
  const totalPages = Math.ceil(filteredEvents.length / itemsPerPage);
  const paginatedEvents = useMemo(() => {
    const start = (currentPage - 1) * itemsPerPage;
    return filteredEvents.slice(start, start + itemsPerPage);
  }, [filteredEvents, currentPage]);

  // Reset page when filters change
  useEffect(() => { setCurrentPage(1); setSelectedIds([]); }, [searchTerm, statusFilter]);

  // ── Form handlers ───────────────────────────────────────────────────
  const openNewForm = useCallback(() => {
    setEditingId(null);
    setFormData(defaultFormState);
    setIsFormOpen(true);
  }, []);

  const openEditForm = useCallback((event: EventData) => {
    setEditingId(event.id);
    setFormData(eventToFormState(event));
    setIsFormOpen(true);
  }, []);

  const closeForm = useCallback(() => {
    setIsFormOpen(false);
    setEditingId(null);
    setFormData(defaultFormState);
  }, []);

  const handleSubmit = useCallback(async (e: React.FormEvent) => {
    e.preventDefault();

    if (formData.hero_type === 1 && (!formData.home_name.trim() || !formData.away_name.trim())) {
      notify('error', 'Both team names are required for matchup style events');
      return;
    }

    if (formData.hero_type === 2 && !formData.custom_title.trim()) {
      notify('error', 'Custom title is required for spotlight style events');
      return;
    }

    try {
      if (editingId) {
        // Update
        const { error: err } = await supabaseAdmin
          .from('events')
          .update(formStateToPayload(formData))
          .eq('id', editingId);
        if (err) throw err;
        notify('success', 'Match event updated successfully');
      } else {
        // Create
        if (!formData.id.trim()) {
          notify('error', 'Event ID/Slug is required');
          return;
        }
        const idExists = events.some(ev => ev.id === formData.id.toLowerCase().trim());
        if (idExists) {
          notify('error', 'Event ID already exists');
          return;
        }
        const cleanId = formData.id.toLowerCase().replace(/[^a-z0-9-_]/g, '-').trim();
        const { error: err } = await supabaseAdmin
          .from('events')
          .insert({ id: cleanId, ...formStateToPayload(formData) });
        if (err) throw err;
        notify('success', 'Match event scheduled successfully');
      }
      closeForm();
      fetchData();
      onRefreshStats();
    } catch (err) {
      notify('error', err instanceof Error ? err.message : 'Operation failed');
    }
  }, [editingId, formData, events, supabaseAdmin, closeForm, fetchData, onRefreshStats, notify]);

  // ── Inline actions ──────────────────────────────────────────────────
  const handleDelete = useCallback(async (id: string) => {
    if (!confirm(`Delete event "${id}"?`)) return;
    try {
      const { error: err } = await supabaseAdmin.from('events').delete().eq('id', id);
      if (err) throw err;
      notify('success', 'Event deleted');
      fetchData();
      onRefreshStats();
    } catch (err) {
      notify('error', err instanceof Error ? err.message : 'Failed to delete');
    }
  }, [supabaseAdmin, fetchData, onRefreshStats, notify]);

  const handleStatusChange = useCallback(async (id: string, newStatus: string) => {
    try {
      const { error: err } = await supabaseAdmin.from('events').update({ status: newStatus }).eq('id', id);
      if (err) throw err;
      notify('success', `Status → ${newStatus}`);
      setEvents(prev => prev.map(ev => ev.id === id ? { ...ev, status: newStatus } : ev));
      onRefreshStats();
    } catch (err) {
      notify('error', err instanceof Error ? err.message : 'Failed to update status');
    }
  }, [supabaseAdmin, onRefreshStats, notify]);

  const handleToggleFeatured = useCallback(async (id: string, current: boolean) => {
    try {
      const { error: err } = await supabaseAdmin.from('events').update({ is_featured: !current }).eq('id', id);
      if (err) throw err;
      notify('success', !current ? 'Featured ⭐' : 'Unfeatured');
      setEvents(prev => prev.map(ev => ev.id === id ? { ...ev, is_featured: !current } : ev));
      onRefreshStats();
    } catch (err) {
      notify('error', err instanceof Error ? err.message : 'Failed to toggle featured');
    }
  }, [supabaseAdmin, onRefreshStats, notify]);

  const handleDuplicate = useCallback((event: EventData) => {
    setEditingId(null);
    setFormData({
      ...eventToFormState(event),
      id: event.id + '-copy',
      status: 'upcoming',
    });
    setIsFormOpen(true);
  }, []);

  // ── Bulk actions ────────────────────────────────────────────────────
  const handleSelectToggle = useCallback((id: string) => {
    setSelectedIds(prev => prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]);
  }, []);

  const handleSelectAll = useCallback((ids: string[]) => {
    const allSelected = ids.every(id => selectedIds.includes(id));
    if (allSelected) {
      setSelectedIds(prev => prev.filter(id => !ids.includes(id)));
    } else {
      setSelectedIds(prev => [...new Set([...prev, ...ids])]);
    }
  }, [selectedIds]);

  const handleBulkDelete = useCallback(async () => {
    if (!confirm(`Delete ${selectedIds.length} selected events?`)) return;
    try {
      const { error: err } = await supabaseAdmin.from('events').delete().in('id', selectedIds);
      if (err) throw err;
      notify('success', `${selectedIds.length} events deleted`);
      setSelectedIds([]);
      fetchData();
      onRefreshStats();
    } catch (err) {
      notify('error', err instanceof Error ? err.message : 'Bulk delete failed');
    }
  }, [selectedIds, supabaseAdmin, fetchData, onRefreshStats, notify]);

  const handleBulkComplete = useCallback(async () => {
    try {
      const { error: err } = await supabaseAdmin.from('events').update({ status: 'completed' }).in('id', selectedIds);
      if (err) throw err;
      notify('success', `${selectedIds.length} events marked completed`);
      setSelectedIds([]);
      fetchData();
      onRefreshStats();
    } catch (err) {
      notify('error', err instanceof Error ? err.message : 'Bulk update failed');
    }
  }, [selectedIds, supabaseAdmin, fetchData, onRefreshStats, notify]);

  // ── Keyboard shortcuts ──────────────────────────────────────────────
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement || e.target instanceof HTMLSelectElement) return;
      if (e.key === 'n' && !e.ctrlKey && !e.metaKey && !isFormOpen) {
        e.preventDefault();
        openNewForm();
      }
    };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [isFormOpen, openNewForm]);

  // ── Render ──────────────────────────────────────────────────────────
  return (
    <div className="space-y-5">
      {/* Header */}
      <EventHeader events={events} onScheduleNew={openNewForm} />

      {/* Notifications */}
      {error && (
        <div className="p-3.5 rounded-xl bg-red-950/40 border border-red-900/50 text-red-400 text-sm flex items-center gap-2 animate-fadeIn">
          <AlertCircle className="w-4 h-4 flex-shrink-0" />
          <span>{error}</span>
        </div>
      )}
      {success && (
        <div className="p-3.5 rounded-xl bg-emerald-950/40 border border-emerald-900/50 text-emerald-400 text-sm flex items-center gap-2 animate-fadeIn">
          <Check className="w-4 h-4 flex-shrink-0" />
          <span>{success}</span>
        </div>
      )}

      {/* Filters */}
      <div className="p-5 rounded-2xl glass-panel space-y-4">
        <EventFilters
          searchTerm={searchTerm}
          onSearchChange={setSearchTerm}
          statusFilter={statusFilter}
          onStatusFilterChange={setStatusFilter}
          viewMode={viewMode}
          onViewModeChange={setViewMode}
          totalCount={events.length}
          filteredCount={filteredEvents.length}
        />

        {/* Bulk action bar */}
        {selectedIds.length > 0 && (
          <div className="flex items-center justify-between p-3 bg-purple-950/20 border border-purple-500/20 rounded-xl animate-fadeIn">
            <span className="text-xs font-semibold text-purple-300">
              {selectedIds.length} event{selectedIds.length > 1 ? 's' : ''} selected
            </span>
            <div className="flex items-center gap-2">
              <button
                onClick={handleBulkComplete}
                className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-600/80 hover:bg-emerald-600 text-white rounded-lg text-xs font-semibold transition-all"
              >
                <CheckCircle className="w-3 h-3" />
                Mark Completed
              </button>
              <button
                onClick={handleBulkDelete}
                className="flex items-center gap-1.5 px-3 py-1.5 bg-red-600/80 hover:bg-red-600 text-white rounded-lg text-xs font-semibold transition-all"
              >
                <Trash2 className="w-3 h-3" />
                Delete
              </button>
              <button
                onClick={() => setSelectedIds([])}
                className="px-3 py-1.5 text-xs text-zinc-400 hover:text-white transition-all"
              >
                Clear
              </button>
            </div>
          </div>
        )}

        {/* Content */}
        {loading ? (
          /* Skeleton loading */
          <div className="space-y-3">
            {[...Array(4)].map((_, i) => (
              <div key={i} className="h-16 rounded-xl bg-zinc-900/60 animate-pulse" />
            ))}
          </div>
        ) : filteredEvents.length === 0 ? (
          /* Empty state */
          <div className="flex flex-col items-center justify-center py-16 text-center">
            <div className="w-16 h-16 rounded-2xl bg-zinc-900 border border-zinc-800 flex items-center justify-center mb-4">
              <Calendar className="w-7 h-7 text-zinc-700" />
            </div>
            <h3 className="text-sm font-semibold text-zinc-400 mb-1">No matches found</h3>
            <p className="text-xs text-zinc-600 max-w-[280px]">
              {searchTerm || statusFilter !== 'all'
                ? 'Try adjusting your search or filters'
                : 'Schedule your first match to get started'
              }
            </p>
            {!searchTerm && statusFilter === 'all' && (
              <button
                onClick={openNewForm}
                className="mt-4 px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-xs font-semibold transition-all"
              >
                Schedule First Match
              </button>
            )}
          </div>
        ) : (
          <>
            {/* Desktop table view */}
            {viewMode === 'table' && (
              <EventTable
                events={paginatedEvents}
                channels={channels}
                selectedIds={selectedIds}
                onSelectToggle={handleSelectToggle}
                onSelectAll={handleSelectAll}
                onEdit={openEditForm}
                onDelete={handleDelete}
                onDuplicate={handleDuplicate}
                onStatusChange={handleStatusChange}
                onToggleFeatured={handleToggleFeatured}
              />
            )}

            {/* Mobile card view — always show on mobile, optionally on desktop */}
            <div className={viewMode === 'cards' ? 'block' : 'md:hidden block'}>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                {paginatedEvents.map(event => (
                  <EventCard
                    key={event.id}
                    event={event}
                    channels={channels}
                    onEdit={openEditForm}
                    onDelete={handleDelete}
                    onDuplicate={handleDuplicate}
                    onStatusChange={handleStatusChange}
                    onToggleFeatured={handleToggleFeatured}
                  />
                ))}
              </div>
            </div>

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="flex items-center justify-between pt-4 border-t border-zinc-800/40">
                <span className="text-[10px] text-zinc-600">
                  Page {currentPage} of {totalPages}
                </span>
                <div className="flex items-center gap-1">
                  <button
                    onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                    disabled={currentPage === 1}
                    className="px-3 py-1.5 rounded-lg border border-zinc-800 text-xs text-zinc-400 hover:text-white hover:border-zinc-600 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                  >
                    Previous
                  </button>
                  {Array.from({ length: Math.min(totalPages, 5) }, (_, i) => {
                    const page = i + 1;
                    return (
                      <button
                        key={page}
                        onClick={() => setCurrentPage(page)}
                        className={`w-8 h-8 rounded-lg text-xs font-semibold transition-all ${
                          currentPage === page
                            ? 'bg-purple-600 text-white'
                            : 'text-zinc-500 hover:bg-zinc-800 hover:text-zinc-200'
                        }`}
                      >
                        {page}
                      </button>
                    );
                  })}
                  {totalPages > 5 && <span className="text-zinc-600 text-xs px-1">…</span>}
                  <button
                    onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}
                    disabled={currentPage === totalPages}
                    className="px-3 py-1.5 rounded-lg border border-zinc-800 text-xs text-zinc-400 hover:text-white hover:border-zinc-600 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                  >
                    Next
                  </button>
                </div>
              </div>
            )}
          </>
        )}
      </div>

      {/* Form Modal */}
      <EventFormModal
        isOpen={isFormOpen}
        editingId={editingId}
        formData={formData}
        channels={channels}
        playlists={playlists}
        onFormChange={setFormData}
        onSubmit={handleSubmit}
        onClose={closeForm}
      />
    </div>
  );
}
