'use client';

import React, { useEffect, useRef } from 'react';
import { X, Save, ImagePlus, Star } from 'lucide-react';
import TeamInput from './TeamInput';
import ChannelPicker from './ChannelPicker';
import {
  EventFormState, defaultFormState, SPORT_OPTIONS, STATUS_OPTIONS,
  ChannelData, PlaylistData, generateSlug,
} from './utils';

interface EventFormModalProps {
  isOpen: boolean;
  editingId: string | null;
  formData: EventFormState;
  channels: ChannelData[];
  playlists: PlaylistData[];
  onFormChange: (data: EventFormState) => void;
  onSubmit: (e: React.FormEvent) => void;
  onClose: () => void;
}

export default function EventFormModal({
  isOpen, editingId, formData, channels, playlists,
  onFormChange, onSubmit, onClose,
}: EventFormModalProps) {
  const overlayRef = useRef<HTMLDivElement>(null);

  // Escape key closes modal
  useEffect(() => {
    if (!isOpen) return;
    const handleKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    window.addEventListener('keydown', handleKey);
    return () => window.removeEventListener('keydown', handleKey);
  }, [isOpen, onClose]);

  // Lock body scroll when open
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => { document.body.style.overflow = ''; };
  }, [isOpen]);

  if (!isOpen) return null;

  const set = <K extends keyof EventFormState>(key: K, value: EventFormState[K]) =>
    onFormChange({ ...formData, [key]: value });

  const autoSlug = () => {
    if (!editingId && !formData.id && formData.home_name && formData.away_name) {
      set('id', generateSlug(formData.home_name, formData.away_name));
    }
  };

  return (
    <>
      {/* Full screen modal container */}
      <div
        className="fixed inset-0 bg-zinc-950 z-50 flex flex-col w-screen h-screen animate-fadeIn"
        onClick={e => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between p-5 border-b border-zinc-800 flex-shrink-0 bg-zinc-900">
          <div>
            <h2 className="text-lg font-bold text-white">
              {editingId ? 'Edit Match Event' : 'Schedule New Match'}
            </h2>
            <p className="text-[11px] text-zinc-500 mt-0.5">
              {editingId ? `Editing: ${editingId}` : 'Fill in the match details below'}
            </p>
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-lg hover:bg-zinc-850 text-zinc-400 hover:text-white transition-all border border-zinc-850"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Scrollable body — 2-column on desktop, stacked on mobile */}
        <form onSubmit={onSubmit} className="flex-1 overflow-y-auto bg-zinc-950">
          <div className="grid grid-cols-1 lg:grid-cols-5 gap-0 min-h-full">

            {/* ─── Left Column: Match Details (3/5 width) ─── */}
            <div className="lg:col-span-3 p-6 space-y-6 lg:border-r border-zinc-850 bg-zinc-900/40">

              {/* Section 1: Match Identity */}
              <div className="space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-500">Match Identity</h3>
                <div className="space-y-3">
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-zinc-400">Event ID / Slug</label>
                    <input
                      type="text"
                      placeholder="auto-generated from team names"
                      value={formData.id}
                      onChange={e => set('id', e.target.value)}
                      className="w-full p-2.5 rounded-lg glass-input text-sm font-mono"
                      required
                      disabled={!!editingId}
                    />
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div className="space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">Sport</label>
                      <select
                        value={formData.sport}
                        onChange={e => set('sport', e.target.value)}
                        className="w-full p-2.5 rounded-lg glass-input text-sm"
                      >
                        {SPORT_OPTIONS.map(o => (
                          <option key={o.value} value={o.value}>{o.label}</option>
                        ))}
                      </select>
                    </div>
                    <div className="space-y-1">
                      <label className="text-xs font-semibold text-zinc-400">League / Cup</label>
                      <input
                        type="text"
                        placeholder="e.g. FIFA World Cup"
                        value={formData.league}
                        onChange={e => set('league', e.target.value)}
                        className="w-full p-2.5 rounded-lg glass-input text-sm"
                        required
                      />
                    </div>
                  </div>
                </div>
              </div>

              {/* Divider */}
              <div className="border-t border-zinc-850" />

              {/* Section 2: Teams */}
              <div className="space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-500">Teams</h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <TeamInput
                    label="Home Team"
                    accentColor="text-purple-400"
                    name={formData.home_name}
                    logo={formData.home_logo}
                    onNameChange={v => { set('home_name', v); }}
                    onLogoChange={v => set('home_logo', v)}
                  />
                  <TeamInput
                    label="Away Team"
                    accentColor="text-pink-400"
                    name={formData.away_name}
                    logo={formData.away_logo}
                    onNameChange={v => { set('away_name', v); }}
                    onLogoChange={v => set('away_logo', v)}
                  />
                </div>
                {!editingId && !formData.id && formData.home_name && formData.away_name && (
                  <button
                    type="button"
                    onClick={autoSlug}
                    className="text-[10px] text-purple-400 hover:text-purple-300 transition-colors"
                  >
                    Auto-generate slug: {generateSlug(formData.home_name, formData.away_name)}
                  </button>
                )}
              </div>

              {/* Divider */}
              <div className="border-t border-zinc-850" />

              {/* Section 3: Schedule & Status */}
              <div className="space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-500">Schedule & Status</h3>
                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-zinc-400">Kick-off Time</label>
                    <input
                      type="datetime-local"
                      value={formData.start_time}
                      onChange={e => set('start_time', e.target.value)}
                      className="w-full p-2.5 rounded-lg glass-input text-sm"
                      required
                    />
                  </div>
                  <div className="space-y-1">
                    <label className="text-xs font-semibold text-zinc-400">Status</label>
                    <select
                      value={formData.status}
                      onChange={e => set('status', e.target.value)}
                      className="w-full p-2.5 rounded-lg glass-input text-sm"
                    >
                      {STATUS_OPTIONS.map(o => (
                        <option key={o.value} value={o.value}>{o.label}</option>
                      ))}
                    </select>
                  </div>
                </div>
                <label className="flex items-center gap-2.5 cursor-pointer p-3 rounded-lg bg-zinc-950/60 border border-zinc-805 hover:border-amber-500/30 transition-all group">
                  <input
                    type="checkbox"
                    checked={formData.is_featured}
                    onChange={e => set('is_featured', e.target.checked)}
                    className="rounded border-zinc-700 bg-zinc-950 text-amber-500 focus:ring-amber-500"
                  />
                  <Star className={`w-4 h-4 transition-all ${formData.is_featured ? 'text-amber-400 fill-amber-400' : 'text-zinc-600 group-hover:text-zinc-400'}`} />
                  <div>
                    <span className="text-sm text-zinc-300 font-medium">Featured / Spotlight</span>
                    <p className="text-[10px] text-zinc-500">Highlight in mobile app banner carousel</p>
                  </div>
                </label>
              </div>

              {/* Divider */}
              <div className="border-t border-zinc-850" />

              {/* Section 4: Banner */}
              <div className="space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-500">Spotlight Banner</h3>
                <div className="space-y-2">
                  <div className="relative">
                    <ImagePlus className="absolute left-2.5 top-2.5 w-4 h-4 text-zinc-500" />
                    <input
                      type="text"
                      placeholder="https://example.com/banner.jpg"
                      value={formData.banner}
                      onChange={e => set('banner', e.target.value)}
                      className="w-full pl-9 pr-3 p-2.5 rounded-lg glass-input text-sm"
                    />
                  </div>
                  {formData.banner && (
                    <div className="relative rounded-lg overflow-hidden border border-zinc-800 h-28 bg-zinc-950">
                      <img
                        src={formData.banner}
                        alt="Banner preview"
                        className="w-full h-full object-cover opacity-80"
                        onError={e => { (e.target as HTMLImageElement).style.display = 'none'; }}
                      />
                      <div className="absolute inset-0 bg-gradient-to-t from-zinc-950/80 to-transparent" />
                      <span className="absolute bottom-2 left-3 text-[10px] text-zinc-400">Banner Preview</span>
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* ─── Right Column: Channel Picker (2/5 width) ─── */}
            <div className="lg:col-span-2 p-6 bg-zinc-900/20">
              <ChannelPicker
                channels={channels}
                playlists={playlists}
                selectedIds={formData.channels}
                onChange={ids => set('channels', ids)}
              />
            </div>
          </div>
        </form>

        {/* Footer / Submit */}
        <div className="p-5 border-t border-zinc-800 bg-zinc-900 flex items-center justify-end gap-3 flex-shrink-0">
          <button
            type="button"
            onClick={onClose}
            className="py-2.5 px-6 rounded-xl border border-zinc-800 text-zinc-400 hover:text-white hover:border-zinc-600 text-sm font-semibold transition-all"
          >
            Cancel
          </button>
          <button
            type="submit"
            onClick={(e) => {
              e.preventDefault();
              const form = document.querySelector<HTMLFormElement>('form');
              if (form) {
                form.requestSubmit();
              }
            }}
            className="py-2.5 px-8 rounded-xl bg-purple-600 hover:bg-purple-700 text-white text-sm font-semibold transition-all shadow-lg shadow-purple-500/20 flex items-center justify-center gap-2"
          >
            <Save className="w-4 h-4" />
            {editingId ? 'Save Changes' : 'Schedule Match'}
          </button>
        </div>
      </div>
    </>
  );
}

