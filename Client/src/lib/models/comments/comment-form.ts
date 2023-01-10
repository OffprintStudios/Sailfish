export interface CommentForm {
	readonly itemId: string;
	readonly body: string;
	readonly spoiler: boolean;
	readonly repliesTo: string[];
	readonly sectionId?: string;
	readonly locationUrl: string;
}
