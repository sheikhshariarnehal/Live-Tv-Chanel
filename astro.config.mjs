import { defineConfig } from 'astro/config';
import vercel from '@astrojs/vercel';

export default defineConfig({
  output: 'server',
  adapter: vercel(),
  vite: {
    ssr: {
      noExternal: ['@vercel/routing-utils']
    }
  }
});

