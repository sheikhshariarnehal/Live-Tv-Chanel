'use client';

import React, { useState, type ReactNode } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useAuth } from '../../providers/auth-provider';
import {
  Layers, Tv, Calendar, Bell, Shield, LogOut,
  ChevronRight, Activity, Menu, X, Search, Sparkles,
} from 'lucide-react';

const navItems = [
  { label: 'Overview', href: '/dashboard/overview', icon: Activity },
  { label: 'Categories', href: '/dashboard/categories', icon: Layers },
  { label: 'Channels', href: '/dashboard/channels', icon: Tv },
  { label: 'Sports Matches', href: '/dashboard/events', icon: Calendar },
  { label: 'Announcements', href: '/dashboard/announcements', icon: Bell },
] as const;

function getTabLabel(pathname: string): string {
  const item = navItems.find((n) => pathname.startsWith(n.href));
  return item?.label ?? 'Dashboard';
}

export default function DashboardLayout({ children }: { children: ReactNode }) {
  const { isAuthenticated, isLoading, logout } = useAuth();
  const pathname = usePathname();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  // Auth gate — guard renders a spinner or redirects
  if (isLoading) {
    return (
      <main className="min-h-screen bg-zinc-950 flex items-center justify-center">
        <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin"></div>
      </main>
    );
  }

  if (!isAuthenticated) return null;

  return (
    <div className="min-h-screen bg-zinc-950 flex text-zinc-300 relative">
      {/* Mobile overlay */}
      {isMobileMenuOpen && (
        <div
          className="fixed inset-0 bg-black/60 backdrop-blur-sm z-40 lg:hidden transition-opacity duration-300"
          onClick={() => setIsMobileMenuOpen(false)}
        />
      )}

      {/* ── Sidebar ────────────────────────────────── */}
      <aside
        className={`fixed top-0 left-0 bottom-0 w-64 flex-shrink-0 bg-zinc-900 border-r border-zinc-800/80 p-5 flex flex-col justify-between z-50 transition-transform duration-300 ease-in-out lg:static lg:translate-x-0 ${
          isMobileMenuOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="space-y-6">
          {/* Brand */}
          <div className="flex items-center justify-between lg:justify-start gap-3">
            <Link href="/dashboard/overview" className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-purple-600 to-pink-600 flex items-center justify-center text-white font-extrabold text-lg shadow-md shadow-purple-500/10">
                G
              </div>
              <div>
                <span className="font-bold text-white text-base block tracking-wide leading-tight">GoPlay TV</span>
                <span className="text-[10px] text-zinc-500 font-mono tracking-wider">ADMIN PLATFORM</span>
              </div>
            </Link>
            <button
              onClick={() => setIsMobileMenuOpen(false)}
              className="lg:hidden p-1.5 rounded-lg hover:bg-zinc-800 text-zinc-400 hover:text-white cursor-pointer"
            >
              <X className="w-4 h-4" />
            </button>
          </div>

          {/* Navigation */}
          <nav className="space-y-1">
            <p className="px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-zinc-600">Management</p>
            {navItems.map((item) => {
              const isActive = pathname.startsWith(item.href);
              const Icon = item.icon;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setIsMobileMenuOpen(false)}
                  className={`w-full flex items-center justify-between p-2.5 rounded-xl text-sm font-medium transition-all duration-200 ${
                    isActive
                      ? 'bg-purple-600 text-white shadow-md shadow-purple-500/20'
                      : 'hover:bg-zinc-800 text-zinc-400 hover:text-zinc-200'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <Icon className="w-4 h-4" />
                    <span>{item.label}</span>
                  </div>
                  <ChevronRight className={`w-3.5 h-3.5 transition-transform duration-200 ${isActive ? 'rotate-90' : 'opacity-30'}`} />
                </Link>
              );
            })}
          </nav>
        </div>

        {/* Sidebar footer */}
        <div className="space-y-3">
          <div className="flex items-center gap-2 px-3 py-2 rounded-lg bg-zinc-950/60 border border-zinc-800/60">
            <Sparkles className="w-3.5 h-3.5 text-purple-400 flex-shrink-0" />
            <div className="leading-tight">
              <span className="text-[11px] text-zinc-300 font-medium block">Live DB Sync</span>
              <span className="text-[9px] text-emerald-400 font-mono">● Operational</span>
            </div>
          </div>
          <button
            onClick={logout}
            className="w-full py-2 px-3 rounded-lg border border-zinc-800 hover:border-red-900/30 text-zinc-400 hover:text-red-400 text-xs font-semibold hover:bg-red-950/10 transition-all flex items-center justify-center gap-2 cursor-pointer"
          >
            <LogOut className="w-3.5 h-3.5" />
            Exit Dashboard
          </button>
        </div>
      </aside>

      {/* ── Topbar + Workspace ────────────────────── */}
      <div className="flex-1 flex flex-col min-w-0 lg:h-screen lg:overflow-hidden">
        {/* Topbar */}
        <header className="sticky top-0 z-30 flex items-center justify-between gap-4 px-4 sm:px-6 lg:px-8 py-3 bg-zinc-900/80 backdrop-blur-md border-b border-zinc-800/80">
          {/* Left */}
          <div className="flex items-center gap-3">
            <button
              onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
              className="lg:hidden p-2 rounded-lg bg-zinc-800/50 border border-zinc-700/50 text-zinc-300 hover:text-white transition-all focus:outline-none cursor-pointer"
              aria-label="Toggle menu"
            >
              {isMobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
            </button>
            <div className="flex items-center gap-3 lg:hidden">
              <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-purple-600 to-pink-600 flex items-center justify-center text-white font-extrabold text-sm shadow-sm">
                G
              </div>
            </div>
            <div className="hidden lg:flex items-center gap-2 text-sm">
              <span className="text-zinc-500">Dashboard</span>
              <ChevronRight className="w-3.5 h-3.5 text-zinc-700" />
              <span className="text-zinc-200 font-semibold">{getTabLabel(pathname)}</span>
            </div>
          </div>

          {/* Right */}
          <div className="flex items-center gap-3">
            <div className="hidden md:flex items-center gap-2 px-3 py-1.5 rounded-lg bg-zinc-950/60 border border-zinc-800 text-zinc-500 text-xs w-56">
              <Search className="w-3.5 h-3.5" />
              <span className="text-zinc-600">Quick search…</span>
              <kbd className="ml-auto px-1.5 py-0.5 rounded bg-zinc-800 text-zinc-500 text-[9px] font-mono">⌘K</kbd>
            </div>
            <div className="hidden sm:flex items-center gap-2 px-3 py-1.5 rounded-lg bg-zinc-950/60 border border-zinc-800">
              <div className="w-6 h-6 rounded-md bg-gradient-to-tr from-purple-600 to-pink-600 flex items-center justify-center text-white">
                <Shield className="w-3.5 h-3.5" />
              </div>
              <div className="leading-tight">
                <span className="text-[11px] text-zinc-200 font-medium block">Administrator</span>
                <span className="text-[9px] text-zinc-500 font-mono">root@goplay</span>
              </div>
            </div>
          </div>
        </header>

        {/* Workspace */}
        <main className="flex-1 p-4 sm:p-6 lg:p-8 lg:overflow-y-auto">
          <div className="w-full max-w-[1600px] mx-auto">{children}</div>
        </main>
      </div>
    </div>
  );
}
