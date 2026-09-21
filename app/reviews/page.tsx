import { Archive } from '@/components/archive'; import { publishedByType } from '@/lib/publication-data';
export default async function Reviews(){return <Archive title="Reviews" intro="Close looking, clear thinking, and a record of what remains after the lights rise." items={await publishedByType('review')} filters/>}
