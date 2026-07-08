import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn('Supabase URL or Anon Key is missing. Ensure PUBLIC_SUPABASE_URL and PUBLIC_SUPABASE_ANON_KEY are set in your environment.');
}

export const supabase = (supabaseUrl && supabaseAnonKey)
  ? createClient(supabaseUrl, supabaseAnonKey)
  : null;

export async function getChannelsData() {
  if (!supabase) {
    console.warn('Supabase client not initialized — skipping data fetch.');
    return { categories: {} };
  }

  const { data: categories, error: catError } = await supabase
    .from('channel_categories')
    .select('*')
    .order('sort_order', { ascending: true });

  const { data: channels, error: chanError } = await supabase
    .from('channels')
    .select('*')
    .order('sort_order', { ascending: true });

  if (catError || chanError) {
    console.error('Error fetching channels/categories:', catError || chanError);
    return { categories: {} };
  }

  const categoriesMap = {};
  categories.forEach(cat => {
    categoriesMap[cat.key] = {
      name: cat.name,
      channels: []
    };
  });

  channels.forEach(ch => {
    const catKey = ch.category;
    if (categoriesMap[catKey]) {
      categoriesMap[catKey].channels.push({
        id: ch.id,
        name: ch.name,
        logo: ch.logo,
        category: ch.category,
        country: ch.country,
        language: ch.language,
        is_live: ch.is_live,
        is_trending: ch.is_trending,
        quality: ch.quality,
        stream_url: ch.stream_url,
        url: ch.url,
        headers: ch.headers,
        sort_order: ch.sort_order,
        proxy: ch.proxy,
        drm: ch.drm
      });
    }
  });

  return { categories: categoriesMap };
}

