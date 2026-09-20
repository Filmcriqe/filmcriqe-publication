import type { Metadata } from 'next';
import './globals.css';
import './appearance-overrides.css';
import { Header, Footer } from '@/components/chrome';
import { SitePersonalizer } from '@/components/personalization';

export const metadata: Metadata = { title: { default: 'FILMCRIQE — Every Frame Counts.', template: '%s — FILMCRIQE' }, description: 'Independent film criticism and editorial.', metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL || 'https://filmcriqe.com'), robots: { index: true, follow: true } };
export default function RootLayout({ children }: { children: React.ReactNode }) { return <html lang="en"><body><SitePersonalizer /><Header />{children}<Footer /></body></html>; }
