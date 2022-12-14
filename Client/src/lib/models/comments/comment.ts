import type { Profile } from "../accounts";
import type { CommentHistory } from "./comment-history";

export interface Comment {
	readonly id: string;
	readonly profile: Profile;
	body: string;
	spoiler: boolean;
	readonly section: { id: string };
	readonly replies: { id: string }[];
	readonly repliedTo: { id: string }[];
	readonly history: CommentHistory[];
	readonly createdAt: Date;
	readonly updatedAt: Date;
}
