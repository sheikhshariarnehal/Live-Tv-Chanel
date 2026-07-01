'use client';

import React, { useState, useEffect } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import DashboardOverview from '../components/DashboardOverview';
import CategoryManager from '../components/CategoryManager';
import ChannelManager from '../components/ChannelManager';
import EventManager from '../components/EventManager';
import AnnouncementManager from '../components/AnnouncementManager';
import { Layers, Tv, Calendar, Bell, Shield, LogOut, Key, ChevronRight, Activity, Terminal, Menu, X } from 'lucide-react';

export default function AdminPage() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [adminToken, setAdminToken] = useState('');
  const [loginPassword, setLoginPassword] = useState('');
  const [loginError, setLoginError] = useState<string | null>(null);

  // Active tab state
  const [activeTab, setActiveTab] = useState('overview');
  
  // Mobile drawer open state
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  // Stats counters state
  const [stats, setStats] = useState({
    categoriesCount: 0,
    channelsCount: 0,
    liveChannelsCount: 0,
    eventsCount: 0,
    announcementsCount: 0
  });

  // Check login state on mount
  useEffect(() => {
    const savedToken = localStorage.getItem('goplay_admin_token');
    if (savedToken) {
      fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ password: savedToken })
      })
      .then(res => {
        if (res.ok) return res.json();
        throw new Error('Session invalid');
      })
      .then(data => {
        setAdminToken(data.token);
        setIsAuthenticated(true);
      })
      .catch(() => {
        localStorage.removeItem('goplay_admin_token');
        setAdminToken('');
        setIsAuthenticated(false);
      });
    }
  }, []);

  // Fetch counts from Supabase when authenticated
  const fetchCounts = async (token = adminToken) => {
    try {
      const supabaseAdmin = createAdminSupabaseClient(token);

      const [catCount, chCount, liveCount, evCount, annCount] = await Promise.all([
        supabaseAdmin.from('categories').select('*', { count: 'exact', head: true }),
        supabaseAdmin.from('channels').select('*', { count: 'exact', head: true }),
        supabaseAdmin.from('channels').select('*', { count: 'exact', head: true }).eq('is_live', true),
        supabaseAdmin.from('events').select('*', { count: 'exact', head: true }),
        supabaseAdmin.from('announcements').select('*', { count: 'exact', head: true })
      ]);

      setStats({
        categoriesCount: catCount.count || 0,
        channelsCount: chCount.count || 0,
        liveChannelsCount: liveCount.count || 0,
        eventsCount: evCount.count || 0,
        announcementsCount: annCount.count || 0
      });
    } catch (e) {
      console.error('Error fetching dashboard statistics', e);
    }
  };

  useEffect(() => {
    if (isAuthenticated && adminToken) {
      fetchCounts();
    }
  }, [isAuthenticated, adminToken]);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoginError(null);

    try {
      const res = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ password: loginPassword.trim() })
      });

      const data = await res.json();

      if (res.ok && data.success) {
        localStorage.setItem('goplay_admin_token', data.token);
        setAdminToken(data.token);
        setIsAuthenticated(true);
        setLoginPassword('');
      } else {
        setLoginError(data.error || 'Invalid Administrator Access Secret.');
      }
    } catch (err: any) {
      setLoginError('Failed to communicate with authentication server.');
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('goplay_admin_token');
    setAdminToken('');
    setIsAuthenticated(false);
    setActiveTab('overview');
  };

  // Render Login state
  if (!isAuthenticated) {
    return (
      <main className="min-h-screen bg-zinc-950 flex flex-col items-center justify-center p-4 relative overflow-hidden">
        {/* Abstract Glowing shapes */}
        <div className="absolute top-1/4 left-1/4 w-80 h-80 bg-purple-500/10 rounded-full blur-3xl"></div>
        <div className="absolute bottom-1/4 right-1/4 w-80 h-80 bg-pink-500/10 rounded-full blur-3xl"></div>

        <div className="w-full max-w-md p-8 rounded-2xl glass-panel relative z-10 space-y-6">
          <div className="text-center space-y-2">
            <div className="mx-auto w-12 h-12 rounded-xl bg-purple-500/10 border border-purple-500/30 flex items-center justify-center text-purple-400">
              <Shield className="w-6 h-6 animate-pulse" />
            </div>
            <h1 className="text-2xl font-bold tracking-tight text-white">GoPlay TV Admin</h1>
            <p className="text-sm text-zinc-400">Please enter administrative secret to continue</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-4">
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400 flex items-center gap-1.5">
                <Key className="w-3.5 h-3.5 text-purple-400" />
                Access Secret
              </label>
              <input
                type="password"
                placeholder="••••••••••••••••"
                value={loginPassword}
                onChange={(e) => setLoginPassword(e.target.value)}
                className="w-full p-3 rounded-xl glass-input text-sm text-center font-mono tracking-widest"
                required
              />
            </div>

            {loginError && (
              <div className="text-xs text-red-400 bg-red-950/20 border border-red-900/50 p-3 rounded-xl text-center">
                ⚠️ {loginError}
              </div>
            )}

            <button
              type="submit"
              className="w-full py-3 bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-700 hover:to-indigo-700 text-white rounded-xl text-sm font-semibold transition-all duration-200 shadow-lg shadow-purple-500/20 hover:scale-[1.01]"
            >
              Sign In
            </button>
          </form>

          <div className="text-center border-t border-zinc-800/80 pt-4">
            <span className="text-[10px] text-zinc-500 font-mono">v1.0.0 • GoPlay Next.js Dashboard</span>
          </div>
        </div>
      </main>
    );
  }

  // Render Dashboard state
  return (
    <div className="min-h-screen bg-zinc-950 flex flex-col md:flex-row text-zinc-300 relative">
      {/* Mobile Sticky Header */}
      <header className="md:hidden sticky top-0 z-30 flex items-center justify-between px-6 py-4 bg-zinc-900/85 backdrop-blur-md border-b border-zinc-800/80">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-purple-600 to-pink-600 flex items-center justify-center text-white font-extrabold text-base shadow-sm">
            G
          </div>
          <div>
            <span className="font-bold text-white text-sm block tracking-wide">GoPlay TV</span>
            <span className="text-[9px] text-zinc-500 font-mono tracking-wider">ADMIN PLATFORM</span>
          </div>
        </div>
        <button
          onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
          className="p-2 rounded-lg bg-zinc-800/50 border border-zinc-700/50 text-zinc-300 hover:text-white transition-all focus:outline-none cursor-pointer"
          aria-label="Toggle menu"
        >
          {isMobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
        </button>
      </header>

      {/* Mobile Overlay Backdrop */}
      {isMobileMenuOpen && (
        <div 
          className="fixed inset-0 bg-black/60 backdrop-blur-sm z-40 md:hidden transition-opacity duration-300"
          onClick={() => setIsMobileMenuOpen(false)}
        />
      )}

      {/* Sidebar Navigation */}
      <aside 
        className={`fixed top-0 left-0 bottom-0 w-64 flex-shrink-0 bg-zinc-900 border-r border-zinc-800/80 p-6 flex flex-col justify-between z-50 transition-transform duration-300 ease-in-out md:static md:translate-x-0 ${
          isMobileMenuOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="space-y-8">
          {/* Logo Brand */}
          <div className="flex items-center justify-between md:justify-start gap-3">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-purple-600 to-pink-600 flex items-center justify-center text-white font-extrabold text-lg shadow-md shadow-purple-500/10">
                G
              </div>
              <div>
                <span className="font-bold text-white text-base block tracking-wide">GoPlay TV</span>
                <span className="text-[10px] text-zinc-500 font-mono tracking-wider">ADMIN PLATFORM</span>
              </div>
            </div>
            {/* Mobile close button inside sidebar */}
            <button
              onClick={() => setIsMobileMenuOpen(false)}
              className="md:hidden p-1.5 rounded-lg hover:bg-zinc-800 text-zinc-400 hover:text-white cursor-pointer"
            >
              <X className="w-4 h-4" />
            </button>
          </div>

          {/* Navigation Menus */}
          <nav className="space-y-1.5">
            <button
              onClick={() => { setActiveTab('overview'); setIsMobileMenuOpen(false); }}
              className={`w-full flex items-center justify-between p-2.5 rounded-xl text-sm font-medium transition-all duration-200 cursor-pointer ${
                activeTab === 'overview'
                  ? 'bg-purple-600 text-white shadow-md shadow-purple-500/10'
                  : 'hover:bg-zinc-800 text-zinc-400 hover:text-zinc-200'
              }`}
            >
              <div className="flex items-center gap-3">
                <Activity className="w-4 h-4" />
                <span>Overview</span>
              </div>
              <ChevronRight className={`w-3.5 h-3.5 transition-transform duration-200 ${activeTab === 'overview' ? 'rotate-90' : 'opacity-30'}`} />
            </button>

            <button
              onClick={() => { setActiveTab('categories'); setIsMobileMenuOpen(false); }}
              className={`w-full flex items-center justify-between p-2.5 rounded-xl text-sm font-medium transition-all duration-200 cursor-pointer ${
                activeTab === 'categories'
                  ? 'bg-purple-600 text-white shadow-md shadow-purple-500/10'
                  : 'hover:bg-zinc-800 text-zinc-400 hover:text-zinc-200'
              }`}
            >
              <div className="flex items-center gap-3">
                <Layers className="w-4 h-4" />
                <span>Categories</span>
              </div>
              <ChevronRight className={`w-3.5 h-3.5 transition-transform duration-200 ${activeTab === 'categories' ? 'rotate-90' : 'opacity-30'}`} />
            </button>

            <button
              onClick={() => { setActiveTab('channels'); setIsMobileMenuOpen(false); }}
              className={`w-full flex items-center justify-between p-2.5 rounded-xl text-sm font-medium transition-all duration-200 cursor-pointer ${
                activeTab === 'channels'
                  ? 'bg-purple-600 text-white shadow-md shadow-purple-500/10'
                  : 'hover:bg-zinc-800 text-zinc-400 hover:text-zinc-200'
              }`}
            >
              <div className="flex items-center gap-3">
                <Tv className="w-4 h-4" />
                <span>Channels</span>
              </div>
              <ChevronRight className={`w-3.5 h-3.5 transition-transform duration-200 ${activeTab === 'channels' ? 'rotate-90' : 'opacity-30'}`} />
            </button>

            <button
              onClick={() => { setActiveTab('events'); setIsMobileMenuOpen(false); }}
              className={`w-full flex items-center justify-between p-2.5 rounded-xl text-sm font-medium transition-all duration-200 cursor-pointer ${
                activeTab === 'events'
                  ? 'bg-purple-600 text-white shadow-md shadow-purple-500/10'
                  : 'hover:bg-zinc-800 text-zinc-400 hover:text-zinc-200'
              }`}
            >
              <div className="flex items-center gap-3">
                <Calendar className="w-4 h-4" />
                <span>Sports Matches</span>
              </div>
              <ChevronRight className={`w-3.5 h-3.5 transition-transform duration-200 ${activeTab === 'events' ? 'rotate-90' : 'opacity-30'}`} />
            </button>

            <button
              onClick={() => { setActiveTab('announcements'); setIsMobileMenuOpen(false); }}
              className={`w-full flex items-center justify-between p-2.5 rounded-xl text-sm font-medium transition-all duration-200 cursor-pointer ${
                activeTab === 'announcements'
                  ? 'bg-purple-600 text-white shadow-md shadow-purple-500/10'
                  : 'hover:bg-zinc-800 text-zinc-400 hover:text-zinc-200'
              }`}
            >
              <div className="flex items-center gap-3">
                <Bell className="w-4 h-4" />
                <span>Announcements</span>
              </div>
              <ChevronRight className={`w-3.5 h-3.5 transition-transform duration-200 ${activeTab === 'announcements' ? 'rotate-90' : 'opacity-30'}`} />
            </button>
          </nav>
        </div>

        {/* Footer Actions */}
        <div className="mt-8 pt-4 border-t border-zinc-850 space-y-4">
          <div className="flex items-center gap-2 text-xs text-zinc-500">
            <Terminal className="w-3.5 h-3.5 text-zinc-600" />
            <span>Dev mode active</span>
          </div>
          <button
            onClick={handleLogout}
            className="w-full py-2 px-3 rounded-lg border border-zinc-800 hover:border-red-900/30 text-zinc-400 hover:text-red-400 text-xs font-semibold hover:bg-red-950/10 transition-all flex items-center justify-center gap-2 cursor-pointer"
          >
            <LogOut className="w-3.5 h-3.5" />
            Exit Dashboard
          </button>
        </div>
      </aside>

      {/* Main Workspace */}
      <main className="flex-1 p-4 sm:p-6 md:p-10 max-w-7xl overflow-y-auto">
        {activeTab === 'overview' && (
          <DashboardOverview stats={stats} setActiveTab={setActiveTab} />
        )}
        {activeTab === 'categories' && (
          <CategoryManager adminToken={adminToken} onRefreshStats={fetchCounts} />
        )}
        {activeTab === 'channels' && (
          <ChannelManager adminToken={adminToken} onRefreshStats={fetchCounts} />
        )}
        {activeTab === 'events' && (
          <EventManager adminToken={adminToken} onRefreshStats={fetchCounts} />
        )}
        {activeTab === 'announcements' && (
          <AnnouncementManager adminToken={adminToken} onRefreshStats={fetchCounts} />
        )}
      </main>
    </div>
  );
}
