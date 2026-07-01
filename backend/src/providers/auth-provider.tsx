'use client';

import React, { createContext, useContext, useState, useEffect, useCallback, type ReactNode } from 'react';
import { useRouter, usePathname } from 'next/navigation';
import { createAdminSupabaseClient } from '../utils/supabase';

interface DashboardStats {
  categoriesCount: number;
  channelsCount: number;
  liveChannelsCount: number;
  eventsCount: number;
  announcementsCount: number;
}

interface AuthContextValue {
  isAuthenticated: boolean;
  adminToken: string;
  login: (password: string) => Promise<{ success: boolean; error?: string }>;
  logout: () => void;
  isLoading: boolean;
  stats: DashboardStats;
  refreshStats: () => void;
}

const defaultStats: DashboardStats = {
  categoriesCount: 0,
  channelsCount: 0,
  liveChannelsCount: 0,
  eventsCount: 0,
  announcementsCount: 0,
};

const AuthContext = createContext<AuthContextValue>({
  isAuthenticated: false,
  adminToken: '',
  login: async () => ({ success: false }),
  logout: () => {},
  isLoading: true,
  stats: defaultStats,
  refreshStats: () => {},
});

export const useAuth = () => useContext(AuthContext);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [adminToken, setAdminToken] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [stats, setStats] = useState<DashboardStats>(defaultStats);
  const router = useRouter();
  const pathname = usePathname();

  // Restore session from localStorage on mount
  useEffect(() => {
    const savedToken = localStorage.getItem('goplay_admin_token');
    if (savedToken) {
      fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ password: savedToken }),
      })
        .then((res) => {
          if (res.ok) return res.json();
          throw new Error('Session invalid');
        })
        .then((data) => {
          setAdminToken(data.token);
          setIsAuthenticated(true);
        })
        .catch(() => {
          localStorage.removeItem('goplay_admin_token');
          setAdminToken('');
          setIsAuthenticated(false);
        })
        .finally(() => setIsLoading(false));
    } else {
      setIsLoading(false);
    }
  }, []);

  // Route guard: redirect to /login if not authenticated on dashboard routes
  useEffect(() => {
    if (!isLoading && !isAuthenticated && pathname.startsWith('/dashboard')) {
      router.replace('/login');
    }
  }, [isLoading, isAuthenticated, pathname, router]);

  const refreshStats = useCallback(() => {
    if (!adminToken) return;
    const supabaseAdmin = createAdminSupabaseClient(adminToken);
    Promise.all([
      supabaseAdmin.from('categories').select('*', { count: 'exact', head: true }),
      supabaseAdmin.from('channels').select('*', { count: 'exact', head: true }),
      supabaseAdmin.from('channels').select('*', { count: 'exact', head: true }).eq('is_live', true),
      supabaseAdmin.from('events').select('*', { count: 'exact', head: true }),
      supabaseAdmin.from('announcements').select('*', { count: 'exact', head: true }),
    ])
      .then(([cat, ch, live, ev, ann]) => {
        setStats({
          categoriesCount: cat.count || 0,
          channelsCount: ch.count || 0,
          liveChannelsCount: live.count || 0,
          eventsCount: ev.count || 0,
          announcementsCount: ann.count || 0,
        });
      })
      .catch((err) => console.error('Error refreshing stats', err));
  }, [adminToken]);

  // Fetch stats when auth is established
  useEffect(() => {
    if (isAuthenticated && adminToken) refreshStats();
  }, [isAuthenticated, adminToken, refreshStats]);

  const login = useCallback(async (password: string) => {
    try {
      const res = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ password: password.trim() }),
      });

      const data = await res.json();

      if (res.ok && data.success) {
        localStorage.setItem('goplay_admin_token', data.token);
        setAdminToken(data.token);
        setIsAuthenticated(true);
        return { success: true };
      } else {
        return { success: false, error: data.error || 'Invalid Administrator Access Secret.' };
      }
    } catch {
      return { success: false, error: 'Failed to communicate with authentication server.' };
    }
  }, []);

  const logout = useCallback(() => {
    localStorage.removeItem('goplay_admin_token');
    setAdminToken('');
    setIsAuthenticated(false);
    router.replace('/login');
  }, [router]);

  return (
    <AuthContext.Provider value={{ isAuthenticated, adminToken, login, logout, isLoading, stats, refreshStats }}>
      {children}
    </AuthContext.Provider>
  );
}
