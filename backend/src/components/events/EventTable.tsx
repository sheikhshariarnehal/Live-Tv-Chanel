'use client';

import React, { useState } from 'react';
import { Edit2, Trash2, Play, CheckCircle, Copy, Star, ChevronDown } from 'lucide-react';
import FlagRenderer from './FlagRenderer';
import StatusBadge from './StatusBadge';
import CountdownTimer from './CountdownTimer';
import { EventData, ChannelData, parseUtcDate } from './utils';

interface EventTableProps {
  events: EventData[];
  channels: ChannelData[];
  selectedIds: string[];
  onSelectToggle: (id: string) => void;
  onSelectAll: (ids: string[]) => void;
  onEdit: (event: EventData) => void;
  onDelete: (id: string) => void;
  onDuplicate: (event: EventData) => void;
  onStatusChange: (id: string, status: string) => void;
  onToggleFeatured: (id: string, current: boolean) => void;
}

export default function EventTable({
  events, channels, selectedIds,
  onSelectToggle, onSelectAll, onEdit, onDelete, onDuplicate,
  onStatusChange, onToggleFeatured,
}: EventTableProps) {
  const [expandedChannels, setExpandedChannels] = useState<string | null>(null);

  const allSelected = events.length > 0 && events.every(ev => selectedIds.includes(ev.id));

  const getChannelName = (id: string) => channels.find(ch => ch.id === id)?.name || id;

  return (
    <div className="hidden md:block overflow-x-auto">
      <table className="w-full border-collapse text-left text-sm text-zinc-400">
        <thead>
          <tr className="border-b border-zinc-800 text-zinc-500 text-[10px] uppercase tracking-wider">
            <th className="py-3 px-3 w-8">
              <input
                type="checkbox"
                checked={allSelected}
                onChange={() => onSelectAll(events.map(e => e.id))}
                className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500 cursor-pointer"
              />
            </th>
            <th className="py-3 px-3">Status</th>
            <th className="py-3 px-3">Match</th>
            <th className="py-3 px-3">League</th>
            <th className="py-3 px-3">Kick-off</th>
            <th className="py-3 px-3">Countdown</th>
            <th className="py-3 px-3">Channels</th>
            <th className="py-3 px-2 text-center w-12">★</th>
            <th className="py-3 px-3 text-right">Actions</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-zinc-800/30">
          {events.map(event => {
            const isSelected = selectedIds.includes(event.id);
            const channelCount = event.channels?.length || 0;
            const isExpanded = expandedChannels === event.id;

            return (
              <tr
                key={event.id}
                className={`transition-colors ${
                  isSelected ? 'bg-purple-950/10' :
                  event.status === 'live' ? 'bg-red-950/5 hover:bg-red-950/10' :
                  'hover:bg-zinc-900/40'
                }`}
              >
                {/* Checkbox */}
                <td className="py-3 px-3">
                  <input
                    type="checkbox"
                    checked={isSelected}
                    onChange={() => onSelectToggle(event.id)}
                    className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500 cursor-pointer"
                  />
                </td>

                {/* Status */}
                <td className="py-3 px-3">
                  <StatusBadge status={event.status} size="sm" />
                </td>

                {/* Match (Teams) */}
                <td className="py-3 px-3">
                  <div className="flex items-center gap-2 min-w-[200px]">
                    <FlagRenderer flag={event.home_team?.flag} size="sm" />
                    <div className="flex flex-col">
                      <span className="text-xs font-semibold text-white truncate max-w-[80px]">
                        {event.home_team?.name || '—'}
                      </span>
                      <span className="text-[9px] text-zinc-600">Home</span>
                    </div>
                    <span className="text-[9px] font-bold text-zinc-600 px-1.5">VS</span>
                    <FlagRenderer flag={event.away_team?.flag} size="sm" />
                    <div className="flex flex-col">
                      <span className="text-xs font-semibold text-white truncate max-w-[80px]">
                        {event.away_team?.name || '—'}
                      </span>
                      <span className="text-[9px] text-zinc-600">Away</span>
                    </div>
                  </div>
                </td>

                {/* League */}
                <td className="py-3 px-3">
                  <div className="flex flex-col">
                    <span className="text-xs text-zinc-300 truncate max-w-[140px]">{event.league}</span>
                    <span className="text-[9px] text-zinc-600 uppercase">{event.sport}</span>
                  </div>
                </td>

                {/* Kick-off */}
                <td className="py-3 px-3">
                  <div className="flex flex-col">
                    <span className="text-xs text-zinc-300 whitespace-nowrap">
                      {parseUtcDate(event.start_time)?.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }) || '—'}
                    </span>
                    <span className="text-[10px] text-zinc-500 whitespace-nowrap">
                      {parseUtcDate(event.start_time)?.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit', hour12: true }) || ''}
                    </span>
                  </div>
                </td>

                {/* Countdown */}
                <td className="py-3 px-3">
                  <CountdownTimer startTime={event.start_time} status={event.status} compact />
                </td>

                {/* Channels */}
                <td className="py-3 px-3">
                  <div className="relative">
                    <button
                      type="button"
                      onClick={() => setExpandedChannels(isExpanded ? null : event.id)}
                      className={`inline-flex items-center gap-1 px-2 py-1 rounded-md text-[10px] font-semibold transition-all ${
                        channelCount > 0
                          ? 'bg-purple-950/30 text-purple-300 border border-purple-500/20 hover:border-purple-500/40'
                          : 'bg-zinc-900 text-zinc-600 border border-zinc-800'
                      }`}
                    >
                      {channelCount} ch
                      {channelCount > 0 && <ChevronDown className={`w-2.5 h-2.5 transition-transform ${isExpanded ? 'rotate-180' : ''}`} />}
                    </button>
                    {isExpanded && channelCount > 0 && (
                      <div className="absolute top-8 left-0 z-30 p-2 rounded-lg bg-zinc-900 border border-zinc-800 shadow-xl shadow-black/40 max-h-32 overflow-y-auto min-w-[160px] animate-fadeIn">
                        {event.channels.map(chId => (
                          <div key={chId} className="text-[10px] text-zinc-300 py-0.5 px-1 truncate">
                            {getChannelName(chId)}
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                </td>

                {/* Featured */}
                <td className="py-3 px-2 text-center">
                  <button
                    onClick={() => onToggleFeatured(event.id, event.is_featured)}
                    className={`p-1.5 rounded-lg transition-all ${
                      event.is_featured
                        ? 'text-amber-400 bg-amber-500/10 hover:bg-amber-500/20'
                        : 'text-zinc-700 hover:text-zinc-500 hover:bg-zinc-800'
                    }`}
                  >
                    <Star className={`w-3.5 h-3.5 ${event.is_featured ? 'fill-amber-400' : ''}`} />
                  </button>
                </td>

                {/* Actions */}
                <td className="py-3 px-3">
                  <div className="flex items-center justify-end gap-1">
                    {event.status !== 'live' && event.status !== 'completed' && (
                      <button
                        onClick={() => onStatusChange(event.id, 'live')}
                        title="Go Live"
                        className="p-1.5 rounded-lg bg-zinc-950 border border-zinc-800 text-red-500 hover:text-red-400 hover:border-red-500/30 hover:bg-red-950/20 transition-all"
                      >
                        <Play className="w-3 h-3 fill-current" />
                      </button>
                    )}
                    {event.status !== 'completed' && (
                      <button
                        onClick={() => onStatusChange(event.id, 'completed')}
                        title="Mark Completed"
                        className="p-1.5 rounded-lg bg-zinc-950 border border-zinc-800 text-emerald-500 hover:text-emerald-400 hover:border-emerald-500/30 hover:bg-emerald-950/20 transition-all"
                      >
                        <CheckCircle className="w-3 h-3" />
                      </button>
                    )}
                    <button
                      onClick={() => onDuplicate(event)}
                      title="Duplicate Event"
                      className="p-1.5 rounded-lg bg-zinc-950 border border-zinc-800 text-blue-400 hover:text-blue-300 hover:border-blue-500/30 hover:bg-blue-950/20 transition-all"
                    >
                      <Copy className="w-3 h-3" />
                    </button>
                    <button
                      onClick={() => onEdit(event)}
                      title="Edit Event"
                      className="p-1.5 rounded-lg bg-zinc-950 border border-zinc-800 text-purple-400 hover:text-white hover:border-purple-500/30 hover:bg-purple-950/20 transition-all"
                    >
                      <Edit2 className="w-3 h-3" />
                    </button>
                    <button
                      onClick={() => onDelete(event.id)}
                      title="Delete Event"
                      className="p-1.5 rounded-lg bg-zinc-950 border border-zinc-800 text-red-400 hover:text-red-300 hover:border-red-500/30 hover:bg-red-950/20 transition-all"
                    >
                      <Trash2 className="w-3 h-3" />
                    </button>
                  </div>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
