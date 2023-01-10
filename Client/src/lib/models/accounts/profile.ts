import type { Presence } from "./presence";
import type { Roles } from "./roles";

export interface Profile {
	readonly id: string;
	readonly account: { id: string; roles: Roles[] };
	username: string;
	avatar: string;
	bannerArt?: string;
	info: {
		bio?: string;
		tagline?: string;
		presence: Presence;
	};
	stats: {
		works: number;
		blogs: number;
		followers: number;
		following: number;
	};
	links: Map<string, string>;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}
