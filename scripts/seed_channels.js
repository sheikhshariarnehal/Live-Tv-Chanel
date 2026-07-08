import fs from 'fs';
import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://evpdgmvzvjtmledjeyep.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2cGRnbXZ6dmp0bWxlZGpleWVwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI3MjA0MjAsImV4cCI6MjA5ODI5NjQyMH0.i2w2mbPMUc1hvU5pAfdSINQvE-tf-zgzAelNHXGXlgk';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function seed() {
  console.log('Reading channels.json...');
  const data = JSON.parse(fs.readFileSync('./public/assets/data/channels.json', 'utf8'));

  const channelsToInsert = [];
  const categories = data.categories;

  for (const catKey in categories) {
    const category = categories[catKey];
    console.log(`Processing category: ${category.name} (${catKey})`);
    
    if (category.channels) {
      category.channels.forEach(ch => {
        channelsToInsert.push({
          id: ch.id,
          name: ch.name,
          logo: ch.logo || null,
          category: catKey,
          country: ch.country || null,
          language: ch.language || null,
          is_live: ch.is_live !== undefined ? ch.is_live : true,
          is_trending: ch.is_trending !== undefined ? ch.is_trending : false,
          quality: ch.quality || 'HD',
          stream_url: ch.stream_url || null,
          url: ch.url || ch.stream_url || null,
          headers: ch.headers || {},
          sort_order: ch.sort_order || 0,
          proxy: ch.proxy !== undefined ? ch.proxy : false,
          drm: ch.drm || null
        });
      });
    }
  }

  console.log(`Total channels to insert: ${channelsToInsert.length}`);

  // Insert in batches of 50
  const batchSize = 50;
  for (let i = 0; i < channelsToInsert.length; i += batchSize) {
    const batch = channelsToInsert.slice(i, i + batchSize);
    console.log(`Inserting batch ${i / batchSize + 1} of ${Math.ceil(channelsToInsert.length / batchSize)}...`);
    const { error } = await supabase.from('channels').upsert(batch);
    if (error) {
      console.error('Error inserting batch:', error);
      process.exit(1);
    }
  }

  console.log('Seeding completed successfully!');
}

seed().catch(err => {
  console.error('Fatal error during seeding:', err);
  process.exit(1);
});
