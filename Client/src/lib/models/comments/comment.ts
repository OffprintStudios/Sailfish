import type { Profile } from "../accounts";
import type { CommentHistory } from "./comment-history";

export interface Comment {
	readonly id: string;
	readonly thread: { id: string };
	readonly profile: Profile;
	body: string;
	spoiler: boolean;
	readonly history: CommentHistory[];
	readonly createdAt: Date;
	readonly updatedAt: Date;
}