export interface DRMCredentials {
  kid: string;
  key: string;
}

export interface SEOData {
  title?: string;
  description?: string;
  keywords?: string;
  image?: string;
}

export interface Channel {
  id: string;
  name: string;
  slug: string;
  logo: string;
  category: string;
  streamUrl: string;
  fallbackUrl?: string;
  type: "hls" | "dash" | "mpegts";
  drm?: boolean;
  drmConfig?: DRMCredentials;
  resolution?: string;
  proxy?: boolean;
  noProxy?: boolean;
  seo?: SEOData;
}

export interface Category {
  id: string;
  name: string;
  channels: Channel[];
}

export interface ChannelsData {
  categories: Record<string, {
    name: string;
    channels: Channel[];
  }>;
}

export interface NewsArticle {
  title: string;
  url: string;
}

export interface MatchSchedule {
  id: string;
  team1: { name: string; flag: string };
  team2: { name: string; flag: string };
  time: string;
  date: string;
  timestamp: number;
  stage: string;
  channelId?: string;
}
