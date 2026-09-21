'use client';

import { createClient } from '@supabase/supabase-js';

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

// One browser client keeps the auth session and Storage requests in sync.
// The public key is safe to expose because every table and bucket is protected
// with Row Level Security policies in the accompanying migrations.
export const supabaseBrowser = url && key ? createClient(url, key) : null;

export function isSupabaseConfigured() {
  return Boolean(supabaseBrowser);
}
