import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import SecurityProvider from '@/components/SecurityProvider';
import './globals.css';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  weight: ['400', '500', '600', '700', '800'],
});

export const viewport = {
  themeColor: '#0a0a0a',
};

export const metadata: Metadata = {
  title: 'Vibestream - Watch Live TV & IPTV Channels | HD Stream Player',
  description:
    'Stream your favorite live TV channels, sports, news, and entertainment in HD quality with Vibestream. A fast, modern, and professional web-based IPTV player.',
  keywords:
    'Vibestream, vibestream tv, live tv, online tv, free iptv, iptv player, watch live tv, live stream tv, bdix tv, streaming player',
  authors: [{ name: 'Vibestream' }],
  robots: 'index, follow',
  openGraph: {
    type: 'website',
    siteName: 'Vibestream',
    images: [
      {
        url: 'https://vibestream.app/assets/image/og-image.png',
        width: 1200,
        height: 630,
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    images: ['https://vibestream.app/assets/image/og-image.png'],
  },
  icons: {
    icon: '/assets/logo.webp',
    apple: '/assets/logo.webp',
  },
  manifest: '/manifest.json',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={inter.className} suppressHydrationWarning>
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link rel="dns-prefetch" href="https://cdn.jsdelivr.net" />
        <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com" />
        <script
          defer
          src="https://umami.ntechbd.app/script.js"
          data-website-id="33997810-5e40-4042-840a-f84fff1cc9ce"
        />
      </head>
      <body>
        <SecurityProvider />
        {children}
      </body>
    </html>
  );
}
