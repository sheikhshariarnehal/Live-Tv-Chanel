import { redirect } from 'next/navigation';

// /dashboard has no content of its own — send users to the overview.
export default function DashboardIndex() {
  redirect('/dashboard/overview');
}
