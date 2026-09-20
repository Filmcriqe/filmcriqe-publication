create extension if not exists pgcrypto;

create type public.content_status as enum ('draft', 'published', 'archived');
create type public.content_type as enum ('review', 'feature', 'essay');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'editor' check (role in ('editor','admin')),
  display_name text,
  created_at timestamptz not null default now()
);
create table public.content (
  id uuid primary key default gen_random_uuid(), type public.content_type not null,
  status public.content_status not null default 'draft', slug text not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  title text not null, dek text, author_id uuid references public.profiles(id),
  published_at timestamptz, updated_at timestamptz not null default now(),
  hero_path text, hero_alt text, body jsonb not null default '[]'::jsonb,
  seo_title text, seo_description text, tags text[] not null default '{}',
  review_meta jsonb, is_hidden_gem boolean not null default false
);
create table public.media (
  id uuid primary key default gen_random_uuid(), path text not null unique, alt_text text not null default '', focal_x numeric(4,3), focal_y numeric(4,3), created_by uuid references public.profiles(id), created_at timestamptz not null default now()
);
create table public.site_settings (
  key text primary key, value jsonb not null, updated_at timestamptz not null default now()
);
create table public.newsletter_subscribers (
  id uuid primary key default gen_random_uuid(), email text not null unique check (email = lower(email)), subscribed_at timestamptz not null default now(), source text not null default 'site', confirmed_at timestamptz, unsubscribed_at timestamptz
);
create table public.review_requests (
  id uuid primary key default gen_random_uuid(), name text not null, email text not null, movie text not null, message text not null, social_handle text, state text not null default 'unread' check (state in ('unread','read','archived')), created_at timestamptz not null default now()
);

create index content_published_idx on public.content (type, published_at desc) where status = 'published';
create index content_hidden_gem_idx on public.content (published_at desc) where is_hidden_gem and status = 'published';

create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = (select auth.uid()) and role = 'admin');
$$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

alter table public.profiles enable row level security;
alter table public.content enable row level security;
alter table public.media enable row level security;
alter table public.site_settings enable row level security;
alter table public.newsletter_subscribers enable row level security;
alter table public.review_requests enable row level security;
revoke all on all tables in schema public from anon, authenticated;
grant select on public.content, public.site_settings to anon, authenticated;
grant select, insert, update, delete on public.content, public.media, public.site_settings, public.newsletter_subscribers, public.review_requests to authenticated;
grant select, insert, update on public.profiles to authenticated;

create policy "published content is public" on public.content for select to anon, authenticated using (status = 'published' or (select public.is_admin()));
create policy "admins manage content" on public.content for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
create policy "site settings are public" on public.site_settings for select to anon, authenticated using (true);
create policy "admins manage site settings" on public.site_settings for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
create policy "admins manage media metadata" on public.media for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
create policy "admins manage profiles" on public.profiles for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
create policy "admins manage subscribers" on public.newsletter_subscribers for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
create policy "admins manage review requests" on public.review_requests for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('editorial-media','editorial-media',true,10485760,array['image/jpeg','image/png','image/webp','image/avif'])
on conflict (id) do nothing;
create policy "public reads editorial media" on storage.objects for select to anon, authenticated using (bucket_id = 'editorial-media');
create policy "admins manage editorial media" on storage.objects for all to authenticated using (bucket_id = 'editorial-media' and (select public.is_admin())) with check (bucket_id = 'editorial-media' and (select public.is_admin()));

insert into public.site_settings(key,value) values
('appearance','{"site_title":"FILMCRIQE","tagline":"EVERY FRAME COUNTS.","accent":"#E3262E","background":"#050505","text":"#F2F2F2","border":"#333333"}'),
('homepage','{"latest_count":6,"manifesto":"Good films don’t just tell stories. They change the way we see the world."}'),
('social','{}') on conflict (key) do nothing;
