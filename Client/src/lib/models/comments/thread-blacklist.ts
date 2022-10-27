import type { Profile } from "../accounts";

export interface ThreadBlacklist {
	readonly id: string;
	readonly thread: { readonly id: string };
	readonly profile: Profile;
	readonly reason: string;
	readonly createdAt: Date;
}