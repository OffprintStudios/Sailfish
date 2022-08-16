import type { Profile } from "../../accounts";
import type { ContentRating } from "../content-rating";
import type { ApprovalStatus } from "../approval-status";

export interface Blog {
	readonly id: string;
	readonly author: Profile;
	title: string;
	desc?: string;
	body: string;
	rating: ContentRating;
	stats: {
		words: number;
		views: number;
		comments: number;
	}
	status: ApprovalStatus;
	publishedOn?: Date;
	readonly createdAt: Date;
	readonly updatedAt: Date;
	readonly deletedAt: Date;
}