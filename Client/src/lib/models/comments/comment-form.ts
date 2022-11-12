export interface CommentForm {
	readonly threadId: string;
	readonly body: string;
	readonly spoiler: boolean;
	readonly repliesTo: string[];
}