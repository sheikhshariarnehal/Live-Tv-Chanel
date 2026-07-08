import { defineConfig } from 'astro/config';
import node from '@astrojs/node';

export default defineConfig({
  output: 'server',
  adapter: node({
    mode: 'standalone'
  }),
  security: {
    checkOrigin: false
  },
  server: {
    host: true,
    port: Number(process.env.PORT) || 3000
  }
});



