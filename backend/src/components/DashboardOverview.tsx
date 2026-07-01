'use client';

import React from 'react';
import { Layers, Tv, Radio, Calendar, Bell, Shield, ArrowRight } from 'lucide-react';

interface OverviewProps {
  stats: {
    categoriesCount: number;
    channelsCount: number;
    liveChannelsCount: number;
    eventsCount: number;
    announcementsCount: number;
  };
  setActiveTab: (tab: string) => void;
}

export default function DashboardOverview({ stats, setActiveTab }: OverviewProps) {
  const cards = [
    {
      title: 'Categories',
      value: stats.categoriesCount,
      desc: 'Channel groupings',
      icon: Layers,
      color: 'from-violet-500/20 to-purple-500/20 border-violet-500/30',
      iconColor: 'text-violet-400',
      tab: 'categories'
    },
    {
      title: 'Channels',
      value: stats.channelsCount,
      desc: 'Total streaming channels',
      icon: Tv,
      color: 'from-blue-500/20 to-indigo-500/20 border-blue-500/30',
      iconColor: 'text-blue-400',
      tab: 'channels'
    },
    {
      title: 'Live Streams',
      value: stats.liveChannelsCount,
      desc: 'Active direct streams',
      icon: Radio,
      color: 'from-emerald-500/20 to-teal-500/20 border-emerald-500/30',
      iconColor: 'text-emerald-400',
      tab: 'channels'
    },
    {
      title: 'Sports Events',
      value: stats.eventsCount,
      desc: 'Live and upcoming matches',
      icon: Calendar,
      color: 'from-pink-500/20 to-rose-500/20 border-pink-500/30',
      iconColor: 'text-pink-400',
      tab: 'events'
    },
    {
      title: 'Announcements',
      value: stats.announcementsCount,
      desc: 'Broadcasts to mobile app',
      icon: Bell,
      color: 'from-amber-500/20 to-orange-500/20 border-amber-500/30',
      iconColor: 'text-amber-400',
      tab: 'announcements'
    }
  ];

  return (
    <div className="space-y-8 animate-fadeIn">
      {/* Welcome Banner */}
      <div className="p-8 rounded-2xl bg-gradient-to-r from-purple-900/40 via-zinc-900/60 to-zinc-900/40 border border-zinc-800/80 backdrop-blur-xl relative overflow-hidden">
        <div className="absolute top-0 right-0 w-96 h-96 bg-purple-500/10 rounded-full blur-3xl -mr-20 -mt-20"></div>
        <div className="relative z-10 space-y-2">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-purple-500/10 border border-purple-500/20 text-purple-300 text-xs font-medium">
            <Shield className="w-3.5 h-3.5" />
            Secure Admin Session
          </div>
          <h1 className="text-3xl font-bold tracking-tight text-white md:text-4xl">
            GoPlay TV <span className="gradient-text">Management Console</span>
          </h1>
          <p className="text-zinc-400 max-w-2xl">
            Manage your categories, stream urls, sports match schedules, and client announcements. Changes update instantly across all connected mobile apps.
          </p>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5">
        {cards.map((card) => {
          const Icon = card.icon;
          return (
            <div
              key={card.title}
              onClick={() => setActiveTab(card.tab)}
              className={`p-6 rounded-2xl bg-gradient-to-br ${card.color} border backdrop-blur-md cursor-pointer transition-all duration-300 hover:scale-[1.02] group hover:shadow-lg hover:shadow-purple-500/5`}
            >
              <div className="flex justify-between items-start">
                <div className="space-y-4">
                  <span className="text-zinc-400 text-sm font-medium">{card.title}</span>
                  <div className="text-3xl font-extrabold text-white">{card.value}</div>
                  <p className="text-xs text-zinc-500">{card.desc}</p>
                </div>
                <div className={`p-3 rounded-xl bg-zinc-900/80 border border-zinc-800 ${card.iconColor} group-hover:scale-110 transition-transform duration-300`}>
                  <Icon className="w-6 h-6" />
                </div>
              </div>
              <div className="mt-4 pt-4 border-t border-zinc-800/50 flex items-center justify-between text-xs text-purple-400 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <span>Manage {card.title.toLowerCase()}</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </div>
            </div>
          );
        })}
      </div>

      {/* System Status & Guides */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 p-6 rounded-2xl glass-panel space-y-4">
          <h2 className="text-lg font-bold text-white flex items-center gap-2">
            <Radio className="w-5 h-5 text-purple-400 animate-pulse" />
            Supabase Live Sync Status
          </h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div className="p-4 rounded-xl bg-zinc-950/80 border border-zinc-800 space-y-1">
              <span className="text-xs text-zinc-500">Database Cluster URL</span>
              <p className="text-sm font-mono text-zinc-300 truncate">https://hqmhuvsjlykrdusfkmeg.supabase.co</p>
            </div>
            <div className="p-4 rounded-xl bg-zinc-950/80 border border-zinc-800 space-y-1">
              <span className="text-xs text-zinc-500">Realtime WebSocket Connection</span>
              <p className="text-sm font-semibold text-emerald-400 flex items-center gap-2">
                <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-ping"></span>
                Connected & Active
              </p>
            </div>
          </div>
          <div className="p-4 rounded-xl bg-purple-950/20 border border-purple-900/30 text-purple-300/90 text-sm">
            💡 <strong>Quick Note on Streaming:</strong> All HLS streams (`.m3u8`) can be proxy-routed by setting the `Proxy` toggle in the channels list. This will route requests through the CORS proxy server to prevent playback errors in the Flutter client.
          </div>
        </div>

        <div className="p-6 rounded-2xl glass-panel space-y-4">
          <h2 className="text-lg font-bold text-white flex items-center gap-2">
            🚀 Quick Admin Actions
          </h2>
          <div className="space-y-3">
            <button
              onClick={() => setActiveTab('channels')}
              className="w-full p-3 rounded-xl bg-zinc-900 hover:bg-zinc-800 border border-zinc-800 text-left text-sm text-zinc-300 hover:text-white transition-all flex items-center justify-between"
            >
              <span>Add New TV Channel</span>
              <Tv className="w-4 h-4 text-purple-400" />
            </button>
            <button
              onClick={() => setActiveTab('events')}
              className="w-full p-3 rounded-xl bg-zinc-900 hover:bg-zinc-800 border border-zinc-800 text-left text-sm text-zinc-300 hover:text-white transition-all flex items-center justify-between"
            >
              <span>Schedule Live Sport Match</span>
              <Calendar className="w-4 h-4 text-purple-400" />
            </button>
            <button
              onClick={() => setActiveTab('announcements')}
              className="w-full p-3 rounded-xl bg-zinc-900 hover:bg-zinc-800 border border-zinc-800 text-left text-sm text-zinc-300 hover:text-white transition-all flex items-center justify-between"
            >
              <span>Publish Global Announcement</span>
              <Bell className="w-4 h-4 text-purple-400" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
