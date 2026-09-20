-- Extends FILMCRIQE's existing model without replacing editorial content.
alter type public.content_type add value if not exists 'interview';

alter table public.media
  add column if not exists caption text,
  add column if not exists credit text,
  add column if not exists fit text not null default 'cover' check (fit in ('cover','contain')),
  add column if not exists aspect_ratio text,
  add column if not exists sort_order integer not null default 0;

-- These are intentionally narrow public-write policies: the admin remains the
-- only role permitted to read, export, archive, or alter submitted records.
create policy "public newsletter signup" on public.newsletter_subscribers
  for insert to anon, authenticated with check (email = lower(email) and length(email) <= 320);
create policy "public review request submission" on public.review_requests
  for insert to anon, authenticated with check (length(name) between 1 and 120 and length(email) <= 320 and length(movie) between 1 and 250 and length(message) between 1 and 6000);
