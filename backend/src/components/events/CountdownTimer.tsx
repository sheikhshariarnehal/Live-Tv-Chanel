'use client';

import React, { useState, useEffect } from 'react';
import { Timer } from 'lucide-react';
import { parseUtcDate } from './utils';

interface CountdownTimerProps {
  startTime: string | null | undefined;
  status: string;
  compact?: boolean;
}

export default function CountdownTimer({ startTime, status, compact = false }: CountdownTimerProps) {
  const [timeLeft, setTimeLeft] = useState('');
  const [isImminent, setIsImminent] = useState(false);

  useEffect(() => {
    if (status !== 'upcoming') {
      setTimeLeft('');
      return;
    }

    const update = () => {
      const target = parseUtcDate(startTime);
      if (!target) {
        setTimeLeft('');
        return;
      }

      const now = new Date();
      const diffMs = target.getTime() - now.getTime();

      if (diffMs <= 0) {
        setTimeLeft('Starting now');
        setIsImminent(true);
        return;
      }

      const seconds = Math.floor(diffMs / 1000);
      const minutes = Math.floor(seconds / 60);
      const hours = Math.floor(minutes / 60);
      const days = Math.floor(hours / 24);

      setIsImminent(minutes < 30);

      if (days > 0) {
        setTimeLeft(`${days}d ${hours % 24}h`);
      } else if (hours > 0) {
        setTimeLeft(`${hours}h ${minutes % 60}m`);
      } else if (minutes > 0) {
        setTimeLeft(`${minutes}m ${seconds % 60}s`);
      } else {
        setTimeLeft(`${seconds}s`);
      }
    };

    update();
    // Update every minute normally, every second when < 5 min
    const target = parseUtcDate(startTime);
    const diffMs = target ? target.getTime() - Date.now() : Infinity;
    const interval = diffMs < 5 * 60 * 1000 ? 1000 : 60000;

    const timer = setInterval(update, interval);
    return () => clearInterval(timer);
  }, [startTime, status]);

  if (status === 'live') {
    return (
      <span className={`inline-flex items-center gap-1 font-semibold text-red-400 ${compact ? 'text-[10px]' : 'text-xs'}`}>
        <span className="relative flex h-2 w-2">
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
          <span className="relative inline-flex rounded-full h-2 w-2 bg-red-500"></span>
        </span>
        Live Now
      </span>
    );
  }

  if (status === 'completed') {
    return (
      <span className={`text-zinc-600 ${compact ? 'text-[10px]' : 'text-xs'}`}>
        Ended
      </span>
    );
  }

  if (!timeLeft) return null;

  return (
    <span className={`
      inline-flex items-center gap-1 font-mono font-semibold rounded-md
      ${isImminent
        ? 'text-amber-400 bg-amber-500/10 border border-amber-500/20 px-1.5 py-0.5'
        : 'text-blue-400'
      }
      ${compact ? 'text-[10px]' : 'text-xs'}
    `}>
      <Timer className={compact ? 'w-2.5 h-2.5' : 'w-3 h-3'} />
      {timeLeft}
    </span>
  );
}
