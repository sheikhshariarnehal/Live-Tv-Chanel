'use client';

import React from 'react';
import { Calendar, Plus, Radio, Clock, CheckCircle } from 'lucide-react';
import type { EventData } from './utils';

interface EventHeaderProps {
  events: EventData[];
  onScheduleNew: () => void;
}

export default function EventHeader({ events, onScheduleNew }: EventHeaderProps) {
  const liveCount = events.filter(e => e.status === 'live').length;
  const upcomingCount = events.filter(e => e.status === 'upcoming').length;
  const completedCount = events.filter(e => e.status === 'completed').length;

  return (
    <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
      <div>
        <h1 className="text-2xl font-bold text-white flex items-center gap-2.5">
          <div className="p-2 rounded-xl bg-purple-500/10 border border-purple-500/20">
            <Calendar className="text-purple-400 w-5 h-5" />
          </div>
          Sports Matches
        </h1>
        <div className="flex items-center gap-4 mt-2.5">
          {liveCount > 0 && (
            <span className="inline-flex items-center gap-1.5 text-xs text-red-400 font-semibold">
              <Radio className="w-3 h-3" />
              {liveCount} Live
            </span>
          )}
          <span className="inline-flex items-center gap-1.5 text-xs text-blue-400">
            <Clock className="w-3 h-3" />
            {upcomingCount} Upcoming
          </span>
          <span className="inline-flex items-center gap-1.5 text-xs text-zinc-500">
            <CheckCircle className="w-3 h-3" />
            {completedCount} Completed
          </span>
        </div>
      </div>
      <button
        onClick={onScheduleNew}
        className="flex items-center gap-2 px-5 py-2.5 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200 shadow-lg shadow-purple-500/20 hover:shadow-purple-500/30 hover:scale-[1.02] active:scale-[0.98]"
      >
        <Plus className="w-4 h-4" />
        Schedule Match
      </button>
    </div>
  );
}
