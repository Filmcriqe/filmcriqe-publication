import { Archive } from '@/components/archive'; import { publishedByType } from '@/lib/publication-data';
export default async function Interviews(){return <Archive title="Interviews" intro="Conversations with filmmakers and artists about the work behind the work." items={await publishedByType('interview')}/>}
