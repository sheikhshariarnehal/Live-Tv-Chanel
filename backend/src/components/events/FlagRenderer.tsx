'use client';

import React from 'react';
import { Trophy } from 'lucide-react';
import { getFlagType, getFlagCode } from './utils';

interface FlagRendererProps {
  flag?: string | null;
  size?: 'sm' | 'md' | 'lg';
}

const sizeMap = {
  sm: { container: 'w-8 h-8', icon: 'w-3.5 h-3.5', text: 'text-lg' },
  md: { container: 'w-12 h-12', icon: 'w-5 h-5', text: 'text-2xl' },
  lg: { container: 'w-16 h-16', icon: 'w-6 h-6', text: 'text-3xl' },
};

export default function FlagRenderer({ flag, size = 'md' }: FlagRendererProps) {
  const s = sizeMap[size];
  const type = getFlagType(flag);

  if (type === 'none') {
    return (
      <div className={`${s.container} rounded-full bg-zinc-950 border border-zinc-800 flex items-center justify-center`}>
        <Trophy className={`${s.icon} text-zinc-600`} />
      </div>
    );
  }

  if (type === 'image') {
    return (
      <div className={`${s.container} rounded-full bg-zinc-950 border border-zinc-800 overflow-hidden flex items-center justify-center`}>
        <img src={flag!} alt="" className="w-full h-full object-contain" />
      </div>
    );
  }

  if (type === 'code') {
    const code = getFlagCode(flag);
    return (
      <div className={`${s.container} rounded-full bg-zinc-950 border border-zinc-800 overflow-hidden flex items-center justify-center`}>
        <span className={`fi fi-${code} fis w-full h-full shadow-sm`} />
      </div>
    );
  }

  return (
    <div className={`${s.container} rounded-full bg-zinc-950 border border-zinc-800 flex items-center justify-center`}>
      <span className={`${s.text} select-none`}>{flag}</span>
    </div>
  );
}
