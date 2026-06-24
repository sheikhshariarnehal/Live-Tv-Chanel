import { Metadata } from 'next';
import { getChannelsData, findChannelByIdOrSlug } from '@/services/channels';
import { getChannelSlug, slugify } from '@/utils/slugify';
import WatchPageClient from './WatchPageClient';
import { notFound } from 'next/navigation';

interface Props {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  const channel = findChannelByIdOrSlug(id);

  if (!channel) {
    return {
      title: 'Channel Not Found | Vibestream',
    };
  }

  const nameLower = channel.name.toLowerCase();
  const hasLiveWord =
    nameLower.endsWith('live') ||
    nameLower.includes(' live ') ||
    nameLower.includes(' live(') ||
    nameLower.includes(' live');

  let title = hasLiveWord
    ? `Watch ${channel.name} | Vibestream`
    : `Watch ${channel.name} Live | Vibestream`;
  let description = `Watch ${channel.name} live stream in HD quality. Access sports, movies, news, and entertainment with Vibestream player.`;
  let keywords = `Watch ${channel.name} Live, ${channel.name} Live Stream, ${channel.name} Online, watch live tv, iptv player, Vibestream`;

  if (channel.id === 'go-fifa-live') {
    title = `Watch Go FIFA Live Stream Free | Vibestream`;
    description = `Watch Go FIFA Live stream in HD quality online. Access free sports, football matches, and live events with Vibestream player, no registration required.`;
    keywords = `Go FIFA Live, Watch Go FIFA Live, Go FIFA Live Stream, FIFA Live Online, Watch FIFA matches free, sports live stream, Vibestream`;
  } else if (channel.id.includes('world-cup-2026') || channel.id === 'sports-world-cup-2026') {
    title = `FIFA World Cup 2026 Live Stream | Vibestream`;
    description = `Watch FIFA World Cup 2026 live stream on Vibestream. Enjoy HD sports streaming with no interruptions and no signup required.`;
    keywords = `FIFA World Cup 2026, FIFA World Cup live, watch World Cup 2026 online, free World Cup stream, live sports streaming, Vibestream`;
  } else if (channel.id === 'sports-cazetv') {
    title = `CazeTV Live - FIFA World Cup Football | Vibestream`;
    description = `Watch FIFA World Cup live on CazeTV with Vibestream. Enjoy HD sports streaming with no interruptions and no signup required.`;
    keywords = `CazeTV, watch CazeTV live, CazeTV live stream, FIFA World Cup, FIFA World Cup live, sports streaming, Vibestream`;
  } else if (channel.id === 'sports-beinsports') {
    title = `BeinSports Live - FIFA World Cup Football | Vibestream`;
    description = `Watch FIFA World Cup live on BeinSports with Vibestream. Enjoy HD sports streaming with no interruptions and no signup required.`;
    keywords = `BeinSports, watch BeinSports live, BeinSports live stream, FIFA World Cup, FIFA World Cup live, sports streaming, Vibestream`;
  }

  const ogImage = channel.logo || 'https://vibestream.app/assets/image/og-image.png';

  return {
    title,
    description,
    keywords,
    openGraph: {
      title,
      description,
      images: [
        {
          url: ogImage,
        },
      ],
    },
    twitter: {
      card: 'summary_large_image',
      title,
      description,
      images: [ogImage],
    },
  };
}

export default async function WatchPage({ params }: Props) {
  const { id } = await params;
  const channel = findChannelByIdOrSlug(id);

  if (!channel) {
    notFound();
  }

  const channelsData = getChannelsData();

  // Find the category key for the active channel
  let activeCategoryKey = Object.keys(channelsData.categories)[0];
  for (const catKey in channelsData.categories) {
    if (channelsData.categories[catKey].channels.some((c) => c.id === channel.id)) {
      activeCategoryKey = catKey;
      break;
    }
  }

  // Generate Schema.org structured data
  const pageUrl = `https://vibestream.app/watch/${channel.slug}`;
  const schema = {
    '@context': 'https://schema.org',
    '@graph': [
      {
        '@type': 'WebPage',
        '@id': `${pageUrl}#webpage`,
        url: pageUrl,
        name: channel.name,
        isPartOf: {
          '@type': 'WebSite',
          '@id': 'https://vibestream.app/#website',
          url: 'https://vibestream.app/',
          name: 'Vibestream',
        },
      },
      {
        '@type': 'BroadcastService',
        '@id': `${pageUrl}#broadcastservice`,
        name: channel.name,
        broadcastDisplayName: channel.name,
        videoFormat: 'HD',
        logo: channel.logo || 'https://vibestream.app/assets/logo.webp',
        url: pageUrl,
        provider: {
          '@type': 'Organization',
          name: 'Vibestream',
          url: 'https://vibestream.app/',
        },
      },
    ],
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
      />
      <WatchPageClient
        initialChannel={channel}
        channelsData={channelsData}
        initialCategoryKey={activeCategoryKey}
      />
    </>
  );
}
