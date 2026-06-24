import { Metadata } from 'next';
import wcData from '@/data/worldcup-2026.json';
import UpcomingPageClient from './UpcomingPageClient';

export const metadata: Metadata = {
  title: 'FIFA World Cup 2026™ Schedule — Match Times in Bangladesh (BD) Time | Vibestream',
  description: 'Full FIFA World Cup 2026™ match schedule with live countdown timers to every fixture. All kick-off times shown in Bangladesh Standard Time (BST / UTC+6).',
};

export default async function UpcomingPage() {
  const matches = wcData.matches;
  return (
    <UpcomingPageClient matches={matches} />
  );
}
