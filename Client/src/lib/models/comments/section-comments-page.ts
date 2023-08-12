import type { Paginate } from "$lib/util/types";
import type { CommentVote } from "$lib/models/comments/comment-vote";
import type { SectionComment } from "$lib/models/comments/section-comment";

export interface SectionCommentsPage {
	page: Paginate<SectionComment>;
	votes: CommentVote[];
}
