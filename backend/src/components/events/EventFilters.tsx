'use client';

import React from 'react';
import { Search, LayoutGrid, TableProperties } from 'lucide-react';

interface EventFiltersProps {
  searchTerm: string;
  onSearchChange: (value: string) => void;
  statusFilter: string;
  onStatusFilterChange: (value: string) => void;
  viewMode: 'table' | 'cards';
  onViewModeChange: (mode: 'table' | 'cards') => void;
  totalCount: number;
  filteredCount: number;
}

const statusChips = [
  { value: 'all', label: 'All' },
  { value: 'live', label: 'Live', dot: 'bg-red-500' },
  { value: 'upcoming', label: 'Upcoming', dot: 'bg-blue-500' },
  { value: 'completed', label: 'Completed', dot: 'bg-zinc-600' },
] as const;

export default function EventFilters({
  searchTerm, onSearchChange,
  statusFilter, onStatusFilterChange,
  viewMode, onViewModeChange,
  totalCount, filteredCount,
}: EventFiltersProps) {
  return (
    <div className="space-y-3">
      <div className="flex flex-col sm:flex-row gap-3">
        {/* Search */}
        <div className="flex-1 relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
          <input
            type="text"
            placeholder="Search by team, league, or sport…"
            value={searchTerm}
            onChange={e => onSearchChange(e.target.value)}
            className="w-full pl-10 pr-4 py-2.5 rounded-xl glass-input text-sm"
          />
        </div>

        {/* View toggle — desktop only */}
        <div className="hidden md:flex items-center rounded-xl bg-zinc-900/80 border border-zinc-800 p-0.5">
          <button
            onClick={() => onViewModeChange('table')}
            className={`p-2 rounded-lg transition-all ${
              viewMode === 'table'
                ? 'bg-purple-600 text-white shadow-sm'
                : 'text-zinc-500 hover:text-zinc-300'
            }`}
            title="Table view"
          >
            <TableProperties className="w-4 h-4" />
          </button>
          <button
            onClick={() => onViewModeChange('cards')}
            className={`p-2 rounded-lg transition-all ${
              viewMode === 'cards'
                ? 'bg-purple-600 text-white shadow-sm'
                : 'text-zinc-500 hover:text-zinc-300'
            }`}
            title="Card view"
          >
            <LayoutGrid className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* Status chips */}
      <div className="flex items-center gap-2 overflow-x-auto pb-1 scrollbar-none">
        {statusChips.map(chip => (
          <button
            key={chip.value}
            onClick={() => onStatusFilterChange(chip.value)}
            className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
              statusFilter === chip.value
                ? 'bg-purple-600 text-white shadow-sm shadow-purple-500/20'
                : 'bg-zinc-900/80 border border-zinc-800 text-zinc-400 hover:text-zinc-200 hover:border-zinc-700'
            }`}
          >
            {'dot' in chip && <span className={`w-1.5 h-1.5 rounded-full ${chip.dot}`} />}
            {chip.label}
          </button>
        ))}

        {/* Results counter */}
        <span className="ml-auto text-[10px] text-zinc-600 whitespace-nowrap hidden sm:inline">
          {filteredCount === totalCount
            ? `${totalCount} events`
            : `${filteredCount} of ${totalCount} events`
          }
        </span>
      </div>
    </div>
  );
}
