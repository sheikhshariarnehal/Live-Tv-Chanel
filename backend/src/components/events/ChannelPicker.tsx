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
  const [draggedIndex, setDraggedIndex] = useState<number | null>(null);

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

  // HTML5 Drag and Drop event handlers for horizontal sorting
  const handleDragStart = (e: React.DragEvent, index: number) => {
    setDraggedIndex(index);
    e.dataTransfer.effectAllowed = 'move';
  };

  const handleDragOver = (e: React.DragEvent, index: number) => {
    e.preventDefault();
    if (draggedIndex === null || draggedIndex === index) return;

    const newIds = [...selectedIds];
    const draggedItem = newIds[draggedIndex];
    newIds.splice(draggedIndex, 1);
    newIds.splice(index, 0, draggedItem);

    setDraggedIndex(index);
    onChange(newIds);
  };

  const handleDragEnd = () => {
    setDraggedIndex(null);
  };

  return (
    <div className="space-y-4">
      {/* Header row */}
      <div className="flex items-center justify-between">
        <label className="text-xs font-semibold text-zinc-400 flex items-center gap-1.5">
          <ListChecks className="w-3.5 h-3.5 text-purple-400" />
          Broadcasting Channels
        </label>
        <span className="text-[10px] font-mono text-purple-400 bg-purple-500/10 px-2.5 py-0.5 rounded-full font-bold font-semibold">
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
              className="text-[10px] text-zinc-550 hover:text-red-400 transition-all font-semibold cursor-pointer"
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
                className={`inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg text-[11px] font-semibold transition-all border cursor-pointer ${
                  isApplied
                    ? 'bg-purple-950/50 border-purple-500/40 text-purple-300 ring-1 ring-purple-500/20 shadow-sm shadow-purple-500/10'
                    : 'bg-zinc-900/80 border-zinc-805 text-zinc-400 hover:border-zinc-700 hover:text-zinc-200'
                }`}
              >
                {isApplied ? (
                  <Check className="w-3 h-3 text-purple-400" />
                ) : (
                  <List className="w-3 h-3 text-zinc-650" />
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

      {/* Selected channel pills with Drag & Drop sorting */}
      {selectedIds.length > 0 && (
        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-[10px] font-bold text-zinc-500 uppercase tracking-wider">
              Broadcasting Priority (Drag to Sort)
            </span>
            <span className="text-[9.5px] text-zinc-500">
              Leftmost is primary channel
            </span>
          </div>

          <div className="flex flex-wrap gap-2 p-2.5 rounded-xl bg-zinc-950/60 border border-zinc-850 min-h-12 max-h-36 overflow-y-auto custom-scrollbar">
            {selectedIds.map((id, index) => {
              const ch = channels.find(c => c.id === id);
              const name = ch ? ch.name : id;
              const isDragging = draggedIndex === index;

              return (
                <div
                  key={id}
                  draggable
                  onDragStart={(e) => handleDragStart(e, index)}
                  onDragOver={(e) => handleDragOver(e, index)}
                  onDragEnd={handleDragEnd}
                  className={`inline-flex items-center gap-1.5 px-4 py-1.5 rounded-full text-xs font-semibold select-none cursor-grab active:cursor-grabbing border transition-all ${
                    isDragging
                      ? 'bg-purple-600/85 border-purple-400 text-white opacity-40 scale-95'
                      : 'bg-purple-950/50 border-purple-500/30 text-purple-300 hover:border-purple-500/60 hover:bg-purple-900/60'
                  }`}
                >
                  <span className="font-semibold">{name}</span>
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      toggleChannel(id);
                    }}
                    className="p-0.5 rounded-full hover:bg-purple-800/40 text-purple-400/80 hover:text-white transition cursor-pointer flex items-center justify-center"
                    title="Remove"
                  >
                    <X className="w-3 h-3" />
                  </button>
                </div>
              );
            })}
          </div>
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
          className="w-full pl-8 pr-3 py-2 rounded-lg bg-zinc-900 border border-zinc-805 text-xs text-white placeholder-zinc-650 focus:border-purple-500/60 focus:outline-none transition-all"
        />
      </div>

      {/* Channel list */}
      <div className="max-h-52 overflow-y-auto rounded-lg bg-zinc-950/80 border border-zinc-805 divide-y divide-zinc-800/40 custom-scrollbar">
        {Object.entries(grouped).map(([category, chs]) => (
          <div key={category}>
            <div className="sticky top-0 px-3 py-1.5 bg-zinc-900/95 backdrop-blur-sm text-[9px] font-bold uppercase tracking-widest text-zinc-500 border-b border-zinc-805/40">
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
                    className={`flex items-center gap-2 p-2 rounded-lg text-left text-xs truncate transition-all cursor-pointer ${
                      isSelected
                        ? 'bg-purple-950/40 text-purple-300 font-semibold ring-1 ring-purple-500/40'
                        : 'text-zinc-400 hover:bg-zinc-850/60 hover:text-zinc-200'
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
          <div className="py-6 text-center text-xs text-zinc-650">No channels match "{search}"</div>
        )}
      </div>
    </div>
  );
}
