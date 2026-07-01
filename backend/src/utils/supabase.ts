import { createClient, SupabaseClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

/**
 * Creates a standard Supabase client.
 */
export const supabase = createClient(supabaseUrl, supabaseAnonKey);

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
