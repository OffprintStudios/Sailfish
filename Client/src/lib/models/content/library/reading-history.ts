import type { Work } from "../works";
import type { Vote } from './vote';

export interface ReadingHistory {
	readonly id: string;
	readonly profile: { readonly id: string };
	readonly work: Work;
	readonly viewedOn: Date;
	vote: Vote;
	sectionsRead: string[];
	bookmarked: { id: string };
	readonly voteChanged?: Date;
	isPublic: boolean;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}