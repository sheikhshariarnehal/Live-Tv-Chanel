import rawChannelsData from '../data/channels.json';
import { ChannelsData, Channel } from '../types';
import { getChannelSlug } from '../utils/slugify';

export function getRawChannelsData() {
  return rawChannelsData;
}

export function getChannelsData(): ChannelsData {
  const categories: Record<string, { name: string; channels: Channel[] }> = {};
  
  const rawCategories = (rawChannelsData as any).categories;
  for (const catKey in rawCategories) {
    const rawCategory = rawCategories[catKey];
    const channels: Channel[] = (rawCategory.channels || []).map((ch: any) => {
      const isDrm = !!ch.drm;
      const url = ch.url || '';
      
      let type: "hls" | "dash" | "mpegts" = "hls";
      if (url.endsWith('.mpd') || url.includes('.mpd?') || isDrm) {
        type = "dash";
      } else if (url.endsWith('.ts') || url.includes('.ts?')) {
        type = "mpegts";
      }

      return {
        id: ch.id,
        name: ch.name,
        slug: getChannelSlug(ch),
        logo: ch.logo || '',
        category: catKey,
        streamUrl: url,
        fallbackUrl: ch.fallbackUrl,
        type,
        drm: isDrm,
        drmConfig: ch.drm,
        resolution: ch.resolution,
        proxy: ch.proxy,
        noProxy: ch.noProxy,
        seo: ch.seo,
      };
    });
    
    categories[catKey] = {
      name: rawCategory.name,
      channels,
    };
  }
  
  return { categories };
}

export function getAllChannels(): Channel[] {
  const data = getChannelsData();
  const channels: Channel[] = [];
  for (const catKey in data.categories) {
    channels.push(...data.categories[catKey].channels);
  }
  return channels;
}

export function findChannelByIdOrSlug(idOrSlug: string): Channel | null {
  const channels = getAllChannels();
  return channels.find(c => c.id === idOrSlug || c.slug === idOrSlug) || null;
}
