'use client';

import { useState } from 'react';

export function ShareButton(){
  const [message,setMessage]=useState('Share');
  async function share(){
    const details={title:document.title,url:window.location.href};
    try { if(navigator.share) await navigator.share(details); else { await navigator.clipboard.writeText(details.url); setMessage('Link copied'); window.setTimeout(()=>setMessage('Share'),1800); } } catch { /* Closing the native share sheet is not an error. */ }
  }
  return <button type="button" onClick={share} aria-label="Share this article">{message}</button>;
}
