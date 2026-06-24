import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface UserPreferences {
  volume: number;
  muted: boolean;
  theme: 'dark' | 'light';
  quality: string;
}

interface AppState {
  favorites: string[];
  recentlyWatched: string[];
  preferences: UserPreferences;
  
  toggleFavorite: (channelId: string) => void;
  addRecentlyWatched: (channelId: string) => void;
  setPreferences: (prefs: Partial<UserPreferences>) => void;
}

export const useAppStore = create<AppState>()(
  persist(
    (set) => ({
      favorites: [],
      recentlyWatched: [],
      preferences: {
        volume: 0.8,
        muted: false,
        theme: 'dark',
        quality: 'Auto',
      },
      toggleFavorite: (channelId) => set((state) => {
        const isFav = state.favorites.includes(channelId);
        return {
          favorites: isFav 
            ? state.favorites.filter((id) => id !== channelId)
            : [...state.favorites, channelId]
        };
      }),
      addRecentlyWatched: (channelId) => set((state) => {
        const filtered = state.recentlyWatched.filter((id) => id !== channelId);
        return {
          recentlyWatched: [channelId, ...filtered].slice(0, 12)
        };
      }),
      setPreferences: (prefs) => set((state) => ({
        preferences: { ...state.preferences, ...prefs }
      })),
    }),
    {
      name: 'vibestream-store',
    }
  )
);
