'use client';

import React from 'react';
import { CheckCircle, Radio, Clock } from 'lucide-react';

interface StatusBadgeProps {
  status: string;
  size?: 'sm' | 'md';
  showIcon?: boolean;
}

const config: Record<string, {
  bg: string; text: string; border: string; dotColor: string;
  icon: React.ComponentType<{ className?: string }>;
  label: string; pulse?: boolean;
}> = {
  live: {
    bg: 'bg-red-500/15',
    text: 'text-red-400',
    border: 'border-red-500/30',
    dotColor: 'bg-red-500',
    icon: Radio,
    label: 'LIVE',
    pulse: true,
  },
  upcoming: {
    bg: 'bg-blue-500/15',
    text: 'text-blue-400',
    border: 'border-blue-500/30',
    dotColor: 'bg-blue-500',
    icon: Clock,
    label: 'UPCOMING',
  },
  completed: {
    bg: 'bg-zinc-800/60',
    text: 'text-zinc-500',
    border: 'border-zinc-700/40',
    dotColor: 'bg-zinc-600',
    icon: CheckCircle,
    label: 'COMPLETED',
  },
};

export default function StatusBadge({ status, size = 'sm', showIcon = true }: StatusBadgeProps) {
  const cfg = config[status] || config.upcoming;
  const Icon = cfg.icon;
  const isSmall = size === 'sm';

  return (
    <span className={`
      inline-flex items-center gap-1.5 font-extrabold uppercase tracking-wider rounded-full border
      ${cfg.bg} ${cfg.text} ${cfg.border}
      ${isSmall ? 'text-[9px] px-2 py-0.5' : 'text-[10px] px-2.5 py-1'}
    `}>
      {showIcon && (
        <span className="relative flex items-center justify-center">
          {cfg.pulse ? (
            <>
              <span className={`absolute w-2 h-2 rounded-full ${cfg.dotColor} animate-ping opacity-40`} />
              <span className={`relative w-2 h-2 rounded-full ${cfg.dotColor}`} />
            </>
          ) : (
            <Icon className={isSmall ? 'w-2.5 h-2.5' : 'w-3 h-3'} />
          )}
        </span>
      )}
      {cfg.label}
    </span>
  );
}
