# FILMCRIQE

An editorial publication built with Next.js App Router. It renders from a small local editorial fixture until Supabase is configured, then content, media, newsletter signups, requests, and authentication can move behind the same repository interface.

## Run

`npm install` then `npm run dev`.

Copy `.env.example` to `.env.local` for deployment configuration. Never expose `SUPABASE_SERVICE_ROLE_KEY` to the browser.

## Production data boundary

Create Supabase tables for `reviews`, `articles`, `site_settings`, `media`, `newsletter_subscribers`, and `review_requests`; store editorial images in a private `media` bucket and issue optimized public URLs only for published assets. Restrict all editorial tables to authenticated admin users with RLS. The UI deliberately shows neutral upload placeholders rather than unlicensed or AI-generated photography.
