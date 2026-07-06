'use client';

import React, { useState, useMemo } from 'react';
import { Search, X, ListChecks, List, Check } from 'lucide-react';
import type { ChannelData, PlaylistData } from './utils';

interface ChannelPickerProps {
  channels: ChannelData[];
  playlists: PlaylistData[];
  selectedIds: string[];
  onChange: (ids: string[]) => void;
}

export default function ChannelPicker({ channels, playlists, selectedIds, onChange }: ChannelPickerProps) {
  const [search, setSearch] = useState('');
  const [appliedPlaylists, setAppliedPlaylists] = useState<string[]>([]);

  const filtered = useMemo(() => {
    const term = search.toLowerCase().trim();
    if (!term) return channels;
    return channels.filter(ch =>
      ch.name.toLowerCase().includes(term) || ch.id.toLowerCase().includes(term)
    );
  }, [channels, search]);

  // Group by category
  const grouped = useMemo(() => {
    const groups: Record<string, ChannelData[]> = {};
    filtered.forEach(ch => {
      const cat = ch.category || 'Uncategorized';
      if (!groups[cat]) groups[cat] = [];
      groups[cat].push(ch);
    });
    return groups;
  }, [filtered]);

  const toggleChannel = (id: string) => {
    if (selectedIds.includes(id)) {
      onChange(selectedIds.filter(x => x !== id));
    } else {
      onChange([...selectedIds, id]);
    }
  };

  // Toggle a playlist: if already applied → remove its channels; otherwise → merge its channels in
  const togglePlaylist = (playlistId: string) => {
    const pl = playlists.find(p => p.id === playlistId);
    if (!pl) return;
    const plChannels = pl.channels || [];

    if (appliedPlaylists.includes(playlistId)) {
      // Un-apply: remove this playlist's channels (unless they belong to another applied playlist)
      const otherAppliedChannels = new Set<string>();
      appliedPlaylists
        .filter(id => id !== playlistId)
        .forEach(id => {
          const other = playlists.find(p => p.id === id);
          if (other) other.channels?.forEach(ch => otherAppliedChannels.add(ch));
        });

      const newSelected = selectedIds.filter(
        chId => !plChannels.includes(chId) || otherAppliedChannels.has(chId)
      );
      onChange(newSelected);
      setAppliedPlaylists(prev => prev.filter(id => id !== playlistId));
    } else {
      // Apply: merge this playlist's channels into the current selection (union, no duplicates)
      const merged = [...new Set([...selectedIds, ...plChannels])];
      onChange(merged);
      setAppliedPlaylists(prev => [...prev, playlistId]);
    }
  };

  const handleClearAll = () => {
    onChange([]);
    setAppliedPlaylists([]);
  };

  const selectedChannelNames = useMemo(() => {
    return selectedIds.map(id => {
      const ch = channels.find(c => c.id === id);
      return ch ? ch.name : id;
    });
  }, [selectedIds, channels]);

  return (
    <div className="space-y-3">
      {/* Header row */}
      <div className="flex items-center justify-between">
        <label className="text-xs font-semibold text-zinc-400 flex items-center gap-1.5">
          <ListChecks className="w-3.5 h-3.5" />
          Broadcasting Channels
        </label>
        <span className="text-[10px] font-mono text-purple-400 bg-purple-500/10 px-2 py-0.5 rounded-full">
          {selectedIds.length} selected
        </span>
      </div>

      {/* Multi-select playlist chips */}
      <div className="space-y-1.5">
        <div className="flex items-center justify-between">
          <span className="text-[10px] font-semibold text-zinc-500 flex items-center gap-1">
            <List className="w-3 h-3" />
            Quick Apply Playlists
            {appliedPlaylists.length > 0 && (
              <span className="text-purple-400 ml-1">({appliedPlaylists.length} applied)</span>
            )}
          </span>
          {selectedIds.length > 0 && (
            <button
              type="button"
              onClick={handleClearAll}
              className="text-[10px] text-zinc-500 hover:text-red-400 transition-all font-semibold"
            >
              Clear all
            </button>
          )}
        </div>
        <div className="flex flex-wrap gap-1.5">
          {playlists.map(pl => {
            const isApplied = appliedPlaylists.includes(pl.id);
            return (
              <button
                key={pl.id}
                type="button"
                onClick={() => togglePlaylist(pl.id)}
                className={`inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg text-[11px] font-semibold transition-all border ${
                  isApplied
                    ? 'bg-purple-950/50 border-purple-500/40 text-purple-300 ring-1 ring-purple-500/20 shadow-sm shadow-purple-500/10'
                    : 'bg-zinc-900/80 border-zinc-800 text-zinc-400 hover:border-zinc-700 hover:text-zinc-200'
                }`}
              >
                {isApplied ? (
                  <Check className="w-3 h-3 text-purple-400" />
                ) : (
                  <List className="w-3 h-3 text-zinc-600" />
                )}
                {pl.name}
                <span className={`text-[9px] font-mono ${isApplied ? 'text-purple-400/70' : 'text-zinc-600'}`}>
                  {pl.channels?.length || 0}
                </span>
              </button>
            );
          })}
        </div>
      </div>

      {/* Selected chips */}
      {selectedIds.length > 0 && (
        <div className="flex flex-wrap gap-1.5 p-2.5 rounded-lg bg-zinc-950/60 border border-zinc-800/60 max-h-20 overflow-y-auto">
          {selectedChannelNames.slice(0, 20).map((name, i) => (
            <button
              key={selectedIds[i]}
              type="button"
              onClick={() => toggleChannel(selectedIds[i])}
              className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-purple-950/50 border border-purple-500/30 text-[10px] text-purple-300 hover:bg-red-950/40 hover:border-red-500/30 hover:text-red-300 transition-all group"
            >
              {name}
              <X className="w-2.5 h-2.5 opacity-50 group-hover:opacity-100" />
            </button>
          ))}
          {selectedIds.length > 20 && (
            <span className="text-[10px] text-zinc-500 self-center">+{selectedIds.length - 20} more</span>
          )}
        </div>
      )}

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-2.5 top-2.5 w-3.5 h-3.5 text-zinc-500" />
        <input
          type="text"
          placeholder="Search channels…"
          value={search}
          onChange={e => setSearch(e.target.value)}
          className="w-full pl-8 pr-3 py-2 rounded-lg bg-zinc-900 border border-zinc-800 text-xs text-white placeholder-zinc-600 focus:border-purple-500/60 focus:outline-none transition-all"
        />
      </div>

      {/* Channel list */}
      <div className="max-h-52 overflow-y-auto rounded-lg bg-zinc-950/80 border border-zinc-800 divide-y divide-zinc-800/40">
        {Object.entries(grouped).map(([category, chs]) => (
          <div key={category}>
            <div className="sticky top-0 px-3 py-1.5 bg-zinc-900/95 backdrop-blur-sm text-[9px] font-bold uppercase tracking-widest text-zinc-500 border-b border-zinc-800/40">
              {category}
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-0.5 p-1">
              {chs.map(ch => {
                const isSelected = selectedIds.includes(ch.id);
                return (
                  <button
                    key={ch.id}
                    type="button"
                    onClick={() => toggleChannel(ch.id)}
                    className={`flex items-center gap-2 p-2 rounded-lg text-left text-xs truncate transition-all ${
                      isSelected
                        ? 'bg-purple-950/40 text-purple-300 font-semibold ring-1 ring-purple-500/40'
                        : 'text-zinc-400 hover:bg-zinc-800/60 hover:text-zinc-200'
                    }`}
                  >
                    <div className={`w-3.5 h-3.5 rounded border flex-shrink-0 flex items-center justify-center transition-all ${
                      isSelected
                        ? 'bg-purple-600 border-purple-500'
                        : 'border-zinc-700 bg-zinc-950'
                    }`}>
                      {isSelected && (
                        <svg className="w-2.5 h-2.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                          <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                        </svg>
                      )}
                    </div>
                    <span className="truncate">{ch.name}</span>
                  </button>
                );
              })}
            </div>
          </div>
        ))}
        {filtered.length === 0 && (
          <div className="py-6 text-center text-xs text-zinc-600">No channels match "{search}"</div>
        )}
      </div>
    </div>
  );
}
