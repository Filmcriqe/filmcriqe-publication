'use client';

import Link from 'next/link';
import { AppearanceControls, ImageAssignments } from '@/components/personalization';
import { AdminContentManager } from '@/components/admin-content-manager';

const sections=['Overview','Reviews','Features','Essays','Hidden Gems','Homepage','Media','Newsletter','Review Requests','Site Settings'];

export default function Admin(){
  return <main className="admin"><aside><div className="brand">FILMCRIQE<span>Editorial desk</span></div><nav>{sections.map((x,index)=><a className={index===0?'active':''} href={`#${x.toLowerCase().replaceAll(' ','-')}`} key={x}>{x}</a>)}</nav><Link href="/">View publication →</Link></aside><section><header><div><div className="eyebrow">Private editorial dashboard</div><h1 className="display">Overview</h1></div><a className="button" href="#reviews">New story</a></header><div className="admin-stats"><Stat n="—" label="Published reviews"/><Stat n="—" label="Published articles"/><Stat n="—" label="Hidden gems"/><Stat n="—" label="Drafts"/></div><AppearanceControls/><ImageAssignments/><AdminContentManager/></section></main>
}
function Stat({n,label}:{n:string;label:string}){return <div><strong>{n}</strong><span>{label}</span></div>}
