import { Archive } from '@/components/archive'; import { byType } from '@/lib/content';
export default function Interviews(){return <Archive title="Interviews" intro="Conversations with filmmakers and artists about the work behind the work." items={byType('interview')}/>}
