'use client';

import React, { useState, useEffect } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import { Plus, Edit2, Trash2, Save, X, Bell, Info, AlertTriangle, CheckCircle, ToggleLeft, ToggleRight } from 'lucide-react';

interface Announcement {
  id: string; // uuid
  title: string;
  body: string;
  type: string;
  active: boolean;
  created_at: string;
}

interface AnnouncementManagerProps {
  adminToken: string;
  onRefreshStats: () => void;
}

export default function AnnouncementManager({ adminToken, onRefreshStats }: AnnouncementManagerProps) {
  const [announcements, setAnnouncements] = useState<Announcement[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  // Form states
  const [showAddForm, setShowAddForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [formData, setFormData] = useState({
    title: '',
    body: '',
    type: 'info',
    active: true
  });

  const supabaseAdmin = createAdminSupabaseClient(adminToken);

  const fetchAnnouncements = async () => {
    try {
      setLoading(true);
      setError(null);
      const { data, error: fetchErr } = await supabaseAdmin
        .from('announcements')
        .select('*')
        .order('created_at', { ascending: false });

      if (fetchErr) throw fetchErr;
      setAnnouncements(data || []);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch announcements');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAnnouncements();
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

  const handleEdit = (announcement: Announcement) => {
    setEditingId(announcement.id);
    setFormData({
      title: announcement.title,
      body: announcement.body,
      type: announcement.type,
      active: announcement.active
    });
    setShowAddForm(false);
  };

  const handleCancel = () => {
    setEditingId(null);
    setFormData({
      title: '',
      body: '',
      type: 'info',
      active: true
    });
  };

  const handleSave = async (id: string) => {
    try {
      if (!formData.title.trim()) {
        showNotification('error', 'Title is required');
        return;
      }
      if (!formData.body.trim()) {
        showNotification('error', 'Announcement body is required');
        return;
      }

      const { error: updateErr } = await supabaseAdmin
        .from('announcements')
        .update({
          title: formData.title.trim(),
          body: formData.body.trim(),
          type: formData.type,
          active: formData.active
        })
        .eq('id', id);

      if (updateErr) throw updateErr;

      showNotification('success', 'Announcement updated successfully');
      setEditingId(null);
      fetchAnnouncements();
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to update announcement');
    }
  };

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (!formData.title.trim()) {
        showNotification('error', 'Announcement Title is required');
        return;
      }
      if (!formData.body.trim()) {
        showNotification('error', 'Announcement Body is required');
        return;
      }

      const { error: insertErr } = await supabaseAdmin
        .from('announcements')
        .insert({
          title: formData.title.trim(),
          body: formData.body.trim(),
          type: formData.type,
          active: formData.active
        });

      if (insertErr) throw insertErr;

      showNotification('success', 'Announcement published successfully');
      handleCancel();
      setShowAddForm(false);
      fetchAnnouncements();
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to publish announcement');
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this announcement?')) {
      return;
    }

    try {
      const { error: deleteErr } = await supabaseAdmin
        .from('announcements')
        .delete()
        .eq('id', id);

      if (deleteErr) throw deleteErr;

      showNotification('success', 'Announcement deleted successfully');
      fetchAnnouncements();
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to delete announcement');
    }
  };

  const toggleActiveState = async (id: string, currentActive: boolean) => {
    try {
      const { error: toggleErr } = await supabaseAdmin
        .from('announcements')
        .update({ active: !currentActive })
        .eq('id', id);

      if (toggleErr) throw toggleErr;

      // Update state locally
      setAnnouncements(prev => prev.map(ann => ann.id === id ? { ...ann, active: !currentActive } : ann));
      onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to toggle active state');
    }
  };

  const getAnnouncementIcon = (type: string) => {
    switch (type) {
      case 'warning':
        return <AlertTriangle className="w-5 h-5 text-amber-400" />;
      case 'success':
        return <CheckCircle className="w-5 h-5 text-emerald-400" />;
      default:
        return <Info className="w-5 h-5 text-blue-400" />;
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <Bell className="text-purple-400 w-6 h-6" />
            Announcement Manager
          </h1>
          <p className="text-xs text-zinc-500 mt-1">Publish system notices, server maintenance warnings, or app updates</p>
        </div>
        <button
          onClick={() => {
            setShowAddForm(!showAddForm);
            handleCancel();
          }}
          className="flex items-center gap-2 px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200 shadow-lg shadow-purple-500/20 hover:scale-[1.02]"
        >
          {showAddForm ? <X className="w-4 h-4" /> : <Plus className="w-4 h-4" />}
          {showAddForm ? 'Close Form' : 'New Notice'}
        </button>
      </div>

      {/* Notifications */}
      {error && (
        <div className="p-4 rounded-xl bg-red-950/40 border border-red-900/50 text-red-400 text-sm animate-shake">
          ⚠️ {error}
        </div>
      )}
      {success && (
        <div className="p-4 rounded-xl bg-emerald-950/40 border border-emerald-900/50 text-emerald-400 text-sm animate-fadeIn">
          ✓ {success}
        </div>
      )}

      {/* Add Announcement Form */}
      {showAddForm && (
        <form onSubmit={handleAdd} className="p-6 rounded-2xl glass-panel space-y-4 max-w-2xl animate-slideDown">
          <h3 className="text-lg font-semibold text-white">Publish New Announcement</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="md:col-span-2 space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Notice Title</label>
              <input
                type="text"
                placeholder="e.g. Scheduled System Maintenance"
                value={formData.title}
                onChange={e => setFormData({ ...formData, title: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
                required
              />
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Notice Level</label>
              <select
                value={formData.type}
                onChange={e => setFormData({ ...formData, type: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              >
                <option value="info">Info (Blue)</option>
                <option value="warning">Warning / Alert (Yellow)</option>
                <option value="success">Success / Promo (Green)</option>
              </select>
            </div>
            <div className="flex items-center pt-6">
              <label className="flex items-center gap-2 cursor-pointer text-sm text-zinc-300">
                <input
                  type="checkbox"
                  checked={formData.active}
                  onChange={e => setFormData({ ...formData, active: e.target.checked })}
                  className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500"
                />
                Active immediately
              </label>
            </div>
            <div className="md:col-span-2 space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Notice Message</label>
              <textarea
                rows={3}
                placeholder="Write the announcement message details here..."
                value={formData.body}
                onChange={e => setFormData({ ...formData, body: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm resize-none"
                required
              ></textarea>
            </div>
          </div>
          <button
            type="submit"
            className="px-5 py-2.5 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200"
          >
            Publish Notice
          </button>
        </form>
      )}

      {/* Announcements Listing */}
      <div className="p-6 rounded-2xl glass-panel space-y-4">
        {loading ? (
          <div className="text-center py-12 text-zinc-500">Loading announcements library...</div>
        ) : announcements.length === 0 ? (
          <div className="text-center py-12 text-zinc-500">No announcements published.</div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {announcements.map((ann) => {
              const isEditing = editingId === ann.id;
              return (
                <div 
                  key={ann.id} 
                  className={`p-5 rounded-xl border transition-all duration-200 ${
                    ann.active 
                      ? 'bg-zinc-900/60 border-zinc-800' 
                      : 'bg-zinc-950/40 border-zinc-900 opacity-60'
                  }`}
                >
                  <div className="flex justify-between items-start mb-3">
                    <div className="flex items-center gap-2">
                      {getAnnouncementIcon(ann.type)}
                      <span className="text-[10px] font-bold uppercase tracking-wider text-zinc-500">
                        {ann.type} level
                      </span>
                    </div>
                    
                    {/* Active Toggle Switch */}
                    <div className="flex items-center gap-2">
                      <span className="text-[10px] text-zinc-500 font-medium">Active</span>
                      {isEditing ? (
                        <input
                          type="checkbox"
                          checked={formData.active}
                          onChange={e => setFormData({ ...formData, active: e.target.checked })}
                        />
                      ) : (
                        <button
                          onClick={() => toggleActiveState(ann.id, ann.active)}
                          className="focus:outline-none"
                        >
                          {ann.active ? (
                            <ToggleRight className="w-5 h-5 text-purple-400" />
                          ) : (
                            <ToggleLeft className="w-5 h-5 text-zinc-600" />
                          )}
                        </button>
                      )}
                    </div>
                  </div>

                  {/* Title & Body */}
                  {isEditing ? (
                    <div className="space-y-3 mb-3">
                      <input
                        type="text"
                        value={formData.title}
                        onChange={e => setFormData({ ...formData, title: e.target.value })}
                        className="w-full p-2 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                        placeholder="Title"
                      />
                      <select
                        value={formData.type}
                        onChange={e => setFormData({ ...formData, type: e.target.value })}
                        className="w-full p-2 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                      >
                        <option value="info">Info</option>
                        <option value="warning">Warning</option>
                        <option value="success">Success</option>
                      </select>
                      <textarea
                        rows={2}
                        value={formData.body}
                        onChange={e => setFormData({ ...formData, body: e.target.value })}
                        className="w-full p-2 rounded bg-zinc-950 border border-zinc-800 text-xs text-white resize-none"
                        placeholder="Body"
                      ></textarea>
                    </div>
                  ) : (
                    <div className="space-y-2 mb-4">
                      <h4 className="font-bold text-white text-sm">{ann.title}</h4>
                      <p className="text-xs text-zinc-400 leading-relaxed">{ann.body}</p>
                    </div>
                  )}

                  {/* Timestamp & Actions */}
                  <div className="flex justify-between items-center pt-3 border-t border-zinc-800/40">
                    <span className="text-[9px] font-mono text-zinc-500">
                      {ann.created_at ? new Date(ann.created_at).toLocaleString() : 'Just now'}
                    </span>

                    <div className="flex gap-2">
                      {isEditing ? (
                        <>
                          <button
                            onClick={() => handleSave(ann.id)}
                            className="p-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg transition-colors"
                          >
                            <Save className="w-3 h-3" />
                          </button>
                          <button
                            onClick={handleCancel}
                            className="p-1.5 bg-zinc-850 hover:bg-zinc-750 text-zinc-400 hover:text-white rounded-lg transition-colors"
                          >
                            <X className="w-3 h-3" />
                          </button>
                        </>
                      ) : (
                        <>
                          <button
                            onClick={() => handleEdit(ann)}
                            className="p-1.5 bg-zinc-950 hover:bg-zinc-850 border border-zinc-850 text-purple-400 hover:text-white rounded-lg transition-all"
                          >
                            <Edit2 className="w-3 h-3" />
                          </button>
                          <button
                            onClick={() => handleDelete(ann.id)}
                            className="p-1.5 bg-zinc-950 hover:bg-red-950/20 border border-zinc-850 text-red-400 hover:text-red-300 rounded-lg transition-all"
                          >
                            <Trash2 className="w-3 h-3" />
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
