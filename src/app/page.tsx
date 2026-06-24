import { redirect } from 'next/navigation';
import { getChannelsData } from '@/services/channels';

export const dynamic = 'force-dynamic';

export default async function Home() {
  const data = getChannelsData();
  const firstCategoryKey = Object.keys(data.categories)[0];
  const firstChannel = firstCategoryKey ? data.categories[firstCategoryKey].channels[0] : null;

  if (firstChannel) {
    redirect(`/watch/${firstChannel.slug}`);
  }

  // Fallback if no channels exist
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-black text-white">
      <h1 className="text-2xl font-bold">No channels available</h1>
      <p className="text-neutral-400 mt-2">Please add channels to public/assets/data/channels.json</p>
    </div>
  );
}
