export interface CommentHistory {
	readonly id: string;
	readonly comment: { readonly id: string };
	readonly oldBody: string;
	readonly createdAt: Date;
}