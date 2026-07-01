import { createClient, SupabaseClient } from '@supabase/supabase-js';

/**
 * Reads the public Supabase config at call time so the module can be imported
 * during build/prerender without instantiating a client (which would throw if
 * the env vars are not yet present).
 */
const getSupabaseConfig = () => ({
  supabaseUrl: process.env.NEXT_PUBLIC_SUPABASE_URL || '',
  supabaseAnonKey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '',
});

let cachedAdminClient: SupabaseClient | null = null;
let cachedToken: string = '';

/**
 * Creates or retrieves a memoized admin-authenticated Supabase client that includes the x-admin-token header.
 * @param adminToken The admin secret token to authenticate write operations
 */
export const createAdminSupabaseClient = (adminToken: string) => {
  if (cachedAdminClient && cachedToken === adminToken) {
    return cachedAdminClient;
  }

  const { supabaseUrl, supabaseAnonKey } = getSupabaseConfig();

  cachedToken = adminToken;
  cachedAdminClient = createClient(supabaseUrl, supabaseAnonKey, {
    global: {
      headers: {
        'x-admin-token': adminToken,
      },
    },
  });

  return cachedAdminClient;
};
