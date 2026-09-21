'use client';

import { CSSProperties, useEffect, useState } from 'react';
import { createClient } from '@supabase/supabase-js';

const url=process.env.NEXT_PUBLIC_SUPABASE_URL;
const key=process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const db=url&&key?createClient(url,key):null;

export function EditorialImageSlot({slot,label='Add photograph',className='',src,alt,focalPoint='center'}:{slot:string;label?:string;className?:string;src?:string;alt?:string;focalPoint?:string}){
  const [managed,setManaged]=useState<Record<string,string>>({});
  useEffect(()=>{let active=true;db?.from('site_settings').select('value').eq('key','image_assignments').maybeSingle().then(({data})=>{if(active&&data?.value)setManaged(data.value as Record<string,string>)});return()=>{active=false}},[]);
  const image=managed[slot]||src;
  const style=image?{backgroundImage:`url(${image})`,backgroundPosition:focalPoint} as CSSProperties:undefined;
  return <div className={`image-slot ${className} ${image?'has-image':''}`} role="img" aria-label={alt||label} style={style}>{!image&&<span><b>Image</b><small>{label}</small></span>}</div>
}
