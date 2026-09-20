import { byType } from '@/lib/content'; import { Archive } from '@/components/archive';
export default function Reviews(){return <Archive title="Reviews" intro="Close looking, clear thinking, and a record of what remains after the lights rise." items={byType('review')} filters/>}
