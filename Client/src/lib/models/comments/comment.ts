import type { Profile } from "../accounts";

export interface Comment {
	readonly id: string;
	readonly thread: { id: string };
	readonly profile: Profile;
	body: string;
	readonly createdAt: Date;
	readonly updatedAt: Date;
}