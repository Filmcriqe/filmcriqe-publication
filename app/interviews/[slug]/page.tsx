import { Article } from '@/components/article';
export default async function Interview({params}:{params:Promise<{slug:string}>}){return <Article slug={(await params).slug} type="interview"/>}
