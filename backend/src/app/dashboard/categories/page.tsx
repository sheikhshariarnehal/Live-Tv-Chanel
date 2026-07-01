'use client';

import CategoryManager from '../../../components/CategoryManager';
import { useAuth } from '../../../providers/auth-provider';

export default function CategoriesPage() {
  const { adminToken, refreshStats } = useAuth();
  return <CategoryManager adminToken={adminToken} onRefreshStats={refreshStats} />;
}
