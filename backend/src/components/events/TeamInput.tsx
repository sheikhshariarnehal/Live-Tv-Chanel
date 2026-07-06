'use client';

import React from 'react';
import FlagRenderer from './FlagRenderer';

interface TeamInputProps {
  label: string;
  accentColor: string;
  name: string;
  logo: string;
  onNameChange: (value: string) => void;
  onLogoChange: (value: string) => void;
}

export default function TeamInput({ label, accentColor, name, logo, onNameChange, onLogoChange }: TeamInputProps) {
  return (
    <div className="p-4 rounded-xl bg-zinc-950/60 border border-zinc-800 space-y-3">
      <div className="flex items-center justify-between">
        <span className={`text-xs font-bold ${accentColor}`}>{label}</span>
        <FlagRenderer flag={logo || undefined} size="sm" />
      </div>
      <div className="space-y-2">
        <input
          type="text"
          placeholder="Team Name"
          value={name}
          onChange={e => onNameChange(e.target.value)}
          className="w-full p-2.5 rounded-lg bg-zinc-900 border border-zinc-800 text-sm text-white placeholder-zinc-600 focus:border-purple-500/60 focus:outline-none focus:ring-1 focus:ring-purple-500/25 transition-all"
          required
        />
        <input
          type="text"
          placeholder="Flag: emoji 🇧🇩, code BD, or image URL"
          value={logo}
          onChange={e => onLogoChange(e.target.value)}
          className="w-full p-2.5 rounded-lg bg-zinc-900 border border-zinc-800 text-sm text-white placeholder-zinc-600 focus:border-purple-500/60 focus:outline-none focus:ring-1 focus:ring-purple-500/25 transition-all"
        />
      </div>
    </div>
  );
}
