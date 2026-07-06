import React from 'react';

// ─── Types ───────────────────────────────────────────────────────────

export interface EventData {
  id: string;
  sport: string;
  league: string;
  home_team: { name: string; flag?: string };
  away_team: { name: string; flag?: string };
  start_time: string;
  status: string;
  channels: string[];
  banner: string | null;
  is_featured: boolean;
}

export interface ChannelData {
  id: string;
  name: string;
  category?: string | null;
}

export interface PlaylistData {
  id: string;
  name: string;
  channels: string[];
}

export interface EventFormState {
  id: string;
  sport: string;
  league: string;
  home_name: string;
  home_logo: string;
  away_name: string;
  away_logo: string;
  start_time: string;
  status: string;
  channels: string[];
  banner: string;
  is_featured: boolean;
}

export const defaultFormState: EventFormState = {
  id: '',
  sport: 'Football',
  league: '',
  home_name: '',
  home_logo: '',
  away_name: '',
  away_logo: '',
  start_time: '',
  status: 'upcoming',
  channels: [],
  banner: '',
  is_featured: false,
};

export const SPORT_OPTIONS = [
  { value: 'Football', label: 'Football (Soccer)' },
  { value: 'Cricket', label: 'Cricket' },
  { value: 'Basketball', label: 'Basketball' },
  { value: 'Tennis', label: 'Tennis' },
  { value: 'F1', label: 'Formula 1' },
  { value: 'WWE', label: 'WWE / Wrestling' },
  { value: 'Other', label: 'Other Sport' },
] as const;

export const STATUS_OPTIONS = [
  { value: 'upcoming', label: 'Upcoming', color: 'blue' },
  { value: 'live', label: 'Live Now', color: 'red' },
  { value: 'completed', label: 'Completed', color: 'zinc' },
] as const;

// ─── Flag Utilities ──────────────────────────────────────────────────

export const emojiToCountryCode = (emoji: string): string | null => {
  if (!emoji) return null;
  const trimmed = emoji.trim();
  if (/^[a-zA-Z]{2}(-[a-zA-Z]{3})?$/.test(trimmed)) {
    return trimmed.toLowerCase();
  }
  const codePoints = Array.from(trimmed).map(char => char.codePointAt(0) || 0);
  if (codePoints.length >= 2 && codePoints.every(cp => cp >= 0x1F1E6 && cp <= 0x1F1FF)) {
    return codePoints.map(cp => String.fromCharCode(cp - 127397)).join('').toLowerCase();
  }
  return null;
};

export const cleanFlagValue = (input: string): string => {
  const trimmed = input.trim();
  if (!trimmed) return '';
  if (trimmed.startsWith('http') || trimmed.startsWith('/') || trimmed.startsWith('data:')) {
    return trimmed;
  }
  const code = emojiToCountryCode(trimmed);
  if (code) return code;
  return trimmed.toLowerCase();
};

export const getFlagType = (flag?: string | null): 'none' | 'image' | 'code' | 'emoji' => {
  if (!flag) return 'none';
  const trimmed = flag.trim();
  if (trimmed.startsWith('http') || trimmed.startsWith('/') || trimmed.startsWith('data:')) return 'image';
  if (/^[a-zA-Z]{2}(-[a-zA-Z]{3})?$/.test(trimmed)) return 'code';
  if (emojiToCountryCode(trimmed)) return 'code';
  return 'emoji';
};

export const getFlagCode = (flag?: string | null): string | null => {
  if (!flag) return null;
  const trimmed = flag.trim();
  if (/^[a-zA-Z]{2}(-[a-zA-Z]{3})?$/.test(trimmed)) return trimmed.toLowerCase();
  return emojiToCountryCode(trimmed);
};

// ─── Date / Time Utilities ───────────────────────────────────────────

export const parseUtcDate = (utcString: string | null | undefined): Date | null => {
  if (!utcString) return null;
  try {
    let cleaned = utcString.trim();
    if (/^\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}/.test(cleaned)) {
      cleaned = cleaned.replace(/\s+/, 'T');
    }
    if (cleaned.endsWith('+00')) {
      cleaned = cleaned.slice(0, -3) + 'Z';
    } else if (/\+\d{2}$/.test(cleaned)) {
      cleaned = cleaned + ':00';
    } else if (/-\d{2}$/.test(cleaned)) {
      cleaned = cleaned + ':00';
    }
    const d = new Date(cleaned);
    return isNaN(d.getTime()) ? null : d;
  } catch {
    return null;
  }
};

export const formatToLocalDateTime = (utcString: string | null | undefined): string => {
  const d = parseUtcDate(utcString);
  if (!d) return '';
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
};

export const parseLocalDateTime = (localString: string | null | undefined): string => {
  if (!localString) return new Date().toISOString();
  try {
    const trimmed = localString.trim();
    const hasTimezone = trimmed.includes(':') && /(Z|[+-]\d{2}(?::?\d{2})?)$/.test(trimmed);

    if (hasTimezone) {
      const d = parseUtcDate(trimmed);
      if (d && !isNaN(d.getTime())) {
        return d.toISOString();
      }
    }

    const match = trimmed.match(/^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})(?::(\d{2}))?/);
    if (match) {
      const year = parseInt(match[1], 10);
      const month = parseInt(match[2], 10) - 1;
      const day = parseInt(match[3], 10);
      const hour = parseInt(match[4], 10);
      const minute = parseInt(match[5], 10);
      const second = match[6] ? parseInt(match[6], 10) : 0;
      const date = new Date(year, month, day, hour, minute, second);
      if (!isNaN(date.getTime())) {
        return date.toISOString();
      }
    }
    const fallback = parseUtcDate(trimmed);
    if (fallback && !isNaN(fallback.getTime())) {
      return fallback.toISOString();
    }
    return new Date().toISOString();
  } catch {
    return new Date().toISOString();
  }
};

export const formatRelativeTime = (utcString: string | null | undefined): string => {
  const d = parseUtcDate(utcString);
  if (!d) return '';
  const now = new Date();
  const diffMs = d.getTime() - now.getTime();

  if (diffMs <= 0) return 'Started';

  const seconds = Math.floor(diffMs / 1000);
  const minutes = Math.floor(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);

  if (days > 0) return `${days}d ${hours % 24}h`;
  if (hours > 0) return `${hours}h ${minutes % 60}m`;
  if (minutes > 0) return `${minutes}m ${seconds % 60}s`;
  return `${seconds}s`;
};

export const formatDisplayDate = (utcString: string | null | undefined): string => {
  const d = parseUtcDate(utcString);
  if (!d) return 'No date';
  return d.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
};

export const formatDisplayTime = (utcString: string | null | undefined): string => {
  const d = parseUtcDate(utcString);
  if (!d) return '';
  return d.toLocaleTimeString('en-US', {
    hour: 'numeric',
    minute: '2-digit',
    hour12: true,
  });
};

// ─── Form Helpers ────────────────────────────────────────────────────

export const eventToFormState = (event: EventData): EventFormState => ({
  id: event.id,
  sport: event.sport,
  league: event.league,
  home_name: event.home_team?.name || '',
  home_logo: event.home_team?.flag || '',
  away_name: event.away_team?.name || '',
  away_logo: event.away_team?.flag || '',
  start_time: formatToLocalDateTime(event.start_time),
  status: event.status,
  channels: event.channels || [],
  banner: event.banner || '',
  is_featured: event.is_featured,
});

export const formStateToPayload = (form: EventFormState) => ({
  sport: form.sport,
  league: form.league.trim(),
  home_team: { name: form.home_name.trim(), flag: cleanFlagValue(form.home_logo) || undefined },
  away_team: { name: form.away_name.trim(), flag: cleanFlagValue(form.away_logo) || undefined },
  start_time: parseLocalDateTime(form.start_time),
  status: form.status,
  channels: form.channels,
  banner: form.banner.trim() || null,
  is_featured: form.is_featured,
});

export const generateSlug = (homeName: string, awayName: string): string => {
  const clean = (s: string) => s.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  if (!homeName.trim() && !awayName.trim()) return '';
  return `${clean(homeName)}-vs-${clean(awayName)}`;
};
