-- FILMCRIQE publication engine: new editorial types and metadata used by the CMS.
-- Apply in the Supabase SQL editor before publishing dashboard-created content.

alter type public.content_type add value if not exists 'news';
alter type public.content_type add value if not exists 'industry';
alter type public.content_type add value if not exists 'awards';
alter type public.content_type add value if not exists 'production';
alter type public.content_type add value if not exists 'hidden-gem';

alter table public.content
  add column if not exists category text,
  add column if not exists release_year integer,
  add column if not exists director text,
  add column if not exists cast_members text[] not null default '{}',
  add column if not exists genre text,
  add column if not exists is_featured boolean not null default false,
  add column if not exists scheduled_at timestamptz,
  add column if not exists reading_minutes integer,
  add column if not exists gallery jsonb not null default '[]'::jsonb,
  add column if not exists source_name text,
  add column if not exists source_url text;

create index if not exists content_featured_idx on public.content (is_featured, published_at desc)
  where status = 'published' and is_featured;
create index if not exists content_archive_idx on public.content (release_year, genre, published_at desc)
  where status = 'published';

-- Media records are private editorial metadata. Public image delivery is handled
-- by the intentionally-public editorial-media bucket; only admins can alter it.
create index if not exists media_created_at_idx on public.media (created_at desc);
