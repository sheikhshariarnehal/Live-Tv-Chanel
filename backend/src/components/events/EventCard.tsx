'use client';

import React from 'react';
import { Edit2, Trash2, Play, CheckCircle, Copy, Star, MoreHorizontal } from 'lucide-react';
import FlagRenderer from './FlagRenderer';
import StatusBadge from './StatusBadge';
import CountdownTimer from './CountdownTimer';
import { EventData, ChannelData, parseUtcDate } from './utils';

interface EventCardProps {
  event: EventData;
  channels: ChannelData[];
  onEdit: (event: EventData) => void;
  onDelete: (id: string) => void;
  onDuplicate: (event: EventData) => void;
  onStatusChange: (id: string, status: string) => void;
  onToggleFeatured: (id: string, current: boolean) => void;
}

export default function EventCard({
  event, channels, onEdit, onDelete, onDuplicate,
  onStatusChange, onToggleFeatured,
}: EventCardProps) {
  const [showMenu, setShowMenu] = React.useState(false);
  const channelCount = event.channels?.length || 0;

  const getChannelName = (id: string) => channels.find(ch => ch.id === id)?.name || id;

  return (
    <div className={`p-4 rounded-2xl border transition-all duration-200 ${
      event.status === 'live'
        ? 'bg-red-950/10 border-red-500/30 shadow-md shadow-red-500/5'
        : event.status === 'completed'
          ? 'bg-zinc-900/30 border-zinc-800/60'
          : 'bg-zinc-900/40 border-zinc-800 hover:border-zinc-700'
    }`}>
      {/* Top row: Sport + Status + Featured */}
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center gap-2">
          <span className="text-[9px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full bg-zinc-800/80 text-zinc-400">
            {event.sport}
          </span>
          <StatusBadge status={event.status} size="sm" />
        </div>
        <div className="flex items-center gap-1">
          <button
            onClick={() => onToggleFeatured(event.id, event.is_featured)}
            className={`p-1.5 rounded-lg transition-all ${
              event.is_featured
                ? 'text-amber-400 bg-amber-500/10'
                : 'text-zinc-600 hover:text-zinc-400'
            }`}
          >
            <Star className={`w-4 h-4 ${event.is_featured ? 'fill-amber-400' : ''}`} />
          </button>
        </div>
      </div>

      {/* Teams display */}
      <div className="flex items-center justify-between py-3">
        <div className="flex flex-col items-center flex-1 text-center">
          <FlagRenderer flag={event.home_team?.flag} size="md" />
          <span className="text-xs font-bold text-white mt-2 truncate w-full max-w-[100px]">
            {event.home_team?.name || '—'}
          </span>
        </div>
        <div className="flex flex-col items-center px-3">
          <span className="text-zinc-600 font-extrabold text-xs">VS</span>
          <CountdownTimer startTime={event.start_time} status={event.status} compact />
        </div>
        <div className="flex flex-col items-center flex-1 text-center">
          <FlagRenderer flag={event.away_team?.flag} size="md" />
          <span className="text-xs font-bold text-white mt-2 truncate w-full max-w-[100px]">
            {event.away_team?.name || '—'}
          </span>
        </div>
      </div>

      {/* League + Time */}
      <div className="text-center space-y-0.5 mb-3">
        <p className="text-xs text-zinc-400">{event.league}</p>
        <p className="text-[10px] text-zinc-500">
          {parseUtcDate(event.start_time)?.toLocaleString('en-US', {
            month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit', hour12: true
          }) || 'No date set'}
        </p>
      </div>

      {/* Channels count */}
      <div className="flex items-center justify-between mb-3 px-1">
        <span className={`text-[10px] font-semibold ${channelCount > 0 ? 'text-purple-300' : 'text-zinc-600'}`}>
          {channelCount > 0 ? `${channelCount} broadcast channels` : 'No channels assigned'}
        </span>
      </div>

      {/* Action buttons — large touch targets */}
      <div className="flex items-center gap-2 pt-3 border-t border-zinc-800/60">
        {event.status !== 'live' && event.status !== 'completed' && (
          <button
            onClick={() => onStatusChange(event.id, 'live')}
            className="flex-1 py-2.5 rounded-xl bg-red-950/30 border border-red-500/20 text-red-400 hover:bg-red-950/50 hover:border-red-500/40 text-xs font-semibold transition-all flex items-center justify-center gap-1.5"
          >
            <Play className="w-3.5 h-3.5 fill-current" />
            Go Live
          </button>
        )}
        {event.status !== 'completed' && (
          <button
            onClick={() => onStatusChange(event.id, 'completed')}
            className="flex-1 py-2.5 rounded-xl bg-emerald-950/30 border border-emerald-500/20 text-emerald-400 hover:bg-emerald-950/50 hover:border-emerald-500/40 text-xs font-semibold transition-all flex items-center justify-center gap-1.5"
          >
            <CheckCircle className="w-3.5 h-3.5" />
            Complete
          </button>
        )}
        <button
          onClick={() => onEdit(event)}
          className="py-2.5 px-3 rounded-xl bg-zinc-950 border border-zinc-800 text-purple-400 hover:text-white hover:border-purple-500/30 transition-all"
        >
          <Edit2 className="w-3.5 h-3.5" />
        </button>

        {/* Overflow menu */}
        <div className="relative">
          <button
            onClick={() => setShowMenu(!showMenu)}
            className="py-2.5 px-3 rounded-xl bg-zinc-950 border border-zinc-800 text-zinc-400 hover:text-white hover:border-zinc-600 transition-all"
          >
            <MoreHorizontal className="w-3.5 h-3.5" />
          </button>
          {showMenu && (
            <>
              <div className="fixed inset-0 z-40" onClick={() => setShowMenu(false)} />
              <div className="absolute right-0 bottom-full mb-1 z-50 p-1 rounded-xl bg-zinc-900 border border-zinc-800 shadow-xl shadow-black/40 min-w-[140px] animate-fadeIn">
                <button
                  onClick={() => { onDuplicate(event); setShowMenu(false); }}
                  className="w-full flex items-center gap-2 p-2.5 rounded-lg text-xs text-zinc-300 hover:bg-zinc-800 transition-all"
                >
                  <Copy className="w-3.5 h-3.5 text-blue-400" />
                  Duplicate
                </button>
                <button
                  onClick={() => { onDelete(event.id); setShowMenu(false); }}
                  className="w-full flex items-center gap-2 p-2.5 rounded-lg text-xs text-red-400 hover:bg-red-950/30 transition-all"
                >
                  <Trash2 className="w-3.5 h-3.5" />
                  Delete
                </button>
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
