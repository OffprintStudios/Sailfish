import type { Presence, Roles } from "$lib/models/accounts";

export interface NewComment {
	readonly id: string;
	readonly comment: { readonly id: string };
	readonly profile: {
		readonly id: string;
		readonly name: string;
		readonly avatar: string;
		readonly banner?: string;
		readonly roles: Roles[];
		readonly info: {
			readonly bio?: string;
			readonly tagline?: string;
			readonly presence: Presence;
		};
		readonly stats: {
			readonly works: number;
			readonly blogs: number;
			readonly followers: number;
			readonly following: number;
		};
	};
	readonly body: string;
	readonly spoiler: string;
	likes: number;
	dislikes: number;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}
