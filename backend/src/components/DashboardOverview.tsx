'use client';

import React from 'react';
import Link from 'next/link';
import { Layers, Tv, Radio, Calendar, Bell, Shield, ArrowRight, TrendingUp, Database, Zap, ArrowUpRight, Plus } from 'lucide-react';

interface OverviewProps {
  stats: {
    categoriesCount: number;
    channelsCount: number;
    liveChannelsCount: number;
    eventsCount: number;
    announcementsCount: number;
  };
}

export default function DashboardOverview({ stats }: OverviewProps) {
  const cards = [
    {
      title: 'Categories',
      value: stats.categoriesCount,
      desc: 'Channel groupings',
      icon: Layers,
      iconBg: 'bg-violet-500/10 border-violet-500/20',
      iconColor: 'text-violet-400',
      tab: 'categories'
    },
    {
      title: 'Channels',
      value: stats.channelsCount,
      desc: 'Total streaming channels',
      icon: Tv,
      iconBg: 'bg-blue-500/10 border-blue-500/20',
      iconColor: 'text-blue-400',
      tab: 'channels'
    },
    {
      title: 'Live Streams',
      value: stats.liveChannelsCount,
      desc: 'Active direct streams',
      icon: Radio,
      iconBg: 'bg-emerald-500/10 border-emerald-500/20',
      iconColor: 'text-emerald-400',
      tab: 'channels'
    },
    {
      title: 'Sports Events',
      value: stats.eventsCount,
      desc: 'Live and upcoming matches',
      icon: Calendar,
      iconBg: 'bg-pink-500/10 border-pink-500/20',
      iconColor: 'text-pink-400',
      tab: 'events'
    },
    {
      title: 'Announcements',
      value: stats.announcementsCount,
      desc: 'Broadcasts to mobile app',
      icon: Bell,
      iconBg: 'bg-amber-500/10 border-amber-500/20',
      iconColor: 'text-amber-400',
      tab: 'announcements'
    }
  ];

  const liveRatio = stats.channelsCount > 0
    ? Math.round((stats.liveChannelsCount / stats.channelsCount) * 100)
    : 0;

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Welcome Banner */}
      <div className="relative overflow-hidden rounded-2xl border border-zinc-800/80 bg-gradient-to-br from-purple-900/30 via-zinc-900/80 to-zinc-900/40 backdrop-blur-xl">
        <div className="absolute -top-24 -right-24 w-96 h-96 bg-purple-500/10 rounded-full blur-3xl"></div>
        <div className="absolute -bottom-24 left-1/3 w-72 h-72 bg-pink-500/10 rounded-full blur-3xl"></div>

        <div className="relative z-10 p-6 sm:p-8 flex flex-col xl:flex-row xl:items-center xl:justify-between gap-6">
          <div className="space-y-3 max-w-3xl">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-300 text-xs font-medium">
              <Shield className="w-3.5 h-3.5" />
              Secure Admin Session
            </div>
            <h1 className="text-3xl sm:text-4xl font-bold tracking-tight text-white">
              GoPlay TV <span className="gradient-text">Management Console</span>
            </h1>
            <p className="text-zinc-400 leading-relaxed">
              Manage your categories, stream urls, sports match schedules, and client announcements. Changes update instantly across all connected mobile apps.
            </p>
            <div className="flex flex-wrap gap-2 pt-1">
              <Link
                href="/dashboard/channels"
                className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-purple-600 hover:bg-purple-700 text-white text-sm font-semibold transition-all shadow-lg shadow-purple-500/20 hover:scale-[1.02]"
              >
                <Plus className="w-4 h-4" />
                Add Channel
              </Link>
              <Link
                href="/dashboard/events"
                className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-900 hover:bg-zinc-800 border border-zinc-800 text-zinc-300 hover:text-white text-sm font-semibold transition-all"
              >
                <Calendar className="w-4 h-4 text-pink-400" />
                Schedule Match
              </Link>
            </div>
          </div>

          {/* Live health meter */}
          <div className="flex-shrink-0 w-full xl:w-72 p-5 rounded-2xl bg-zinc-950/60 border border-zinc-800/80 space-y-4">
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-zinc-400 flex items-center gap-1.5">
                <TrendingUp className="w-3.5 h-3.5 text-emerald-400" />
                Stream Health
              </span>
              <span className="text-xs font-bold text-emerald-400">{liveRatio}%</span>
            </div>
            <div className="h-2 rounded-full bg-zinc-800 overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-emerald-500 to-teal-400 rounded-full transition-all duration-500"
                style={{ width: `${liveRatio}%` }}
              ></div>
            </div>
            <div className="flex items-center justify-between text-[11px] text-zinc-500">
              <span>{stats.liveChannelsCount} live</span>
              <span>of {stats.channelsCount} total</span>
            </div>
          </div>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
        {cards.map((card) => {
          const Icon = card.icon;
          return (
            <Link
              key={card.title}
              href={`/dashboard/${card.tab}`}
              className="group p-5 rounded-2xl glass-panel cursor-pointer transition-all duration-300 hover:border-purple-500/40 hover:bg-zinc-900/80 relative overflow-hidden"
            >
              <div className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300 bg-gradient-to-br from-purple-500/5 to-transparent pointer-events-none"></div>

              <div className="relative flex items-center justify-between mb-4">
                <div className={`p-2.5 rounded-xl border ${card.iconBg} ${card.iconColor} group-hover:scale-110 transition-transform duration-300`}>
                  <Icon className="w-5 h-5" />
                </div>
                <ArrowUpRight className="w-4 h-4 text-zinc-700 group-hover:text-purple-400 group-hover:rotate-45 transition-all duration-300" />
              </div>

              <div className="relative space-y-1">
                <div className="text-3xl font-extrabold text-white tabular-nums">{card.value}</div>
                <span className="text-sm font-semibold text-zinc-200">{card.title}</span>
                <p className="text-xs text-zinc-500">{card.desc}</p>
              </div>
            </Link>
          );
        })}
      </div>

      {/* System Status & Quick Actions */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        {/* Status panel */}
        <div className="lg:col-span-2 p-6 rounded-2xl glass-panel space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="text-base font-bold text-white flex items-center gap-2">
              <Database className="w-5 h-5 text-purple-400" />
              Supabase Live Sync Status
            </h2>
            <span className="inline-flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-wider px-2 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-400">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-ping"></span>
              Online
            </span>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div className="p-4 rounded-xl bg-zinc-950/80 border border-zinc-800 space-y-1.5">
              <div className="flex items-center gap-1.5 text-xs text-zinc-500">
                <Database className="w-3 h-3" />
                Database Cluster URL
              </div>
              <p className="text-sm font-mono text-zinc-300 truncate">hqmhuvsjlykrdusfkmeg.supabase.co</p>
            </div>
            <div className="p-4 rounded-xl bg-zinc-950/80 border border-zinc-800 space-y-1.5">
              <div className="flex items-center gap-1.5 text-xs text-zinc-500">
                <Zap className="w-3 h-3" />
                Realtime WebSocket
              </div>
              <p className="text-sm font-semibold text-emerald-400 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-emerald-500 animate-ping"></span>
                Connected &amp; Active
              </p>
            </div>
          </div>

          <div className="p-4 rounded-xl bg-purple-950/20 border border-purple-900/30 text-purple-300/90 text-xs leading-relaxed">
            <strong className="text-purple-300">💡 Quick Note on Streaming:</strong> All HLS streams (`.m3u8`) can be proxy-routed by setting the `Proxy` toggle in the channels list. This will route requests through the CORS proxy server to prevent playback errors in the Flutter client.
          </div>
        </div>

        {/* Quick actions */}
        <div className="p-6 rounded-2xl glass-panel space-y-4">
          <h2 className="text-base font-bold text-white flex items-center gap-2">
            <Zap className="w-5 h-5 text-amber-400" />
            Quick Admin Actions
          </h2>
          <div className="space-y-2">
            <Link
              href="/dashboard/channels"
              className="group w-full p-3 rounded-xl bg-zinc-900/60 hover:bg-zinc-800 border border-zinc-800 hover:border-purple-500/30 text-left text-sm text-zinc-300 hover:text-white transition-all flex items-center justify-between"
            >
              <span className="flex items-center gap-2.5">
                <Tv className="w-4 h-4 text-blue-400" />
                Add New TV Channel
              </span>
              <ArrowRight className="w-3.5 h-3.5 text-zinc-600 group-hover:text-purple-400 group-hover:translate-x-0.5 transition-all" />
            </Link>
            <Link
              href="/dashboard/events"
              className="group w-full p-3 rounded-xl bg-zinc-900/60 hover:bg-zinc-800 border border-zinc-800 hover:border-purple-500/30 text-left text-sm text-zinc-300 hover:text-white transition-all flex items-center justify-between"
            >
              <span className="flex items-center gap-2.5">
                <Calendar className="w-4 h-4 text-pink-400" />
                Schedule Live Sport Match
              </span>
              <ArrowRight className="w-3.5 h-3.5 text-zinc-600 group-hover:text-purple-400 group-hover:translate-x-0.5 transition-all" />
            </Link>
            <Link
              href="/dashboard/announcements"
              className="group w-full p-3 rounded-xl bg-zinc-900/60 hover:bg-zinc-800 border border-zinc-800 hover:border-purple-500/30 text-left text-sm text-zinc-300 hover:text-white transition-all flex items-center justify-between"
            >
              <span className="flex items-center gap-2.5">
                <Bell className="w-4 h-4 text-amber-400" />
                Publish Global Announcement
              </span>
              <ArrowRight className="w-3.5 h-3.5 text-zinc-600 group-hover:text-purple-400 group-hover:translate-x-0.5 transition-all" />
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
