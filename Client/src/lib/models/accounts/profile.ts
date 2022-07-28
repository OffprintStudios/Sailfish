import type { Pronouns } from "./pronouns";
import type { Presence } from "./presence";

export interface Profile {
	readonly id: string;
	readonly account: string;
	username: string;
	avatar: string;
	info: {
		bio?: string;
		tagline?: string;
		coverPic?: string;
		pronouns: Pronouns[];
		presence: Presence;
	};
	stats: {
		works: number;
		blogs: number;
		followers: number;
		following: number;
	};
	readonly createdAt: Date;
	readonly updatedAt: Date;
}