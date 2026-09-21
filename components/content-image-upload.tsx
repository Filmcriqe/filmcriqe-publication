'use client';

import { ChangeEvent, useState } from 'react';
import { supabaseBrowser as db } from '@/lib/supabase-browser';

export function ContentImageUpload({onUploaded}:{onUploaded:(url:string)=>void}){
  const [message,setMessage]=useState('');
  async function upload(event:ChangeEvent<HTMLInputElement>){
    const file=event.target.files?.[0];
    if(!file||!db)return;
    if(!['image/jpeg','image/png','image/webp','image/avif'].includes(file.type)){setMessage('Choose a JPG, PNG, WebP, or AVIF image.');return}
    if(file.size>10_000_000){setMessage('Choose an image smaller than 10 MB.');return}
    setMessage('Uploading image…');
    const safe=file.name.replace(/[^a-z0-9.-]/gi,'-').toLowerCase();
    const path=`stories/${Date.now()}-${safe}`;
    const {error}=await db.storage.from('editorial-media').upload(path,file,{contentType:file.type,upsert:false});
    if(error){setMessage(`Upload failed: ${error.message}`);return}
    const url=db.storage.from('editorial-media').getPublicUrl(path).data.publicUrl;
    const {error:mediaError}=await db.from('media').insert({path,alt_text:''});
    if(mediaError){setMessage(`Image uploaded, but media details could not be saved: ${mediaError.message}`);onUploaded(url);return}
    onUploaded(url);setMessage('Image uploaded and selected for this story.');
  }
  return <div className="form-field full"><label htmlFor="story-image-upload">Upload hero image</label><input id="story-image-upload" type="file" accept="image/jpeg,image/png,image/webp,image/avif" onChange={upload}/>{message&&<small role="status">{message}</small>}</div>
}
