export interface CommentVote {
	readonly id: string;
	readonly profile: { readonly id: string };
	readonly comment: { readonly id: string };
	readonly rating: "liked" | "disliked";
	readonly createdAt: Date;
	readonly updatedAt: Date;
}
